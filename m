Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab2BWUEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:04:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52174 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443Ab2BWUEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:04:35 -0500
Message-ID: <4F469BC7.50705@linux.vnet.ibm.com>
Date: Thu, 23 Feb 2012 12:04:23 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home>
In-Reply-To: <alpine.DEB.2.00.1202231334290.10914@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022320-9360-0000-0000-000003E9EF02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 11:40 AM, Christoph Lameter wrote:
> On Thu, 23 Feb 2012, Dave Hansen wrote:
>>> Hmmm isnt the race still there between the determination of the task and
>>> the get_task_struct()? You would have to verify after the get_task_struct
>>> that this is really the task we wanted to avoid the race.
>>
>> It's true that selecting a task by pid is inherently racy.  What that
>> code does is ensure that the task you've got current has 'pid', but not
>> ensure that 'pid' has never represented another task.  But, that's what
>> we do everywhere else in the kernel; there's not much better that we can do.
> 
> We may at this point be getting a reference to a task struct from another
> process not only from the current process (where the above procedure is
> valid). You rightly pointed out that the slab rcu free mechanism allows a
> free and a reallocation within the RCU period.

I didn't _mean_ to point that out, but I think I realize what you're
talking about.  What we have before this patch is this:

        rcu_read_lock();
        task = pid ? find_task_by_vpid(pid) : current;
        rcu_read_unlock();

	task->foo;

So, the task at task->foo time is neither RCU-protected nor protected by
having a reference.  I changed it to:

        rcu_read_lock();
        task = pid ? find_task_by_vpid(pid) : current;
	get_task_struct(task);
        rcu_read_unlock();

	task->foo;

That keeps task from being freed.  But, as you point out

> The effect is that the task
> struct could be pointing to a task with another pid that what we were
> looking for and therefore migrate_pages could subsequently be operating on
> a totally different process.
> 
> The patch does not fix that race so far.

Agreed, this patch would not fix such an issue.

I think this also implies that stuff like get_task_pid() is broken,
along with virtually all of the users of find_task_by_vpid().  Eric, any
thoughts on this?

> I think you have to verify that the pid of the task matches after you took
> the refcount in order to be safe. If it does not match then abort.
> 
>> Maybe "race" is the wrong word for what we've got here.  It's a lack of
>> a refcount being taken.
> 
> Is that a real difference or are you just playing with words?

I think we're talking about two different things:
1. does RCU protect the pid->task lookup sufficiently?
2. Can the task simply go away in the move/migrate_pages() calls?

I think we're on the same page now.

