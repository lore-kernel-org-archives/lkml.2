Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0F3Jo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:44:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:32933 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab0F3Jo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:44:56 -0400
Subject: Re: [Bugfix] unregister_trace_probe needs to be called under mutex
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20100630084548.GA10325@linux.vnet.ibm.com>
References: <20100630084548.GA10325@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Jun 2010 11:44:26 +0200
Message-ID: <1277891066.1868.107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-30 at 14:15 +0530, Srikar Dronamraju wrote:
> Comment in unregister_trace_probe() says probe_lock will be held
> when it gets called. However there is a case where it might called
> without the probe_lock being held. Also since we are traversing the
> probe_list and deleting an element from the probe_list, probe_lock
> should be held.
> 
> This was first pointed in uprobes traceevent review by Frederic
> Weisbecker here.  (http://lkml.org/lkml/2010/5/12/106)
> 
> This patch is needed for both 2.6.35-rc3 and 2.6.35-rc3-tip
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
> 
> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> index 4f11a56..67670cd 100644
> --- a/kernel/trace/trace_kprobe.c
> +++ b/kernel/trace/trace_kprobe.c
> @@ -269,14 +269,17 @@ static int create_trace_probe(int argc, char **argv)
>  			pr_info("Delete command needs an event name.\n");
>  			return -EINVAL;
>  		}
> +		mutex_lock(&probe_lock);
>  		tp = find_probe_event(event, group);
>  		if (!tp) {
> +			mutex_unlock(&probe_lock);
>  			pr_info("Event %s/%s doesn't exist.\n", group, event);
>  			return -ENOENT;
>  		}
>  		/* delete an event */
>  		unregister_trace_probe(tp);
>  		free_trace_probe(tp);
> +		mutex_unlock(&probe_lock);
>  		return 0;
>  	}

Shouldn't all that go through steven's ->reg() interface?
