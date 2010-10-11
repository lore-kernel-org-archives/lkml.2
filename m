Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab0JKNwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:52:00 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:43899 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab0JKNv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:51:59 -0400
Date: Mon, 11 Oct 2010 15:51:52 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH/RFC] timer: fix deadlock on cpu hotplug
Message-ID: <20101011135152.GB10270@osiris.boeblingen.de.ibm.com>
References: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
 <4C98D0EB.30002@kernel.org>
 <1285083618.2275.884.camel@laptop>
 <20100922083706.GA2177@osiris.boeblingen.de.ibm.com>
 <1285147362.2275.896.camel@laptop>
 <1285165776.2275.1022.camel@laptop>
 <20100923133103.GA3832@osiris.boeblingen.de.ibm.com>
 <1286800263.2336.390.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286800263.2336.390.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 02:31:03PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-09-23 at 15:31 +0200, Heiko Carstens wrote:
> > On Wed, Sep 22, 2010 at 04:29:36PM +0200, Peter Zijlstra wrote:
> > > On Wed, 2010-09-22 at 11:22 +0200, Peter Zijlstra wrote:
> > > 
> > > > The idea was to move it to a class of its own above SCHED_FIFO.
> > > > 
> > > > I'll try and get something done, but I'm heading out to LinuxCon.JP
> > > > soon.
> > > 
> > > Something like the below, it seems to boot, build a kernel and hotplug.
> > 
> > Thanks for the fast patch. Yes, it works. Sort of:
> > 
> > ------------[ cut here ]------------
> > WARNING: at kernel/kthread.c:182
> > [...]
> > ..and crashes afterwards ;)
> > 
> > Btw. I also tried to boot 2.6.35.5 with your patch and it hangs just at
> > the beginning. I also had to apply 5e3d20a68f63fc5a310687d81956c3b96e488b84
> > "init: Remove the BKL from startup code" to make the machine boot again,
> > which was a bit surprising.
> 
> Does something like the below (on top of the previous patch) work?

Yes, it works. Just survived a git clone a complete kernel build while cpu
hotplug stress was running. Thanks!

Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>

> Can I have your hotplug script (cpukill2.sh?) to test, a simply while(1)
> loop offlining and onlining cpu1 doesn't seem to impress my machine
> (with the below folded in)..

That's one of the scripts our testers are using:

#! /bin/bash
RANDOM=`date '+%s'`
let "NUMBER = $RANDOM % 2 + 0"
CPUS=`ls /sys/devices/system/cpu/ | grep cpu`
count=`echo $CPUS | wc -w`
echo You have $count no. of CPUs
echo You have the following CPUs: $CPUS
while [ 1 ] ; do
   for ((i=0 ; i<=$count ; i++)) ; do
      rnd=$[($RANDOM % $count) ]     # RND between 0..max_no_of_cpu
      let "NUMBER = $RANDOM % 2 + 0"
      echo "echo $NUMBER > /sys/devices/system/cpu/cpu$rnd/online"
      echo $NUMBER > /sys/devices/system/cpu/cpu$rnd/online
   done
done
