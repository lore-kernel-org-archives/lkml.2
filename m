Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329Ab1AEBcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 20:32:12 -0500
Received: from smtp-out.google.com ([74.125.121.67]:13844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1AEBcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 20:32:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Lz4TPBHPKP4qSpL6mVkDgrt6ASS7KVqD0dbyVpl9g+GzLAjcebFJxuEE3irkihRJFw
         EEw1Jf/Pyc1Y0PMNHPqw==
MIME-Version: 1.0
In-Reply-To: <4D22D7BE.4070702@cn.fujitsu.com>
References: <4D22D7BE.4070702@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Tue, 4 Jan 2011 17:31:47 -0800
Message-ID: <AANLkTinG2UkH4nsPiM6=jhLFBujonK9e0yf5CijhuaZ_@mail.gmail.com>
Subject: Re: [PATCH RESEND] cgroups: fix incorrect using rcu_dereference() in cgroup_subsys_state()
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 12:18 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Mon, 25 Aug 2008 11:05:28 +0800
> (Original) Subject: [PATCH] cgroup: fix wrong rcu_dereference()
>
> It is tsk->cgroups which is protected by RCU, not ->subsys[subsys_id].
>
> laijs: updated it(the surrounding code have been changed since these two years).
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index ed4ba11..a798814 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -535,10 +535,11 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
>  * cgroup_subsys::attach() methods.
>  */
>  #define task_subsys_state_check(task, subsys_id, __c)                  \
> -       rcu_dereference_check(task->cgroups->subsys[subsys_id],         \
> +       rcu_dereference_check(task->cgroups,                            \
>                              rcu_read_lock_held() ||                   \
>                              lockdep_is_held(&task->alloc_lock) ||     \
> -                             cgroup_lock_is_held() || (__c))
> +                             cgroup_lock_is_held() ||                  \
> +                             (__c))->subsys[subsys_id]

Can you reformat this a bit? It took a fair bit of staring to realize
that (__c))->subsys[subsys_id] wasn't trying to dereference __c.

Maybe make it:

#define task_subsys_state_check(task, subsys_id, __c) ({ \
  struct css_set *_css = rcu_dereference_check(...); \
  _css->subsys[subsys_id]; \
})

Paul
