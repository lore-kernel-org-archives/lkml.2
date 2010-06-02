Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0FBI6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 04:58:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48541 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0FBI6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 04:58:43 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/2] tmpfs: Quick token library to allow scalable retrieval of tokens from token jar
From: Andi Kleen <andi@firstfloor.org>
References: <1274902371.31973.9392.camel@mudge.jf.intel.com>
	<20100601145126.f46572d1.akpm@linux-foundation.org>
Date: Wed, 02 Jun 2010 10:58:42 +0200
In-Reply-To: <20100601145126.f46572d1.akpm@linux-foundation.org> (Andrew Morton's message of "Tue\, 1 Jun 2010 14\:51\:26 -0700")
Message-ID: <87ocftyfnh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

I am to blame for the "token jar" name.

> OK, thanks.  But I'm still struggling a bit in understanding the
> applicability.  Where else might one use this?  What particular
> problem is it good at solving?

I wrote a similar scheme a long time ago for IP protocol ID
allocation (but that code never ended up in mainline).
Back then it was called "cookie jar" and you can actually
still google for it :)

It can be used for pretty much anything where you have
a global resource and want to hand it out to different CPUs,
but still have a global limit that is enforced.

For example a file system could use it for accounting 
free space too.

In principle you could even use it for pids for example
or other IDs.

>
> I think the problem here is that you're using the term "token jar" as
> if others already know what a token jar _is_.  I guess I was asleep
> during that compsci lecture, but google doesn't appear to know about
> the term either.
>
> And from looking at the tmpfs caller, it appears that the token jar is
> being used to speed up the access to a single `unsigned long
> free_blocks'.  Could we have used say a percpu_counter instead?

You need some synchronization, otherwise the accounting
would not be exact and you could overflow. Yes you could
open code it, but having it in a library is nicer.

That's what the token jar provides.

You grab some tokens out of the jar and to be fast take multiple in
advance. And there's a watchman who forces you to give them back if you
don't really need them all and they run low.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
