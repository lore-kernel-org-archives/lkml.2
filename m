Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab0KXA2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:28:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab0KXA2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:28:11 -0500
Date: Wed, 24 Nov 2010 11:28:01 +1100
From: Neil Brown <neilb@suse.de>
To: x86@kernel.org, cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Missing "unregister_cpu_notifier" in powernow-k8.c
Message-ID: <20101124112801.78830fba@notabene.brown>
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
 (hope I got the right addressees above....)

 I appears that when powernow-k8 find that 

    No compatible ACPI _PSS objects found.

 and suggests

    Try again with latest BIOS.

 it fails the module load, but does not unregister the cpu_notifier that was 
 registered in powernowk8_init

 This ends up leaving freed memory on the cpu notifier list for some other
 poor module (e.g. md/raid5) to come along and trip over.

 The following might be a partial fix, but I suspect there is probably other
 clean-up that is needed.

 ( https://bugzilla.novell.com/show_bug.cgi?id=655215 has full dmesg traces).

Thanks,
NeilBrown


diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 491977b..812778c 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1537,6 +1537,7 @@ static struct notifier_block cpb_nb = {
 static int __cpuinit powernowk8_init(void)
 {
 	unsigned int i, supported_cpus = 0, cpu;
+	int rv;
 
 	for_each_online_cpu(i) {
 		int rc;
@@ -1574,7 +1575,10 @@ static int __cpuinit powernowk8_init(void)
 			(cpb_enabled ? "on" : "off"));
 	}
 
-	return cpufreq_register_driver(&cpufreq_amd64_driver);
+	rv = cpufreq_register_driver(&cpufreq_amd64_driver);
+	if (rv < 0 && boot_cpu_has(X86_FEATURE_CPB))
+		unregister_cpu_notifier(&cpb_nb);
+	return rv;
 }
 
 /* driver entry point for term */
