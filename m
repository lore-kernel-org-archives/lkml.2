Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1GAPwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:52:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37062 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1GAPwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:52:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=iByZvHOLbfhUc6tdP1paAR7nbsEnWc05+IsogVB/++UHjCgdq47CKj5Kjk94B1REK
	xkfHRNP3iLMm6Q8E6nqEw==
MIME-Version: 1.0
In-Reply-To: <20110701154150.0ac303a3@lxorguk.ukuu.org.uk>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<1309486707-1658-11-git-send-email-nroyer@invensense.com>
	<20110701085604.0aabd6f1@bob.linux.org.uk>
	<CAN_12A8Za7r92=r3JHx3R=AwAA7xk6=NVVMiSp68HPatb1G3hg@mail.gmail.com>
	<20110701154150.0ac303a3@lxorguk.ukuu.org.uk>
Date: Fri, 1 Jul 2011 08:52:28 -0700
X-Google-Sender-Auth: j11s8EPtiaiRqkQHSEJhkrSNkDE
Message-ID: <CAN_12A9jvid+7u5mOHbFBqE+Xtb6kbo_endwRk98JLrGK2E2TA@mail.gmail.com>
Subject: Re: [PATCH 11/11] misc: Add slave driver for bma085 pressure sensor
From: Chris Wolfe <cwolfe@chromium.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Nathan Royer <nroyer@invensense.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 7:41 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Part of the reason I got started on the KXTF9 driver was to try and
>> understand how a normal kernel driver could cope with the "here and
>> gone again" behavior of being on the MPU's secondary bus.
>
> It's a hot pluggable bus - no different to an i2c bus on a hot pluggable
> device.

Can such a hot pluggable device maintain state while "unplugged"?

e.g. if the system is going to suspend, we need to pause the MPU,
switch it back to pass-through mode, then send commands to suspend the
slave on that bus. I took that to mean we wanted the secondary bus to
have a normal device on it, which is still considered plugged in, but
temporarily inaccessible from the CPU.

> I would guess however that if you knew the device was going to be used for
> the mpu3050 only you'd not add the "slave" devices in your platform data
> in the first place as well so they didn't bounce in and out and you'd
> probably teach the mpu3050 code to not create the bus if it was then
> going to destroy it again a moment later.

Something needs to initialize and configure the slaved devices (and
suspend/resume/shutdown/etc). I'm not sure where this happens if not
A) special-purpose code in the mpu3050 driver for each possible slave;
or B) normal drivers and platform data which cope with B1) the kernel
relaying their data to the MPU and B2) being disconnected from the CPU
while the MPU reads from the device directly.

>> The other note that may not have been made explicit yet is that the
>> 3050 will happily provide unprocessed gyro and slave data without
>> firmware loaded. The firmware sets up some additional processing
>> capabilities of the chip, which are used by InvenSense's user-space
>> products.
>
> Yes - and the current mpu3050 driver provides just these interfaces.

Ah, great. Sorry for missing them. In scanning the ioctls, it looked
like dev-i2c was still a similar level of abstraction :)

Chris
