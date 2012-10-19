Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab2JSJUq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:20:46 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:51367 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab2JSJUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:20:39 -0400
Message-ID: <1350638436.3339.2.camel@gitbox>
Subject: Re: [PATCH v7 2/3] pwm_backlight: use power sequences
From: Tony Prisk <linux@prisktech.co.nz>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-fbdev@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Date: Fri, 19 Oct 2012 22:20:36 +1300
In-Reply-To: <1350637589-7405-3-git-send-email-acourbot@nvidia.com>
References: <1350637589-7405-1-git-send-email-acourbot@nvidia.com>
	 <1350637589-7405-3-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 18:06 +0900, Alexandre Courbot wrote:
> Make use of the power sequences specified in the device tree or platform
> data to control how the backlight is powered on and off.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  .../bindings/video/backlight/pwm-backlight.txt     |  72 ++++++++-
>  drivers/video/backlight/Kconfig                    |   1 +
>  drivers/video/backlight/pwm_bl.c                   | 161 ++++++++++++++++-----
>  include/linux/pwm_backlight.h                      |  18 ++-
>  4 files changed, 213 insertions(+), 39 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> index 1e4fc72..3ba25ea 100644
> --- a/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> +++ b/Documentation/devicetree/bindings/video/backlight/pwm-backlight.txt
> @@ -14,15 +14,83 @@ Required properties:
>  Optional properties:
>    - pwm-names: a list of names for the PWM devices specified in the
>                 "pwms" property (see PWM binding[0])
> +  - low-threshold-brightness: brightness threshold low level. Sets the lowest
> +    brightness value.
> +    On some panels the backlight misbehaves if the duty cycle percentage of the
> +    PWM wave is less than a certain level (say 20%).  In this example the user
> +    can set low-threshold-brightness to a value above 50 (ie, 20% of 255), thus
> +    preventing the PWM duty cycle from going too low.
> +    On setting low-threshold-brightness the range of brightness levels is
> +    calculated in the range low-threshold-brightness to the maximum value in
> +    brightness-levels, described above.
> +  - pwm-names: name for the PWM device specified in the "pwms" property (see PWM
> +    binding[0]). Necessary if power sequences are used
> +  - power-sequences: Power sequences (see Power sequences[1]) used to bring the
> +    backlight on and off. If this property is present, then two power
> +    sequences named "power-on" and "power-off" must be defined to control how
> +    the backlight is to be powered on and off. These sequences must reference
> +    the PWM specified in the pwms property by its name, and can also reference
> +    other resources supported by the power sequences mechanism
>  
>  [0]: Documentation/devicetree/bindings/pwm/pwm.txt
> +[1]: Documentation/devicetree/bindings/power/power_seq.txt
>  
>  Example:
>  
>  	backlight {
>  		compatible = "pwm-backlight";
> -		pwms = <&pwm 0 5000000>;
> -
>  		brightness-levels = <0 4 8 16 32 64 128 255>;
>  		default-brightness-level = <6>;
> +		low-threshold-brightness = <50>;
> +
> +		/* resources used by the power sequences */
> +		pwms = <&pwm 0 5000000>;
> +		pwm-names = "backlight";
> +		power-supply = <&backlight_reg>;
> +
> +		power-sequences {
> +			power-on {
> +				step0 {
> +					type = "regulator";
> +					id = "power";
> +					enable;
> +				};
> +				step1 {
> +					type = "delay";
> +					delay = <10000>;
> +				};
> +				step2 {
> +					type = "pwm";
> +					id = "backlight";
> +					enable;
> +				};
> +				step3 {
> +					type = "gpio";
> +					gpio = <&gpio 28 0>;
> +					value = <1>;
> +				};
> +			};
> +
> +			power-off {
> +				step0 {
> +					type = "gpio";
> +					gpio = <&gpio 28 0>;
> +					value = <0>;
> +				};
> +				step1 {
> +					type = "pwm";
> +					id = "backlight";
> +					disable;
> +				};
> +				step2 {
> +					type = "delay";
> +					delay = <10000>;
> +				};
> +				step3 {
> +					type = "regulator";
> +					id = "power";
> +					disable;
> +				};
> +			};
> +		};
>  	};
> diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
> index c101697..c2e5f79 100644
> --- a/drivers/video/backlight/Kconfig
> +++ b/drivers/video/backlight/Kconfig
> @@ -239,6 +239,7 @@ config BACKLIGHT_CARILLO_RANCH
>  config BACKLIGHT_PWM
>  	tristate "Generic PWM based Backlight Driver"
>  	depends on PWM
> +	select POWER_SEQ
>  	help
>  	  If you have a LCD backlight adjustable by PWM, say Y to enable
>  	  this driver.
> diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
> index 069983c..e607c6e 100644
> --- a/drivers/video/backlight/pwm_bl.c
> +++ b/drivers/video/backlight/pwm_bl.c
> @@ -27,6 +27,12 @@ struct pwm_bl_data {
>  	unsigned int		period;
>  	unsigned int		lth_brightness;
>  	unsigned int		*levels;
> +	bool			enabled;
> +	struct power_seq_set	power_seqs;
> +	struct power_seq	*power_on_seq;
> +	struct power_seq	*power_off_seq;
> +
> +	/* Legacy callbacks */
>  	int			(*notify)(struct device *,
>  					  int brightness);
>  	void			(*notify_after)(struct device *,
> @@ -35,6 +41,52 @@ struct pwm_bl_data {
>  	void			(*exit)(struct device *);
>  };
>  
> +static void pwm_backlight_on(struct backlight_device *bl)
> +{
> +	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
> +	int ret;
> +
> +	if (pb->enabled)
> +		return;
> +
> +	if (pb->power_on_seq) {
> +		ret = power_seq_run(pb->power_on_seq);
> +		if (ret < 0) {
> +			dev_err(&bl->dev, "cannot run power on sequence\n");
> +			return;
> +		}
> +	} else {
> +		/* legacy framework */
> +		pwm_config(pb->pwm, 0, pb->period);
> +		pwm_disable(pb->pwm);
Is this right? pwm_disable() in the backlight_on function?
> +	}
> +
> +	pb->enabled = true;
> +}
> +
> +static void pwm_backlight_off(struct backlight_device *bl)
> +{
> +	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
> +	int ret;
> +
> +	if (!pb->enabled)
> +		return;
> +
> +	if (pb->power_off_seq) {
> +		ret = power_seq_run(pb->power_off_seq);
> +		if (ret < 0) {
> +			dev_err(&bl->dev, "cannot run power off sequence\n");
> +			return;
> +		}
> +	} else {
> +		/* legacy framework */
> +		pwm_enable(pb->pwm);
Same here.. owm_enable() in backlight_off()
> +		return;
> +	}
> +
> +	pb->enabled = false;
> +}
> +
>  static int pwm_backlight_update_status(struct backlight_device *bl)
>  {
>  	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
> @@ -51,8 +103,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
>  		brightness = pb->notify(pb->dev, brightness);
>  
>  	if (brightness == 0) {
> -		pwm_config(pb->pwm, 0, pb->period);
> -		pwm_disable(pb->pwm);
> +		pwm_backlight_off(bl);
>  	} else {
>  		int duty_cycle;
>  
> @@ -66,7 +117,7 @@ static int pwm_backlight_update_status(struct backlight_device *bl)
>  		duty_cycle = pb->lth_brightness +
>  		     (duty_cycle * (pb->period - pb->lth_brightness) / max);
>  		pwm_config(pb->pwm, duty_cycle, pb->period);
> -		pwm_enable(pb->pwm);
> +		pwm_backlight_on(bl);
>  	}
>  
>  	if (pb->notify_after)
> @@ -145,11 +196,10 @@ static int pwm_backlight_parse_dt(struct device *dev,
>  		data->max_brightness--;
>  	}
>  
> -	/*
> -	 * TODO: Most users of this driver use a number of GPIOs to control
> -	 *       backlight power. Support for specifying these needs to be
> -	 *       added.
> -	 */
> +	/* read power sequences */
> +	data->power_seqs = devm_of_parse_power_seq_set(dev);
> +	if (IS_ERR(data->power_seqs))
> +		return PTR_ERR(data->power_seqs);
>  
>  	return 0;
>  }
> @@ -172,6 +222,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>  {
>  	struct platform_pwm_backlight_data *data = pdev->dev.platform_data;
>  	struct platform_pwm_backlight_data defdata;
> +	struct power_seq_resource *res;
>  	struct backlight_properties props;
>  	struct backlight_device *bl;
>  	struct pwm_bl_data *pb;
> @@ -180,7 +231,9 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>  
>  	if (!data) {
>  		ret = pwm_backlight_parse_dt(&pdev->dev, &defdata);
> -		if (ret < 0) {
> +		if (ret == -EPROBE_DEFER) {
> +			return ret;
> +		} else if (ret < 0) {
>  			dev_err(&pdev->dev, "failed to find platform data\n");
>  			return ret;
>  		}
> @@ -201,6 +254,68 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>  		goto err_alloc;
>  	}
>  
> +	if (data->power_seqs) {
> +		/* use power sequences */
> +		struct power_seq_set *seqs = &pb->power_seqs;
> +
> +		power_seq_set_init(seqs, &pdev->dev);
> +		power_seq_set_add_sequences(seqs, data->power_seqs);
> +
> +		/* Check that the required sequences are here */
> +		pb->power_on_seq = power_seq_lookup(seqs, "power-on");
> +		if (!pb->power_on_seq) {
> +			dev_err(&pdev->dev, "missing power-on sequence\n");
> +			return -EINVAL;
> +		}
> +		pb->power_off_seq = power_seq_lookup(seqs, "power-off");
> +		if (!pb->power_off_seq) {
> +			dev_err(&pdev->dev, "missing power-off sequence\n");
> +			return -EINVAL;
> +		}
> +
> +		/* we must have exactly one PWM resource for this driver */
> +		power_seq_for_each_resource(res, seqs) {
> +			if (res->type != POWER_SEQ_PWM)
> +				continue;
> +			if (pb->pwm) {
> +				dev_err(&pdev->dev, "more than one PWM used\n");
> +				return -EINVAL;
> +			}
> +			/* keep the pwm at hand */
> +			pb->pwm = res->pwm.pwm;
> +		}
> +		/* from here we should have a PWM */
> +		if (!pb->pwm) {
> +			dev_err(&pdev->dev, "no PWM defined!\n");
> +			return -EINVAL;
> +		}
> +	} else {
> +		/* use legacy interface */
> +		pb->pwm = devm_pwm_get(&pdev->dev, NULL);
> +		if (IS_ERR(pb->pwm)) {
> +			dev_err(&pdev->dev,
> +				"unable to request PWM, trying legacy API\n");
> +
> +			pb->pwm = pwm_request(data->pwm_id, "pwm-backlight");
> +			if (IS_ERR(pb->pwm)) {
> +				dev_err(&pdev->dev,
> +					"unable to request legacy PWM\n");
> +				ret = PTR_ERR(pb->pwm);
> +				goto err_alloc;
> +			}
> +		}
> +
> +		dev_dbg(&pdev->dev, "got pwm for backlight\n");
> +
> +		/*
> +		* The DT case will set the pwm_period_ns field to 0 and store
> +		* the period, parsed from the DT, in the PWM device. For the
> +		* non-DT case, set the period from platform data.
> +		*/
> +		if (data->pwm_period_ns > 0)
> +			pwm_set_period(pb->pwm, data->pwm_period_ns);
> +	}
> +
>  	if (data->levels) {
>  		max = data->levels[data->max_brightness];
>  		pb->levels = data->levels;
> @@ -213,28 +328,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>  	pb->exit = data->exit;
>  	pb->dev = &pdev->dev;
>  
> -	pb->pwm = devm_pwm_get(&pdev->dev, NULL);
> -	if (IS_ERR(pb->pwm)) {
> -		dev_err(&pdev->dev, "unable to request PWM, trying legacy API\n");
> -
> -		pb->pwm = pwm_request(data->pwm_id, "pwm-backlight");
> -		if (IS_ERR(pb->pwm)) {
> -			dev_err(&pdev->dev, "unable to request legacy PWM\n");
> -			ret = PTR_ERR(pb->pwm);
> -			goto err_alloc;
> -		}
> -	}
> -
> -	dev_dbg(&pdev->dev, "got pwm for backlight\n");
> -
> -	/*
> -	 * The DT case will set the pwm_period_ns field to 0 and store the
> -	 * period, parsed from the DT, in the PWM device. For the non-DT case,
> -	 * set the period from platform data.
> -	 */
> -	if (data->pwm_period_ns > 0)
> -		pwm_set_period(pb->pwm, data->pwm_period_ns);
> -
>  	pb->period = pwm_get_period(pb->pwm);
>  	pb->lth_brightness = data->lth_brightness * (pb->period / max);
>  
> @@ -267,8 +360,7 @@ static int pwm_backlight_remove(struct platform_device *pdev)
>  	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
>  
>  	backlight_device_unregister(bl);
> -	pwm_config(pb->pwm, 0, pb->period);
> -	pwm_disable(pb->pwm);
> +	pwm_backlight_off(bl);
>  	if (pb->exit)
>  		pb->exit(&pdev->dev);
>  	return 0;
> @@ -282,8 +374,7 @@ static int pwm_backlight_suspend(struct device *dev)
>  
>  	if (pb->notify)
>  		pb->notify(pb->dev, 0);
> -	pwm_config(pb->pwm, 0, pb->period);
> -	pwm_disable(pb->pwm);
> +	pwm_backlight_off(bl);
>  	if (pb->notify_after)
>  		pb->notify_after(pb->dev, 0);
>  	return 0;
> diff --git a/include/linux/pwm_backlight.h b/include/linux/pwm_backlight.h
> index 56f4a86..0dcec1d 100644
> --- a/include/linux/pwm_backlight.h
> +++ b/include/linux/pwm_backlight.h
> @@ -5,14 +5,28 @@
>  #define __LINUX_PWM_BACKLIGHT_H
>  
>  #include <linux/backlight.h>
> +#include <linux/power_seq.h>
>  
>  struct platform_pwm_backlight_data {
> -	int pwm_id;
>  	unsigned int max_brightness;
>  	unsigned int dft_brightness;
>  	unsigned int lth_brightness;
> -	unsigned int pwm_period_ns;
>  	unsigned int *levels;
> +	/*
> +	 * New interface using power sequences. Must include exactly
> +	 * two power sequences named 'power-on' and 'power-off'. If NULL,
> +	 * the legacy interface is used.
> +	 */
> +	struct platform_power_seq_set *power_seqs;
> +
> +	/*
> +	 * Legacy interface - use power sequences instead!
> +	 *
> +	 * pwm_id and pwm_period_ns need only be specified
> +	 * if get_pwm(dev, NULL) would return NULL.
> +	 */
> +	int pwm_id;
> +	unsigned int pwm_period_ns;
>  	int (*init)(struct device *dev);
>  	int (*notify)(struct device *dev, int brightness);
>  	void (*notify_after)(struct device *dev, int brightness);

Regards
Tony P

