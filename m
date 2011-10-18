Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab1JROOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:14:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57739 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab1JROOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:14:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
Date: Tue, 18 Oct 2011 16:14:02 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        jamie@jamieiles.com
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org> <20111017161616.GA5108@suse.de> <4E9D5F29.1070303@linaro.org>
In-Reply-To: <4E9D5F29.1070303@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110181614.02312.arnd@arndb.de>
X-Provags-ID: V02:K0:o7eL3o1JS2wovuYp5qDIO7DJXrqOs60U7Q5aFo9lcZr
 rL1zoCFOQ+LCfA1IC3KNzV3EPPPfM/296dabQTpmc+m0stGimd
 nYY0oW9DodpE6hNVAU6wFbDGqfzCP+FPsiRakRoIR84RgtJD64
 gEHw+Tg1tSjDWzbEW/wx/xJquSJGHINOQevsCYC7xPmOP8J+mx
 8N7SU6IwsHyEHbc2dX08yp9uwj/RoWb3KEqbUDsxv8bQ2grliv
 zMc9uYs+3U5+JZCrRVDqJG5NFrG/6lAMWo6HnVjxoVzV5IxDcL
 sTWNZWUxIcsajQesYaodMxdO2v2JdDBCM1I1kxf3g6pD6/qp4n
 6wneL/s9vYCJ1xLczuZ0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 October 2011, Lee Jones wrote:
> >> +struct device *soc_device_register(struct soc_device_attribute *soc_dev_attr)
> >> +{
> >> +    struct soc_device *soc_dev;
> >> +    static atomic_t soc_device_num = ATOMIC_INIT(0);
> > 
> > No, please don't do this, use the proper kernel interface to dynamically
> > handle numbering devices (hint, if you unload a SOC device, you will
> > never reclaim that device number, which isn't that nice.)
> 
> Again, some help would really be appreciated here. I searched the kernel
> last time you mentioned numbering, but this is all I came up with.

I guess the correct interface to use here would be an "ida", see
linux/idr.h. However, I'm not convinced that's actually worth the
extra space for maintaining it here.

An SoC pretty much has the following properties:

* gets probed very early at boot time,
* can never go away, and
* there is only one of them in the system.

The only reason I even asked for the devices to be enumerated is that
there is the possibility that some device will need to have more than
one and we should design every stable user interface in a way that never
changes in a user visible way.

IMHO, we could also remove the soc_device_unregister() function entirely
and add a comment along the lines of 
/*
 * If you really need to add hot-pluggable soc_devices, add a
 * soc_device_unregister function and turn the number generation
 * into an IDA.
 */

	Arnd
