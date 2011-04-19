Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1DSGeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:34:15 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:50478 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1DSGeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:34:13 -0400
Date: Tue, 19 Apr 2011 08:34:01 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-s390@vger.kernel.org, Stephen Powell <zlinuxman@wowway.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [OOPS s390] Unable to handle kernel pointer dereference at
 virtual kernel address (null)
Message-ID: <20110419063400.GA2878@osiris.boeblingen.de.ibm.com>
References: <2099315211.286690.1302917498637.JavaMail.root@md01.wow.synacor.com>
 <20110416014811.GA6150@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110416014811.GA6150@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 08:48:40PM -0500, Jonathan Nieder wrote:
> > I installed linux-image-2.6.38-2-s390x version 2.6.38-3 on my up-to-date Wheezy
> > system today.  It runs in a virtual machine under z/VM 5.4.0 running in an LPAR
> > on an IBM z/890.  It IPLed just fine.  After the IPL, the system fell idle for a while.
> > Then a CRON job kicked off, which caused a page fault, which caused a kernel oops.
> > Here is the log:

Ok, I was able to reproduce it and could verify that my patch fixes the bug.
Thanks for reporting! The patch below will go upstream:

Subject: [S390] pfault: fix token handling

From: Heiko Carstens <heiko.carstens@de.ibm.com>

f6649a7e "[S390] cleanup lowcore access from external interrupts" changed
handling of external interrupts. Instead of letting the external interrupt
handlers accessing the per cpu lowcore the entry code of the kernel reads
already all fields that are necessary and passes them to the handlers.
The pfault interrupt handler was incorrectly converted. It tries to
dereference a value which used to be a pointer to a lowcore field. After
the conversion however it is not anymore the pointer to the field but its
content. So instead of a dereference only a cast is needed to get the
task pointer that caused the pfault.

Fixes a NULL pointer dereference and a subsequent kernel crash:

Unable to handle kernel pointer dereference at virtual kernel address (null)
Oops: 0004 [#1] SMP
Modules linked in: nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc
                   loop qeth_l3 qeth vmur ccwgroup ext3 jbd mbcache dm_mod
                   dasd_eckd_mod dasd_diag_mod dasd_mod
CPU: 0 Not tainted 2.6.38-2-s390x #1
Process cron (pid: 1106, task: 000000001f962f78, ksp: 000000001fa0f9d0)
Krnl PSW : 0404200180000000 000000000002c03e (pfault_interrupt+0xa2/0x138)
           R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
Krnl GPRS: 0000000000000000 0000000000000001 0000000000000000 0000000000000001
           000000001f962f78 0000000000518968 0000000090000002 000000001ff03280
           0000000000000000 000000000064f000 000000001f962f78 0000000000002603
           0000000006002603 0000000000000000 000000001ff7fe68 000000001ff7fe48
Krnl Code: 000000000002c036: 5820d010            l       %r2,16(%r13)
           000000000002c03a: 1832                lr      %r3,%r2
           000000000002c03c: 1a31                ar      %r3,%r1
          >000000000002c03e: ba23d010            cs      %r2,%r3,16(%r13)
           000000000002c042: a744fffc            brc     4,2c03a
           000000000002c046: a7290002            lghi    %r2,2
           000000000002c04a: e320d0000024        stg     %r2,0(%r13)
           000000000002c050: 07f0                bcr     15,%r0
Call Trace:
 ([<000000001f962f78>] 0x1f962f78)
  [<000000000001acda>] do_extint+0xf6/0x138
  [<000000000039b6ca>] ext_no_vtime+0x30/0x34
  [<000000007d706e04>] 0x7d706e04
Last Breaking-Event-Address:
  [<0000000000000000>] 0x0

For stable maintainers:
the first kernel which contains this bug is 2.6.37.

Reported-by: Stephen Powell <zlinuxman@wowway.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: stable@kernel.org
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 arch/s390/mm/fault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 9217e33..4cf85fe 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -558,9 +558,9 @@ static void pfault_interrupt(unsigned int ext_int_code,
 	 * Get the token (= address of the task structure of the affected task).
 	 */
 #ifdef CONFIG_64BIT
-	tsk = *(struct task_struct **) param64;
+	tsk = (struct task_struct *) param64;
 #else
-	tsk = *(struct task_struct **) param32;
+	tsk = (struct task_struct *) param32;
 #endif
 
 	if (subcode & 0x0080) {
