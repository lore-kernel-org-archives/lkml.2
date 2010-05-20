Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab0ETX3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 19:29:21 -0400
Received: from kroah.org ([198.145.64.141]:53374 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab0ETX3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 19:29:18 -0400
Date: Thu, 20 May 2010 16:12:29 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 06/11] perf: core, export pmus via sysfs
Message-ID: <20100520231229.GB8335@kroah.com>
References: <1274233602.3036.84.camel@localhost>
 <20100518200524.GA20223@kroah.com>
 <1274236496.3603.22.camel@minggr.sh.intel.com>
 <20100519024823.GA25229@kroah.com>
 <1274253276.5605.10124.camel@twins>
 <20100520184213.GB21030@kroah.com>
 <20100520201418.GB11470@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520201418.GB11470@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 10:14:18PM +0200, Ingo Molnar wrote:
> 
> * Greg KH <greg@kroah.com> wrote:
> 
> > [...]
> >
> > I can always knock up a eventfs for you do mount at /sys/kernel/events/ or 
> > something if you want :)
> 
> eventfs was my first idea, until Peter convinced me that we want sysfs :-)
> 
> One important aspect would be to move it into the physical topology. Graphics 
> card? It might have events. PCI device? It might have events. Southbridge? It 
> might have a PMU and events. CPU? It has a PMU.
> 
> Especially when it comes to complex physical topologies on larger systems, we 
> eventually want to visualize things in tooling as well - as a tree of the 
> physical topology. Also, physical topologies will only become more complex, so 
> we dont want to detach events from them.

Ok, yes, physical topology would be nice to have, I agree.

> > sysfs exports single values just fine.  If you are starting to do more 
> > complex things, like you currently are, maybe you shouldn't be in sysfs...
> 
> This is really like a read-only attributes, and it would be multi-line only 
> for the event format descriptor - a genuinely new aspect: a flexible ABI 
> descriptor.

Oh no...

> It's an attribute for a very good purpose: flexible ABI with a user-space that 
> interprets new format descriptions automatically. This is not just theory, for 
> example perf trace does this today, and you can write scripts with old tools 
> for a new event that shows up in a new kernel, without rebuilding the tools.
> 
> Here is an example of a format descriptor:
> 
> # cat /debug/tracing/events/sched/sched_wakeup/format 
> name: sched_wakeup
> ID: 59
> format:
> 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> 	field:int common_pid;	offset:4;	size:4;	signed:1;
> 	field:int common_lock_depth;	offset:8;	size:4;	signed:1;
> 
> 	field:char comm[TASK_COMM_LEN];	offset:12;	size:16;	signed:1;
> 	field:pid_t pid;	offset:28;	size:4;	signed:1;
> 	field:int prio;	offset:32;	size:4;	signed:1;
> 	field:int success;	offset:36;	size:4;	signed:1;
> 	field:int target_cpu;	offset:40;	size:4;	signed:1;
> 
> print fmt: "comm=%s pid=%d prio=%d success=%d target_cpu=%03d", REC->comm, REC->pid, REC->prio, REC->success, REC->target_cpu

Hm, kind of like a "sane" xml, right?

> Also, we already have quite a few multi-line files in sysfs, for example:

These are all aborations, please don't perputuate it.

> $ cat /sys/devices/pnp0/00:09/options
> Dependent: 00 - Priority preferred
>   port 0x378-0x378, align 0x0, size 0x8, 16-bit address decoding
>   port 0x778-0x778, align 0x0, size 0x8, 16-bit address decoding
>   irq 7 High-Edge
>   dma 3 8-bit compatible
> Dependent: 01 - Priority acceptable
>   port 0x378-0x378, align 0x0, size 0x8, 16-bit address decoding
>   port 0x778-0x778, align 0x0, size 0x8, 16-bit address decoding
>   irq 3,4,5,6,7,10,11,12 High-Edge
>   dma 0,1,2,3 8-bit compatible
> Dependent: 02 - Priority acceptable
>   port 0x278-0x278, align 0x0, size 0x8, 16-bit address decoding
>   port 0x678-0x678, align 0x0, size 0x8, 16-bit address decoding
>   irq 3,4,5,6,7,10,11,12 High-Edge
>   dma 0,1,2,3 8-bit compatible
> Dependent: 03 - Priority acceptable
>   port 0x3bc-0x3bc, align 0x0, size 0x4, 16-bit address decoding
>   port 0x7bc-0x7bc, align 0x0, size 0x4, 16-bit address decoding
>   irq 3,4,5,6,7,10,11,12 High-Edge
>   dma 0,1,2,3 8-bit compatible

That should be a debugfs file.

> $ cat /sys/devices/pci0000:00/0000:00:1a.7/pools
> poolinfo - 0.1
> ehci_sitd           0    0   96  0
> ehci_itd            0    0  160  0
> ehci_qh             4   42   96  1
> ehci_qtd            4   42   96  1
> buffer-2048         0    0 2048  0
> buffer-512          0    0  512  0
> buffer-128          0    0  128  0
> buffer-32           1  128   32  1

Odd, I hadn't noticed that one before.  I can't figure out what that
file is, who creates it?

Ick, mm/dmapool.c?  Hm, not good, that's a debugging file only, and
really does not belong in sysfs.  It seems to predate 2.6.12, so it made
it in before debugfs was around.  I'll work on moving it out of sysfs...

> In fact uevents have multi-line attributes as well:
> 
> $ cat /sys/devices/pci0000:00/0000:00:1a.1/usb4/uevent
> MAJOR=189
> MINOR=384
> DEVNAME=bus/usb/004/001
> DEVTYPE=usb_device
> DRIVER=usb
> DEVICE=/proc/bus/usb/004/001
> PRODUCT=1d6b/1/206
> TYPE=9/0/0
> BUSNUM=004
> DEVNUM=001

Yes, that's the environment variables that are sent to userspace in the
uevent.  I don't like the multi-line stuff for this one, but we couldn't
think of a better way at the time.

Anyway, back to your original issue, multi-line sysfs files.

I really don't want to do something like that, in sysfs, if at all
possible.  We have been working very hard to keep the sysfs file format
simple, and to follow the one-value-per-file rule, so we don't end up
repeating the same mistakes we did in /proc.

Now one could argue that we are not entirely successful, especially
based on your examples above.  However, those are the rare exception,
not the rule by far.

So, where do we do something like this?  I don't know.  I still like the
idea of eventfs, and we could pass in a kobject to it to have it create
the tree if needed.  Yeah, that would be a replication of some of the
sysfs structure, but you could have a custom file format, like you show
above, which would you could control and keep in step with your
userspace tools.

How deep in the device tree are you really going to be caring about?  It
sounds like the large majority of events are only going to be coming
from the "system" type objects (cpu, nodes, memory, etc.) and very few
would be from things that we consider a 'struct device' today (like a
pci, usb, scsi, or input, etc.)

thanks,

greg k-h
