Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2BXVi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 16:38:56 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58797 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2BXViz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 16:38:55 -0500
Message-ID: <4F480326.8070706@linux.vnet.ibm.com>
Date: Fri, 24 Feb 2012 13:37:42 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home> <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home> <4F47BF56.6010602@linux.vnet.ibm.com> <alpine.DEB.2.00.1202241053220.3726@router.home> <alpine.DEB.2.00.1202241105280.3726@router.home> <4F47C800.4090903@linux.vnet.ibm.com> <alpine.DEB.2.00.1202241131400.3726@router.home>
In-Reply-To: <alpine.DEB.2.00.1202241131400.3726@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022421-3270-0000-0000-0000044C6DF2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2012 09:32 AM, Christoph Lameter wrote:
> @@ -1318,10 +1318,10 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
>  	rcu_read_lock();
>  	task = pid ? find_task_by_vpid(pid) : current;
>  	if (!task) {
> -		rcu_read_unlock();
>  		err = -ESRCH;
>  		goto out;
>  	}
...
> +	put_task_struct(task);
> +	task = NULL;
>  	err = do_migrate_pages(mm, old, new,
>  		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
>  out:
> +	if (task)
> +		put_task_struct(task);
> +
>  	if (mm)
>  		mmput(mm);
>  	NODEMASK_SCRATCH_FREE(scratch);

Man, patch did not like this for some reason.  I kept throwing most of
the mempolicy.c hunks away.  I've never seen anything like it.

Anyway...  This looks fine except I think that rcu_read_unlock() need to
stay.  There's currently no release of it after out:.

