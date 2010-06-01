Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab0FABVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 21:21:30 -0400
Received: from ozlabs.org ([203.10.76.45]:58724 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0FABV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 21:21:29 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Tue, 1 Jun 2010 10:51:24 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <20100531094834.c1a684d1.akpm@linux-foundation.org> <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006011051.25636.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 03:49:14 am Linus Torvalds wrote:
> because the module locking is pure and utter crap. It uses one hug lock 
> that it tries to hold for a long time, rather than protecting just the 
> parts it needs.

Originally it was a big lock around module loading.  That was simple, and
simple is good.

Sure, that simplicity has been eroded, but "crap" is harsh.
 
> Rusty's fix is to just drop the lock around use_module(), and it seems to 
> work. It's may be right for 'use_module()', but totally wrong from a 
> conceptual locking standpoint, though - dropping the lock in the middle of 
> module loading may well "work", but who the hell knows what it really 
> results in?

I do.  If I didn't think so, I wouldn't have pushed the patch.

> IOW, it's one of those "this works, but it's very wrong" things. It makes 
> the whole module_mutex pretty much a random thing with even less semantics 
> than it has now. Right now it has some clear area that it protects - the 
> area may be too _big_, but at least it makes some amount of sense.

See, this I agree with, but you could have said this in far fewer words and
much more politely.

As posted, I had a patch to clean up the locking.  Seems you ignored it.

> It's entirely possible that an interim fix (if we can't just fix the 
> locking) is to _not_ use "strong_try_module_get()" at all, but instead 
> just use "try_module_get()", and then after we've dropped the 
> module_mutex, but _before_ we call the "init" function for the module, we 
> wait for all the modules that this module depends on.

No, those modules could still fail init.

> Doesn't that sound like the logical thing to do? And it wouldn't change 
> any locking.

No, it sounds wrong, complex and fundamentally broken.

Rusty.
