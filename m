Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2BXRHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 12:07:06 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50421 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab2BXRHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:07:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of kosaki.motohiro@gmail.com designates 10.68.129.162 as permitted sender) smtp.mail=kosaki.motohiro@gmail.com; dkim=pass header.i=kosaki.motohiro@gmail.com
Message-ID: <4F47C3B7.20109@gmail.com>
Date: Fri, 24 Feb 2012 12:07:03 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kosaki.motohiro@gmail.com
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home> <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home>
In-Reply-To: <alpine.DEB.2.00.1202240859340.2621@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2/24/12 10:20 AM), Christoph Lameter wrote:
> On Thu, 23 Feb 2012, Eric W. Biederman wrote:
>
>>> The bug in migrate_pages() is that we do a rcu_unlock and a rcu_lock. If
>>> we drop those then we should be safe if the use of a task pointer within a
>>> rcu section is safe without taking a refcount.
>>
>> Yes the user of a task_struct pointer found via a userspace pid is valid
>> for the life of an rcu critical section, and the bug is indeed that we
>> drop the rcu_lock and somehow expect the task to remain valid.
>>
>> The guarantee comes from release_task.  In release_task we call
>> __exit_signal which calls __unhash_process, and then we call
>> delayed_put_task to guarantee that the task lives until the end of the
>> rcu interval.
>
> Ah. Ok. Great.
>
>> In migrate_pages we have a lot of task accesses outside of the rcu
>> critical section, and without a reference count on task.
>
> Yes but that is only of interesting for setup and verification of
> permissions. What matters during migration is that the mm_struct does not
> go away and we take a refcount on that one.
>
>> I tell you the truth trying to figure out what that code needs to be
>> correct if task != current makes my head hurt.
>
> Hmm...
>
>> I think we need to grab a reference on task_struct, to stop the task
>> from going away, and in addition we need to hold task_lock.  To keep
>> task->mm from changing (see exec_mmap).  But we can't do that and sleep
>> so I think the entire function needs to be rewritten, and the need for
>> task deep in the migrate_pages path needs to be removed as even with the
>> reference count held we can race with someone calling exec.
>
> We dont need the task during migration. We only need the mm. The task
> is safe until rcu_read_unlock therefore maybe the following should fix
> migrate pages:
>
>
> Subject: migration: Do not do rcu_read_unlock until the last time we need the task_struct pointer
>
> Migration functions perform the rcu_read_unlock too early. As a result the
> task pointed to may change. Bugs were introduced when adding security checks
> because rcu_unlock/lock sequences were inserted. Plus the security checks
> and do_move_pages used the task_struct pointer after rcu_unlock.
>
> Fix those issues by removing the unlock/lock sequences and moving the
> rcu_read_unlock after the last use of the task struct pointer.
>
> Signed-off-by: Christoph Lameter<cl@linux.com>
>
>

	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


