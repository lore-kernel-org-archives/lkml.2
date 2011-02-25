Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1BYLaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:30:00 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49450 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab1BYL36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:29:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kEbliADvhaAyIYLc+clp/0P/kVm1a+U2fikn5sLRTYmAPqI2xbC4HdoFJzG6lbvrNC
         HHTKCQrMTPQNb1xqR7amZ5zPU98AuBWiJ4QPA6rM2brxo9XTDvaktSjcVkPnPbdsT8XE
         kGnpnCVMGF5C5yEblhmoO2eMNuYmSTMVnL8tg=
Date: Fri, 25 Feb 2011 12:29:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Dominik Klein <dk@in-telegence.net>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        libvir-list@redhat.com
Subject: Re: Is it a workqueue related issue in 2.6.37 (Was: Re: [libvirt]
 blkio cgroup [solved])
Message-ID: <20110225112936.GH24828@htj.dyndns.org>
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
> 
> And that output i gzip'd.
> 
> This was taken with 2.6.37 plus the patch you mentioned on a Dell R815
> with 2 12 core AMD Opteron 6174 CPUs. If you need any more information,
> please let me know.

Hmmm... well, I have no idea what you were trying to do but here are
some info which might be helpful.

* queue_work happens when the work item is queued.

* activate_work happens when the work item becomes eligible for
  execution.  e.g. If the workqueue's @max_active is limited and
  maximum number of work items are already in flight, a new item will
  only get activated after one of the in flight ones retires.

* execute_start marks the actual starting of execution.

* execute_end marks the end of execution.

So, I would look for the matching work function and then try to follow
what happens to it after being scheduled and if it doesn't get
executed what's going on with the target workqueue.

Thanks.

-- 
tejun
