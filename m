Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0FXQPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 12:15:10 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:47322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0FXQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 12:15:08 -0400
Subject: Re: [rfc] Describe events in a structured way via sysfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Greg KH <greg@kroah.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100624093625.GA26931@elte.hu>
References: <20100520231229.GB8335@kroah.com>
	 <1274429038.1674.1684.camel@laptop> <20100521094053.GA4658@elte.hu>
	 <AANLkTimf1Z0N9cv2Pu2qTTUscn4utC37zOPelCbqQoPv@mail.gmail.com>
	 <1277110509.18390.28.camel@minggr.sh.intel.com>
	 <1277112858.3618.16.camel@jlt3.sipsolutions.net>
	 <1277187920.4467.3.camel@minggr.sh.intel.com>
	 <1277189971.3637.5.camel@jlt3.sipsolutions.net>
	 <1277191359.5025.4.camel@minggr.sh.intel.com>
	 <1277192007.3637.8.camel@jlt3.sipsolutions.net>
	 <20100624093625.GA26931@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Jun 2010 18:14:13 +0200
Message-ID: <1277396053.3870.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 11:36 +0200, Ingo Molnar wrote:

> That's probably best achieved via a TRACE_EVENT() variant, by passing in the 
> sysfs location.
> 
> It might even make sense to make this a part of TRACE_EVENT() itself and make 
> 'NULL' the current default, non-sysfs-enumerated behavior. That way we can 
> gradually (and non-intrusively) find all the right sysfs places for events.

No, this doesn't work. A lot of events are multi-instance. Say you have
an event for each USB device. This event would have to show up in many
places in sysfs, and each trace_foo() invocation needs to get the struct
device pointer, not just the TRACE_EVENT() definition. Additionally, to
create/destroy the sysfs pieces we need something like
init_trace_foo(dev) and destroy_trace_foo(dev) be called when the sysfs
points for the device should be created/destroyed.

The TRACE_EVENT() just defines the template, but such multi-instance
events really should be standardised in terms of their struct device (or
maybe kobject).

I think that needs some TRACE_DEVICE_EVENT macro that creates the
required inlines etc, and including the init/destroy that are called
when the event should show up in sysfs.

There's no way you can have the event show up in sysfs at the right spot
with _just_ a TRACE_EVENT macro, since at define time in the header file
you don't even have a valid struct device pointer.

johannes

