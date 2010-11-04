Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab0KDSLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:11:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0KDSLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:11:49 -0400
Message-ID: <4CD2F735.2040903@redhat.com>
Date: Thu, 04 Nov 2010 14:11:01 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, kyle@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
References: <20101009224041.GA901@sepie.suse.cz>	<4CD1E232.30406@redhat.com>	<AANLkTimyh-k8gYwuNi6nZFp3oviQ33+M3fDRzZ+sJN9i@mail.gmail.com>	<4CD22627.2000607@redhat.com>	<AANLkTi=Eb8k6gmeGqvC=Zbo2mj51oHcbCncZGt00u9Tx@mail.gmail.com>	<4CD29493.5020101@redhat.com> <20101104101910.920efbed.randy.dunlap@oracle.com>
In-Reply-To: <20101104101910.920efbed.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 04-11-2010 13:19, Randy Dunlap escreveu:
> On Thu, 04 Nov 2010 07:10:11 -0400 Mauro Carvalho Chehab wrote:
> 
>> All dependencies required by the selected symbols are satisfied. For example,
>> the simplest case is likely cafe_ccic, as, currently, there's just one possible
>> driver that can be attached dynamically at runtime to cafe_ccic. We have:
>>
>> menu "Encoders/decoders and other helper chips"
>> 	depends on !VIDEO_HELPER_CHIPS_AUTO
>>
>> ...
>> config VIDEO_OV7670
>>         tristate "OmniVision OV7670 sensor support"
>>         depends on I2C && VIDEO_V4L2
>> ...
>> endmenu
>>
>> config VIDEO_CAFE_CCIC
>>         tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
>>         depends on PCI && I2C && VIDEO_V4L2
>>         select VIDEO_OV7670
>>
>> The dependencies needed by ov7670 (I2C and VIDEO_V4L2) are also dependencies of 
>> cafe_ccic. So, it shouldn't have any problem for it to work (and it doesn't have,
>> really. This is working as-is during the last 4 years).
> 
> This warning line:
> 
> warning: (VIDEO_CAFE_CCIC && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && PCI && I2C && VIDEO_V4L2 || VIDEO_VIA_CAMERA && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && FB_VIA) selects VIDEO_OV7670 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && I2C && VIDEO_V4L2)
> 
> is not caused by CAFE_CCIC -- it's caused by VIDEO_VIA_CAMERA, because
> VIDEO_HELPER_CHIPS_AUTO=y, so !VIDEO_HELPER_CHIPS_AUTO is false, so
> VIDEO_OV7670 should not be available since it depends on
> !VIDEO_HELPER_CHIPS_AUTO.
> 
> Below is a simple patch that reduces the kconfig warning count in 2.6.37-rc1
> from 240 down to only 88.  :)

Yes, but this makes things worse: it will allow compiling drivers that Kernel
will never use, as they won't work without an I2C adapter, and the I2C adapter
is not compiled.

Worse than that: if you go into all V4L bridge drivers, that implements the I2C
adapters and disable them, the I2C ancillary adapters will still be compiled
(as they won't return to 'n'), but they will never ever be used...

So, no, this is not a solution.

What we need is to prompt the menu only if the user wants to do some manual configuration.
Otherwise, just use the selects done by the drivers that implement the I2C bus adapters,
and have some code to use those selected I2C devices.

Cheers,
Mauro.
