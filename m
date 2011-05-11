Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab1EKREX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:04:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33892 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1EKREV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HtlVZOtz45LRTbctahNaXstrJ/3RnZreM6bc9cvhWkz7uIqyCjy3yS3Gx6j20XtOnC
         FCGAiwFVR9GA7uyfTVIH7Pvdu/69dFB4NTpZP75X2dTC/qR/52fkFxqhwQUoA7hRtOEU
         L6+zKTo7DQSCjF/fTfUpkeMz5kM4UnItf7xzA=
MIME-Version: 1.0
In-Reply-To: <BANLkTinDYcB6xSmPeRtPQcKERxxZaGk=4Q@mail.gmail.com>
References: <BANLkTi=8U3=E0=j8MJ-r70O_aO8Pxvv9Nw@mail.gmail.com>
	<BANLkTi=F8u7oZM+=W+5vzmvf1b0YiN0fQg@mail.gmail.com>
	<20110420080535.3edd11ac@pluto.restena.lu>
	<20110420105631.70695dfa@lxorguk.ukuu.org.uk>
	<BANLkTikF5YL8tJ_f5510yy1Ywm69rOUK2A@mail.gmail.com>
	<BANLkTi=x76zkTpZxaHUnSUeP+_O0SsK0Zw@mail.gmail.com>
	<BANLkTiksbbCqnQG6N_xe69bvWSAA8AVAbQ@mail.gmail.com>
	<BANLkTikpswH4cyCVx7h74ttcivdnXZQrUg@mail.gmail.com>
	<20110510105001.401d0f66@lxorguk.ukuu.org.uk>
	<BANLkTikVSGUs=S3=1nR9gwr4iuAsWM9FuQ@mail.gmail.com>
	<BANLkTim49ZU06Upg77-hOzc60tGEYO80wg@mail.gmail.com>
	<4DCA8717.5050808@canonical.com>
	<20110511140213.73fe6d49@lxorguk.ukuu.org.uk>
	<BANLkTinDYcB6xSmPeRtPQcKERxxZaGk=4Q@mail.gmail.com>
Date: Wed, 11 May 2011 20:04:20 +0300
Message-ID: <BANLkTimWS3Q5LDd1MX7t5DjgkS2eNbXnDw@mail.gmail.com>
Subject: Re: [2.6.39-rc2, framebuffer] use after free oops
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tim Gardner <tim.gardner@canonical.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>, Dave Airlie <airlied@redhat.com>,
        =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
        Andy Whitcroft <andy.whitcroft@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 7:17 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, May 11, 2011 at 6:02 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>
>> We need some kind of patch for this release, even one where we leak the
>> memory to avoid the scribbles. Random scribbling into freed memory could
>> hit anything including user data or file system meta data - not good.
>
> Yeah.
>
> I looked at just not freeing things, but that ends up being ugly,
> because the actual low-level allocation is being done by the
> framebuffer driver itself (and it gets freed in fb_destroy). Now, it's
> all supposed to use "framebuffer_release()", and maybe they all even
> do, but it just made me worry.
>
> So I ended up looking at just the refcount thing.
>
> This is my trial. It should get the /proc locking right too. But it is
> *ENTIRELY* untested. I looked at the Ubuntu patch, but that one mixed
> up the refcounting with some other issues. I'm sure they are perfectly
> valid fixes too, and should probably be done, but they are also an
> unrelated thing. And the patch from Ubuntu seems to leave the /proc
> accesses unprotected.
>
> The one registered_fb[] access (well, at least in fbmem.c) I didn't
> fix is FBIOPUT_CON2FBMAP, which the Ubuntu patch didn't fix either. It
> would be easy to lock the accesses there, but I don't know what the
> f*ck the code wants to do (it only looks at the entry, but it actually
> *uses* the 'info' that was passed in), so I just passed on that as
> "insane code that makes no sense".
>
> The "remove_conflicting_framebuffers()" function should be locked too,
> but I didn't bother, because it would mean splitting
> unregister_framebuffer() into some helper functions. So that's a
> "fixme later".
>
> Whatever. The patch looks sane.
>
> So *if* this works, I think it's better. I did actually go through the
> patches side-by-side, and they end up very similar (apart from where
> they aren't - the unrelated fb locking changes, and the fact that my
> registration lock is much bigger and covers more). Which is
> understandable, the way I did it was look for accesses to
> "registered_fb[]", and I assume that is what Andy did too.
>
> Testing? I obviously don't see the problem in the first place, so..
>
>                        Linus
>

