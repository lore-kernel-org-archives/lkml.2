Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab0LGJWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 04:22:20 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8110 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0LGJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 04:22:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6189"; a="65778729"
Message-ID: <4CFDFCC3.5000700@codeaurora.org>
Date: Tue, 07 Dec 2010 14:52:11 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-arm-msm@vger.kernel.org
Subject: Re: [RFC v1 PATCH 2/6] input: pm8058_keypad: Qualcomm PMIC8058 keypad
 controller driver
References: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org> <1289393281-4459-3-git-send-email-tsoni@codeaurora.org> <20101206181427.GA18567@core.coreip.homeip.net>
In-Reply-To: <20101206181427.GA18567@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

On 12/6/2010 11:44 PM, Dmitry Torokhov wrote:
> Hi Trilok,
> 
> On Wed, Nov 10, 2010 at 06:17:57PM +0530, Trilok Soni wrote:
>> Add Qualcomm PMIC8058 based keypad controller driver
>> supporting upto 18x8 matrix configuration.
>>
> 
> Looks very good, just a couple of small things:

Thanks for reviewing same revision of the patch again :)

> 
>> +
>> +#include <linux/input/pmic8058-keypad.h>
> 
> Move to MFD directory with the rest of pmic8058 definitions?

As discussed earlier we can either have one big header file having all of the
sub-device(s) or have separate file for each sub-device driver, I need to check
which one would be better but I will atleast move pmic8058-keypad.h header
to "mfd" directory, as these patch series is in RFC state, we can have final
changes like along with when core-driver gets submitted for review.

> 
>> + */
>> +struct pmic8058_kp {
>> +	const struct pmic8058_keypad_data *pdata;
>> +	struct input_dev *input;
>> +	int key_sense_irq;
>> +	int key_stuck_irq;
>> +
>> +	unsigned short *keycodes;
> 
> I'd pull the keycodes into this structure (at the end) so it can be
> allocated in one shot. Hmm it even appears to be constant-sized. So just
> declare it right here and be done with it.

Done. You had already commented on it during the 1st review :)

> 
>> +
>> +static int pmic8058_detect_ghost_keys(struct pmic8058_kp *kp, u16 *new_state)
> 
> bool

Done.

> 
>> +{
>> +	int row, found_first = -1;
>> +	u16 check, row_state;
>> +
>> +	check = 0;
>> +	for (row = 0; row < kp->pdata->num_rows; row++) {
>> +		row_state = (~new_state[row]) &
>> +				 ((1 << kp->pdata->num_cols) - 1);
>> +
>> +		if (hweight16(row_state) > 1) {
>> +			if (found_first == -1)
>> +				found_first = row;
>> +			if (check & row_state) {
>> +				dev_dbg(kp->dev, "detected ghost key on row[%d]"
>> +					 " and row[%d]\n", found_first, row);
>> +				return 1;
> 
> true
> 
>> +			}
>> +		}
>> +		check |= row_state;
>> +	}
>> +	return 0;
> 
> false

Done.

> 
>> +
>> +static int pmic8058_kpd_init(struct pmic8058_kp *kp)
>> +{
>> +	int bits, rc, cycles;
>> +	u8 scan_val = 0, ctrl_val = 0;
>> +	static u8 row_bits[] = {
> 
> const?
> 
>> +		0, 1, 2, 3, 4, 4, 5, 5, 6, 6, 6, 7, 7, 7,
>> +	};

Sure.

>> +
>> +static int pmic8058_kp_open(struct input_dev *dev)
>> +{
>> +	struct pmic8058_kp *kp = input_get_drvdata(dev);
>> +
>> +	return pmic8058_kp_enable(kp);
>> +}
>> +
>> +static void pmic8058_kp_close(struct input_dev *dev)
>> +{
>> +	struct pmic8058_kp *kp = input_get_drvdata(dev);
>> +
>> +	pmic8058_kp_disable(kp);
>> +}
>> +
> 
> You need to protect suspend/resume from racing with open_close. Take
> dev->mutex and act depending on whether there are users of the device.

Sure.

> 
>> +	if (pdata->rows_gpio_start < 0 || pdata->cols_gpio_start < 0) {
>> +		dev_err(&pdev->dev, "invalid gpio_start platform data\n");
>> +		return -EINVAL;
> 
> These are declared as unsigned. Hmm, doesn't sparse catch it?

I will fix it.

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
