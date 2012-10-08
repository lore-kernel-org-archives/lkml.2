Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab2JHJa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 05:30:57 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3748 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2JHJaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 05:30:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Subject: Re: [PATCH v2 5/6] Add a V4L2 driver for SI476X MFD
Date: Mon, 8 Oct 2012 11:30:28 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc5-tschai; KDE/4.8.4; x86_64; ; )
Cc: andrey.smrinov@convergeddevices.net, mchehab@redhat.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        perex@perex.cz, tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net> <1349488502-11293-6-git-send-email-andrey.smirnov@convergeddevices.net>
In-Reply-To: <1349488502-11293-6-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210081130.28233.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat October 6 2012 03:55:01 Andrey Smirnov wrote:
> This commit adds a driver that exposes all the radio related
> functionality of the Si476x series of chips via the V4L2 subsystem.
> 
> Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
> ---
>  drivers/media/radio/Kconfig        |   17 +
>  drivers/media/radio/Makefile       |    1 +
>  drivers/media/radio/radio-si476x.c | 1153 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 1171 insertions(+)
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
> diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
> index c03ce4f..c4618e0 100644
> --- a/drivers/media/radio/Makefile
> +++ b/drivers/media/radio/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_RADIO_GEMTEK) += radio-gemtek.o
>  obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
>  obj-$(CONFIG_I2C_SI4713) += si4713-i2c.o
>  obj-$(CONFIG_RADIO_SI4713) += radio-si4713.o
> +obj-$(CONFIG_RADIO_SI476X) += radio-si476x.o
>  obj-$(CONFIG_RADIO_MIROPCM20) += radio-miropcm20.o
>  obj-$(CONFIG_USB_DSBR) += dsbr100.o
>  obj-$(CONFIG_RADIO_SI470X) += si470x/
> diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
> new file mode 100644
> index 0000000..2d943da
> --- /dev/null
> +++ b/drivers/media/radio/radio-si476x.c
> @@ -0,0 +1,1153 @@
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/atomic.h>
> +#include <linux/videodev2.h>
> +#include <linux/mutex.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-device.h>
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
> +enum si476x_freq_bands {
> +	SI476X_BAND_FM,
> +	SI476X_BAND_AM,
> +};
> +
> +static const struct v4l2_frequency_band si476x_bands[] = {
> +	[SI476X_BAND_FM] = {
> +		.type		= V4L2_TUNER_RADIO,
> +		.index		= SI476X_BAND_FM,
> +		.capability	= V4L2_TUNER_CAP_LOW
> +		| V4L2_TUNER_CAP_STEREO
> +		| V4L2_TUNER_CAP_RDS
> +		| V4L2_TUNER_CAP_RDS_BLOCK_IO
> +		| V4L2_TUNER_CAP_FREQ_BANDS,
> +		.rangelow	=  64 * FREQ_MUL,
> +		.rangehigh	= 108 * FREQ_MUL,
> +		.modulation	= V4L2_BAND_MODULATION_FM,
> +	},
> +	[SI476X_BAND_AM] = {
> +		.type		= V4L2_TUNER_RADIO,
> +		.index		= SI476X_BAND_AM,
> +		.capability	= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
> +		.rangelow	= 0.52 * FREQ_MUL,
> +		.rangehigh	= 30 * FREQ_MUL,
> +		.modulation	= V4L2_BAND_MODULATION_AM,
> +	},
> +};
> +
> +#define PRIVATE_CTL_IDX(x) (x - V4L2_CID_PRIVATE_BASE)
> +
> +static int si476x_s_ctrl(struct v4l2_ctrl *ctrl);
> +
> +static const char * const deemphasis[] = {
> +	"75 us",
> +	"50 us",
> +};
> +
> +static const struct v4l2_ctrl_ops si476x_ctrl_ops = {
> +	.s_ctrl = si476x_s_ctrl,
> +};
> +
> +static const struct v4l2_ctrl_config si476x_ctrls[] = {
> +	/*
> +	   Tuning parameters
> +	   'max tune errors' is shared for both AM/FM mode of operation
> +	*/
> +	{
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= SI476X_CID_RSSI_THRESHOLD,
> +		.name	= "valid rssi threshold",
> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> +		.min	= -128,
> +		.max	= 127,
> +		.step	= 1,
> +	},
> +	{
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= SI476X_CID_SNR_THRESHOLD,
> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> +		.name	= "valid snr threshold",
> +		.min	= -128,
> +		.max	= 127,
> +		.step	= 1,
> +	},
> +	{
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= SI476X_CID_MAX_TUNE_ERROR,
> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> +		.name	= "max tune errors",
> +		.min	= 0,
> +		.max	= 126 * 2,
> +		.step	= 2,
> +	},
> +	/*
> +	   Region specific parameters
> +	*/
> +	{
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= SI476X_CID_HARMONICS_COUNT,
> +		.type	= V4L2_CTRL_TYPE_INTEGER,
> +		.name	= "count of harmonics to reject",
> +		.min	= 0,
> +		.max	= 20,
> +		.step	= 1,
> +	},
> +	{
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= SI476X_CID_DEEMPHASIS,
> +		.type	= V4L2_CTRL_TYPE_MENU,
> +		.name	= "de-emphassis",
> +		.qmenu	= deemphasis,
> +		.min	= 0,
> +		.max	= ARRAY_SIZE(deemphasis) - 1,
> +		.def	= 0,
> +	},

I think most if not all of the controls above are candidates for turning into
standardized controls. I recommend that you make a proposal (RFC) for this.

This may be useful as well:

http://lists-archives.com/linux-kernel/27641304-radio-fixes-and-new-features-for-fm.html

This patch series contains a standardized DEEMPHASIS control.
Note that this patch series is outdated, but patch 2/5 is OK.

> +	{
> +		.ops	= &si476x_ctrl_ops,
> +		.id	= SI476X_CID_RDS_RECEPTION,
> +		.type	= V4L2_CTRL_TYPE_BOOLEAN,
> +		.name	= "rds",
> +		.min	= 0,
> +		.max	= 1,
> +		.step	= 1,
> +	},

If this control returns whether or not RDS is detected, then this control
should be removed. VIDIOC_G_TUNER will return that information in rxsubchans.

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
> +	struct v4l2_device v4l2dev;
> +	struct video_device videodev;
> +	struct v4l2_ctrl_handler ctrl_handler;
> +
> +	struct si476x_core  *core;
> +	/* This field should not be accesses unless core lock is held */
> +	const struct si476x_radio_ops *ops;
> +
> +	u32 rangelow;
> +	u32 rangehigh;
> +	u32 spacing;
> +	u32 audmode;
> +};
> +
> +static inline struct si476x_radio *v4l2_dev_to_radio(struct v4l2_device *d)
> +{
> +	return container_of(d, struct si476x_radio, v4l2dev);
> +}
> +
> +static inline struct si476x_radio *v4l2_ctrl_handler_to_radio(struct v4l2_ctrl_handler *d)
> +{
> +	return container_of(d, struct si476x_radio, ctrl_handler);
> +}
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
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	strlcpy(capability->driver, radio->v4l2dev.name,
> +		sizeof(capability->driver));
> +	strlcpy(capability->card,   DRIVER_CARD, sizeof(capability->card));
> +	strlcpy(capability->bus_info, radio->v4l2dev.name, sizeof(capability->bus_info));

