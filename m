Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab2AaMjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 07:39:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33217 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab2AaMjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 07:39:20 -0500
Date: Tue, 31 Jan 2012 13:39:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Maxime Coquelin <maxime.coquelin@stericsson.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Mel Gorman <mel@csn.ul.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Andrea GALLO <andrea.gallo@stericsson.com>,
        Vincent GUITTOT <vincent.guittot@stericsson.com>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFCv1 0/6] PASR: Partial Array Self-Refresh Framework
Message-ID: <20120131123903.GB4408@elte.hu>
References: <1327930436-10263-1-git-send-email-maxime.coquelin@stericsson.com>
 <20120130135341.GA3720@elte.hu>
 <4F26A701.3090006@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F26A701.3090006@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maxime Coquelin <maxime.coquelin@stericsson.com> wrote:

> Dear Ingo,
> 
> On 01/30/2012 02:53 PM, Ingo Molnar wrote:
> >* Maxime Coquelin<maxime.coquelin@stericsson.com>  wrote:
> >
> >>The role of this framework is to stop the refresh of unused
> >>memory to enhance DDR power consumption.
> >I'm wondering in what scenarios this is useful, and how
> >consistently it is useful.
> >
> >The primary concern I can see is that on most Linux systems with
> >an uptime more than a couple of minutes RAM gets used up by the
> >Linux page-cache:
> >
> >  $ uptime
> >   14:46:39 up 11 days,  2:04, 19 users,  load average: 0.11, 0.29, 0.80
> >  $ free
> >               total       used       free     shared    buffers     cached
> >  Mem:      12255096   12030152     224944          0     651560    6000452
> >  -/+ buffers/cache:    5378140    6876956
> >
> > Even mobile phones easily have days of uptime - quite often 
> > weeks of uptime. I'd expect the page-cache to fill up RAM on 
> > such systems.
> >
> > So how will this actually end up saving power consistently? 
> > Does it have to be combined with a VM policy that more 
> > aggressively flushes cached pages from the page-cache?
>
> You're right Ingo, page-cache fills up the RAM. This framework 
> is to be used in combination with a page-cache flush governor. 
> In the case of a mobile phone, we can imagine dropping the 
> cache when system's screen is off for a while, in order to 
> preserve user's experience.

Is this "page-cache flush governor" some existing code?
How does it work and does it need upstream patches?

> > A secondary concern is fragmentation: right now we fragment 
> > memory rather significantly.
>
> Yes, I think fragmentation is the main challenge. This is the 
> same problem faced for Memory Hotplug feature. The solution I 
> see is to add a significant Movable zone in the system and use 
> the Compaction feature from Mel Gorman. The problem of course 
> remains for the Normal zone.

Ok. I guess phones/appliances can generally live with a 
relatively large movable zone as they don't have serious
memory pressure issues.

> > For the Ux500 PASR driver you've implemented the section 
> > size is 64 MB. Do I interpret the code correctly in that a 
> > continuous, 64MB physical block of RAM has to be 100% free 
> > for us to be able to turn off refresh and power for this 
> > block of RAM?
>
> Current DDR (2Gb/4Gb dies) used in mobile platform have 64MB 
> banks and segments. This is the lower granularity for Partial 
> Array Self-refresh.

Ok, so do you see real, consistent power savings with a large 
movable zone, with page cache governor patches applied (assuming 
it's a kernel mechanism) and CONFIG_COMPACTION=y enabled, on an 
upstream kernel with all these patches applied?

Thanks,

	Ingo
