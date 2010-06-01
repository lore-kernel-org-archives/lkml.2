Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0FADpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:45:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753973Ab0FADpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:45:05 -0400
Date: Mon, 31 May 2010 20:40:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module
 libcrc32c"
In-Reply-To: <201006011127.14794.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.1005312024320.3637@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org> <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org> <201006011127.14794.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Rusty Russell wrote:

> On Tue, 1 Jun 2010 05:45:37 am Linus Torvalds wrote:
> > 
> > basically, we should do the whole module dependency list regardless 
> > of whether we can unload modules or not 
> 
> Why?

Because the current non-CONFIG_MODULE_UNLOAD code is currently broken, and 
it was broken exactly because the code had two totally different paths and 
totally different logic. And one part simply missed the case.

We'd be much better off having as much of the logic shared as possible. 
No?

Your 2/2 actually fixed that, because it moved the broken 
wait_event_interruptible_timeout() out of the (non-shared) use_module() 
into the (shared) resolve_symbol_wait(). But even that seemed to be almost 
accidental, and seemed to be more about the fact that now the locking 
rules required it (if you wanted to wait without holding the lock), rather 
than anything else.

In contrast, wouldn't it be nice if we just made the waiting be a separate 
event entirely? And have the !MODULE_UNLOAD case also able to share the 
/proc/module format, for example? 

You do realize - although maybe you don't - that right now, even with your 
2/2 case, the !MODULE_UNLOAD case seems to get the module ref-counts 
wrong. I didn't look through it all, but it _seems_ to increment the 
ref-count for every symbol it resolves. 

What happens if the module load fails in the middle (say, because some 
symbols referred to module 'a' that was loaded successfully, and others 
refer to module 'b' that had some probelsm)? I think the !MODULE_UNLOAD 
case is _broken_ again.

Why?

Take a small guess. It's broken - even with your 2/2 - exactly because the 
!MODULE_UNLOAD case does something fundamentally different from the 
regular case. It increments the module counts for each symbol it looks up, 
exactly BECAUSE IT DOESN'T TRACK MODULE DEPENDENCIES!

Which means that it then cannot clean up properly afterwards if an error 
happens in the middle.

So I'd suggest we should just track those module dependencies, and share 
more of the code and the logic. Because it looks to me like not sharing it 
continually results in bugs.

No?

			Linus
