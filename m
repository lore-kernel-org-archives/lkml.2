Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab1CaJ3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:29:49 -0400
Received: from relay3.sgi.com ([192.48.152.1]:58505 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933310Ab1CaJ3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:29:47 -0400
Date: Thu, 31 Mar 2011 04:29:45 -0500
From: Robin Holt <holt@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Robin Holt <holt@sgi.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 2/2] Make x86 calibrate_delay run in parallel.
Message-ID: <20110331092945.GD24046@sgi.com>
References: <20101215015840.390204279@gulag1.americas.sgi.com>
 <20101215015849.051095242@gulag1.americas.sgi.com>
 <AANLkTinoctZFKo4wBmrrdFggnjSj74QfqvEpz59sW15x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinoctZFKo4wBmrrdFggnjSj74QfqvEpz59sW15x@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 09:46:46PM -0700, Yinghai Lu wrote:
> On Tue, Dec 14, 2010 at 5:58 PM,  <Robin@sgi.com> wrote:
> >
> > On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
> > up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
> > Andi Kleen suggested we rework the calibrate_delay calls to run in
> > parallel.  With that code in place, a test boot of the same machine took
> > 61 seconds to bring the cups up.  I am not sure how we beat the lpj=
> > case, but it did outperform.
> >
> > One thing to note is the total BogoMIPS value is also consistently higher.
> > I am wondering if this is an effect with the cores being in performance
> > mode.  I did notice that the parallel calibrate_delay calls did cause the
> > fans on the machine to ramp up to full speed where the normal sequential
> > calls did not cause them to budge at all.
> 
> please check attached patch, that could calibrate correctly.
> 
> Thanks
> 
> Yinghai

> [PATCH -v2] x86: Make calibrate_delay run in parallel.
> 
> On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
> up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
> Andi Kleen suggested we rework the calibrate_delay calls to run in
> parallel.
> 
> -v2: from Yinghai
>      two path: one for initial boot cpus. and one for hotplug cpus
> 	initial path:
> 	  after all cpu boot up, enter idle, use smp_call_function_many
> 	  let every ap call __calibrate_delay.
>           We can not put that calibrate_delay after local_irq_enable
>           in start_secondary(), at that time that cpu could be involed
> 	  with perf_event with nmi_watchdog enabling. that will cause
> 	  strange calibrating result.

If I understand your description above, that would cause the cpu's lpj
value to be too low if they did take an NMI, correct?  The problem I was
seeing was additional cores on the socket got a value much higher than
the first core.  I don't recall exact values.  It would be something
like the second through fifth cores all got larger than the first, then
the sixth stayed the same as the fifth, and seventh was slightly less
then the sixth and finally the eigth was lower than the seventh.

I don't see how this patch would affect that.  Has this been tested on
a multi-core intel cpu?  I will try to test it today when I get to the
office.

Additionally, it takes the bogomips value from being part of an output
line and makes it a separate line.  On a 4096 cpu system, that will mean
many additional lines of output.  In the past, we have seen that will
cause a considerable slowdown as time is spent printing.  Fortunately,
that is likely not going to slow things down as a secondary cpu will
likely be doing that work while the boot cpu is allowed to continue with
the boot.  Is there really a value for a normal boot to have this output?
Can we remove the individual lines of output and just print the system
BogoMips value?

Thanks,
Robin
