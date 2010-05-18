Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab0ERTfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:35:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36761 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab0ERTfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:35:15 -0400
Date: Tue, 18 May 2010 21:34:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Joe Perches <joe@perches.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       "Young, Brent" <brent.young@intel.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100518193437.GC30936@elte.hu>
References: <4BF18995.6070008@redhat.com>
 <4BF2392A.9040409@jp.fujitsu.com>
 <4BF2C3D1.10009@redhat.com>
 <1274204560.17703.82.camel@Joe-Laptop.home>
 <20100518185305.GA23921@elte.hu>
 <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
 <20100518191802.GG25224@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518191802.GG25224@aftab>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> Well, we have a trace_mce_record tracepoint in the 
> mcheck code which calls all the necessary callbacks when 
> an mcheck occurs. For the time being, the idea is to use 
> the mce.c ring buffer for early mchecks and copy them to 
> the regular ftrace per-cpu buffer after the last has 
> been initialized. Later, we could switch to a another 
> early bootmem buffer if there's need to.

The end result would be even simpler by one more step: 
with persistent events we just use them and dont need the 
mce.c ringbuffer at all. (getting rid of that complication 
is one of the code cleanliness benefits i see in this move 
as a x86 maintainer - beyond the obvious generalization 
and unification benefits.)

> Also, we want to have a userspace daemon that reads out 
> the mces from the trace buffer and does further 
> processing like thresholding etc in userspace.
> 
> Concerning critical errors, there we bypass the perf 
> subsystem and execute the smallest amount of code 
> possible while trying to shutdown gracefully if the 
> error type allows that.

Yeah. Each perf_event can have arbitrary callbacks with 
add-on (or critical) functionality. We would activate the 
event(s) during bootup and it would do its thing from that 
point on: critical functionality gets a direct path via 
the callback, and every other event that survives goes via 
the regular perf output channels, to one (or more) 
consumers/subscribers of these events.

	Ingo
