Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab0EaUUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:20:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059Ab0EaUUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:20:05 -0400
Date: Mon, 31 May 2010 13:15:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Brandon Philips <brandon@ifup.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201005312130.17038.rusty@rustcorp.com.au> <201005312131.43238.rusty@rustcorp.com.au> <201005312132.28631.rusty@rustcorp.com.au> <20100531094834.c1a684d1.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 31 May 2010, Linus Torvalds wrote:
> 
> It's entirely possible that an interim fix (if we can't just fix the 
> locking) is to _not_ use "strong_try_module_get()" at all, but instead 
> just use "try_module_get()", and then after we've dropped the 
> module_mutex, but _before_ we call the "init" function for the module, we 
> wait for all the modules that this module depends on.
> 
> IOW, we'd link to other modules _before_ they are necessarily initialized 
> (their symbol tables will be as initialized as they are going to be), but 
> then before we call our own initialization routines we make sure that the 
> modules we linked to have finished theirs.
> 
> Doesn't that sound like the logical thing to do? And it wouldn't change 
> any locking.

Ok, this is a two-patch series to do exactly that. It's totally untested, 
although I _have_ booted the result, and tested that module loading and 
unloading works. But I haven't tested the race condition, obviously.

It looks sane, and quite frankly, I think it's a much better design than 
what we have now. I also note that the old code was broken for the case of 
not having CONFIG_MODULE_UNLOAD - I didn't fix it, but it should be easy 
to do (basically, we should do the whole module dependency list regardless 
of whether we can unload modules or not - we _do_ need it in order to get 
that whole case of waiting for them to load right).

The first patch doesn't really change anything, it just cleans things up 
and introduces the two-way module usage list that the second patch needs 
in order to wait for modules that we use to initialize.

Comments? Brandon - does this work for you? I may well have missed 
something.

			Linus
