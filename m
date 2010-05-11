Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab0EKVv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:51:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751434Ab0EKVv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:51:27 -0400
Date: Tue, 11 May 2010 14:50:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 2/5] stop_machine: reimplement using cpu_stop
Message-Id: <20100511145059.d846e85c.akpm@linux-foundation.org>
In-Reply-To: <1273164772-19149-3-git-send-email-tj@kernel.org>
References: <1273164772-19149-1-git-send-email-tj@kernel.org>
	<1273164772-19149-3-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 May 2010 18:52:49 +0200
Tejun Heo <tj@kernel.org> wrote:

> Reimplement stop_machine using cpu_stop.  As cpu stoppers are
> guaranteed to be available for all online cpus,
> stop_machine_create/destroy() are no longer necessary and removed.
> 
> With resource management and synchronization handled by cpu_stop, the
> new implementation is much simpler.  Asking the cpu_stop to execute
> the stop_cpu() state machine on all online cpus with cpu hotplug
> disabled is enough.
> 
> stop_machine itself doesn't need to manage any global resources
> anymore, so all per-instance information is rolled into struct
> stop_machine_data and the mutex and all static data variables are
> removed.
> 
> The previous implementation created and destroyed RT workqueues as
> necessary which made stop_machine() calls highly expensive on very
> large machines.  According to Dimitri Sivanich, preventing the dynamic
> creation/destruction makes booting faster more than twice on very
> large machines.  cpu_stop resources are preallocated for all online
> cpus and should have the same effect.
> 
> ...
>
> @@ -361,9 +357,6 @@ int disable_nonboot_cpus(void)
>  {
>  	int cpu, first_cpu, error;
>  
> -	error = stop_machine_create();
> -	if (error)
> -		return error;
>  	cpu_maps_update_begin();
>  	first_cpu = cpumask_first(cpu_online_mask);
>  	/*

kernel/cpu.c: In function 'disable_nonboot_cpus':
kernel/cpu.c:397: warning: 'error' may be used uninitialized in this function

Looks like this is a real bug if the cpumask happens to contain only a
single CPU for some reason.

--- a/kernel/cpu.c~a
+++ a/kernel/cpu.c
@@ -355,7 +355,8 @@ static cpumask_var_t frozen_cpus;
 
 int disable_nonboot_cpus(void)
 {
-	int cpu, first_cpu, error;
+	int cpu, first_cpu;
+	int error = 0;
 
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
_