Bus info needs the proper prefix. See the latest querycap documentation:

http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-querycap

> +
> +	capability->device_caps = V4L2_CAP_TUNER
> +		| V4L2_CAP_RADIO
> +		| V4L2_CAP_RDS_CAPTURE
> +		| V4L2_CAP_READWRITE
> +		| V4L2_CAP_HW_FREQ_SEEK;
> +	capability->capabilities = \

Remove the trailing \

> +		capability->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	return 0;
> +}
> +
> +static int si476x_enum_freq_bands(struct file *file, void *priv,
> +				  struct v4l2_frequency_band *band)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	if (band->tuner != 0)
> +		return -EINVAL;

This needs a check against non-blocking mode and it should return -EAGAIN
if it is non-blocking. HWSEEK while in non-blocking mode is currently not
supported by the API.

> +
> +	switch (radio->core->chip_id) {
> +		/* AM/FM tuners -- all bands are supported */
> +	case SI476X_CHIP_SI4761:
> +	case SI476X_CHIP_SI4762:
> +	case SI476X_CHIP_SI4763:
> +	case SI476X_CHIP_SI4764:
> +		if (band->index < ARRAY_SIZE(si476x_bands)) {
> +			*band = si476x_bands[band->index];
> +			err = 0;
> +		} else {
> +			err = -EINVAL;
> +		}
> +		break;
> +		/* FM companion tuner chips -- only FM bands are
> +		 * supported */
> +	case SI476X_CHIP_SI4768:
> +	case SI476X_CHIP_SI4769:
> +		if (band->index == SI476X_BAND_FM) {
> +			*band = si476x_bands[band->index];
> +			err = 0;
> +		} else {
> +			err = -EINVAL;
> +		}
> +		break;
> +	default:
> +		err = -EINVAL;
> +	}
> +
> +	return err;
> +}
> +
> +static int si476x_g_tuner(struct file *file, void *priv,
> +			  struct v4l2_tuner *tuner)
> +{
> +	int err;
> +	struct si476x_rsq_status_report report;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	if (tuner->index != 0)
> +		return -EINVAL;
> +
> +	tuner->type       = V4L2_TUNER_RADIO;
> +	tuner->capability = V4L2_TUNER_CAP_LOW /* Measure frequncies

frequncies -> frequencies

> +						 * in multiples of
> +						 * 62.5 Hz */
> +		| V4L2_TUNER_CAP_STEREO
> +		| V4L2_TUNER_CAP_HWSEEK_BOUNDED
> +		| V4L2_TUNER_CAP_HWSEEK_WRAP;

You probably should also set V4L2_TUNER_CAP_HWSEEK_PROG_LIM. See
http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-s-hw-freq-seek

> +
> +	switch (radio->core->chip_id) {
> +		/* AM/FM tuners -- all bands are supported */
> +	case SI476X_CHIP_SI4764:
> +		if (radio->core->diversity_mode == SI476X_PHDIV_SECONDARY_ANTENNA ||
> +		    radio->core->diversity_mode == SI476X_PHDIV_SECONDARY_COMBINING) {
> +			strlcpy(tuner->name, "FM (secondary)", sizeof(tuner->name));
> +			tuner->capability = 0;
> +			tuner->rxsubchans = 0;
> +			break;
> +		}
> +
> +		if (radio->core->diversity_mode == SI476X_PHDIV_PRIMARY_ANTENNA ||
> +		    radio->core->diversity_mode == SI476X_PHDIV_PRIMARY_COMBINING)
> +			strlcpy(tuner->name, "AM/FM (primary)", sizeof(tuner->name));
> +
> +	case SI476X_CHIP_SI4761: /* FALLTHROUGH */
> +	case SI476X_CHIP_SI4762:
> +	case SI476X_CHIP_SI4763:
> +		if (radio->core->chip_id != SI476X_CHIP_SI4764)
> +			strlcpy(tuner->name, "AM/FM", sizeof(tuner->name));
> +
> +		tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO
> +			| V4L2_TUNER_SUB_RDS;
> +		tuner->capability |= V4L2_TUNER_CAP_RDS
> +			| V4L2_TUNER_CAP_RDS_BLOCK_IO
> +			| V4L2_TUNER_CAP_FREQ_BANDS;
> +
> +		tuner->rangelow = si476x_bands[SI476X_BAND_AM].rangelow;
> +
> +		break;
> +		/* FM companion tuner chips -- only FM bands are
> +		 * supported */
> +	case SI476X_CHIP_SI4768:
> +	case SI476X_CHIP_SI4769:
> +		tuner->rxsubchans = V4L2_TUNER_SUB_RDS;
> +		tuner->capability |= V4L2_TUNER_CAP_RDS
> +			| V4L2_TUNER_CAP_RDS_BLOCK_IO
> +			| V4L2_TUNER_CAP_FREQ_BANDS;
> +		tuner->rangelow = si476x_bands[SI476X_BAND_FM].rangelow;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	tuner->audmode = radio->audmode;
> +
> +	tuner->afc = 1;
> +	tuner->rangehigh = si476x_bands[SI476X_BAND_FM].rangehigh;
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
> +	return err;
> +}
> +
> +static int si476x_s_tuner(struct file *file, void *priv,
> +				 struct v4l2_tuner *tuner)
> +{
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	if (tuner->index != 0)
> +		return -EINVAL;
> +	else if (tuner->audmode == V4L2_TUNER_MODE_MONO ||

No need for the 'else' keyword.

> +		 tuner->audmode == V4L2_TUNER_MODE_STEREO)
> +		radio->audmode = tuner->audmode;

If audmode is neither mono nor stereo, then you should fall back to stereo.

> +
> +	return 0;
> +}
> +
> +static int si476x_switch_func(struct si476x_radio *radio, enum si476x_func func)
> +{
> +	int err;
> +
> +	/*
> +	   Since power/up down is a very time consuming operation,
> +	   try to avoid doing it if the requested mode matches the one
> +	   the tuner is in
> +	*/
> +	if (func == radio->core->power_up_parameters.func)
> +		return 0;
> +
> +	err = si476x_core_stop(radio->core, true);
> +	if (err < 0)
> +		return err;
> +
> +	radio->core->power_up_parameters.func = func;
> +
> +	err = si476x_core_start(radio->core, true);
> +	if (!err)
> +		err = si476x_radio_initialize_mode(radio);
> +
> +	return err;
> +}
> +
> +static int si476x_g_frequency(struct file *file, void *priv,
> +			      struct v4l2_frequency *f)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	if (f->tuner != 0 ||
> +	    f->type  != V4L2_TUNER_RADIO)
> +		return -EINVAL;
> +
> +	si476x_core_lock(radio->core);
> +
> +	f->type = V4L2_TUNER_RADIO;

This line is obviously not needed.

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
> +
> +	return err;
> +}
> +
> +static int si476x_s_frequency(struct file *file, void *priv,
> +			      struct v4l2_frequency *f)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	if (f->tuner != 0 ||
> +	    f->type  != V4L2_TUNER_RADIO)
> +		return -EINVAL;
> +
> +	si476x_core_lock(radio->core);
> +
> +	/* Remap rangewlow - 1 and rangehigh + 1 */
> +	if (f->frequency == si476x_bands[SI476X_BAND_FM].rangelow - 1 ||
> +	    f->frequency == si476x_bands[SI476X_BAND_AM].rangelow - 1)
> +		f->frequency += 1;
> +
> +	if (f->frequency == si476x_bands[SI476X_BAND_FM].rangehigh + 1 ||
> +	    f->frequency == si476x_bands[SI476X_BAND_AM].rangehigh + 1)
> +		f->frequency -= 1;

