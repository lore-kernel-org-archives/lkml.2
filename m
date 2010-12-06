Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0LFSOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:14:38 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61743 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0LFSOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:14:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JqjSSz5+JVl6d+7x9WBufNjR9u6y7bIlfKCRhGNJagb+txlNAO9UBUYT90lnmrCd2O
         z2Gglz1OY9XMQia9LUf4qE+8y0zoTV8l57b1tNwQaL39/pABWYZ6JceIX4EleKawJAbm
         EIV/6FccoP0yat4i+bMklloSxO1GQfyrreNt8=
Date: Mon, 6 Dec 2010 10:14:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Trilok Soni <tsoni@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC v1 PATCH 2/6] input: pm8058_keypad: Qualcomm PMIC8058
 keypad controller driver
Message-ID: <20101206181427.GA18567@core.coreip.homeip.net>
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

Hi Trilok,

On Wed, Nov 10, 2010 at 06:17:57PM +0530, Trilok Soni wrote:
> Add Qualcomm PMIC8058 based keypad controller driver
> supporting upto 18x8 matrix configuration.
> 

Looks very good, just a couple of small things:

> +
> +#include <linux/input/pmic8058-keypad.h>

Move to MFD directory with the rest of pmic8058 definitions?

> + */
> +struct pmic8058_kp {
> +	const struct pmic8058_keypad_data *pdata;
> +	struct input_dev *input;
> +	int key_sense_irq;
> +	int key_stuck_irq;
> +
> +	unsigned short *keycodes;

I'd pull the keycodes into this structure (at the end) so it can be
allocated in one shot. Hmm it even appears to be constant-sized. So just
declare it right here and be done with it.

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

> +
> +static int pmic8058_kpd_init(struct pmic8058_kp *kp)
> +{
> +	int bits, rc, cycles;
> +	u8 scan_val = 0, ctrl_val = 0;
> +	static u8 row_bits[] = {

const?

> +		0, 1, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7,
> +	};
> +
> +}
> +
> +static int pmic8058_kp_enable(struct pmic8058_kp *kp)
> +{
> +	int rc;
> +
> +	kp->ctrl_reg |= KEYP_CTRL_KEYP_EN;
> +
> +	rc = pmic8058_kp_write_u8(kp, kp->ctrl_reg, KEYP_CTRL);
> +	if (rc < 0)
> +		return rc;
> +
> +	enable_irq(kp->key_sense_irq);
> +	enable_irq(kp->key_stuck_irq);
> +
> +	return rc;
> +}
> +
> +static int pmic8058_kp_disable(struct pmic8058_kp *kp)
> +{
> +	int rc;
> +
> +	kp->ctrl_reg &= ~KEYP_CTRL_KEYP_EN;
> +
> +	rc = pmic8058_kp_write_u8(kp, kp->ctrl_reg, KEYP_CTRL);
> +	if (rc < 0)
> +		return rc;
> +
> +	disable_irq(kp->key_sense_irq);
> +	disable_irq(kp->key_stuck_irq);
> +
> +	return rc;
> +}
> +
> +static int pmic8058_kp_open(struct input_dev *dev)
> +{
> +	struct pmic8058_kp *kp = input_get_drvdata(dev);
> +
> +	return pmic8058_kp_enable(kp);
> +}
> +
> +static void pmic8058_kp_close(struct input_dev *dev)
> +{
> +	struct pmic8058_kp *kp = input_get_drvdata(dev);
> +
> +	pmic8058_kp_disable(kp);
> +}
> +

You need to protect suspend/resume from racing with open_close. Take
dev->mutex and act depending on whether there are users of the device.

> +	if (pdata->rows_gpio_start < 0 || pdata->cols_gpio_start < 0) {
> +		dev_err(&pdev->dev, "invalid gpio_start platform data\n");
> +		return -EINVAL;

These are declared as unsigned. Hmm, doesn't sparse catch it?

Thanks.

-- 
Dmitry
