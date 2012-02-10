Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab2BJQhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:37:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab2BJQhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:37:31 -0500
Date: Fri, 10 Feb 2012 17:30:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>
Subject: Re: I finally prepared a testcase for read(inotify_fd) getting
	EINTR on PTRACE_ATTACH
Message-ID: <20120210163058.GA30072@redhat.com>
References: <4F352565.6030402@redhat.com> <20120210144846.GA10798@redhat.com> <20120210150923.GA12322@redhat.com> <4F3543AA.5040003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F3543AA.5040003@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10, Denys Vlasenko wrote:
>
> On 02/10/2012 04:09 PM, Oleg Nesterov wrote:
>> On 02/10, Oleg Nesterov wrote:
>>> At first glance this looks obvious? I never used inotify and I never
>>> looked into fs/notify/inotify/, but it seems that inotify_read() simply
>>> returns -EINTR if signal_pending() and doesn't implement restarts.
>>>
>>> Probably this trivial change
>>>
>>> 	--- x/fs/notify/inotify/inotify_user.c
>>> 	+++ x/fs/notify/inotify/inotify_user.c
>>> 	@@ -264,7 +264,7 @@ static ssize_t inotify_read(struct file
>>> 			ret = -EAGAIN;
>>> 			if (file->f_flags&  O_NONBLOCK)
>>> 				break;
>>> 	-		ret = -EINTR;
>>> 	+		ret = -ERESTARTSYS;
>>> 			if (signal_pending(current))
>>> 				break;
>>>
>>>
>>> makes sense.
>>
>> except I meant -ERESTARTNOHAND to avoid the behavioural change.
>
> I run-tested the fix. It works: testcase no longer fails
> (modulo incorrect logic in the testcase which wase not working
> properly on "no bug detected" code path. Fixed one:
> http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/tests/eintr-on-attach.c?cvsroot=systemtap
> )

Good, thanks.

> I'm not sure inotify really wants to deviate from other reads
> and return -EINTR even for SA_RESTARTing signals. IOW:
> I think -ERESTARTSYS here would be more correct than -ERESTARTNOHAND.

I am not sure either. ERESTARTNOHAND doesn't change the behaviour,
that was my point.

But I agree, ERESTARTSYS makes more sense to me.

Oleg.

