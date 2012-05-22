Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab2EVWPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:15:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37714 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab2EVWPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:15:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAJJYPdmimcz45qdT0W-iLTyY-U2qCe4fa4+e19adrjMtwd2Ywg@mail.gmail.com>
References: <CAJJYPd=JQdzepw818ZP6OmKK4v38--T+ruKBOG_wn2pUmnVaSw@mail.gmail.com>
	<20120522123058.GB4629@phenom.ffwll.local>
	<CAJJYPdmcJYT1VTnqbkbybut-_NqpFYsuEEzDb9LO-E+ss=wz-g@mail.gmail.com>
	<20120522144443.GD4629@phenom.ffwll.local>
	<CAJJYPdmimcz45qdT0W-iLTyY-U2qCe4fa4+e19adrjMtwd2Ywg@mail.gmail.com>
Date: Wed, 23 May 2012 00:15:00 +0200
Message-ID: <CAJJYPdkhSOXZeCJN9MDHTgd1hg07zo1ZDXkwwASJ74NojQ=dyQ@mail.gmail.com>
Subject: Re: Regression on GMA965 - display seems to have slow jump changes in brightness
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Cc: daniel@ffwll.ch, seanpaul@chromium.org, jbarnes@virtuousgeek.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/22 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2012/5/22 Daniel Vetter <daniel@ffwll.ch>:
>> On Tue, May 22, 2012 at 04:36:30PM +0200, Zdenek Kabelac wrote:
>>> 2012/5/22 Daniel Vetter <daniel@ffwll.ch>:
>>> > On Tue, May 22, 2012 at 02:08:46PM +0200, Zdenek Kabelac wrote:
>>> >> Hi
>>> >>
>>> >> I've updated to 3.4 kernel, and now I'm noticing slight changes in
>>> >> brightness on colorful images.
>>> >> It seems the change is mostly visibly on  'darker' images i.e. it's
>>> >> not really visible on white background.
>>> >>
>>> >> When I reboot back to 3.3  kernel - brightness changes are gone - so I
>>> >> do not suspect hw fault of my T61 display.
>>> >> I guess once in past there has been already such bug, so this problem
>>> >> seems to me like reintroducing the same
>>> >> problem again.
>>> >>
>>> >> xorg-x11-server-Xorg-1.12.1-1.fc18.x86_64
>>> >> with SNA intel driver build from git repo.
>>> >> T61, 965GM
>>> >>
>>> >> Is this a know issue ?
>>> >> Is bisect needed ?
>>> >
>>> > You're the first one to report things, so a bisect would be highly
>>> > appreciated. Also I'm a bit confused about what you mean by 'changing
>>> > brightness'. Can you please try to explain this a bit more?
>>> >
>>>
>>> I've some default gnome picture like this one:
>>> https://lh6.googleusercontent.com/-96ZhFbfLX_M/ThHsm0ZxBgI/AAAAAAAAFQQ/3ApjzYgulso/s400/gnome-3-login-screen.png
>>>
>>> When I watch the picture for some period of time  I'm noticing slight
>>> changes in the picture brightness looking like small change in LUT
>>> table or something like that.
>>> If the picture is white I'm not noticing any change.
>>> (Initially I've thought my display dies - but reboot to 3.3 fixed the
>>> issue immediately).
>>
>> "for some period", does that mean it takes you a while to notice the
>> changes (because they're tiny), or are the changes happend just rather slowly?
>>
>
> Deviation in picture is not huge - but gets noticeable by my eyes and
> it's annoying,
> it's like several seconds between each minor change.
>
> If I've monotone background in i.e. text editor  the change is
> practically not visibible,
> but if watch some digicam photos full screen they are quite obvious.
>
> Not sure if that has any influence (not tested without)  I'm using
> some icc profile
> ('xcalib') to get away from blue of IBM display.
>
>>> Is there any suspecting patch for this chipset I should try to revert ?
>>
>> Tbh I have no idea. If there's no changes when the picture is white, it
>> can't be the backlight, we haven't frobbed around with the gamma stuff and
>> temporal dithering is disabled, too. If you can bisect this it would
>> greatly help.
>
> ok, I'll play this game in the evening if there is nothing obvious.
>

And we have a winner - cec2f356d59d9e070413e5966a3c5a1af136d948

drm/i915: Only look for matching clocks for LVDS downclock

reverting just  this patch for vanilla 3.4  fixes the problem for my T61.
(I've not tried to play with those individial 3 pieces inside this patch
to check exactly which one is responsible)

Zdenek

Here is the bisect game:
git bisect start
# bad: [acc73fb11695b564dc485b1f98f8237bbdc0742f] Remove ioctl warning
git bisect bad acc73fb11695b564dc485b1f98f8237bbdc0742f
# good: [c16fa4f2ad19908a47c63d8fa436a1178438c7e7] Linux 3.3
git bisect good c16fa4f2ad19908a47c63d8fa436a1178438c7e7
# bad: [141124c02059eee9dbc5c86ea797b1ca888e77f7] Delete all instances
of asm/system.h
git bisect bad 141124c02059eee9dbc5c86ea797b1ca888e77f7
# good: [3b59bf081622b6446db77ad06c93fe23677bc533] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good 3b59bf081622b6446db77ad06c93fe23677bc533
# good: [424a6f6ef990b7e9f56f6627bfc6c46b493faeb4] Merge tag
'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6
git bisect good 424a6f6ef990b7e9f56f6627bfc6c46b493faeb4
# bad: [be53bfdb8088e9d1924199cc1a96e113756b1075] Merge branch
'drm-next' of git://people.freedesktop.org/~airlied/linux
git bisect bad be53bfdb8088e9d1924199cc1a96e113756b1075
# good: [828006de1bddf83b6ecf03ec459c15f7c7c22db7] Merge tag
'asoc-3.4' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound
into topic/asoc
git bisect good 828006de1bddf83b6ecf03ec459c15f7c7c22db7
# skip: [496a73bbecb81e6753715995e4519d152f814667] drm/nv50/pm: use
hwsq for engine reclocking too
git bisect skip 496a73bbecb81e6753715995e4519d152f814667
# skip: [c11dd0da5277596d0ccdccb745b273d69a94f2d7] drm/nouveau/pm: fix
oops if chipset has no pm support at all
git bisect skip c11dd0da5277596d0ccdccb745b273d69a94f2d7
# skip: [07cafff288266c3aa082f4bda3d47989e73ee85d] ALSA: hda/conexant
- Clear unsol events on unused pins
git bisect skip 07cafff288266c3aa082f4bda3d47989e73ee85d
# bad: [f3298532f71f163877b9003009d6e1eefe988258] drm/nvc0: add
initial memory type detection
git bisect bad f3298532f71f163877b9003009d6e1eefe988258
# bad: [019d96cb55ade38a4b4a52bba0304e8cd681f30a] drm: add some caps
for userspace to discover more info for dumb KMS driver (v2)
git bisect bad 019d96cb55ade38a4b4a52bba0304e8cd681f30a
# bad: [5c0480f21f9896c443b0e65d779c8e09a695da7b] drm/i915: fall
through pwrite_gtt_slow to the shmem slow path
git bisect bad 5c0480f21f9896c443b0e65d779c8e09a695da7b
# bad: [8e636784b6f76653d358d521af9c2a8c246df38b] drm/i915: fixup
assert_pipe to take the pipe A quirk into account
git bisect bad 8e636784b6f76653d358d521af9c2a8c246df38b
# bad: [23c99e775d14f01ba45a5affd2fb51af4328359c] drm/i915: Fix
assert_pch_hdmi_disabled to mention HDMI (not DP)
git bisect bad 23c99e775d14f01ba45a5affd2fb51af4328359c
# bad: [a7516a05311d0e2deb8ce8ae8b8c12a513ca8ca2] drm/i915: split out
pll divider code
git bisect bad a7516a05311d0e2deb8ce8ae8b8c12a513ca8ca2
# bad: [5a117db77e47e3946d1aaa7ce8deafafd9d76746] drm/i915: there is
no pipe CxSR on ironlake
git bisect bad 5a117db77e47e3946d1aaa7ce8deafafd9d76746
# good: [0b8ecdda1943a05c8e7896f0b5f1addf39269927] drm/i915: Silence _DSM errors
git bisect good 0b8ecdda1943a05c8e7896f0b5f1addf39269927
