Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab2JJAQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:16:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54612 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2JJAQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:16:33 -0400
Date: Tue, 9 Oct 2012 17:16:30 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 4/5] aio: vmap ringbuffer
Message-ID: <20121010001630.GC26835@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-4-git-send-email-koverstreet@google.com>
 <20121009182949.GO26187@lenny.home.zabbo.net>
 <20121009213111.GE29494@google.com>
 <20121009223210.GR26187@lenny.home.zabbo.net>
 <20121009224428.GH29494@google.com>
 <20121009225836.GU26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009225836.GU26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 03:58:36PM -0700, Zach Brown wrote:
> > Not if we decouple the ringbuffer size from max_requests.
> 
> Hmm, interesting.
> 
> > This would be useful to do anyways because right now, allocating a kiocb
> > has to take a global refcount and check head and tail in the ringbuffer
> > just so it can avoid overflowing the ringbuffer.
> 
> I'm not sure what you mean by a 'global refcount'.. do you mean the
> per-mm ctx_lock?

kioctx->reqs_active. We just have to keep that count somehow if we're
going to avoid overflowing the ringbuffer.

> > If we change aio_complete() so that if the ringbuffer is full then the
> > kiocb just goes on a linked list - we can size the ringbuffer so this
> > doesn't happen normally and avoid the global synchronization in the fast
> > path.
> 
> How would completion events make their way from the list to the ring if
> an app is only checking the ring for completions from userspace?

Either they'd have to make a syscall when the ringbuffer is empty- which
should be fine, because at least for most apps all they could do is
sleep or spin. Alternately we could maintain a flag next to the tail
pointer in the ringbuffer that the kernel could maintain, if userspace
wants to be able to avoid that syscall when it's not necessary.

Although - since current libaio skips the syscall if the ringbuffer is
empty, this is yet another thing we can't do with the current
ringbuffer.

Crap.

Well, we should be able to hack around it with the existing
ringbuffer... normally, if the ringbuffer is full and stuff goes on the
list, then there's going to be more completions coming later and stuff
would get pulled off the list then.

The only situation you have to worry about is when the ringbuffer fills
up and stuff goes on the list, and then completions completely stop -
this should be a rare enough situation that maybe we could just hack
around it with a timer that gets flipped on when the list isn't empty.

Also, for this to be an issue at all, _all_ the reaping would have to be
done from userspace - since existing libaio doesn't do that, there may
not be any code out there which triggers it.
