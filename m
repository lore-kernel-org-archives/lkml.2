Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1CaKqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:46:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55885 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab1CaKqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:46:20 -0400
Date: Thu, 31 Mar 2011 12:46:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Robin Holt <holt@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 2/2] Make x86 calibrate_delay run in parallel.
Message-ID: <20110331104601.GA8577@elte.hu>
References: <20101215015840.390204279@gulag1.americas.sgi.com>
 <20101215015849.051095242@gulag1.americas.sgi.com>
 <AANLkTinoctZFKo4wBmrrdFggnjSj74QfqvEpz59sW15x@mail.gmail.com>
 <20110331065036.GC5938@elte.hu>
 <20110331065805.GG5938@elte.hu>
 <20110331093723.GE24046@sgi.com>
 <20110331095705.GA23319@elte.hu>
 <4D9457BF.1040601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9457BF.1040601@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Avi Kivity <avi@redhat.com> wrote:

> On 03/31/2011 11:57 AM, Ingo Molnar wrote:
> >>
> >>  I am not trying to be argumentative.  I never got an understanding of
> >>  what was going wrong with that earlier patch and am hoping for some
> >>  understanding now.
> >
> > Well, if calibrate_delay() calls run in parallel then different 
> > hyperthreads will impact each other.
> 
> It's different but not more wrong.  If delay() later runs on a thread whose 
> sibling is busy, it will in fact give more accurate results.

No, it's actively wrong: because it makes the delay loop *run faster* when 
other siblings

I.e. this shortens udelay(X)s potentially, which is far more dangerous than the 
current conservative approach of potentially *lengthening* them.

> > Really, there's no good reason why every CPU should be calibrated on a 
> > system running identical CPUs, right? Mixed-frequency systems are rather 
> > elusive on x86.
> 
> Good point.  And udelay() users are probably not sensitive to accuracy anyway 
> (which changes with load and thermal conditions).

True with one important distinction: they are only sensitive to one fact, that 
the delay should not be *shorter* than specified. By shortening udelay() we 
essentially overclock the hardware's tolerances - not good.

Thanks,

	Ingo
