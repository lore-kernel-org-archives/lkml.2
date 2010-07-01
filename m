Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab0GABJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 21:09:14 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:39864 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab0GABJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 21:09:12 -0400
X-AuditID: b753bd60-a9e06ba000007d15-e0-4c2beab5e948
Message-ID: <4C2BEAAF.8050103@hitachi.com>
Date: Thu, 01 Jul 2010 10:09:03 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bugfix] unregister_trace_probe needs to be called under mutex
References: <20100630084548.GA10325@linux.vnet.ibm.com>
In-Reply-To: <20100630084548.GA10325@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju wrote:
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

Ah, right! That's definately needed.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!


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
>  

