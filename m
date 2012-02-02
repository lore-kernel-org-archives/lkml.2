Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab2BBWsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:48:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab2BBWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:48:37 -0500
Date: Thu, 2 Feb 2012 14:48:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv7 PATCH 2/4] poll: add poll_requested_events() and
 poll_does_not_wait() functions
Message-Id: <20120202144835.5ccd3a76.akpm@linux-foundation.org>
In-Reply-To: <54c55b11bba94b57a76ca7553f735bcb822aa43d.1328176079.git.hans.verkuil@cisco.com>
References: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
	<54c55b11bba94b57a76ca7553f735bcb822aa43d.1328176079.git.hans.verkuil@cisco.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Feb 2012 11:26:55 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
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
> Very rarely drivers might want to know whether poll_wait will actually wait.
> If another earlier file descriptor in the set already matched the events the
> caller wanted to wait for, then the kernel will return from the select() call
> without waiting.
> 
> A new helper function poll_does_not_wait() is added that drivers can use to
> detect this situation.
> 
> Drivers should no longer access any of the poll_table internals, but use the
> poll_requested_events() and poll_does_not_wait() access functions instead.

A way to communicate and enforce this is to rename the relevant fields.  Prepend
a "_" to them and add a stern comment.


> Since the behavior of the qproc field changes with this patch (since this
> function pointer can now be NULL when that wasn't possible in the past) I
> have renamed that field from qproc to pq_proc. Any out-of-tree driver that
> uses it will now fail to compile.
> 
> Some notes regarding the correctness of this patch: the driver's poll()
> function is called with a 'struct poll_table_struct *wait' argument. This
> pointer may or may not be NULL, drivers can never rely on it being one or
> the other as that depends on whether or not an earlier file descriptor in
> the select()'s fdset matched the requested events.
> 
> ...
> 
