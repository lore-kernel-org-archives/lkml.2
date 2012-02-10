Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab2BJQIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 11:08:13 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:36985 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab2BJQIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 11:08:11 -0500
Date: Fri, 10 Feb 2012 11:07:55 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: guenter.roeck@ericsson.com
Cc: "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH v5 4/5] hwmon: add MAX197 support
Message-ID: <20120210110755.4914b332@v0nbox>
In-Reply-To: <1328561164.2261.258.camel@groeck-laptop>
References: <1328130344-18836-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1328130344-18836-5-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1328132138.2261.116.camel@groeck-laptop>
	<20120206151507.73a23eb8@v0nbox>
	<1328561164.2261.258.camel@groeck-laptop>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 6 Feb 2012 12:46:04 -0800,
Guenter Roeck <guenter.roeck@ericsson.com> wrote:

> On Mon, 2012-02-06 at 15:15 -0500, Vivien Didelot wrote:
> [ ... ]
> > 
> > BTW, about the TS-5500 ADC part, is a platform ts5500_adc.c file the
> > better solution, or should the device be declared in the ts5500.c
> > platform code?
> > 
> I would suggest to declare it in the ts5500.c platform code. That
> seems to be the common approach as far as I can see.
> 
> platform_add_devices() works pretty well for this. It saves you from
> having to call platform_device_register() for each device separately.
> Obviously that only works if all devices are declared in a single
> file.

As the LED is registered using the leds_class, I think
platform_add_devices() couldn't be used here.

Lots of platform codes don't check the returned
value of platform_add_devices(). Should we care about a LED or ADC
registration failure (is the following snippet OK?)?

    static int __init ts5500_init(void)
    {
    [...]
        pdev = platform_device_register_simple("ts5500", -1, NULL, 0); 
        if (IS_ERR(pdev)) {
                ret = PTR_ERR(pdev);
                goto release_mem;
        }
        platform_set_drvdata(pdev, ts5500);
    
        ret = sysfs_create_group(&pdev->dev.kobj,
                                 &ts5500_attr_group);
        if (ret)
                goto release_pdev;
    
        led_classdev_register(&pdev->dev, &ts5500_led_cdev);
        if (ts5500->adc) {
                ts5500_adc_pdev.dev.parent = &pdev->dev;
                platform_device_register(&ts5500_adc_pdev);
        }
    
        return 0;
    
        release_pdev:
                platform_device_unregister(pdev);
        release_mem:
                kfree(ts5500);
    
                return ret;
    }
    device_initcall(ts5500_init);


Thanks,


-- 
Vivien Didelot
Savoir-faire Linux Inc.
Tel: (514) 276-5468 #149
