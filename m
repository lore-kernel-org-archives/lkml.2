Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2GMUzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:55:08 -0400
Received: from mx2.netapp.com ([216.240.18.37]:54479 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757313Ab2GMUzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:55:04 -0400
X-IronPort-AV: E=Sophos;i="4.77,580,1336374000"; 
   d="scan'208";a="663269310"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        "Ubuntu Kernel Team" <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Simplifying kernel configuration for distro issues
Thread-Topic: [RFC] Simplifying kernel configuration for distro issues
Thread-Index: AQHNYTm8IweICz6a/U+QbuoWlCkiDA==
Date: Fri, 13 Jul 2012 20:54:46 +0000
Message-ID: <1342212885.25704.4.camel@lade.trondhjem.org>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
In-Reply-To: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5BC75F00BF85F4D8F60D672C0A618C2@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6DKtI3K016663

On Fri, 2012-07-13 at 13:37 -0700, Linus Torvalds wrote:
> So this has long been one of my pet configuration peeves: as a user I
> am perfectly happy answering the questions about what kinds of
> hardware I want the kernel to support (I kind of know that), but many
> of the "support infrastructure" questions are very opaque, and I have
> no idea which of the them any particular distribution actually depends
> on.
> 
> And it tends to change over time. For example, F14 (iirc) started
> using TMPFS and TMPFS_POSIX_ACL/XATTR for /dev. And starting in F16,
> the initrd setup requires DEVTMPFS and DEVTMPFS_MOUNT. There's been
> several times when I started with my old minimal config, and the
> resulting kernel would boot, but something wouldn't quite work right,
> and it can be very subtle indeed.
> 
> Similarly, the distro ends up having very particular requirements for
> exactly *which* security models it uses and needs, and they tend to
> change over time. And now with systemd, CGROUPS suddenly aren't just
> esoteric things that no normal person would want to use, but are used
> for basic infrastructure. And I remember being surprised by OpenSUSE
> suddenly needing the RAW table support for netfilter, because it had a
> NOTRACK rule or something.
> 
> The point I'm slowly getting to is that I would actually love to have
> *distro* Kconfig-files, where the distribution would be able to say
> "These are the minimums I *require* to work". So we'd have a "Distro"
> submenu, where you could pick the distro(s) you use, and then pick
> which release, and we'd have something like
> 
>  - distro/Kconfig:
> 
>     config DISTRO_REQUIREMENTS
>         bool "Pick minimal distribution requirements"
> 
>     choice DISTRO
>         prompt "Distribution"
>         depends on DISTRO_REQUIREMENTS
> 
>     config FEDORA
>     config OPENSUSE
>     config UBUNTU
>     ...
> 
>     endchoice
> 
> and then depending on the DISTRO config, we'd include one of the
> distro-specific ones with lists of supported distro versions and then
> the random config settings for that version:
> 
>  - distro/Kconfig.suse:
> 
>     config OPENSUSE_121
>         select OPENSUSE_11
>         select IP_NF_RAW  # ..
> 
>  - distro/Kconfig.Fedora:
> 
>     config FEDORA_16
>         select FEDORA_15
>         select DEVTMPFS               # F16 initrd needs this
>         select DEVTMPFS_MOUNT  # .. and expects the kernel to mount
> DEVTMPFS automatically
>         ...
> 
>     config FEDORA_17
>         select FEDORA_16
>         select CGROUP_xyzzy
>         ...
> 
> and the point would be that it would make it much easier for a normal
> user (and quite frankly, I want to put myself in that group too) to
> make a kernel config that "just works".
> 
> Sure, you can copy the config file that came with the distro, but it
> has tons of stuff that really isn't required. Not just in hardware,
> but all the debug choices etc that are really a user choice. And it's
> really hard to figure out - even for somebody like me - what a minimal
> usable kernel is.
> 
> And yes, I know about "make localmodconfig". That's missing the point
> for the same reason the distro config is missing the point.
> 
> Comments? It doesn't have to start out perfect, but I think it would
> *really* help make the kernel configuration much easier for people.
> 
> In addition to the "minimal distro settings", we might also have a few
> "common platform" settings, so that you could basically do a "hey, I
> have a modern PC laptop, make it pick the obvious stuff that a normal
> person needs, like USB storage, FAT/VFAT support, the core power
> management etc". The silly stuff that you need, and that
> "localyesconfig" actually misses because if you haven't inserted a USB
> thumb drive, you won't necessarily have the FAT module loaded, but we
> all know you do want it in real life. But that's really independent
> issue, so let's keep it to just distro core things at first, ok?
> 
> Would something like this make sense to people? I really think that
> "How do I generate a kernel config file" is one of those things that
> keeps normal people from compiling their own kernel. And we *want*
> people to compile their own kernel so that they can help with things
> like bisecting etc. The more, the merrier.
> 
>                     Linus

We could at least make selection of a minimal set of drivers for the
more common virtualised platforms a lot easier.
Right now, you need to hunt through 30+ different menus in order to find
what you need to run in a basic KVM virtual machine...

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
