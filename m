Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0JNKic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 06:38:32 -0400
Received: from canuck.infradead.org ([134.117.69.58]:42430 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab0JNKib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 06:38:31 -0400
Subject: Re: [PATCH v3 3/7] sched: throttle cfs_rq entities which exceed
 their local quota
From: Peter Zijlstra <peterz@infradead.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20101014190828.f835c5e2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101012074910.GA9893@in.ibm.com>
	 <20101012075202.GD9893@in.ibm.com>
	 <20101013153421.b38a5c6f.kamezawa.hiroyu@jp.fujitsu.com>
	 <1287047542.29097.169.camel@twins>
	 <20101014185002.6ecb2bf5.kamezawa.hiroyu@jp.fujitsu.com>
	 <1287050395.29097.176.camel@twins>
	 <20101014190828.f835c5e2.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 12:37:57 +0200
Message-ID: <1287052677.29097.190.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 19:08 +0900, KAMEZAWA Hiroyuki wrote:
> > No, both lead to the same problem, its just that this adds another
> > dimension to it.. and I'm fairly sure people won't realise this until it
> > bites them in the ass.
> > 
> Hmm, them, existing problem but this add a new pitfall.
> 
> What's your recomendation to make progess on this work ?
> 
> I think 1st step will be..
> - explain the problem of priority inversion in cgroup+cfs documenation with
>   !!CAUTION!!
> 
> I'm sorry I'm not sure there have been trials for fixing priority inversion
> in the linux scheduler development.

There's kernel/rtmutex.c which is a mutex implementation with classic PI
that works for SCHED_FIFO/RR.

Thomas and I have been planning of completely rewriting PI support in
the kernel for some time but haven't gotten around to actually doing it.

The goal is to implement a variant of the Proxy Execution Protocol
(close to what gets described here in:
http://www.artist-embedded.org/docs/Events/2010/OSPERT/OSPERT2010-Proceedings.pdf
page 16, Timeslice donation in component based systems).

One of the advantages of PEP is that it works across all scheduling
policies, including proportional fair share schedulers.

It also deals correctly with all PI issues for deadline based schedulers
(correctly handles deadline as well as bandwidth inheritance).

> Explaining my motivation, a user of this feature on my customer is virtual machine
> rental service. So, some fuctionality as
> "When vcpu holds spinlock in kernel, please don't sleep.." will be nice.
> Is there patch already ? 

Well, clearly you cannot sleep while holding a spinlock.. sleeping while
holding a mutex/semaphore is allowed however, but even when you'd have
full PI over all kernel lock (as -rt has), that's not enough, you have
exactly the same problem with all userspace locks.


