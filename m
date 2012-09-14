Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2INHRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:17:46 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1621 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2INHRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:17:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Subject: Re: [PATCH 2/3] Add a V4L2 driver for SI476X MFD
Date: Fri, 14 Sep 2012 09:17:36 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc3-tschai; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1347576013-28832-1-git-send-email-andrey.smirnov@convergeddevices.net> <1347576013-28832-3-git-send-email-andrey.smirnov@convergeddevices.net>
In-Reply-To: <1347576013-28832-3-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209140917.36368.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey!

Some generic comments:

sound/i2c/other/tea575x-tuner.c is a good example of how to make an AM/FM tuner
driver. It's used by e.g. drivers/media/radio/radio-shark.c. This went in just
yesterday, so you need to look at the latest staging/for_v3.7 branch of the
media_tree.git repo.

Some main missing pieces here:

- you must use a struct v4l2_device as the top-level struct.
- you must use the control framework to handle controls
- you must use struct v4l2_fh as that gives you V4L2 priority handling and
  control events for free.
- don't use audio inputs to select the freq bands. Instead do what tea575x does:
  implement enum_freq_bands and do the right checks in hw_freq_seek. See the
  documentation for those ioctls in the latest V4L2 spec available from linuxtv.org.
- is the RDS format that's returned with read() compliant to the V4L2 spec?
  See: http://linuxtv.org/downloads/v4l-dvb-apis/rds.html
  Note that the v4l-utils repository contains a command line tool rds-ctl to test
  rds input.
- run v4l2-compliance for your driver. This is available in the v4l-utils.git repo
  (use the master branch) on linuxtv.org. This tool verifies whether your driver
  is fully V4L2 compliant. There should be no errors or warnings. In case of doubt
  or if you suspect a bug in the tool, then please contact me and/or the mailinglist!

Several of the controls can be dropped when frequency bands are implemented
correctly. There are a few others that probably need to be turned into
standard controls. We can discuss that for the next version of this patch.

