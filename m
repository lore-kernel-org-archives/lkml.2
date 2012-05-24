Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2EXJN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 05:13:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40181 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2EXJNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 05:13:55 -0400
Subject: Re: [PATCH v5 4/5] cpusets: Update tasks' cpus_allowed mask upon
 updates to root cpuset
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        rientjes@google.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
In-Reply-To: <20120517170055.3011.18690.stgit@srivatsabhat.in.ibm.com>
References: <20120517165839.3011.98723.stgit@srivatsabhat.in.ibm.com>
	 <20120517170055.3011.18690.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 11:13:47 +0200
Message-ID: <1337850827.9783.77.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-17 at 22:33 +0530, Srivatsa S. Bhat wrote:
> +               /*
> +                * Restore only the top_cpuset because it has to track
> +                * cpu_active_mask always.
> +                * (We don't need to do anything if we come here during resume
> +                * from suspend, since top_cpuset.cpus_allowed will already be
> +                * equal to cpu_active_mask.)
> +                */
> +               if (root == &top_cpuset && !cpumask_equal(root->cpus_allowed,
> +                                                         cpu_active_mask)) {
> +                       mutex_lock(&callback_mutex);
> +                       cpumask_copy(root->cpus_allowed, cpu_active_mask);
> +                       mutex_unlock(&callback_mutex);
> +                       update_tasks_cpumask(root, NULL);
> +               } 

This looks absolutely broken.

Suppose I set an explicit cpu affinity mask on my task, which per not
using cpusets is in the root group.

If I then do a hotplug cycle, I'll find my affinity mask is lost.



