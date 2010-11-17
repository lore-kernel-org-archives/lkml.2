Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0KQFka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:40:30 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61756 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0KQFka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:40:30 -0500
MIME-Version: 1.0
In-Reply-To: <20101116104600.GA24015@suse.de>
References: <20101116104600.GA24015@suse.de>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Wed, 17 Nov 2010 00:40:08 -0500
Message-ID: <AANLkTi=F1vbwpOzyN9o0nuRtsEUTQx2j3==kLu9j7Ccb@mail.gmail.com>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
To: Marcus Meissner <meissner@suse.de>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        akpm@osdl.org, hpa@zytor.com, mingo@elte.hu, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 05:46, Marcus Meissner <meissner@suse.de> wrote:
> Making /proc/kallsyms readable only for root makes it harder
> for attackers to write generic kernel exploits by removing
> one source of knowledge where things are in the kernel.
>
> This is the second submit, discussion happened on this on first submit
> and mostly concerned that this is just one hole of the sieve ... but
> one of the bigger ones.
>
> Changing the permissions of at least System.map and vmlinux is
> also required to fix the same set, but a packaging issue.
>
> Target of this starter patch and follow ups is removing any kind of
> kernel space address information leak from the kernel.
[...snip...]
> -       proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
> +       proc_create("kallsyms", 0400, NULL, &kallsyms_operations);

Erm... this still seems to be missing a couple of really major
criticisms from the last review:

  (1) For 99%+ of all the computers out there you can get a 90%+
accurate guess for what kernel is running by looking at the version of
libc installed on the system.  All you have to do for those computers
is download a bunch of distro kernels and look at the libc packages
and build a table of "libc6-SOMEVERSION => 0xADDRESS", etc.  Because
of how all the vendors backport and track versions, "SOMEVERSION"
usually includes something wonderfully helpful like "el5" or "squeeze"
or whatever.  This does *nothing* for those users, and it's not clear
that it ever *could*.

  (2) Most of the arguments about introducing "uncertainty" into the
hacking process are specious as well.  If a kernel bug is truly a
"workable" vulnerability then 99%+ of the attempts to exploit it would
be completely automated virii and computer worms that don't really
care what happens if they fail to compromise the system.  Take a look
at the vast collection of sample code we have in the form of Windows
virii/trojans/worms/malware/etc; care to guess what portion of those
programs authors would shed a tear if their exploit horribly crashed
or generated vast amounts of audit spam for 70% of the computers it
executed on?

  (2) By just flat out changing the permissions on this file you are
breaking all sorts of existing debugging and analysis tools (which
currently operate just fine as non-root).  If you make the argument
that those people "can just write a boot script to 'chmod' the file",
well, you *too* can write a boot script to just chmod the file.
Furthermore, if you're truly locking down a system that hard, there
are lots of other boot scripts you will be modifying already anyways.

  (3) If you are really interested in locking down a system to this
degree then you should also be using an appropriate LSM, which is
already a much better place to hook these sorts of specific checks.
In fact, with roughly a 5-line SELinux policy change I could already
close this so-called "security hole" with no kernel changes
whatsoever.

Cheers,
Kyle Moffett
