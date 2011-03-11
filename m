Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1CKCEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:04:47 -0500
Received: from mail-am1.bigfish.com ([213.199.180.138]:52979 "EHLO
	AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754043Ab1CKCEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:04:46 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Mar 2011 21:04:46 EST
X-SpamScore: -12
X-BigFish: VPS-12(zzbb2dK1432N98dN78fbkzz1202hzz8275bhz2fh637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D797F92.6020504@am.sony.com>
Date: Thu, 10 Mar 2011 17:49:06 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Chris Mason <chris.mason@oracle.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 22/22] sched: Remove TASK_WAKING
References: <20110302173831.295031866@chello.nl> <20110302174121.858324339@chello.nl>
In-Reply-To: <20110302174121.858324339@chello.nl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/11 09:38, Peter Zijlstra wrote:
> With the new locking TASK_WAKING has become obsolete, remove it.
> 
> Suggested-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---

< snip >

> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -2175,7 +2175,7 @@ void set_task_cpu(struct task_struct *p,
>  	 * We should never call set_task_cpu() on a blocked task,
>  	 * ttwu() will sort out the placement.
>  	 */
> -	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
> +	WARN_ON_ONCE(p->state != TASK_RUNNING &&
>  			!(task_thread_info(p)->preempt_count & PREEMPT_ACTIVE));
>  
>  #ifdef CONFIG_LOCKDEP
> @@ -2613,7 +2613,7 @@ try_to_wake_up(struct task_struct *p, un
>  	smp_rmb();
>  
>  	p->sched_contributes_to_load = !!task_contributes_to_load(p);
> -	p->state = TASK_WAKING;
> +	p->state = TASK_RUNNING;
>  
>  	if (p->sched_class->task_waking)
>  		p->sched_class->task_waking(p);

No harm if the coded as in the patch, but an alternate suggestion
if you like it:

The only reason left for "p->state = TASK_RUNNING;" here is when
cpu is remote.  If cpu is not remote then p->state will be set by:

   ttwu_queue()
      ttwu_do_activate()
         ttwu_do_wakeup()
            p->state = TASK_RUNNING;

It would be more clear that setting state to TASK_RUNNING is protecting
the process until it has been removed from the wake_list by
sched_ttwu_pending() by setting p->state = TASK_RUNNING in ttwu_queue_remote().