On Fri September 14 2012 00:40:12 Andrey Smirnov wrote:
> This commit adds a driver that exposes all the radio related
> functionality of the Si476x series of chips via the V4L2 subsystem.
> 
> Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
> ---
>  drivers/media/radio/Kconfig        |   17 +
>  drivers/media/radio/radio-si476x.c | 1307 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 1324 insertions(+)
>  create mode 100644 drivers/media/radio/radio-si476x.c
> 
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index 8090b87..3c79d09 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -16,6 +16,23 @@ config RADIO_SI470X
>  	bool "Silicon Labs Si470x FM Radio Receiver support"
>  	depends on VIDEO_V4L2
>  
> +config RADIO_SI476X
> +	tristate "Silicon Laboratories Si476x I2C FM Radio"
> +	depends on I2C && VIDEO_V4L2
> +	select MFD_CORE
> +	select MFD_SI476X_CORE
> +	select SND_SOC_SI476X
> +	---help---
> +	  Choose Y here if you have this FM radio chip.
> +
> +	  In order to control your radio card, you will need to use programs
> +	  that are compatible with the Video For Linux 2 API.  Information on
> +	  this API and pointers to "v4l2" programs may be found at
> +	  <file:Documentation/video4linux/API.html>.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called radio-si476x.
> +
>  source "drivers/media/radio/si470x/Kconfig"
>  
>  config USB_MR800
> diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
> new file mode 100644
> index 0000000..f313005
> --- /dev/null
> +++ b/drivers/media/radio/radio-si476x.c
> @@ -0,0 +1,1307 @@
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/atomic.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include <linux/mfd/si476x-core.h>
> +
> +#define FM_FREQ_RANGE_LOW   64000000
> +#define FM_FREQ_RANGE_HIGH 108000000
> +
> +#define AM_FREQ_RANGE_LOW    520000
> +#define AM_FREQ_RANGE_HIGH 30000000
> +
> +#define PWRLINEFLTR (1 << 8)
> +
> +#define FREQ_MUL (10000000 / 625)
> +
> +#define DRIVER_NAME "si476x-radio"
> +#define DRIVER_CARD "SI476x AM/FM Receiver"
> +
> +static const char * const deemphasis[] = {
> +	"75 us",
> +	"50 us",
> +};
> +
> +static const char * const grid_frequency[] = {
> +	"50 Hz",
> +	"60 Hz",
> +};
> +
> +#define PRIVATE_CTL_IDX(x) (x - V4L2_CID_PRIVATE_BASE)
> +
> +static const struct v4l2_queryctrl si476x_ctrls[] = {
> +	/*
> +	   Tuning parameters
> +	   'max tune errors' is shared for both AM/FM mode of operation
> +	*/
> +	{
> +		.id		= SI476X_CID_RSSI_THRESHOLD,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "valid rssi threshold",
> +		.minimum	= -128,
> +		.maximum	= 127,
> +		.step		= 1,
> +	},
> +	{
> +		.id		= SI476X_CID_SNR_THRESHOLD,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "valid snr threshold",
> +		.minimum	= -128,
> +		.maximum	= 127,
> +		.step		= 1,
> +	},
> +	{
> +		.id		= SI476X_CID_MAX_TUNE_ERROR,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "max tune errors",
> +		.minimum	= 0,
> +		.maximum	= 126 * 2,
> +		.step		= 2,
> +	},
> +	/*
> +	   Region specific parameters
> +	*/
> +	{
> +		.id		= SI476X_CID_GRID_FREQUENCY,

Use V4L2_CID_POWER_LINE_FREQUENCY instead.

> +		.type		= V4L2_CTRL_TYPE_MENU,
> +		.name		= "power grid frequency",
> +		.minimum	= 0,
> +		.maximum	= ARRAY_SIZE(grid_frequency) - 1,
> +		.step		= 1,
> +	},
> +	{
> +		.id		= SI476X_CID_HARMONICS_COUNT,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "# of harmonics to reject",
> +		.minimum	= 0,
> +		.maximum	= 20,
> +		.step		= 1,
> +	},
> +	{
> +		.id		= SI476X_CID_SEEK_SPACING,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "seek frequency spacing",
> +		.minimum	= 0,
> +		.maximum	= 0xFFFF,
> +		.step		= 1,
> +	},
> +	{
> +		.id		= SI476X_CID_SEEK_BAND_TOP,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "seek band top",
> +		.minimum	= 0,
> +		.maximum	= 0xFFFF,
> +		.step		= 1,
> +	},
> +	{
> +		.id		= SI476X_CID_SEEK_BAND_BOTTOM,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
> +		.name		= "seek band bottom",
> +		.minimum	= 0,
> +		.maximum	= 0xFFFF,
> +		.step		= 1,
> +	},

The three controls above shouldn't be necessary with the freq_bands and
hw seek API.

> +	{
> +		.id		= SI476X_CID_DEEMPHASIS,
> +		.type		= V4L2_CTRL_TYPE_MENU,
> +		.name		= "de-emphassis",

emphasis typo

> +		.minimum	= 0,
> +		.maximum	= ARRAY_SIZE(deemphasis) - 1,
> +		.step		= 1,
> +		.default_value	= 0,
> +	},

I know a patch was posted that added this as a standard control, but I haven't
heard from that for some time now.

> +	{
> +		.id		= SI476X_CID_RDS_RECEPTION,
> +		.type		= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name		= "rds",
> +		.minimum	= 0,
> +		.maximum	= 1,
> +	},

Probably isn't necessary. The presence of RDS is reported through rxsubchans
returned by VIDIOC_G_TUNER.

> +};
> +
> +struct si476x_radio;
> +
> +/**
> + * struct si476x_radio_ops - vtable of tuner functions
> + *
> + * This table holds pointers to functions implementing particular
> + * operations depending on the mode in which the tuner chip was
> + * configured to start in. If the function is not supported
> + * corresponding element is set to #NULL.
> + *
> + * @tune_freq: Tune chip to a specific frequency
> + * @seek_start: Star station seeking
> + * @rsq_status: Get Recieved Signal Quality(RSQ) status
> + * @rds_blckcnt: Get recived RDS blocks count
> + * @phase_diversity: Change phase diversity mode of the tuner
> + * @phase_div_status: Get phase diversity mode status
> + * @acf_status: Get the status of Automatically Controlled
> + * Features(ACF)
> + * @agc_status: Get Automatic Gain Control(AGC) status
> + */
> +struct si476x_radio_ops {
> +	int (*tune_freq)(struct si476x_core *, struct si476x_tune_freq_args *);
> +	int (*seek_start)(struct si476x_core *, bool, bool);
> +	int (*rsq_status)(struct si476x_core *, struct si476x_rsq_status_args *,
> +			  struct si476x_rsq_status_report *);
> +	int (*rds_blckcnt)(struct si476x_core *, bool,
> +			   struct si476x_rds_blockcount_report *);
> +
> +	int (*phase_diversity)(struct si476x_core *,
> +			       enum si476x_phase_diversity_mode);
> +	int (*phase_div_status)(struct si476x_core *);
> +	int (*acf_status)(struct si476x_core *,
> +			  struct si476x_acf_status_report *);
> +	int (*agc_status)(struct si476x_core *,
> +			  struct si476x_agc_status_report *);
> +};
> +
> +/**
> + * struct si476x_radio - radio device
> + *
> + * @core: Pointer to underlying core device
> + * @videodev: Pointer to video device created by V4L2 subsystem
> + * @ops: Vtable of functions. See struct si476x_radio_ops for details
> + * @kref: Reference counter
> + * @core_lock: An r/w semaphore to brebvent the deletion of underlying
> + * core structure is the radio device is being used
> + */
> +struct si476x_radio {
> +	struct si476x_core  *core;
> +	struct video_device *videodev;
> +
> +	/* This field should not be accesses unless core lock is held */
> +	const struct si476x_radio_ops *ops;
> +
> +	struct kref kref;
> +	struct rw_semaphore core_lock;
> +};
> +static inline struct si476x_radio *kref_to_si476x_radio(struct kref *ref)
> +{
> +	return container_of(ref, struct si476x_radio, kref);
> +}
> +
> +static void si476x_radio_delete(struct kref *kref);
> +static inline void si476x_radio_get(struct si476x_radio *radio)
> +{
> +	kref_get(&radio->kref);
> +}
> +
> +static inline void si476x_radio_put(struct si476x_radio *radio)
> +{
> +	kref_put(&radio->kref, si476x_radio_delete);
> +}

Why would you need refcounting?

