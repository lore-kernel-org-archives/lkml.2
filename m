Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2FAJKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:10:03 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:47495 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2FAJKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:10:00 -0400
Date: Fri, 1 Jun 2012 11:10:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120601091026.GC20959@aftab.osrc.amd.com>
References: <20120531145416.GI14515@aftab.osrc.amd.com>
 <4FC787BF.3020006@redhat.com>
 <20120531151408.GJ14515@aftab.osrc.amd.com>
 <4FC798E2.4000402@redhat.com>
 <20120531171337.GN14515@aftab.osrc.amd.com>
 <1338492772.13348.388.camel@gandalf.stny.rr.com>
 <20120531194207.GC16998@aftab.osrc.amd.com>
 <1338495092.13348.419.camel@gandalf.stny.rr.com>
 <20120531201824.GD16998@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6DE2@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F6DE2@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 08:52:21PM +0000, Luck, Tony wrote:
> > It could be very quiet (i.e., machine runs with no errors) and it could
> > have bursts where it reports a large number of errors back-to-back
> > depending on access patterns, DIMM health, temperature, sea level and at
> > least a bunch more factors.
> 
> Yes - the normal case is a few errors from stray neutrons ...  perhaps
> a few per month, maybe on a very big system a few per hour.  When something
> breaks, especially if it affects a wide range of memory addresses, then
> you will see a storm of errors.

IOW, when the sh*t hits the fan :-)

> > So I can imagine buffers filling up suddenly and fast, and userspace
> > having hard time consuming them in a timely manner.
> 
> But I'm wondering what agent is going to be reporting all these
> errors.  Intel has CMCI - so you can get a storm of interrupts
> which would each generate a trace record ... but we are working
> on a patch to turn off CMCI if a storm is detected.

Yeah, about that. What are you guys doing about losing CECCs when
throttling is on, I'm assuming there's no way around it?

> AMD doesn't have CMCI, so errors just report from polling

It does, look at <arch/x86/kernel/cpu/mcheck/mce_amd.c> That's the error
thresholding. We were talking about having an APIC interrupt fire at
_every_ CECC but I don't know/haven't tested how the software would
behave in such cases where the hw spits out an overwhelming amount of
errors.

> - and we have a
> maximum poll rate which is quite low by trace standards (even
> when multiplied by NR_CPUS).
> 
> Will EDAC drivers loop over some chipset registers blasting
> out huge numbers of trace records ... that seems just as bad
> for system throughput as a CMCI storm. And just as useless.

Why useless?

I don't know but we need to be as slim as possible on the reporting side
for future use cases like that.

Also, we probably want to proactively do something about such storms
like offline pages or disable some hardware components so that they
subside.

Switching to polling mode IMHO only cures the symptom but not the
underlying cause.

> General principle: If there are very few errors happening then it is
> important to log every single one of them.

Absolutely.

> If there are so many that we can't keep up, then we must sample at
> some level, and we might as well do that at generation point.

Yes, and then take action to recover and stop the storm.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
