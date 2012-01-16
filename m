Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2APMko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 07:40:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab2APMkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 07:40:43 -0500
Date: Mon, 16 Jan 2012 09:14:46 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2] kvm: remove dependence on delay-accounting
Message-ID: <20120116111446.GF7937@amt.cnet>
References: <20120114162413.15761.7341.stgit@zurg>
 <20120114163051.23946.25895.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120114163051.23946.25895.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 08:30:51PM +0400, Konstantin Khlebnikov wrote:
> KVM selects delay-accounting only to get sched-info for steal-time accounting.
> Meanwhile delay-accounting can be disabled by boot option. This is ridiculous.
> 
> This patch adds internal boolean option CONFIG_TASK_SCHED_INFO to enable only
> task->sched_info and its collecting inside scheduler.
> 
> v2:
> * stupid misprint fixed
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> ---
>  arch/x86/kvm/Kconfig  |    5 +----
>  include/linux/sched.h |    6 ++----
>  init/Kconfig          |    7 +++++++
>  kernel/sched/core.c   |    2 +-
>  kernel/sched/stats.h  |    4 ++--
>  lib/Kconfig.debug     |    1 +
>  6 files changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 1a7fe86..e3952e8 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -22,8 +22,6 @@ config KVM
>  	depends on HAVE_KVM
>  	# for device assignment:
>  	depends on PCI
> -	# for TASKSTATS/TASK_DELAY_ACCT:
> -	depends on NET
>  	select PREEMPT_NOTIFIERS
>  	select MMU_NOTIFIER
>  	select ANON_INODES
> @@ -33,8 +31,7 @@ config KVM
>  	select KVM_ASYNC_PF
>  	select USER_RETURN_NOTIFIER
>  	select KVM_MMIO
> -	select TASKSTATS
> -	select TASK_DELAY_ACCT
> +	select TASK_SCHED_INFO
>  	select PERF_EVENTS
>  	---help---
>  	  Support hosting fully virtualized guest machines using hardware
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
>  
>  #ifdef CONFIG_TASK_DELAY_ACCT
>  struct task_delay_info {
> @@ -782,7 +780,7 @@ struct task_delay_info {
>  
>  static inline int sched_info_on(void)
>  {
> -#ifdef CONFIG_SCHEDSTATS
> +#if IS_ENABLED(CONFIG_SCHEDSTATS) || IS_ENABLED(CONFIG_KVM)
>  	return 1;

CONFIG_TASK_SCHED_INFO?

