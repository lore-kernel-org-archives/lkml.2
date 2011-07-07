Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab1GGSLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:11:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32967 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab1GGSLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:11:32 -0400
Date: Thu, 7 Jul 2011 20:11:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110707181116.GA13430@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-urgent-for-linus

 Thanks,

	Ingo

------------------>
Robert Richter (1):
      oprofile, x86: Fix race in nmi handler while starting counters

Xiao Guangrong (1):
      jump_label: Fix jump_label update for modules


 arch/x86/oprofile/nmi_int.c |   14 ++++++++++----
 kernel/jump_label.c         |   14 +++++++++-----
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cf97500..68894fd 100644
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
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index fa27e75..a8ce450 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -375,15 +375,19 @@ int jump_label_text_reserved(void *start, void *end)
 
 static void jump_label_update(struct jump_label_key *key, int enable)
 {
-	struct jump_entry *entry = key->entries;
-
-	/* if there are no users, entry can be NULL */
-	if (entry)
-		__jump_label_update(key, entry, __stop___jump_table, enable);
+	struct jump_entry *entry = key->entries, *stop = __stop___jump_table;
 
 #ifdef CONFIG_MODULES
+	struct module *mod = __module_address((jump_label_t)key);
+
 	__jump_label_mod_update(key, enable);
+
+	if (mod)
+		stop = mod->jump_entries + mod->num_jump_entries;
 #endif
+	/* if there are no users, entry can be NULL */
+	if (entry)
+		__jump_label_update(key, entry, stop, enable);
 }
 
 #endif
