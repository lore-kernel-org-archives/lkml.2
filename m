Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab1COOqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:46:36 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:40780 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab1COOqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:46:35 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D7F7C04.50909@cam.ac.uk>
Date: Tue, 15 Mar 2011 14:47:32 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jean Delvare <khali@linux-fr.org>,
        mems applications <mems.applications@st.com>, rdunlap@xenotime.net,
        carmine.iascone@st.com, matteo.dameno@st.com, rubini@cvml.unipv.it,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>, Greg KH <greg@kroah.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] Add STMicroelectronics LPS001WP pressure sensor device
 driver into misc
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <201103151038.40559.arnd@arndb.de> <4D7F4944.4070507@cam.ac.uk> <201103151429.29460.arnd@arndb.de>
In-Reply-To: <201103151429.29460.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/11 13:29, Arnd Bergmann wrote:
> On Tuesday 15 March 2011, Jonathan Cameron wrote:
>> On 03/15/11 09:38, Arnd Bergmann wrote:
>>> Do you think it would help to split the iio codebase into a smaller part
>>> for the relatively clean drivers that can be put into shape for
>>> drivers/iio, and the bulk of the code that stays in staging for a bit
>>> longer, until it gets converted to the new one in small chunks?
>>>
>>> That may be less frustrating than trying to do it all at once. In particular,
>>> you could do major internal rewrites much faster if you don't have
>>> to immediately worry about breaking dozens of drivers in the process.
>>>
>> Hi Arnd,
>>
>> An interesting idea though I'm not entirely sure how it would
>> work in practice.
>> Two options occurred whilst cycling in this morning.
>> 1) Spit functionality out in staging. This would give a core
>> set that is basically the sysfs only stuff.  To do that we'd
>> have to define a struct iio_dev_basic and make it an element
>> of the iio_dev.  Prior to that we'd probably need to make pretty
>> much all accesses into iio_dev via macros / inline functions 
>> which would not be a trivial undertaking.
> 
> I think if you try to maintain compatibility between the
> basic drivers and the complex stuff in the same tree, you
> won't be able to gain much. Any major changes to address the TODO
> items would still potentially impact all drivers.
True though the todo's I know about shouldn't cause trouble for
the simple drivers.
> 
>> 2) Basically make a copy. 
>> ...
>> * Take out a subset of struct iio_dev (and associated functions
>>   etc), initially just doing the 'bus' handling and sysfs direct
>>   access to the devices.
>> * Move over the relevant parts of Docs (mostly from sysfs-iio-bus)
>> * Hack out the relevant chunks of a number of the cleaner drivers.
>> (the driver and doc moves would occur in sets covering different
>> types of devices to keep the review burden of looking at the 
>> interface to a minimum. We could also clean up the remaining poorly
>> defined abis as we do this (energy meters and resolvers IIRC).
> 
> Yes, this sounds like what I had in mind.
> 
>> Pause for a while (note that we would have to rigorously prevent
>> any divergence between the two versions).
> 
> I wouldn't even worry about divergence at all. Just keep the
> existing version alive and make sure that it doesn't conflict
> with the new one. Any identifiers that are part of the user interface
> could be renamed from iio to something like iioclassic to let
> them coexist and to make sure that you don't have to start out
> with iio2 for the non-staging version.
> 
>> * Copy over the events infrastructure
>> * Move the next chunk of Docs
>> * Lift over the events support from clean drivers.
>>
>> Pause for another while
>>
>> * Lift the core buffering support
>> * Lift over the reset of the documentation.
>> * Take over the hardware buffered device drivers
>> * Take over kfifo wrapping code (has an inferior feature set
>>   to ring_sw but easier to review by far).
>> * synchronise the remains of our good driver set and kill
>>   them off in staging.
>>
>> That would leave the ugly drivers in staging to pull over
>> as they get fixed up.
> 
> Yes. Or, with my variant, leave a copy of the core as well.
Sure, depending on what is left there.  If we have moved all of the
above across then there the non staging version should do everything
the staging version does..
> 
>> Disadvantages of this:
>>
>> * It's not necessarily trivial to break up complex drivers into
>> the three elements described here. They have a tedious habit of
>> interacting.  The issue would be that a lot of the code would seem
>> like it has been done in a very strange way to any reviewer of 
>> the parts they see at a time. Normally they get to look on to a
>> later patch to see why stuff has been done as it has.  Here, would
>> anyone really take a look at the driver in staging to understand 
>> what is going on?
> 
> Then leave the complex drivers until you have the infrastructure
> for them in the new core version.
Then the key thing is going to be convincing people that there is
a reason for a lot of what will go in early on, but they'll need to
look at staging to see why... I guess the version going into mainline
may need a lot of comments in the code.  Note for some whole classes
of devices there are only 'complex' drivers.
> 
>> * The difficulty of keeping the stuff in staging in sync with
>>   the stuff outside.
>>
>> * Fiddly stuff to handle the fact we will for a while have two
>>   drivers for an awful lot of stuff.
> 
> I think these would easily be avoided if you have two incompatible
> subsystems. The disadvantage is that it would become harder to
> move a driver from staging/iioclassic to drivers/iio when the
> APIs are diverging.
Will be interesting to see how bad this gets, but I guess one never
knows until one tries...

Thanks for your suggestions on this.  

