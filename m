Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab2EVNFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:05:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:48238 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2EVNFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:05:11 -0400
Date: Tue, 22 May 2012 15:05:43 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory
 controller events
Message-ID: <20120522130543.GD18878@aftab.osrc.amd.com>
References: <4FB6866E.7090503@redhat.com>
 <20120518185258.GE20215@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F1A33@ORSMSX104.amr.corp.intel.com>
 <20120518211211.GA26464@aftab.osrc.amd.com>
 <20120519092618.GC29991@aftab.osrc.amd.com>
 <4FBB67ED.70606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBB67ED.70606@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 07:18:21AM -0300, Mauro Carvalho Chehab wrote:
> Em 22-05-2012 06:28, Borislav Petkov escreveu:
> > On Tue, May 22, 2012 at 12:04:48AM -0300, Mauro Carvalho Chehab wrote:
> >> +TRACE_EVENT(mc_event,
> >> +
> >> +	TP_PROTO(const unsigned int err_type,
> >> +		 const unsigned int mc_index,
> >> +		 const char *error_msg,
> >> +		 const char *label,
> >> +		 int layer0,
> >> +		 int layer1,
> >> +		 int layer2,
> > 
> > Those are EDAC-internal layer representation, why are they exported to
> > userspace? Userspace needs only the location and label AFAICT.
> 
> Those are not the EDAC internal layer representation. They're the physical
> location of the DIMM or rank.

Ok, you've replaced the location char * with the layers.

> > If you export them to userspace, they need much more meaningful names -
> > layer{0,1,2} mean nothing outside of the kernel.
> 
> Ok. Do you have a better naming suggestion?
> 
> What about layer0_pos, layer1_pos, layer2_pos?

Actually, I'd like them to be called channel/rank/row or something. Having them
numbered I don't know which layer is the top layer (channel/branch/slot)
and the lowest (rank/csrow/...)

Maybe top_layer, middle_layer, lowest_layer? Or something like that...

> > 
> >> +		 unsigned long pfn,
> >> +		 unsigned long offset,
> >> +		 unsigned long grain,
> > 
> > Why aren't those a single 'unsigned long address' since they all are
> > computed from it?
> 
> We can merge pfn and offset into "unsigned long address".

Just have a single "unsigned long address" field and userspace can pick
out the stuff it needs from it.

> With regards to the grain, it is an address mask, written with a "short" way.
> So, grain 32, for example, means:
> 	ffff:ffff:ffff:fffe0
> 
> As the current EDAC API exports it as grain, IMO, it is better to keep it as-is,
> but it won't be hard to do:
> 	unsigned long mask = ((unsigned long) -1) && (1 - grain)
> 
> What do you think?

Why are we even exporting grain actually with each tracepoint
invocation? This is the granularity of reported error in bytes, and it,
as such, is statically assigned to a value in each driver. Userspace can
certainly figure out that value in a different way.

But the more important question is: does the grain help us when handling
the error info in userspace?

It tells us that at this physical address with "grain" granularity we
had an error. So?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