> +
> +
> +static int si476x_radio_initialize_mode(struct si476x_radio *);
> +
> +/*
> + * si476x_vidioc_querycap - query device capabilities
> + */
> +static int si476x_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *capability)
> +{
> +	strlcpy(capability->driver, DRIVER_NAME, sizeof(capability->driver));
> +	strlcpy(capability->card,   DRIVER_CARD, sizeof(capability->card));

fill in bus_info

> +	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
> +		V4L2_CAP_TUNER | V4L2_CAP_RADIO;

fill in device_caps

> +
> +	return 0;
> +}
> +
> +static int si476x_queryctrl(struct file *file, void *priv,
> +			    struct v4l2_queryctrl *qc)
> +{
> +	int retval;
> +
> +	/* search video control */
> +	switch (qc->id) {
> +	case SI476X_CID_RSSI_THRESHOLD:
> +	case SI476X_CID_SNR_THRESHOLD:
> +	case SI476X_CID_MAX_TUNE_ERROR:
> +	case SI476X_CID_SEEK_SPACING:
> +	case SI476X_CID_SEEK_BAND_TOP:
> +	case SI476X_CID_SEEK_BAND_BOTTOM:
> +	case SI476X_CID_RDS_RECEPTION:
> +	case SI476X_CID_HARMONICS_COUNT:
> +	case SI476X_CID_GRID_FREQUENCY:
> +	case SI476X_CID_DEEMPHASIS:
> +		memcpy(qc, &si476x_ctrls[PRIVATE_CTL_IDX(qc->id)],
> +		       sizeof(*qc));
> +		retval = 0;
> +		break;
> +	default:
> +		retval = -EINVAL;
> +		break;
> +	}
> +
> +	return retval;
> +}
> +
> +static int si476x_querymenu(struct file *file, void *fh,
> +			    struct v4l2_querymenu *m)
> +{
> +	switch (m->id) {
> +	case SI476X_CID_GRID_FREQUENCY:
> +		if (m->index > ARRAY_SIZE(grid_frequency) - 1)
> +			return -EINVAL;
> +		strncpy(m->name, grid_frequency[m->index], sizeof(m->name));
> +		break;
> +	case SI476X_CID_DEEMPHASIS:
> +		if (m->index > ARRAY_SIZE(deemphasis) - 1)
> +			return -EINVAL;
> +		strncpy(m->name, deemphasis[m->index], sizeof(m->name));
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/* si4713_g_ctrl - get the value of a control */
> +static int si476x_g_ctrl(struct file *file, void *priv,
> +			 struct v4l2_control *ctrl)
> +{
> +	int retval;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		retval = -ENODEV;
> +		goto up_semaphore;
> +	}
> +
> +	si476x_core_lock(radio->core);
> +
> +	switch (ctrl->id) {
> +	case SI476X_CID_RSSI_THRESHOLD:
> +		retval = si476x_core_get_valid_rssi_threshold(radio->core);
> +		break;
> +	case SI476X_CID_SNR_THRESHOLD:
> +		retval = si476x_core_get_valid_snr_threshold(radio->core);
> +		break;
> +	case SI476X_CID_MAX_TUNE_ERROR:
> +		retval = si476x_core_get_valid_max_tune_error(radio->core);
> +		break;
> +	case SI476X_CID_SEEK_SPACING:
> +		retval = si476x_core_get_frequency_spacing(radio->core);
> +		break;
> +	case SI476X_CID_SEEK_BAND_TOP:
> +		retval = si476x_core_get_seek_band_top(radio->core);
> +		break;
> +	case SI476X_CID_SEEK_BAND_BOTTOM:
> +		retval = si476x_core_get_seek_band_bottom(radio->core);
> +		break;
> +	case SI476X_CID_RDS_RECEPTION:
> +		retval = si476x_core_get_rds_reception(radio->core);
> +		break;
> +	case SI476X_CID_DEEMPHASIS:
> +		retval = si476x_core_get_audio_deemphasis(radio->core);
> +		break;
> +	case SI476X_CID_HARMONICS_COUNT:
> +		retval = si476x_core_get_audio_pwr_line_filter(radio->core);
> +		break;
> +	case SI476X_CID_GRID_FREQUENCY:
> +		retval = si476x_core_get_audio_pwr_line_filter(radio->core);
> +		break;
> +	default:
> +		retval = -EINVAL;
> +		break;
> +	}
> +
> +	if (retval >= 0) {
> +		if (ctrl->id == SI476X_CID_HARMONICS_COUNT)
> +			ctrl->value = retval & 0x0F;
> +		else if (ctrl->id == SI476X_CID_GRID_FREQUENCY)
> +			ctrl->value = !!(PWRLINEFLTR & retval);
> +		else
> +			ctrl->value = retval;
> +
> +		retval = 0;
> +	}
> +	si476x_core_unlock(radio->core);
> +
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	return retval;
> +}
> +
> +/* si4713_s_ctrl - set the value of a control */
> +static int si476x_s_ctrl(struct file *file, void *priv,
> +			 struct v4l2_control *ctrl)
> +{
> +	int old_value, retval, count;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		retval = -ENODEV;
> +		goto up_semaphore;
> +	}
> +
> +	si476x_core_lock(radio->core);
> +
> +	switch (ctrl->id) {
> +	case SI476X_CID_RSSI_THRESHOLD:
> +		retval = si476x_core_set_valid_rssi_threshold(radio->core,
> +							      ctrl->value);
> +		break;
> +	case SI476X_CID_SNR_THRESHOLD:
> +		retval = si476x_core_set_valid_snr_threshold(radio->core,
> +							     ctrl->value);
> +		break;
> +	case SI476X_CID_MAX_TUNE_ERROR:
> +		retval = si476x_core_set_valid_max_tune_error(radio->core,
> +							      ctrl->value);
> +		break;
> +	case SI476X_CID_SEEK_SPACING:
> +		retval = si476x_core_set_frequency_spacing(radio->core,
> +							   ctrl->value);
> +		break;
> +	case SI476X_CID_SEEK_BAND_TOP:
> +		retval = si476x_core_set_seek_band_top(radio->core,
> +						       ctrl->value);
> +		break;
> +	case SI476X_CID_SEEK_BAND_BOTTOM:
> +		retval = si476x_core_set_seek_band_bottom(radio->core,
> +							  ctrl->value);
> +		break;
> +	case SI476X_CID_RDS_RECEPTION:
> +		retval = si476x_core_set_rds_reception(radio->core,
> +						       ctrl->value);
> +		break;
> +	case SI476X_CID_DEEMPHASIS:
> +		retval = si476x_core_set_audio_deemphasis(radio->core,
> +							  ctrl->value);
> +		break;
> +	case SI476X_CID_HARMONICS_COUNT:
> +		old_value = si476x_core_get_audio_pwr_line_filter(radio->core);
> +		if (old_value < 0) {
> +			retval = old_value;
> +			break;
> +		}
> +
> +		retval = si476x_core_set_audio_pwr_line_filter(radio->core,
> +					(ctrl->value > 0) ? true : false,
> +					!!(PWRLINEFLTR & old_value),
> +					ctrl->value);
> +		break;
> +	case SI476X_CID_GRID_FREQUENCY:
> +		old_value = si476x_core_get_audio_pwr_line_filter(radio->core);
> +		if (old_value < 0) {
> +			retval = old_value;
> +			break;
> +		}
> +		count  = old_value & 0x0F;
> +
> +		retval = si476x_core_set_audio_pwr_line_filter(radio->core,
> +						(count > 0) ? true : false,
> +						ctrl->value,
> +						count);
> +		break;
> +	default:
> +		retval = -EINVAL;
> +		break;
> +	}
> +
> +	si476x_core_unlock(radio->core);
> +
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	return retval;
> +}
> +
> +static int si476x_g_tuner(struct file *file, void *priv,
> +			  struct v4l2_tuner *tuner)
> +{
> +	int err;
> +	struct si476x_rsq_status_report report;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	if (tuner->index != 0) {
> +		err = -EINVAL;
> +		goto exit;
> +	}
> +
> +	down_read(&radio->core_lock);

Use the V4L2 core locking functionality. See Documentation/video4linux/v4l2-framework.txt.
Also see the tea575x driver that uses it. And never use a semaphore for
this, use a mutex.

> +
> +	if (!radio->core) {
> +		err = -ENODEV;

This should never happen.

> +		goto up_semaphore;
> +	}
> +
> +	tuner->type       = V4L2_TUNER_RADIO;
> +	tuner->capability = V4L2_TUNER_CAP_LOW; /* Measure frequncies
> +						 * in multiples of
> +						 * 62.5 Hz */
> +	if (radio->core->chip_id < 5) { /* Si4760/61/62/63/64 */
> +		strlcpy(tuner->name, "AM/FM", sizeof(tuner->name));
> +
> +		tuner->capability |=  V4L2_TUNER_CAP_STEREO
> +			| V4L2_TUNER_CAP_RDS
> +			| V4L2_TUNER_CAP_RDS_BLOCK_IO;
> +
> +		tuner->rangelow  = 520 * FREQ_MUL / 1000;
> +
> +		tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
> +		tuner->audmode = V4L2_TUNER_MODE_STEREO;
> +	} else {  /* Si4768/69 */
> +		strlcpy(tuner->name, "FM", sizeof(tuner->name));
> +		tuner->rangelow  = 64 * FREQ_MUL;
> +		tuner->capability |= V4L2_TUNER_CAP_RDS
> +			| V4L2_TUNER_CAP_RDS_BLOCK_IO;
> +	}
> +
> +	tuner->rxsubchans |= V4L2_TUNER_SUB_RDS;
> +
> +
> +	if (radio->core->diversity_mode == SI476X_PHDIV_SECONDARY_ANTENNA ||
> +	    radio->core->diversity_mode == SI476X_PHDIV_SECONDARY_COMBINING) {
> +		strlcpy(tuner->name, "FM (secondary)", sizeof(tuner->name));
> +		tuner->capability = 0;
> +		tuner->rxsubchans = 0;
> +		tuner->audmode    = 0;
> +	}
> +
> +	if (radio->core->diversity_mode == SI476X_PHDIV_PRIMARY_ANTENNA ||
> +	    radio->core->diversity_mode == SI476X_PHDIV_PRIMARY_COMBINING)
> +		strlcpy(tuner->name, "AM/FM (primary)", sizeof(tuner->name));
> +
> +	tuner->rangehigh = 108 * FREQ_MUL;
> +	tuner->afc = 1;
> +
> +	si476x_core_lock(radio->core);
> +	{
> +		struct si476x_rsq_status_args args = {
> +			.primary	= false,
> +			.rsqack		= false,
> +			.attune		= false,
> +			.cancel		= false,
> +			.stcack		= false,
> +		};
> +		if (radio->ops->rsq_status) {
> +			err = radio->ops->rsq_status(radio->core,
> +						     &args, &report);
> +			if (err < 0) {
> +				tuner->signal = 0;
> +			} else {
> +				/*
> +				  tuner->signal value range: 0x0000 .. 0xFFFF,
> +				  report.rssi: -128 .. 127
> +				*/
> +				tuner->signal = (report.rssi + 128) * 257;
> +			}
> +		} else {
> +			tuner->signal = 0;
> +			err = -EINVAL;
> +		}
> +	}
> +	si476x_core_unlock(radio->core);
> +
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +exit:
> +	return err;
> +}
> +
> +/**
> + * The switching between AM/FM mode of the tuner is implemented as
> + * swtiching between tow audio stream of the V4L2 tuner. SO each AM/FM
> + * capabel chips reports two audio streams "AM Radio" and "FM Radio".
> + * Selectio=ng one or the other would put hte tuner in an appropriate
> + * mode.
> + */
> +
> +static int si476x_enumaudio(struct file *file, void *fh,
> +			    struct v4l2_audio *audio)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		err = -ENODEV;
> +		goto up_semaphore;
> +	}
> +
> +	if (radio->core->chip_id >= 5) {
> +		err = -EINVAL;
> +		goto up_semaphore;
> +	}
> +
> +	err = 0;
> +	switch (audio->index) {
> +	case 0:
> +		strcpy(audio->name, "FM Radio");
> +		audio->capability = V4L2_AUDCAP_STEREO;
> +		audio->mode = 0;
> +		break;
> +	case 1:
> +		strcpy(audio->name, "AM Radio");
> +		audio->capability = 0;
> +		audio->mode = 0;
> +		break;
> +	default:
> +		err = -EINVAL;
> +	}
> +
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	return err;
> +}
> +
> +static int si476x_g_audio(struct file *file, void *priv,
> +			  struct v4l2_audio *audio)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		err = -ENODEV;
> +		goto up_semaphore;
> +	}
> +
> +	if (radio->core->chip_id >= 5) {
> +		err = -EINVAL;
> +		goto up_semaphore;
> +	}
> +
> +	si476x_core_lock(radio->core);
> +	err = 0;
> +	switch (radio->core->power_up_parameters.func) {
> +	case SI476X_FUNC_FM_RECEIVER:
> +		audio->index = 0;
> +		strcpy(audio->name, "FM Radio");
> +		audio->capability = V4L2_AUDCAP_STEREO;
> +		break;
> +	case SI476X_FUNC_AM_RECEIVER:
> +		audio->index = 1;
> +		strcpy(audio->name, "AM Radio");
> +		audio->capability = 0;
> +		break;
> +	default:
> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +	audio->mode = 0;
> +unlock:
> +	si476x_core_unlock(radio->core);
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	return err;
> +}
> +
> +static int si476x_s_audio(struct file *file, void *priv,
> +			  struct v4l2_audio *audio)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		err = -ENODEV;
> +		goto up_semaphore;
> +	}
> +
> +	if (radio->core->chip_id >= 5 || audio->index > 1) {
> +		err = -EINVAL;
> +		goto up_semaphore;
> +	}
> +
> +	si476x_core_lock(radio->core);
> +
> +	/*
> +	   Since power/up down is a very time consuming operation,
> +	   try to avoid doing it if the requested mode matches the one
> +	   the tuner is in
> +	*/
> +	if ((audio->index == 0 &&
> +	     radio->core->power_up_parameters.func
> +	     == SI476X_FUNC_FM_RECEIVER) ||
> +	    (audio->index == 1 &&
> +	     radio->core->power_up_parameters.func
> +	     == SI476X_FUNC_AM_RECEIVER)) {
> +		err = 0;
> +		goto unlock;
> +	}
> +
> +	err = si476x_core_stop(radio->core, true);
> +	if (err < 0)
> +		goto unlock;
> +
> +	switch (audio->index) {
> +	case 0:
> +		radio->core->power_up_parameters.func = SI476X_FUNC_FM_RECEIVER;
> +		break;
> +	case 1:
> +		radio->core->power_up_parameters.func = SI476X_FUNC_AM_RECEIVER;
> +		break;
> +	}
> +
> +	err = si476x_core_start(radio->core, true);
> +	if (!err)
> +		err = si476x_radio_initialize_mode(radio);
> +
> +unlock:
> +	si476x_core_unlock(radio->core);
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	return err;
> +}