With 2.6.39-rc7 I get
[   19.420036] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[   19.420063] IP: [<ffffffff815a9d3a>] __mutex_lock_slowpath+0xca/0x180
[   19.420077] PGD 7bbfc067 PUD 7bbfd067 PMD 0
[   19.420089] Oops: 0002 [#1] SMP
[   19.420097] last sysfs file: /sys/devices/virtual/vtconsole/vtcon1/uevent
[   19.420107] CPU 1
[   19.420111] Modules linked in: parport_pc ppdev
snd_hda_codec_realtek snd_hda_intel snd_hda_codec adt7475 hwmon_vid
snd_hwdep snd_pcm snd_seq_midi snd_rawmidi nouveau ttm drm_kms_helper
snd_seq_midi_event drm i2c_algo_bit snd_seq snd_timer snd_seq_device
psmouse snd serio_raw soundcore video snd_page_alloc intel_agp
intel_gtt lp parport r8169 pata_marvell ahci mii libahci btrfs
zlib_deflate crc32c libcrc32c
[   19.420211]
[   19.420216] Pid: 268, comm: plymouthd Not tainted 2.6.39-rc7 #1
MICRO-STAR INTERNATIONAL CO.,LTD MS-7360/MS-7360
[   19.420231] RIP: 0010:[<ffffffff815a9d3a>]  [<ffffffff815a9d3a>]
__mutex_lock_slowpath+0xca/0x180
[   19.420244] RSP: 0018:ffff880036ef1e28  EFLAGS: 00010246
[   19.420251] RAX: 0000000000000000 RBX: ffff88007f817008 RCX: 0000000000000001
[   19.420260] RDX: ffff880036ef1e38 RSI: ffff88006dd87600 RDI: ffff88007f81700c
[   19.420269] RBP: ffff880036ef1e88 R08: 00000000ffffffff R09: 0000000000000000
[   19.420279] R10: ffff88006dd87610 R11: 0000000000000246 R12: ffff8800369dc440
[   19.420404] R13: ffff88007f81700c R14: 00000000ffffffff R15: ffff88007f817010
[   19.420414] FS:  00007f9f557b6720(0000) GS:ffff88007fc80000(0000)
knlGS:0000000000000000
[   19.420424] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   19.420432] CR2: 0000000000000000 CR3: 000000007bbfb000 CR4: 00000000000006e0
[   19.420441] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   19.420450] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   19.420460] Process plymouthd (pid: 268, threadinfo
ffff880036ef0000, task ffff8800369dc440)
[   19.420469] Stack:
[   19.420473]  ffff880036ef1e78 ffff880036ef0000 ffff88007f817010
0000000000000000
[   19.420487]  ffff880036ef1e58 0000000000000000 ffff88006dd87610
ffff88007f817008
[   19.420503]  ffff88007f817008 ffff88007d3d9480 ffff88007be34d90
ffff88007be34d90
[   19.420518] Call Trace:
[   19.420525]  [<ffffffff815a97bb>] mutex_lock+0x2b/0x50
[   19.420535]  [<ffffffff8130acc9>] fb_release+0x29/0x70
[   19.420545]  [<ffffffff8115d04a>] fput+0xea/0x220
[   19.420553]  [<ffffffff81159296>] filp_close+0x66/0x90
[   19.420561]  [<ffffffff81159867>] sys_close+0xb7/0x120
[   19.420569]  [<ffffffff815b30c2>] system_call_fastpath+0x16/0x1b
[   19.420576] Code: 90 4c 8d 6b 04 4c 8d 7b 08 41 be ff ff ff ff 4c
89 ef e8 5a 13 00 00 48 8b 43 10 48 8d 55 b0 4c 89 7d b0 48 89 53 10
48 89 45 b8
[   19.420658]  89 10 44 89 f0 4c 89 65 c0 87 03 83 f8 01 75 24 eb 2c 0f 1f
[   19.420698] RIP  [<ffffffff815a9d3a>] __mutex_lock_slowpath+0xca/0x180
[   19.420709]  RSP <ffff880036ef1e28>
[   19.420714] CR2: 0000000000000000
[   19.501432] r8169 0000:04:00.0: eth0: link up
[   19.501773] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   21.049817] [drm] nouveau 0000:01:00.0: EvoCh 2 Mthd 0x0080 Data
0x00000000 (0x000b 0x05)
[   21.053688] ---[ end trace 15bf5450f28092e3 ]---

Full dmesg at: http://pastebin.com/BTzX30be

After your patch:
I get an hard freeze. I can only get a photo If you are interested.
