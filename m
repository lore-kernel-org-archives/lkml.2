Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0FABEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 21:04:52 -0400
Received: from ozlabs.org ([203.10.76.45]:59070 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab0FABEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 21:04:50 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Tue, 1 Jun 2010 10:34:46 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201005312132.28631.rusty@rustcorp.com.au> <20100531094834.c1a684d1.akpm@linux-foundation.org>
In-Reply-To: <20100531094834.c1a684d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006011034.47739.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 02:18:34 am Andrew Morton wrote:
> On Mon, 31 May 2010 21:32:27 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > Problem: it's hard to avoid an init routine stumbling over a
> > request_module these days.  And it's not clear it's always a bad idea:
> > for example, a module like kvm with dynamic dependencies on kvm-intel
> > or kvm-amd would be neater if it could simply request_module the right
> > one.
> > 
> > In this particular case, it's libcrc32c:
> > 
> > 	libcrc32c_mod_init
> > 	 crypto_alloc_shash
> > 	  crypto_alloc_tfm
> > 	   crypto_find_alg
> > 	    crypto_alg_mod_lookup
> > 	     crypto_larval_lookup
> > 	      request_module
> > 
> > If another module is waiting for libcrc32c to finish initializing
> > (ie. bne2 depends on libcrc32c) then it does so holding the module
> > lock, and our request_module() can't make progress until that is
> > released.
> > 
> > Waiting without the lock isn't all that hard: we just need to pass the
> > -EBUSY up the call chain so we can sleep where we don't hold the lock.
> > Error reporting is a bit trickier: we need to copy the name of the
> > unfinished module before releasing the lock.
> 
> Who's returning -EBUSY?  request_module()?  If so, are you requiring
> that all code which might call request_module() be correctly
> propagating error codes back?  Please spell this all out?

Sorry if I was unclear.  It's all inside module.c.  Here's the updated
commentry:

 If another module is waiting inside resolve_symbol() for libcrc32c to
 finish initializing (ie. bne2 depends on libcrc32c) then it does so
 holding the module lock, and our request_module() can't make progress
 until that is released.

 Waiting inside resolve_symbol() without the lock isn't all that hard:
 we just need to pass the -EBUSY up the call chain so we can sleep
 where we don't hold the lock.  Error reporting is a bit trickier: we
 need to copy the name of the unfinished module before releasing the
 lock.

Hope that helps,
Rusty.
