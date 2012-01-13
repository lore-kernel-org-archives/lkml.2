Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab2AMXam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:30:42 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:44076 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2AMXak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:30:40 -0500
Date: Sat, 14 Jan 2012 10:00:09 +1030
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Fix race in process_vm_rw_core
Message-ID: <20120114100009.4dd8588b@Gantu.yeoh.info>
In-Reply-To: <20120113143050.df23a02c.akpm@linux-foundation.org>
References: <20120113220028.4ba7cead@Gantu.yeoh.info>
	<20120113143050.df23a02c.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12011313-1618-0000-0000-000000894F59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012 14:30:50 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:
> > +struct mm_struct *get_check_task_mm(struct task_struct *task,
> > unsigned int mode) +{
> > +	struct mm_struct *mm;
> > +	int err;
> > +
> > +	err =
> > mutex_lock_killable(&task->signal->cred_guard_mutex);
> > +	if (err)
> > +		return ERR_PTR(err);
> > +
> > +	task_lock(task);
> > +	if (__ptrace_may_access(task, mode)) {
> > +		mm = ERR_PTR(-EACCES);
> > +		goto out;
> > +	}
> > +
> > +	mm = task->mm;
> > +	if (mm) {
> > +		if (task->flags & PF_KTHREAD)
> > +			mm = NULL;
> > +		else
> > +			atomic_inc(&mm->mm_users);
> > +	}
> > +
> > +out:
> > +	task_unlock(task);
> > +	mutex_unlock(&task->signal->cred_guard_mutex);
> > +
> > +	return mm;
> > +}
> > +EXPORT_SYMBOL_GPL(get_check_task_mm);
> 
> I don't think the export is needed - CONFIG_PROC_FS=m isn't supported.

ok.

> btw, I'm trying to work out why we didn't make the whole
> process_vm_access.o feature Kconfigurable, so people who don't want
> it do not get burdened with it?

I don't know. I'll make this change if you'd like but I won't have time
to do it before leaving for LCA tomorrow. Have a toddler about to arrive
at my house.

Chris
-- 
cyeoh@au.ibm.com

