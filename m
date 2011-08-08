Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1HHGSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 02:18:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51482 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1HHGSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 02:18:45 -0400
MIME-Version: 1.0
In-Reply-To: <CAJn8CcGqQwLPoweUN3fed2j0SorZO08NPpxeH70e+rogVsvhAw@mail.gmail.com>
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
	<CAJn8CcGqQwLPoweUN3fed2j0SorZO08NPpxeH70e+rogVsvhAw@mail.gmail.com>
Date: Mon, 8 Aug 2011 09:18:44 +0300
X-Google-Sender-Auth: DxoNG9Rvzij3BhhSJThxJmiv2QE
Message-ID: <CAOJsxLGyoJjaqsDN8CLVAMF+h72tepSpaouGJ2diQ=FpMiJqdg@mail.gmail.com>
Subject: Re: list corruption in the last few days. (block ? crypto ?)
From: Pekka Enberg <penberg@kernel.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Christoph Lameter <cl@linux.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 8, 2011 at 9:14 AM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> On Mon, Aug 8, 2011 at 1:18 PM, Pekka Enberg <penberg@kernel.org> wrote:
>> Hi Linus,
>>
>> On Sun, Aug 7, 2011 at 11:58 AM, Pekka Enberg <penberg@kernel.org> wrote:
>>>>
>>>> Christoph, I've been reading the code and spotted two potential issues in
>>>> __slab_free(). The first one seems like an off-by-one where our
>>>> comparison
>>>> in deactivate_slab() doesn't match __slab_free.
>>>>
>>>> The other one is remove_full() call in __slab_free() that can get called
>>>> even if cache debugging is not enabled.
>>>>
>>>> Hmm?
>>
>> On Sun, 7 Aug 2011, Linus Torvalds wrote:
>>>
>>> I'd like to do -rc1 today, regardless of whether this fixes things or
>>> not (-rc1 is already a few days delayed).
>>>
>>> The patch seems to be a good fix, and a likely candidate for the
>>> corruption. Commit log and sign-off? I assume you've given it some
>>> testing, even if you couldn't reproduce the original issue?
>>
>> No, I haven't tested the patch myself but here's one in proper format in
>> case someone wants to test it.
>
> I applied it and I'm still seeing the corruption warning start from this :(
>
>  [ 3674.255030] ------------[ cut here ]------------
>  [ 3674.255040] WARNING: at lib/list_debug.c:53 __list_del_entry+0xa1/0xd0()
>  [ 3674.255042] Hardware name: 42424XC
>  [ 3674.255045] list_del corruption. prev->next should be
> ffffea0000493420, but was ffffea0001ab0520
>  [ 3674.255047] Modules linked in: ip6table_filter ip6_tables
> ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4
> xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp
> iptable_filter ip_tables x_tables binfmt_misc bridge stp parport_pc
> ppdev snd_hda_codec_conexant snd_hda_intel snd_hda_codec snd_hwdep
> snd_pcm thinkpad_acpi arc4 cryptd aes_x86_64 aes_generic snd_seq_midi
> i915 snd_rawmidi snd_seq_midi_event snd_seq joydev iwlagn btusb
> snd_timer snd_seq_device drm_kms_helper bluetooth uvcvideo snd
> videodev drm mac80211 cfg80211 i2c_algo_bit soundcore tpm_tis tpm
> tpm_bios lp snd_page_alloc psmouse serio_raw v4l2_compat_ioctl32 nvram
> video parport usbhid hid sdhci_pci firewire_ohci ahci libahci sdhci
> firewire_core crc_itu_t e1000e
>  [ 3674.255129] Pid: 3, comm: ksoftirqd/0 Not tainted 3.1.0-rc1+ #38
>  [ 3674.255131] Call Trace:
>  [ 3674.255138]  [<ffffffff8106db3f>] warn_slowpath_common+0x7f/0xc0
>  [ 3674.255143]  [<ffffffff8106dc36>] warn_slowpath_fmt+0x46/0x50
>  [ 3674.255147]  [<ffffffff81331851>] __list_del_entry+0xa1/0xd0
>  [ 3674.255151]  [<ffffffff81331891>] list_del+0x11/0x40
>  [ 3674.255156]  [<ffffffff81179631>] __slab_free+0x3d1/0x3e0
>  [ 3674.255162]  [<ffffffff811c5b06>] ? bvec_free_bs+0x26/0x40
>  [ 3674.255166]  [<ffffffff8117ab27>] ? kmem_cache_free+0x97/0x220
>  [ 3674.255170]  [<ffffffff811c5b06>] ? bvec_free_bs+0x26/0x40
>  [ 3674.255174]  [<ffffffff811c5b06>] ? bvec_free_bs+0x26/0x40
>  [ 3674.255179]  [<ffffffff8117ac9f>] kmem_cache_free+0x20f/0x220

Can you please also run

  addr2line -e vmlinux
  0xffffffff81179631

so that we know whether the corruption happens in the full list or the
partial list.

                         Pekka
