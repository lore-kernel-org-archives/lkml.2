Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798Ab1LJQZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 11:25:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:43126 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750826Ab1LJQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 11:25:50 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX18q729dpmsqcy2CNmQ9CPQJU1IRDY0hYnxf0b7jBm
	q8zPky+kz4rZg9
Date: Sat, 10 Dec 2011 17:25:38 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: boyd yang <boyd.yang@gmail.com>
Cc: eparis@redhat.com, xiyou.wangcong@gmail.com,
        Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fanotify: to differ file access event from different
 threads
Message-ID: <20111210162538.GB2773@Neptun>
References: <CAE8kqZJO_YZ855g2P3803-3ptExDeKX108x-Q_2Rz7rgz1iUew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE8kqZJO_YZ855g2P3803-3ptExDeKX108x-Q_2Rz7rgz1iUew@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 09:23:25AM +0800, boyd yang wrote:
> fanotify: to differ file access event from different threads
> When fanotify is monitoring the whole mount point "/", and multiple
> threads iterate the same direcotry, some thread will hang.
> This patch let fanotify to differ access events from different
> threads, prevent fanotify from merging access events from different
> threads.

I could reproduce the problem you described. Actually it may occur each time
when more than one thread of a process is waiting in fanotify_get_response() 
at the same time. This is since we are not prepared to wake up more than one 
waiter: We do 

wait_event(group->fanotify_data.access_waitq, event->response ||
			atomic_read(&group->fanotify_data.bypass_perm));

and after that 
  event->response = 0;

which is the reason that even if we woke up other waiters on the same waitqueue
they may see event->response being already 0, go back to sleep and then possibly 
hang forever.

> It also hide overflow events to reach user space.

This is not part of this patch and also should not be, since overflow
events are supposted to reach user space.

> -	if (event->mask & FAN_ALL_PERM_EVENTS) {
> -		/* if we merged we need to wait on the new event */
> -		if (notify_event)
> -			event = notify_event;
> -		ret = fanotify_get_response_from_access(group, event);
> +	/*if overflow, do not wait for response*/
> +	if (event->mask&FS_Q_OVERFLOW) {
> +		pr_debug("fanotify overflow!\n");
> +	}	else {
> +		if (event->mask & FAN_ALL_PERM_EVENTS) {
> +			/* if we merged we need to wait on the new event */
> +			if (notify_event)
> +				event = notify_event;
> +			ret = fanotify_get_response_from_access(group, event);
> +		}
>  	}

What is this for? All you do is introduce a debug message for no real reason.
However your fix (avoid merging of events from the same process) seems to work.

Regards,
Lino
