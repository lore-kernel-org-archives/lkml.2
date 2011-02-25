Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab1BYO5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:57:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab1BYO5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:57:19 -0500
Date: Fri, 25 Feb 2011 09:57:08 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Dominik Klein <dk@in-telegence.net>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225145708.GB2994@redhat.com>
References: <4D650D7E.4050908@in-telegence.net>
 <4D662248.6040405@in-telegence.net>
 <20110224142303.GA18494@redhat.com>
 <20110224143105.GL7840@htj.dyndns.org>
 <4D66720E.70102@in-telegence.net>
 <20110224151701.GQ7840@htj.dyndns.org>
 <4D67591F.10105@in-telegence.net>
 <20110225112936.GH24828@htj.dyndns.org>
 <4D679688.7020503@in-telegence.net>
 <20110225131850.GI24828@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225131850.GI24828@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 02:18:50PM +0100, Tejun Heo wrote:
> Hello,
> 
> On Fri, Feb 25, 2011 at 12:46:16PM +0100, Dominik Klein wrote:
> > With 2.6.37 (also tried .1 and .2) it does not work but end up like I
> > documented. With 2.6.38-rc1, it does work. With deadline scheduler, it
> > also works in 2.6.37.
> 
> Okay, here's the problematic part.
> 
>           <idle>-0     [013]  1640.975562: workqueue_queue_work: work struct=ffff88080f14f270 function=blk_throtl_work workqueue=ffff88102c8fc700 req_cpu=13 cpu=13
>           <idle>-0     [013]  1640.975564: workqueue_activate_work: work struct ffff88080f14f270
>            <...>-477   [013]  1640.975574: workqueue_execute_start: work struct ffff88080f14f270: function blk_throtl_work
> 	  <idle>-0     [013]  1641.087450: workqueue_queue_work: work struct=ffff88080f14f270 function=blk_throtl_work workqueue=ffff88102c8fc700 req_cpu=13 cpu=13
> 		     
> The workqueue is per-cpu, so we only need to follow cpu=13 cases.
> @1640, blk_throtl_work() is queued, activated and starts executing but
> never finishes.  The same work item is never executed more than once
> at the same on the same CPU, so when the next work item is queued, it
> doesn't get activated until the previous execution is complete.
> 
> The next thing to do would be finding out why blk_throtl_work() isn't
> finishing.  sysrq-t or /proc/PID/stack should show us where it's
> stalled.

Hi Tejun,

blk_throtl_work() calls generic_make_request() to dispatch some bios and I
guess blk_throtl_work() has been put to sleep because threre are no request
descriptors available and CFQ is frozen so no requests descriptors get freed
hence blk_throtl_work() never finishes.

Following caught my eye.

     ksoftirqd/0-3     [000]  1640.983585:   8,16   m   N cfq4810 slice
expired t=0
     ksoftirqd/0-3     [000]  1640.983588:   8,16   m   N cfq4810
sl_used=2 disp=6 charge=2 iops=0 sect=2080
     ksoftirqd/0-3     [000]  1640.983589:   8,16   m   N cfq4810
del_from_rr
     ksoftirqd/0-3     [000]  1640.983591:   8,16   m   N cfq schedule
dispatch
            sshd-3125  [004]  1640.983597: workqueue_queue_work: work
struct=ffff88102c3a3110 function=flush_to_ldisc workqueue=ffff88182c834a00
req_cpu=4 cpu=4
            sshd-3125  [004]  1640.983598: workqueue_activate_work: work
struct ffff88102c3a3110

CFQ tries to schedule a work and but there is no associated
"workqueue_queue_work" trace. So it looks like that work never got queued.

CFQ calls following.

cfq_log(cfqd, "schedule dispatch");
kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);

We do see "schedule dispatch" message and kblockd_schedule_work() calls
queue_work(). So what happended here? This is strange. I will put one
more trace after kblockd_schedule_work() to trace that function returned.

Thanks
Vivek
