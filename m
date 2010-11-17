Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935221Ab0KQSCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:02:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53260 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935136Ab0KQSCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OeViLBEw8RuQBDUkUqG96yCVxnIvRYVNl9m665RsThX49BaVstaJiC3ka0wYuPi6m1
         tgRcfHLwlK5dqxiBsgnnEKmWjv1x6d+LbD0fdt6L0EqscOF0hgjE5Mh18s4VRTurNsQu
         pRdAImjydG3TP+dfad6wGxSMVPh9gPdKvGHr4=
Date: Wed, 17 Nov 2010 10:02:40 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <tsoni@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC v1 PATCH 2/6] input: pm8058_keypad: Qualcomm PMIC8058
 keypad controller driver
Message-ID: <20101117180240.GC6148@core.coreip.homeip.net>
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org>
 <1289393281-4459-3-git-send-email-tsoni@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289393281-4459-3-git-send-email-tsoni@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 06:17:57PM +0530, Trilok Soni wrote:
> Add Qualcomm PMIC8058 based keypad controller driver
> supporting upto 18x8 matrix configuration.
> 

Looks good, just a couple of nitpicks:

> +struct pmic8058_kp {
> +	const struct pmic8058_keypad_data *pdata;
> +	struct input_dev *input;
> +	int key_sense_irq;
> +	int key_stuck_irq;
> +
> +	unsigned short *keycodes;

Since the size of keycode table is constant there is no need to allocate
it separately (and even if it was variable you still could move it to
the end of the structure and allocate together).

> +
> +static int pmic8058_detect_ghost_keys(struct pmic8058_kp *kp, u16 *new_state)

bool

> +{
> +	int row, found_first = -1;
> +	u16 check, row_state;
> +
> +	check = 0;
> +	for (row = 0; row < kp->pdata->num_rows; row++) {
> +		row_state = (~new_state[row]) &
> +				 ((1 << kp->pdata->num_cols) - 1);
> +
> +		if (hweight16(row_state) > 1) {
> +			if (found_first == -1)
> +				found_first = row;
> +			if (check & row_state) {
> +				dev_dbg(kp->dev, "detected ghost key on row[%d]"
> +					 " and row[%d]\n", found_first, row);
> +				return 1;

true

> +			}
> +		}
> +		check |= row_state;
> +	}
> +	return 0;

false

> +static int __devinit pmic8058_kp_probe(struct platform_device *pdev)
> +{
> +	struct pmic8058_keypad_data *pdata = pdev->dev.platform_data;
> +	const struct matrix_keymap_data *keymap_data;
> +	struct pmic8058_kp *kp;
> +	int rc;
> +	unsigned short *keycodes;
> +	u8 ctrl_val;
> +	struct pm8058_chip	*pm_chip;
> +
> +	pm_chip = platform_get_drvdata(pdev);
> +	if (pm_chip == NULL) {
> +		dev_err(&pdev->dev, "no parent data passed in\n");
> +		return -EFAULT;

EFAULT is really odd, maybe -EINVAL?

> +	}
> +
> +	/* Check PMIC8058 version. A0 version is not supported */
> +	if (pm8058_rev(pm_chip) == PM_8058_REV_1p0) {
> +		dev_err(&pdev->dev, "PMIC8058 1.0 version is not supported\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!pdata || !pdata->num_cols || !pdata->num_rows ||
> +		pdata->num_cols > PM8058_MAX_COLS ||
> +		pdata->num_rows > PM8058_MAX_ROWS ||
> +		pdata->num_cols < PM8058_MIN_COLS ||
> +		pdata->num_rows < PM8058_MIN_ROWS) {
> +		dev_err(&pdev->dev, "invalid platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	if (pdata->rows_gpio_start < 0 || pdata->cols_gpio_start < 0) {
> +		dev_err(&pdev->dev, "invalid gpio_start platform data\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!pdata->scan_delay_ms || pdata->scan_delay_ms > MAX_SCAN_DELAY
> +		|| pdata->scan_delay_ms < MIN_SCAN_DELAY ||
> +		!is_power_of_2(pdata->scan_delay_ms)) {
> +		dev_err(&pdev->dev, "invalid keypad scan time supplied\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!pdata->row_hold_ns || pdata->row_hold_ns > MAX_ROW_HOLD_DELAY
> +		|| pdata->row_hold_ns < MIN_ROW_HOLD_DELAY ||
> +		((pdata->row_hold_ns % MIN_ROW_HOLD_DELAY) != 0)) {
> +		dev_err(&pdev->dev, "invalid keypad row hold time supplied\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!pdata->debounce_ms
> +		|| ((pdata->debounce_ms % 5) != 0)
> +		|| pdata->debounce_ms > MAX_DEBOUNCE_TIME
> +		|| pdata->debounce_ms < MIN_DEBOUNCE_TIME) {
> +		dev_err(&pdev->dev, "invalid debounce time supplied\n");

Mixing style (logical || either in front of expression or after), please use
same style (and I prefer after).


> +		return -EINVAL;
> +	}
> +
> +	keymap_data = pdata->keymap_data;
> +	if (!keymap_data) {
> +		dev_err(&pdev->dev, "no keymap data supplied\n");
> +		return -EINVAL;
> +	}
> +
> +	kp = kzalloc(sizeof(*kp), GFP_KERNEL);
> +	if (!kp)
> +		return -ENOMEM;
> +
> +	keycodes = kzalloc(PM8058_MATRIX_MAX_SIZE * sizeof(*keycodes),
> +				 GFP_KERNEL);
> +	if (!keycodes) {
> +		rc = -ENOMEM;
> +		goto err_alloc_mem;
> +	}
> +
> +	platform_set_drvdata(pdev, kp);
> +
> +	kp->pdata	= pdata;
> +	kp->dev		= &pdev->dev;
> +	kp->keycodes	= keycodes;
> +	kp->pm_chip	= pm_chip;
> +
> +	kp->input = input_allocate_device();
> +	if (!kp->input) {
> +		dev_err(&pdev->dev, "unable to allocate input device\n");
> +		rc = -ENOMEM;
> +		goto err_alloc_device;
> +	}
> +
> +	kp->key_sense_irq = platform_get_irq(pdev, 0);
> +	if (kp->key_sense_irq < 0) {
> +		dev_err(&pdev->dev, "unable to get keypad sense irq\n");
> +		rc = -ENXIO;
> +		goto err_get_irq;
> +	}
> +
> +	kp->key_stuck_irq = platform_get_irq(pdev, 1);
> +	if (kp->key_stuck_irq < 0) {
> +		dev_err(&pdev->dev, "unable to get keypad stuck irq\n");
> +		rc = -ENXIO;
> +		goto err_get_irq;
> +	}
> +
> +	if (pdata->input_name)
> +		kp->input->name = pdata->input_name;
> +	else
> +		kp->input->name = "PMIC8058 keypad";
> +
> +	if (pdata->input_phys_device)
> +		kp->input->phys = pdata->input_phys_device;
> +	else
> +		kp->input->phys = "pmic8058_keypad/input0";

	kp->input->phys = pdata->input_phys_device ?: "pmic8058_keypad/input0";

Is shorter.

Thanks.

-- 
Dmitry
