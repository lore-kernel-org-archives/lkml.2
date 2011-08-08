Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab1HHGOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 02:14:33 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34946 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1HHGOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 02:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1108080817050.25955@tiger>
References: <20110805010038.GA18148@redhat.com>
	<20110805084614.GA1588@x4.trippels.de>
	<CAOJsxLEMf8SbSmJv5u6GZtq_OYH3fpmomT-ioWXQGp83veK7wQ@mail.gmail.com>
	<alpine.DEB.2.00.1108051131440.28580@router.home>
	<20110805163948.GA11113@redhat.com>
	<alpine.DEB.2.00.1108051146180.28580@router.home>
	<20110805165119.GA11593@redhat.com>
	<alpine.DEB.2.00.1108051158400.28580@router.home>
	<20110805171607.GA11703@redhat.com>
	<alpine.DEB.2.00.1108051312090.28580@router.home>
	<20110805182008.GA22314@redhat.com>
	<CA+55aFwGSJM6g+YXfy_Oyb0OpQP5kH=OxCR-pnBk7RUshL+mXg@mail.gmail.com>
	<alpine.DEB.2.00.1108072155240.9480@tiger>
	<CA+55aFzdp+7+AcCFbx3dCkfqERzYvOZG3c3SUuNAw+X0MJ8iNw@mail.gmail.com>
	<alpine.DEB.2.00.1108080817050.25955@tiger>
Date: Mon, 8 Aug 2011 14:14:30 +0800
Message-ID: <CAJn8CcGqQwLPoweUN3fed2j0SorZO08NPpxeH70e+rogVsvhAw@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
From: Xiaotian Feng <xtfeng@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 1:18 PM, Pekka Enberg <penberg@kernel.org> wrote:
> Hi Linus,
>
> On Sun, Aug 7, 2011 at 11:58 AM, Pekka Enberg <penberg@kernel.org> wrote:
>>>
>>> Christoph, I've been reading the code and spotted two potential issues in
>>> __slab_free(). The first one seems like an off-by-one where our
>>> comparison
>>> in deactivate_slab() doesn't match __slab_free.
>>>
>>> The other one is remove_full() call in __slab_free() that can get called
>>> even if cache debugging is not enabled.
>>>
>>> Hmm?
>
> On Sun, 7 Aug 2011, Linus Torvalds wrote:
>>
>> I'd like to do -rc1 today, regardless of whether this fixes things or
>> not (-rc1 is already a few days delayed).
>>
>> The patch seems to be a good fix, and a likely candidate for the
>> corruption. Commit log and sign-off? I assume you've given it some
>> testing, even if you couldn't reproduce the original issue?
>
> No, I haven't tested the patch myself but here's one in proper format in
> case someone wants to test it.

I applied it and I'm still seeing the corruption warning start from this :(

 [ 3674.255030] ------------[ cut here ]------------
 [ 3674.255040] WARNING: at lib/list_debug.c:53 __list_del_entry+0xa1/0xd0()
 [ 3674.255042] Hardware name: 42424XC
 [ 3674.255045] list_del corruption. prev->next should be
