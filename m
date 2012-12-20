Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab2LTEQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 23:16:41 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:30295
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251Ab2LTEQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 23:16:34 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MFBAJA-01-B5U-02
X-M-MSG: 
Date: Wed, 19 Dec 2012 22:16:21 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
Message-ID: <20121220041621.GA23609@jshin-Toonie>
References: <50CD04F1.8020902@zytor.com>
 <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
 <20121219220504.GA32212@jshin-Toonie>
 <50D23EE8.7030904@zytor.com>
 <20121219225155.GK24895@liondog.tnic>
 <20121219225941.GB2968@jshin-Toonie>
 <50D25AA9.3090306@zytor.com>
 <20121220002954.GA10405@jshin-Toonie>
 <50D279F9.4000707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <50D279F9.4000707@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 06:37:45PM -0800, H. Peter Anvin wrote:
> On 12/19/2012 04:29 PM, Jacob Shin wrote:
> > On Wed, Dec 19, 2012 at 04:24:09PM -0800, H. Peter Anvin wrote:
> >> On 12/19/2012 04:07 PM, Jacob Shin wrote:
> >>>
> >>> From what I remember, accessing memory around the memory hole (not
> >>> just the HT hole, but e038000000 ~ 10000000000 on our mentioned system
> >>> ) generated prefetches because the memory hole was marked as WB in PAT.
> >>>
> >>> I'll take a look at the system again, try the blanket MTRR covering
> >>> 0xe000000000 ~ 1TB, and talk to our BIOS guys.
> >>>
> >>
> >> Yes, but do they all #MC (as opposed to, say, fetching all FFs)?
> > 
> > Yes, MCE every time and it was fatal.
> > 
> 
> OK, one more question... there is something odd with the memory ranges here:
> 
>  BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
>  BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
>  BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable
> 
> The first usable range here is 4G to 896G + 896M which is an awfully
> strange number.  Similarly, the second range is 1T to 1T + 128G - 16M.
> The little fiddly bits imply that there is either overshoot of some sort
> going on -- possibly reserved memory -- or these are fairly arbitrary
> sizes that don't match any physical bank sizes in which case it should
> be possible to shuffle it differently...

Not exactly sure why the wierd boundaries, I'll have to ask the BIOS
side folks to be sure. But if I were to guess ..

Here is the NUMA spew out, physically there is 128 GB connected to
each memory controller node. The PCI MMIO region starts at 0xc8000000.
4 GB - 0xc8000000 = 0x3800000 (896 MB). So we loose 896 MB due to PCI
MMIO hole, so the first node ends at 128 GB + 896 MB to talk to all of
128 GB off of the first memory controller, and hence the weird 896 MB
offset.

[    0.000000] SRAT: Node 0 PXM 0 0-a0000
[    0.000000] SRAT: Node 0 PXM 0 100000-c8000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-2038000000
[    0.000000] SRAT: Node 1 PXM 1 2038000000-4038000000
[    0.000000] SRAT: Node 2 PXM 2 4038000000-6038000000
[    0.000000] SRAT: Node 3 PXM 3 6038000000-8038000000
[    0.000000] SRAT: Node 4 PXM 4 8038000000-a038000000
[    0.000000] SRAT: Node 5 PXM 5 a038000000-c038000000
[    0.000000] SRAT: Node 6 PXM 6 c038000000-e038000000
[    0.000000] SRAT: Node 7 PXM 7 10000000000-11fff000000
[    0.000000] NUMA: Initialized distance table, cnt=8
[    0.000000] NUMA: Node 0 [0,a0000) + [100000,c8000000) -> [0,c8000000)
[    0.000000] NUMA: Node 0 [0,c8000000) + [100000000,2038000000) -> [0,2038000000)
[    0.000000] Initmem setup node 0 0000000000000000-0000002038000000
[    0.000000]   NODE_DATA [0000002037ff5000 - 0000002037ffffff]
[    0.000000] Initmem setup node 1 0000002038000000-0000004038000000
[    0.000000]   NODE_DATA [0000004037ff5000 - 0000004037ffffff]
[    0.000000] Initmem setup node 2 0000004038000000-0000006038000000
[    0.000000]   NODE_DATA [0000006037ff5000 - 0000006037ffffff]
[    0.000000] Initmem setup node 3 0000006038000000-0000008038000000
[    0.000000]   NODE_DATA [0000008037ff5000 - 0000008037ffffff]
[    0.000000] Initmem setup node 4 0000008038000000-000000a038000000
[    0.000000]   NODE_DATA [000000a037ff5000 - 000000a037ffffff]
[    0.000000] Initmem setup node 5 000000a038000000-000000c038000000
[    0.000000]   NODE_DATA [000000c037ff5000 - 000000c037ffffff]
[    0.000000] Initmem setup node 6 000000c038000000-000000e038000000
[    0.000000]   NODE_DATA [000000e037ff2000 - 000000e037ffcfff]
[    0.000000] Initmem setup node 7 0000010000000000-0000011fff000000
[    0.000000]   NODE_DATA [0000011ffeff1000 - 0000011ffeffbfff]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x11fff000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[10] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000099
[    0.000000]     0: 0x00000100 -> 0x000c7ec0
[    0.000000]     0: 0x00100000 -> 0x02038000
[    0.000000]     1: 0x02038000 -> 0x04038000
[    0.000000]     2: 0x04038000 -> 0x06038000
[    0.000000]     3: 0x06038000 -> 0x08038000
[    0.000000]     4: 0x08038000 -> 0x0a038000
[    0.000000]     5: 0x0a038000 -> 0x0c038000
[    0.000000]     6: 0x0c038000 -> 0x0e038000
[    0.000000]     7: 0x10000000 -> 0x11fff000
[    0.000000] On node 0 totalpages: 33553993
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3916 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 800504 pages, LIFO batch:31
[    0.000000]   Normal zone: 447552 pages used for memmap
[    0.000000]   Normal zone: 32287680 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 33554432
[    0.000000]   Normal zone: 458752 pages used for memmap
[    0.000000]   Normal zone: 33095680 pages, LIFO batch:31
[    0.000000] On node 2 totalpages: 33554432
[    0.000000]   Normal zone: 458752 pages used for memmap
[    0.000000]   Normal zone: 33095680 pages, LIFO batch:31
[    0.000000] On node 3 totalpages: 33554432
[    0.000000]   Normal zone: 458752 pages used for memmap
[    0.000000]   Normal zone: 33095680 pages, LIFO batch:31
[    0.000000] On node 4 totalpages: 33554432
[    0.000000]   Normal zone: 458752 pages used for memmap
[    0.000000]   Normal zone: 33095680 pages, LIFO batch:31
[    0.000000] On node 5 totalpages: 33554432
[    0.000000]   Normal zone: 458752 pages used for memmap
[    0.000000]   Normal zone: 33095680 pages, LIFO batch:31
[    0.000000] On node 6 totalpages: 33554432
[    0.000000]   Normal zone: 458752 pages used for memmap
[    0.000000]   Normal zone: 33095680 pages, LIFO batch:31
[    0.000000] On node 7 totalpages: 33550336
[    0.000000]   Normal zone: 458696 pages used for memmap
[    0.000000]   Normal zone: 33091640 pages, LIFO batch:31

> 
> 	-hpa
> 
> 

