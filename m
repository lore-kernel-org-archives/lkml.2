Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab2APNeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 08:34:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55169 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab2APNeG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 08:34:06 -0500
Message-ID: <1326720836.2442.231.camel@twins>
Subject: Re: [PATCH v2] kvm: remove dependence on delay-accounting
From: Peter Zijlstra <peterz@infradead.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Mon, 16 Jan 2012 14:33:56 +0100
In-Reply-To: <20120114163051.23946.25895.stgit@zurg>
References: <20120114162413.15761.7341.stgit@zurg>
	 <20120114163051.23946.25895.stgit@zurg>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-14 at 20:30 +0400, Konstantin Khlebnikov wrote:
> KVM selects delay-accounting only to get sched-info for steal-time accounting.
> Meanwhile delay-accounting can be disabled by boot option. This is ridiculous.
> 
> This patch adds internal boolean option CONFIG_TASK_SCHED_INFO to enable only
> task->sched_info and its collecting inside scheduler.

Urgh, more stupid config knobs, we should be removing them, not adding
moar.

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 868cb83..dd5bf78 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -734,7 +734,6 @@ extern struct user_struct root_user;
>  
>  struct backing_dev_info;
>  
> -#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>  struct sched_info {
>  	/* cumulative counters */
>  	unsigned long pcount;	      /* # of times run on this cpu */
> @@ -744,7 +743,6 @@ struct sched_info {
>  	unsigned long long last_arrival,/* when we last ran on a cpu */
>  			   last_queued;	/* when we were last queued to run */
>  };
> -#endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */

Not having that structure helps with compile errors.

>  #ifdef CONFIG_TASK_DELAY_ACCT
>  struct task_delay_info {
> @@ -782,7 +780,7 @@ struct task_delay_info {
>  
>  static inline int sched_info_on(void)
>  {
> -#ifdef CONFIG_SCHEDSTATS
> +#if IS_ENABLED(CONFIG_SCHEDSTATS) || IS_ENABLED(CONFIG_KVM)

WTF is IS_ENABLED and why do you use it?


Not much like this stuff.
