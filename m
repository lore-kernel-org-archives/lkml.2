Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab0CaDoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 23:44:54 -0400
Received: from ozlabs.org ([203.10.76.45]:57583 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab0CaDow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 23:44:52 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nick Piggin <npiggin@gmail.com>
Subject: Re: Is module refcounting racy?
Date: Wed, 31 Mar 2010 14:14:49 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
References: <20100318105533.GE25636@laptop> <201003291942.56706.rusty@rustcorp.com.au> <e619185d1003290958w23037176uc869c7dbc0a48bcc@mail.gmail.com>
In-Reply-To: <e619185d1003290958w23037176uc869c7dbc0a48bcc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003311414.49364.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010 03:28:49 am Nick Piggin wrote:
> On Mon, Mar 29, 2010 at 8:12 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Thu, 18 Mar 2010 09:25:34 pm Nick Piggin wrote:
> >> Hey,
> >>
> >> I've been looking at weird and wonderful ways to do scalable refcounting,
> >> for the vfs...
> >>
> >> Sadly, module refcounting doesn't fit my bill. But as far as I could see,
> >> it is racy.
> >
> > Other than for advisory purposes, the refcount is only checked against zero
> > under stop_machine.  For exactly this reason.
> 
> There definitely looks to me like there is code that checks the refcount
> *without* stop_machine. module_refcount is an exported function, and you
> expect drivers to get this right (scsi_device_put for a trivial example)

No, but there's a lot of history of crap drivers which wanted to poke at it.
And it's cute for debugging.

The scsi code is simply wrong.  But noone cares, since module removal is
so rare.

> , but
> it even looks like it is used in a racy way in kernel/module.c code.

Yep, though I don't know if anyone uses waiting module removal AFAICT
though; there's not even a modprobe option for it.

> Either we need to take my patch, or audit t, and put a WARN_ON
> if it is called while not under stop_machine.

So can you send me a proper annotated signed-off patch to queue?

Note that years ago it was decided that module reference counting would be
best effort, rather than perfect.  I disagreed, but we've lived with it
surprisingly well.

I wonder if by caring even *less*, we can lose a lot of complexity without
noticeably increasing the bug count.  Make modules run their own reference
counts and just sleep for a while to see if the reference count changes.
If not, assume it's good to be removed.  If reference count still hasn't
moved after another minute or so, actually free the memory.

Thanks,
Rusty.
