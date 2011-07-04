Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab1GDR7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:59:35 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:35479
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758475Ab1GDR7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:59:34 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz936eK4015L1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNTLZ3-02-6CO-02
X-M-MSG: 
Date: Mon, 4 Jul 2011 19:59:27 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
Message-ID: <20110704175927.GZ4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
 <1309716271.3282.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309716271.3282.6.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.07.11 14:04:31, Peter Zijlstra wrote:
> On Sun, 2011-07-03 at 17:04 +0200, Robert Richter wrote:
> > 
> > this is a prototype implementation for attaching an event to a
> > specific PMU. If there is a general acceptance for this approach I
> > will create patches for upstream integration and base my current IBS
> > patches on it. 
> 
> But there's already an infrastructure to do this, simply stick the
> contents of /sys/bus/event_source/devices/*/type in
> perf_event_attr::type and you're done.
> 
> I don't see the need for /dev crap.

Using sysfs by reading from /sys/bus/event_source/devices/*/type would
work too. But there are several reasons why I like my approach.

First of all, it follows the idea of grouping events. Attaching events
to a specific pmu is not different from attaching them to a specific
event group. It is actually the same if we think of one group for
events that may be scheduled on only one pmu. Thus, treating a pmu
like a group event is the logical step for intuitive usage of the
perf_open syscall. This way we have symmetrical implementations for
binding events to groups or pmus.

The syscall interface has already everything needed for this.
Following the concept of attaching events to a group with a file
descriptor, we simply must create a file descriptor pointing to a pmu
device. This works without extending the perf_open syscall interface,
no changes to the interface are needed.

Device nodes are the general approach for controlling devices from
user-space, they are integral part of the Linux device driver model.
With a device file descriptor opened from a device node we can
explicitly point to a pmu device.

Representing a device with a device node is common programming
practice. Usage of device nodes is not deprecated. There are existing
frameworks to easily create such devices. With dynamically device node
allocation and udev there are solutions for drawbacks of /dev. Why not
having a device node for pmus? What are your concerns using /dev?

The patch introduces a pmu device class and devices are grouped by
class now. They can be found in /dev/pmu/* instead of searching for
device attributes somewhere in the system hirarchie at
/sys/bus/event_source/devices/*/type. A device node is easier to
handle.

The implementation only needs about 150 lines of kernel code. It is
straight and separated. There is nothing special what makes it hard to
read or maintain. The code is using typical kernel device allocation
methods. Do you think this patch makes kernel code too complex?

There is much easier user-space code:

       pmu = open("/dev/pmu/proto", O_RDONLY);
       if (pmu == -1)
               err(1, "pmu not found");

       attr.config = 0xf00ba2;

       event = sys_perf_event_open(&attr, 0, -1, pmu, 0);

vs.

        pmu = open("/sys/bus/event_source/devices/proto/type", O_RDONLY);
        if (pmu == -1)
                err(1, "pmu not found");
        size = read(pmu, buf, BUFSIZ - 1);
        if (size < 0) {
                close(pmu);
                err(1, "failed to read pmu type");
        }
        buf[size] = '0';

        attr.type = atoi(buf);
        attr.config = 0xf00ba2;

       event = sys_perf_event_open(&attr, 0, -1, -1, 0);

There are also additional header includes and variable declarations
needed.

(Btw, current kernel code does not support dynamically allocated pmu
types due to a check in perf_copy_attr():

        if (attr->type >= PERF_TYPE_MAX)
                return -EINVAL;
)

Beside of that, using /sys/ is racy. There is no protection against
unregistering the pmu. Probably this might not cause big problems in
practice, but it can be done better. With open/close we can protect
the pmu from being removed.

Overall, my approach improves the perf design. It adds a better and
more intuitve access to perf from user space with clear and common
methods and interfaces. Please let me know the concerns you have.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

