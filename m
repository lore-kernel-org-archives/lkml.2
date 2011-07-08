Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1GHFDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:03:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42056 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab1GHFDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:03:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:57 2011
Message-Id: <20110708001657.566525317@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>
Subject: [050/107] oprofile, x86: Fix race in nmi handler while starting counters
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit 8fe7e94eb71430cf63a742f3c19739d82a662758 upstream.

In some rare cases, nmis are generated immediately after the nmi
handler of the cpu was started. This causes the counter not to be
enabled. Before enabling the nmi handlers we need to set variable
ctr_running first and make sure its value is written to memory.

Also, the patch makes all existing barriers a memory barrier instead
of a compiler barrier only.

Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/nmi_int.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -112,8 +112,10 @@ static void nmi_cpu_start(void *dummy)
 static int nmi_start(void)
 {
 	get_online_cpus();
-	on_each_cpu(nmi_cpu_start, NULL, 1);
 	ctr_running = 1;
+	/* make ctr_running visible to the nmi handler: */
+	smp_mb();
+	on_each_cpu(nmi_cpu_start, NULL, 1);
 	put_online_cpus();
 	return 0;
 }
@@ -504,15 +506,18 @@ static int nmi_setup(void)
 
 	nmi_enabled = 0;
 	ctr_running = 0;
-	barrier();
+	/* make variables visible to the nmi handler: */
+	smp_mb();
 	err = register_die_notifier(&profile_exceptions_nb);
 	if (err)
 		goto fail;
 
 	get_online_cpus();
 	register_cpu_notifier(&oprofile_cpu_nb);
-	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
+	/* make nmi_enabled visible to the nmi handler: */
+	smp_mb();
+	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	put_online_cpus();
 
 	return 0;
@@ -531,7 +536,8 @@ static void nmi_shutdown(void)
 	nmi_enabled = 0;
 	ctr_running = 0;
 	put_online_cpus();
-	barrier();
+	/* make variables visible to the nmi handler: */
+	smp_mb();
 	unregister_die_notifier(&profile_exceptions_nb);
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);