As mentioned above, these three functions should be removed. That's not the
way frequency bands are supported.

> +
> +static int si476x_g_frequency(struct file *file, void *priv,
> +			      struct v4l2_frequency *f)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		err = -ENODEV;
> +		goto up_semaphore;
> +	}
> +
> +	si476x_core_lock(radio->core);
> +
> +	f->type = V4L2_TUNER_RADIO;
> +	if (radio->ops->rsq_status) {
> +		struct si476x_rsq_status_report report;
> +		struct si476x_rsq_status_args   args = {
> +			.primary	= false,
> +			.rsqack		= false,
> +			.attune		= true,
> +			.cancel		= false,
> +			.stcack		= false,
> +		};
> +
> +		err = radio->ops->rsq_status(radio->core, &args, &report);
> +		if (!err)
> +			f->frequency = si476x_to_v4l2(radio->core,
> +						      report.readfreq);
> +	} else {
> +		err = -EINVAL;
> +	}
> +
> +	si476x_core_unlock(radio->core);
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	return err;
> +}
> +
> +static int si476x_s_frequency(struct file *file, void *priv,
> +			      struct v4l2_frequency *f)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		err = -ENODEV;
> +		goto up_semaphore;
> +	}
> +	si476x_core_lock(radio->core);
> +
> +	switch (radio->core->power_up_parameters.func) {
> +	case SI476X_FUNC_FM_RECEIVER:
> +		/* FIXME change teh constants to use Hz */
> +		if (v4l2_to_hz(f->frequency) < FM_FREQ_RANGE_LOW ||
> +		    v4l2_to_hz(f->frequency) > FM_FREQ_RANGE_HIGH) {
> +			err = -EDOM;
> +			goto unlock;
> +		}
> +		break;
> +	case SI476X_FUNC_AM_RECEIVER:
> +		if (v4l2_to_hz(f->frequency) < AM_FREQ_RANGE_LOW ||
> +		    v4l2_to_hz(f->frequency) > AM_FREQ_RANGE_HIGH) {
> +			err = -EDOM;
> +			goto unlock;
> +		}
> +		break;
> +	case SI476X_FUNC_WB_RECEIVER:
> +	case SI476X_FUNC_BOOTLOADER:
> +		break;
> +	}
> +
> +	if (radio->ops->tune_freq) {
> +		struct si476x_tune_freq_args args = {
> +			.zifsr		= false,
> +			.hd		= false,
> +			.injside	= SI476X_INJSIDE_AUTO,
> +			.freq		= v4l2_to_si476x(radio->core,
> +							 f->frequency),
> +			.tunemode	= SI476X_SM_INITIALIZE_AUDIO,
> +			.smoothmetrics	= SI476X_TM_VALIDATED_NORMAL_TUNE,
> +			.antcap		= 0,
> +		};
> +		err = radio->ops->tune_freq(radio->core, &args);
> +	} else {
> +		err = -ENOTSUPP;
> +	}
> +
> +unlock:
> +	si476x_core_unlock(radio->core);
> +
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	return err;
> +}
> +
> +static int si476x_s_hw_freq_seek(struct file *file, void *priv,
> +				 struct v4l2_hw_freq_seek *seek)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		err = -ENODEV;
> +		goto up_semaphore;
> +	}
> +	/* FIXME: Add seek->spacing support */
> +	si476x_core_lock(radio->core);
> +	if (radio->ops->seek_start)
> +		err = radio->ops->seek_start(radio->core,
> +					     seek->seek_upward,
> +					     seek->wrap_around);
> +	else
> +		err = -ENOTSUPP;

