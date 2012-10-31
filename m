Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760047Ab2JaCd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:33:57 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37878 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759503Ab2JaCdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <1351615741-24134-5-git-send-email-hongbo.zhang@linaro.com>
References: <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
	<1351615741-24134-1-git-send-email-hongbo.zhang@linaro.com>
	<1351615741-24134-5-git-send-email-hongbo.zhang@linaro.com>
Date: Wed, 31 Oct 2012 08:03:54 +0530
Message-ID: <CAKohpondoFppsj38pWAzA4O=bcU81qzCP6vLBSYZ1f=oopykGA@mail.gmail.com>
Subject: Re: [PATCH V3 4/5] Thermal: Add ST-Ericsson DB8500 thermal driver.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "hongbo.zhang" <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, rui.zhang@intel.com, amit.kachhap@linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for late comments :(

On 30 October 2012 22:19, hongbo.zhang <hongbo.zhang@linaro.org> wrote:
> From: "hongbo.zhang" <hongbo.zhang@linaro.com>
>
> This diver is based on the thermal management framework in thermal_sys.c. A

s/diver/driver

> thermal zone device is created with the trip points to which cooling devices
> can be bound, the current cooling device is cpufreq, e.g. CPU frequency is
> clipped down to cool the CPU, and other cooling devices can be added and bound
> to the trip points dynamically.  The platform specific PRCMU interrupts are
> used to active thermal update when trip points are reached.
>
> Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
> ---
>  .../devicetree/bindings/thermal/db8500-thermal.txt |  40 ++
>  drivers/thermal/Kconfig                            |  20 +
>  drivers/thermal/Makefile                           |   2 +
>  drivers/thermal/db8500_cpufreq_cooling.c           | 108 +++++
>  drivers/thermal/db8500_thermal.c                   | 531 +++++++++++++++++++++
>  include/linux/platform_data/db8500_thermal.h       |  38 ++
>  6 files changed, 739 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/thermal/db8500-thermal.txt
>  create mode 100644 drivers/thermal/db8500_cpufreq_cooling.c
>  create mode 100644 drivers/thermal/db8500_thermal.c
>  create mode 100644 include/linux/platform_data/db8500_thermal.h
>
> diff --git a/Documentation/devicetree/bindings/thermal/db8500-thermal.txt b/Documentation/devicetree/bindings/thermal/db8500-thermal.txt
> new file mode 100644
> index 0000000..cab6916
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/db8500-thermal.txt
> @@ -0,0 +1,40 @@
> +* ST-Ericsson DB8500 Thermal
> +
> +** Thermal node properties:
> +
> +- compatible : "stericsson,db8500-thermal";
> +- reg : address range of the thermal sensor registers;
> +- interrupts : interrupts generated from PRCMU;
> +- interrupt-names : "IRQ_HOTMON_LOW" and "IRQ_HOTMON_HIGH";

Just mention here that below properties are optional or required.

> +- num-trips : number of total trip points;
> +- tripN-temp : temperature of trip point N, should be in ascending order;
> +- tripN-type : type of trip point N, should be one of "active" "passive" "hot" "critical";
> +- tripN-cdev-num : number of the cooling devices which can be bound to trip point N;
> +- tripN-cdev-nameM : name of the No. M cooling device of trip point N;

> diff --git a/drivers/thermal/db8500_thermal.c b/drivers/thermal/db8500_thermal.c

> +static int db8500_thermal_match_cdev(struct thermal_cooling_device *cdev,
> +               struct db8500_trip_point *trip_points)
> +{
> +       int i;
> +       char *cdev_name;
> +
> +       if (!strlen(cdev->type))
> +               return -EINVAL;
> +
> +       for (i = 0; i < COOLING_DEV_MAX; i++) {
> +               cdev_name = trip_points->cdev_name[i];
> +               if (!strcmp(cdev_name, cdev->type))

You can actually remove cdev_name variable. and use
if (!strcmp(trip_points->cdev_name[i], cdev->type))

> +                       return 0;
> +       }
> +
> +       return -ENODEV;
> +}

> +#ifdef CONFIG_OF
> +static struct db8500_thsens_platform_data*
> +               db8500_thermal_parse_dt(struct platform_device *pdev)
> +{

> +               for (j = 0; j < tmp_data; j++) {
> +                       sprintf(prop_name, "trip%d-cdev-name%d", i, j);
> +                       if (of_property_read_string(np, prop_name, &tmp_str))
> +                               goto err_parse_dt;
> +
> +                       if (strlen(tmp_str) > THERMAL_NAME_LENGTH)
> +                               goto err_parse_dt;
> +
> +                       strcpy(ptrips->trip_points[i].cdev_name[j], tmp_str);

want to check if it is copied or not??

> +               }
> +       }
> +       return ptrips;
> +
> +err_parse_dt:
> +       dev_err(&pdev->dev, "Parsing device tree data error.\n");
> +       return NULL;
> +}

After these please add my:

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
