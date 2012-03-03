Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab2CCAYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 19:24:34 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34880 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405Ab2CCAYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 19:24:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.133.96 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1203021616040.23477@asgard.lang.hm>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
 <20120303000203.GH22215@thunk.org> <alpine.DEB.2.02.1203021616040.23477@asgard.lang.hm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Mar 2012 16:24:11 -0800
X-Google-Sender-Auth: i7-4rjIIOEARZOyMzZ5sMFFnGBo
Message-ID: <CA+55aFw7C3XYzwZ8F31EA4Svj1WZ8O--HV82qVg3t=JpxRy1Ww@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
To: david@lang.hm
Cc: "Ted Ts'o" <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 4:17 PM,  <david@lang.hm> wrote:
>
> or did some CPUs have efficient char access, but inefficient unaligned word
> access?

Tons of CPU's have efficient char accesses but horrible unaligned word
accesses. Some are even outright buggy (ie at least some ARM cores)
and load crap. Others take a fault.

They just aren't x86, because x86 has traditionally had code with a
fair amount of unaligned loads and stores (and not just for historical
reasons either: even modern code replaces constant-sized memcpy() etc
with direct loads and stores)

For some other architectures, we could just use "get_unaligned()",
which fixes things up for them. I could have made that explicit, even
if it doesn't matter on x86.

So the bigger portability problem to some degree is the fact that it
is limited to little-endian, so even if you have a CPU with good
unaligned accesses (some POWER chips do ok, for example, although not
all), you'd have to also do something with the mask generation (which
currently uses the "(x-1)&~x" trick that means that it generates the
mask of the *low bits* - and then assumes that "low bits" means "first
bytes" - ie little endian).

                       Linus
