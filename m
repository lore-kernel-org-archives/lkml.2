Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2BBHQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 02:16:29 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35039 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab2BBHQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 02:16:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120201144931.GC30184@srcf.ucam.org>
References: <1323789196-4942-1-git-send-email-amit.kachhap@linaro.org>
	<1323789196-4942-2-git-send-email-amit.kachhap@linaro.org>
	<20120201144931.GC30184@srcf.ucam.org>
Date: Thu, 2 Feb 2012 12:46:27 +0530
Message-ID: <CAK44p21qu=8rtO=C+wogK3sjG77fwUsF_FyZBnCbHTyxNrVT_A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] thermal: Add a new trip type to use cooling
 device instance number
From: Amit Kachhap <amit.kachhap@linaro.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        linaro-dev@lists.linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 February 2012 20:19, Matthew Garrett <mjg@redhat.com> wrote:
>
> I'm not really a fan of this as it stands - the name isn't very
> intuitive and the code's pretty difficult to read. Would the following
> (incomplete and obviously untested) not have the effect you want? Then
> you register multiple trip points with the same cooling device but
> different private values, and the state set does whatever you want it
> to. Or am I misunderstanding the problem you're trying to solve?

Thanks for the detailed review of the patch. Actually i tried to merge
the benefits of trip type ACTIVE and PASSIVE into one so this name.
This new trip type is just like ACTIVE but instead of OFF(0)/ON(1)
all values greater then 0 is on. Anyways I looked at your
implementation below but this will not solve the purpose as
thermal_cooling_device_register() need to be be called only once to
register a cooling device such cpu frequency based. However the same
cooling device may be binded many times to different trips.
Say,
1) thermal_zone_bind_cooling_device(tz_dev, 0, cdev);
2) thermal_zone_bind_cooling_device(tz_dev, 1, cdev);
3) thermal_zone_bind_cooling_device(tz_dev, 2, cdev);

0,1, 2 are nothing but trip points so the set_cur_state should be called like
set_cur_state(cdev, 0)
set_cur_state(cdev, 1)
set_cur_state(cdev, 2) when the trip point threshold are crossed.

Yeah I agree that implementation logic looks complex but this to
prevent the lower temp trip points cooling handlers to be called. I
will surely make this better in next version.

>
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 220ce7e..817f2ba 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -50,6 +50,7 @@ struct thermal_cooling_device_instance {
>        char attr_name[THERMAL_NAME_LENGTH];
>        struct device_attribute attr;
>        struct list_head node;
> +       unsigned long private;
>  };
>
>  static DEFINE_IDR(thermal_tz_idr);
> @@ -909,7 +910,8 @@ static struct class thermal_class = {
>  * @ops:               standard thermal cooling devices callbacks.
>  */
>  struct thermal_cooling_device *thermal_cooling_device_register(
> -     char *type, void *devdata, const struct thermal_cooling_device_ops *ops)
> +       char *type, void *devdata, const struct thermal_cooling_device_ops *ops,
> +       unsigned long private)
>  {
>        struct thermal_cooling_device *cdev;
>        struct thermal_zone_device *pos;
> @@ -936,6 +938,7 @@ struct thermal_cooling_device *thermal_cooling_device_register(
>        cdev->ops = ops;
>        cdev->device.class = &thermal_class;
>        cdev->devdata = devdata;
> +       cdev->private = private;
>        dev_set_name(&cdev->device, "cooling_device%d", cdev->id);
>        result = device_register(&cdev->device);
>        if (result) {
> @@ -1079,11 +1082,14 @@ void thermal_zone_device_update(struct thermal_zone_device *tz)
>                                        continue;
>
>                                cdev = instance->cdev;
> -
> -                               if (temp >= trip_temp)
> -                                       cdev->ops->set_cur_state(cdev, 1);
> -                               else
> -                                       cdev->ops->set_cur_state(cdev, 0);
> +                               if (cdev->private) {
> +                                       cdev->ops->set_cur_state(cdev, cdev->private);
> +                               } else {
> +                                       if (temp >= trip_temp)
> +                                               cdev->ops->set_cur_state(cdev, 1);
> +                                       else
> +                                               cdev->ops->set_cur_state(cdev, 0);
> +                               }
>                        }
>                        break;
>                case THERMAL_TRIP_PASSIVE:
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 796f1ff..04aac09 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -148,7 +148,7 @@ int thermal_zone_unbind_cooling_device(struct thermal_zone_device *, int,
>                                       struct thermal_cooling_device *);
>  void thermal_zone_device_update(struct thermal_zone_device *);
>  struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
> -               const struct thermal_cooling_device_ops *);
> +                    const struct thermal_cooling_device_ops *, unsigned long private);
>  void thermal_cooling_device_unregister(struct thermal_cooling_device *);
>
>  #ifdef CONFIG_NET
>
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
