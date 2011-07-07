Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab1GGKWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 06:22:52 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:28436
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441Ab1GGKWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:22:48 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNYKTT-02-209-02
X-M-MSG: 
Date: Thu, 7 Jul 2011 12:22:41 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
Message-ID: <20110707102241.GK4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
 <1309716271.3282.6.camel@twins>
 <20110704175927.GZ4590@erda.amd.com>
 <1309855905.3282.42.camel@twins>
 <20110705091252.GA5725@elte.hu>
 <20110706165357.GG4590@erda.amd.com>
 <20110706171015.GA13869@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110706171015.GA13869@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.07.11 13:10:15, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:

> > I have to learn yet why /dev is bad and /sys is good...
> 
> Because /sys is already there and already carries rather rich 
> classification of various hardware components, devices and kernel 
> subsystems.
> 
> /dev/ is mostly a flat registry of classical, unstructured devices.

As already said, /sys provides system information. Of course it is
richer then. But I also don't want/need to specify a pmu that deep in
the system hierarchy. And /dev is flat and easy. What of the following
would you prefer?

 /sys/devices/pci0000:00/0000:00:03.0/usb2/2-2/2-2:1.1/input/input4/mouse0
 /dev/input/mouse0

Beside of this, you can't control devices with /sys.

> > The system topology is always in /sys, also for device nodes. But 
> > we can't get a device file descriptor from /sys. I doubt /sys is 
> > capable to handle a device use count (need to be checked). We 
> > actually must grab the pmu while attaching events to it. And, user 
> > space implementation is must easier with /dev (see code in my 
> > previous mail).
> 
> I think Peter suggested it that an open() done in /sys should give us 
> a handle to a given event?

Using /dev solves the problems in a simple way, and simple things
often work very well. With open() we control the refcount and we then
get a device reference which is unique and immediately usable without
parsing strings. This makes user code small and intuitive and also
avoids complex config checks on the kernel side to catch wrongly
assigned events.

While we probably can live with such races now on static pmus,
thinking of future use cases like hotplugable graphic cards with pmus
in it, we actually want a clean design for this. I don't see how to do
this with sysfs. As there are no implementations yet for such an
interface, we now have the chance to design it properly.

> > My patch also includes code that creates a device class. It is also 
> > visible in /sys/class/pmu/*.
> 
> But PMU is a very limited term: what we want is a higher level 
> organization of 'event sources' and 'events'. Some may come from 
> PMUs, many wont.

You can see it as 'virtual' pmu, like the virtual file system.
Whatever the name for this is, 'event sources' is not very handy. But
don't want to change this.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

