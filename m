Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab1CaLuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 07:50:18 -0400
Received: from relay2.sgi.com ([192.48.179.30]:60970 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751908Ab1CaLuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 07:50:17 -0400
Date: Thu, 31 Mar 2011 06:50:14 -0500
From: Robin Holt <holt@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC 2/2] Make x86 calibrate_delay run in parallel.
Message-ID: <20110331115014.GF24046@sgi.com>
References: <20101215015840.390204279@gulag1.americas.sgi.com>
 <20101215015849.051095242@gulag1.americas.sgi.com>
 <AANLkTinoctZFKo4wBmrrdFggnjSj74QfqvEpz59sW15x@mail.gmail.com>
 <20110331065036.GC5938@elte.hu>
 <20110331065805.GG5938@elte.hu>
 <20110331093723.GE24046@sgi.com>
 <20110331095705.GA23319@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110331095705.GA23319@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 11:57:05AM +0200, Ingo Molnar wrote:
> 
> * Robin Holt <holt@sgi.com> wrote:
> 
> > On Thu, Mar 31, 2011 at 08:58:05AM +0200, Ingo Molnar wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Yinghai Lu <yinghai@kernel.org> wrote:
> > > > 
> > > > > On Tue, Dec 14, 2010 at 5:58 PM,  <Robin@sgi.com> wrote:
> > > > > >
> > > > > > On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
> > > > > > up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
> > > > > > Andi Kleen suggested we rework the calibrate_delay calls to run in
> > > > > > parallel.  With that code in place, a test boot of the same machine took
> > > > > > 61 seconds to bring the cups up.  I am not sure how we beat the lpj=
> > > > > > case, but it did outperform.
> > > > > >
> > > > > > One thing to note is the total BogoMIPS value is also consistently higher.
> > > > > > I am wondering if this is an effect with the cores being in performance
> > > > > > mode.  I did notice that the parallel calibrate_delay calls did cause the
> > > > > > fans on the machine to ramp up to full speed where the normal sequential
> > > > > > calls did not cause them to budge at all.
> > > > > 
> > > > > please check attached patch, that could calibrate correctly.
> > > > > 
> > > > > Thanks
> > > > > 
> > > > > Yinghai
> > > > 
> > > > > [PATCH -v2] x86: Make calibrate_delay run in parallel.
> > > > > 
> > > > > On a 4096 cpu machine, we noticed that 318 seconds were taken for bringing
> > > > > up the cpus.  By specifying lpj=<value>, we reduced that to 75 seconds.
> > > > > Andi Kleen suggested we rework the calibrate_delay calls to run in
> > > > > parallel.
> > > > 
> > > > The risk wit that suggestion is that it will spectacularly miscalibrate on 
> > > > hyperthreading systems.
> > 
> > I am not trying to be argumentative.  I never got an understanding of
> > what was going wrong with that earlier patch and am hoping for some
> > understanding now.
> 
> Well, if calibrate_delay() calls run in parallel then different hyperthreads 
> will impact each other.
> 
> > Why does it spectacularly miscalibrate?  Can anything be done to correct
> > that miscalibration?  Doesn't this patch indicate another problem with
> > the calibration for hotplug cpus?  Isn't there already a problem if
> > you boot a cpu normally, then hot-remove a hyperthread of a cpu, run a
> > userland task which fully loads up all the cores on that socket, then
> > hot-add that hyperthread back in?  If the lpj value is that volatile,
> > what value does it really have?
> 
> The typical CPU hotplug usecase is suspend/resume, where we bring down the CPUs 
> in a more or less controlled manner.
> 
> Yes, you could achieve something similar by frobbing /sys/*/*/online but that's 
> a big difference to *always* running the calibration loops in parallel.
> 
> I'd argue for the opposite direction: only calibrate a physical CPU once per 
> CPU per bootup - this would also make CPU hotplug faster btw.
> 
> ( Virtual CPUs (KVM, etc.) need a recalibration per bringup, because the new 
>   CPU could be running on different hardware - but that's a detail: 4096 UV
>   CPUs are not in this category. )
> 
> Really, there's no good reason why every CPU should be calibrated on a system 
> running identical CPUs, right? Mixed-frequency systems are rather elusive on 
> x86.

I had argued initially for calibrating a single core per socket
earlier.  I do not remember who indicated that would not work, but I
do recall something about some AMD hardware possibly not having the
same frequency for all cores.  Do know any details about any offering
where the individual cores on a socket can have different lpj values
(other than calculation noise)?

Robin
