Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab0IAHU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:20:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41793 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab0IAHU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:20:27 -0400
Date: Wed, 1 Sep 2010 09:20:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, peterz@infradead.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [lockup detector] sync touch_*_watchdog back to old
 semantics
Message-ID: <20100901072016.GA27065@elte.hu>
References: <1283310009-22168-1-git-send-email-dzickus@redhat.com>
 <1283310009-22168-2-git-send-email-dzickus@redhat.com>
 <20100901053055.GA14316@elte.hu>
 <AANLkTim_O0CXMCv_qVDKOP72=VC63eoZuvpKWm=mme7k@mail.gmail.com>
 <AANLkTim1s=O6+OEvwLsaxbkpfyQk-Mypr5wE7H4fh9V0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim1s=O6+OEvwLsaxbkpfyQk-Mypr5wE7H4fh9V0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On 9/1/10, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On 9/1/10, Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >> * Don Zickus <dzickus@redhat.com> wrote:
> >>
> >>>  void touch_nmi_watchdog(void)
> >>>  {
> >>> -	__get_cpu_var(watchdog_nmi_touch) = true;
> >>> +	if (watchdog_enabled) {
> >>> +		unsigned cpu;
> >>> +
> >>> +		for_each_present_cpu(cpu) {
> >>> +			if (per_cpu(watchdog_nmi_touch, cpu) != true)
> >>> +				per_cpu(watchdog_nmi_touch, cpu) = true;
> >>> +		}
> >>
> >> Hm, this is going to be a scalability nightmare with lots of CPUs. Not
> >> only do we have a nr_cpus loop, but we touch per-cpu areas of _other_
> >> CPUs - a big scalability nono.
> >>
> >> Why do we need to do this? We never needed to touch other CPU's NMI
> >> lockup accounting data areas - why has this changed? The changelog does
> >> not explain this.
> >>
> >> Thanks,
> >>
> >> 	Ingo
> >>
> > I believe this came from old nmi watchdog code where it might be
> > useful when nmi watchdog activated via io-apic. I'm trying to figure
> > out if we really need it still.
>
> Well, we can't drop it or make per-cpu specific, for example we need 
> it in case of panic with watchdog enabled and panic timeout set, or 
> boot delay set and etc. Seems same applies to printk_delay. Hmm...

Ok - can you cite the old watchdog code, did it really do a nr_cpus 
loop?

Thanks,

	Ingo
