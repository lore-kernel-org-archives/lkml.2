Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab0G2NDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 09:03:18 -0400
Received: from mtagate4.de.ibm.com ([195.212.17.164]:35829 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab0G2NDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 09:03:16 -0400
Date: Thu, 29 Jul 2010 15:03:09 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.35-rc6
Message-ID: <20100729150309.4b2ea955@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Heiko Carstens (1):
      [S390] Fix IRQ tracing in case of PER

Martin Schwidefsky (1):
      [S390] etr: fix clock synchronization race

 arch/s390/kernel/entry.S   |   12 ++++++++++--
 arch/s390/kernel/entry64.S |   12 ++++++++++--
 arch/s390/kernel/time.c    |   18 ++++++++++++------
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index d5e3e60..bea9ee3 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -535,8 +535,16 @@ pgm_no_vtime2:
 	l	%r3,__LC_PGM_ILC	# load program interruption code
 	la	%r8,0x7f
 	nr	%r8,%r3 		# clear per-event-bit and ilc
-	be	BASED(pgm_exit)		# only per or per+check ?
-	b	BASED(pgm_do_call)
+	be	BASED(pgm_exit2)	# only per or per+check ?
+	l	%r7,BASED(.Ljump_table)
+	sll	%r8,2
+	l	%r7,0(%r8,%r7)		# load address of handler routine
+	la	%r2,SP_PTREGS(%r15)	# address of register-save area
+	basr	%r14,%r7		# branch to interrupt-handler
+pgm_exit2:
+	TRACE_IRQS_ON
+	stosm	__SF_EMPTY(%r15),0x03	# reenable interrupts
+	b	BASED(sysc_return)
 
 #
 # it was a single stepped SVC that is causing all the trouble
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index e7192e1..8bccec1 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -544,8 +544,16 @@ pgm_no_vtime2:
 	lgf	%r3,__LC_PGM_ILC	# load program interruption code
 	lghi	%r8,0x7f
 	ngr	%r8,%r3			# clear per-event-bit and ilc
-	je	pgm_exit
-	j	pgm_do_call
+	je	pgm_exit2
+	sll	%r8,3
+	larl	%r1,pgm_check_table
+	lg	%r1,0(%r8,%r1)		# load address of handler routine
+	la	%r2,SP_PTREGS(%r15)	# address of register-save area
+	basr	%r14,%r1		# branch to interrupt-handler
+pgm_exit2:
+	TRACE_IRQS_ON
+	stosm	__SF_EMPTY(%r15),0x03	# reenable interrupts
+	j	sysc_return
 
 #
 # it was a single stepped SVC that is causing all the trouble
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index a2163c9..15a7536 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -524,8 +524,11 @@ void etr_switch_to_local(void)
 	if (!etr_eacr.sl)
 		return;
 	disable_sync_clock(NULL);
-	set_bit(ETR_EVENT_SWITCH_LOCAL, &etr_events);
-	queue_work(time_sync_wq, &etr_work);
+	if (!test_and_set_bit(ETR_EVENT_SWITCH_LOCAL, &etr_events)) {
+		etr_eacr.es = etr_eacr.sl = 0;
+		etr_setr(&etr_eacr);
+		queue_work(time_sync_wq, &etr_work);
+	}
 }
 
 /*
@@ -539,8 +542,11 @@ void etr_sync_check(void)
 	if (!etr_eacr.es)
 		return;
 	disable_sync_clock(NULL);
-	set_bit(ETR_EVENT_SYNC_CHECK, &etr_events);
-	queue_work(time_sync_wq, &etr_work);
+	if (!test_and_set_bit(ETR_EVENT_SYNC_CHECK, &etr_events)) {
+		etr_eacr.es = 0;
+		etr_setr(&etr_eacr);
+		queue_work(time_sync_wq, &etr_work);
+	}
 }
 
 /*
@@ -902,7 +908,7 @@ static struct etr_eacr etr_handle_update(struct etr_aib *aib,
 	 * Do not try to get the alternate port aib if the clock
 	 * is not in sync yet.
 	 */
-	if (!check_sync_clock())
+	if (!eacr.es || !check_sync_clock())
 		return eacr;
 
 	/*
@@ -1064,7 +1070,7 @@ static void etr_work_fn(struct work_struct *work)
 	 * If the clock is in sync just update the eacr and return.
 	 * If there is no valid sync port wait for a port update.
 	 */
-	if (check_sync_clock() || sync_port < 0) {
+	if ((eacr.es && check_sync_clock()) || sync_port < 0) {
 		etr_update_eacr(eacr);
 		etr_set_tolec_timeout(now);
 		goto out_unlock;
