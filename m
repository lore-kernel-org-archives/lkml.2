Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953Ab2AITSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:18:36 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52184 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab2AITSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:18:35 -0500
MIME-Version: 1.0
In-Reply-To: <20120109190450.GA26390@infradead.org>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu> <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk> <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
 <CA+55aFxRroO0KAz8qbhz_2vDc=bc-C2b0ux0tdFfQhBGMnqRzQ@mail.gmail.com> <20120109190450.GA26390@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Jan 2012 11:18:13 -0800
X-Google-Sender-Auth: wcrHgcZOOQOr2H07absMgzFQYdA
Message-ID: <CA+55aFweg+A0GmEZM=tTHfMPqT_=7ioq3FBFMefsTgcxEgaXYA@mail.gmail.com>
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgorman@suse.de, gregkh@suse.de, akpm@linux-foundation.org,
        david@fromorbit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 11:04 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> After Dave's patch select_parent isolates dentries that are going to
> be dropped directly to an on-stack list instead of abusing the LRU.
>
> With that scheme the trylock and retry loop in __shrink_dcache_sb
> goes away completely for this caller.

Yes, but it still exists for the prune_dcache_sb() case.

So prune_dcache_sb() puts random dentries on its own private lists,
and drops the lru_lock (and the dentry lock).

In the meantime, what protects us from select_parent() finding those
*same* dentries, and doing

    dentry_lru_move_list(dentry, dispose);

which - despite the name - moves the dentry not from the lru list, but
from the prune_dcache_sb local list to the select_parent() local
list..

Hmm. I guess the endless "move back-and-forth" thing is gone, but the
random "move from one private list to another" makes me worry about
the confusion.

But I guess we don't care - the same thing is going to happen to the
dentry regardless of which of the local lists it is on.

And in any case, I think Dave's patch looks like a nice cleanup. Does
it work for people in that forward-ported-alone version I sent out?

And Miklos, does it fix your test-case? Because if so, I think Dave's
patch is nicer, and avoids adding a new state bit by just cleaning
things up in general.

                        Linus
