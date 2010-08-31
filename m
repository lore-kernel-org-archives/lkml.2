Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab0HaKfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 06:35:12 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:47240 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab0HaKfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 06:35:09 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzbb2cK1431J1432N98dNzz1202hzz8275bh8275dhz32i2a8h5bep5bfs)
X-WSS-ID: 0L80II0-02-42S-02
X-M-MSG: 
Date: Tue, 31 Aug 2010 12:30:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] oprofile, x86: fix init_sysfs error handling
Message-ID: <20100831103001.GC22783@erda.amd.com>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
 <1283107921-21464-2-git-send-email-will.deacon@arm.com>
 <1283107921-21464-3-git-send-email-will.deacon@arm.com>
 <1283107921-21464-4-git-send-email-will.deacon@arm.com>
 <20100830090929.GU22783@erda.amd.com>
 <1283244880.645.17.camel@e102144-lin.cambridge.arm.com>
 <20100831090518.GZ22783@erda.amd.com>
 <1283247089.4063.2.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1283247089.4063.2.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.08.10 05:31:29, Will Deacon wrote:
> > For x86 wont change the code (actually I found a bug in the init_sysfs
> > error handler for which I will send a fix). Just wanted to get your
> > confirmation in case I was missing something that x86 is not affected.
> > I will apply the first 2 patches, no need to resubmit.

This is the patch, applied to:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent

-Robert

--

>From 10f0412f57f2a76a90eff4376f59cbb0a39e4e18 Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Mon, 30 Aug 2010 10:56:18 +0200
Subject: [PATCH] oprofile, x86: fix init_sysfs error handling

On failure init_sysfs() might not properly free resources. The error
code of the function is not checked. And, when reinitializing the exit
function might be called twice. This patch fixes all this.

Cc: stable@kernel.org
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index f6b48f6..73a41d3 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -568,8 +568,13 @@ static int __init init_sysfs(void)
 	int error;
 
 	error = sysdev_class_register(&oprofile_sysclass);
-	if (!error)
-		error = sysdev_register(&device_oprofile);
+	if (error)
+		return error;
+
+	error = sysdev_register(&device_oprofile);
+	if (error)
+		sysdev_class_unregister(&oprofile_sysclass);
+
 	return error;
 }
 
@@ -695,6 +700,8 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	char *cpu_type = NULL;
 	int ret = 0;
 
+	using_nmi = 0;
+
 	if (!cpu_has_apic)
 		return -ENODEV;
 
@@ -774,7 +781,10 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 
 	mux_init(ops);
 
-	init_sysfs();
+	ret = init_sysfs();
+	if (ret)
+		return ret;
+
 	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;
-- 
1.7.1.1



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

