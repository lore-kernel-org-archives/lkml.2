Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab0I2SVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:21:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38776 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab0I2SVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fJRLSTdm7G9GZGW7bea50rOScOHmX28BSztWPbL9KrW71krtTn+TEwOmD9okG7Y4kt
         Reb/yR/jqIf2T7Y/jzc/G1iR0XTWkge2oFUkZOuq6AiEe+qJc+3erP3BeROPpXxt+nnS
         DQrxhpZY+5CeTN7Jvssw/BtLEk7nINTJjCVHM=
MIME-Version: 1.0
In-Reply-To: <20100927165737.GJ2560@sortiz-mobl>
References: <20100919172301.91EEA9D401B@zog.reactivated.net>
	<20100927165737.GJ2560@sortiz-mobl>
Date: Wed, 29 Sep 2010 19:21:45 +0100
X-Google-Sender-Auth: vhrLvNIuMJcEOQZnMFDdrvP7KV8
Message-ID: <AANLkTi=95qyBwvUamCqPsR_Yox5ybcK3k2NNNZjDqAKy@mail.gmail.com>
Subject: Re: [PATCH] Add VIA VX855 multi-function device support
From: Daniel Drake <dsd@laptop.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, laforge@gnumonks.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 September 2010 17:57, Samuel Ortiz <sameo@linux.intel.com> wrote:
> We do have an MFD API for registering sub devices as platform devices. See
> mfd_add_devices(). You'd have to define cells (statically or not) and set the
> cell->platform_data pointer properly. I'd prefer to see this driver using this
> API.

Thanks. I've made the change locally but have run into a problem.

mfd_add_devices calls acpi_check_resource_conflict() on each resource.
And as noted in the earlier patch, ACPI also has a region reserved.
Because acpi_check_resource_conflict() says there is a conflict,
mfd_add_devices() bails out before registering the devices.

So I've researched the conflict.
The GPIO driver is trying to reserve region 0x420 - 0x452
ACPI reports a conflict on "PRIE" 0x434

Indeed, 0x434 is something ACPI-specific, so ACPI is right to say "get
off my turf", and actually there are a whole host of non-GPIO things
intermixed with GPIO things within the region 0x420 - 0x452.

So, I thought about making the driver only reserve the 2 ports that it
uses: 0x448,  0x44c

However, ACPI has also reserved 0x448. This is because the XO-1.5 also
uses GPIOs for the lid switch and ebook switch, which are basically
presented to the OS as normal ACPI buttons. This particular byte
includes a range of GPIOs including the ones that ACPI uses internally
(the switches) plus the ones that we want to make available through
the gpio driver.

So, we're running into a limitation with Linux's model that
