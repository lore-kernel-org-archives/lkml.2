Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0FAHLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 03:11:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35077 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab0FAHLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 03:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Ab18+cp6I+VEqFMikzWp7BMDqaH8XNUbxT0drNmg/TmQR9CYZ5Lxl9b1mT7D9uMHzV
         VqcEBCNB+hhgAq9ehgX6FR5NPacp46KiAoJDUV0+Iyc4UXrOYRxHBHyNCOxPJHLrGuxb
         s3XGBgcU0HoUEcCdWMtA9j2LbtAjsnzzd0Gw4=
Date: Tue, 1 Jun 2010 09:11:27 +0200
From: Dan Carpenter <error27@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] x86, cacheinfo: dereferences before check
Message-ID: <20100601071126.GF5483@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves a couple dereferences after the checks in
show_cache_disable() and store_cache_disable().  These were introduced
fairly recently in 9350f982e4: "x86, cacheinfo: Reorganize AMD L3 cache
structure"

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 33eae20..1725a0e 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -399,12 +399,13 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 				  unsigned int slot)
 {
-	struct pci_dev *dev = this_leaf->l3->dev;
+	struct pci_dev *dev;
 	unsigned int reg = 0;
 
 	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
 		return -EINVAL;
 
+	dev = this_leaf->l3->dev;
 	if (!dev)
 		return -EINVAL;
 
@@ -456,7 +457,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 				   const char *buf, size_t count,
 				   unsigned int slot)
 {
-	struct pci_dev *dev = this_leaf->l3->dev;
+	struct pci_dev *dev;
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
 	unsigned long val = 0;
 
@@ -469,6 +470,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	dev = this_leaf->l3->dev;
 	if (!dev)
 		return -EINVAL;
 
