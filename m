Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab0FVTST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:18:19 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59819 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0FVTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 15:18:18 -0400
Date: Tue, 22 Jun 2010 21:19:40 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, "x86@kernel.org" <x86@kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: intel_cacheinfo: potential NULL dereference?
Message-ID: <20100622191940.GA29678@aftab>
References: <4C209C15.9090604@gmail.com>
 <4C209C6E.3060302@gmail.com>
 <20100622130825.GB27658@aftab>
 <4C20C478.9030505@gmail.com>
 <4C20EE54.2050506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C20EE54.2050506@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, Jun 22, 2010 at 01:09:40PM -0400

> On 06/22/2010 07:11 AM, Jiri Slaby wrote:
> > On 06/22/2010 03:08 PM, Borislav Petkov wrote:
> >> From: Jiri Slaby <jirislaby@gmail.com>
> >> Date: Tue, Jun 22, 2010 at 07:20:14AM -0400
> >>
> >>> On 06/22/2010 01:18 PM, Jiri Slaby wrote:
> >>>> Stanse found, that this_leaf->l3 is dereferenced at <<1>>, but checked
> >>>> for being NULL at <<2>>. Is the check superfluous or the dev assignment
> >>>> should go after the check?
> >>>
> >>> Oh, and I have another report with same symptoms for show_cache_disable.
> >>
> >> Right, so I have a patch in tip/x86/cpu
> >> (8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0) which reorganizes
> >> and cleans up that code. With it, all possible checks land in
> >> amd_check_l3_disable() and if they have all been passed, the PCI dev is
> >> guaranteed to be properly set. So no need for sprinkling additional NULL
> >> checks in the code.
> >>
> >> How's that?
> > 
> > Looks good.
> > 
> 
> Do we need a patch for the existing code to go into -linus and -stable,
> though?

Right, so this is not such a bad idea, actually. Here's a small fix,
just in case. This should go to -linus so that the issue is patched up
for .35 time. No need for -stable since this code came into the last
merge window.

The 8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0 in tip/x86/cpu was meant
for the .36 merge window so I'll readjust it relative to the small fix
below.

---
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Tue, 22 Jun 2010 21:06:51 +0200
Subject: [PATCH] x86, cacheinfo: Move dereferencing after NULL check

The sysfs handlers {show,store}_cache_disable() should dereference the
pci dev pointer after having checked the previous l3 pointer in the
chain first.

Spotted-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 33eae20..a7e358f 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -399,16 +399,15 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 				  unsigned int slot)
 {
-	struct pci_dev *dev = this_leaf->l3->dev;
 	unsigned int reg = 0;
 
 	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
 		return -EINVAL;
 
-	if (!dev)
+	if (!this_leaf->l3->dev)
 		return -EINVAL;
 
-	pci_read_config_dword(dev, 0x1BC + slot * 4, &reg);
+	pci_read_config_dword(this_leaf->l3->dev, 0x1BC + slot * 4, &reg);
 	return sprintf(buf, "0x%08x\n", reg);
 }
 
@@ -456,7 +455,6 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 				   const char *buf, size_t count,
 				   unsigned int slot)
 {
-	struct pci_dev *dev = this_leaf->l3->dev;
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
 	unsigned long val = 0;
 
@@ -469,7 +467,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!dev)
+	if (!this_leaf->l3->dev)
 		return -EINVAL;
 
 	if (strict_strtoul(buf, 10, &val) < 0)
-- 
1.6.4.4


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
