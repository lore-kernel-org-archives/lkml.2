Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab1BYTxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:53:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54588 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab1BYTxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:53:10 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=gkLDreHdBTAA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=Qwv9gRP5RxJNI3ml-1oA:9 a=iazzvTmQJHTtRuGflVjXHlmEVBgA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 25 Feb 2011 14:53:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Dominik Klein <dk@in-telegence.net>
Cc: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225195307.GA23161@home.goodmis.org>
References: <4D63BA3B.7070809@in-telegence.net>
 <20110222152426.GD28269@redhat.com>
 <20110222190953.GF28269@redhat.com>
 <4D650D7E.4050908@in-telegence.net>
 <4D662248.6040405@in-telegence.net>
 <20110224142303.GA18494@redhat.com>
 <20110224143105.GL7840@htj.dyndns.org>
 <4D66720E.70102@in-telegence.net>
 <20110224151701.GQ7840@htj.dyndns.org>
 <4D67591F.10105@in-telegence.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D67591F.10105@in-telegence.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 08:24:15AM +0100, Dominik Klein wrote:
> > Maybe watching what the workqueue is doing using the following trace
> > events could be helpful.
> > 
> > # grep workqueue /sys/kernel/debug/tracing/available_events
> > workqueue:workqueue_insertion
> > workqueue:workqueue_execution
> > workqueue:workqueue_creation
> > workqueue:workqueue_destruction
> 
> Since I've never done this before, I will tell you how I captured the
> trace so you know what I did and can see whether I did something wrong
> and can correct me if necessary.
> 
> echo blk > /sys/kernel/debug/tracing/current_tracer
> echo 1 > /sys/block/sdb/trace/enable
> echo workqueue_queue_work >> /sys/kernel/debug/tracing/set_event
> echo workqueue_activate_work >> /sys/kernel/debug/tracing/set_event
> echo workqueue_execute_start >> /sys/kernel/debug/tracing/set_event
> echo workqueue_execute_end >> /sys/kernel/debug/tracing/set_event
> cat /sys/kernel/debug/tracing/trace_pipe

Just an FYI,

If you download trace-cmd from:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

You could do the following:

# trace-cmd record -p blk -e workqueue_queue_work -e workqueue_activate_work -e workqueue_execute_start -e workqueue_execute_end <cmd>

Where <cmd> could be 
sh -c "echo 1 > /sys/block/sdb/trace/enable; sleep 10"

This will create a trace.dat file that you can read with 
trace-cmd report

Another way, if you want to do more than just that echo is to use:

# trace-cmd start -p blk -e workqueue_queue_work -e workqueue_activate_work -e workqueue_execute_start -e workqueue_execute_end
# echo 1 > /sys/block/sdb/trace/enable
# <do anyting you want>
# trace-cmd stop
# trace-cmd extract

The start just enable ftrace (like you did with the echos).
The extract will create the trace.dat file from the ftrace ring buffers.
You could alse just cat trace_pipe, which would do the same, or you
could do the echos, and then the trace-cmd stop and extract to get the
file. It's your choice ;)

You can then gzip the trace.dat file and send it to others that can read
it as well, as all the information needed to read the trace is recorded
in the file.

You could even send the data over the network instead of writing the
trace.dat locally.

On another box:

$ trace-cmd listen -p 12345

Then on the target:

# trace-cmd record -N host:12345 ...

This will send the data to the listening host and the file will be
created on the host side.

One added benefit of having the trace.dat file. kernelshark can read it.

-- Steve



> 
> And that output i gzip'd.
> 
> This was taken with 2.6.37 plus the patch you mentioned on a Dell R815
> with 2 12 core AMD Opteron 6174 CPUs. If you need any more information,
> please let me know.
> 


