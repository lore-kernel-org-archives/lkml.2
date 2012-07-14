Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2GNTxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 15:53:53 -0400
Received: from mail.lang.hm ([64.81.33.126]:56179 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab2GNTxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 15:53:49 -0400
Date: Sat, 14 Jul 2012 12:51:55 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: Borislav Petkov <bp@amd64.org>, Pekka Enberg <penberg@kernel.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Ubuntu Kernel Team <kernel-team@lists.ubuntu.com>,
        Debian Kernel Team <debian-kernel@lists.debian.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Subject: Re: [opensuse-kernel] Re: [RFC] Simplifying kernel configuration
 for distro issues
In-Reply-To: <20120714185120.GC4093@moon>
Message-ID: <alpine.DEB.2.02.1207141239010.20176@asgard.lang.hm>
References: <CA+55aFxw8pY1KMjobp=dKJd+g4B9KGhe4+fsfSPA3ofCGVhkPQ@mail.gmail.com> <1342212885.25704.4.camel@lade.trondhjem.org> <CAFLxGvxxWodD97=78218wc+tuigAFsNK_PdroDfb4BWTZoxxUw@mail.gmail.com> <20120714103716.GD26559@liondog.tnic>
 <CAOJsxLGHQuuXqDD-1SNhL7Ly1-heCYFLzqj3SLh4xzmP9NR5GQ@mail.gmail.com> <20120714124332.GA4093@moon> <20120714174827.GA13319@aftab.osrc.amd.com> <20120714185120.GC4093@moon>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2012, Cyrill Gorcunov wrote:

> On Sat, Jul 14, 2012 at 07:48:27PM +0200, Borislav Petkov wrote:
>> On Sat, Jul 14, 2012 at 04:43:32PM +0400, Cyrill Gorcunov wrote:
>>> For example to enable "PCI driver for virtio devices" I need to go to
>>> Device Drivers -> Virtio drivers, while I think it would be great to
>>> have everything virt. related in Virtualization section.
>>
>> Actually, we need something more generic than that: everything X-related
>> should be automatically selected when setting CONFIG_X. And X can be any
>> subset of configuration options which belong to one feature, be it KVM,
>> distro-specific stuff, or CPU-vendor specific stuff, or whatever.
>>
>> I can imagine, for example, that when a user wants to have an
>> AMD-specific config, it automatically selects CPU_SUP_AMD, X86_MCE_AMD
>> (for MCE), MICROCODE_AMD (microcode support), AGP_AMD64, EDAC_AMD64 and
>> a bunch of other AMD-specific features.
>
> sure, no doubts, it would be great! (I must admit I never looked up into
> kconfig parser code so i don't know if this could be achieved easily).

think of this as a variation of the miniconfig problem.

Instead of the miniconfig being one file that specifies everything you 
want, that you then use to generate a real .config file, you instead have 
one _or_ _more_ config files that get combined and then used to generate 
the real .config file.

Doing this as a set of miniconfig snippets instead of as menu options in 
the main kconfig has the advantage that once the real .config is created, 
it can then be edited freely, without worrying about things like SELINUX 
being enabled when you want to do development on a different LSM.

The distro config would be the first of these, but then you could have 
multiple hardware specific config files (a vmware config, a KVM config, 
one or more config files for the systems that you own, a USB config to 
enable a bunch of the various USB deices that you want to support, etc)

The distros may choose to produce several miniconfig files, one the 
minimum infrastructure features they need, and then additional files for 
the rest of their config. For example, I could see them having a set of 
files

1. Core
2. architecture
3. architecture specific drivers
4. architecture neutral drivers (USB devices and similar)


starting off with the distro config, the people creating this are going to 
be very familiar with kconfig and could create these by hand, but going 
forward we are going to want to have some tools to help sysadmins to 
create these files. Not knowing kconfig, it may be as simple as taking the 
miniconfig snippets that you start with, creating a .config and then doing 
a diff of that .config with the one the admin created, using the result as 
the new miniconfig snippet.

David Lang
