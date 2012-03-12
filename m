Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2CLU07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 16:26:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:40499 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756661Ab2CLU06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 16:26:58 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX18wHhIIWwwwAswuuj/GMVhta0nlMeFnbX54splz+B
	9Qvztqoq2f6tBY
From: Marc Dietrich <marvin24@gmx.de>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] staging: fix powerpc linux-next break on zsmalloc
Date: Mon, 12 Mar 2012 21:26:02 +0100
Message-ID: <1682961.ZuPU006sSl@ax5200p>
User-Agent: KMail/4.7.3 (Linux/3.2.0-17-generic; KDE/4.7.4; x86_64; ; )
In-Reply-To: <4F5E097B.4070605@linux.vnet.ibm.com>
References: <1329144469-8575-1-git-send-email-sjenning@linux.vnet.ibm.com> <5736714.Unq6oKkpjO@ax5200p> <4F5E097B.4070605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Monday 12 March 2012 09:34:35 Seth Jennings wrote:
> On 02/14/2012 10:21 AM, Marc Dietrich wrote:
> > On Tuesday 14 February 2012 08:35:13 Seth Jennings wrote:
> >> On 02/14/2012 05:39 AM, Marc Dietrich wrote:
> >>> Am 14.02.2012 12:22, schrieb Marc Dietrich:
> >>>> Am 13.02.2012 15:47, schrieb Seth Jennings:
> >>>>> linux/vmalloc.h added to zsmalloc-main.c to resolve implicit
> >>>>> declaration errors.
> >>>>> 
> >>>>> X86 dependency added to zsmalloc and dependent drivers zcache
> >>>>> and
> >>>>> zram.
> >>>>> 
> >>>>> This X86 only requirement is not ideal.  Working to find
> >>>>> portable
> >>>>> functions for __flush_tlb_one and set_pte.
> >>>> 
> >>>> sorry, zcache/zram works fine one ARM here. Why not depend on
> >>>> !POWERPC?
> >>> 
> >>> ups, sorry again, I tested an older version only. flush_tlb_one and
> >>> set_pte is only used with the new allocator as it seems.
> >> 
> >> It would seem that the cpu-local tlb page flushing function for ARM
> >> is local_flush_tlb_kernel_page(), by look at the kmap_atomic() code
> >> in arch/arm/mm/highmem.c.
> >> 
> >> So each arch is using a slightly different approach here.
> >> 
> >> A simple #define per-arch could make a it a common call.  I think
> >> I'm going to code it up and see how it goes.
> > 
> > ... and I'm happy to test it ;-)
> 
> So I have a branch ready for you to test if your are willing
> 
> git://github.com/spartacus06/linux.git -b portable

ok, I took three patches I found relavant:
	454bded136: staging: zsmalloc: change type of vm_area
	33258b4c9d: staging: zcache: use portable cpu-local tlb flush
	15959dc488: staging: add ARM/PPC64 to zcache/zram/zsmalloc Kconfig

and also backported:
	cd12909cb5: xen: map foreign pages for shared rings by updating the PTEs 
directly

to my 3.0 tree which has all changes for zcache/frontswap/zram/cleancache 
backported from linux-next (sorry, other kernels are more hard to test on this 
machine).

> The branch is based on Greg's staging-next, since my
> patches that remove the sparsemem dependency are in there.
> The frontswap_v11 patches are in that branch as well.
> 
> I did a simple make test with my ARM cross compiler and it
> builds cleanly.  Now I just need to know if it _works_.
> 
> I'm not sure if you have been experimenting with frontswap
> since it's not in mainline yet, but you can enable/disable
> it in:
> 
> Kernel Features -> Enable frontswap to cache swap pages if tmem is present
> 
> Only the frontswap paths use zsmalloc right now. We are looking
> to use it for the cleancache paths too soon (I'm working on
> that now).
> 
> I'd appreciate any feedback you can provide!

I enabled zram (for swap), frontswap and cleancache.

In a short test, my half proprietary display driver crashes

