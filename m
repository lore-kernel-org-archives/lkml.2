Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab1BYPDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 10:03:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56598 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287Ab1BYPDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 10:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=okQIQyK70GNJ/XDQFSMzIO5p9MtMzg3O4rKd5zZTXhDabMxYWbG/sJswOC0XNUbqKm
         M24mmEGxz+7apO87iBoGHcyY+AdnBT1xQ9K19ZJr9kz4ljOvY2xSC1rCdKubzqF8tXeT
         /8Pb/IcWVRpGTaxiSI65iZt55pYP2fVzisSd4=
Date: Fri, 25 Feb 2011 16:03:29 +0100
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dominik Klein <dk@in-telegence.net>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225150329.GM24828@htj.dyndns.org>
References: <4D662248.6040405@in-telegence.net>
 <20110224142303.GA18494@redhat.com>
 <20110224143105.GL7840@htj.dyndns.org>
 <4D66720E.70102@in-telegence.net>
 <20110224151701.GQ7840@htj.dyndns.org>
 <4D67591F.10105@in-telegence.net>
 <20110225112936.GH24828@htj.dyndns.org>
 <4D679688.7020503@in-telegence.net>
 <20110225131850.GI24828@htj.dyndns.org>
 <20110225145708.GB2994@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225145708.GB2994@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 25, 2011 at 09:57:08AM -0500, Vivek Goyal wrote:
> blk_throtl_work() calls generic_make_request() to dispatch some bios and I
> guess blk_throtl_work() has been put to sleep because threre are no request
> descriptors available and CFQ is frozen so no requests descriptors get freed
> hence blk_throtl_work() never finishes.
> 
> Following caught my eye.
> 
>      ksoftirqd/0-3     [000]  1640.983585:   8,16   m   N cfq4810 slice
> expired t=0
>      ksoftirqd/0-3     [000]  1640.983588:   8,16   m   N cfq4810
> sl_used=2 disp=6 charge=2 iops=0 sect=2080
>      ksoftirqd/0-3     [000]  1640.983589:   8,16   m   N cfq4810
> del_from_rr
>      ksoftirqd/0-3     [000]  1640.983591:   8,16   m   N cfq schedule
> dispatch
>             sshd-3125  [004]  1640.983597: workqueue_queue_work: work
> struct=ffff88102c3a3110 function=flush_to_ldisc workqueue=ffff88182c834a00
> req_cpu=4 cpu=4
>             sshd-3125  [004]  1640.983598: workqueue_activate_work: work
> struct ffff88102c3a3110
> 
> CFQ tries to schedule a work and but there is no associated
> "workqueue_queue_work" trace. So it looks like that work never got queued.
> 
> CFQ calls following.
> 
> cfq_log(cfqd, "schedule dispatch");
> kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);
> 
> We do see "schedule dispatch" message and kblockd_schedule_work() calls
> queue_work(). So what happended here? This is strange. I will put one
> more trace after kblockd_schedule_work() to trace that function returned.

It could be that the unplug work was already queued and in pending
state.  The second queueing request will be ignored then.  So, I think
the problem is that blk_throtl_work() occupies kblockd but requires
another work item (unplug_work) to make forward progress.  In such
cases, forward progress cannot be guaranteed.  Either
blk_throtl_work() or cfq unplug work should use a separate workqueue.

Thanks.

-- 
tejun
