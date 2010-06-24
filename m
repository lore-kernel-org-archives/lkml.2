Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0FXHpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 03:45:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64819 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab0FXHpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 03:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B8WZUDvldX1r2GHZb0vvzHWpsrXbmQ+YL+C/0r7r0budNBUu1HzgGXeLXJPl09BW+t
         L6mnE64+0Mxlyv5qzjClTBkIJvgt16kMc9Lh84DdlqREFb4n0T/LR9rBUQRsa4Zno/yy
         WzdQtNHHc7eWmTk1mt0TKKIvW3NCyFkT/kmas=
MIME-Version: 1.0
In-Reply-To: <4C2305F9.5010306@gmail.com>
References: <AANLkTimYUy0tCvGHf_Qtz0tUG7XVms9i3MOz03m28Jin@mail.gmail.com>
	<AANLkTilXIkZM8tHX3QCP9A9LpVbmezaa5_PJdQfVU-w7@mail.gmail.com>
	<4C2305F9.5010306@gmail.com>
Date: Thu, 24 Jun 2010 15:45:07 +0800
Message-ID: <AANLkTik5H_rQ2tPO6h3UtslOVzGQo-qoKW_YD8hULAA3@mail.gmail.com>
Subject: Re: 2.6.35-rc3 -- kernel BUG at mm/vmalloc.c:216! - invalid opcode: 
	0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Xiaotian Feng <xtfeng@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Cliff Wickman <cpw@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 3:15 PM, Tejun Heo <htejun@gmail.com> wrote:
> Hello,
>
> On 06/24/2010 07:22 AM, Xiaotian Feng wrote:
>> I can reproduce it with the same ...
>>
>>> [ 1046.984453] kernel BUG at mm/vmalloc.c:216!
>>> [ 1046.984463] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>> [ 1046.984484] last sysfs file: /sys/devices/system/cpu/cpu1/crash_notes
>>> [ 1046.984495] Modules linked in: aes_i586 aes_generic binfmt_misc
>>> ipv6 snd_hda_codec_realtek arc4 snd_hda_intel ecb snd_hda_codec ath9k
>>> snd_hwdep snd_pcm_oss ath9k_common snd_mixer_oss ath9k_hw snd_pcm
>>> snd_seq_dummy ath snd_seq_oss snd_seq_midi snd_rawmidi mac80211
>>> snd_seq_midi_event snd_seq snd_timer cfg80211 snd_seq_device rtc_cmos
>>> snd rtc_core rtc_lib snd_page_alloc rng_core led_class processor
>>> battery ac sg uhci_hcd ehci_hcd sd_mod usbcore thermal
>>> [ 1046.984668]
>>> [ 1046.984680] Pid: 15038, comm: head Not tainted 2.6.35-rc3 #1 1000HE/1000HE
>>> [ 1046.984691] EIP: 0060:[<c10985de>] EFLAGS: 00010246 CPU: 0
>>> [ 1046.984705] EIP is at vmalloc_to_page+0x16/0xd1
>>> [ 1046.984714] EAX: 00000000 EBX: c1527000 ECX: c6e0b2a8 EDX: f7ffe000
>>> [ 1046.984725] ESI: c6e0b2a8 EDI: c133234c EBP: d6645f20 ESP: d6645f18
>>> [ 1046.984736]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>>> [ 1046.984748] Process head (pid: 15038, ti=d6645000 task=ca6c6900
>>> task.ti=d6645000)
>>> [ 1046.984757] Stack:
>>> [ 1046.984764]  d6644000 c6e0341c d6645f28 c10a3423 d6645f34 c1204bf8
>>> c1204bdc d6645f44
>>> [ 1046.984800] <0> c1201ebc c93ea400 f70a12c0 d6645f70 c10e594f
>>> c112b2df 00002000 bfa194ec
>>> [ 1046.984840] <0> 00000000 c93ea414 c133234c e07cd600 bfa194ec
>>> c10e58c1 d6645f8c c10a6223
>>> [ 1046.984883] Call Trace:
>>> [ 1046.984902]  [<c10a3423>] ? per_cpu_ptr_to_phys+0x5b/0x74
>>> [ 1046.984920]  [<c1204bf8>] ? show_crash_notes+0x1c/0x30
>
> It's probably the same bug Cliff Wickman reported.
> per_cpu_ptr_to_phys() was using wrong first chunk match logic which
> ends up passing wrong addresses to vmalloc_to_page().  I have the
> following fix patch queued in percpu#for-linus branch and was waiting
> for Linus to come back.
>
>  http://git.kernel.org/?p=linux/kernel/git/tj/percpu.git;a=commitdiff_plain;h=9983b6f0cf8263e51bcf4c8a9dc0c1ef175b3c60;hp=a92d3ff9e5dbd958d8008a3e7a573e988e370ca3
>
> Can you please verify the above patch fixes the problem?

Yes, that patch fixes the problem on my box, thanks.

>
> Thanks.
>
> --
> tejun
>
