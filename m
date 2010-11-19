Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab0KSP3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:29:30 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:26840 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754851Ab0KSP33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:29:29 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: vUw4ZB8VM1lyQls8vHFBrm43JzdHdTh45dCqbuc69EbqyV2
 fvOr2xQYa4QDI29x8pj63Hp1TmcRC1ZdaLGZbHIoCRQu3A0MiThwu4SfMiT0
 dOdMqzUdyZk7IC9zqGmy7z1_20i25PzsV58.9z5bM2wX2mcqbv5CqiGUJMVG
 jaWfoPdwxmZ8Q7cVboxTeMIvk6SvIW0DWW.toNl937ks8Ji9b2DcXZwy7nLx
 C9iZXYoG8MAI-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 19 Nov 2010 09:29:25 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Shaohua Li <shaohua.li@intel.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] set_pgdat_percpu_threshold() don't use
 for_each_online_cpu
In-Reply-To: <20101116160720.5244ea22.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1011190923370.32655@router.home>
References: <1288169256-7174-2-git-send-email-mel@csn.ul.ie> <20101028100920.5d4ce413.kamezawa.hiroyu@jp.fujitsu.com> <20101114163727.BEE0.A69D9226@jp.fujitsu.com> <20101116160720.5244ea22.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010, Andrew Morton wrote:

> > Following patch use (2) beucase removing get_online_cpus() makes good
> > side effect. It reduce potentially cpu-hotplug vs memory-shortage deadlock
> > risk.
>
> Well.  Being able to run for_each_online_cpu() is a pretty low-level
> and fundamental thing.  It's something we're likely to want to do more
> and more of as time passes.  It seems a bad thing to tell ourselves
> that we cannot use it in reclaim context.  That blots out large chunks
> of filesystem and IO-layer code as well!

The online map can change if no locks were taken. Thus it
becomes something difficult to do in some code paths and overhead
increases significantly.

> >  		threshold = (*calculate_pressure)(zone);
> > -		for_each_online_cpu(cpu)
> > +		for_each_possible_cpu(cpu)
> >  			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
> >  							= threshold;
> >  	}
> > -	put_online_cpus();
> >  }
>
> That's a pretty sad change IMO, especially of num_possible_cpus is much
> larger than num_online_cpus.

num_possible_cpus should only be higher if the arch code has detected
that the system has the ability to physically online and offline cpus.
I have never actually seen such a system. Heard rumors from Fujitsu that
they have something.

Maybe the virtualization people also need this? Otherwise cpu
online/offline is useful mainly to debug the cpu offline/online handling
in various subsystems which is unsurprisingly often buggy given the rarity
of encountering such hardware.

> What do we need to do to make get_online_cpus() safe to use in reclaim
> context?  (And in kswapd context, if that's really equivalent to
> "reclaim context").

I think its not worth the effort.