Use ENOTTY instead of ENOTSUPP. ENOTTY is the standard error code when an
ioctl is not supported.

> +	si476x_core_unlock(radio->core);
> +
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	return err;
> +}
> +
> +static int __g_register(struct file *file, void *fh,
> +			     struct v4l2_dbg_register *reg)
> +{
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	if (si476x_core_is_valid_property(radio->core, reg->reg)) {
> +		reg->size = 2;
> +		reg->val  = si476x_core_cmd_get_property(radio->core, reg->reg);
> +		return (reg->val < 0) ? reg->val : 0;
> +	} else {
> +		return -EINVAL;
> +	}
> +}
> +
> +static int __s_register(struct file *file, void *fh,
> +			struct v4l2_dbg_register *reg)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	if (si476x_core_is_valid_property(radio->core, reg->reg) &&
> +	   !si476x_core_is_readonly_property(radio->core, reg->reg)) {
> +		err = si476x_core_cmd_set_property(radio->core,
> +						   reg->reg, reg->val);
> +	} else {
> +		err = -EINVAL;
> +	}
> +
> +	return err;
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int si476x_g_register(struct file *file, void *fh,
> +			     struct v4l2_dbg_register *reg)

If you implement g/s_register, then you should also implement g_chip_ident.

> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		err = -ENODEV;
> +	} else {
> +		si476x_core_lock(radio->core);
> +		err = __g_register(file, fh, reg);
> +		si476x_core_unlock(radio->core);
> +	}
> +
> +	up_read(&radio->core_lock);
> +	return err;
> +}
> +
> +static int si476x_s_register(struct file *file, void *fh,
> +			     struct v4l2_dbg_register *reg)
> +{
> +
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		err = -ENODEV;
> +	} else {
> +		si476x_core_lock(radio->core);
> +		err = __s_register(file, fh, reg);
> +		si476x_core_unlock(radio->core);
> +	}
> +
> +	up_read(&radio->core_lock);
> +	return err;
> +}
> +#endif
> +
> +static long si476x_default(struct file *file, void *fh,
> +			   bool valid_prio, int cmd, void *arg)
> +{
> +	long rval;
> +	struct si476x_rsq_status_args args = {
> +		.primary	= false,
> +		.rsqack		= false,
> +		.attune		= false,
> +		.cancel		= false,
> +		.stcack		= false,
> +	};
> +	struct si476x_radio *radio  = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +	if (!radio->core) {
> +		rval = -ENODEV;
> +		goto up_semaphore;
> +	}
> +
> +	si476x_core_lock(radio->core);
> +	switch (cmd) {
> +	case SI476X_IOC_GET_RSQ_PRIMARY:
> +		args.primary = true;
> +	case SI476X_IOC_GET_RSQ: /* FALLTHROUG */
> +		if (radio->ops->rsq_status)
> +			rval = radio->ops->rsq_status(radio->core, &args,
> +				(struct si476x_rsq_status_report *) arg);
> +		else
> +			rval = -ENOTTY;
> +		break;
> +	case SI476X_IOC_SET_PHDIV_MODE:
> +		if (radio->ops->phase_diversity)
> +			rval = radio->ops->phase_diversity(radio->core,
> +				*((enum si476x_phase_diversity_mode *) arg));
> +		else
> +			rval = -ENOTTY;
> +		break;
> +	case SI476X_IOC_GET_PHDIV_STATUS:
> +		if (radio->ops->phase_div_status) {
> +			rval = radio->ops->phase_div_status(radio->core);
> +			if (rval >= 0) {
> +				*((int *)arg) = rval;
> +				rval = 0;
> +			}
> +		} else {
> +			rval = -ENOTTY;
> +		}
> +		break;
> +	case SI476X_IOC_GET_ACF:
> +		if (radio->ops->acf_status)
> +			rval = radio->ops->acf_status(radio->core,
> +				(struct si476x_acf_status_report *)arg);
> +		else
> +			rval = -ENOTTY;
> +		break;
> +	case SI476X_IOC_GET_AGC:
> +		if (radio->ops->agc_status)
> +			rval = radio->ops->agc_status(radio->core,
> +				(struct si476x_agc_status_report *)arg);
> +		else
> +			rval = -ENOTTY;
> +		break;
> +	case SI476X_IOC_GET_RDS_BLKCNT:
> +		if (radio->ops->rds_blckcnt)
> +			rval = radio->ops->rds_blckcnt(radio->core, true,
> +				(struct si476x_rds_blockcount_report *)arg);
> +		else
> +			rval = -ENOTTY;
> +		break;

Please give an explanation of these custom ioctls and why you think this
driver needs them. Perhaps these can be implemented in a more generic manner.

> +#ifndef CONFIG_VIDEO_ADV_DEBUG
> +	case VIDIOC_DBG_G_REGISTER:
> +		rval = __g_register(file, fh, arg);
> +		break;
> +	case VIDIOC_DBG_S_REGISTER:
> +		rval = __s_register(file, fh, arg);
> +		break;

Why are these here? These are available in v4l2_ioctls_op.

> +#endif
> +	default:
> +		/* nothing */
> +		rval = -ENOTTY;
> +		break;
> +	}
> +
> +	si476x_core_unlock(radio->core);
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	return rval;
> +}
> +
> +static int si476x_radio_fops_open(struct file *file)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	si476x_radio_get(radio);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		err = -ENODEV;
> +		goto up_semaphore;
> +	}
> +
> +	if (atomic_inc_return(&radio->core->users) == 1) {
> +		si476x_core_lock(radio->core);
> +		err = si476x_core_set_power_state(radio->core,
> +						     SI476X_POWER_UP_FULL);
> +		if (err < 0)
> +			goto done;
> +
> +		err = si476x_radio_initialize_mode(radio);
> +		if (err < 0)
> +			goto power_down;
> +
> +		si476x_core_unlock(radio->core);
> +	} else {
> +		err = 0;
> +	}
> +
> +	up_read(&radio->core_lock);
> +	return err;
> +
> +power_down:
> +	si476x_core_set_power_state(radio->core,
> +				    SI476X_POWER_DOWN);
> +done:
> +	si476x_core_unlock(radio->core);
> +	atomic_dec(&radio->core->users);
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	si476x_radio_put(radio);
> +	return err;
> +}
> +
> +static int si476x_radio_fops_release(struct file *file)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		err = -ENODEV;
> +		goto up_semaphore;
> +	}
> +
> +	if (atomic_dec_and_test(&radio->core->users)) {
> +		err = si476x_core_set_power_state(radio->core,
> +						  SI476X_POWER_DOWN);
> +	} else {
> +		err = 0;
> +	}
> +
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	si476x_radio_put(radio);
> +	return err;
> +}
> +
> +static ssize_t si476x_radio_fops_read(struct file *file, char __user *buf,
> +				      size_t count, loff_t *ppos)
> +{
> +	ssize_t      rval;
> +	size_t       fifo_len;
> +	unsigned int copied;
> +
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +
> +	if (!radio->core) {
> +		rval = -ENODEV;
> +		goto up_semaphore;
> +	}
> +
> +	/* block if no new data available */
> +	if (kfifo_is_empty(&radio->core->rds_fifo)) {
> +		if (file->f_flags & O_NONBLOCK) {
> +			rval = -EWOULDBLOCK;
> +			goto up_semaphore;
> +		}
> +		rval = wait_event_interruptible(radio->core->rds_read_queue,
> +				(!kfifo_is_empty(&radio->core->rds_fifo) ||
> +				 !atomic_read(&radio->core->is_alive)));
> +		if (rval < 0) {
> +			rval = -EINTR;
> +			goto up_semaphore;
> +		}
> +		if (!atomic_read(&radio->core->is_alive)) {
> +			rval = -ENODEV;
> +			goto up_semaphore;
> +		}
> +	}
> +
> +	fifo_len = kfifo_len(&radio->core->rds_fifo);
> +
> +	if (kfifo_to_user(&radio->core->rds_fifo, buf,
> +			  min(fifo_len, count),
> +			  &copied) != 0) {
> +		dev_warn(&radio->videodev->dev,
> +			 "Error durnig FIFO to userspace copy\n");
> +		rval = -EIO;
> +	} else {
> +		rval = (ssize_t)copied;
> +	}
> +
> +up_semaphore:
> +	up_read(&radio->core_lock);
> +	return rval;
> +}
> +
> +
> +static unsigned int si476x_radio_fops_poll(struct file *file,
> +				struct poll_table_struct *pts)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	down_read(&radio->core_lock);
> +	if (!radio->core) {
> +		err = POLLHUP;
> +		goto up_semaphore;
> +	}
> +
> +	if (atomic_read(&radio->core->is_alive))
> +		poll_wait(file, &radio->core->rds_read_queue, pts);
> +
> +	if (!atomic_read(&radio->core->is_alive))
> +		err = POLLHUP;
> +
> +	if (!kfifo_is_empty(&radio->core->rds_fifo))
> +		err = POLLIN | POLLRDNORM;
> +
> +up_semaphore:
> +	up_read(&radio->core_lock);

