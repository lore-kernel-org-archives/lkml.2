Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1AQO0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:26:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab1AQO03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:26:29 -0500
Date: Mon, 17 Jan 2011 09:26:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 1/2]block cfq:  make queue preempt work for queues from
 different workload
Message-ID: <20110117142623.GC5624@redhat.com>
References: <1294735916.1949.637.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294735916.1949.637.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 04:51:56PM +0800, Shaohua Li wrote:
> I got this:
>              fio-874   [007]  2157.724514:   8,32   m   N cfq874 preempt
>              fio-874   [007]  2157.724519:   8,32   m   N cfq830 slice expired t=1
>              fio-874   [007]  2157.724520:   8,32   m   N cfq830 sl_used=1 disp=0 charge=1 iops=0 sect=0
>              fio-874   [007]  2157.724521:   8,32   m   N cfq830 set_active wl_prio:0 wl_type:0
>              fio-874   [007]  2157.724522:   8,32   m   N cfq830 Not idling. st->count:1
> cfq830 is an async queue, and preempted by a sync queue cfq874. But since we
> have cfqg->saved_workload_slice mechanism, the preempt is a nop.
> Looks currently our preempt is totally broken if the two queues are not from
> the same workload type.
> Below patch fixes it. This will might make async queue starvation, but it's
> what our old code does before cgroup is added.

I am not sure how good a idea this is. So effectively now if there is a
preemtion across workload, the workload being preempted can lose its
share completely and be starved. So it is not just about async WRITES.
sync-noidle can starve sync-idle workload too as meta data request will
preempt any regular sync-idle queue and then sync-idle queue workload 
can be starved. So this is not exactly going back to old CFQ behavior
but something more than that too.

On one hand you are going to great lengths to fix the issues where if a
cfqq is preempted, it does not lose its share (patch 2 in the series) and
on the other hand you don't mind all the queues in a workload losing their
share due to preemption.

I think atleast we should limit this to async workload. Or solve the
problem by giving even smaller slice length to async workload.

Thanks
Vivek
