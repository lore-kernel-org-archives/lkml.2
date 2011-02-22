Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1BVOdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:33:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59648 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1BVOdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=otfcVtt1wOOyzAHg4EMUBwiAm8SFNgtr1n7dw6UgLSfANfEURYbWFcstA8gQk8kIth
         quUf2c4Ghql6D4LXxF7cKudxZLq5lqo5dRCWp+/f+zzzW5Bx64Q9WTlMjwCYaRocesJd
         YeCNVsavxOSOiRMgS3wBW/Qb+dgrjC6e0PB1E=
Date: Tue, 22 Feb 2011 22:32:59 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH V2] sched, autogroup: always show autogroup name in
 sched_debug
Message-ID: <20110222143259.GA1578@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1298185696-4403-1-git-send-email-yong.zhang0@gmail.com>
 <1298185696-4403-6-git-send-email-yong.zhang0@gmail.com>
 <1298207379.7998.11.camel@marge.simson.net>
 <20110220141003.GA6006@zhy>
 <1298222533.7881.15.camel@marge.simson.net>
 <1298306175.24121.14.camel@twins>
 <AANLkTin_aqBTXUyO4H-p1_4i-9FAvxChBi1QpPFXvqD_@mail.gmail.com>
 <1298368566.2217.18.camel@twins>
 <20110222121002.GA2100@zhy>
 <1298383320.8036.5.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1298383320.8036.5.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 03:02:00PM +0100, Mike Galbraith wrote:
> On Tue, 2011-02-22 at 20:10 +0800, Yong Zhang wrote:
> > On Tue, Feb 22, 2011 at 10:56:06AM +0100, Peter Zijlstra wrote:
> > > On Tue, 2011-02-22 at 11:13 +0800, Yong Zhang wrote:
> > > > So show autogroup name always. But for the root group,
> > > > its name will dance between "cfs_rq[cpu]:" and
> > > > "cfs_rq[cpu]:/autogroup-0" according to
> > > > sysctl_sched_autogroup_enabled. 
> > > 
> > > Would it make sense to force the root group to always be a !autogroup?
> > 
> > Hmmm, I think it's ok.
> 
> Yup, it's not an autogroup, so let's stop claiming it.
> 
> sched, autogroup: stop claiming ownership of the root task group.
> 
> Disown it, and only display autogroup association if one exists.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

Ah, I like this one better :)
Actually I misunderstanded what Peter mean.

Reviewed-by: Yong Zhang <yong.zhang0@gmail.com>

Thanks,
Yong
> 
> diff --git a/kernel/sched_autogroup.c b/kernel/sched_autogroup.c
> index 9fb6562..506faa0 100644
> --- a/kernel/sched_autogroup.c
> +++ b/kernel/sched_autogroup.c
> @@ -12,7 +12,6 @@ static atomic_t autogroup_seq_nr;
>  static void __init autogroup_init(struct task_struct *init_task)
>  {
>  	autogroup_default.tg = &root_task_group;
> -	root_task_group.autogroup = &autogroup_default;
>  	kref_init(&autogroup_default.kref);
>  	init_rwsem(&autogroup_default.lock);
>  	init_task->signal->autogroup = &autogroup_default;
> @@ -130,7 +129,7 @@ task_wants_autogroup(struct task_struct *p, struct task_group *tg)
>  
>  static inline bool task_group_is_autogroup(struct task_group *tg)
>  {
> -	return tg != &root_task_group && tg->autogroup;
> +	return !!tg->autogroup;
>  }
>  
>  static inline struct task_group *
> @@ -247,10 +246,14 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
>  {
>  	struct autogroup *ag = autogroup_task_get(p);
>  
> +	if (!task_group_is_autogroup(ag->tg))
> +		goto out;
> +
>  	down_read(&ag->lock);
>  	seq_printf(m, "/autogroup-%ld nice %d\n", ag->id, ag->nice);
>  	up_read(&ag->lock);
>  
> +out:
>  	autogroup_kref_put(ag);
>  }
>  #endif /* CONFIG_PROC_FS */
> @@ -258,9 +261,7 @@ void proc_sched_autogroup_show_task(struct task_struct *p, struct seq_file *m)
>  #ifdef CONFIG_SCHED_DEBUG
>  static inline int autogroup_path(struct task_group *tg, char *buf, int buflen)
>  {
> -	int enabled = ACCESS_ONCE(sysctl_sched_autogroup_enabled);
> -
> -	if (!enabled || !tg->autogroup)
> +	if (!task_group_is_autogroup(tg))
>  		return 0;
>  
>  	return snprintf(buf, buflen, "%s-%ld", "/autogroup", tg->autogroup->id);
> 
