Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1EEHSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 03:18:24 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55584 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1EEHSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 03:18:23 -0400
Date: Thu, 5 May 2011 09:17:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86, mce: Have MCE persistent event off by default
 for now
Message-ID: <20110505071747.GA3185@aftab>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-5-git-send-email-bp@amd64.org>
 <20110503064505.GF7751@elte.hu>
 <20110503072302.GC18979@aftab>
 <987664A83D2D224EAE907B061CE93D5301C53670E0@orsmsx505.amr.corp.intel.com>
 <20110504065843.GC20828@elte.hu>
 <987664A83D2D224EAE907B061CE93D5301C53C9B31@orsmsx505.amr.corp.intel.com>
 <20110505063951.GB28015@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505063951.GB28015@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 02:39:51AM -0400, Ingo Molnar wrote:
> printk events are a compatibility wrapper to allow RAS functionality to have 
> easy and unified access to all system events that matter. The structure of 
> printk events is obviously the log level plus a free-form ASCII string, 
> something like:
> 
>  1- the printk timestamp

Yeah, we want here the timestamp when the event happened.

>  2- the log level of the kernel when the message was generated
>  3- the log level of the message
>  4- the printk message itself, as a free-form string
> 
> > [...] a big issue when you have some heavy duty infrastructure trying to 
> > parse and consume these messages.  We should really consider such stuff a 
> > user visible ABI, and thus not subject to random breakage - which is a 
> > radical departure from our current attitude to printk().
> 
> Indeed, turning printk into an ABI clearly wont fly upstream although i'd 
> expect upstream to *care more* about good printk messages if the RAS daemon 
> starts making good use of it. Any printk message that turns out to be useful 
> can be turned into an ABI by defining a proper structured event out of it, via 
> TRACE_EVENT() et al.

Actually let's have the RAS printk's as TRACE_EVENT's from the start
- it's not like we're going to convert every printk call into a RAS
printk event. We only want relevant ones from traps.c, maybe some power
management events, fs, maybe some critical security stuff, etc.

> This does not mean that it's not *useful* to allow the streaming of all print 
> evnts to the RAS daemon. They are available, they get generated and they 
> clearly look useful to me, and it will be useful when a sysadmin looks at the 
> RAS log to figure out an incident.
> 
> Consider an example of two logs, one with just pure RAS events, the other with 
> printk lines (and user-space events, see my patch a couple of months ago that 
> allows event injection for critical user-space events as well) embedded:
> 
> The MCE-only log:
> 
>  Subsystem  |  Time           | event
>  ------------------------------------------------------------------
>  [MCE]         May 5 05:23:56   correctable MCE event on memory bank X
>  [MCE]         May 5 06:19:59   correctable MCE event on memory bank X
> 
> Versus a broader, unified log (all events come via the perf event mmap 
> ring-buffer, ordered properly and delivered quickly and transparently):

Yes, especially since we can get it out to userspace even faster than
printk :).

>  Subsystem  |  Time           | event
>  ------------------------------------------------------------------
>  [MCE]         May 5 05:23:56   correctable MCE event on memory bank X
>  [printk]      May 5 06:19:53   thermal trip triggered
>  [MCE]         May 5 06:19:59   correctable MCE event on memory bank X
>  [fault]       May 5 06:20:00   delivered SIGSEGV to task 'httpd' 
>  [httpd]       May 5 06:20:00   unexpected restart
>  [printk]      May 5 06:20:01   EXT4-fs (9345): group descriptors corrupted!

   ^^ I wouldn't even call it "printk" since this is obviously [fs].
   The printk event should have a field that says from which subsys the
   printk comes from and thus make it so integrated that it is even
   invisible :).

And
>  [printk]      May 5 06:19:53   thermal trip triggered

could be

>  [pm]      May 5 06:19:53   thermal trip triggered

for power management.

> As a sysadmin i might misinterpret the first one as a low and still acceptable 
> rate of correctable MCE errors: roughly one event per hour.
> 
> I'd take the second log *much* more seriously and would prioritize this 
> incident as it likely indicates bad (overheating?) hardware and user-visible 
> crashes and possible uncorrected data corruption.
> 
> Note that we made use of printk events, fault events and user-space injected 
> events as well, in addition to the primary MCE events.
> 
> And yes, some of the printk events, if they are relied on frequently and 
> programmatically, will be turned into proper events - and this process is 
> helped by printk events.
> 
> As i understood it, being useful in such a way is one of the main goals of the 
> new RAS daemon.

Yep, this is absolutely what we want to do - we want to have RAS
events not only coupled with hardware events but actually collect all
_relevant_ events into a common RAS log that is very lightweight and
doesn't rely on printk. It can, _however_, be turned into printk's (and
it should) if no daemon is running. And yes, we can have special tags
like "[[..]]" or whatever to be able to grep it out even from dmesg.

Cool,
thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
