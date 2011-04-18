Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1DRVgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 17:36:42 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49877 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494Ab1DRVgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 17:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=M9IjK5o59/oZuw0mzW9gySXrcUERy5A0A/OQmLaTaPEIcoGflAgnSJK8mvY+4jCod5
         cjRv1ClCaiREiVF1cWvBsdGeByeYKYThDz3vWxA2aqn397Dg/BmgxFoE+DLAzZgYV1EI
         VUJ9sn+ZsCrejWkkRfj/GxnjCE5dncNZyy/40=
MIME-Version: 1.0
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024C8B3CD6@dbde02.ent.ti.com>
References: <cover.1302031487.git.bengardiner@nanometrics.ca>
	<B85A65D85D7EB246BE421B3FB0FBB593024C8B3CD6@dbde02.ent.ti.com>
Date: Mon, 18 Apr 2011 17:36:38 -0400
Message-ID: <BANLkTi=7DbMrbo0nQU+268LC_2258q-_DA@mail.gmail.com>
Subject: Re: [PATCH 0/6] i2c-davinci gpio pulsed SCL recovery with ICPFUNC
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        "Griffis, Brad" <bgriffis@ti.com>,
        Jon Povey <jon.povey@racelogic.co.uk>,
        Philby John <pjohn@in.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

Thank you for reviewing the series.

On Wed, Apr 13, 2011 at 12:25 PM, Nori, Sekhar <nsekhar@ti.com> wrote:
> Hi Ben,
>
> On Wed, Apr 06, 2011 at 03:08:03, Ben Gardiner wrote:
>> This series for the i2c-davinci driver implements both a register dump and
>> a pulsed-SCL recovery of the bus on those controllers that have ICPFUNC
>> registers which is, so far, the da850 and da830 based platforms.
>>
>> I2C "controller timed out" messages were being observed by both myself on the
>> da850evm and Bastian Ruppert on some custom da850 hardware [1]. Originally I
>> thought it was the existing pulse-SCL routine but was quickly proven wrong; my
>> apologies to John Povey and Philby John for jumping to conclusions.
>>
>> A discussion was spawned on the e2e forums [2] where Brad Griffis was
>> instrumental in the development of the recovery routine proposed by this patch
>> series. It was pointed out by him that the da850's i2c controller has the
>> ability to control the SDA and SCL pins as GPIOS through its ICPFUNC registers.
>> The recovery routine implemented by the patch series toggles the SCL pin and
>> reads the SDA state using the ICPFUNC registers.
>
> [...]
>
>>
>> When creating this series I noticed that there are obvious similarities between
>> the existing recovery routine implemented by Philby John and John Povey and the
>> recovery routine proposed in this series. Testing was performed using the
>> ICPFUNC regsiters to toggle SCL as prescribed by the existing routine and it
>> was found that the recovery did not work. The method described initially by Brad
>> Griffis had the initial state of SCL high and delays of 5us with a maximum
> of
>> 8 pulses with a check of SDA each time as compared to the existing routine with
>> undetermined SCL initial state, 20us delays and a maximum of 8 pulses. I tested
>
> I wonder how these values (5us or 20us) are derived. The document[1]
> referred to in the existing code says that "the master should send
> 9 clock pulses". I think 5us suggested by Brad assumes a 100KHz
> bus. If that is so, this number should be derived out of the bus_freq
> platform data.
>
> [1] http://www.nxp.com/documents/user_manual/UM10204.pdf

I'm not sure how the 20us in the existing method was derived -- I
wonder if Philby John or John Povey could comment? I agree that the
5us suggested by Brad assumes a 100KHz bus -- I could certainly derive
this delay from the bus_freq platform data for the new recovery
procedure since board-da850-evm.c sets bus_freq to 100 kHz.

But I was apprehensive to do so for the existing recovery procedure
since the two (in-tree) boards that are assigning the scl_pin member
are dm355 and dm644x which assign bus_freq values of 400kHz and 20kHz,
respectively. These would require delays of 1.25us and 25us,
respectively; neither of which is the hard-coded 20us. To complicate
matters further, dm644x (20kHz) sets bus_delay to 100us with a comment
that "the msp430 uses a slow bitbanged i2c implementation [...] which
requires 100us of idle after i2c writes [...]." If I derived the
clock-pulse delays from bus_freq the dm644x would probably still work
but if the clock-pulse width was at all important for dm355 then the
recovery procedure could fail there. I don't want to introduce
instabilities into other platforms.

>> and found that if I changed the initial state of SCL or the number of pulses
>> (Bastian had success with 16) that the recovery did not occur as expected;
>
> Was this testing done with the original PinMuxed GPIO based approach or with
> the new internal GPIO based approach?

This testing was performed using the 'new' ICPFUNC-based GPIO toggling.

>> furthermore Brad pointed out that it was important to check the state of SDA
>> after each pulse to see if the slave had released the line. Indeed, adding the
>> check of SDA resulted in a quicker recovery. On my da850evm, at least, the
>> recovery took only one SCL pulse every time.
>
> Yes, the document referred to above suggests this too.
>
> I guess the existing recovery mechanism and the new ICPFUNC
> based approach shouldn't be functionally different - correct?

At the outset I had hoped so too; but what we have in the result is a
method proven to work on the problem hardware here that is now
different than the existing method.

> In that case, it would really be worthwhile to fix the existing
> recovery method as well.
>
>>
>> It would be nice to consolidate the two recovery routines and -- since they
>> are gpio-based -- put the shared recovery routine in i2c-algo-bit so it can
>> also be used by bitbanging i2c masters. I did not undertake the former because
>> I don't have access to the hardware on which the existing recovery routine was
>> tested.
>
> I think if you see issues with existing code, you should just
> go ahead and fix. AFAICT, the existing approach should have
> worked for you. You can test on your hardware and those with
> other hardware can test your patches as well and send their
> acks.

Ok -- I did not want to break behaviour on other hardware with my
changes --but I respect your expert opinion coming from the experience
you have in merging patches as a kernel mach maintainer. I will
re-spin (not immeadiately -- I don't expect to be able to return to
development of this patch series for another couple weeks) another
version, this time replacing the existing recovery procedure with the
tested method here. Also, allowing the individual da8xx boards to
specify whether they enable the recovery procedure as you requested in
reviewing 6/6 of this series. I would still prefer to do the
extraction to i2c-algo-bit in a separate series.

Best Regards,
Ben Gardiner

---
Nanometrics Inc.
http://www.nanometrics.ca
