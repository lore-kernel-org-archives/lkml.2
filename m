Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1H3MsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:48:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46797 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab1H3MsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:48:11 -0400
Date: Tue, 30 Aug 2011 13:48:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, jdike@addtoit.com
Subject: Re: [PATCH 8/9] um: fix strrchr problems
Message-ID: <20110830124805.GU2203@ZenIV.linux.org.uk>
References: <1314634419-24766-9-git-send-email-richard@nod.at>
 <20110829142705.5be82d7c.akpm@linux-foundation.org>
 <4E5C06DF.60508@nod.at>
 <20110829221230.GP2203@ZenIV.linux.org.uk>
 <4E5C0F9F.5000405@nod.at>
 <20110829221922.GQ2203@ZenIV.linux.org.uk>
 <4E5C11D5.4020404@nod.at>
 <20110830002330.GR2203@ZenIV.linux.org.uk>
 <20110830024853.GS2203@ZenIV.linux.org.uk>
 <4E5CBC3F.9030006@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5CBC3F.9030006@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 12:32:31PM +0200, Richard Weinberger wrote:

> defconfig + STATIC_LINK +  UML_NET_VDE builds fine for me.
> 
> Toolchain (openSUSE 11.4):
> glibc: 2.11.3
> vde2: 2.3.1
> gcc: 4.5.3
> binutils: 2.21.1
> 
> Is my vde too new?
> BTW: Why is only strstr affected, what makes it so special?

What happens is that we end up with arch/um/drivers/vde.o having a reference
to rindex().  It comes from libvdeplug.a:libvdeplug.o and we don't have
rindex() in the kernel.  In libc we *do* have it - as an alias for strrchr.
So libc.a:strrchr.o is pulled in by that and we end up with conflict since
now two object files picked by linker define the same symbol.

At a guess, newer vde stopped wanking with rindex(3) (perhaps switching
to strrchr(3), as recommended by POSIX these days) and that has eliminated
the problem.

So yes, probably it's your vde being newer.  Until other distros pick that
version we are stuck with that problem, though...  Alternative solution
would be to have rindex() in arch/um/drivers/vde_kern.c - that also works
and might be a bit saner.  Defining it in lib/string.c is probably a bad
idea, since its use is not a good practice - it duplicates a standard C
equivalent (C89, at that) for no reason.
