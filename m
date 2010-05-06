Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab0EFNq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 09:46:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096Ab0EFNq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 09:46:26 -0400
Date: Thu, 6 May 2010 15:46:21 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
       Jiri Benc <jbenc@suse.cz>,
       "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
       "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>
Subject: Re: [113/197] x86, cacheinfo: Calculate L3 indices
In-Reply-To: <20100506081721.GA20616@aftab>
Message-ID: <alpine.LNX.2.00.1005061532390.9849@pobox.suse.cz>
References: <20100422190917.467545308@kvm.kroah.org> <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz> <20100505180228.GC15804@aftab> <alpine.LNX.2.00.1005052328000.9849@pobox.suse.cz> <20100506081721.GA20616@aftab>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Borislav Petkov wrote:

> > The point is though, that we really should be checking for return value of 
> > node_to_k8_nb_misc() as it can legitimately return NULL, can't it? (and 
> > other places, such as show_cache_disable() and store_cache_disable(), are 
> > checking for this being NULL properly).
> 
> Well, I don't like sprinkling NULL ptr checks all over the place - this
> makes the code unreadable and means that there's something wrong with
> its design in the first place.
> 
> Therefore, it is better IMO to verify whether the K8_NB thing is
> initialized properly and exit early if not. And this is what the two
> patches I'm suggesting try to accomplish:
> 
> 1. Call into K8_NB on AMD unconditionally so that we have those
> initialized (we'll be needing them more in the future, I guess)
> 
> 2. Check in the L3 cache code whether K8_NB has initted properly and
> bail out if not.
> 
> With this, no need for NULL ptr checks anywhere and you got
> better/smaller/more readable code with the proper assumptions in place.

Well, we have

	#ifdef CONFIG_K8_NB
	static inline struct pci_dev *node_to_k8_nb_misc(int node)
	{
		return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
	}
	#else
	static inline struct pci_dev *node_to_k8_nb_misc(int node)
	{
		return NULL;
	}
	#endif

So it legitimately returns NULL in two cases:

	1) if someone passes too large node
	2) if CONFIG_K8_NB is unset

1) Either we assume that node will always be in the range (i.e. 
amd_get_nb_id() will never go crazy return anything bogus), and then we 
could just drop the test completely. Or we want to check for such the 
possibility, and then node_to_k8_nb_misc() is going to return NULL in such 
cases, and so we want to check for it.

2) is now moot, as all three in-tree callers are now under proper ifdefs 
(CONFIG_CPU_SUP_AMD, which depends on CONFIG_K8_NB after your patch has 
been applied). So I believe we could remove it, right?

Either way, current state seems inconsistent. So either we should add the 
return value check to amd_calc_l3_indices() as well, or remove all the 
NULL magic altogether, i.e. the (untested) patch below.

What do you think?


From: Jiri Kosina <jkosina@suse.cz>
Subject: x86, cacheinfo: remove unnecessary NULL pointer checks

As K8_NB thing is now always initialized on AMD CPUs, and we don't have 
any caller that would be outside CONFIG_CPU_SUP_AMD/CONFIG_K8_NB, it is 
safe to assume that kb_northbridges has been always initialized).

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

 arch/x86/include/asm/k8.h             |   10 +---------
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 ------
 2 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index f70e600..0cff8ba 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -15,17 +15,9 @@ extern int k8_get_nodes(struct bootnode *nodes);
 extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int k8_scan_nodes(void);
 
-#ifdef CONFIG_K8_NB
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
-	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
+	return k8_northbridges[node];
 }
-#else
-static inline struct pci_dev *node_to_k8_nb_misc(int node)
-{
-	return NULL;
-}
-#endif
-
 
 #endif /* _ASM_X86_K8_H */
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index b3eeb66..6c5f3cd 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -355,9 +355,6 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 	if (!this_leaf->can_disable)
 		return -EINVAL;
 
-	if (!dev)
-		return -EINVAL;
-
 	pci_read_config_dword(dev, 0x1BC + index * 4, &reg);
 	return sprintf(buf, "0x%08x\n", reg);
 }
@@ -388,9 +385,6 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!dev)
-		return -EINVAL;
-
 	if (strict_strtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
