Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab2FYEs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 00:48:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61125 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2FYEsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 00:48:25 -0400
X-AuditID: cbfee612-b7fbe6d000007898-03-4fe7ed9745bb
Date: Mon, 25 Jun 2012 04:48:23 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] Extcon: Arizona: Add driver for Wolfson Arizona class
 devices
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Cc: "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120625043812733@myungjoo.ham
Msgkey: 20120625043812733@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120625043812733@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <14300735.10471340599701741.JavaMail.weblogic@epv6ml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t/t6brT3z73N/i+UMHi8q45bA6MHp83
	yQUwRnHZpKTmZJalFunbJXBlnLisX7BNp6Jx12SWBsYF2l2MnBxCAuoSi5acZAOxJQRMJNYs
	ecAEYYtJXLi3HijOBVQzn1FiYucmRpAEi4CqxPc3n9i7GDk42ATMJe7PCAIJCwsESWw/voAF
	pF5EYA2jxN6fO5hBHGaBCYwSp6ZuZ4fYpiSxZt8rFhCbV0BQ4uTMJywQ21QldnZtYoKIq0lc
	+bSfFSIuITFr+gUom1diRvtTqHo5iWlf1zBD2NIS52dtYIS5evH3x1Bxfoljt3cwgRwK0vvk
	fjDMmN2bv0A9LCAx9cxBqFYtiU/vT0Ot4pNYs/AtC8yYXaeWg41kFlCUmNL9kB3C1pL48mMf
	G7pXeAWcJb7+Wcc4gVF2FpLULCTts5C0I6tZwMiyilE0tSC5oDgpPdVCrzgxt7g0L10vOT93
	EyM4np8J7WBc1mBxiFGAg1GJh3f7m+f+QqyJZcWVuYcYJTiYlUR4k8uBQrwpiZVVqUX58UWl
	OanFhxilOViUxHn7rC/4CwmkJ5akZqemFqQWwWSZODilGhhdj777uDjgHOtB08OfD2icUPz9
	j9dnkfvEcIFlmv+9khwWB8UXOWXHGF7RzxAJ8113rtpZMffM1bUa8elHl6SWnZHyko685Z6x
	T9v28X7NQt2vCnPYX28rWu/butbowqIin0WMerO3qU1YGHKr7ub6Y7N5mn6sO1V1enXDgfAY
	njYuiy07JTOVWIozEg21mIuKEwFVkcD74wIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5P4mWMr028667

> Most Wolfson Arizona class audio hub CODECs include a flexible ultra low
> power accessory detection subsystem. This driver exposes initial support
> for this subsystem via the Extcon framework, implementing support for
> ultra low power detection of headphone and headset with the ability to
> detect the polarity of a headset.
> 
> The functionality of the devices is much richer and more flexible than
> the current driver, future patches will extend the features of the
> driver to more fully exploit this.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Hello,

> +static void arizona_start_mic(struct arizona_extcon_info *info)
> +{
> +	struct arizona *arizona = info->arizona;
> +	bool change;
> +	int ret;
> +
> +	info->detecting = true;
> +	info->mic = false;
> +	info->jack_flips = 0;
> +
> +	/* Microphone detection can't use idle mode */
> +	pm_runtime_get(info->dev);

Is it alright to use asynchronous get here?
(sync not required?)

> +
> +	ret = regulator_enable(info->micvdd);
> +	if (ret != 0) {
> +		dev_err(arizona->dev, "Failed to enable MICVDD: %d\n",
> +			ret);
> +	}
> +
> +	if (info->micd_reva) {
> +		regmap_write(arizona->regmap, 0x80, 0x3);
> +		regmap_write(arizona->regmap, 0x294, 0);
> +		regmap_write(arizona->regmap, 0x80, 0x0);
> +	}
> +
> +	regmap_update_bits_check(arizona->regmap, ARIZONA_MIC_DETECT_1,
> +				 ARIZONA_MICD_ENA, ARIZONA_MICD_ENA,
> +				 &change);
> +	if (!change) {
> +		regulator_disable(info->micvdd);
> +		pm_runtime_put_autosuspend(info->dev);
> +	}
> +}
> +

[]

> +static int __devinit arizona_extcon_probe(struct platform_device *pdev)
> +{
> +	struct arizona *arizona = dev_get_drvdata(pdev->dev.parent);
> +	struct arizona_pdata *pdata;
> +	struct arizona_extcon_info *info;
> +	int ret, mode;
> +
> +	pdata = dev_get_platdata(arizona->dev);
> +
> +	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
> +	if (!info) {
> +		dev_err(&pdev->dev, "failed to allocate memory\n");
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	info->micvdd = devm_regulator_get(arizona->dev, "MICVDD");
> +	if (IS_ERR(info->micvdd)) {
> +		ret = PTR_ERR(info->micvdd);
> +		dev_err(arizona->dev, "Failed to get MICVDD: %d\n", ret);
> +		goto err;
> +	}
> +
> +	mutex_init(&info->lock);
> +	info->arizona = arizona;
> +	info->dev = &pdev->dev;
> +	info->detecting = true;
> +	platform_set_drvdata(pdev, info);
> +
> +	switch (arizona->type) {
> +	case WM5102:
> +		switch (arizona->rev) {
> +		case 0:
> +			info->micd_reva = true;
> +			break;
> +		default:
> +			break;
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	info->edev.name = "Headset Jack";
> +	info->edev.supported_cable = arizona_cable;
> +	info->edev.mutually_exclusive = arizona_exclusions;
> +
> +	ret = extcon_dev_register(&info->edev, arizona->dev);
> +	if (ret < 0) {
> +		dev_err(arizona->dev, "extcon_dev_regster() failed: %d\n",
> +			ret);
> +		goto err;
> +	}
> +
> +	if (pdata->num_micd_configs) {
> +		info->micd_modes = pdata->micd_configs;
> +		info->micd_num_modes = pdata->num_micd_configs;
> +	} else {
> +		info->micd_modes = micd_default_modes;
> +		info->micd_num_modes = ARRAY_SIZE(micd_default_modes);
> +	}
> +
> +	if (arizona->pdata.micd_pol_gpio > 0) {
> +		if (info->micd_modes[0].gpio)
> +			mode = GPIOF_OUT_INIT_HIGH;
> +		else
> +			mode = GPIOF_OUT_INIT_LOW;
> +
> +		ret = devm_gpio_request_one(&pdev->dev,
> +					    arizona->pdata.micd_pol_gpio,
> +					    mode,
> +					    "MICD polarity");
> +		if (ret != 0) {
> +			dev_err(arizona->dev, "Failed to request GPIO%d: %d\n",
> +				arizona->pdata.micd_pol_gpio, ret);
> +			goto err_register;
> +		}
> +	}
> +
> +	arizona_extcon_set_mode(info, 0);
> +
> +	pm_runtime_enable(&pdev->dev);
> +	pm_runtime_idle(&pdev->dev);
> +	pm_runtime_get_sync(&pdev->dev);
> +
> +	ret = arizona_request_irq(arizona, ARIZONA_IRQ_JD_RISE,
> +				  "JACKDET rise", arizona_jackdet, info);

Is this arizone_request_irq using threaded irq? (it's fine if so)


Cheers!
MyungJoo.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
