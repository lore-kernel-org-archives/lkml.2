Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932976Ab2EOVjD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:39:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133Ab2EOVjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:39:01 -0400
Date: Tue, 15 May 2012 14:38:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Ledford <dledford@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc/mqueue: use correct gfp flags in msg_insert
Message-Id: <20120515143859.c3cad9b7.akpm@linux-foundation.org>
In-Reply-To: <4FB1C365.3090006@redhat.com>
References: <1337029525-8760-1-git-send-email-levinsasha928@gmail.com>
	<20120514165401.e4efc2fd.akpm@linux-foundation.org>
	<4FB1C365.3090006@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012 22:45:57 -0400
Doug Ledford <dledford@redhat.com> wrote:

> On 5/14/2012 7:54 PM, Andrew Morton wrote:
> > On Mon, 14 May 2012 23:05:25 +0200
> > Sasha Levin <levinsasha928@gmail.com> wrote:
> > 
> >> msg_insert() tries to allocate using GFP_KERNEL, while in both cases when it's called,
> >> it's coming from an atomic context. Introduced by 7dd7edf ("ipc/mqueue: improve
> >> performance of send/recv").
> >>
> >> Use GFP_ATOMIC instead.
> >>
> >> Also, fix up coding style in the kzalloc while we're there.
> >>
> >> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> >> ---
> >>  ipc/mqueue.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> >> index 30f6f8f..9ec6896 100644
> >> --- a/ipc/mqueue.c
> >> +++ b/ipc/mqueue.c
> >> @@ -133,7 +133,7 @@ static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
> >>  		else
> >>  			p = &(*p)->rb_right;
> >>  	}
> >> -	leaf = kzalloc(sizeof(struct posix_msg_tree_node), GFP_KERNEL);
> >> +	leaf = kzalloc(sizeof(*leaf), GFP_ATOMIC);
> >>  	if (!leaf)
> >>  		return -ENOMEM;
> >>  	rb_init_node(&leaf->rb_node);
> > 
> > hm, that should have spewed warnings everywhere the first time anyone
> > tested it.  Doug, is a re-read of Documentation/SubmitChecklist needed?
> 
> Re-read?  I never it read it a first time, so hard for me to re-read it.
>  But thanks for pointing it out.  Now I've read it.

I was being nice ;)

> > Switching to GFP_ATOMIC is a bit regrettable.  Can we avoid this by
> > speculatively allocating the memory before taking the lock, then free
> > it again if we ended up not using it?
> 
> Not really, we take the lock in a different function than this and would
> have to pass around a node struct and then free it if we didn't use it.
>  I mean, it could be done, but it would fugly the calls around this up.
>  The msg_insert() routine is called in two places.  In one place, the
> lock is taken right there so you could allocate before and then call.
> In the other, it is another function called with the lock held so now
> you would have to pass the possible mem allocation around two functions.
>  Doable, but ugly.

Well, it's not *too* bad: just pass a void** around, zero it if it got
used, then unconditionally free it.  Nice and easy.

But in a contest between source-level beauty and runtime robustness,
robustness surely wins?

>  On the other hand, this is a small struct that
> should be coming off one of the small size kmem cache pools (4 pointers
> total, a long, and an int, so kmalloc-32 or kmalloc-64 depending on
> arch).  That doesn't seem like a likely candidate to fail if there is
> memory pressure, especially considering that immediately prior to taking
> the lock we call kmalloc with GFP_KERNEL (as part of load_msg()) and so
> we should either not be under serious memory pressure or we would have
> slept waiting for it to ease up.

True.  But weaselly!

> I think I can imagine a better way to do this though as part of the
> whole request to cache at least one rbnode entry so we get the 0 message
> performance of the queue back.  I'll send that patch through once I've
> verified it does what I think it will.

That sounds good.
