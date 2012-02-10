Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2BJPP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:15:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab2BJPPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:15:55 -0500
Date: Fri, 10 Feb 2012 16:09:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>
Subject: Re: I finally prepared a testcase for read(inotify_fd) getting
	EINTR on PTRACE_ATTACH
Message-ID: <20120210150923.GA12322@redhat.com>
References: <4F352565.6030402@redhat.com> <20120210144846.GA10798@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210144846.GA10798@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Oleg Nesterov wrote:
>
> Add CC's,
>
> On 02/10, Denys Vlasenko wrote:
> >
> > I recalled that I saw a spurious EINTR on strace attach.
> > I found time/inspiration to create an isolated testcase for it.
> > Already committed it to ptrace-tests.
> >
> > The code: skip all the cruft, read reproduce() function body.
> > It's quite straightforward.
> >
> > $ gcc -Wall -Os eintr-on-attach.c -oeintr-on-attach
> > $ ./eintr-on-attach 1;echo 1
> > bug: read was interrupted by attach, errno: Interrupted system call
>
> At first glance this looks obvious? I never used inotify and I never
> looked into fs/notify/inotify/, but it seems that inotify_read() simply
> returns -EINTR if signal_pending() and doesn't implement restarts.
>
> Probably this trivial change
>
>
> 	--- x/fs/notify/inotify/inotify_user.c
> 	+++ x/fs/notify/inotify/inotify_user.c
> 	@@ -264,7 +264,7 @@ static ssize_t inotify_read(struct file
> 			ret = -EAGAIN;
> 			if (file->f_flags & O_NONBLOCK)
> 				break;
> 	-		ret = -EINTR;
> 	+		ret = -ERESTARTSYS;
> 			if (signal_pending(current))
> 				break;
>
>
> makes sense.

except I meant -ERESTARTNOHAND to avoid the behavioural change.

Oleg.