[  204.951006] Unable to handle kernel NULL pointer dereference at virtual 
address 00000000
[  204.959130] pgd = c1018000
[  204.961829] [00000000] *pgd=00000000
[  204.965421] Internal error: Oops: 5 [#1] SMP
[  204.969682] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat fuse 
zram(C) snd_soc_alc5632 rt2800usb snd_seq_dummy rt2800lib rt2x00usb 
snd_soc_tegra_pcm rt2x00lib mac80211 snd_seq_oss snd_seq_midi_event cdc_ether 
snd_soc_tegra_i2s usbnet snd_soc_tegra_das snd_pcm_oss snd_soc_tegra_alc5632 
cdc_wdm snd_mixer_oss mii snd_soc_core cdc_acm cfg80211 uvcvideo snd_seq 
videodev snd_pcm tegra_wdt snd_seq_device snd_timer snd_soc_tegra_utils lm90 
snd soundcore snd_page_alloc
[  205.011152] CPU: 0    Tainted: G         C   (3.0.19 #28)
[  205.016551] PC is at get_zspage_mapping+0x14/0x48
[  205.021247] LR is at zs_map_object+0x60/0x1a0
[  205.025597] pc : [<c036179c>]    lr : [<c0361b70>]    psr: 400f0013
[  205.025603] sp : c3ca5978  ip : c3ca5988  fp : c3ca5984
[  205.037062] r10: 000197c8  r9 : d86c5000  r8 : 00005045
[  205.042275] r7 : c06ae000  r6 : dacf0000  r5 : 00000fc3  r4 : c074e8a0
[  205.048790] r3 : 00080068  r2 : c3ca5994  r1 : c3ca5990  r0 : 00000000
[  205.055306] Flags: nZcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment 
user
[  205.062428] Control: 10c5387d  Table: 0101804a  DAC: 00000015
[  205.068164] Process plugin-containe (pid: 1771, stack limit = 0xc3ca42f8)
[  205.074940] Stack: (0xc3ca5978 to 0xc3ca6000)
<stack snipped>
[  205.512112] [<c036179c>] (get_zspage_mapping+0x14/0x48) from [<c0361b70>] 
(zs_map_object+0x60/0x1a0)
[  205.521247] [<c0361b70>] (zs_map_object+0x60/0x1a0) from [<bf0186a0>] 
(zram_bvec_rw.isra.4+0x4b4/0x5b8 [zram])
[  205.531262] [<bf0186a0>] (zram_bvec_rw.isra.4+0x4b4/0x5b8 [zram]) from 
[<bf018c20>] (zram_make_request+0x178/0x244 [zram])
[  205.542304] [<bf018c20>] (zram_make_request+0x178/0x244 [zram]) from 
[<c0242490>] (generic_make_request+0x46c/0x504)
[  205.552816] [<c0242490>] (generic_make_request+0x46c/0x504) from 
[<c024264c>] (submit_bio+0x124/0x164)
[  205.562117] [<c024264c>] (submit_bio+0x124/0x164) from [<c012c37c>] 
(swap_writepage+0xfc/0x114)
[  205.570818] [<c012c37c>] (swap_writepage+0xfc/0x114) from [<c010fc50>] 
(shrink_page_list+0x3ec/0x810)
[  205.580030] [<c010fc50>] (shrink_page_list+0x3ec/0x810) from [<c011046c>] 
(shrink_inactive_list+0x1fc/0x3f4)
[  205.589846] [<c011046c>] (shrink_inactive_list+0x1fc/0x3f4) from 
[<c0110a50>] (shrink_zone+0x3ec/0x508)
[  205.599230] [<c0110a50>] (shrink_zone+0x3ec/0x508) from [<c01115f4>] 
(try_to_free_pages+0x188/0x434)
[  205.608364] [<c01115f4>] (try_to_free_pages+0x188/0x434) from [<c0106e10>] 
(__alloc_pages_nodemask+0x3f0/0x634)
[  205.618450] [<c0106e10>] (__alloc_pages_nodemask+0x3f0/0x634) from 
[<c02a0fc0>] (nvmap_alloc_pages_exact.constprop.4+0x4c/0x108)
[  205.630004] [<c02a0fc0>] (nvmap_alloc_pages_exact.constprop.4+0x4c/0x108) 
from [<c02a1150>] (handle_page_alloc.isra.3+0xd4/0x16c)
[  205.641644] [<c02a1150>] (handle_page_alloc.isra.3+0xd4/0x16c) from 
[<c02a1480>] (nvmap_alloc_handle_id+0x198/0x2c4)
[  205.652156] [<c02a1480>] (nvmap_alloc_handle_id+0x198/0x2c4) from 
[<c02a3184>] (nvmap_ioctl_alloc+0xa0/0xb8)
[  205.661974] [<c02a3184>] (nvmap_ioctl_alloc+0xa0/0xb8) from [<c029fd48>] 
(nvmap_ioctl+0x1b4/0x234)
[  205.670925] [<c029fd48>] (nvmap_ioctl+0x1b4/0x234) from [<c0146734>] 
(do_vfs_ioctl+0x4fc/0x570)
[  205.679615] [<c0146734>] (do_vfs_ioctl+0x4fc/0x570) from [<c0146808>] 
(sys_ioctl+0x60/0x84)
[  205.687971] [<c0146808>] (sys_ioctl+0x60/0x84) from [<c0053dc0>] 
(ret_fast_syscall+0x0/0x30)
[  205.696399] Code: e92dd800 e24cb004 e92d4000 e8bd4000 (e5903000) 
[  205.703172] ---[ end trace 679c2bb67298abde ]---

nvmap used alloc_vm_area which got a second paramter in newer kernels. I just 
replaced it with NULL, but that seems to be the wrong way. I don't want to 
bother you with boring details.

I booted without the xorg driver (so the kernel interface is not used) and got

Mar 12 21:20:28 ac100 kernel: [  118.264433] ------------[ cut here 
]------------
Mar 12 21:20:28 ac100 kernel: [  118.264523] WARNING: at 
/home/marc/ac100/marvin24s-kernel/drivers/staging/zcache/zcache-main.c:755 
zcache_pampd_get_data+0x88/0x14c()
Mar 12 21:20:28 ac100 kernel: [  118.264586] Modules linked in: nls_iso8859_1 
nls_cp437 vfat fat fuse zram(C) snd_soc_alc5632 snd_seq_dummy rt2800usb 
rt2800lib rt2x00usb rt2x00lib snd_soc_tegra_alc5632 mac80211 snd_seq_oss 
snd_soc_tegra_pcm snd_soc_tegra_i2s snd_seq_midi_event snd_soc_tegra_das 
snd_soc_core snd_pcm_oss snd_mixer_oss uvcvideo videodev cfg80211 tegra_wdt 
snd_seq cdc_ether usbnet snd_pcm cdc_wdm cdc_acm mii snd_seq_device lm90 
snd_timer snd soundcore snd_page_alloc snd_soc_tegra_utils
Mar 12 21:20:28 ac100 kernel: [  118.265176] [<c005acac>] 
(unwind_backtrace+0x0/0xec) from [<c0444314>] (dump_stack+0x20/0x24)
Mar 12 21:20:28 ac100 kernel: [  118.265290] [<c0444314>] 
(dump_stack+0x20/0x24) from [<c00860bc>] (warn_slowpath_common+0x5c/0x74)
Mar 12 21:20:28 ac100 kernel: [  118.265385] [<c00860bc>] 
(warn_slowpath_common+0x5c/0x74) from [<c0086100>] 
(warn_slowpath_null+0x2c/0x34)
Mar 12 21:20:28 ac100 kernel: [  118.265474] [<c0086100>] 
(warn_slowpath_null+0x2c/0x34) from [<c035ed9c>] 
(zcache_pampd_get_data+0x88/0x14c)
Mar 12 21:20:28 ac100 kernel: [  118.265566] [<c035ed9c>] 
(zcache_pampd_get_data+0x88/0x14c) from [<c0361028>] (tmem_get+0x160/0x19c)
Mar 12 21:20:28 ac100 kernel: [  118.265651] [<c0361028>] 
(tmem_get+0x160/0x19c) from [<c035fc98>] 
(zcache_get_page.constprop.16+0x8c/0xa8)
Mar 12 21:20:28 ac100 kernel: [  118.265737] [<c035fc98>] 
(zcache_get_page.constprop.16+0x8c/0xa8) from [<c035fd9c>] 
(zcache_frontswap_get_page+0x90/0xa0)
Mar 12 21:20:28 ac100 kernel: [  118.265843] [<c035fd9c>] 
(zcache_frontswap_get_page+0x90/0xa0) from [<c013037c>] 
(__frontswap_get_page+0x90/0xd8)
Mar 12 21:20:28 ac100 kernel: [  118.265934] [<c013037c>] 
(__frontswap_get_page+0x90/0xd8) from [<c012c3d8>] (swap_readpage+0x44/0xdc)
Mar 12 21:20:28 ac100 kernel: [  118.266020] [<c012c3d8>] 
(swap_readpage+0x44/0xdc) from [<c012c9c8>] (read_swap_cache_async+0xc8/0x11c)
Mar 12 21:20:28 ac100 kernel: [  118.266106] [<c012c9c8>] 
(read_swap_cache_async+0xc8/0x11c) from [<c012cab0>] 
(swapin_readahead+0x94/0x9c)
Mar 12 21:20:28 ac100 kernel: [  118.266204] [<c012cab0>] 
(swapin_readahead+0x94/0x9c) from [<c011ff20>] (handle_pte_fault+0x2f4/0x6c4)
Mar 12 21:20:28 ac100 kernel: [  118.266292] [<c011ff20>] 
(handle_pte_fault+0x2f4/0x6c4) from [<c01203a8>] (handle_mm_fault+0xb8/0xd0)
Mar 12 21:20:28 ac100 kernel: [  118.266382] [<c01203a8>] 
(handle_mm_fault+0xb8/0xd0) from [<c005f114>] (do_page_fault+0xf8/0x28c)
Mar 12 21:20:28 ac100 kernel: [  118.266483] [<c005f114>] 
(do_page_fault+0xf8/0x28c) from [<c004e170>] (do_DataAbort+0x44/0xa8)
Mar 12 21:20:28 ac100 kernel: [  118.266588] [<c004e170>] 
(do_DataAbort+0x44/0xa8) from [<c0053d64>] (ret_from_exception+0x0/0x10)
Mar 12 21:20:28 ac100 kernel: [  118.266645] Exception stack(0xdb86dfb0 to 
0xdb86dff8)
Mar 12 21:20:28 ac100 kernel: [  118.266697] dfa0:                                     
b6f4cf68 b6f4e658 00000001 b6f4cee8
Mar 12 21:20:28 ac100 kernel: [  118.266769] dfc0: 00000011 b6f4c8e8 b6f806ac 
b6f4b9c0 00000001 b6f4b988 bec64998 00000011
Mar 12 21:20:28 ac100 kernel: [  118.266835] dfe0: b6f4cf68 bec64948 b6f2fc07 
b6f2fc66 200f0030 ffffffff
Mar 12 21:20:28 ac100 kernel: [  118.266885] ---[ end trace 3a9bf99eb36a0d77 
]---
Mar 12 21:20:28 ac100 kernel: [  118.266940] kernel BUG at 
/home/marc/ac100/marvin24s-kernel/drivers/staging/zcache/zcache-main.c:761!
Mar 12 21:20:28 ac100 kernel: [  118.276268] Unable to handle kernel NULL 
pointer dereference at virtual address 00000000
Mar 12 21:20:28 ac100 kernel: [  118.284396] pgd = db2b4000
Mar 12 21:20:28 ac100 kernel: [  118.287123] [00000000] *pgd=00000000
Mar 12 21:20:28 ac100 kernel: [  118.290746] Internal error: Oops: 805 [#1] 
SMP
Mar 12 21:20:28 ac100 kernel: [  118.295212] Modules linked in: nls_iso8859_1 
nls_cp437 vfat fat fuse zram(C) snd_soc_alc5632 snd_seq_dummy rt2800usb 
rt2800lib rt2x00usb rt2x00lib snd_soc_tegra_alc5632 mac80211 snd_seq_oss 
snd_soc_tegra_pcm snd_soc_tegra_i2s snd_seq_midi_event snd_soc_tegra_das 
snd_soc_core snd_pcm_oss snd_mixer_oss uvcvideo videodev cfg80211 tegra_wdt 
snd_seq cdc_ether usbnet snd_pcm cdc_wdm cdc_acm mii snd_seq_device lm90 
snd_timer snd soundcore snd_page_alloc snd_soc_tegra_utils
Mar 12 21:20:28 ac100 kernel: [  118.337316] CPU: 1    Tainted: G        WC   
(3.0.19 #29)
Mar 12 21:20:28 ac100 kernel: [  118.342765] PC is at __bug+0x2c/0x38
Mar 12 21:20:28 ac100 kernel: [  118.346387] LR is at 
console_unlock+0x1ac/0x1c8
Mar 12 21:20:28 ac100 kernel: [  118.350958] pc : [<c00576bc>]    lr : 
[<c0086c70>]    psr: 600f0193
Mar 12 21:20:28 ac100 kernel: [  118.350985] sp : db86dc50  ip : db86db68  fp 
: db86dc5c
Mar 12 21:20:28 ac100 kernel: [  118.362488] r10: 00000001  r9 : 00000000  r8 
: 00000018
Mar 12 21:20:28 ac100 kernel: [  118.367744] r7 : ffffffea  r6 : 0ca61001  r5 : 
d572b000  r4 : c06a8304
Mar 12 21:20:28 ac100 kernel: [  118.374302] r3 : 00000000  r2 : 271aed0f  r1 
: 00000001  r0 : 0000006f
Mar 12 21:20:28 ac100 kernel: [  118.380864] Flags: nZCv  IRQs off  FIQs on  
Mode SVC_32  ISA ARM  Segment user
Mar 12 21:20:28 ac100 kernel: [  118.388122] Control: 10c5387d  Table: 
1b2b404a  DAC: 00000015
Mar 12 21:20:28 ac100 kernel: [  118.393901] Process init (pid: 1, stack limit 
= 0xdb86c2f8)
Mar 12 21:20:28 ac100 kernel: [  118.399503] Stack: (0xdb86dc50 to 0xdb86e000)
Mar 12 21:20:28 ac100 kernel: [  118.403898] dc40:                                     
db86dc8c db86dc60 c035ed80 c005769c
Mar 12 21:20:28 ac100 kernel: [  118.412128] dc60: db86dc6c c0104dd8 00000000 
00001000 db86dd18 daed1794 daed1000 0ca61001
Mar 12 21:20:28 ac100 kernel: [  118.420359] dc80: db86dcd4 db86dc90 c0361028 
c035ed20 daed1000 db86dd18 00000018 00000000
Mar 12 21:20:28 ac100 kernel: [  118.428586] dca0: 00000000 c095c560 ffffffff 
000f0113 daed1000 db86dd18 c095c560 00000018
Mar 12 21:20:28 ac100 kernel: [  118.436813] dcc0: 00000000 00000000 db86dd14 
db86dcd8 c035fc98 c0360ed4 db86dcec 00000000
Mar 12 21:20:28 ac100 kernel: [  118.445038] dce0: 00000000 000200da 00000000 
00001000 00000000 c095c560 0000183f 0000003f
Mar 12 21:20:28 ac100 kernel: [  118.453266] dd00: 000000d0 c095c560 db86dd64 
db86dd18 c035fd9c c035fc18 0000003f 00000000
Mar 12 21:20:28 ac100 kernel: [  118.461488] dd20: 00000000 00000000 00000000 
00000000 00000000 00000000 00000000 00000000
Mar 12 21:20:28 ac100 kernel: [  118.469716] dd40: 00000000 00000000 c05f9798 
effffff0 000000c1 000200da db86dd7c db86dd68
Mar 12 21:20:28 ac100 kernel: [  118.477944] dd60: c013037c c035fd18 c095c560 
00000000 db86dd94 db86dd80 c012c3d8 c01302f8
Mar 12 21:20:28 ac100 kernel: [  118.486171] dd80: 0000183f 00000000 db86ddc4 
db86dd98 c012c9c8 c012c3a0 b6f4e000 db2f5498
Mar 12 21:20:28 ac100 kernel: [  118.494399] dda0: 000200da 0000183f b6f4e000 
db2f4d40 00000000 00000000 db86ddf4 db86ddc8
Mar 12 21:20:28 ac100 kernel: [  118.502628] ddc0: c012cab0 c012c90c c0699498 
db2f4d40 db2f4d40 db2b4000 db2f5498 b6f4e000
Mar 12 21:20:28 ac100 kernel: [  118.510857] dde0: 00000000 00307e00 db86de44 
db86ddf8 c011ff20 c012ca28 00000000 c00d5918
Mar 12 21:20:28 ac100 kernel: [  118.519086] de00: c05d0020 db3ec580 db2f4d74 
db2f4d74 0000184e 0000183f db86de34 b6f4e000
Mar 12 21:20:28 ac100 kernel: [  118.527316] de20: db2b4000 000005b7 db2b6db8 
db2f4d40 db2f5498 00000000 db86de7c db86de48
Mar 12 21:20:28 ac100 kernel: [  118.535544] de40: c01203a8 c011fc38 db2b6db8 
00000000 c025bf1c db2f5498 db86dfb0 db857a80
Mar 12 21:20:28 ac100 kernel: [  118.543774] de60: b6f4e670 db2f4d40 db2f4d78 
00000017 db86df04 db86de80 c005f114 c01202fc
Mar 12 21:20:28 ac100 kernel: [  118.552001] de80: db86df70 00000000 00000000 
db86df58 db86df3c db86dea0 c01356b0 c013e99c
Mar 12 21:20:28 ac100 kernel: [  118.560223] dea0: 00000000 00000000 00000000 
00000000 00000000 00000000 001a2000 00000000
Mar 12 21:20:28 ac100 kernel: [  118.568449] dec0: 05802400 00000000 00001198 
00000000 00004ccd 00000000 0091aee5 00000017
Mar 12 21:20:28 ac100 kernel: [  118.576678] dee0: c05e4dec b6f4e670 db86dfb0 
00000001 b6f4b988 bec64998 db86dfac db86df08
Mar 12 21:20:28 ac100 kernel: [  118.584909] df00: c004e170 c005f028 db86df58 
db857a80 db86df54 db86df20 c0089b14 c00a5f18
Mar 12 21:20:28 ac100 kernel: [  118.593134] df20: bec64c24 00000001 00000001 
bec649d0 00000000 00000003 00000000 c008aa50
Mar 12 21:20:28 ac100 kernel: [  118.601362] df40: 00000000 bec649d0 db86dfa4 
db86df58 c008aa50 c00a2394 00000003 0000000f
Mar 12 21:20:28 ac100 kernel: [  118.609590] df60: 00000000 bec649d0 00000000 
00000000 00000000 db857a80 c0088748 00100100
Mar 12 21:20:28 ac100 kernel: [  118.617817] df80: 00200200 00000000 00000000 
0000000f ffffffff b6f4c8e8 b6f806ac b6f4b9c0
Mar 12 21:20:28 ac100 kernel: [  118.626044] dfa0: 00000000 db86dfb0 c0053d64 
c004e138 b6f4cf68 b6f4e658 00000001 b6f4cee8
Mar 12 21:20:28 ac100 kernel: [  118.634273] dfc0: 00000011 b6f4c8e8 b6f806ac 
b6f4b9c0 00000001 b6f4b988 bec64998 00000011
Mar 12 21:20:28 ac100 kernel: [  118.642503] dfe0: b6f4cf68 bec64948 b6f2fc07 
b6f2fc66 200f0030 ffffffff 86950214 104188c8
Mar 12 21:20:28 ac100 kernel: [  118.650758] [<c00576bc>] (__bug+0x2c/0x38) 
from [<c035ed80>] (zcache_pampd_get_data+0x6c/0x14c)
Mar 12 21:20:28 ac100 kernel: [  118.659532] [<c035ed80>] 
(zcache_pampd_get_data+0x6c/0x14c) from [<c0361028>] (tmem_get+0x160/0x19c)
Mar 12 21:20:28 ac100 kernel: [  118.668733] [<c0361028>] 
(tmem_get+0x160/0x19c) from [<c035fc98>] 
(zcache_get_page.constprop.16+0x8c/0xa8)
Mar 12 21:20:28 ac100 kernel: [  118.678449] [<c035fc98>] 
(zcache_get_page.constprop.16+0x8c/0xa8) from [<c035fd9c>] 
(zcache_frontswap_get_page+0x90/0xa0)
Mar 12 21:20:28 ac100 kernel: [  118.689483] [<c035fd9c>] 
(zcache_frontswap_get_page+0x90/0xa0) from [<c013037c>] 
(__frontswap_get_page+0x90/0xd8)
Mar 12 21:20:28 ac100 kernel: [  118.699814] [<c013037c>] 
(__frontswap_get_page+0x90/0xd8) from [<c012c3d8>] (swap_readpage+0x44/0xdc)
Mar 12 21:20:28 ac100 kernel: [  118.709100] [<c012c3d8>] 
(swap_readpage+0x44/0xdc) from [<c012c9c8>] (read_swap_cache_async+0xc8/0x11c)
Mar 12 21:20:28 ac100 kernel: [  118.718560] [<c012c9c8>] 
(read_swap_cache_async+0xc8/0x11c) from [<c012cab0>] 
(swapin_readahead+0x94/0x9c)
Mar 12 21:20:28 ac100 kernel: [  118.728282] [<c012cab0>] 
(swapin_readahead+0x94/0x9c) from [<c011ff20>] (handle_pte_fault+0x2f4/0x6c4)
Mar 12 21:20:28 ac100 kernel: [  118.737654] [<c011ff20>] 
(handle_pte_fault+0x2f4/0x6c4) from [<c01203a8>] (handle_mm_fault+0xb8/0xd0)
Mar 12 21:20:28 ac100 kernel: [  118.746939] [<c01203a8>] 
(handle_mm_fault+0xb8/0xd0) from [<c005f114>] (do_page_fault+0xf8/0x28c)
Mar 12 21:20:28 ac100 kernel: [  118.755884] [<c005f114>] 
(do_page_fault+0xf8/0x28c) from [<c004e170>] (do_DataAbort+0x44/0xa8)
Mar 12 21:20:28 ac100 kernel: [  118.764574] [<c004e170>] 
(do_DataAbort+0x44/0xa8) from [<c0053d64>] (ret_from_exception+0x0/0x10)
Mar 12 21:20:28 ac100 kernel: [  118.773481] Exception stack(0xdb86dfb0 to 
0xdb86dff8)
Mar 12 21:20:28 ac100 kernel: [  118.778571] dfa0:                                     
b6f4cf68 b6f4e658 00000001 b6f4cee8
Mar 12 21:20:28 ac100 kernel: [  118.786802] dfc0: 00000011 b6f4c8e8 b6f806ac 
b6f4b9c0 00000001 b6f4b988 bec64998 00000011
Mar 12 21:20:28 ac100 kernel: [  118.795026] dfe0: b6f4cf68 bec64948 b6f2fc07 
b6f2fc66 200f0030 ffffffff
Mar 12 21:20:28 ac100 kernel: [  118.801690] Code: e59f0010 e1a01003 eb0fb47d 
e3a03000 (e5833000) 
Mar 12 21:20:28 ac100 kernel: [  118.808264] ---[ end trace 3a9bf99eb36a0d78 
]---
Mar 12 21:20:28 ac100 kernel: [  118.826844] ------------[ cut here 
]------------
Mar 12 21:20:28 ac100 kernel: [  118.831491] WARNING: at 
/home/marc/ac100/marvin24s-kernel/drivers/staging/zcache/zcache-main.c:732 
zcache_pampd_free+0x90/0x14c()
Mar 12 21:20:28 ac100 kernel: [  118.843128] Modules linked in: nls_iso8859_1 
nls_cp437 vfat fat fuse zram(C) snd_soc_alc5632 snd_seq_dummy rt2800usb 
rt2800lib rt2x00usb rt2x00lib snd_soc_tegra_alc5632 mac80211 snd_seq_oss 
snd_soc_tegra_pcm snd_soc_tegra_i2s snd_seq_midi_event snd_soc_tegra_das 
snd_soc_core snd_pcm_oss snd_mixer_oss uvcvideo videodev cfg80211 tegra_wdt 
snd_seq cdc_ether usbnet snd_pcm cdc_wdm cdc_acm mii snd_seq_device lm90 
snd_timer snd soundcore snd_page_alloc snd_soc_tegra_utils
Mar 12 21:20:28 ac100 kernel: [  118.884648] [<c005acac>] 
(unwind_backtrace+0x0/0xec) from [<c0444314>] (dump_stack+0x20/0x24)
Mar 12 21:20:28 ac100 kernel: [  118.893177] [<c0444314>] 
(dump_stack+0x20/0x24) from [<c00860bc>] (warn_slowpath_common+0x5c/0x74)
Mar 12 21:20:28 ac100 kernel: [  118.902131] [<c00860bc>] 
(warn_slowpath_common+0x5c/0x74) from [<c0086100>] 
(warn_slowpath_null+0x2c/0x34)
Mar 12 21:20:28 ac100 kernel: [  118.911784] [<c0086100>] 
(warn_slowpath_null+0x2c/0x34) from [<c035ea90>] 
(zcache_pampd_free+0x90/0x14c)
Mar 12 21:20:28 ac100 kernel: [  118.921259] [<c035ea90>] 
(zcache_pampd_free+0x90/0x14c) from [<c03610f0>] (tmem_flush_page+0x8c/0xe8)
Mar 12 21:20:28 ac100 kernel: [  118.930470] [<c03610f0>] 
(tmem_flush_page+0x8c/0xe8) from [<c035fe18>] 
(zcache_flush_page.constprop.17+0x6c/0x9c)
Mar 12 21:20:28 ac100 kernel: [  118.940720] [<c035fe18>] 
(zcache_flush_page.constprop.17+0x6c/0x9c) from [<c035ff0c>] 
(zcache_frontswap_flush_page+0x70/0x7c)
Mar 12 21:20:28 ac100 kernel: [  118.952020] [<c035ff0c>] 
(zcache_frontswap_flush_page+0x70/0x7c) from [<c0130440>] 
(__frontswap_invalidate_page+0x7c/0xe4)
Mar 12 21:20:28 ac100 kernel: [  118.963055] [<c0130440>] 
(__frontswap_invalidate_page+0x7c/0xe4) from [<c012d38c>] 
(swap_entry_free+0x11c/0x158)
Mar 12 21:20:28 ac100 kernel: [  118.973220] [<c012d38c>] 
(swap_entry_free+0x11c/0x158) from [<c012ed70>] 
(free_swap_and_cache+0x30/0xfc)
Mar 12 21:20:28 ac100 kernel: [  118.982695] [<c012ed70>] 
(free_swap_and_cache+0x30/0xfc) from [<c011f02c>] (unmap_vmas+0x3b4/0x5ac)
Mar 12 21:20:28 ac100 kernel: [  118.991736] [<c011f02c>] 
(unmap_vmas+0x3b4/0x5ac) from [<c0123614>] (exit_mmap+0x13c/0x254)
Mar 12 21:20:28 ac100 kernel: [  119.000081] [<c0123614>] 
(exit_mmap+0x13c/0x254) from [<c0083b38>] (mmput+0x54/0x11c)
Mar 12 21:20:28 ac100 kernel: [  119.007908] [<c0083b38>] (mmput+0x54/0x11c) 
from [<c0088488>] (exit_mm+0x16c/0x178)
Mar 12 21:20:28 ac100 kernel: [  119.015573] [<c0088488>] 
(exit_mm+0x16c/0x178) from [<c008a088>] (do_exit+0x218/0x710)
Mar 12 21:20:28 ac100 kernel: [  119.023489] [<c008a088>] 
(do_exit+0x218/0x710) from [<c0057c8c>] (die+0x2e0/0x338)
Mar 12 21:20:28 ac100 kernel: [  119.031057] [<c0057c8c>] (die+0x2e0/0x338) 
from [<c04443bc>] (__do_kernel_fault.part.3+0x64/0x84)
Mar 12 21:20:28 ac100 kernel: [  119.039925] [<c04443bc>] 
(__do_kernel_fault.part.3+0x64/0x84) from [<c005f28c>] 
(do_page_fault+0x270/0x28c)
Mar 12 21:20:28 ac100 kernel: [  119.049656] [<c005f28c>] 
(do_page_fault+0x270/0x28c) from [<c005f364>] (do_translation_fault+0x2c/0xb0)
Mar 12 21:20:28 ac100 kernel: [  119.059046] [<c005f364>] 
(do_translation_fault+0x2c/0xb0) from [<c004e170>] (do_DataAbort+0x44/0xa8)
Mar 12 21:20:28 ac100 kernel: [  119.068175] [<c004e170>] 
(do_DataAbort+0x44/0xa8) from [<c005392c>] (__dabt_svc+0x4c/0x60)
Mar 12 21:20:28 ac100 kernel: [  119.076427] Exception stack(0xdb86dc08 to 
0xdb86dc50)
Mar 12 21:20:28 ac100 kernel: [  119.081470] dc00:                   0000006f 
00000001 271aed0f 00000000 c06a8304 d572b000
Mar 12 21:20:28 ac100 kernel: [  119.089637] dc20: 0ca61001 ffffffea 00000018 
00000000 00000001 db86dc5c db86db68 db86dc50
Mar 12 21:20:28 ac100 kernel: [  119.097800] dc40: c0086c70 c00576bc 600f0193 
ffffffff
Mar 12 21:20:28 ac100 kernel: [  119.102849] [<c005392c>] 
(__dabt_svc+0x4c/0x60) from [<c00576bc>] (__bug+0x2c/0x38)
Mar 12 21:20:28 ac100 kernel: [  119.110498] [<c00576bc>] (__bug+0x2c/0x38) 
from [<c035ed80>] (zcache_pampd_get_data+0x6c/0x14c)
Mar 12 21:20:28 ac100 kernel: [  119.119189] [<c035ed80>] 
(zcache_pampd_get_data+0x6c/0x14c) from [<c0361028>] (tmem_get+0x160/0x19c)
Mar 12 21:20:28 ac100 kernel: [  119.128313] [<c0361028>] 
(tmem_get+0x160/0x19c) from [<c035fc98>] 
(zcache_get_page.constprop.16+0x8c/0xa8)
Mar 12 21:20:28 ac100 kernel: [  119.137957] [<c035fc98>] 
(zcache_get_page.constprop.16+0x8c/0xa8) from [<c035fd9c>] 
(zcache_frontswap_get_page+0x90/0xa0)
Mar 12 21:20:28 ac100 kernel: [  119.148904] [<c035fd9c>] 
(zcache_frontswap_get_page+0x90/0xa0) from [<c013037c>] 
(__frontswap_get_page+0x90/0xd8)
Mar 12 21:20:28 ac100 kernel: [  119.159156] [<c013037c>] 
(__frontswap_get_page+0x90/0xd8) from [<c012c3d8>] (swap_readpage+0x44/0xdc)
Mar 12 21:20:28 ac100 kernel: [  119.168368] [<c012c3d8>] 
(swap_readpage+0x44/0xdc) from [<c012c9c8>] (read_swap_cache_async+0xc8/0x11c)
Mar 12 21:20:28 ac100 kernel: [  119.177753] [<c012c9c8>] 
(read_swap_cache_async+0xc8/0x11c) from [<c012cab0>] 
(swapin_readahead+0x94/0x9c)
Mar 12 21:20:28 ac100 kernel: [  119.187398] [<c012cab0>] 
(swapin_readahead+0x94/0x9c) from [<c011ff20>] (handle_pte_fault+0x2f4/0x6c4)
Mar 12 21:20:28 ac100 kernel: [  119.196696] [<c011ff20>] 
(handle_pte_fault+0x2f4/0x6c4) from [<c01203a8>] (handle_mm_fault+0xb8/0xd0)
Mar 12 21:20:28 ac100 kernel: [  119.205905] [<c01203a8>] 
(handle_mm_fault+0xb8/0xd0) from [<c005f114>] (do_page_fault+0xf8/0x28c)
Mar 12 21:20:28 ac100 kernel: [  119.214769] [<c005f114>] 
(do_page_fault+0xf8/0x28c) from [<c004e170>] (do_DataAbort+0x44/0xa8)
Mar 12 21:20:28 ac100 kernel: [  119.223375] [<c004e170>] 
(do_DataAbort+0x44/0xa8) from [<c0053d64>] (ret_from_exception+0x0/0x10)
Mar 12 21:20:28 ac100 kernel: [  119.232231] Exception stack(0xdb86dfb0 to 
0xdb86dff8)
Mar 12 21:20:28 ac100 kernel: [  119.237273] dfa0:                                     
b6f4cf68 b6f4e658 00000001 b6f4cee8
Mar 12 21:20:28 ac100 kernel: [  119.245441] dfc0: 00000011 b6f4c8e8 b6f806ac 
b6f4b9c0 00000001 b6f4b988 bec64998 00000011
Mar 12 21:20:28 ac100 kernel: [  119.253606] dfe0: b6f4cf68 bec64948 b6f2fc07 
b6f2fc66 200f0030 ffffffff
Mar 12 21:20:28 ac100 kernel: [  119.260209] ---[ end trace 3a9bf99eb36a0d79 
]---
Mar 12 21:20:28 ac100 kernel: [  119.264943] ------------[ cut here 
]------------
Mar 12 21:20:29 ac100 kernel: [  119.269578] WARNING: at 
/home/marc/ac100/marvin24s-kernel/drivers/staging/zcache/zcache-main.c:732 
zcache_pampd_free+0x90/0x14c()
Mar 12 21:20:29 ac100 kernel: [  119.281213] Modules linked in: nls_iso8859_1 
nls_cp437 vfat fat fuse zram(C) snd_soc_alc5632 snd_seq_dummy rt2800usb 
rt2800lib rt2x00usb rt2x00lib snd_soc_tegra_alc5632 mac80211 snd_seq_oss 
snd_soc_tegra_pcm snd_soc_tegra_i2s snd_seq_midi_event snd_soc_tegra_das 
snd_soc_core snd_pcm_oss snd_mixer_oss uvcvideo videodev cfg80211 tegra_wdt 
snd_seq cdc_ether usbnet snd_pcm cdc_wdm cdc_acm mii snd_seq_device lm90 
snd_timer snd soundcore snd_page_alloc snd_soc_tegra_utils
Mar 12 21:20:29 ac100 kernel: [  119.322726] [<c005acac>] 
(unwind_backtrace+0x0/0xec) from [<c0444314>] (dump_stack+0x20/0x24)
Mar 12 21:20:29 ac100 kernel: [  119.331253] [<c0444314>] 
(dump_stack+0x20/0x24) from [<c00860bc>] (warn_slowpath_common+0x5c/0x74)
Mar 12 21:20:29 ac100 kernel: [  119.340205] [<c00860bc>] 
(warn_slowpath_common+0x5c/0x74) from [<c0086100>] 
(warn_slowpath_null+0x2c/0x34)
Mar 12 21:20:29 ac100 kernel: [  119.349855] [<c0086100>] 
(warn_slowpath_null+0x2c/0x34) from [<c035ea90>] 
(zcache_pampd_free+0x90/0x14c)
Mar 12 21:20:29 ac100 kernel: [  119.359329] [<c035ea90>] 
(zcache_pampd_free+0x90/0x14c) from [<c03610f0>] (tmem_flush_page+0x8c/0xe8)
Mar 12 21:20:29 ac100 kernel: [  119.368540] [<c03610f0>] 
(tmem_flush_page+0x8c/0xe8) from [<c035fe18>] 
(zcache_flush_page.constprop.17+0x6c/0x9c)
Mar 12 21:20:29 ac100 kernel: [  119.378794] [<c035fe18>] 
(zcache_flush_page.constprop.17+0x6c/0x9c) from [<c035ff0c>] 
(zcache_frontswap_flush_page+0x70/0x7c)
Mar 12 21:20:29 ac100 kernel: [  119.390096] [<c035ff0c>] 
(zcache_frontswap_flush_page+0x70/0x7c) from [<c0130440>] 
(__frontswap_invalidate_page+0x7c/0xe4)
Mar 12 21:20:29 ac100 kernel: [  119.401133] [<c0130440>] 
(__frontswap_invalidate_page+0x7c/0xe4) from [<c012d38c>] 
(swap_entry_free+0x11c/0x158)
Mar 12 21:20:29 ac100 kernel: [  119.411300] [<c012d38c>] 
(swap_entry_free+0x11c/0x158) from [<c012ed70>] 
(free_swap_and_cache+0x30/0xfc)
Mar 12 21:20:29 ac100 kernel: [  119.420774] [<c012ed70>] 
(free_swap_and_cache+0x30/0xfc) from [<c011f02c>] (unmap_vmas+0x3b4/0x5ac)
Mar 12 21:20:29 ac100 kernel: [  119.429815] [<c011f02c>] 
(unmap_vmas+0x3b4/0x5ac) from [<c0123614>] (exit_mmap+0x13c/0x254)
Mar 12 21:20:29 ac100 kernel: [  119.438161] [<c0123614>] 
(exit_mmap+0x13c/0x254) from [<c0083b38>] (mmput+0x54/0x11c)
Mar 12 21:20:29 ac100 kernel: [  119.445987] [<c0083b38>] (mmput+0x54/0x11c) 
from [<c0088488>] (exit_mm+0x16c/0x178)
Mar 12 21:20:29 ac100 kernel: [  119.453638] [<c0088488>] 
(exit_mm+0x16c/0x178) from [<c008a088>] (do_exit+0x218/0x710)
Mar 12 21:20:29 ac100 kernel: [  119.461549] [<c008a088>] 
(do_exit+0x218/0x710) from [<c0057c8c>] (die+0x2e0/0x338)
Mar 12 21:20:29 ac100 kernel: [  119.469113] [<c0057c8c>] (die+0x2e0/0x338) 
from [<c04443bc>] (__do_kernel_fault.part.3+0x64/0x84)
Mar 12 21:20:29 ac100 kernel: [  119.477982] [<c04443bc>] 
(__do_kernel_fault.part.3+0x64/0x84) from [<c005f28c>] 
(do_page_fault+0x270/0x28c)
Mar 12 21:20:29 ac100 kernel: [  119.487715] [<c005f28c>] 
(do_page_fault+0x270/0x28c) from [<c005f364>] (do_translation_fault+0x2c/0xb0)
Mar 12 21:20:29 ac100 kernel: [  119.497105] [<c005f364>] 
(do_translation_fault+0x2c/0xb0) from [<c004e170>] (do_DataAbort+0x44/0xa8)
Mar 12 21:20:29 ac100 kernel: [  119.506236] [<c004e170>] 
(do_DataAbort+0x44/0xa8) from [<c005392c>] (__dabt_svc+0x4c/0x60)
Mar 12 21:20:29 ac100 kernel: [  119.514486] Exception stack(0xdb86dc08 to 
0xdb86dc50)
Mar 12 21:20:29 ac100 kernel: [  119.519530] dc00:                   0000006f 
00000001 271aed0f 00000000 c06a8304 d572b000
Mar 12 21:20:29 ac100 kernel: [  119.527698] dc20: 0ca61001 ffffffea 00000018 
00000000 00000001 db86dc5c db86db68 db86dc50
Mar 12 21:20:29 ac100 kernel: [  119.535862] dc40: c0086c70 c00576bc 600f0193 
ffffffff
Mar 12 21:20:29 ac100 kernel: [  119.540910] [<c005392c>] 
(__dabt_svc+0x4c/0x60) from [<c00576bc>] (__bug+0x2c/0x38)
Mar 12 21:20:29 ac100 kernel: [  119.548560] [<c00576bc>] (__bug+0x2c/0x38) 
from [<c035ed80>] (zcache_pampd_get_data+0x6c/0x14c)
Mar 12 21:20:29 ac100 kernel: [  119.557251] [<c035ed80>] 
(zcache_pampd_get_data+0x6c/0x14c) from [<c0361028>] (tmem_get+0x160/0x19c)
Mar 12 21:20:29 ac100 kernel: [  119.566375] [<c0361028>] 
(tmem_get+0x160/0x19c) from [<c035fc98>] 
(zcache_get_page.constprop.16+0x8c/0xa8)
Mar 12 21:20:29 ac100 kernel: [  119.576018] [<c035fc98>] 
(zcache_get_page.constprop.16+0x8c/0xa8) from [<c035fd9c>] 
(zcache_frontswap_get_page+0x90/0xa0)
Mar 12 21:20:29 ac100 kernel: [  119.586964] [<c035fd9c>] 
(zcache_frontswap_get_page+0x90/0xa0) from [<c013037c>] 
(__frontswap_get_page+0x90/0xd8)
Mar 12 21:20:29 ac100 kernel: [  119.597216] [<c013037c>] 
(__frontswap_get_page+0x90/0xd8) from [<c012c3d8>] (swap_readpage+0x44/0xdc)
Mar 12 21:20:29 ac100 kernel: [  119.606427] [<c012c3d8>] 
(swap_readpage+0x44/0xdc) from [<c012c9c8>] (read_swap_cache_async+0xc8/0x11c)
Mar 12 21:20:29 ac100 kernel: [  119.615812] [<c012c9c8>] 
(read_swap_cache_async+0xc8/0x11c) from [<c012cab0>] 
(swapin_readahead+0x94/0x9c)
Mar 12 21:20:29 ac100 kernel: [  119.625457] [<c012cab0>] 
(swapin_readahead+0x94/0x9c) from [<c011ff20>] (handle_pte_fault+0x2f4/0x6c4)
Mar 12 21:20:29 ac100 kernel: [  119.634755] [<c011ff20>] 
(handle_pte_fault+0x2f4/0x6c4) from [<c01203a8>] (handle_mm_fault+0xb8/0xd0)
Mar 12 21:20:29 ac100 kernel: [  119.643966] [<c01203a8>] 
(handle_mm_fault+0xb8/0xd0) from [<c005f114>] (do_page_fault+0xf8/0x28c)
Mar 12 21:20:29 ac100 kernel: [  119.652830] [<c005f114>] 
(do_page_fault+0xf8/0x28c) from [<c004e170>] (do_DataAbort+0x44/0xa8)
Mar 12 21:20:29 ac100 kernel: [  119.661434] [<c004e170>] 
(do_DataAbort+0x44/0xa8) from [<c0053d64>] (ret_from_exception+0x0/0x10)
Mar 12 21:20:29 ac100 kernel: [  119.670289] Exception stack(0xdb86dfb0 to 
0xdb86dff8)
Mar 12 21:20:29 ac100 kernel: [  119.675331] dfa0:                                     
b6f4cf68 b6f4e658 00000001 b6f4cee8
Mar 12 21:20:29 ac100 kernel: [  119.683497] dfc0: 00000011 b6f4c8e8 b6f806ac 
b6f4b9c0 00000001 b6f4b988 bec64998 00000011
Mar 12 21:20:29 ac100 kernel: [  119.691661] dfe0: b6f4cf68 bec64948 b6f2fc07 
b6f2fc66 200f0030 ffffffff
Mar 12 21:20:29 ac100 kernel: [  119.698262] ---[ end trace 3a9bf99eb36a0d7a 
]---

It's possible that the 3.0 doesn't like the driver from linux-next, but maybe 
you have some other idea.

Thanks!

Marc

