Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab0EZIBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:01:12 -0400
Received: from ozlabs.org ([203.10.76.45]:36191 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0EZIBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:01:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression] Crash in load_module() while freeing args
Date: Wed, 26 May 2010 17:30:58 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>,
       Jon Masters <jonathan@jonmasters.org>
References: <201005252300.07739.rjw@sisk.pl> <201005260054.52122.rjw@sisk.pl> <alpine.LFD.2.00.1005251639420.3689@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005251639420.3689@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005261730.59058.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 09:17:32 am Linus Torvalds wrote:
> 
> On Wed, 26 May 2010, Rafael J. Wysocki wrote:
> >
> > I'm not able to reproduce the issue with the following commit reverted:
> > 
> > commit 480b02df3aa9f07d1c7df0cd8be7a5ca73893455
> > Author: Rusty Russell <rusty@rustcorp.com.au>
> > Date:   Wed May 19 17:33:39 2010 -0600
> > 
> >     module: drop the lock while waiting for module to complete initialization.
> 
> Hmm. That does seem to be buggy. We can't just drop and re-take the lock: 
> that may make sense _internally_ as far as resolve_symbol() itself is 
> concerned, but the caller will its own local variables, and some of those 
> will no longer be valid if the lock was dropped. 

Well, yes, obviously I missed something :(  I'll look at it tonight after
Arabella is asleep.

> That commit also changes the return value semantics of "use_module()", 
> which is an exported interface where the only users seem to be 
> out-of-kernel (the only in-kernel use is in kernel/module.c itself). That 
> seems like a really really bad idea too.

The kprobes guys: they were cc'd about the change.

> So I think reverting it is definitely the right thing to do. The commit 
> seems fundamentally broken.

> And having modules do request_module() in 
> their init functions has always been invalid anyway, so that excuse 
> doesn't really seem to be a reason to do anything crazy like this either.

I'd have to look back through the pre-git history, but we've dropped the
lock around the initfn for a long time now because people wanted to do odd
things (ISTR it sucked when modules oopsed on load, too).

So then we have the problem that crc32 is finished its init and needs the
lock back, and bnx2x which needs crc32 is waiting for it.  We could just
fail bnx2x; and in fact, we did prior to this patch (we timeout) and it breaks
network on booting on some box according to Brandon:

http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg04331.html

This *used* not to be a problem, because userspace placed locks on
modules and so it would never try to load bnx2x until crc32 was loaded.
ISTR a mention that Jon removed that...

> Rewriting the logic to
>  - not drop the lock
>  - not change the return semantics of an exported interface
>  - just make 'resolve_symbol()' fail if the module isn't fully loaded
> would seem to be a more reasonable approach, no?

Sure, then userspace needs to change :(

Rusty.
