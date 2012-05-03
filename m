Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab2ECUFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab2ECUFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:05:37 -0400
Date: Thu, 3 May 2012 22:05:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, mingo@elte.hu
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] perf tool: Add pmu event alias support
Message-ID: <20120503200518.GC1671@m.brq.redhat.com>
References: <1335924440-11242-1-git-send-email-zheng.z.yan@intel.com>
 <1335924440-11242-10-git-send-email-zheng.z.yan@intel.com>
 <20120503105655.GB1671@m.brq.redhat.com>
 <1336044261.22523.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336044261.22523.11.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 01:24:21PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-03 at 12:56 +0200, Jiri Olsa wrote:
> > - in sysfs you would have directory with aliases (now called 'events')
> > - each alias is sysfs dir, with file attrs:
> >         file name = term name, file value = term value
> >   eg.:
> >         events/
> >                 CAS_COUNT_RD/
> >                         # files:
> >                         config  - value 1
> >                         config1 - value 2
> >                         mask    - value ... 
> 
> I'd prefer the thing Yan proposed (if the sysfs folks let us),
> 
> $foo/events/QHL_REQUEST_REMOTE_READS
> 
> with contents: "event=0x20,umask=0x4"
> 
> > this way it's also possible to add extra terms to existing alias
> > in command line if needed... might be handy
> > 
> That should always be possible, if you modify the parser to take things
> like:
> 
>   event=0x20,umask=0x4,event=0x21
> 
> and have latter values override earlier values, so it collapses into:
> 
>   umask=0x4,event=0x21
> 
> you can simply take whatever comes out of the event file and stick extra
> bits at the end.

I discussed this with Peter on irc, so I'll try to sum it up

we have following options so far:

   with event alias 'al' with definition 'config=1,config1=1,config2=2'

1) inside parse_events_add_pmu function
   once alias term is detected as part of event definition 'pmu/al/mod' we
   construct new event 'pmu/config=1,config1=1,config2=2/mod' and rerun the
   event parser on that

2) inside parse_events_add_pmu function 
   once alias term is detected as part of event definition 'pmu/al/mod' we
   replace that term with list of terms for that alias definition and run
   perf_pmu__config with this new term list

3) during bison/flex processing
   have option 2) embeded inside flex/bison rules. Once alias term
   is detected, insert the aliased terms directly to the list of terms,
   not replacing expos as in option 2.


- option 1 is currently implemented 
- options 2 and 3 requires the aliased config is loaded/parsed from pmu
  sysfs tree in form of terms list
- option 3 is a little fuzzy for me now on how to integrate this with
  flex/bison

My interest here is to go with option 2 or 3 if possible - preferrably 2 ;),
because I think it's better/cleaner to deal with terms in one place once they
are parsed - in parse_events_add_pmu function.

I think there's no need to re run the whole parser (option 1) when we
have the whole thing ready by adding just extra terms.

thoughts?

thanks,
jirka
