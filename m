Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab0EKOO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:14:59 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51411 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab0EKOO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:14:57 -0400
Date: Tue, 11 May 2010 16:15:11 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Lin Ming <ming.m.lin@intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
Message-ID: <20100511141511.GA14034@aftab>
References: <1273483623.15998.57.camel@minggr.sh.intel.com>
 <1273484401.5605.3333.camel@twins>
 <1273486313.15998.76.camel@minggr.sh.intel.com>
 <1273486708.5605.3342.camel@twins>
 <1273487195.15998.85.camel@minggr.sh.intel.com>
 <1273490824.5605.3379.camel@twins>
 <20100510114311.GA6449@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510114311.GA6449@elte.hu>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_bei_M=FCnchen=2C_Gesc?=
	=?iso-8859-1?Q?h=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuliano_Meroni=2C?=
	=?iso-8859-1?Q?_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_La?=
	=?iso-8859-1?Q?ndkreis_M=FCnchen=2C_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, May 10, 2010 at 01:43:11PM +0200

Hi all,

> Yeah, we really want a mechanism like this in place instead of continuing with 
> the somewhat ad-hoc extensions to the event enumeration space.
> 
> One detail: i think we want one more level. Instead of:
> 
>  /sys/devices/system/node/nodeN/node_events
>                                 node_events/event_source_id
>                                 node_events/local_misses
>                                            /local_hits
>                                            /remote_misses
>                                            /remote_hits
>                                            /...
> 
> We want the individual events to be a directory, containing the event_id:
> 
>  /sys/devices/system/node/nodeN/node_events
>                                 node_events/event_source_id
>                                 node_events/local_misses/event_id
>                                            /local_hits/event_id
>                                            /remote_misses/event_id
>                                            /remote_hits/event_id
>                                            /...
> 
> The reason is that we want to keep our options open to add more attributes to 
> individual events. (In fact extended attributes already exist for certain 
> event classes - such as the 'format' info for tracepoints.)

ok, what you guys have so far sounds ok, here's some more stuff
we should be considering when using the tracepoints (and their
representation in /sysfs or whatever) for error reporting.

All the error reporting is done using MCEs so the
MCE should be a raw per cpu event somewhere under
/sys/devices/system/cpu/cpuN/events/raw_cpu_events/ or whatever works for
you.

Another point I have is that MCEs don't need pmus so we should consider
having the ability to decouple events from pmus.

What you basically want to have is a tracepoint which is "persistent,"
as Ingo suggested earlier, and it buffers MCEs occurring at any time
into a ring buffer until a userspace daemon or similar sucks that data
out for processing (critical stuff is handled differently, of course).
And this should work on any x86 hw supporting MCA without hw perf
monitoring features.

Also, we might think in terms of using some of the MCE fields in /sysfs
for hardware error injection like EDAC does inject DRAM ECC errors but
this should be straight-forward using one attribute like

/sys/devices/system/cpu/cpuN/events/raw_cpu_events/mce/inject_ecc

or similar.

This is mostly what I can come up with now...


-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
