Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934410Ab2DLPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:25:28 -0400
Received: from numidia.opendz.org ([98.142.220.152]:57978 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934369Ab2DLPZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:25:26 -0400
Date: Thu, 12 Apr 2012 16:29:27 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 5/6] proc: use task_access_lock() instead of
 ptrace_may_access()
Message-ID: <20120412152927.GA18097@dztty>
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
 <1334123976-11681-5-git-send-email-xiyou.wangcong@gmail.com>
 <4F86D702.30209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F86D702.30209@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cong,

On Thu, Apr 12, 2012 at 09:22:10PM +0800, Cong Wang wrote:
> On 04/11/2012 01:59 PM, Cong Wang wrote:
> > There are several places in fs/proc/base.c still use ptrace_may_access()
> > directly to check the permission, actually this just gets a snapshot of
> > the permission, nothing prevents the target task from raising the priviledges
> > itself, it is better to use task_access_lock() for these places, to hold
> > the priviledges.
> >
> Hi, Andrew,
> 
> Please drop this patch, it introduces a deadlock when execve() a 
> /proc/<pid>/exec file, and it is not a big improvement nor fixes any 
> bugs, so let's just drop this one.
I was going to ask about this since it seems that abusing lock_trace()
or task_access_lock() can cause problems.

Please see commit 5e442a493fc59f which reverts commit aa6afca5bcaba8101f
that tries to protect /proc/PID/fd** files


IMHO A solution for some of the simple /proc/<pid>/* files is to use
mm_access() check just after gathering data and before returning it to
userspace.

So IMO the original code of proc_pid_wchan() was correct, since that data
is not copied to userspace directly, and we can avoid the mm_access() and
the task->signal->cred_guard_mutex lock since we do not race against them,
we have already grabbed the 'wchan', a simple ptrace_may_access() check will
do the job.

(I guess there is a window against another execve and ptrace_may_access()
but that returned data is not useful anymore, is it ?).


For others I don't know what would be the best solution.

Thanks.

> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
tixxdz
http://opendz.org
