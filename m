Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0FAFT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:19:56 -0400
Received: from ozlabs.org ([203.10.76.45]:48626 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140Ab0FAFTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:19:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] module: fix bne2 "gave up waiting for init of module libcrc32c"
Date: Tue, 1 Jun 2010 14:49:50 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
References: <201005252300.07739.rjw@sisk.pl> <201006011127.14794.rusty@rustcorp.com.au> <alpine.LFD.2.00.1005312024320.3637@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005312024320.3637@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006011449.51587.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010 01:10:36 pm Linus Torvalds wrote:
> 
> On Tue, 1 Jun 2010, Rusty Russell wrote:
> 
> > On Tue, 1 Jun 2010 05:45:37 am Linus Torvalds wrote:
> > > 
> > > basically, we should do the whole module dependency list regardless 
> > > of whether we can unload modules or not 
> > 
> > Why?
> 
> Because the current non-CONFIG_MODULE_UNLOAD code is currently broken, and 
> it was broken exactly because the code had two totally different paths and 
> totally different logic. And one part simply missed the case.
> 
> We'd be much better off having as much of the logic shared as possible. 
> No?
> 
> Your 2/2 actually fixed that, because it moved the broken 
> wait_event_interruptible_timeout() out of the (non-shared) use_module() 
> into the (shared) resolve_symbol_wait(). But even that seemed to be almost 
> accidental, and seemed to be more about the fact that now the locking 
> rules required it (if you wanted to wait without holding the lock), rather 
> than anything else.

!CONFIG_MODULE_UNLOAD still does the old "fail don't wait" behavior.

So yes, moving the waiting into common code was a win for consistency,
either with your patch or mine.

> So I'd suggest we should just track those module dependencies, and share 
> more of the code and the logic. Because it looks to me like not sharing it 
> continually results in bugs.
> 
> No?

I wonder if we should just get rid of !CONFIG_UNLOAD then?  I have a soft spot
for it because it keeps us honest and shows how much shit is there simply for
our poor man's pagable kernel.

Let me compile up a kernel with and without and see what it's really doing
to us...

Thanks,
Rusty.
