Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab0I2S0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 14:26:15 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63113 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab0I2S0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 14:26:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rxu3Hf3ltkopNeCymwZmatDvICmd3SS5m5OhVuuJsyWdOLhCUfzvq8UhEgbGMTIZhf
         ZGqn0ot3/22c9McWo3jvUwJPjkJtr7RuuemnB/d9r1FYe8iykwxQKZOHahX6NfUa2apq
         zFxcJQVFt+272zvX7KaFX56tafT+NNa0GHe8E=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=95qyBwvUamCqPsR_Yox5ybcK3k2NNNZjDqAKy@mail.gmail.com>
References: <20100919172301.91EEA9D401B@zog.reactivated.net>
	<20100927165737.GJ2560@sortiz-mobl>
	<AANLkTi=95qyBwvUamCqPsR_Yox5ybcK3k2NNNZjDqAKy@mail.gmail.com>
Date: Wed, 29 Sep 2010 19:26:12 +0100
X-Google-Sender-Auth: NgX2JujCQhPwAUYCz1V-gKKZihg
Message-ID: <AANLkTinK8KScJ6Ux69w_ou4bbjsk8phb_2cokB-ZniFm@mail.gmail.com>
Subject: Re: [PATCH] Add VIA VX855 multi-function device support
From: Daniel Drake <dsd@laptop.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, laforge@gnumonks.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, hit send too early.

On 29 September 2010 19:21, Daniel Drake <dsd@laptop.org> wrote:
> Thanks. I've made the change locally but have run into a problem.
>
> mfd_add_devices calls acpi_check_resource_conflict() on each resource.
> And as noted in the earlier patch, ACPI also has a region reserved.
> Because acpi_check_resource_conflict() says there is a conflict,
> mfd_add_devices() bails out before registering the devices.
>
> So I've researched the conflict.
> The GPIO driver is trying to reserve region 0x420 - 0x452
> ACPI reports a conflict on "PRIE" 0x434
>
> Indeed, 0x434 is something ACPI-specific, so ACPI is right to say "get
> off my turf", and actually there are a whole host of non-GPIO things
> intermixed with GPIO things within the region 0x420 - 0x452.
>
> So, I thought about making the driver only reserve the 2 ports that it
> uses: 0x448,  0x44c
>
> However, ACPI has also reserved 0x448. This is because the XO-1.5 also
> uses GPIOs for the lid switch and ebook switch, which are basically
> presented to the OS as normal ACPI buttons. This particular byte
> includes a range of GPIOs including the ones that ACPI uses internally
> (the switches) plus the ones that we want to make available through
> the gpio driver.
>
> So, we're running into a limitation with Linux's model that

...an individual byte is either owned by one driver or another. In
this case, we want certain bits to belong to ACPI and other bits to
belong to the gpio driver. And given that these are "general purpose"
I/Os, this sharing even seems reasonable.

Any thoughts on what we can do?
Perhaps we could avoid using the mfd cell resource mechanism for the
GPIO ports, go back to passing them some other way, and attempting to
reserve the 2 needed ports but not bailing out if they can't be
reserved.

Thanks,
Daniel
