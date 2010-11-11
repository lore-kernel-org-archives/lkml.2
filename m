Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0KKMPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:15:37 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52193 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab0KKMPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:15:34 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6163"; a="61578230"
Message-ID: <4CDBDE5D.4040801@codeaurora.org>
Date: Thu, 11 Nov 2010 17:45:25 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [RFC v1 PATCH 3/6] led: pmic8058: Add PMIC8058 leds driver
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-4-git-send-email-tsoni@codeaurora.org> <4CDB0451.3090303@metafoo.de>
In-Reply-To: <4CDB0451.3090303@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

>> +struct pmic8058_led_data {
>> +	struct led_classdev	cdev;
>> +	int			id;
> "enum pmic8058_leds" instead of int

Ack.

>> +	enum led_brightness	brightness;
>> +	struct pm8058_chip	*pm_chip;
>> +	struct work_struct	work;
>> +	struct mutex		lock;
>> +	spinlock_t		value_lock;
>> +	u8			reg_kp;
>> +	u8			reg_led_ctrl[3];
>> +	u8			reg_flash_led0;
>> +	u8			reg_flash_led1;
> 
> You allocate a separate pmic8058_led_data for each led, so one "u8 reg" should be
> sufficient.

Agree. I will check and update.

> 
>> +};
>> +
>> +#define PM8058_MAX_LEDS		7
>> +
>> +static void led_kp_set(struct pmic8058_led_data *led, enum led_brightness value)
>> +{
>> +	int rc;
>> +	u8 level;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&led->value_lock, flags);
> This function is only ever called from within the workqueue so there is no need for
> locking.

There is a historical reason here, but not application to upstream. You can see that we
have flash_drv lines also for flash leds in this code, which is used to drive
the camera flash leds. The core problem here is that there is no "camera flash" framework
in the v4l2 which could drive these pins from the kernel space, so internally we had
to also export this _set functions so that v4l2 drivers can use them to control
the brightness of the camera flash.

Looking at another way, you can use all of these low level leds, flash leds and keyboard
leds drive strengths by combining them into the h/w and driver single camera flash requiring
around 990mA of current.

I could remove these spin locks from this code though, as we don't have generic solution
in upstream to handle in-kernel usage of LED apis.


>> +
>> +static enum led_brightness led_kp_get(struct pmic8058_led_data *led)
>> +{
>> +	if ((led->reg_kp & PM8058_DRV_KEYPAD_BL_MASK) >>
>> +			 PM8058_DRV_KEYPAD_BL_SHIFT)
>> +		return LED_FULL;
>> +	else
>> +		return LED_OFF;
>> +}
>> +
> 
> Shouldn't you be returning the actual brightness here instead of only either on or
> off? The brightness is btw. stored in led->brightness, so you can use the same getter
> for all three types of leds.

Ack.

