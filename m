Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1GFUZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 16:25:48 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:40451 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755800Ab1GFUZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 16:25:47 -0400
From: Nathan Royer <nroyer@invensense.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<4E0D8E94.5030604@cam.ac.uk>	<4d61a92a11e5d83a1cb0094441ae5f5e@mail.gmail.com>
	<4E105284.7030209@cam.ac.uk> <20110704091658.0d4c8e3f@bob.linux.org.uk>
 <c2189246a279a0e5a1b8599edc94a79a@mail.gmail.com> <4E1425E0.2070408@cam.ac.uk>
In-Reply-To: <4E1425E0.2070408@cam.ac.uk>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Acw7uwqeq76DZdnUS1W5/DioNhRjzgAOikiw
Date: Wed, 6 Jul 2011 13:25:43 -0700
Message-ID: <7c63d523bcbec36ba226968f20249823@mail.gmail.com>
Subject: RE: [PATCH 01/11] misc: inv_mpu primary header file and README file.
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Chris Hudson <chudson@kionix.com>,
        eric.andersson@unixphere.com, eric.miao@linaro.org,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        linux-iio@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It is only intended for those rare
> cases where someone really wants to use a 1000 dolar IMU as a mouse.
> Not relevant here though.

We have a mouse application that is significantly less expensive than
$1000, so it might actually be relevant, in the future.

> > If the DMP is
> err, DMP?

Digital Motion Processor.  It is what we call the built in micro
controller on the mpu3050 that does sensor fusion.

> > used, a buffer for the FIFO data would be created, and user space
> would be
> > responsible to push the sensor data back to iio after sensor fusion
> and
> > calibration.  Without the DMP, each sensor driver would act
> independently
> > providing their own raw data.
>
> Strangely enough, your need to push data back is not dissimilar to what
> we have
> discussed in the past for DACs. Right now we only have a slow and
> simple interface
> for DACs, mainly because doing anything clever requires some fairly
> nasty additions
> to the host bus drivers and no one has had the time.  Michael has
> almost
> certainly thought more on this than I ever have!

A slow interface might be ok.  Highest traffic is usually in the low 10's
of bytes at 30hz.

> > We still need a way to read and write registers and DMP memory during
> > runtime from user space.
> I guess the DMP is the on device processor? So what you write varies a
> lot
> with what firmware is loaded?

Yes that is correct.

> So let me just check I understand the data flow here.
>
> Example
>
> Magnetometer -> kernel -> userspace interface -> hideously complex
> algorithm ->
> kernel -> mpu -> mpu fusion algorithm in relevant firmware -> userspace
> ?

Hideously complex algorithm or HCA for short :)

Your data path is more relevant for the mpu6050.  I'll explain what it
currently looks like on each chip 2 chips.  For the 3050 it looks like
this:
=======================
Accel -> mpu3050 -> DMP (6 Axis fusion) -> FIFO
         (gyro)                   ^
                                  |
                               Kernel
                                  |
FIFO -> Kernel -> user space -> 9 Axis fusion + HCA's-> application
                                  ^
                                  |
Compass -> kernel -> user space --/

For the mpu6050:
================
Compass -> mpu6050   -> DMP (9 Axis Fusion) -> Kernel -> User Space HCA's
-> Apps
          (gyro + accel)     ^                               |
                             |                               |
                             \---------------- Kernel <------/


As you might have seen we don't have an input or an iio interface for user
space to retrieve data.  Currently applications have to link in our MPL,
either standalone, or as a daemon, or something similar like the Android
sensor HAL.  What I'm trying to figure out is once data is ready to be
provided to applications, where should it come from, input, IIO, or a
daemon, before I start that part of development.  It seems like IIO was
built more for raw data, but that input has a facility to handle processed
data.

> So how do we know the mpu wants data?  Obvious options that might be
> the case
> a) on chip fifo with flow control.
> b) interrupt to request data?
> c) Always feed latest value and it runs unsynchronized.

The MPL (Motion Processing Library user space library that includes HCA's)
makes the decision when to feed data down, and does it in an
unsynchronized way.  It will do it shortly after processing a FIFO data
packet, but the timing does not need to be precise.

> Do we actually have that hideously complex algorithm in userspace
> element
> or did I invent that part?  If not, we might want to use some in kernel
> hooks to pass the data back bypassing userspace entirely.

Yes the HCA's exists.  They include 9 axis fusion, compass calibration
algorithms, and a number of other proprietary algorithms.  We've tried to
design the MPL so that they can be removed and still provide basic
functionality.  This basic functionality is available to be pushed into
the kernel if necessary, but we will still need a way to support the
HCA's.