Huh? err can be undefined here. The compiler should have warned you.

> +	return err;
> +}
> +
> +static const struct v4l2_file_operations si476x_fops = {
> +	.owner			= THIS_MODULE,
> +	.read			= si476x_radio_fops_read,
> +	.poll			= si476x_radio_fops_poll,
> +	.unlocked_ioctl		= video_ioctl2,
> +	.open			= si476x_radio_fops_open,
> +	.release		= si476x_radio_fops_release,
> +};
> +
> +static const struct v4l2_ioctl_ops si4761_ioctl_ops = {
> +	.vidioc_querycap	= si476x_querycap,
> +	.vidioc_queryctrl	= si476x_queryctrl,
> +	.vidioc_querymenu       = si476x_querymenu,
> +	.vidioc_g_ctrl		= si476x_g_ctrl,
> +	.vidioc_s_ctrl		= si476x_s_ctrl,
> +	.vidioc_g_audio		= si476x_g_audio,
> +	.vidioc_s_audio		= si476x_s_audio,
> +	.vidioc_enumaudio	= si476x_enumaudio,
> +	.vidioc_g_tuner		= si476x_g_tuner,
> +
> +	.vidioc_g_frequency	= si476x_g_frequency,
> +	.vidioc_s_frequency	= si476x_s_frequency,
> +	.vidioc_s_hw_freq_seek	= si476x_s_hw_freq_seek,
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.vidioc_g_register      = si476x_g_register,
> +	.vidioc_s_register      = si476x_s_register,
> +#endif
> +	.vidioc_default         = si476x_default,
> +};
> +
> +
> +static const struct video_device si476x_viddev_template = {
> +	.fops			= &si476x_fops,
> +	.name			= DRIVER_NAME,
> +	.release		= video_device_release,
> +};
> +
> +
> +static int si476x_radio_initialize_mode(struct si476x_radio *radio)
> +{
> +	static const struct si476x_radio_ops fm_ops = {
> +		.tune_freq		= si476x_core_cmd_fm_tune_freq,
> +		.seek_start		= si476x_core_cmd_fm_seek_start,
> +		.rsq_status		= si476x_core_cmd_fm_rsq_status,
> +		.rds_blckcnt		= si476x_core_cmd_fm_rds_blockcount,
> +		.phase_diversity	= si476x_core_cmd_fm_phase_diversity,
> +		.phase_div_status	= si476x_core_cmd_fm_phase_div_status,
> +		.acf_status		= si476x_core_cmd_fm_acf_status,
> +		.agc_status		= si476x_core_cmd_agc_status,
> +	};
> +
> +	static const struct si476x_radio_ops am_ops = {
> +		.tune_freq		= si476x_core_cmd_am_tune_freq,
> +		.seek_start		= si476x_core_cmd_am_seek_start,
> +		.rsq_status		= si476x_core_cmd_am_rsq_status,
> +		.rds_blckcnt		= NULL,
> +		.phase_diversity	= NULL,
> +		.phase_div_status	= NULL,
> +		.acf_status		= si476x_core_cmd_am_acf_status,
> +		.agc_status		= NULL,
> +	};
> +
> +	static const struct si476x_radio_ops none_ops = {
> +		.tune_freq		= NULL,
> +		.seek_start		= NULL,
> +		.rsq_status		= NULL,
> +		.rds_blckcnt		= NULL,
> +		.phase_diversity	= NULL,
> +		.phase_div_status	= NULL,
> +		.acf_status		= NULL,
> +		.agc_status		= NULL,
> +	};
> +
> +	struct si476x_func_info info;
> +	int retval;
> +
> +	retval = si476x_core_cmd_func_info(radio->core, &info);
> +	if (retval < 0)
> +		return retval;
> +
> +	switch (info.func) {
> +	case SI476X_FUNC_FM_RECEIVER:
> +		radio->ops = &fm_ops;
> +		break;
> +	case SI476X_FUNC_AM_RECEIVER:
> +		radio->ops = &am_ops;
> +		break;
> +	default:
> +		WARN(1, "Unexpected tuner function value\n"); /* FALLTHROUGH */
> +	case SI476X_FUNC_WB_RECEIVER: /* FALLTHROUGH */
> +	case SI476X_FUNC_BOOTLOADER:
> +		radio->ops = &none_ops;
> +		break;
> +	}
> +
> +	return retval;
> +}
> +
> +static int __devinit si476x_radio_probe(struct platform_device *pdev)
> +{
> +	int rval;
> +	struct si476x_core **core = pdev->dev.platform_data;
> +	struct si476x_radio *radio;
> +
> +	if (!core) {
> +		dev_err(&pdev->dev, "No platform data.\n");
> +		rval = -EINVAL;
> +		goto exit;
> +	}
> +
> +	radio = kzalloc(sizeof(*radio), GFP_KERNEL);
> +	if (!radio) {
> +		rval = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	radio->core = *core;
> +	si476x_core_get(radio->core);
> +
> +	radio->videodev = video_device_alloc();

I generally recommend that video_device is embedded in the radio struct.
That way you don't have to test whether the allocation failed.

> +	if (!radio->videodev) {
> +		dev_err(&pdev->dev, "Failed to alloc video device.\n");
> +		rval = -ENOMEM;
> +		goto free_radio;
> +	}
> +
> +	memcpy(radio->videodev, &si476x_viddev_template,
> +	       sizeof(struct video_device));

	radio->videodev = si476x_viddev_template;

> +	radio->videodev->ioctl_ops = &si4761_ioctl_ops;
> +
> +	/* tie this device to some physical hardware */
> +	radio->videodev->parent = &pdev->dev;
> +
> +	video_set_drvdata(radio->videodev, radio);
> +	platform_set_drvdata(pdev, radio);
> +
> +	/* register video device */
> +	rval = video_register_device(radio->videodev, VFL_TYPE_RADIO, -1);
> +
> +	if (rval) {
> +		dev_err(&pdev->dev, "Could not register video device\n");
> +	} else {
> +		init_rwsem(&radio->core_lock);
> +		kref_init(&radio->kref);

Do this before the video_register_device.

> +		/* si476x_debugfs_init(radio, id->name); */
> +		return 0;
> +	}
> +
> +free_radio:
> +	kfree(radio);
> +exit:
> +	return rval;
> +}
> +
> +static void si476x_radio_delete(struct kref *kref)
> +{
> +	struct si476x_radio *radio = kref_to_si476x_radio(kref);
> +	kfree(radio);
> +}
> +
> +
> +static int si476x_radio_remove(struct platform_device *pdev)
> +{
> +	struct si476x_radio *radio = platform_get_drvdata(pdev);
> +
> +
> +	video_unregister_device(radio->videodev);
> +
> +	down_write(&radio->core_lock);
> +	si476x_core_put(radio->core);
> +	radio->core = NULL;
> +	up_write(&radio->core_lock);
> +
> +	si476x_radio_put(radio);
> +
> +	return 0;
> +}
> +
> +MODULE_ALIAS("platform:si476x-radio");
> +
> +static struct platform_driver si476x_radio_driver = {
> +	.probe		= si476x_radio_probe,
> +	.remove		= __devexit_p(si476x_radio_remove),
> +	.driver		= {
> +		.name	= DRIVER_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init si476x_module_init(void)
> +{
> +	return platform_driver_register(&si476x_radio_driver);
> +}
> +module_init(si476x_module_init);
> +
> +static void __exit si476x_module_exit(void)
> +{
> +	platform_driver_unregister(&si476x_radio_driver);
> +}
> +module_exit(si476x_module_exit);
> +
> +MODULE_AUTHOR("Andrey Smirnov <andrey.smirnov@convergeddevices.net>");
> +MODULE_DESCRIPTION("Driver for Si4761/64/68 AM/FM Radio MFD Cell");
> +MODULE_LICENSE("GPL");
> 

Regards,

	Hans
