Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab1COLKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:10:13 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:42771 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab1COLKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:10:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D7F4944.4070507@cam.ac.uk>
Date: Tue, 15 Mar 2011 11:11:00 +0000
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
References: <1300128906-1066-1-git-send-email-matteo.dameno@st.com> <20110314224244.3d6d23ba@endymion.delvare> <4D7EA38F.5070002@cam.ac.uk> <201103151038.40559.arnd@arndb.de>
In-Reply-To: <201103151038.40559.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'd linux-iio as the discussion is moving more into that realm by the minute!

On 03/15/11 09:38, Arnd Bergmann wrote:
> On Tuesday 15 March 2011 00:23:59 Jonathan Cameron wrote:
>>>
>>> This is indeed the major disadvantage. IIO seems to take a lot of time
>>> to move out of staging, although I don't know what the current ETA is.
>>>
>> Whilst I'd like to say soon there are a couple more big changes to make
>> (such as the ongoing changes to allow threaded interrupts for the triggers
>> - basically implementing what Thomas Gleixner suggested and having virtual
>> interrupt chips) and some of these will take a fair bit of bedding down. In the
>> original write I got quite a few things wrong :( Mind you quite a lot of
>> evolution of requirements has taken place as well.
>>
>> Usual sob story (50+ drivers of mixed quality to avoid breaking,
>> little manpower, steady stream of new drivers keeping people busy reviewing
>> etc etc)
>>
>> Having said that, for the simple drivers the interfaces are mostly fixed
>> and nothing much has changed for quite a few months. (e.g. anything that
>> is slow and only uses hwmon style sysfs interfaces).
>>
>> Of course, if anyone does have any time (looks around hopefully...)
>> Particularly helpful are people pointing out what really needs fixing
>> before attempting to move out of staging.   Much better if we get that
>> sort of feedback in plenty of time rather than on sending a pull request
>> to Linus. I like to spread my arguments out ;)
> 
> Do you think it would help to split the iio codebase into a smaller part
> for the relatively clean drivers that can be put into shape for
> drivers/iio, and the bulk of the code that stays in staging for a bit
> longer, until it gets converted to the new one in small chunks?
> 
> That may be less frustrating than trying to do it all at once. In particular,
> you could do major internal rewrites much faster if you don't have
> to immediately worry about breaking dozens of drivers in the process.
> 
Hi Arnd,

An interesting idea though I'm not entirely sure how it would work in practice.
Two options occurred whilst cycling in this morning.
1) Spit functionality out in staging. This would give a core set that is basically the sysfs
only stuff.  To do that we'd have to define a struct iio_dev_basic and make
it an element of the iio_dev.  Prior to that we'd probably
need to make pretty much all accesses into iio_dev via macros / inline functions which
would not be a trivial undertaking.

Then we could switch those drivers doing the minimum to the _basic form.  At that point
we could perhaps attempt to move a couple of drivers and the abi docs out of staging.

The disadvantages of this that come to mind are:
* Makes the path to driver addition that I'd prefer trickier.  You write a basic sysfs
only driver first, then add on stuff like events and buffering as separate patches. We could
go the other way around like v4l2-subdev and have a base structure with the option
of pointers to structures offering different combinations of features.
* Not many of the drivers I'd consider to be ready to go at the moment are actually in
this _basic class. 

2) Basically make a copy.  This would look like the original patch set did when we went
into staging.  I'd imagine any attempt to move the core wholesale is going to get
kicked back as it would be unreviewably large.  We wouldn't be far from this anyway,
it is just a question of ordering and timing.  To achieve a partial merge we would:

* Take out a subset of struct iio_dev (and associated functions etc), initially just doing
the 'bus' handling and sysfs direct access to the devices.
* Move over the relevant parts of Docs (mostly from sysfs-iio-bus)
* Hack out the relevant chunks of a number of the cleaner drivers.
(the driver and doc moves would occur in sets covering different types of devices to keep
the review burden of looking at the interface to a minimum. We could also clean up the
remaining poorly defined abis as we do this (energy meters and resolvers IIRC).

Pause for a while (note that we would have to rigorously prevent any divergence between the
two versions).

* Copy over the events infrastructure
* Move the next chunk of Docs
* Lift over the events support from clean drivers.

Pause for another while

* Lift the core buffering support
* Lift over the reset of the documentation.
* Take over the hardware buffered device drivers
* Take over kfifo wrapping code (has an inferior feature set to ring_sw but easier to review
by far).
* synchronise the remains of our good driver set and kill them off in staging.

That would leave the ugly drivers in staging to pull over as they get fixed up.

Disadvantages of this:

* It's not necessarily trivial to break up complex drivers into the three elements described here.
They have a tedious habit of interacting.  The issue would be that a lot of the code would seem
like it has been done in a very strange way to any reviewer of the parts they see at a time.
Normally they get to look on to a later patch to see why stuff has been done as it has.  Here, would
anyone really take a look at the driver in staging to understand what is going on?

* The difficulty of keeping the stuff in staging in sync with the stuff outside.

* Fiddly stuff to handle the fact we will for a while have two drivers for an awful lot of stuff.

The alternative would be to do much as above over a much shorter timescale once we are happy with
what we have in staging.  Only substantial other difference is that we take very few drivers along
the intermediate steps (probably just the ones I or whoever puts the patch set together can actually
verify at each step).  We then bring the others over at the end.  This approach would probably happen
into a tree picked up by linux-next over weeks or months.

Perhaps some pseudo version of above would work review wise.  Post the patches in sets and get
acks for each step from all interested players.  After ALS I'd definitely like to get a view
from Linus as early as possible, but I don't think we are ready to approach him quite yet.  There
are big ugly corners that will distract from the main issues.

Thanks,

Jonathan
