Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab1F2UR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 16:17:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49991 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1F2URY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 16:17:24 -0400
Date: Thu, 30 Jun 2011 00:17:18 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Balbir Singh <bsingharora@gmail.com>
Cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org,
        Eric Paris <eparis@redhat.com>, Solar Designer <solar@openwall.com>
Subject: Re: [PATCH 2/2] taskstats: restrict access to user
Message-ID: <20110629201718.GA11071@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 06:57 +0530, Balbir Singh wrote:
> On Fri, Jun 24, 2011 at 5:39 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > +               task = find_task_by_vpid(s->pid);
> > +               if (!task || __task_cred(task)->euid != cred->euid) {

If consider this patch for inclusion, it also needs some check for
the listener root ability.  __task_cred(task)->euid == 0 or smth like
that.  But ptrace_task_may_access_current() is better.

> > +                       rcu_read_unlock();
> > +                       continue;
> > +               }
> > +               rcu_read_unlock();
> > +
> 
> Release the lock prior to up_read()
> 
> >                skb_next = NULL;
> >                if (!list_is_last(&s->list, &listeners->list)) {
> >                        skb_next = skb_clone(skb_cur, GFP_KERNEL);
> > @@ -199,14 +211,19 @@ static void fill_stats(struct task_struct *tsk, struct taskstats *stats)
> >  static int fill_stats_for_pid(pid_t pid, struct taskstats *stats)
> >  {
> >        struct task_struct *tsk;
> > +       int rc = -ESRCH;
> >
> >        rcu_read_lock();
> >        tsk = find_task_by_vpid(pid);
> > +       if (tsk && !ptrace_may_access(tsk, PTRACE_MODE_READ)) {
> > +               tsk = NULL;
> > +               rc = -EACCES;
> > +       }
> >        if (tsk)
> >                get_task_struct(tsk);
> >        rcu_read_unlock();
> >        if (!tsk)
> > -               return -ESRCH;
> > +               return rc;
> >        fill_stats(tsk, stats);
> >        put_task_struct(tsk);
> >        return 0;
> > @@ -224,6 +241,10 @@ static int fill_stats_for_tgid(pid_t tgid, struct taskstats *stats)
> >         */
> >        rcu_read_lock();
> >        first = find_task_by_vpid(tgid);
> > +       if (first && !ptrace_may_access(first, PTRACE_MODE_READ)) {
> > +               rc = -EACCES;
> > +               goto out;
> > +       }
> >
> >        if (!first || !lock_task_sighand(first, &flags))
> >                goto out;
> 
> Balbir Singh

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
