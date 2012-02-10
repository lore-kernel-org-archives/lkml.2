Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab2BJQT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:19:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758164Ab2BJQT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:19:59 -0500
Message-ID: <4F3543AA.5040003@redhat.com>
Date: Fri, 10 Feb 2012 17:19:54 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>
Subject: Re: I finally prepared a testcase for read(inotify_fd) getting EINTR
 on PTRACE_ATTACH
References: <4F352565.6030402@redhat.com> <20120210144846.GA10798@redhat.com> <20120210150923.GA12322@redhat.com>
In-Reply-To: <20120210150923.GA12322@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 04:09 PM, Oleg Nesterov wrote:
> On 02/10, Oleg Nesterov wrote:
>> At first glance this looks obvious? I never used inotify and I never
>> looked into fs/notify/inotify/, but it seems that inotify_read() simply
>> returns -EINTR if signal_pending() and doesn't implement restarts.
>>
>> Probably this trivial change
>>
>> 	--- x/fs/notify/inotify/inotify_user.c
>> 	+++ x/fs/notify/inotify/inotify_user.c
>> 	@@ -264,7 +264,7 @@ static ssize_t inotify_read(struct file
>> 			ret = -EAGAIN;
>> 			if (file->f_flags&  O_NONBLOCK)
>> 				break;
>> 	-		ret = -EINTR;
>> 	+		ret = -ERESTARTSYS;
>> 			if (signal_pending(current))
>> 				break;
>>
>>
>> makes sense.
>
> except I meant -ERESTARTNOHAND to avoid the behavioural change.

I run-tested the fix. It works: testcase no longer fails
(modulo incorrect logic in the testcase which wase not working
properly on "no bug detected" code path. Fixed one:
http://sources.redhat.com/cgi-bin/cvsweb.cgi/~checkout~/tests/ptrace-tests/tests/eintr-on-attach.c?cvsroot=systemtap
)

I'm not sure inotify really wants to deviate from other reads
and return -EINTR even for SA_RESTARTing signals. IOW:
I think -ERESTARTSYS here would be more correct than -ERESTARTNOHAND.

If -ERESTARTNOHAND is really what inotify people want, they need to
add a comment about it.

-- 
vda
