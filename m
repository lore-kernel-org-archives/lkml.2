Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab0KWIMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:12:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59322 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab0KWIMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:12:54 -0500
Message-ID: <4CEB77E0.10202@cn.fujitsu.com>
Date: Tue, 23 Nov 2010 16:14:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup: Convert synchronize_rcu to call_rcu in cgroup_attach_task
References: <AANLkTikx6d0_VFtZ4zWQucRCf=vFt7N2M6=0jpnKasEE@mail.gmail.com> <1290398767-15230-1-git-send-email-ccross@android.com>
In-Reply-To: <1290398767-15230-1-git-send-email-ccross@android.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-23 16:13:03,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-23 16:13:07,
	Serialize complete at 2010-11-23 16:13:07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12:06, Colin Cross wrote:
> The synchronize_rcu call in cgroup_attach_task can be very
> expensive.  All fastpath accesses to task->cgroups that expect
> task->cgroups not to change already use task_lock() or
> cgroup_lock() to protect against updates, and, in cgroup.c,
> only the CGROUP_DEBUG files have RCU read-side critical
> sections.
> 
> sched.c uses RCU read-side-critical sections on task->cgroups,
> but only to ensure that a dereference of task->cgroups does
> not become invalid, not that it doesn't change.
> 

Other cgroup subsystems also use rcu_read_lock to access task->cgroups,
for example net_cls cgroup and device cgroup.

I don't think the performance of task attaching is so critically
important that we have to use call_rcu() instead of synchronize_rcu()?

> This patch adds a function put_css_set_rcu, which delays the
> put until after a grace period has elapsed.  This ensures that
> any RCU read-side critical sections that dereferenced
> task->cgroups in sched.c have completed before the css_set is
> deleted.  The synchronize_rcu()/put_css_set() combo in
> cgroup_attach_task() can then be replaced with
> put_css_set_rcu().
> 

> Also converts the CGROUP_DEBUG files that access
> current->cgroups to use task_lock(current) instead of
> rcu_read_lock().
> 

What for? What do we gain from doing this for those debug
interfaces?

> Signed-off-by: Colin Cross <ccross@android.com>
> 
> ---
> 
> This version fixes the problems with the previous patch by
> keeping the use of RCU in cgroup_attach_task, but allowing
> cgroup_attach_task to return immediately by deferring the
> final put_css_reg to an rcu callback.
> 
>  include/linux/cgroup.h |    4 +++
>  kernel/cgroup.c        |   58 ++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 50 insertions(+), 12 deletions(-)
