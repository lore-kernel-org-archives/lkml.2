Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1GFI7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 04:59:49 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:41150 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1GFI7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 04:59:47 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E1425E0.2070408@cam.ac.uk>
Date: Wed, 06 Jul 2011 10:07:44 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Nathan Royer <nroyer@invensense.com>
CC: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Chris Hudson <chudson@kionix.com>,
        eric.andersson@unixphere.com, eric.miao@linaro.org,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README file.
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>	<4E0D8E94.5030604@cam.ac.uk>	<4d61a92a11e5d83a1cb0094441ae5f5e@mail.gmail.com>	<4E105284.7030209@cam.ac.uk> <20110704091658.0d4c8e3f@bob.linux.org.uk> <c2189246a279a0e5a1b8599edc94a79a@mail.gmail.com>
In-Reply-To: <c2189246a279a0e5a1b8599edc94a79a@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/11 02:49, Nathan Royer wrote:
>>>> accel/bma150.c
>>> An input driver exists for that one. (cc'd Eric)
>>
>> [Two input drivers - bma023 which I posted covers it too ;)]
>>
>>>> # sensors - compass
>>>> compass/ak8975.c
>>
>> We have a driver for this (I posted a while back)
>>
>>>> compass/ak8972.c
>>
>>>> compass/ami30x.c
>>
>> AMI304 is identical to the AK8974 which we already have - Gram Hsieh
>> posted patches for this a while ago
> 
> It seems that some sensors are in input and but that most are in iio.
> Obviously I don't want to dissent with both and put ours in misc, so how
> do we make this better? 
Definitely not misc - we don't want to end up with drivers in there purely
because they might fit in two other places!
> Should we work on cleaning this up.  If so should
> we start moving the drivers that are in input to iio.
Will cause all sorts of userspace issues.  a) iio is still in staging
and for good reason.  I really ought to update our todo list!
b) We don't have a transparent way to provide input interfaces for iio
devices - so that will mean mass abi breakge.  There have been some
discussions about how to do this (see Mark Brown's suggestions a month
or so ago), be it for very different reason.

Anyhow, I'm personally in favour of the current divide:
Basically if it's for human input (primarily) it goes in input (decision
on that is Dmitry's). Otherwise, IIO is happy to take drivers that don't
fit elsewhere (we deliberately have very wide scope).
> 
> If this is the right thing to do, I could start working on merging the
> current mpu3050 input interface and our misc interface to the iio
> interface.  I'm still trying to wrap my head around the iio framework, but
> I think one of the things I need is a uinput like interface for iio
> (perhaps it exists, I just haven't figured it out yet).
Nope. Not previously had a use case.
Unlike input we don't have a whole host of userspace code that is expecting to
receive data in a particular format so we don't have the standard use
case for uinput  (cc'd Manuel and Michael who have done a lot more on the userspace
end of IIO than I have + linux-iio for everyone else).  We do have a prototype
uinput based bridge to push event into input.  It is only intended for those rare
cases where someone really wants to use a 1000 dolar IMU as a mouse. Not relevant
here though.

> If the DMP is
err, DMP?
> used, a buffer for the FIFO data would be created, and user space would be
> responsible to push the sensor data back to iio after sensor fusion and
> calibration.  Without the DMP, each sensor driver would act independently
> providing their own raw data.

Strangely enough, your need to push data back is not dissimilar to what we have
discussed in the past for DACs. Right now we only have a slow and simple interface
for DACs, mainly because doing anything clever requires some fairly nasty additions
to the host bus drivers and no one has had the time.  Michael has almost
certainly thought more on this than I ever have!
> 
> We still need a way to read and write registers and DMP memory during
> runtime from user space.
I guess the DMP is the on device processor? So what you write varies a lot
with what firmware is loaded?

So let me just check I understand the data flow here.

Example

Magnetometer -> kernel -> userspace interface -> hideously complex algorithm ->
kernel -> mpu -> mpu fusion algorithm in relevant firmware -> userspace ?

So how do we know the mpu wants data?  Obvious options that might be the case
a) on chip fifo with flow control.
b) interrupt to request data?
c) Always feed latest value and it runs unsynchronised.

Do we actually have that hideously complex algorithm in userspace element
or did I invent that part?  If not, we might want to use some in kernel
hooks to pass the data back bypassing userspace entirely.

Jonathan 
