Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab2JJOZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:25:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39671 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab2JJOZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:25:33 -0400
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
From: Andrew Theurer <habanero@linux.vnet.ibm.com>
Reply-To: habanero@linux.vnet.ibm.com
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
In-Reply-To: <20121009185108.GA2549@linux.vnet.ibm.com>
References: <20120921120000.27611.71321.sendpatchset@codeblue>
	 <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com>
	 <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com>
	 <506C7057.6000102@redhat.com> <506D69AB.7020400@linux.vnet.ibm.com>
	 <506D83EE.2020303@redhat.com> <1349356038.14388.3.camel@twins>
	 <506DA48C.8050200@redhat.com>  <20121009185108.GA2549@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 10 Oct 2012 09:24:55 -0500
Message-ID: <1349879095.5551.266.camel@oc6622382223.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101014-2876-0000-0000-000000E598FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran 'perf sched map' on the dbench workload for medium and large VMs,
and I thought I would share some of the results.  I think it helps to
visualize what's going on regarding the yielding.

These files are png bitmaps, generated from processing output from 'perf
sched map' (and perf data generated from 'perf sched record').  The Y
axis is the host cpus, each row being 10 pixels high.  For these tests,
there are 80 host cpus, so the total height is 800 pixels.  The X axis
is time (in microseconds), with each pixel representing 1 microsecond.
Each bitmap plots 30,000 microseconds.  The bitmaps are quite wide
obviously, and zooming in/out while viewing is recommended.

Each row (each host cpu) is assigned a color based on what thread is
running.  vCPUs of the same VM are assigned a common color (like red,
blue, magenta, etc), and each vCPU has a unique brightness for that
color.  There are a maximum of 12 assignable colors, so in any VMs >12
revert to vCPU color of gray. I would use more colors, but it becomes
harder to distinguish one color from another.  The white color
represents missing data from perf, and black color represents any thread
which is not a vCPU.

For the following tests, VMs were pinned to host NUMA nodes and to
specific cpus to help with consistency and operate within the
constraints of the last test (gang scheduler).

Here is a good example of PLE.  These are 10-way VMs, 16 of them (as
described above only 12 of the VMs have a color, rest are gray).

https://docs.google.com/open?id=0B6tfUNlZ-14wdmFqUmE5QjJHMFU

If you zoom out and look at the whole bitmap, you may notice the 4ms
intervals of the scheduler.  They are pretty well aligned across all
cpus.  Normally, for cpu bound workloads, we would expect to see each
thread to run for 4 ms, then something else getting to run, and so on.
That is mostly true in this test.  We have 2x over-commit and we
generally see the switching of threads at 4ms.  One thing to note is
that not all vCPU threads for the same VM run at exactly the same time,
and that is expected and the whole reason for lock-holder preemption.
Now, if you zoom in on the bitmap, you should notice within the 4ms
intervals there is some task switching going on.  This is most likely
because of the yield_to initiated by the PLE handler.  In this case
there is not that much yielding to do.   It's quite clean, and the
performance is quite good.

Below is an example of PLE, but this time with 20-way VMs, 8 of them.
CPU over-commit is still 2x.

https://docs.google.com/open?id=0B6tfUNlZ-14wdmFqUmE5QjJHMFU

This one looks quite different.  In short, it's a mess.  The switching
between tasks can be lower than 10 microseconds.  It basically never
recovers.  There is constant yielding all the time.  

Below is again 8 x 20-way VMs, but this time I tried out Nikunj's gang
scheduling patches.  While I am not recommending gang scheduling, I
think it's a good data point.  The performance is 3.88x the PLE result.

https://docs.google.com/open?id=0B6tfUNlZ-14wWXdscWcwNTVEY3M

Note that the task switching intervals of 4ms are quite obvious again,
and this time all vCPUs from same VM run at the same time.  It
represents the best possible outcome.


Anyway, I thought the bitmaps might help better visualize what's going
on.

-Andrew



