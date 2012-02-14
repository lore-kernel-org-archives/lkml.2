Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab2BNPdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:33:05 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:18384 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab2BNPdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:33:01 -0500
Date: Tue, 14 Feb 2012 10:29:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: ftrace_enabled set to 1 on bootup, slow downs with
 CONFIG_FUNCTION_TRACER in virt environments?
Message-ID: <20120214152955.GA17671@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F3A7EAA.0032,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I was running some benchmarks (netserver/netperf) where the init script just launched
the netserver and nothing else and was concerned to see the performance not up to par.
This was an HVM guest running with PV drivers.

If I compile the kernel without CONFIG_FUNCTION_TRACER it is much better - but it was
my understanding that the tracing code does not impact the machine unless it is enabled.
And when I inserted a bunch of print_dump_bytes I do see instructions such as
e8 6a 90 60 e1 get replaced with 66 66 66 90 so I see the the instructions getting
patched over.

To get a better feel for this I tried this on baremetal, and (this is going
to sound a bit round-about way, but please bear with me), I was working on making
the pte_flags be paravirt (so it is a function instead of being a macro) and noticed
that on on an AMD A8-3850, with a CONFIG_PARAVIRT and CONFIG_FUNCTION_TRACER and
running kernelbench it would run slower than without CONFIG_FUNCTION_TRACER.

I am not really sure what the problem is, but based on those experiments
four things come to my mind:
 - Lots of nops and we choke the CPU instruction decoder with 20-30 bytes
   of 'nop', so the CPU is stalling waiting for some real instructions.
 - The compiler has choosen to compile most of the paravirt instructions as
   functions making the call to mcount (which gets patched over), but the
   end result is that we have an extra 'call' in the chain.
 - Somehow the low-level para-virt (like the assembler ones) calls don't get
   patched over and still end up calling mcount? (but I really doubt that is the
   case - but you never know).
 - Something else?

My thought was to crash the kernel as it is up and running and look at the
diassembled core to see what the instructions end up looking to get a further feel
for this.  But before I go with this are there some other ideas of what I should look
for?

Thanks!

Note: The "working on making the pte_flags be paravirt" patches are here:
http://darnok.org/results/baseline_pte_flags_pte_attrs/ if you are interested.
