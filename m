Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1IMLn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 07:43:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab1IMLn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:43:58 -0400
Message-ID: <4E6F41EB.1040106@redhat.com>
Date: Tue, 13 Sep 2011 14:43:39 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 8/5] llist: Remove cpu_relax() usage in cmpxchg loops
References: <1315461646-1379-1-git-send-email-ying.huang@intel.com>  <1315836358.26517.43.camel@twins> <4E6E1693.7080606@redhat.com> <1315837930.26517.49.camel@twins>
In-Reply-To: <1315837930.26517.49.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2011 05:32 PM, Peter Zijlstra wrote:
> On Mon, 2011-09-12 at 17:26 +0300, Avi Kivity wrote:
> >  On 09/12/2011 05:05 PM, Peter Zijlstra wrote:
> >  >  Subject: llist: Remove cpu_relax() usage in cmpxchg loops
> >  >  From: Peter Zijlstra<a.p.zijlstra@chello.nl>
> >  >  Date: Mon Sep 12 15:50:49 CEST 2011
> >  >
> >  >  Initial benchmarks show they're a net loss (2 socket wsm):
> >  >
> >  >    $ for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ; do echo performance>   $i; done
> >  >    $ echo 4096 32000 64 128>   /proc/sys/kernel/sem
> >  >    $ ./sembench -t 2048 -w 1900 -o 0
> >  >
> >
> >  We hyperthreading enabled, and were all threads loaded?  cpu_relax
> >  allows the other thread to make more progress while the spinner relaxes.
>
> Yeah, with HT enabled, the benchmark runs 2048 tasks and does 1900 task
> bulk wakeups or so. Forgot the details, but it basically stresses the
> sleep+wakeup paths like nobodies business.

Ok.

Another issue is that hypervisors use PAUSE to detect a spinning guest 
and issue a directed yield to another vcpu.  But for cmpxchg loops, the 
"spinner" would just commit on the next loop, no?  So I think there's no 
objection from that front.

-- 
error compiling committee.c: too many arguments to function