> 
> 
>> +static void led_lc_set(struct pmic8058_led_data *led, enum led_brightness value)
>> +{
>> +	unsigned long flags;
>> +	int rc, offset;
>> +	u8 level, tmp;
>> +
>> +	spin_lock_irqsave(&led->value_lock, flags);
> This function is only ever called from within the workqueue so there is no need for
> locking.

As pointed above. Ack.

>> +
>> +static void pmic8058_led_work(struct work_struct *work)
>> +{
>> +	struct pmic8058_led_data *led = container_of(work,
>> +					 struct pmic8058_led_data, work);
>> +
>> +	mutex_lock(&led->lock);
>> +
> Since this is a workqueue and there will only one running instance per led at a time
> there is no need to take a lock here.

I will check this. 

>> +
>> +static void pmic8058_led_set(struct led_classdev *led_cdev,
>> +	enum led_brightness value)
>> +{
>> +	struct pmic8058_led_data *led;
>> +	unsigned long flags;
>> +
>> +	led = container_of(led_cdev, struct pmic8058_led_data, cdev);
>> +
>> +	spin_lock_irqsave(&led->value_lock, flags);
> Locking is not really required here since it is only a single assignment...
>> +	led->brightness = value;
>> +	schedule_work(&led->work);
> and scheudule_work does not have to be inside of the lock.
>> +	spin_unlock_irqrestore(&led->value_lock, flags);

locks will go away.

>> +}
>> +
>> +static enum led_brightness pmic8058_led_get(struct led_classdev *led_cdev)
>> +{
>> +	struct pmic8058_led_data *led;
>> +
>> +	led = container_of(led_cdev, struct pmic8058_led_data, cdev);
> return led->brightness; (See above)

Ack.

>> +
>> +static int pmic8058_led_probe(struct platform_device *pdev)
> __devinit

Ack.

>> +
>> +	pm_chip = platform_get_drvdata(pdev);
> This looks at least a bit bogus since you'll overwrite the drvdata later. Can't you
> get the pm8058_chip through pdev->dev.parent somehow?

I will update this once the PMIC8058 core driver gets updated.

>> +	if (pm_chip == NULL) {
>> +		dev_err(&pdev->dev, "no parent data passed in\n");
>> +		return -EFAULT;
> -EINVAL

Sure. 

>> +
>> +	if (pdata->num_leds > PMIC8058_MAX_LEDS) {
>> +		dev_err(&pdev->dev, "can't handle more than %d LEDS\n",
>> +				 PMIC8058_MAX_LEDS);
>> +		return -EFAULT;
> -EINVAL

Ack.

>> +	}
>> +
>> +	led = kzalloc(sizeof(*led) * pdata->num_leds, GFP_KERNEL);
> Use kcalloc instead of kzalloc.

Ok.

>> +
>> +	rc = pm8058_read(pm_chip, SSBI_REG_ADDR_DRV_KEYPAD, &reg_kp,
>> +				1);
>> +	if (rc) {
>> +		dev_err(&pdev->dev, "can't get keypad backlight level\n");
>> +		goto err_reg_read;
>> +	}
>> +
>> +	rc = pm8058_read(pm_chip, SSBI_REG_ADDR_LED_CTRL_BASE,
>> +			reg_led_ctrl, 3);
>> +	if (rc) {
>> +		dev_err(&pdev->dev, "can't get led levels\n");
>> +		goto err_reg_read;
>> +	}
>> +
>> +	rc = pm8058_read(pm_chip, SSBI_REG_ADDR_FLASH_DRV0,
>> +			&reg_flash_led0, 1);
>> +	if (rc) {
>> +		dev_err(&pdev->dev, "can't read flash led0\n");
>> +		goto err_reg_read;
>> +	}
>> +
>> +	rc = pm8058_read(pm_chip, SSBI_REG_ADDR_FLASH_DRV1,
>> +			&reg_flash_led1, 1);
>> +	if (rc) {
>> +		dev_err(&pdev->dev, "can't get flash led1\n");
>> +		goto err_reg_read;
>> +	}
> How about adding a helper function which will initializes the leds 'reg' field
> depending on its id? It will certainly to improve code readability.

Sure. I will add it.

>> +
>> +static int __devexit pmic8058_led_remove(struct platform_device *pdev)
>> +{
>> +	int i;
>> +	struct pmic8058_leds_platform_data *pdata = pdev->dev.platform_data;
>> +	struct pmic8058_led_data *led = platform_get_drvdata(pdev);
>> +
>> +	for (i = 0; i < pdata->num_leds; i++) {
>> +		mutex_destroy(&led[led->id].lock);
>> +		led_classdev_unregister(&led[led->id].cdev);
>> +		cancel_work_sync(&led[led->id].work);
>> +	}
> 
> You need to free the 'led' array.

Thanks. Missed it.

>> +
>> +/**
>> + * struct pmic8058_led - per led data
>> + * @name - name of the led
>> + * @default_trigger - default trigger which needs to e attached
>> + * @max_brightness - maximum brightness level supported by the led
>> + * @id - supported led id
>> + */
>> +struct pmic8058_led {
>> +	const char	*name;
>> +	const char	*default_trigger;
>> +	unsigned	max_brightness;
> Should max_brightness not rather be hardcoded in the driver? As far as I can tell it
> depend on the hardware and is 4 bits wide for flash and bl leds and 5 bits for the
> others.
>> +	int		id;
> 
> enum pmic8058_leds instead of int

Ack.

>> +struct pmic8058_leds_platform_data {
>> +	int			num_leds;
> size_t

Ack.

>> +	struct pmic8058_led	*leds;
>> +};
> 
> 
> If max_brightness is hardcoded in the driver you can reuse "struct led_info" and
> "struct struct led_platform_data" instead of adding your own structs.

I will check this and see if I can add it in next version.

Thanks for the review. 

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
