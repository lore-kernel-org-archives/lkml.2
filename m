Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab1BYOzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 09:55:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36591 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab1BYOzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 09:55:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B6D2Mn52epA9gqAO4PI7A0n0IrgpbwFgPrk2ZA/9+J8U/3vGYbAJ0TG5dA3939hRC5
         BRF5qOvfhrjWzTGIcTtfrr6weI0FXyM/deHO/34MT92J4G9ZieQy0EAPPlKXPGTMser9
         gvcIdMsZ9MBMcxB+OSZRJP7IeAdF0zVlS5k2s=
Date: Fri, 25 Feb 2011 15:55:16 +0100
From: Tejun Heo <tj@kernel.org>
To: Dominik Klein <dk@in-telegence.net>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225145516.GL24828@htj.dyndns.org>
References: <4D662248.6040405@in-telegence.net>
 <20110224142303.GA18494@redhat.com>
 <20110224143105.GL7840@htj.dyndns.org>
 <4D66720E.70102@in-telegence.net>
 <20110224151701.GQ7840@htj.dyndns.org>
 <4D67591F.10105@in-telegence.net>
 <20110225112936.GH24828@htj.dyndns.org>
 <4D679688.7020503@in-telegence.net>
 <20110225131850.GI24828@htj.dyndns.org>
 <4D67BFAB.1090306@in-telegence.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D67BFAB.1090306@in-telegence.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Feb 25, 2011 at 03:41:47PM +0100, Dominik Klein wrote:
> See attached logs of another run.
> 
> sysctl -w kernel.sysrq=1
> 
> echo blk > /sys/kernel/debug/tracing/current_tracer
> echo 1 > /sys/block/sdb/trace/enable
> echo workqueue_queue_work >> /sys/kernel/debug/tracing/set_event
> echo workqueue_activate_work >> /sys/kernel/debug/tracing/set_event
> echo workqueue_execute_start >> /sys/kernel/debug/tracing/set_event
> echo workqueue_execute_end >> /sys/kernel/debug/tracing/set_event
> 
> That makes attachment trace_pipe5.gz
> 
> echo 8 > /proc/sysrq-trigger
> echo t > /proc/sysrq-trigger
> 
> That makes attachment console.gz

So, the following work item never finished.  We can tell that pid 549
started execution from the last line.

          <idle>-0     [017]  1497.601733: workqueue_queue_work: work struct=ffff880809f3fe70 function=blk_throtl_work workqueue=ffff88102c8ba700 req_cpu=17 cpu=17
          <idle>-0     [017]  1497.601736: workqueue_activate_work: work struct ffff880809f3fe70
           <...>-549   [017]  1497.601754: workqueue_execute_start: work struct ffff880809f3fe70: function blk_throtl_work

And the stack trace of pid 549 is...

[ 1522.220046] kworker/17:1  D ffff88202fc53600     0   549      2 0x00000000
[ 1522.220046]  ffff88082c5bd7c0 0000000000000046 ffff88180a822600 ffff88082c578000
[ 1522.220046]  0000000000013600 ffff88080afaffd8 0000000000013600 0000000000013600
[ 1522.220046]  ffff88082c5bda98 ffff88082c5bdaa0 ffff88082c5bd7c0 0000000000013600
[ 1522.220046] Call Trace:
[ 1522.220046]  [<ffffffff810395c6>] ? __wake_up+0x35/0x46
[ 1522.220046]  [<ffffffff81315de3>] ? io_schedule+0x68/0xa7
[ 1522.220046]  [<ffffffff81182168>] ? get_request_wait+0xee/0x17d
[ 1522.220046]  [<ffffffff810604f1>] ? autoremove_wake_function+0x0/0x2a
[ 1522.220046]  [<ffffffff811826b6>] ? __make_request+0x313/0x45d
[ 1522.220046]  [<ffffffff81180ebd>] ? generic_make_request+0x30d/0x385
[ 1522.220046]  [<ffffffff8105cc79>] ? queue_delayed_work_on+0xfc/0x10a
[ 1522.220046]  [<ffffffff8118c607>] ? blk_throtl_work+0x312/0x32b
[ 1522.220046]  [<ffffffff8118c2f5>] ? blk_throtl_work+0x0/0x32b
[ 1522.220046]  [<ffffffff8105b754>] ? process_one_work+0x1d1/0x2ee
[ 1522.220046]  [<ffffffff8105d1e3>] ? worker_thread+0x12d/0x247
[ 1522.220046]  [<ffffffff8105d0b6>] ? worker_thread+0x0/0x247
[ 1522.220046]  [<ffffffff8105d0b6>] ? worker_thread+0x0/0x247
[ 1522.220046]  [<ffffffff8106009f>] ? kthread+0x7a/0x82
[ 1522.220046]  [<ffffffff8100a824>] ? kernel_thread_helper+0x4/0x10
[ 1522.220046]  [<ffffffff81060025>] ? kthread+0x0/0x82
[ 1522.220046]  [<ffffffff8100a820>] ? kernel_thread_helper+0x0/0x10

The '?'s are because frame pointer is disabled and means that the
stack trace is a guesswork.  Can you please turn on
CONFIG_FRAME_POINTER just to be sure?  But at any rate, it looks like
blk_throtl_work() got stuck trying to allocate a request.  I don't
think workqueue is causing any problem here.  It seems like a resource
deadlock on request.  Vivek, any ideas?

Thanks.

-- 
tejun
