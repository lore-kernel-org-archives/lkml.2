Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2DKLTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 07:19:10 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:40258 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2DKLTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 07:19:08 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F8568A8.5060206@cam.ac.uk>
Date: Wed, 11 Apr 2012 12:19:04 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
References: <20120410131206.GB31551@sirena.org.uk> <20120410142501.6045c6c0@pyramind.ukuu.org.uk> <20120410133339.GK7499@opensource.wolfsonmicro.com> <20120410144235.1e05efd4@pyramind.ukuu.org.uk> <20120410140749.GL7499@opensource.wolfsonmicro.com> <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk> <20120410151943.GM7499@opensource.wolfsonmicro.com> <20120410175632.5c11c36e@pyramind.ukuu.org.uk> <20120410175846.GQ7499@opensource.wolfsonmicro.com> <20120411112411.11825eec@pyramind.ukuu.org.uk> <20120411103827.GH3163@opensource.wolfsonmicro.com> <4F856173.8000901@cam.ac.uk> <20120411121309.4b8f8e40@pyramind.ukuu.org.uk>
In-Reply-To: <20120411121309.4b8f8e40@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/11/2012 12:13 PM, Alan Cox wrote:
>>>> happily enough. IIO can use it from staging and IIO can migrate whenever.
>> IIO is about a heck of a lot other than ADCs.  Keep that in mind. They
>> are a substantial
>> corner but we handle a lot of output devices and other input devices
>> (though these
>> might be adc's inside, that's not what your average users think of them as).
>> We 'have' to ensure anything we do works for the other device types as well.
> At the IIO layer, but an ADC layer itself needs very very little indeed.
>
> You've got
> 	allocate
> 	deallocate
> 	read_samples (block/nonblock)
> 	setup
> 	->samples() callback

To add a few more things that are common (there are others).

Read scale, read offset.
Hardware event interrupts,
Triggering control.
Filtering control.

Some adcs may only need what you specify, others need a whole lot more.
You might term these setup I suppose, but the consumer of the data often
needs to know about them.
>
> and devices are either polled, IRQ driven or DMA.
>
> Now setup is a lot of different things but those can be abstracted and
> added as needed (and much probably taken from the IIO bits).
>
> A pure ADC abstraction ought to be a very very thin layer of code.
Except that you then end up with simple_adc abstraction and a whole host 
of more
complex abstractions on top.
>
>> I  know it's not ideal, but at the end of the day IIO had a rather
>> different target when
>> we wrote it from SoC ADCs. That target of consistent userspace
>> interfaces and
>> brute force data capture still has to be met without introducing major
>> regressions.
> I don't see the two conflicting. At one level we have a need for a simple
> abstraction for low level ADC access within devices (akin to gpio). At the
> level above we have a need for a consistent, sensible interface to
> userspace with a stable API.
We have that simple abstraction.  Dumb polled or irq driven adc stuff 
can be done cleanly
in minimal code.
What I disagree on is that the bit you have grouped into setup is 
actually separate.  That
needs to be abstracted as well.  Consumers might not care that the gain 
just doubled
because someone else requested it, but I suspect many of them will.
>
> Your simple IIO examples would just use the ADC abstraction, your complex
> IIO examples would use the ADC abstraction *and* layer it with IIO level
> code that is mixing it with all the other needed work.
I suspect you'll end up adding more and more to your adc abstraction 
till you actually
end up with most of IIO.  That's effectively what we did...   It's big 
because there are
actually not that many 'simple' adc's out there.

Jonathan
