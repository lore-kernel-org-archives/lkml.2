Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0EaQtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 12:49:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754088Ab0EaQtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 12:49:13 -0400
Date: Mon, 31 May 2010 09:48:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2
 "gave up waiting for init of module libcrc32c"
Message-Id: <20100531094834.c1a684d1.akpm@linux-foundation.org>
In-Reply-To: <201005312132.28631.rusty@rustcorp.com.au>
References: <201005252300.07739.rjw@sisk.pl>
	<201005312130.17038.rusty@rustcorp.com.au>
	<201005312131.43238.rusty@rustcorp.com.au>
	<201005312132.28631.rusty@rustcorp.com.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 21:32:27 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:

> Problem: it's hard to avoid an init routine stumbling over a
> request_module these days.  And it's not clear it's always a bad idea:
> for example, a module like kvm with dynamic dependencies on kvm-intel
> or kvm-amd would be neater if it could simply request_module the right
> one.
> 
> In this particular case, it's libcrc32c:
> 
> 	libcrc32c_mod_init
> 	 crypto_alloc_shash
> 	  crypto_alloc_tfm
> 	   crypto_find_alg
> 	    crypto_alg_mod_lookup
> 	     crypto_larval_lookup
> 	      request_module
> 
> If another module is waiting for libcrc32c to finish initializing
> (ie. bne2 depends on libcrc32c) then it does so holding the module
> lock, and our request_module() can't make progress until that is
> released.
> 
> Waiting without the lock isn't all that hard: we just need to pass the
> -EBUSY up the call chain so we can sleep where we don't hold the lock.
> Error reporting is a bit trickier: we need to copy the name of the
> unfinished module before releasing the lock.

Who's returning -EBUSY?  request_module()?  If so, are you requiring
that all code which might call request_module() be correctly
propagating error codes back?  Please spell this all out?

Because I keep on coming across code which does

	if (foo() < 0)
		return -EWHATEVER;

or
		return -1;

I try to stamp it out, but they have me outnumbered.

I think transgressions are sufficiently rare that the patch will be OK.
Plus we needed to fix transgressors anyway.

After your changes, what would be the observable effects if this code
encountered a return-value-corruptor?


Also, I bet there are drivers which return -EBUSY from their
module_init() functions if the hardware's in an unexpected state.  What
happens?

