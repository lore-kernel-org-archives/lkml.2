Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab2BWTLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:11:15 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:46990 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab2BWTLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:11:14 -0500
Message-ID: <4F468F09.5050200@linux.vnet.ibm.com>
Date: Thu, 23 Feb 2012 11:10:01 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home>
In-Reply-To: <alpine.DEB.2.00.1202231240590.9878@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022319-7282-0000-0000-000006C7C8A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 10:45 AM, Christoph Lameter wrote:
> On Thu, 23 Feb 2012, Dave Hansen wrote:
>> This patch takes the pid-to-task code along with the credential
>> and security checks in sys_move_pages() and sys_migrate_pages()
>> and consolidates them.  It now takes a task reference in
>> the new function and requires the caller to drop it.  I
>> believe this resolves the race.
> 
> And this way its safer?

I think so... I'll talk about it below.

>> diff -puN include/linux/migrate.h~movememory-helper include/linux/migrate.h
>> --- linux-2.6.git/include/linux/migrate.h~movememory-helper	2012-02-16 09:59:17.270207242 -0800
>> +++ linux-2.6.git-dave/include/linux/migrate.h	2012-02-16 09:59:17.286207438 -0800
>> @@ -31,6 +31,7 @@ extern int migrate_vmas(struct mm_struct
>>  extern void migrate_page_copy(struct page *newpage, struct page *page);
>>  extern int migrate_huge_page_move_mapping(struct address_space *mapping,
>>  				  struct page *newpage, struct page *page);
>> +struct task_struct *can_migrate_get_task(pid_t pid);
> 
> Could we use something easier to understand? try_get_task()?

It's hard to see in the patch context, but can_migrate_get_task() does
two migration-specific operations:

>         tcred = __task_cred(task);
>         if (cred->euid != tcred->suid && cred->euid != tcred->uid &&
>             cred->uid  != tcred->suid && cred->uid  != tcred->uid &&
>             !capable(CAP_SYS_NICE)) {
>                 err = -EPERM;
>                 goto out;
>         }
> 
>         err = security_task_movememory(task);

So, I was trying to relate that it's checking the current's permissions
to _do_ migration on task.  try_get_task() wouldn't really say much
about that part of its job.


>> +struct task_struct *can_migrate_get_task(pid_t pid)
>>  {
>> -	const struct cred *cred = current_cred(), *tcred;
>>  	struct task_struct *task;
>> -	struct mm_struct *mm;
>> -	int err;
>> -
>> -	/* Check flags */
>> -	if (flags & ~(MPOL_MF_MOVE|MPOL_MF_MOVE_ALL))
>> -		return -EINVAL;
>> -
>> -	if ((flags & MPOL_MF_MOVE_ALL) && !capable(CAP_SYS_NICE))
>> -		return -EPERM;
>> +	const struct cred *cred = current_cred(), *tcred;
>> +	int err = 0;
>>
>> -	/* Find the mm_struct */
>>  	rcu_read_lock();
>>  	task = pid ? find_task_by_vpid(pid) : current;
>>  	if (!task) {
>>  		rcu_read_unlock();
>> -		return -ESRCH;
>> +		return ERR_PTR(-ESRCH);
>>  	}
>> -	mm = get_task_mm(task);
>> -	rcu_read_unlock();
>> -
>> -	if (!mm)
>> -		return -EINVAL;
>> +	get_task_struct(task);
> 
> Hmmm isnt the race still there between the determination of the task and
> the get_task_struct()? You would have to verify after the get_task_struct
> that this is really the task we wanted to avoid the race.

It's true that selecting a task by pid is inherently racy.  What that
code does is ensure that the task you've got current has 'pid', but not
ensure that 'pid' has never represented another task.  But, that's what
we do everywhere else in the kernel; there's not much better that we can do.

Maybe "race" is the wrong word for what we've got here.  It's a lack of
a refcount being taken.

