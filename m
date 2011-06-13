Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1FMJv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:51:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53440 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1FMJv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:51:26 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "Girdwood, Liam" <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>,
        Jorge Eduardo Candelaria <jorge.candelaria@ti.com>
Subject: Re: Re: [PATCH v4 11/18] input: Add initial support for TWL6040 vibrator
Date: Mon, 13 Jun 2011 12:51:16 +0300
Message-ID: <1530216.k8lJ4nKZ1s@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110611231854.GA3979@core.coreip.homeip.net>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com> <1307706876-4768-12-git-send-email-peter.ujfalusi@ti.com> <20110611231854.GA3979@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 June 2011 01:18:54 Dmitry Torokhov wrote:
> > +static void twl6040_vibra_enable(struct vibra_info *info)
> > +{
> > +     struct twl6040 *twl6040 = info->twl6040;
> > +     int ret = 0;
> 
> Initialization is not needed.

True.

> > +static void vibra_play_work(struct work_struct *work)
> > +{
> > +     struct vibra_info *info = container_of(work,
> > +                             struct vibra_info, play_work);
> > +
> > +     mutex_lock(&info->mutex);
> > +
> > +     if (info->weak_speed || info->strong_speed) {
> > +             if (!info->enabled)
> > +                     twl6040_vibra_enable(info);
> > +
> > +             twl6040_vibra_set_effect(info);
> > +     } else if (info->enabled)
> > +             twl6040_vibra_disable(info);
> 
> Why do we play with enabling/disabling the device here? Nobody can
> request playing of an effect unless the device has been opened so if we
> manage power state in open/close methods we should not be doing it here
> I think.

We want to preserve as much power as we can.
So if application opens the driver, but it is not requesting to play any 
effect we still keep the device turned off.
When application request for stopping the effect without closing the device, 
we turn off things in a similar way.
The twl4030-vibra driver has been implemented in this way as well.

> > +
> > +     mutex_unlock(&info->mutex);
> > +}

...

> > +static int twl6040_vibra_open(struct input_dev *input)
> > +{
> > +     struct vibra_info *info = input_get_drvdata(input);
> > +
> > +     info->workqueue = create_singlethread_workqueue("vibra");
> > +     if (info->workqueue == NULL) {
> > +             dev_err(&input->dev, "couldn't create workqueue\n");
> > +             return -ENOMEM;
> > +     }
> 
> Why do we need to create a separate workqueue? With arrival of CWQ
> it looks like we should be able to use one of the system-wide
> workqueues for this.

The reason for this is to ensure that we have the lowest latency as possible 
in most case. In the embedded devices we use the vibra for tactile type of 
feedbacks as well, where few tens of ms delay can be felt.

> > +
> > +     return 0;
> > +}
> > +
> > +static void twl6040_vibra_close(struct input_dev *input)
> > +{
> > +     struct vibra_info *info = input_get_drvdata(input);
> > +
> > +     cancel_work_sync(&info->play_work);
> > +     INIT_WORK(&info->play_work, vibra_play_work);
> > +     destroy_workqueue(info->workqueue);
> > +     info->workqueue = NULL;
> > +
> > +     mutex_lock(&info->mutex);
> > +
> > +     if (info->enabled)
> > +             twl6040_vibra_disable(info);
> > +
> > +     mutex_unlock(&info->mutex);
> > +}
> > +
> > +#if CONFIG_PM
> 
> CONFIG_PM_SLEEP.

OK, will be fixed.

> > +static int twl6040_vibra_suspend(struct device *dev)
> > +{
> > +     struct platform_device *pdev = to_platform_device(dev);
> > +     struct vibra_info *info = platform_get_drvdata(pdev);
> > +
> > +     mutex_lock(&info->mutex);
> > +
> > +     if (info->enabled)
> > +             twl6040_vibra_disable(info);
> > +
> > +     mutex_unlock(&info->mutex);
> > +
> > +     return 0;
> > +}
> > +
> > +static SIMPLE_DEV_PM_OPS(twl6040_vibra_pm_ops,
> > +                      twl6040_vibra_suspend, NULL);
> 
> Move twl6040_vibra_pm_ops definition out of the #ifdef block so you
> won't need to protect it use with ifdefs later.

Thanks, I have change this.
 
> > +#endif

...

> > +static int __devexit twl6040_vibra_remove(struct platform_device *pdev)
> > +{
> > +     struct vibra_info *info = platform_get_drvdata(pdev);
> > +
> > +     twl6040_power(info->twl6040, 0);
> 
> If we ensure that device is powered off until open() is called, and
> also powered off when close() is called, then we do not need to switch
> off power here.

True, removed.

> Thanks.
> 
> --
> Dmitry

Thanks for the comments. I will update the series.

-- 
Péter
