Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab0F3NkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 09:40:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0F3NkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 09:40:12 -0400
X-Authority-Analysis: v=1.1 cv=jfMbZ+4tkgrYlaJBi3iJCtg6TDszHDHJJpQ3TdTfnr0= c=1 sm=0 a=u8eIACkqEOAA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=AONxhUtn9rnsukDYc5MA:9 a=U9uWd7ZmrxxynDPTGjwA:7 a=tBDf3qHoBecfeF8tdgUZm0ynncoA:4 a=PUjeQqilurYA:10 a=0kPLrQdw3YYA:10 a=P8ES0JSHQkb-jz7X:21 a=Yc4W0-ETLj4URaow:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [BUG] kacpi_notify goes into an infinite loop (luckly it calls
 cond_resched)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Renninger <trenn@suse.de>,
       "clarkt@cnsp.com" <clarkt@cnsp.com>, "Brown, Len" <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1275274670.9119.4419.camel@rzhang1-desktop>
References: <1275094882.22648.607.camel@gandalf.stny.rr.com>
	 <1275274670.9119.4419.camel@rzhang1-desktop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 30 Jun 2010 09:40:08 -0400
Message-ID: <1277905208.24800.21.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 10:57 +0800, Zhang Rui wrote:
> Hi, Steve,
> 
> On Sat, 2010-05-29 at 09:01 +0800, Steven Rostedt wrote:
> > I just replaced Windows with F12 on my wife's computer, to have nothing
> > but issues. But anyway, one of the issues I had on this box was in
> > vanilla linux kernel 2.6.34 (all the fedora kernels had other issues),
> > the kacpi_notify would go into an infinite loop.
> > 
> > I debugged it a bit with ftrace and saw that the kacpi_notify workqueue
> > was constantly requeuing itself (thanks to the workqueue trace events).
> > 
> > I bisected this, and it came down to this change:
> > 
> > commit fa80945269f312bc609e8384302f58b03c916e12
> > Author: Thomas Renninger <trenn@suse.de>
> > Date:   Sat Feb 20 11:44:27 2010 +0100
> > 
> >     ACPI thermal: Don't invalidate thermal zone if critical trip point is bad
> > 
> > 
> This patch enables the ACPI thermal control which is used to be disabled
> on some laptops.
> 
> Maybe this triggers an interrupt storm on this box.
> 
> please attach the output of "grep . /sys/firmware/acpi/interrupts/*".
> please attach the acpidump output of your laptop as well.

Sorry for the very late reply, I've been on the Cc of two kacpi_notify
bugs and one was not the problem, and I was deleting both emails as they
came in thinking they were the one I was ignoring. I just noticed that
the bug I had was closed due to my unresponsiveness. Sorry about that,
this was my wife's desktop and once I got it working, it became very low
priority (and I basically forgot about it).


Anyway here's the info on the box if your are still interested:

# grep . /sys/firmware/acpi/interrupts/*
/sys/firmware/acpi/interrupts/error:       0
/sys/firmware/acpi/interrupts/ff_gbl_lock:       0	disabled
/sys/firmware/acpi/interrupts/ff_pmtimer:       0	invalid
/sys/firmware/acpi/interrupts/ff_pwr_btn:       0	enabled
/sys/firmware/acpi/interrupts/ff_rt_clk:       0	disabled
/sys/firmware/acpi/interrupts/ff_slp_btn:       0	invalid
/sys/firmware/acpi/interrupts/gpe00:       0	invalid
/sys/firmware/acpi/interrupts/gpe01:       0	invalid
/sys/firmware/acpi/interrupts/gpe02:       0	invalid
/sys/firmware/acpi/interrupts/gpe03:       0	disabled
/sys/firmware/acpi/interrupts/gpe04:       0	disabled
/sys/firmware/acpi/interrupts/gpe05:       0	invalid
/sys/firmware/acpi/interrupts/gpe06:       0	invalid
/sys/firmware/acpi/interrupts/gpe07:       0	invalid
/sys/firmware/acpi/interrupts/gpe08:       0	invalid
/sys/firmware/acpi/interrupts/gpe09:       0	invalid
/sys/firmware/acpi/interrupts/gpe0A:       0	invalid
/sys/firmware/acpi/interrupts/gpe0B:       0	disabled
/sys/firmware/acpi/interrupts/gpe0C:       0	disabled
/sys/firmware/acpi/interrupts/gpe0D:       0	disabled
/sys/firmware/acpi/interrupts/gpe0E:       0	invalid
/sys/firmware/acpi/interrupts/gpe0F:       0	invalid
/sys/firmware/acpi/interrupts/gpe10:       0	invalid
/sys/firmware/acpi/interrupts/gpe11:       0	invalid
/sys/firmware/acpi/interrupts/gpe12:       0	invalid
/sys/firmware/acpi/interrupts/gpe13:       0	invalid
/sys/firmware/acpi/interrupts/gpe14:       0	invalid
/sys/firmware/acpi/interrupts/gpe15:       0	invalid
/sys/firmware/acpi/interrupts/gpe16:       0	invalid
/sys/firmware/acpi/interrupts/gpe17:       0	invalid
/sys/firmware/acpi/interrupts/gpe18:       0	enabled
/sys/firmware/acpi/interrupts/gpe19:       0	invalid
/sys/firmware/acpi/interrupts/gpe1A:       0	invalid
/sys/firmware/acpi/interrupts/gpe1B:       0	invalid
/sys/firmware/acpi/interrupts/gpe1C:       0	invalid
/sys/firmware/acpi/interrupts/gpe1D:       0	invalid
/sys/firmware/acpi/interrupts/gpe1E:       0	invalid
/sys/firmware/acpi/interrupts/gpe1F:       0	invalid
/sys/firmware/acpi/interrupts/gpe_all:       0
/sys/firmware/acpi/interrupts/sci:       0
/sys/firmware/acpi/interrupts/sci_not:       1

Note, this is a desktop not a laptop.

I don't see a acpidump utility installed, nor do I see anywhere in
fedora 12 that would install it.

After reverting the one patch, everything seemed to work (although it
still crashes here and there, but I think that's a video driver bug).

I'll help investigate this if you want. But it may take time. The box
does belong to my wife and I need to wait for her to finish with it
before I can take a look ;-) Well, I can ssh in, but to try patches or
anything else requiring reboots, will have to wait till she's off of it.


-- Steve