Huh?

I think you are working around a v4l2-compliance test where I use rangelow-1 and
rangehigh+1 to test if s_frequency will correctly clamp frequencies. But obviously
the point is to clamp any out-of-range frequency to the closest valid frequency
range.

In other words, an out-of-range frequency value shouldn't result in an error,
but it should be mapped to the closest valid frequency.

> +
> +	switch (radio->core->chip_id) {
> +	case SI476X_CHIP_SI4764:
> +		if (radio->core->diversity_mode == SI476X_PHDIV_SECONDARY_ANTENNA ||
> +		    radio->core->diversity_mode == SI476X_PHDIV_SECONDARY_COMBINING)
> +			if (f->frequency < si476x_bands[SI476X_BAND_FM].rangelow ||
> +			    f->frequency > si476x_bands[SI476X_BAND_FM].rangehigh) {
> +				err = -EDOM;
> +				goto unlock;
> +			}
> +	case SI476X_CHIP_SI4761: /* FALLTHROUGH */
> +	case SI476X_CHIP_SI4762:
> +	case SI476X_CHIP_SI4763:
> +		if (f->frequency < si476x_bands[SI476X_BAND_AM].rangelow ||
> +		    f->frequency > si476x_bands[SI476X_BAND_FM].rangehigh) {
> +			err = -EDOM;
> +			goto unlock;
> +		}
> +		break;
> +	case SI476X_CHIP_SI4768:
> +	case SI476X_CHIP_SI4769:
> +		if (f->frequency < si476x_bands[SI476X_BAND_FM].rangelow ||
> +		    f->frequency > si476x_bands[SI476X_BAND_FM].rangehigh) {
> +			err = -EDOM;
> +			goto unlock;
> +		}
> +		break;
> +	default:
> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +
> +
> +	if (f->frequency < si476x_bands[SI476X_BAND_FM].rangelow)
> +		si476x_switch_func(radio, SI476X_FUNC_AM_RECEIVER);
> +	else
> +		si476x_switch_func(radio, SI476X_FUNC_FM_RECEIVER);
> +
> +	if (radio->ops->tune_freq) {
> +		struct si476x_tune_freq_args args = {
> +			.zifsr		= false,
> +			.hd		= false,
> +			.injside	= SI476X_INJSIDE_AUTO,
> +			.freq		= v4l2_to_si476x(radio->core,
> +							 f->frequency),
> +			.tunemode	= SI476X_TM_VALIDATED_NORMAL_TUNE,
> +			.smoothmetrics	= SI476X_SM_INITIALIZE_AUDIO,
> +			.antcap		= 0,
> +		};
> +		err = radio->ops->tune_freq(radio->core, &args);
> +	} else {
> +		err = -ENOTTY;
> +	}
> +
> +unlock:
> +	si476x_core_unlock(radio->core);
> +
> +	return err;
> +}
> +
> +static int si476x_s_hw_freq_seek(struct file *file, void *priv,
> +				 struct v4l2_hw_freq_seek *seek)
> +{
> +	int err;
> +	u32 rangelow, rangehigh;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	if (seek->tuner != 0 ||
> +	    seek->type  != V4L2_TUNER_RADIO)
> +		return -EINVAL;
> +
> +	si476x_core_lock(radio->core);
> +
> +	rangelow = (!seek->rangelow) ? radio->rangelow : seek->rangelow;
> +	rangehigh = (!seek->rangehigh) ? radio->rangehigh : seek->rangehigh;
> +
> +	if ((rangelow  >= si476x_bands[SI476X_BAND_FM].rangelow) &&
> +	    rangehigh <= si476x_bands[SI476X_BAND_FM].rangehigh) {
> +		si476x_switch_func(radio, SI476X_FUNC_FM_RECEIVER);
> +	} else if (rangelow  >= si476x_bands[SI476X_BAND_AM].rangelow &&
> +		   rangehigh <= si476x_bands[SI476X_BAND_AM].rangehigh) {

This should include a check whether this chip supports AM.

In addition, we should check that rangelow <= rangehigh


> +		si476x_switch_func(radio, SI476X_FUNC_AM_RECEIVER);
> +	} else {
> +		err = -EDOM;

-EINVAL

> +		goto unlock;
> +	}
> +
> +	/* Cache the following parameters to imporve seek operation
> +	 * performance */
> +	if (seek->rangehigh && radio->rangehigh != seek->rangehigh) {
> +		err = si476x_core_set_seek_band_top(radio->core,
> +						    v4l2_to_hz(seek->rangehigh));
> +		if (err)
> +			goto unlock;
> +		radio->rangehigh = seek->rangehigh;
> +	}
> +	if (seek->rangelow && radio->rangelow != seek->rangelow) {
> +		err = si476x_core_set_seek_band_bottom(radio->core,
> +						       v4l2_to_hz(seek->rangelow));
> +		if (err)
> +			goto unlock;
> +		radio->rangelow = seek->rangelow;
> +	}
> +	if (seek->spacing && radio->spacing != seek->spacing) {
> +		err = si476x_core_set_frequency_spacing(radio->core,
> +							v4l2_to_hz(seek->spacing));
> +		if (err)
> +			goto unlock;
> +		radio->spacing = seek->spacing;
> +	}
> +
> +
> +	if (radio->ops->seek_start)
> +		err = radio->ops->seek_start(radio->core,
> +					     seek->seek_upward,
> +					     seek->wrap_around);
> +	else
> +		err = -ENOTSUPP;

-ENOTTY

BTW, it is better to test whether certain ioctls are supported just before the
radio node is registered, and to disable such ioctls using v4l2_disable_ioctl()
(see include/media/v4l2-dev.h)

> +
> +
> +unlock:
> +	si476x_core_unlock(radio->core);
> +
> +	return err;
> +}
> +static int si476x_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	int old_value, retval, count;
> +	struct si476x_radio *radio = v4l2_ctrl_handler_to_radio(ctrl->handler);
> +
> +	si476x_core_lock(radio->core);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_POWER_LINE_FREQUENCY:
> +		old_value = si476x_core_get_audio_pwr_line_filter(radio->core);
> +		if (old_value < 0) {
> +			retval = old_value;
> +			break;
> +		}
> +		count = old_value & 0x0F;
> +
> +		switch (ctrl->val) {
> +		case V4L2_CID_POWER_LINE_FREQUENCY_DISABLED:
> +			retval = si476x_core_set_audio_pwr_line_filter(radio->core,
> +								       false,
> +								       SI476X_POWER_GRID_50HZ,
> +								       count);
> +			break;
> +		case V4L2_CID_POWER_LINE_FREQUENCY_50HZ:
> +			retval = si476x_core_set_audio_pwr_line_filter(radio->core,
> +								       (count > 0) ? true : false,
> +								       SI476X_POWER_GRID_50HZ,
> +								       count);
> +			break;
> +		case V4L2_CID_POWER_LINE_FREQUENCY_60HZ:
> +			retval = si476x_core_set_audio_pwr_line_filter(radio->core,
> +								       (count > 0) ? true : false,
> +								       SI476X_POWER_GRID_60HZ,
> +								       count);
> +			break;
> +		default:
> +			BUG();

Don't use BUG here, just break. This can never happen anyway.

> +			break;
> +		}
> +		break;
> +	case SI476X_CID_RSSI_THRESHOLD:
> +		retval = si476x_core_set_valid_rssi_threshold(radio->core,
> +							      ctrl->val);
> +		break;
> +	case SI476X_CID_SNR_THRESHOLD:
> +		retval = si476x_core_set_valid_snr_threshold(radio->core,
> +							     ctrl->val);
> +		break;
> +	case SI476X_CID_MAX_TUNE_ERROR:
> +		retval = si476x_core_set_valid_max_tune_error(radio->core,
> +							      ctrl->val);
> +		break;
> +	case SI476X_CID_RDS_RECEPTION:
> +		retval = si476x_core_set_rds_reception(radio->core,
> +						       ctrl->val);
> +		break;
> +	case SI476X_CID_DEEMPHASIS:
> +		retval = si476x_core_set_audio_deemphasis(radio->core,
> +							  ctrl->val);
> +		break;
> +	case SI476X_CID_HARMONICS_COUNT:
> +		old_value = si476x_core_get_audio_pwr_line_filter(radio->core);
> +		if (old_value < 0) {
> +			retval = old_value;
> +			break;
> +		}
> +
> +		retval = si476x_core_set_audio_pwr_line_filter(radio->core,
> +					(ctrl->val > 0) ? true : false,
> +					!!(PWRLINEFLTR & old_value),
> +					ctrl->val);
> +		break;
> +	default:
> +		retval = -EINVAL;
> +		break;
> +	}
> +
> +	si476x_core_unlock(radio->core);
> +
> +	return retval;
> +}
> +
> +static int si476x_g_chip_ident(struct file *file, void *fh,
> +			       struct v4l2_dbg_chip_ident *chip)
> +{
> +	if (chip->match.type == V4L2_CHIP_MATCH_HOST &&
> +	    v4l2_chip_match_host(&chip->match))
> +		return 0;
> +	return -EINVAL;
> +}
> +
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
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
> +static int si476x_g_register(struct file *file, void *fh,
> +			     struct v4l2_dbg_register *reg)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	si476x_core_lock(radio->core);
> +	err = __g_register(file, fh, reg);
> +	si476x_core_unlock(radio->core);
> +
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
> +	si476x_core_lock(radio->core);
> +	err = __s_register(file, fh, reg);
> +	si476x_core_unlock(radio->core);
> +
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
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	si476x_core_lock(radio->core);
> +	switch (cmd) {
> +	case SI476X_IOC_GET_RSQ_PRIMARY:
> +		args.primary = true;
> +	case SI476X_IOC_GET_RSQ: /* FALLTHROUG */
> +		if (radio->ops->rsq_status)
> +			rval = radio->ops->rsq_status(radio->core, &args,
> +						      (struct si476x_rsq_status_report *) arg);
> +		else
> +			rval = -ENOTTY;
> +		break;
> +	case SI476X_IOC_SET_PHDIV_MODE:

You should check for valid_prio here:

		if (!valid_prio)
			rval = -EBUSY;

> +		if (radio->ops->phase_diversity)
> +			rval = radio->ops->phase_diversity(radio->core,
> +							   *((enum si476x_phase_diversity_mode *) arg));
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
> +						      (struct si476x_acf_status_report *)arg);
> +		else
> +			rval = -ENOTTY;
> +		break;
> +	case SI476X_IOC_GET_AGC:
> +		if (radio->ops->agc_status)
> +			rval = radio->ops->agc_status(radio->core,
> +						      (struct si476x_agc_status_report *)arg);
> +		else
> +			rval = -ENOTTY;
> +		break;
> +	case SI476X_IOC_GET_RDS_BLKCNT:
> +		if (radio->ops->rds_blckcnt)
> +			rval = radio->ops->rds_blckcnt(radio->core, true,
> +						       (struct si476x_rds_blockcount_report *)arg);
> +		else
> +			rval = -ENOTTY;
> +		break;
> +	default:
> +		/* nothing */
> +		rval = -ENOTTY;
> +		break;
> +	}
> +
> +	si476x_core_unlock(radio->core);
> +	return rval;
> +}
> +
> +static int si476x_radio_fops_open(struct file *file)
> +{
> +	struct si476x_radio *radio = video_drvdata(file);
> +	int err;
> +
> +	err = v4l2_fh_open(file);
> +	if (err)
> +		return err;
> +
> +	if (v4l2_fh_is_singular_file(file)) {
> +		si476x_core_lock(radio->core);
> +		err = si476x_core_set_power_state(radio->core,
> +						  SI476X_POWER_UP_FULL);
> +		if (err < 0)
> +			goto done;
> +
> +		err = si476x_radio_initialize_mode(radio);
> +		if (err < 0)
> +			goto power_down;
> +
> +		si476x_core_unlock(radio->core);
> +		/* Must be done after si476x_core_unlock to prevent a deadlock */
> +		v4l2_ctrl_handler_setup(&radio->ctrl_handler);
> +	}
> +
> +	/* v4l2_device_get(&radio->v4l2dev); */
> +
> +	return err;
> +
> +power_down:
> +	si476x_core_set_power_state(radio->core,
> +				    SI476X_POWER_DOWN);
> +done:
> +	si476x_core_unlock(radio->core);
> +	v4l2_fh_release(file);
> +
> +	return err;
> +}
> +
> +static int si476x_radio_fops_release(struct file *file)
> +{
> +	int err;
> +	struct si476x_radio *radio = video_drvdata(file);
> +
> +	if (v4l2_fh_is_singular_file(file) &&
> +	    atomic_read(&radio->core->is_alive))
> +		si476x_core_set_power_state(radio->core,
> +					    SI476X_POWER_DOWN);
> +
> +	err = v4l2_fh_release(file);
> +	/* v4l2_device_put(&radio->v4l2dev); */
> +
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
> +	/* block if no new data available */
> +	if (kfifo_is_empty(&radio->core->rds_fifo)) {
> +		if (file->f_flags & O_NONBLOCK)
> +			return -EWOULDBLOCK;
> +
> +		rval = wait_event_interruptible(radio->core->rds_read_queue,
> +				(!kfifo_is_empty(&radio->core->rds_fifo) ||
> +				 !atomic_read(&radio->core->is_alive)));
> +		if (rval < 0) 
> +			return -EINTR;
> +
> +		if (!atomic_read(&radio->core->is_alive))
> +			return -ENODEV;
> +	}
> +
> +	fifo_len = kfifo_len(&radio->core->rds_fifo);
> +
> +	if (kfifo_to_user(&radio->core->rds_fifo, buf,
> +			  min(fifo_len, count),
> +			  &copied) != 0) {
> +		dev_warn(&radio->videodev.dev,
> +			 "Error durnig FIFO to userspace copy\n");
> +		rval = -EIO;
> +	} else {
> +		rval = (ssize_t)copied;
> +	}
> +
> +	return rval;
> +}
> +
> +static unsigned int si476x_radio_fops_poll(struct file *file,
> +				struct poll_table_struct *pts)
> +{
> +	struct si476x_radio *radio = video_drvdata(file);
> +	unsigned long req_events = poll_requested_events(pts);
> +	int err = v4l2_ctrl_poll(file, pts);	
> +       
> +	if (req_events & (POLLIN | POLLRDNORM)) {
> +		if (atomic_read(&radio->core->is_alive))
> +			poll_wait(file, &radio->core->rds_read_queue, pts);
> +
> +		if (!atomic_read(&radio->core->is_alive))
> +			err = POLLHUP;
> +
> +		if (!kfifo_is_empty(&radio->core->rds_fifo))
> +			err = POLLIN | POLLRDNORM;
> +	}
> +
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
> +
> +static const struct v4l2_ioctl_ops si4761_ioctl_ops = {
> +	.vidioc_querycap		= si476x_querycap,
> +	.vidioc_g_tuner			= si476x_g_tuner,
> +	.vidioc_s_tuner			= si476x_s_tuner,
> +
> +	.vidioc_g_frequency		= si476x_g_frequency,
> +	.vidioc_s_frequency		= si476x_s_frequency,
> +	.vidioc_s_hw_freq_seek		= si476x_s_hw_freq_seek,
> +	.vidioc_enum_freq_bands		= si476x_enum_freq_bands,
> +
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +
> +	.vidioc_g_chip_ident		= si476x_g_chip_ident,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.vidioc_g_register		= si476x_g_register,
> +	.vidioc_s_register		= si476x_s_register,
> +#endif
> +	.vidioc_default			= si476x_default,
> +};
> +
> +
> +static const struct video_device si476x_viddev_template = {
> +	.fops			= &si476x_fops,
> +	.name			= DRIVER_NAME,
> +	.release		= video_device_release_empty,
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
> +	struct si476x_tune_freq_args args = {
> +		.zifsr		= false,
> +		.hd		= false,
> +		.injside	= SI476X_INJSIDE_AUTO,
> +		.tunemode	= SI476X_TM_VALIDATED_NORMAL_TUNE,
> +		.smoothmetrics	= SI476X_SM_INITIALIZE_AUDIO,
> +		.antcap		= 0,
> +	};
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
> +		args.freq = v4l2_to_si476x(radio->core,
> +					   92 * FREQ_MUL);
> +		retval = radio->ops->tune_freq(radio->core, &args);
> +		break;
> +	case SI476X_FUNC_AM_RECEIVER:
> +		radio->ops = &am_ops;
> +		args.freq = v4l2_to_si476x(radio->core,
> +					   0.6 * FREQ_MUL);
> +		retval = radio->ops->tune_freq(radio->core, &args);
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
> +	int rval, i;
> +	struct si476x_radio *radio;
> +
> +	static atomic_t instance = ATOMIC_INIT(0);
> +
> +	radio = devm_kzalloc(&pdev->dev, sizeof(*radio), GFP_KERNEL);
> +	if (!radio)
> +		return -ENOMEM;
> +
> +	radio->core = i2c_mfd_cell_to_core(&pdev->dev);
> +
> +	switch (radio->core->power_up_parameters.func) {
> +	default:
> +	case SI476X_FUNC_FM_RECEIVER:
> +		radio->rangelow  = si476x_bands[SI476X_BAND_FM].rangelow;
> +		radio->rangehigh = si476x_bands[SI476X_BAND_FM].rangehigh;
> +		break;
> +	case SI476X_FUNC_AM_RECEIVER:
> +		radio->rangelow  = si476x_bands[SI476X_BAND_AM].rangelow;
> +		radio->rangehigh = si476x_bands[SI476X_BAND_AM].rangehigh;
> +		break;
> +	}
> +
> +	v4l2_device_set_name(&radio->v4l2dev, DRIVER_NAME, &instance);
> +
> +	rval = v4l2_device_register(&pdev->dev, &radio->v4l2dev);
> +	if (rval) {
> +		dev_err(&pdev->dev, "Cannot register v4l2_device.\n");
> +		return rval;
> +	}
> +
> +	memcpy(&radio->videodev, &si476x_viddev_template,
> +	       sizeof(struct video_device));
> +
> +	radio->videodev.v4l2_dev  = &radio->v4l2dev;
> +	radio->videodev.ioctl_ops = &si4761_ioctl_ops;
> +
> +
> +	video_set_drvdata(&radio->videodev, radio);
> +	platform_set_drvdata(pdev, radio);
> +
> +	set_bit(V4L2_FL_USE_FH_PRIO, &radio->videodev.flags);
> +
> +	radio->v4l2dev.ctrl_handler = &radio->ctrl_handler;
> +	v4l2_ctrl_handler_init(&radio->ctrl_handler, 1 + ARRAY_SIZE(si476x_ctrls));
> +	v4l2_ctrl_new_std_menu(&radio->ctrl_handler,
> +			       &si476x_ctrl_ops,
> +			       V4L2_CID_POWER_LINE_FREQUENCY,
> +			       V4L2_CID_POWER_LINE_FREQUENCY_60HZ, 0, 0);
> +	for (i = 0; i < ARRAY_SIZE(si476x_ctrls); ++i)
> +		v4l2_ctrl_new_custom(&radio->ctrl_handler, &si476x_ctrls[i], NULL);
> +
> +
> +	if (radio->ctrl_handler.error) {
> +		rval = radio->ctrl_handler.error;
> +		dev_err(&pdev->dev, "Could not initialize controls %d\n", rval);
> +	} else {
> +		/* register video device */
> +		rval = video_register_device(&radio->videodev, VFL_TYPE_RADIO, -1);
> +	}
> +
> +	if (rval) {
> +		dev_err(&pdev->dev, "Could not register video device\n");
> +		v4l2_ctrl_handler_free(radio->videodev.ctrl_handler);
> +		
> +		return rval;
> +	} 
> +	
> +	return 0;
> +}
> +
> +static int si476x_radio_remove(struct platform_device *pdev)
> +{
> +	struct si476x_radio *radio = platform_get_drvdata(pdev);
> +
> +	v4l2_ctrl_handler_free(radio->videodev.ctrl_handler);
> +	video_unregister_device(&radio->videodev);
> +	v4l2_device_unregister(&radio->v4l2dev);
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

For the next version, can you also post the output of the v4l2-compliance run?
Make sure you use the latest version from the v4l-utils.git master branch!

Regards,

	Hans
