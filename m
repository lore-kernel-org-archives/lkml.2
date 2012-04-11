Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2DKHo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 03:44:26 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:53070 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2DKHoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 03:44:25 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F85364D.1080706@cam.ac.uk>
Date: Wed, 11 Apr 2012 08:44:13 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
References: <20120410131206.GB31551@sirena.org.uk> <20120410142501.6045c6c0@pyramind.ukuu.org.uk> <20120410133339.GK7499@opensource.wolfsonmicro.com> <20120410144235.1e05efd4@pyramind.ukuu.org.uk> <20120410140749.GL7499@opensource.wolfsonmicro.com> <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk> <20120410151943.GM7499@opensource.wolfsonmicro.com> <20120410175632.5c11c36e@pyramind.ukuu.org.uk> <20120410175846.GQ7499@opensource.wolfsonmicro.com> <4F848C7C.5040703@cam.ac.uk> <20120410223722.GY7499@opensource.wolfsonmicro.com> <e65fbfb8-1169-46dc-aad9-1dc9dbb91e8f@email.android.com>
In-Reply-To: <e65fbfb8-1169-46dc-aad9-1dc9dbb91e8f@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fairly stupid place to reply but I don't have any way of 
replying to the original
patch whilst at work.  Looking quickly at it in a web browser, looks 
like we fundamentally
have a couple of interfaces exported. An alloc and free pair and two 
types of sample?
The second, during gsmpulse sample is some sort of triggered capture?

Mapping to what is now in IIO (and hasn't been for that long!).
We handle alloc and free via a mapping table that registered with the 
core by the
consumer driver (often coming from platform data).

Raw channel reads are available via polling or you can register a 
callback function
(that's the bit that is going through review at the moment) if you have 
a buffered
situation.  So the missing bit is that we don't have a 'request n 
samples' call.
We also don't currently have the functions to switch the triggering 
mechanism from
consumers (though they should be easy to add).

Anyhow, those are the differences and looks like IIO needs a few small 
tweaks to
meet the interface requirements if you did decide to go that way.  The 
only one
I'm not immediately sure how to handle is the 'read n samples' bit.  A 
self unregistering
version of the callback buffer might do it reasonably cleanly....
What you have may correspond to an arbitary scan.  The question is do 
you ever do
uneven reading of different channels?  e.g. AABAAB.

Jonathan
>
> Mark Brown<broonie@opensource.wolfsonmicro.com>  wrote:
>
>> On Tue, Apr 10, 2012 at 08:39:40PM +0100, Jonathan Cameron wrote:
>>
>>> 1)  Review of code.  This is crucial. If people have a little time
>>> ripping holes in the core IIO code is what we need.  Arnd did a good
>> job
>>> of this a while back. Others have done bits of it since.
>>> 2) Getting the push code tidied up and pushed out.  I'll post it as
>> an
>>> updated rfc to linux-iio shortly.  All I had left that definitely
>>> wanted doing here was cleaning up the example iio to input bridge
>>> driver.  That can happen later.
>> For these two can we refactor in place?  That's pretty much what seems
>> to have been happening anyway...
>>
> I guess it comes down to whether Linus will pull.  2 should be there within a week or so anyway depending mostly on analog testing I haven't broken any of their drivers.
>>> * Event passing to consumers else where in the kernel. Right now an
>>> input driver can readings from a sensor, but there is no way of
>>> requesting threshold interrupts.
>>> * Interaction between consumer drivers (e.g. hwmon or input) where
>> some
>>> are requesting data by polling when they want it and others want a
>> These sound like something that can be added incrementally?
>>
>>>> If the code was moved out of staging today what would go wrong?
>>> Churn in interfaces is probably about it.  Maybe a good use of any
>> time
>>
>> I guess the big question is then if we can live with that.
> Agreed.
>>> would be for people to take their non IIO drivers that they think
>> might
>>> fit (or data sheets!) and see whether there are things that they
>> would
>>> like to be different.
>> In tree there's a few auxadc and comparator drivers in drivers/mfd,
>> plus
>> things like arch/arm/plat-samsung/adc.c in the arch direcories.  These
>> are all broadly similar to the at91 code that's been sent to IIO
>> already.  There's also the code Alan posted at the top of this thread.
> Quite a lot of things in miscellaneous as well to possibly pull in over time.
>
>
>

