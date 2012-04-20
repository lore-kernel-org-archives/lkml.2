Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab2DTQKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:10:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63862 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab2DTQKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:10:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johan Hovold <jhovold@gmail.com>
Subject: Re: [PATCH 3/4] leds: add LM3533 LED driver
Date: Fri, 20 Apr 2012 16:10:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Richard Purdie <rpurdie@rpsys.net>, Samuel Ortiz <sameo@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com> <1334935826-12527-4-git-send-email-jhovold@gmail.com>
In-Reply-To: <1334935826-12527-4-git-send-email-jhovold@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204201610.15758.arnd@arndb.de>
X-Provags-ID: V02:K0:N7OM7OUXGo+bCQqc/iDwCHJBsK+S72GdRZRwJszd6oH
 eKaY0omCUFX684NaIXAF0zrUz0amZCHOdbvf9+xhLBBe06AMoG
 KWlFIzxWN4vGiLYdVr626GBGeTsb97y2ojWaNvg5nbqGSCxkMO
 adQZiSn6PpqgsBA96mGhDqrVIoOY14zX6Igtu0nnLVk2kxl1Vv
 7bSoW5QIuWj9oHWq6IZnCkZ742KxTqtKz7AVqE/NBwi2FWW6mH
 KZ1FxXfdAO5igFAUNOw2BtXQ473ePqDMCy9hhHc/qLAdvv+OM4
 yFIV8uXj3mpzZ2HTLK16yrqQdfKk8rfShOUCm/CaugYbFpwPY5
 Sw0Nr482jf9PdaBNmIKg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2012, Johan Hovold wrote:
> Add sub-driver for the LEDs in National Semiconductor / TI LM3533
> lighting power chips.
> 
> The chip provides 256 brightness levels, hardware accelerated blinking
> as well as ambient-light-sensor and pwm input control.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

I notice that there is already driver for lm3530, which sounds related.
Is there an opportunity to share code between these, or are they completely
different devices?

> +
> +#define show_ctrlbank_attr(_name)					\
> +static ssize_t show_##_name(struct device *dev,				\
> +				struct device_attribute *attr,		\
> +				char *buf)				\
> +{									\
> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);		\
> +	struct lm3533_led *led = to_lm3533_led(led_cdev);		\
> +	u8 val;								\
> +	int ret;							\
> +									\
> +	ret = lm3533_ctrlbank_get_##_name(&led->cb, &val);		\
> +	if (ret)							\
> +		return ret;						\
> +									\
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", val);			\
> +}

IMHO this macro adds more in terms of complexity than it saves in terms
of lines of code, and it would be better to open-code the two instances.
If you need more than two or three instances, I would recommend creating
keying the number off of the attribute pointer, either by comparing the
pointer or by adding a data structure derived from device_attribute and
using container_of to get at the other data.

	Arnd
