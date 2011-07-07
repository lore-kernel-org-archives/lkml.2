Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1GGQm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 12:42:58 -0400
Received: from tex.lwn.net ([70.33.254.29]:58714 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab1GGQm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 12:42:57 -0400
Date: Thu, 7 Jul 2011 10:42:55 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-media" <linux-media@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [RFC PATCH] poll: add poll_requested_events() function
Message-ID: <20110707104255.6771771d@bike.lwn.net>
In-Reply-To: <201107011537.30829.hverkuil@xs4all.nl>
References: <201107011537.30829.hverkuil@xs4all.nl>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011 15:37:30 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> In some cases the poll() implementation in a driver has to do different
> things depending on the events the caller wants to poll for. An example is
> when a driver needs to start a DMA engine if the caller polls for POLLIN,
> but doesn't want to do that if POLLIN is not requested but instead only
> POLLOUT or POLLPRI is requested. This is something that can happen in the
> video4linux subsystem.

The change makes sense to me, FWIW.  One bit of trivia I noticed while
looking at it:

> @@ -796,7 +792,7 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
>  		 * All waiters have already been registered, so don't provide
>  		 * a poll_table to them on the next loop iteration.
>  		 */
> -		pt = NULL;
> +		pt->qproc = NULL;
>  		if (!count) {
>  			count = wait->error;
>  			if (signal_pending(current))

The comment at the beginning of this hunk is no longer accurate since the
poll_table is, indeed, still being supplied.  The previous comment in the
same function:

				/*
				 * Fish for events. If we found one, record it
				 * and kill the poll_table, so we don't
				 * needlessly register any other waiters after
				 * this. They'll get immediately deregistered
				 * when we break out and return.
				 */

Could also use tweaking.

jon
