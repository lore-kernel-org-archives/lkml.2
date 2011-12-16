Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab1LPQUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:20:05 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:4142
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab1LPQUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:20:00 -0500
X-SpamScore: -17
X-BigFish: VPS-17(zzbb2dI9371I936eK103dK1432N98dKzz1202hzz8275bh8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWB1D4-02-342-02
X-M-MSG: 
Date: Fri, 16 Dec 2011 10:20:05 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Yinghai Lu <yinghai.lu@oracle.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes
 above 4 GB from direct mapping.
Message-ID: <20111216162004.GC18068@jshin-Toonie>
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>
 <4EA09EA2.3030203@zytor.com>
 <1319149574.13035.6.camel@jshin-Toonie>
 <4EE9266A.90200@zytor.com>
 <20111214231425.GA18068@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111214231425.GA18068@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 05:14:25PM -0600, Jacob Shin wrote:
> On Wed, Dec 14, 2011 at 02:42:50PM -0800, H. Peter Anvin wrote:
> > On 10/20/2011 03:26 PM, Jacob Shin wrote:
> > > On Thu, 2011-10-20 at 17:20 -0500, H. Peter Anvin wrote:
> > >> On 10/20/2011 02:15 PM, Jacob Shin wrote:
> > >>> On systems with very large memory (1 TB in our case), BIOS may report a
> > >>> reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
> > >>> these from the direct mapping.
> > >>
> > >>> +			if (ei->type == E820_RESERVED)
> > >>> +				continue;
> > >>
> > >> This should probably be ei->type != E820_RAM or something similar.  I
> > >> haven't looked yet, what does the < 4 GiB code do?
> > > 
> > > Hm, okay, it calls e820_end_of_low_ram_pfn() which effectively is !=
> > > E820_RAM.
> > > 
> > > I'll fix this, test, then resend.
> > > 
> > 
> > I never got any kind of updated patch, did I?
> 
> No, I never sent one out, because it would have still only covered > 4GB, and
> in later emails, you said that you wanted a general one that covered all x86.
> 
> I'll give it another shot at the generic patch, making a special case for the
> < 1MB ISA region.
> 

Here is the new patch, thanks!

>From dad99fe54eb26d4022a48f1f9b88c21f77809282 Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Thu, 15 Dec 2011 10:56:14 -0500
Subject: [PATCH] x86: Only include address ranges marked as E820_RAM in kernel direct mapping

Currently, 0 ~ max_low_pfn is first mapped, then 4GB ~ max_pfn is
mapped. On some systems that have large memory holes that occur
within those two regions, we end up with PATs that mark pages that
are not backed by actual DRAM -- as cacheable.

This patch first maps 0 ~ 1MB ISA region, then iterates over the
E820 to map useable E820_RAM ranges.

Cc: stable@kernel.org   # > 2.6.32
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Reviewed-by: Andreas Herrmann <Andreas.Herrmann3@amd.com>
---
 arch/x86/kernel/setup.c |   29 ++++++++++++++++++++++++++---
 1 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cf0ef98..eae6b41 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -691,6 +691,8 @@ early_param("reservelow", parse_reservelow);
 
 void __init setup_arch(char **cmdline_p)
 {
+	int i;
+
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
@@ -932,13 +934,34 @@ void __init setup_arch(char **cmdline_p)
 	init_gbpages();
 
 	/* max_pfn_mapped is updated here */
-	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
+	max_low_pfn_mapped = init_memory_mapping(0, 0x100000);
 	max_pfn_mapped = max_low_pfn_mapped;
 
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 start = ei->addr;
+		u64 end = ei->addr + ei->size;
+
+		if (ei->type != E820_RAM)
+			continue;
+
+		if (start < 0x100000)
+			continue;
+#ifdef CONFIG_X86_32
+		if ((start >> PAGE_SHIFT) >= max_low_pfn)
+			continue;
+
+		if ((end >> PAGE_SHIFT) > max_low_pfn)
+			end = max_low_pfn << PAGE_SHIFT;
+#endif
+		max_pfn_mapped = init_memory_mapping(start, end);
+
+		if ((end >> PAGE_SHIFT) == max_low_pfn)
+			max_low_pfn_mapped = max_pfn_mapped;
+	}
+
 #ifdef CONFIG_X86_64
 	if (max_pfn > max_low_pfn) {
-		max_pfn_mapped = init_memory_mapping(1UL<<32,
-						     max_pfn<<PAGE_SHIFT);
 		/* can we preseve max_low_pfn ?*/
 		max_low_pfn = max_pfn;
 	}
-- 
1.7.1


