Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab1BYUSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:18:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932783Ab1BYUSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:18:44 -0500
Date: Fri, 25 Feb 2011 15:18:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dominik Klein <dk@in-telegence.net>, Tejun Heo <tj@kernel.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225201830.GK2994@redhat.com>
References: <20110222152426.GD28269@redhat.com>
 <20110222190953.GF28269@redhat.com>
 <4D650D7E.4050908@in-telegence.net>
 <4D662248.6040405@in-telegence.net>
 <20110224142303.GA18494@redhat.com>
 <20110224143105.GL7840@htj.dyndns.org>
 <4D66720E.70102@in-telegence.net>
 <20110224151701.GQ7840@htj.dyndns.org>
 <4D67591F.10105@in-telegence.net>
 <20110225195307.GA23161@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225195307.GA23161@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 02:53:08PM -0500, Steven Rostedt wrote:
> On Fri, Feb 25, 2011 at 08:24:15AM +0100, Dominik Klein wrote:
> > > Maybe watching what the workqueue is doing using the following trace
> > > events could be helpful.
> > > 
> > > # grep workqueue /sys/kernel/debug/tracing/available_events
> > > workqueue:workqueue_insertion
> > > workqueue:workqueue_execution
> > > workqueue:workqueue_creation
> > > workqueue:workqueue_destruction
> > 
> > Since I've never done this before, I will tell you how I captured the
> > trace so you know what I did and can see whether I did something wrong
> > and can correct me if necessary.
> > 
> > echo blk > /sys/kernel/debug/tracing/current_tracer
> > echo 1 > /sys/block/sdb/trace/enable
> > echo workqueue_queue_work >> /sys/kernel/debug/tracing/set_event
> > echo workqueue_activate_work >> /sys/kernel/debug/tracing/set_event
> > echo workqueue_execute_start >> /sys/kernel/debug/tracing/set_event
> > echo workqueue_execute_end >> /sys/kernel/debug/tracing/set_event
> > cat /sys/kernel/debug/tracing/trace_pipe
> 
> Just an FYI,
> 
> If you download trace-cmd from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
> 
> You could do the following:
> 
> # trace-cmd record -p blk -e workqueue_queue_work -e workqueue_activate_work -e workqueue_execute_start -e workqueue_execute_end <cmd>
> 
> Where <cmd> could be 
> sh -c "echo 1 > /sys/block/sdb/trace/enable; sleep 10"
> 
> This will create a trace.dat file that you can read with 
> trace-cmd report
> 
> Another way, if you want to do more than just that echo is to use:
> 
> # trace-cmd start -p blk -e workqueue_queue_work -e workqueue_activate_work -e workqueue_execute_start -e workqueue_execute_end
> # echo 1 > /sys/block/sdb/trace/enable
> # <do anyting you want>
> # trace-cmd stop
> # trace-cmd extract
> 
> The start just enable ftrace (like you did with the echos).
> The extract will create the trace.dat file from the ftrace ring buffers.
> You could alse just cat trace_pipe, which would do the same, or you
> could do the echos, and then the trace-cmd stop and extract to get the
> file. It's your choice ;)
> 
> You can then gzip the trace.dat file and send it to others that can read
> it as well, as all the information needed to read the trace is recorded
> in the file.
> 
> You could even send the data over the network instead of writing the
> trace.dat locally.
> 
> On another box:
> 
> $ trace-cmd listen -p 12345
> 
> Then on the target:
> 
> # trace-cmd record -N host:12345 ...
> 
> This will send the data to the listening host and the file will be
> created on the host side.

Thanks Steve. In this case this feature of sending trace data over
network would have helped. We were running into issues where IO scheduler
was freezing so we could not read anything from disk(including saved traces).
Hence we were directing everything to console and then doing copy paste.

So sending it over network would have probably worked even in this case.

Will give trace-cmd a try next time.

Thanks
Vivek
