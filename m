Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1HCCwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 22:52:30 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:41467 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753385Ab1HCCw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 22:52:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkDAN20OE55LCkBgWdsb2JhbABCp1kVAQEWJiWBQAEBBTocIxAIAxguFCUDNMZTDoY0BJsuiEM
Date: Wed, 3 Aug 2011 12:52:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [regression, 3.1, rcu] rcu_sched_state detected stall on CPU 8
 (t=15000 jiffies)
Message-ID: <20110803025222.GI12870@dastard>
References: <20110803022857.GH12870@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110803022857.GH12870@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 12:28:57PM +1000, Dave Chinner wrote:
> Hi Paul,
> 
> I've had this hang a couple of times now, so I figured it isn't an
> isolated event. I am getting kernels occassionally hanging with the
> following output occurring:
> 
> [   62.812011] INFO: rcu_sched_state detected stall on CPU 8 (t=15000 jiffies)
> [  242.936009] INFO: rcu_sched_state detected stall on CPU 8 (t=60031 jiffies)
> 
> And that just goes on until I reboot the machine. e.g. from a test
> run on a 2p VM that I didn't check on over the weekend:
> 
> [220167.108005] INFO: rcu_sched_state detected stall on CPU 0 (t=54681420 jiffies)
> [220347.228004] INFO: rcu_sched_state detected stall on CPU 0 (t=54726450 jiffies)
> [220527.348003] INFO: rcu_sched_state detected stall on CPU 0 (t=54771480 jiffies)
> [220707.468006] INFO: rcu_sched_state detected stall on CPU 0 (t=54816510 jiffies)
> [220887.588003] INFO: rcu_sched_state detected stall on CPU 0 (t=54861540 jiffies)
> [221067.708003] INFO: rcu_sched_state detected stall on CPU 0 (t=54906570 jiffies)
> [221247.828004] INFO: rcu_sched_state detected stall on CPU 0 (t=54951600 jiffies)
> [221427.948003] INFO: rcu_sched_state detected stall on CPU 0 (t=54996630 jiffies)
> [221608.068003] INFO: rcu_sched_state detected stall on CPU 0 (t=55041660 jiffies)
> [221788.188019] INFO: rcu_sched_state detected stall on CPU 0 (t=55086690 jiffies)
> [221968.308014] INFO: rcu_sched_state detected stall on CPU 0 (t=55131720 jiffies)
> [222148.428010] INFO: rcu_sched_state detected stall on CPU 0 (t=55176750 jiffies)
> 
> I've seen it on 2p and now a 16p test VM. This one occurred
> during boot of the 16p VM:
> 
> [    2.600499] kjournald starting.  Commit interval 5 seconds
> [    2.600878] EXT3-fs (sda1): mounted filesystem with ordered data mode
> [    2.600995] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
> [    2.612351] Freeing unused kernel memory: 2824k freed
> INIT: version 2.88 booting
> Using makefile-style concurrent boot in runlevel S.
> [   62.812011] INFO: rcu_sched_state detected stall on CPU 8 (t=15000 jiffies)
> [  242.936009] INFO: rcu_sched_state detected stall on CPU 8 (t=60031 jiffies)
> 
> While the console still echos characters, the boot process is
> not making progress.
> 
> I've had this happen under heavy CPU and IO load, sometimes hours
> after boot e.g. one was mid-way through a 4th run of xfstests which
> takes about 80mins to do a complete run. There doesn't appear to be
> any pattern to when it occurs and I cannot reproduce it on command,
> so tracking it down might be difficult.

This might be a false alarm - I've just diagnosed(*) that a kernel
thread was stuck in a hard loop therefore not giving up the CPU.

Perhaps this is error message could be more informative?
The detector is acting like the hung task detector, except it's
working on kernel code stuck in a loop burning CPU, so maybe dumping
a stack trace of the spinning CPU (i.e. similar to sysrq-l output)
might be a useful addition to tracking down such stalls?

Cheers,

Dave.

(*) luckily the kernel was still responding to the kvm sendkey
command so I could get at sysrq dumps to the console...
-- 
Dave Chinner
david@fromorbit.com
