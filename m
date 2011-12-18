Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab1LRBW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 20:22:26 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62886 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070Ab1LRBWX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 20:22:23 -0500
MIME-Version: 1.0
In-Reply-To: <1324050284.3734.14.camel@lenny>
References: <1323280461.10724.13.camel@lenny>
	<4EDFCDD4.2080603@zytor.com>
	<20111207205459.031a0609@lxorguk.ukuu.org.uk>
	<CALQRfL6A+XUiLUVzsSOkz52rs7Pejtb_v8QZbpWxh5W8yYDYtg@mail.gmail.com>
	<1324050284.3734.14.camel@lenny>
Date: Sat, 17 Dec 2011 17:22:21 -0800
X-Google-Sender-Auth: AiS3jfTFl4uX2UXx7AR-wztZgoA
Message-ID: <CALQRfL4_zWAp3ZUM2GXKaw_6ofEfLUGs9WypD9qi_-15MeQx0Q@mail.gmail.com>
Subject: Re: chroot(2) and bind mounts as non-root
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Colin Walters <walters@verbum.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, serue@us.ibm.com,
        dhowells@redhat.com, kzak@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 7:44 AM, Colin Walters <walters@verbum.org> wrote:
> On Thu, 2011-12-15 at 10:55 -0800, Andrew G. Morgan wrote:
>> I'm genuinely confused whether all these concerns are valid with file
>> capabilities.
>>
>> Consider (let's say luser is some user that I want to be active inside
>> the chroot, but I don't want to allow regular login to my system):
>
> Then we already have different deployment scenarios.  You seem to be
> imagining a system where some user has an environment preconfigured by a
> system administrator.  My constraint (read my previous posts) is that
> the functionality must be available "out of the box" on a mainstream
> "distro" such as RHEL or Debian to any uid.  I don't even want to
> require addition to some magical group (that in reality is often a root
> backdoor anyways).

I don't read any issues with this in your original post. What I read
there is that you want to run a build in a chroot environment. Are you
also implying that the user gets to build this chroot filesystem from
nothing - without any privileges - or are you assuming that the root
user provides some sort of template into which the user adds
build-relevant files?

If the former, then yes I think you are going to have a very hard
time. If the latter then I still don't see the core problem...

>
>> root> setcap cap_sys_chroot=ep /tmp/launcher
>> Is there a need for privileged binaries within /tmp/chroot? If not,
>> how might they get there (without help from root, always presuming I
>> can prevent luser from logging in outside of this chroot'd
>> environment)?
>
> First of all, as I mentioned in my original mail (and is still in the
> Subject line), chroot(2) *almost* gets me what I want - except I need
> the ability to at least mount /proc, and being able to do bind mounts is
> necessary to use /dev.
>
> But let's just ignore the bind mounts for a second and pretend
> cap_sys_chroot is enough.  Is your suggestion that we could distribute a
> copy of /usr/sbin/chroot that grants cap_sys_chroot via file caps a
> secure thing to add to util-linux?  Or we could just add it to
> coreutils?

Before reaching that finish line, my suggestions/questions are trying
to get to the bottom of why this is believed impossible.

>
> See the attached shell script for an attack that should work against
> *any* setuid binary that uses glibc.  I wrote this without looking at
> other exploits on the internet, just reading the glibc sources - mainly
> for my own edification.
>
> It turns out in this case glibc trusts the contents of /etc, and in
> particular /etc/ld.so.preload.  So all I need to do is make a shared
> library that just runs /bin/bash as a __attribute__ ((constructor)), and
> when the glibc dynamic linker is loading /bin/su that I've hardlinked
> into the chroot, game over:
>
> $ cp /usr/sbin/chroot /usr/local/bin/fcaps-chroot
> $ sudo setcap cap_sys_chroot=ep /usr/local/bin/fcaps-chroot
> $ ./chroot-with-su.sh
> $ fcaps-chroot mychroot
> (now inside the chroot, but still uid=500)

So, you are saying that if I can explain how to prevent this from working:

> $ echo /lib64/rootshell.so > /etc/ld.so.preload

And prevent this from being possible:

> $ su -
> uid=500; euid=0; starting /bin/bash

You'll have what you want?

Or are there some other constraints not mentioned?

Thanks

Andrew

> # id
> uid=0 gid=500 groups=500
>
> The glibc linker also doesn't check that e.g. /lib64/libc.so.6 is owned
> by root - clearly I could just replace that with whatever I want.  But
> this is less typing.  Note glibc isn't buggy here, it was designed in a
> world where unprivileged users can't chroot.
>
