Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab0LTNIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:08:22 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:37349 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab0LTNIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w1OAW6YTGz8UGVWodjjPKb5kYmtrtZVLupJFeJ7nJhn9m16N2kBNHdALhZrl2VxjF2
         dRwTDeaUKveXa8qJRWkDi/pOaANeNicZDCz6v6ux8EUZL24QqHaArRUUHqerMBMMvKtB
         u3+UAPyGwakWyKkREZtMsSPCT8VimPnSJ0qFI=
MIME-Version: 1.0
In-Reply-To: <tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
References: <1290281700.28711.9.camel@maggy.simson.net>
	<tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
Date: Mon, 20 Dec 2010 18:38:18 +0530
Message-ID: <AANLkTimRfVFmuMJzuirgsc37=RhC6zKX0C0YXhXO44O9@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
 automated per session task groups
From: Bharata B Rao <bharata.rao@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, pjt@google.com,
        markus@trippelsdorf.de, tglx@linutronix.de, oleg@redhat.com,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 9:09 PM, tip-bot for Mike Galbraith
<efault@gmx.de> wrote:
> Commit-ID:  5091faa449ee0b7d73bc296a93bca9540fc51d0a
> Gitweb:     http://git.kernel.org/tip/5091faa449ee0b7d73bc296a93bca9540fc51d0a
> Author:     Mike Galbraith <efault@gmx.de>
> AuthorDate: Tue, 30 Nov 2010 14:18:03 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 30 Nov 2010 16:03:35 +0100
>
> sched: Add 'autogroup' scheduling feature: automated per session task groups
>
> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
> index e95b774..1dfae3d 100644
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -54,8 +54,7 @@ static unsigned long nsec_low(unsigned long long nsec)
>  #define SPLIT_NS(x) nsec_high(x), nsec_low(x)
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -static void print_cfs_group_stats(struct seq_file *m, int cpu,
> -               struct task_group *tg)
> +static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group *tg)
>  {
>        struct sched_entity *se = tg->se[cpu];
>        if (!se)
> @@ -110,16 +109,6 @@ print_task(struct seq_file *m, struct rq *rq, struct task_struct *p)
>                0LL, 0LL, 0LL, 0L, 0LL, 0L, 0LL, 0L);
>  #endif
>
> -#ifdef CONFIG_CGROUP_SCHED
> -       {
> -               char path[64];
> -
> -               rcu_read_lock();
> -               cgroup_path(task_group(p)->css.cgroup, path, sizeof(path));
> -               rcu_read_unlock();
> -               SEQ_printf(m, " %s", path);
> -       }
> -#endif
>        SEQ_printf(m, "\n");
>  }
>
> @@ -147,19 +136,6 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
>        read_unlock_irqrestore(&tasklist_lock, flags);
>  }
>
> -#if defined(CONFIG_CGROUP_SCHED) && \
> -       (defined(CONFIG_FAIR_GROUP_SCHED) || defined(CONFIG_RT_GROUP_SCHED))
> -static void task_group_path(struct task_group *tg, char *buf, int buflen)
> -{
> -       /* may be NULL if the underlying cgroup isn't fully-created yet */
> -       if (!tg->css.cgroup) {
> -               buf[0] = '\0';
> -               return;
> -       }
> -       cgroup_path(tg->css.cgroup, buf, buflen);
> -}
> -#endif
> -
>  void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>  {
>        s64 MIN_vruntime = -1, min_vruntime, max_vruntime = -1,
> @@ -168,16 +144,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>        struct sched_entity *last;
>        unsigned long flags;
>
> -#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
> -       char path[128];
> -       struct task_group *tg = cfs_rq->tg;
> -
> -       task_group_path(tg, path, sizeof(path));
> -
> -       SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
> -#else
>        SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
> -#endif
>        SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
>                        SPLIT_NS(cfs_rq->exec_clock));
>
> @@ -215,7 +182,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>        SEQ_printf(m, "  .%-30s: %ld\n", "load_contrib",
>                        cfs_rq->load_contribution);
>        SEQ_printf(m, "  .%-30s: %d\n", "load_tg",
> -                       atomic_read(&tg->load_weight));
> +                       atomic_read(&cfs_rq->tg->load_weight));
>  #endif
>
>        print_cfs_group_stats(m, cpu, cfs_rq->tg);
> @@ -224,17 +191,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>
>  void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
>  {
> -#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_RT_GROUP_SCHED)
> -       char path[128];
> -       struct task_group *tg = rt_rq->tg;
> -
> -       task_group_path(tg, path, sizeof(path));
> -
> -       SEQ_printf(m, "\nrt_rq[%d]:%s\n", cpu, path);
> -#else
>        SEQ_printf(m, "\nrt_rq[%d]:\n", cpu);
> -#endif
> -

The above change as well as the recent changes due to tg_shares_up
improvements have two (undesirable ?) side effects on
/proc/sched_debug output.

The autogroup patchset removes the display of cgroup name from
sched_debug output.

On a 16 CPU system, with 2 groups having one task each and one task in
root group, the difference in o/p appears like this:

$ grep while1 sched_debug-2.6.37-rc5
R         while1  2208     13610.855787      1960   120
13610.855787     19272.857661         0.000000 /2
R         while1  2207     20255.605110      3160   120
20255.605110     31572.634065         0.000000 /1
R         while1  2209     63913.721827      1273   120
63913.721827     12604.411880         0.000000 /

$ grep while1 sched_debug-2.6.37-rc5-tip
R         while1  2173     17603.479529      2754   120
17603.479529     25818.279858         4.560010
R         while1  2174     11435.667691      1669   120
11435.667691     16456.476663         0.000000
R         while1  2175     10074.709060      1019   120
10074.709060     10075.915495         0.000000

So you can see in the latter case, it becomes difficult to see which
task belongs to which group.

The group names are also missing from per-CPU rq information. Hence in
the above example of 2 groups, I see 2 blocks of data for 2 cfs_rqs,
but it is not possible to know which group they represent.

Also, with tg_shares_up improvements, the leaf cfs_rqs are maintained
on rq->leaf_cfs_rq_list only if they carry any load. But the code to
display cfs_rq information for sched_debug isn't updated and hence
information from a few cfs_rqs are missing from sched_debug.

$ grep cfs_rq sched_debug-2.6.37-rc5
cfs_rq[0]:/2
cfs_rq[0]:/1
cfs_rq[0]:/
cfs_rq[1]:/2
cfs_rq[1]:/1
cfs_rq[1]:/
cfs_rq[2]:/2
cfs_rq[2]:/1
cfs_rq[2]:/
cfs_rq[3]:/2
cfs_rq[3]:/1
cfs_rq[3]:/
cfs_rq[4]:/2
cfs_rq[4]:/1
cfs_rq[4]:/
cfs_rq[5]:/2
cfs_rq[5]:/1
cfs_rq[5]:/
cfs_rq[6]:/2
cfs_rq[6]:/1
cfs_rq[6]:/
cfs_rq[7]:/2
cfs_rq[7]:/1
cfs_rq[7]:/
cfs_rq[8]:/2
cfs_rq[8]:/1
cfs_rq[8]:/
cfs_rq[9]:/2
cfs_rq[9]:/1
cfs_rq[9]:/
cfs_rq[10]:/2
cfs_rq[10]:/1
cfs_rq[10]:/
cfs_rq[11]:/2
cfs_rq[11]:/1
cfs_rq[11]:/
cfs_rq[12]:/2
cfs_rq[12]:/1
cfs_rq[12]:/
cfs_rq[13]:/2
cfs_rq[13]:/1
cfs_rq[13]:/
cfs_rq[14]:/2
cfs_rq[14]:/1
cfs_rq[14]:/
cfs_rq[15]:/2
cfs_rq[15]:/1
cfs_rq[15]:/

$ grep cfs_rq sched_debug-2.6.37-rc5-tip
cfs_rq[0]:
cfs_rq[0]:
cfs_rq[1]:
cfs_rq[2]:
cfs_rq[3]:
cfs_rq[4]:
cfs_rq[4]:
cfs_rq[5]:
cfs_rq[5]:
cfs_rq[6]:
cfs_rq[7]:
cfs_rq[8]:
cfs_rq[9]:
cfs_rq[10]:
cfs_rq[11]:
cfs_rq[11]:
cfs_rq[12]:
cfs_rq[12]:
cfs_rq[13]:
cfs_rq[13]:
cfs_rq[14]:
cfs_rq[14]:
cfs_rq[15]:
cfs_rq[15]:

Regards,
Bharata.
