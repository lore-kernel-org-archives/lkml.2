Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0H0I6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:58:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33790 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0H0I6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:58:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EUB3eMHOxH+amEOpbTjRGGlACaWWlojnltDlz1q+kqhvz+e9FWf6wob5MT1fWpkOOc
         j9evKXfZOld/FkouZjzd3rmSmMpwW/V0d1c89nkQ2+DNHPWoRirkfbTl/ML1XnWFVPau
         wWf7J/WzTVZG++deb6ogcvenLskz40dfPRIHs=
Date: Fri, 27 Aug 2010 11:20:07 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, mcheck: Avoid duplicate sysfs links/files for
 thresholding banks
Message-ID: <20100827092006.GB5348@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

kobject_add_internal failed for threshold_bank2 with -EEXIST, don't
    try to register things with the same name in the same directory.
  Pid: 1, comm: swapper Tainted: G        W  2.6.31 #1
  Call Trace:
  [<ffffffff81161b07>] ? kobject_add_internal+0x156/0x180
  [<ffffffff81161cc0>] ? kobject_add+0x66/0x6b
  [<ffffffff81161793>] ? kobject_init+0x42/0x82
  [<ffffffff81161cf9>] ? kobject_create_and_add+0x34/0x63
  [<ffffffff81393963>] ? threshold_create_bank+0x14f/0x259
  [<ffffffff8139310a>] ? mce_create_device+0x8d/0x1b8
  [<ffffffff81646497>] ? threshold_init_device+0x3f/0x80
  [<ffffffff81646458>] ? threshold_init_device+0x0/0x80
  [<ffffffff81009050>] ? do_one_initcall+0x4f/0x143
  [<ffffffff816413a0>] ? kernel_init+0x14c/0x1a2
  [<ffffffff8100c8da>] ? child_rip+0xa/0x20
  [<ffffffff81641254>] ? kernel_init+0x0/0x1a2
  [<ffffffff8100c8d0>] ? child_rip+0x0/0x20
  kobject_create_and_add: kobject_add error: -17

(Probably the for_each_cpu loop should be entirely removed.)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 224392d..5e97529 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -530,7 +530,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		err = -ENOMEM;
 		goto out;
 	}
-	if (!alloc_cpumask_var(&b->cpus, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&b->cpus, GFP_KERNEL)) {
 		kfree(b);
 		err = -ENOMEM;
 		goto out;
@@ -543,7 +543,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 #ifndef CONFIG_SMP
 	cpumask_setall(b->cpus);
 #else
-	cpumask_copy(b->cpus, c->llc_shared_map);
+	cpumask_set_cpu(cpu, b->cpus);
 #endif
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
-- 
1.6.4.4

