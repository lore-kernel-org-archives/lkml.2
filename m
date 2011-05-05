Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab1EEJbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 05:31:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52934 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab1EEJbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 05:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qm+fa4YxIYhnwKMIZZXwyJCrZ+ri/2AhaRruSkRLOtZ3a6yPnbHtGWCf6r+zVaICf1
         a0zmUS6l6Mqf2iQDRxUSN70X7EfFcDTIDsRQ2cKxauKZYKE/iMIQeAKumWEHyiSzo35J
         QP1sNnWByN2aoPRRXANxT61YzvzYNdXPrJsNs=
MIME-Version: 1.0
In-Reply-To: <1304256126-26015-5-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
	<1304256126-26015-5-git-send-email-paulmck@linux.vnet.ibm.com>
Date: Thu, 5 May 2011 17:31:35 +0800
Message-ID: <BANLkTindSvefZFoM6uPx+UyHOsFSmYnfhQ@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 05/86] rcu: move TREE_RCU from softirq to kthread
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 1, 2011 at 9:20 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
>
> If RCU priority boosting is to be meaningful, callback invocation must
> be boosted in addition to preempted RCU readers.  Otherwise, in presence
> of CPU real-time threads, the grace period ends, but the callbacks don't
> get invoked.  If the callbacks don't get invoked, the associated memory
> doesn't get freed, so the system is still subject to OOM.
>
> But it is not reasonable to priority-boost RCU_SOFTIRQ, so this commit
> moves the callback invocations to a kthread, which can be boosted easily.
>
> Also add comments and properly synchronized all accesses to
> rcu_cpu_kthread_task, as suggested by Lai Jiangshan.
>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
[snip]
> + * Drop to non-real-time priority and yield, but only after posting a
> + * timer that will cause us to regain our real-time priority if we
> + * remain preempted.  Either way, we restore our real-time priority
> + * before returning.
> + */
> +static void rcu_yield(int cpu)
> +{
> +       struct rcu_data *rdp = per_cpu_ptr(rcu_sched_state.rda, cpu);
> +       struct sched_param sp;
> +       struct timer_list yield_timer;
> +
> +       setup_timer(&yield_timer, rcu_cpu_kthread_timer, (unsigned long)rdp);

setup_timer_on_stack() should be used here :)

Thanks,
Yong


-- 
Only stand for myself
