Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2HOPPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:15:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:39147 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab2HOPPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:15:04 -0400
Message-ID: <1345043679.31459.109.camel@twins>
Subject: Re: [PATCH] sched: Support compiling out real-time scheduling with
 REALTIME_SCHED.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Trevor Brandt <tjbrandt@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>, Eric Paris <eparis@redhat.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Glauber Costa <glommer@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        team-fjord@googlegroups.com
Date: Wed, 15 Aug 2012 17:14:39 +0200
In-Reply-To: <1344977423-28900-1-git-send-email-tjbrandt@gmail.com>
References: <y> <1344977423-28900-1-git-send-email-tjbrandt@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 13:50 -0700, Trevor Brandt wrote:
> Adds support for compiling out the real-time scheduler (SCHED_FIFO
> and SCHED_RR) to save space. Changes sched_set_stop_task to use
> SCHED_NORMAL rather than SCHED_FIFO, since the kernel only uses this
> function as a fake scheduling priority for userspace to read to avoid
> exposing the stop class to userspace. Bloat-o-meter gives a space
> savings of 1877 bytes with REALTIME_SCHED turned off.
> 
> Userspace works fine with REALTIME_SCHED turned off. Processes
> attempting to set a real-time scheduling policy get EINVAL, exactly
> the response that the sched_setscheduler manpage documents you will
> get if the "scheduling policy is not one of the recognized policies."

Are you in the same group that wanted to make SCHED_FAIR optional as
well?

> Signed-off-by: Trevor Brandt <tjbrandt@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
> index 9a7dd35..a9bee25 100644
> --- a/kernel/sched/Makefile
> +++ b/kernel/sched/Makefile
> @@ -11,7 +11,8 @@ ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
>  CFLAGS_core.o := $(PROFILING) -fno-omit-frame-pointer
>  endif
>  
> -obj-y += core.o clock.o idle_task.o fair.o rt.o stop_task.o
> +obj-y += core.o clock.o idle_task.o fair.o stop_task.o
> +obj-$(CONFIG_REALTIME_SCHED) += rt.o
>  obj-$(CONFIG_SMP) += cpupri.o

This wants extra magic, cpupri is only used for rt, cutting that will of
course increase your savings.

>  obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
>  obj-$(CONFIG_SCHEDSTATS) += stats.o

Other than that I'm not entirely happy with the growing #ifdef maze.
Granted this new one isn't nearly as bad as some of the existing ones,
but I do wish someone would clean up some of that.