ffffea0000493420, but was ffffea0001ab0520
 [ 3674.255047] Modules linked in: ip6table_filter ip6_tables
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
iptable_filter ip_tables x_tables binfmt_misc bridge stp parport_pc
ppdev snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep
snd_pcm thinkpad_acpi arc4 cryptd aes_x86_64 aes_generic snd_seq_midi
i915 snd_rawmidi snd_seq_midi_event snd_seq joydev iwlagn btusb
snd_timer snd_seq_device drm_kms_helper bluetooth uvcvideo snd
videodev drm mac80211 cfg80211 i2c_algo_bit soundcore tpm_tis tpm
tpm_bios lp snd_page_alloc psmouse serio_raw v4l2_compat_ioctl32 nvram
video parport usbhid hid sdhci_pci firewire_ohci ahci libahci sdhci
firewire_core crc_itu_t e1000e
 [ 3674.255129] Pid: 3, comm: ksoftirqd/0 Not tainted 3.1.0-rc1+ #38
 [ 3674.255131] Call Trace:
 [ 3674.255138]  [<ffffffff8106db3f>] warn_slowpath_common+0x7f/0xc0
 [ 3674.255143]  [<ffffffff8106dc36>] warn_slowpath_fmt+0x46/0x50
 [ 3674.255147]  [<ffffffff81331851>] __list_del_entry+0xa1/0xd0
 [ 3674.255151]  [<ffffffff81331891>] list_del+0x11/0x40
 [ 3674.255156]  [<ffffffff81179631>] __slab_free+0x3d1/0x3e0
 [ 3674.255162]  [<ffffffff811c5b06>] ? bvec_free_bs+0x26/0x40
 [ 3674.255166]  [<ffffffff8117ab27>] ? kmem_cache_free+0x97/0x220
 [ 3674.255170]  [<ffffffff811c5b06>] ? bvec_free_bs+0x26/0x40
 [ 3674.255174]  [<ffffffff811c5b06>] ? bvec_free_bs+0x26/0x40
 [ 3674.255179]  [<ffffffff8117ac9f>] kmem_cache_free+0x20f/0x220
 [ 3674.255183]  [<ffffffff811c5b06>] bvec_free_bs+0x26/0x40
 [ 3674.255187]  [<ffffffff811c5b54>] bio_free+0x34/0x70
 [ 3674.255191]  [<ffffffff811c5ba5>] bio_fs_destructor+0x15/0x20
 [ 3674.255195]  [<ffffffff811c491b>] bio_put+0x2b/0x30
 [ 3674.255199]  [<ffffffff81244543>] ext4_end_bio+0x63/0x270
 [ 3674.255204]  [<ffffffff811c47cd>] bio_endio+0x1d/0x40
 [ 3674.255208]  [<ffffffff8130140b>] req_bio_endio.clone.35+0xab/0xf0
 [ 3674.255212]  [<ffffffff813043e4>] blk_update_request+0x104/0x5f0
 [ 3674.255216]  [<ffffffff81304679>] ? blk_update_request+0x399/0x5f0
 [ 3674.255220]  [<ffffffff81304904>] blk_update_bidi_request+0x34/0xa0
 [ 3674.255224]  [<ffffffff81304aef>] blk_end_bidi_request+0x2f/0x80
 [ 3674.255228]  [<ffffffff81304b80>] blk_end_request+0x10/0x20
 [ 3674.255233]  [<ffffffff8142ef8f>] scsi_io_completion+0xaf/0x630
 [ 3674.255238]  [<ffffffff814253b8>] scsi_finish_command+0xc8/0x130
 [ 3674.255242]  [<ffffffff8142edd7>] scsi_softirq_done+0x147/0x170
 [ 3674.255247]  [<ffffffff8130aeec>] blk_done_softirq+0x8c/0xa0
 [ 3674.255252]  [<ffffffff810761a4>] __do_softirq+0xd4/0x340
 [ 3674.255256]  [<ffffffff81076547>] run_ksoftirqd+0x137/0x210
 [ 3674.255260]  [<ffffffff81076410>] ? __do_softirq+0x340/0x340
 [ 3674.255264]  [<ffffffff81094b16>] kthread+0xb6/0xc0
 [ 3674.255269]  [<ffffffff81655a64>] kernel_thread_helper+0x4/0x10
 [ 3674.255274]  [<ffffffff8164b274>] ? retint_restore_args+0x13/0x13
 [ 3674.255279]  [<ffffffff81094a60>] ? __init_kthread_worker+0x70/0x70
 [ 3674.255283]  [<ffffffff81655a60>] ? gs_change+0x13/0x13


>
>                        Pekka
>
> From 85380c605764927576d6ef54e4e8a3354df05d47 Mon Sep 17 00:00:00 2001
> From: Pekka Enberg <penberg@kernel.org>
> Date: Mon, 8 Aug 2011 07:56:49 +0300
> Subject: [PATCH] slub: Fix partial and full list handling in __slab_free
>
> Dave Jones and Xiaotian Feng reported SLUB list corruption:
>
>  https://lkml.org/lkml/2011/8/4/375
>
>  https://lkml.org/lkml/2011/8/3/37
>
> While I haven't able to reproduce the issue, I spotted two problems in
> __slab_free() during code review:
>
>  - The ->nr_partial check in __slab_free() has an off-by-one bug
>    when compared to similar check in deactivate_slab()
>
>  - remove_full() is called even if cache debugging has not been enabled
>
> Reported-by: Dave Jones <davej@redhat.com>
> Reported-by: Xiaotian Feng <xtfeng@gmail.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>
> ---
>  mm/slub.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index eb5a8f9..cee8c20 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2368,7 +2368,7 @@ static void __slab_free(struct kmem_cache *s, struct
> page *page,
>        if (was_frozen)
>                stat(s, FREE_FROZEN);
>        else {
> -               if (unlikely(!inuse && n->nr_partial > s->min_partial))
> +               if (unlikely(!inuse && n->nr_partial >= s->min_partial))
>                         goto slab_empty;
>
>                /*
> @@ -2376,7 +2376,8 @@ static void __slab_free(struct kmem_cache *s, struct
> page *page,
>                 * then add it.
>                 */
>                if (unlikely(!prior)) {
> -                       remove_full(s, page);
> +                       if (kmem_cache_debug(s))
> +                               remove_full(s, page);
>                        add_partial(n, page, 0);
>                        stat(s, FREE_ADD_PARTIAL);
>                }
> --
> 1.7.0.4
>
>
