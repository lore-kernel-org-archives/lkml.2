Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab2BCBpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:45:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47036 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab2BCBpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:45:38 -0500
Date: Fri, 3 Feb 2012 01:45:33 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joel Becker <jlbec@evilplan.org>, Chris Mason <chris.mason@oracle.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
Message-ID: <20120203014533.GT23916@ZenIV.linux.org.uk>
References: <m14nvc82jo.fsf@fess.ebiederm.org>
 <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com>
 <m1wr87ywex.fsf@fess.ebiederm.org>
 <m1ehueyz20.fsf_-_@fess.ebiederm.org>
 <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <20120202012258.GQ23916@ZenIV.linux.org.uk>
 <20120202212400.GR23916@ZenIV.linux.org.uk>
 <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
 <20120203011612.GS23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203011612.GS23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 01:16:12AM +0000, Al Viro wrote:

> After looking a bit more: nlink_t is a f*cking mess.  Almost any code
> using that type kernel-side is broken.  Crap galore:
> 	* sometimes it's 32 bits, sometimes 16, sometimes 64.  Essentially
> at random.
> 	* almost all have it unsigned, except for sparc32, where it's
> signed short [inherited from v7 via SunOS?  BTW, in v6 it used to be even
> funnier - char, which is where ridiculous LINK_MAX == 127 comes from]
> 
> IOW, nlink_t is an attractive nuisance - it's nearly impossible to use in
> a portable way and we are lucky that almost nobody tries to.

Incidentally, why the hell do we have
	typedef __kernel_nlink_t        nlink_t;
anyway?  It's *not* exposed to userland and it's different from the
userland nlink_t (which is unsigned int on 32bit and unsigned long on 64bit).
Why not use __kernel_nlink_t (or explicitly-sized __uNN) in
arch/*/include/asm/stat.h and declare nlink_t kernel-side as __u32?

Why do we have daddr_t, while we are at it?  There is exactly one user -
fs/freevxfs and there we definitely want a fixed-sized type.
