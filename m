Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab1IGXvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 19:51:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54639 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756647Ab1IGXvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 19:51:14 -0400
Date: Wed, 7 Sep 2011 16:51:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: viro@zeniv.linux.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-media" <linux-media@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: Can you review or ack this patch?
Message-Id: <20110907165103.41b8b252.akpm@linux-foundation.org>
In-Reply-To: <201108230833.25812.hverkuil@xs4all.nl>
References: <201108230833.25812.hverkuil@xs4all.nl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 08:33:25 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> (and resent again, this time with the correct linux-fsdevel mail address)
> (Resent as requested by Andrew Morton since this is still stuck)
> 
> Hi Al, Andrew,
> 
> Can you take a look at this patch and send an Ack or review comments?
> 
> It's already been reviewed by Jon Corbet and we really need this functionality
> for v3.1. You were in the CC list in earlier postings:
> 
> Here: http://www.spinics.net/lists/linux-fsdevel/msg46753.html
> and here: http://www.mail-archive.com/linux-media@vger.kernel.org/msg34546.html
> 
> The patch also featured on LWN: http://lwn.net/Articles/450658/
> 
> Without your ack Mauro can't upstream this and we have a number of other
> patches that depend on this and are currently blocked.
> 
> We would prefer to upstream this patch through the linux-media git tree
> due to these dependencies.
> 
> My git branch containing this and the dependent patches is here:
> 
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/poll
> 
> Your help would be greatly appreciated (and your ack even more :-) )!

I'll grab the patch to get it a bit of testing while Al cogitates.

> 
> 
> [PATCH] poll: add poll_requested_events() function
> 
> In some cases the poll() implementation in a driver has to do different
> things depending on the events the caller wants to poll for. An example is
> when a driver needs to start a DMA engine if the caller polls for POLLIN,
> but doesn't want to do that if POLLIN is not requested but instead only
> POLLOUT or POLLPRI is requested. This is something that can happen in the
> video4linux subsystem.
> 
> Unfortunately, the current epoll/poll/select implementation doesn't provide
> that information reliably. The poll_table_struct does have it: it has a key
> field with the event mask. But once a poll() call matches one or more bits
> of that mask any following poll() calls are passed a NULL poll_table_struct
> pointer.
> 
> The solution is to set the qproc field to NULL in poll_table_struct once
> poll() matches the events, not the poll_table_struct pointer itself. That
> way drivers can obtain the mask through a new poll_requested_events inline.
> 
> The poll_table_struct can still be NULL since some kernel code calls it
> internally (netfs_state_poll() in ./drivers/staging/pohmelfs/netfs.h). In
> that case poll_requested_events() returns ~0 (i.e. all events).
> 
> Since eventpoll always leaves the key field at ~0 instead of using the
> requested events mask, that source was changed as well to properly fill in
> the key field.

It would be nice to find some suitable place in the code where we can
explain all this to other potential users of the capability.  Perhaps
the implementation site for the currently undocumented
poll_requested_events() would be a suitable place.

>
> ...
>
> -	epi->event.events = event->events;
> +	epi->event.events = pt.key = event->events;

coding style nit: we generally try to avoid multiple assignemnts like this.

>
> ...
>

