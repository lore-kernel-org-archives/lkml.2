Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab2CHPqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 10:46:21 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:54684 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757373Ab2CHPqU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 10:46:20 -0500
Subject: Re: [RFC] Scheduler recorder and playback
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <4F58CE25.5070906@tu-ilmenau.de>
Date: Thu, 8 Mar 2012 17:46:15 +0200
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C1472CED-10ED-4BB6-B977-8A20EBA5DCD4@antoniou-consulting.com>
References: <85A3EFC3-FAE0-4B3A-AAA0-85FA435A9F7B@antoniou-consulting.com> <4F58CE25.5070906@tu-ilmenau.de>
To: stephan.baerwolf@tu-ilmenau.de
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephan,

On Mar 8, 2012, at 5:20 PM, Stephan Bärwolf wrote:

> Hi Pantelis,
> 
> what is your primary goal?
> 
> Saving power? Improving interactivity? Be more cache-optimal?
> 

My primary goal is improving the scheduler implementation for the new class of
devices using asymmetric cores, like the big.LITTLE ARM devices.

The scheduler is really not capable at this moment to handle the case of an arbitrary
mix of fast and slow cores which need to be shutdown when in use in milliseconds.

The target is keeping the device within the proper power operating envelope, while 
delivering acceptable performance for the interactive user.
However I cannot go about wildly hacking the scheduler without impacting drastically
the performance of other user cases.
 
> I think recording the scheduling (without drastically slowing it down) is hard to do,
> since it ticks at least HZ times per second.
> 
> Replay such an recording (on a differeny platform) seems even harder to me.
> Since different cpus (and number of them), different speed and a very likely not
> reproduceable process-setup may noise completely the replay.
> 
> Do you also want to record/replay the behaviour of the more important loadbalancer, too?
> 
> Did you thought to compare different platforms by simply having syntetically generated
> loads? (I.e. see interbench -> http://users.on.net/~ckolivas/interbench/)
> 
> 
> If you are interested in examing the scheduling-behaviour as a function of the tuneables
> (and even the HZ) - and if you are interested in getting better latency, maybe you
> are interested in nitro-patch for the scheduler?
> (I currently don't have an external patch-file, but you can get it integrated from
> https://github.com/baerwolf/linux-stephan/commits/v3.2.9-stephan-201203030000 )
> 
> Nitro enables you to do so some things, like:
> 
>        * tune the scheduler at configuration point
>        * increase the ticker-frequency way above 1000Hz
>        * tune the ticker-freq. from userspace during runtime
> 	* change the scheduling-algo for idle-tasks
> 
> 
> regards Stephan

Scheduling frequency and tuning the scheduler is immaterial. 
I don't expect to record and playback the actions of a scheduling tick.

Let's take the simple example of two CPU tasks both running in single CPU system,
without performing any I/O.

Assume a normal, non NOHZ kernel with T is the HZ tick.

A possible schedule would be something like this.

Time ->
--------------------T-----------T------------T------ ...
        |---- A ----|-- B --|--- A ----------|-- B - ...
                   (1)     (2)
                   
That is A run for time units, on the scheduling tick it is replaced by B on the CPU,
which runs for 7 time units and is blocked at (2). A is scheduled again for 18 time 
units and so on.

I don't care to recreate the minutiae of the preemption of A by B at point
(1) or vice versa at (2).

What I want is to record that during a given time period A had the CPU for 
12 time units was preempted by B for 7, and then due to the blocking of (2)
A was scheduled again.

These time units could be converted in some kind of MIPS rating, and I could state

A: Uses the CPU for 7 + 18 time units...
B: Uses the CPU for 7 time units and then blocks for ...

This is intended to be a tool for these reasons:

a) For developers to collaborate in the creation of a scheduler that
satisfies requirements for modern classes of hardware.
b) For developers to have a way to pass around files that describe their 
own use-case models, and make sure that there are no serious regressions.
c) For users to be able to report possible scheduler problems, by including
the workload that caused the problem when reporting bugs.

Regards

-- Pantelis




