Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab0E2Uev (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 16:34:51 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:42537 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754841Ab0E2Uet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 16:34:49 -0400
Message-ID: <4C017A5D.6060706@euromail.se>
Date: Sat, 29 May 2010 22:34:37 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Christopher Heiny <cheiny@synaptics.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <wmanson@synaptics.com>
Subject: Re: [RFC PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver
References: <1275092980-29208-1-git-send-email-cheiny@synaptics.com> <1275092980-29208-2-git-send-email-cheiny@synaptics.com>
In-Reply-To: <1275092980-29208-2-git-send-email-cheiny@synaptics.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OISju-0006ld-5z.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OISju-0006ld-5z aadd35fc9dd2df1061236367e7b4d8d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher Heiny wrote:
> Initial driver for Synaptics touchscreens using RMI4 protocol.
> 
> Signed-off-by: William Manson <WManson@synaptics.com>
> Signed-off-by: Allie Xiong <axiong@synaptics.com>
> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>
> ---

Thank you for this driver. Some scattered comments on the MT parts below.

Henrik

[...]
> +int FN_11_report(struct rmi_application *app,
> +		struct rmi_function_info *rfi, struct input_dev *input)
> +{
> +	unsigned char values[2] = {0, 0};
> +	unsigned char data[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
> +	/* number of touch points - fingers down in this case */
> +	int fingerDownCount;
> +	int X, Y, Z, W, Wy, Wx;
> +	int finger;
> +	int fn11FingersSupported;
> +	int fn11FingerRegisters;
> +	unsigned short fn11DataBaseAddr;
> +	unsigned char fn11DataRegBlockSize;
> +	static bool wasdown;
> +
> +	fingerDownCount = 0;
> +
> +	/* get 2D sensor finger data */
> +
> +	/* First get the finger status field - the size of the finger status
> +	field is determined by the number of finger supporte - 2 bits per
> +	finger, so the number of registers to read is:
> +		registerCount = ceil(numberOfFingers/4).
> +	Read the required number of registers and check each 2 bit field to
> +	determine if a finger is down:
> +		00 = finger not present,
> +		01 = finger present and data accurate,
> +		10 = finger present but data may not be accurate,
> +		11 = reserved for product use.
> +	*/
> +	fn11FingersSupported = rfi->numDataPoints;
> +	fn11FingerRegisters = (fn11FingersSupported + 3)/4;
> +
> +	fn11DataBaseAddr = rfi->funcDescriptor.dataBaseAddr;
> +
> +	if (rmi_read_multiple(app, fn11DataBaseAddr, values,
> +			fn11FingerRegisters)) {
> +		printk(KERN_ERR "%s: RMI4 function $11 report: "
> +			"Could not read finger status registers 0x%x\n",
> +			__func__, fn11DataBaseAddr);
> +		return 0;

The in-kernel rmi interface seems to expect the number of touches to be returned
here, but it does not seem to be used anywhere. Would it not be more useful to
return zero on success, and error codes on failure?

> +	}
> +
> +	/* For each finger present, read the proper number of registers
> +	to get absolute data. */
> +	fn11DataRegBlockSize = rfi->dataRegBlockSize;
> +
> +	for (finger = 0; finger < fn11FingersSupported; finger++) {
> +		int reg;
> +		int fingerShift;
> +		int fingerStatus;
> +
> +		/* determine which data byte the finger status is in */
> +		reg = finger/4;
> +		/* bit shift to get finger's status */
> +		fingerShift = (finger % 4) * 2;
> +		fingerStatus = (values[reg] >> fingerShift) & 3;
> +
> +		/* if finger status indicates a finger is present then
> +		read the finger data and report it */
> +		if (fingerStatus == 1 || fingerStatus == 2) {
> +			/* number of active touch points not same as
> +			number of supported fingers */
> +			fingerDownCount++;
> +
> +			/* Read the finger data */
> +			if (rmi_read_multiple(app, fn11DataBaseAddr +
> +					((finger  * fn11DataRegBlockSize) +
> +					fn11FingerRegisters),
> +					data, fn11DataRegBlockSize)) {
> +				printk(KERN_ERR "%s: RMI4 function $11 report: "
> +					"Could not read finger data registers "
> +					"0x%x\n", __func__,
> +					fn11DataBaseAddr +
> +					((finger  * fn11DataRegBlockSize) +
> +					fn11FingerRegisters));
> +				return 0;

Bailing out without finishing off the input packet...

> +			} else {
> +				X = (data[0] & 0x1f) << 4;
> +				X |= data[2] & 0xf;
> +				Y = (data[1] & 0x1f) << 4;
> +				Y |= (data[2] >> 4) & 0xf;
> +				W = data[3];
> +
> +				/* upper 4 bits of W are Wy,
> +				lower 4 of W are Wx */
> +				Wy =  (W >> 4) & 0x0f;
> +				Wx = W & 0x0f;
> +
> +				Z = data[4];
> +
> +				/* if this is the first finger report normal
> +				ABS_X, ABS_Y, PRESSURE, TOOL_WIDTH events for
> +				non-MT apps. Apps that support Multi-touch
> +				will ignore these events and use the MT events.
> +				Apps that don't support Multi-touch will still
> +				function.
> +				*/
> +				if (fingerDownCount == 1) {
> +					input_report_abs(input, ABS_X, X);
> +					input_report_abs(input, ABS_Y, Y);
> +					input_report_abs(input, ABS_PRESSURE,
> +							Z);
> +					input_report_abs(input, ABS_TOOL_WIDTH,
> +							max(Wx, Wy));
> +					input_report_key(input, BTN_TOUCH, 1);
> +					wasdown = true;
> +				}
> +
> +				/* Report Multi-Touch events for each finger */
> +				/* major axis of touch area ellipse */
> +				input_report_abs(input, ABS_MT_TOUCH_MAJOR,
> +						max(Wx, Wy));
> +				/* minor axis of touch area ellipse */
> +				input_report_abs(input, ABS_MT_TOUCH_MINOR,
> +						min(Wx, Wy));
> +				/* Currently only 2 supported - 1 or 0 */
> +				input_report_abs(input, ABS_MT_ORIENTATION,
> +						(Wx > Wy ? 1 : 0));
> +				input_report_abs(input, ABS_MT_POSITION_X, X);
> +				input_report_abs(input, ABS_MT_POSITION_Y, Y);
> +				/* Tracking ID reported but not used yet */
> +				input_report_abs(input, ABS_MT_TRACKING_ID,
> +						finger+1);

The tracking id used here is not entirely proper, since the id seems to be
reused too often.

Does the position in the finger array (0..fn11FingersSupported) really track an
identified contact, as suggested by the code? If so, a proper tracking id could
be formed by keeping an id per position, and assigning a new id when the
fingerStatus changes for that position.

> +				/* MT sync between fingers */
> +				input_mt_sync(input);
> +			}
> +		}
> +	}
> +
> +	if (fingerDownCount) {
> +		/* touch will be non-zero if we had any reported events */
> +		input_sync(input); /* sync after groups of events */
> +	} else {
> +		/* if we had a finger down before and now we don't have
> +		any we need to send a button up and a sync. */
> +		if (wasdown) {
> +			wasdown = false;
> +			input_report_key(input, BTN_TOUCH, 0);
> +			input_sync(input); /* sync after groups of events */
> +		}
> +	}

input_sync() should always be called at the end, regardless. If nothing changed,
the input core will filter it out.

> +
> +	/* return the number of touch points: fingers down or buttons pressed */
> +	return fingerDownCount;
> +}

