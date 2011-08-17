Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab1HQRbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 13:31:23 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59751 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1HQRbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 13:31:20 -0400
Date: Wed, 17 Aug 2011 10:31:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Henrik Rydberg <rydberg@euromail.se>,
        Chase Douglas <chase.douglas@canonical.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Huang <aaron_huang@emc.com.tw>, JJ Ding <jj_ding@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>
Subject: Re: [PATCH] Input: elantech - Add v3 hardware support
Message-ID: <20110817173111.GD4877@core.coreip.homeip.net>
References: <1313589793-31184-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313589793-31184-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Wed, Aug 17, 2011 at 09:03:13AM -0500, Seth Forshee wrote:
> Adds basic v3 hardware support for newer devices not currently
> supported by the driver.
> 
> Thanks to Tom Lin <tom_lin@emc.com.tw> and Mark A. Stratman
> <stratman@gmail.com>, whose work on a previous patch revealed many
> of the details of the v3 protocol.

Excellent work, thank you.

Apparently Elantech is now also interested in supporting ther devices
on Linux and is preparing some patches adding support for the new
hardware so it woudl be great if we coordinated efforts. I am CC-ing
JJ Ding and Aaron Huang...

Thanks.

> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/input/mouse/elantech.c |  255 ++++++++++++++++++++++++++++++++++------
>  drivers/input/mouse/elantech.h |    4 +
>  2 files changed, 223 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
> index 3250356..e708a75 100644
> --- a/drivers/input/mouse/elantech.c
> +++ b/drivers/input/mouse/elantech.c
> @@ -22,6 +22,10 @@
>  #include "psmouse.h"
>  #include "elantech.h"
>  
> +#define FW_VERSION_MAJOR_MASK	0xff0000
> +#define FW_VERSION_MINOR_MASK	0x00ff00
> +#define FW_VERSION_MICRO_MASK	0x0000ff
> +
>  #define elantech_debug(fmt, ...)					\
>  	do {								\
>  		if (etd->debug)						\
> @@ -82,6 +86,7 @@ static int elantech_read_reg(struct psmouse *psmouse, unsigned char reg,
>  {
>  	struct elantech_data *etd = psmouse->private;
>  	unsigned char param[3];
> +	unsigned char command;
>  	int rc = 0;
>  
>  	if (reg < 0x10 || reg > 0x26)
> @@ -90,9 +95,11 @@ static int elantech_read_reg(struct psmouse *psmouse, unsigned char reg,
>  	if (reg > 0x11 && reg < 0x20)
>  		return -1;
>  
> +	command = (etd->hw_version == 3) ? ETP_REGISTER_RW : ETP_REGISTER_READ;
> +
>  	switch (etd->hw_version) {
>  	case 1:
> -		if (psmouse_sliced_command(psmouse, ETP_REGISTER_READ) ||
> +		if (psmouse_sliced_command(psmouse, command) ||
>  		    psmouse_sliced_command(psmouse, reg) ||
>  		    ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO)) {
>  			rc = -1;
> @@ -100,8 +107,9 @@ static int elantech_read_reg(struct psmouse *psmouse, unsigned char reg,
>  		break;
>  
>  	case 2:
> +	case 3:
>  		if (elantech_ps2_command(psmouse,  NULL, ETP_PS2_CUSTOM_COMMAND) ||
> -		    elantech_ps2_command(psmouse,  NULL, ETP_REGISTER_READ) ||
> +		    elantech_ps2_command(psmouse,  NULL, command) ||
>  		    elantech_ps2_command(psmouse,  NULL, ETP_PS2_CUSTOM_COMMAND) ||
>  		    elantech_ps2_command(psmouse,  NULL, reg) ||
>  		    elantech_ps2_command(psmouse, param, PSMOUSE_CMD_GETINFO)) {
> @@ -125,6 +133,7 @@ static int elantech_write_reg(struct psmouse *psmouse, unsigned char reg,
>  				unsigned char val)
>  {
>  	struct elantech_data *etd = psmouse->private;
> +	unsigned char command;
>  	int rc = 0;
>  
>  	if (reg < 0x10 || reg > 0x26)
> @@ -133,9 +142,11 @@ static int elantech_write_reg(struct psmouse *psmouse, unsigned char reg,
>  	if (reg > 0x11 && reg < 0x20)
>  		return -1;
>  
> +	command = (etd->hw_version == 3) ? ETP_REGISTER_RW : ETP_REGISTER_WRITE;
> +
>  	switch (etd->hw_version) {
>  	case 1:
> -		if (psmouse_sliced_command(psmouse, ETP_REGISTER_WRITE) ||
> +		if (psmouse_sliced_command(psmouse, command) ||
>  		    psmouse_sliced_command(psmouse, reg) ||
>  		    psmouse_sliced_command(psmouse, val) ||
>  		    ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSCALE11)) {
> @@ -145,7 +156,7 @@ static int elantech_write_reg(struct psmouse *psmouse, unsigned char reg,
>  
>  	case 2:
>  		if (elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
> -		    elantech_ps2_command(psmouse, NULL, ETP_REGISTER_WRITE) ||
> +		    elantech_ps2_command(psmouse, NULL, command) ||
>  		    elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
>  		    elantech_ps2_command(psmouse, NULL, reg) ||
>  		    elantech_ps2_command(psmouse, NULL, ETP_PS2_CUSTOM_COMMAND) ||
> @@ -164,6 +175,41 @@ static int elantech_write_reg(struct psmouse *psmouse, unsigned char reg,
>  }
>  
>  /*
> + * Set the elantech touchpad mode byte via special commands
> + */
> +static int elantech_mode_command(struct psmouse *psmouse, unsigned char reg,
> +				unsigned char val)
> +{
> +	struct elantech_data *etd = psmouse->private;
> +	unsigned char param[3];
> +	int write_cmd, read_cmd;
> +
> +	if (etd->hw_version == 3) {
> +		write_cmd = ETP_REGISTER_RW;
> +		read_cmd = ETP_REGISTER_RW;
> +	} else {
> +		write_cmd = ETP_REGISTER_READ;
> +		read_cmd = ETP_REGISTER_WRITE;
> +	}
> +
> +	if (psmouse_sliced_command(psmouse, write_cmd) ||
> +	    psmouse_sliced_command(psmouse, reg) ||
> +	    psmouse_sliced_command(psmouse, val) ||
> +	    ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSCALE11))
> +		return -1;
> +
> +	if (psmouse_sliced_command(psmouse, read_cmd) ||
> +	    psmouse_sliced_command(psmouse, reg) ||
> +	    ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO))
> +		return -1;
> +
> +	if (val != param[0])
> +		return -1;
> +
> +	return 0;
> +}
> +
> +/*
>   * Dump a complete mouse movement packet to the syslog
>   */
>  static void elantech_packet_dump(unsigned char *packet, int size)
> @@ -223,7 +269,7 @@ static void elantech_report_absolute_v1(struct psmouse *psmouse)
>  		input_report_abs(dev, ABS_X,
>  			((packet[1] & 0x0c) << 6) | packet[2]);
>  		input_report_abs(dev, ABS_Y,
> -			ETP_YMAX_V1 - (((packet[1] & 0x03) << 8) | packet[3]));
> +			etd->y_max - (((packet[1] & 0x03) << 8) | packet[3]));
>  	}
>  
>  	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
> @@ -298,7 +344,7 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
>  		 * byte 4:  .   .   .   .   .   .  y9  y8
>  		 * byte 5: y7  y6  y5  y4  y3  y2  y1  y0
>  		 */
> -		y1 = ETP_YMAX_V2 - (((packet[4] & 0x03) << 8) | packet[5]);
> +		y1 = etd->y_max - (((packet[4] & 0x03) << 8) | packet[5]);
>  
>  		input_report_abs(dev, ABS_X, x1);
>  		input_report_abs(dev, ABS_Y, y1);
> @@ -316,14 +362,14 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
>  		 */
>  		x1 = ((packet[0] & 0x10) << 4) | packet[1];
>  		/* byte 2: ay7 ay6 ay5 ay4 ay3 ay2 ay1 ay0 */
> -		y1 = ETP_2FT_YMAX - (((packet[0] & 0x20) << 3) | packet[2]);
> +		y1 = etd->y_max_2ft - (((packet[0] & 0x20) << 3) | packet[2]);
>  		/*
>  		 * byte 3:  .   .  by8 bx8  .   .   .   .
>  		 * byte 4: bx7 bx6 bx5 bx4 bx3 bx2 bx1 bx0
>  		 */
>  		x2 = ((packet[3] & 0x10) << 4) | packet[4];
>  		/* byte 5: by7 by8 by5 by4 by3 by2 by1 by0 */
> -		y2 = ETP_2FT_YMAX - (((packet[3] & 0x20) << 3) | packet[5]);
> +		y2 = etd->y_max_2ft - (((packet[3] & 0x20) << 3) | packet[5]);
>  		/*
>  		 * For compatibility with the X Synaptics driver scale up
>  		 * one coordinate and report as ordinary mouse movent
> @@ -352,6 +398,83 @@ static void elantech_report_absolute_v2(struct psmouse *psmouse)
>  	input_sync(dev);
>  }
>  
> +/*
> + * Interpret complete data packets and report absolute mode input events for
> + * hardware version 3. (6 byte packets)
> + */
> +static psmouse_ret_t elantech_report_absolute_v3(struct psmouse *psmouse)
> +{
> +	struct elantech_data *etd = psmouse->private;
> +	struct input_dev *dev = psmouse->dev;
> +	unsigned char *packet1 = psmouse->packet;
> +	unsigned char *packet2 = NULL;
> +	unsigned int fingers, width = 0, pres = 0;
> +	unsigned int x1, y1, x2 = 0, y2 = 0;
> +
> +	/* byte 0: n1  n0   .   .   .   .   R   L */
> +	fingers = (packet1[0] & 0xc0) >> 6;
> +
> +	/*
> +	 * Need to receive two packets for 2-touch events. If this
> +	 * is the first packet, store it away and wait for the second.
> +	 * We don't support parity in v3, so use that storage.
> +	 */
> +	if (fingers == 2 && (packet1[0] & 0x0c) == 0x04) {
> +		memcpy(etd->parity, packet1, psmouse->pktsize);
> +		return PSMOUSE_FULL_PACKET;
> +	}
> +
> +	/*
> +	 * If this the second packet of a two-fingered touch event we
> +	 * need to process the previous packet stashed away in
> +	 * etd->parity
> +	 */
> +	if (fingers == 2) {
> +		packet1 = etd->parity;
> +		packet2 = psmouse->packet;
> +	}
> +
> +	x1 = ((packet1[1] & 0x0f) << 8) | packet1[2];
> +	y1 = etd->y_max - (((packet1[4] & 0x0f) << 8) | packet1[5]);
> +
> +	if (packet2) {
> +		x2 = ((packet2[1] & 0x0f) << 8) | packet2[2];
> +		y2 = etd->y_max - (((packet2[4] & 0x0f) << 8) | packet2[5]);
> +	}
> +
> +	/*
> +	 * Reject crazy values we sometimes get from the hardware
> +	 */
> +	if (fingers != 0 && (x1 > etd->x_max || y1 > etd->y_max))
> +		return PSMOUSE_FULL_PACKET;
> +
> +	pres = (packet1[1] & 0xf0) | ((packet1[4] & 0xf0) >> 4);
> +	width = ((packet1[0] & 0x30) >> 2) | ((packet1[3] & 0x30) >> 4);
> +
> +	elantech_report_semi_mt_data(dev, fingers, x1, y1, x2, y2);
> +
> +	input_report_key(dev, BTN_TOUCH, fingers != 0);
> +	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
> +	input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
> +	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
> +
> +	if (etd->reports_pressure) {
> +		input_report_abs(dev, ABS_PRESSURE, pres);
> +		input_report_abs(dev, ABS_TOOL_WIDTH, width);
> +	}
> +
> +	if (fingers != 0) {
> +		input_report_abs(dev, ABS_X, x1);
> +		input_report_abs(dev, ABS_Y, y1);
> +	}
> +
> +	input_report_key(dev, BTN_LEFT, packet1[0] & 0x01);
> +	input_report_key(dev, BTN_RIGHT, packet1[0] & 0x02);
> +
> +	input_sync(dev);
> +	return PSMOUSE_FULL_PACKET;
> +}
> +
>  static int elantech_check_parity_v1(struct psmouse *psmouse)
>  {
>  	struct elantech_data *etd = psmouse->private;
> @@ -401,6 +524,9 @@ static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
>  		/* We don't know how to check parity in protocol v2 */
>  		elantech_report_absolute_v2(psmouse);
>  		break;
> +	case 3:
> +		/* We don't know how to check parity in protocol v3 */
> +		return elantech_report_absolute_v3(psmouse);
>  	}
>  
>  	return PSMOUSE_FULL_PACKET;
> @@ -433,13 +559,16 @@ static int elantech_set_absolute_mode(struct psmouse *psmouse)
>  		etd->reg_21 = 0x60;	/* 0x00 */
>  		if (elantech_write_reg(psmouse, 0x10, etd->reg_10) ||
>  		    elantech_write_reg(psmouse, 0x11, etd->reg_11) ||
> -		    elantech_write_reg(psmouse, 0x21, etd->reg_21)) {
> +		    elantech_write_reg(psmouse, 0x21, etd->reg_21))
>  			rc = -1;
> -			break;
> -		}
> +		break;
> +	case 3:
> +		etd->reg_10 = 0x0f;
> +		rc = elantech_mode_command(psmouse, 0x10, etd->reg_10);
> +		break;
>  	}
>  
> -	if (rc == 0) {
> +	if (etd->hw_version != 3 && rc == 0) {
>  		/*
>  		 * Read back reg 0x10. For hardware version 1 we must make
>  		 * sure the absolute mode bit is set. For hardware version 2
> @@ -473,10 +602,11 @@ static int elantech_set_absolute_mode(struct psmouse *psmouse)
>  /*
>   * Set the appropriate event bits for the input subsystem
>   */
> -static void elantech_set_input_params(struct psmouse *psmouse)
> +static int elantech_set_input_params(struct psmouse *psmouse)
>  {
>  	struct input_dev *dev = psmouse->dev;
>  	struct elantech_data *etd = psmouse->private;
> +	unsigned char param[3];
>  
>  	__set_bit(EV_KEY, dev->evbit);
>  	__set_bit(EV_ABS, dev->evbit);
> @@ -492,20 +622,41 @@ static void elantech_set_input_params(struct psmouse *psmouse)
>  
>  	switch (etd->hw_version) {
>  	case 1:
> +		etd->x_max = ETP_XMAX_V1;
> +		etd->y_max = ETP_YMAX_V1;
> +
>  		/* Rocker button */
>  		if (etd->fw_version < 0x020000 &&
>  		    (etd->capabilities & ETP_CAP_HAS_ROCKER)) {
>  			__set_bit(BTN_FORWARD, dev->keybit);
>  			__set_bit(BTN_BACK, dev->keybit);
>  		}
> -		input_set_abs_params(dev, ABS_X, ETP_XMIN_V1, ETP_XMAX_V1, 0, 0);
> -		input_set_abs_params(dev, ABS_Y, ETP_YMIN_V1, ETP_YMAX_V1, 0, 0);
> +		input_set_abs_params(dev, ABS_X, ETP_XMIN_V1, etd->x_max, 0, 0);
> +		input_set_abs_params(dev, ABS_Y, ETP_YMIN_V1, etd->y_max, 0, 0);
>  		break;
>  
>  	case 2:
> +	case 3:
> +		if (etd->hw_version == 3) {
> +			if (ps2_command(&psmouse->ps2dev, NULL, ETP_PS2_CUSTOM_COMMAND) ||
> +			    ps2_command(&psmouse->ps2dev, NULL, 0x00) ||
> +			    ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO))
> +				return -1;
> +
> +			etd->x_max = (param[0] & 0xf) << 8 | param[1];
> +			etd->y_max = (param[0] & 0xf0) << 4 | param[2];
> +			etd->y_max_2ft = etd->y_max;
> +			elantech_debug("x_max = %d, y_max = %d\n",
> +				       etd->x_max, etd->y_max);
> +		} else {
> +			etd->x_max = ETP_XMAX_V2;
> +			etd->y_max = ETP_YMAX_V2;
> +			etd->y_max_2ft = ETP_2FT_YMAX;
> +		}
> +
>  		__set_bit(BTN_TOOL_QUADTAP, dev->keybit);
> -		input_set_abs_params(dev, ABS_X, ETP_XMIN_V2, ETP_XMAX_V2, 0, 0);
> -		input_set_abs_params(dev, ABS_Y, ETP_YMIN_V2, ETP_YMAX_V2, 0, 0);
> +		input_set_abs_params(dev, ABS_X, ETP_XMIN_V2, etd->x_max, 0, 0);
> +		input_set_abs_params(dev, ABS_Y, ETP_YMIN_V2, etd->y_max, 0, 0);
>  		if (etd->reports_pressure) {
>  			input_set_abs_params(dev, ABS_PRESSURE, ETP_PMIN_V2,
>  					     ETP_PMAX_V2, 0, 0);
> @@ -514,10 +665,12 @@ static void elantech_set_input_params(struct psmouse *psmouse)
>  		}
>  		__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);
>  		input_mt_init_slots(dev, 2);
> -		input_set_abs_params(dev, ABS_MT_POSITION_X, ETP_XMIN_V2, ETP_XMAX_V2, 0, 0);
> -		input_set_abs_params(dev, ABS_MT_POSITION_Y, ETP_YMIN_V2, ETP_YMAX_V2, 0, 0);
> +		input_set_abs_params(dev, ABS_MT_POSITION_X, ETP_XMIN_V2, etd->x_max, 0, 0);
> +		input_set_abs_params(dev, ABS_MT_POSITION_Y, ETP_YMIN_V2, etd->y_max, 0, 0);
>  		break;
>  	}
> +
> +	return 0;
>  }
>  
>  struct elantech_attr_data {
> @@ -639,10 +792,17 @@ static bool elantech_is_signature_valid(const unsigned char *param)
>  /*
>   * Use magic knock to detect Elantech touchpad
>   */
> +
> +static const char elantech_magic_knocks[][3] = {
> +	{ '\x3c', '\x03', '\xc8' },
> +	{ '\x3c', '\x03', '\x00' },
> +};
> +
>  int elantech_detect(struct psmouse *psmouse, bool set_properties)
>  {
>  	struct ps2dev *ps2dev = &psmouse->ps2dev;
>  	unsigned char param[3];
> +	int i;
>  
>  	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS);
>  
> @@ -655,11 +815,15 @@ int elantech_detect(struct psmouse *psmouse, bool set_properties)
>  		return -1;
>  	}
>  
> -	/*
> -	 * Report this in case there are Elantech models that use a different
> -	 * set of magic numbers
> -	 */
> -	if (param[0] != 0x3c || param[1] != 0x03 || param[2] != 0xc8) {
> +	for (i = 0; i < ARRAY_SIZE(elantech_magic_knocks); i++) {
> +		if (!memcmp(param, elantech_magic_knocks[i], sizeof(param)))
> +			break;
> +	}
> +	if (i >= ARRAY_SIZE(elantech_magic_knocks)) {
> +		/*
> +		 * Report this in case there are Elantech models that use a
> +		 * different set of magic numbers
> +		 */
>  		pr_debug("unexpected magic knock result 0x%02x, 0x%02x, 0x%02x.\n",
>  			 param[0], param[1], param[2]);
>  		return -1;
> @@ -749,23 +913,38 @@ int elantech_init(struct psmouse *psmouse)
>  
>  	etd->fw_version = (param[0] << 16) | (param[1] << 8) | param[2];
>  
> -	/*
> -	 * Assume every version greater than this is new EeePC style
> -	 * hardware with 6 byte packets
> -	 */
> -	if (etd->fw_version >= 0x020030) {
> +	if (etd->fw_version < 0x020030) {
> +		etd->hw_version = 1;
> +		etd->paritycheck = 1;
> +	} else if ((etd->fw_version & ~FW_VERSION_MICRO_MASK) <= 0x140000) {
>  		etd->hw_version = 2;
>  		/* For now show extra debug information */
>  		etd->debug = 1;
> -		/* Don't know how to do parity checking for version 2 */
> -		etd->paritycheck = 0;
>  
>  		if (etd->fw_version >= 0x020800)
>  			etd->reports_pressure = true;
> -
>  	} else {
> -		etd->hw_version = 1;
> -		etd->paritycheck = 1;
> +		unsigned char dummy[3];
> +		error = 0;
> +		if (ps2_command(&psmouse->ps2dev, NULL, ETP_PS2_CUSTOM_COMMAND) ||
> +		    ps2_command(&psmouse->ps2dev, NULL, 0x01) ||
> +		    ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO))
> +			error = -1;
> +		else if (
> +		    ps2_command(&psmouse->ps2dev, NULL, ETP_PS2_CUSTOM_COMMAND) ||
> +		    ps2_command(&psmouse->ps2dev, NULL, 0x04) ||
> +		    ps2_command(&psmouse->ps2dev, dummy, PSMOUSE_CMD_GETINFO))
> +			error = -1;
> +
> +		if (!error &&
> +		    (param[0] & 0x0f) >= 5 && (param[1] & 0x0f) >= 0x06) {
> +			etd->hw_version = 3;
> +			etd->debug = 1;
> +			etd->reports_pressure = true;
> +		} else {
> +			pr_debug("did not detect elantech firmware version\n");
> +			goto init_fail;
> +		}
>  	}
>  
>  	pr_info("assuming hardware version %d, firmware version %d.%d.%d\n",
> @@ -794,7 +973,11 @@ int elantech_init(struct psmouse *psmouse)
>  		goto init_fail;
>  	}
>  
> -	elantech_set_input_params(psmouse);
> +	error = elantech_set_input_params(psmouse);
> +	if (error) {
> +		pr_err("failed to set input parameters\n");
> +		goto init_fail;
> +	}
>  
>  	error = sysfs_create_group(&psmouse->ps2dev.serio->dev.kobj,
>  				   &elantech_attr_group);
> @@ -806,7 +989,7 @@ int elantech_init(struct psmouse *psmouse)
>  	psmouse->protocol_handler = elantech_process_byte;
>  	psmouse->disconnect = elantech_disconnect;
>  	psmouse->reconnect = elantech_reconnect;
> -	psmouse->pktsize = etd->hw_version == 2 ? 6 : 4;
> +	psmouse->pktsize = etd->hw_version == 1 ? 4 : 6;
>  
>  	return 0;
>  
> diff --git a/drivers/input/mouse/elantech.h b/drivers/input/mouse/elantech.h
> index fabb2b9..b896cc8 100644
> --- a/drivers/input/mouse/elantech.h
> +++ b/drivers/input/mouse/elantech.h
> @@ -22,6 +22,7 @@
>  /*
>   * Command values for register reading or writing
>   */
> +#define ETP_REGISTER_RW			0x00
>  #define ETP_REGISTER_READ		0x10
>  #define ETP_REGISTER_WRITE		0x11
>  
> @@ -110,6 +111,9 @@ struct elantech_data {
>  	bool reports_pressure;
>  	unsigned char hw_version;
>  	unsigned int fw_version;
> +	unsigned int x_max;
> +	unsigned int y_max;
> +	unsigned int y_max_2ft;
>  	unsigned int single_finger_reports;
>  	unsigned char parity[256];
>  };
> -- 
> 1.7.4.1
> 

-- 
Dmitry
