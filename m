Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1HNRsN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 13:48:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab1HNRsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 13:48:12 -0400
Date: Sun, 14 Aug 2011 19:45:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: paulmck@linux.vnet.ibm.com, Ben Blum <bblum@andrew.cmu.edu>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Possible race between cgroup_attach_proc and de_thread, and
	questionable code in de_thread.
Message-ID: <20110814174516.GB2381@redhat.com>
References: <20110727171101.5e32d8eb@notabene.brown> <20110727150710.GB5242@unix33.andrew.cmu.edu> <20110727234235.GA2318@linux.vnet.ibm.com> <20110728110813.7ff84b13@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728110813.7ff84b13@notabene.brown>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28, NeilBrown wrote:
>
> +/* Thread group leader can change, so stop loop when we see one
> + * even if it isn't 'g' */
>  #define while_each_thread(g, t) \
> -	while ((t = next_thread(t)) != g)
> +	while ((t = next_thread(t)) != g && !thread_group_leader(t))

This assumes that while_each_thread(g, t) always uses g == group_leader.

> @@ -70,8 +70,13 @@ static void __unhash_process(struct task_struct *p, bool group_dead)
>  		list_del_rcu(&p->tasks);
>  		list_del_init(&p->sibling);
>  		__this_cpu_dec(process_counts);
> -	}
> -	list_del_rcu(&p->thread_group);
> +	} else
> +		/* only remove members from the thread group.
> +		 * The thread group leader must stay so that
> +		 * while_each_thread() uses can see the end of
> +		 * the list and stop.
> +		 */
> +		list_del_rcu(&p->thread_group);

Hmm... this looks obvously wrong. This leaves the dead thread on
the list.

Oleg.

