Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab0EaSYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:24:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581Ab0EaSYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:24:03 -0400
Date: Mon, 31 May 2010 11:19:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Brandon Philips <brandon@ifup.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <20100531094834.c1a684d1.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201005312130.17038.rusty@rustcorp.com.au> <201005312131.43238.rusty@rustcorp.com.au> <201005312132.28631.rusty@rustcorp.com.au> <20100531094834.c1a684d1.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 31 May 2010, Andrew Morton wrote:
> 
> Who's returning -EBUSY?  request_module()?  If so, are you requiring
> that all code which might call request_module() be correctly
> propagating error codes back?  Please spell this all out?

The problem roughly as follows:

	task 1				task 2
	------				------

	request_module("crc32c")
	gets module_mutex
	...
	drops module_mutex in otder to run "init"
					request_module("bne2");
					gets module_mutex
					wants to link to crc32:
					use_module("bne2", "crc32c")
					.. 
					strong_try_module_get() returns -EBUSY
					because it's not initialized yet
	calls libcrc32c_mod_init
	 ...
          request_module(optimized crc32c)
	  waits for module_mutex
	  that is held by the bne2 loading

					.. gives up .. BOOM ..
					releases module_mutex
					returns error
	finishes successfully


because the module locking is pure and utter crap. It uses one hug lock 
that it tries to hold for a long time, rather than protecting just the 
parts it needs.

Rusty's fix is to just drop the lock around use_module(), and it seems to 
work. It's may be right for 'use_module()', but totally wrong from a 
conceptual locking standpoint, though - dropping the lock in the middle of 
module loading may well "work", but who the hell knows what it really 
results in?

IOW, it's one of those "this works, but it's very wrong" things. It makes 
the whole module_mutex pretty much a random thing with even less semantics 
than it has now. Right now it has some clear area that it protects - the 
area may be too _big_, but at least it makes some amount of sense. 

The proper fix would appear to be to actually fix locking, which probably 
implies turning most of "module_mutex" into a spinlock that protects just 
the _real_ critical sections. I don't think there are any real blocking 
things except for that "wait for another module to load" case, which is 
obviously exactly where we cannot hold the lock in the first place.

So rather than having one large area that gets protected but then dropping 
the lock in random places, we should probably just have lots of small 
areas that are clearly defined and protected.

And a _lot_ of the module loading doesn't need any locks at all. Much of 
the real work is probably totally private, ie loading the actual module 
and setting things up before we really expose it. We hold that big lock 
over a ridiculously large area right now (basically _all_ of module 
loading except the actual init sequence for a module).

> Also, I bet there are drivers which return -EBUSY from their
> module_init() functions if the hardware's in an unexpected state.  What
> happens?

Nothing. See above: this is a special case, and it's really just about 
strong_try_module_get() returning EBUSY for one special reason.

It's entirely possible that an interim fix (if we can't just fix the 
locking) is to _not_ use "strong_try_module_get()" at all, but instead 
just use "try_module_get()", and then after we've dropped the 
module_mutex, but _before_ we call the "init" function for the module, we 
wait for all the modules that this module depends on.

IOW, we'd link to other modules _before_ they are necessarily initialized 
(their symbol tables will be as initialized as they are going to be), but 
then before we call our own initialization routines we make sure that the 
modules we linked to have finished theirs.

Doesn't that sound like the logical thing to do? And it wouldn't change 
any locking.

			Linus
