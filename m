Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab2JHR53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:57:29 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:54244
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab2JHR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:57:27 -0400
X-Forefront-Antispam-Report: CIP:157.56.236.117;KIP:(null);UIP:(null);IPV:NLI;H:BY2PRD0610HT001.namprd06.prod.outlook.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: PS-4(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzz8275ch17326ah8275bhz2fh2a8h668h839hd25he5bhf0ah107ah1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
Message-ID: <507313FD.6050507@convergeddevices.net>
Date: Mon, 8 Oct 2012 10:57:17 -0700
From: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <mchehab@redhat.com>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] Add a V4L2 driver for SI476X MFD
References: <1349488502-11293-1-git-send-email-andrey.smirnov@convergeddevices.net> <1349488502-11293-6-git-send-email-andrey.smirnov@convergeddevices.net> <201210081130.28233.hverkuil@xs4all.nl>
In-Reply-To: <201210081130.28233.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [173.160.178.141]
X-OriginatorOrg: convergeddevices.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2012 02:30 AM, Hans Verkuil wrote:
> On Sat October 6 2012 03:55:01 Andrey Smirnov wrote:
>> This commit adds a driver that exposes all the radio related
>> functionality of the Si476x series of chips via the V4L2 subsystem.
>>
>> Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
>> ---
>>  drivers/media/radio/Kconfig        |   17 +
>>  drivers/media/radio/Makefile       |    1 +
>>  drivers/media/radio/radio-si476x.c | 1153 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1171 insertions(+)
>>  create mode 100644 drivers/media/radio/radio-si476x.c
>>
>> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
>> index 8090b87..3c79d09 100644
>> --- a/drivers/media/radio/Kconfig
>> +++ b/drivers/media/radio/Kconfig
>> @@ -16,6 +16,23 @@ config RADIO_SI470X
>>  	bool "Silicon Labs Si470x FM Radio Receiver support"
>>  	depends on VIDEO_V4L2
>>  
>> +config RADIO_SI476X
>> +	tristate "Silicon Laboratories Si476x I2C FM Radio"
>> +	depends on I2C && VIDEO_V4L2
>> +	select MFD_CORE
>> +	select MFD_SI476X_CORE
>> +	select SND_SOC_SI476X
>> +	---help---
>> +	  Choose Y here if you have this FM radio chip.
>> +
>> +	  In order to control your radio card, you will need to use programs
>> +	  that are compatible with the Video For Linux 2 API.  Information on
>> +	  this API and pointers to "v4l2" programs may be found at
>> +	  <file:Documentation/video4linux/API.html>.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called radio-si476x.
>> +
>>  source "drivers/media/radio/si470x/Kconfig"
>>  
>>  config USB_MR800
>> diff --git a/drivers/media/radio/Makefile b/drivers/media/radio/Makefile
>> index c03ce4f..c4618e0 100644
>> --- a/drivers/media/radio/Makefile
>> +++ b/drivers/media/radio/Makefile
>> @@ -19,6 +19,7 @@ obj-$(CONFIG_RADIO_GEMTEK) += radio-gemtek.o
>>  obj-$(CONFIG_RADIO_TRUST) += radio-trust.o
>>  obj-$(CONFIG_I2C_SI4713) += si4713-i2c.o
>>  obj-$(CONFIG_RADIO_SI4713) += radio-si4713.o
>> +obj-$(CONFIG_RADIO_SI476X) += radio-si476x.o
>>  obj-$(CONFIG_RADIO_MIROPCM20) += radio-miropcm20.o
>>  obj-$(CONFIG_USB_DSBR) += dsbr100.o
>>  obj-$(CONFIG_RADIO_SI470X) += si470x/
>> diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
>> new file mode 100644
>> index 0000000..2d943da
>> --- /dev/null
>> +++ b/drivers/media/radio/radio-si476x.c
>> @@ -0,0 +1,1153 @@
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/slab.h>
>> +#include <linux/atomic.h>
>> +#include <linux/videodev2.h>
>> +#include <linux/mutex.h>
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-device.h>
>> +
>> +#include <linux/mfd/si476x-core.h>
>> +
>> +#define FM_FREQ_RANGE_LOW   64000000
>> +#define FM_FREQ_RANGE_HIGH 108000000
>> +
>> +#define AM_FREQ_RANGE_LOW    520000
>> +#define AM_FREQ_RANGE_HIGH 30000000
>> +
>> +#define PWRLINEFLTR (1 << 8)
>> +
>> +#define FREQ_MUL (10000000 / 625)
>> +
>> +#define DRIVER_NAME "si476x-radio"
>> +#define DRIVER_CARD "SI476x AM/FM Receiver"
>> +
>> +enum si476x_freq_bands {
>> +	SI476X_BAND_FM,
>> +	SI476X_BAND_AM,
>> +};
>> +
>> +static const struct v4l2_frequency_band si476x_bands[] = {
>> +	[SI476X_BAND_FM] = {
>> +		.type		= V4L2_TUNER_RADIO,
>> +		.index		= SI476X_BAND_FM,
>> +		.capability	= V4L2_TUNER_CAP_LOW
>> +		| V4L2_TUNER_CAP_STEREO
>> +		| V4L2_TUNER_CAP_RDS
>> +		| V4L2_TUNER_CAP_RDS_BLOCK_IO
>> +		| V4L2_TUNER_CAP_FREQ_BANDS,
>> +		.rangelow	=  64 * FREQ_MUL,
>> +		.rangehigh	= 108 * FREQ_MUL,
>> +		.modulation	= V4L2_BAND_MODULATION_FM,
>> +	},
>> +	[SI476X_BAND_AM] = {
>> +		.type		= V4L2_TUNER_RADIO,
>> +		.index		= SI476X_BAND_AM,
>> +		.capability	= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
>> +		.rangelow	= 0.52 * FREQ_MUL,
>> +		.rangehigh	= 30 * FREQ_MUL,
>> +		.modulation	= V4L2_BAND_MODULATION_AM,
>> +	},
>> +};
>> +
>> +#define PRIVATE_CTL_IDX(x) (x - V4L2_CID_PRIVATE_BASE)
>> +
>> +static int si476x_s_ctrl(struct v4l2_ctrl *ctrl);
>> +
>> +static const char * const deemphasis[] = {
>> +	"75 us",
>> +	"50 us",
>> +};
>> +
>> +static const struct v4l2_ctrl_ops si476x_ctrl_ops = {
>> +	.s_ctrl = si476x_s_ctrl,
>> +};
>> +
>> +static const struct v4l2_ctrl_config si476x_ctrls[] = {
>> +	/*
>> +	   Tuning parameters
>> +	   'max tune errors' is shared for both AM/FM mode of operation
>> +	*/
>> +	{
>> +		.ops	= &si476x_ctrl_ops,
>> +		.id	= SI476X_CID_RSSI_THRESHOLD,
>> +		.name	= "valid rssi threshold",
>> +		.type	= V4L2_CTRL_TYPE_INTEGER,
>> +		.min	= -128,
>> +		.max	= 127,
>> +		.step	= 1,
>> +	},
>> +	{
>> +		.ops	= &si476x_ctrl_ops,
>> +		.id	= SI476X_CID_SNR_THRESHOLD,
>> +		.type	= V4L2_CTRL_TYPE_INTEGER,
>> +		.name	= "valid snr threshold",
>> +		.min	= -128,
>> +		.max	= 127,
>> +		.step	= 1,
>> +	},
>> +	{
>> +		.ops	= &si476x_ctrl_ops,
>> +		.id	= SI476X_CID_MAX_TUNE_ERROR,
>> +		.type	= V4L2_CTRL_TYPE_INTEGER,
>> +		.name	= "max tune errors",
>> +		.min	= 0,
>> +		.max	= 126 * 2,
>> +		.step	= 2,
>> +	},
>> +	/*
>> +	   Region specific parameters
>> +	*/
>> +	{
>> +		.ops	= &si476x_ctrl_ops,
>> +		.id	= SI476X_CID_HARMONICS_COUNT,
>> +		.type	= V4L2_CTRL_TYPE_INTEGER,
>> +		.name	= "count of harmonics to reject",
>> +		.min	= 0,
>> +		.max	= 20,
>> +		.step	= 1,
>> +	},
>> +	{
>> +		.ops	= &si476x_ctrl_ops,
>> +		.id	= SI476X_CID_DEEMPHASIS,
>> +		.type	= V4L2_CTRL_TYPE_MENU,
>> +		.name	= "de-emphassis",
>> +		.qmenu	= deemphasis,
>> +		.min	= 0,
>> +		.max	= ARRAY_SIZE(deemphasis) - 1,
>> +		.def	= 0,
>> +	},
> I think most if not all of the controls above are candidates for turning into
> standardized controls. I recommend that you make a proposal (RFC) for this.
>
> This may be useful as well:
>
> http://lists-archives.com/linux-kernel/27641304-radio-fixes-and-new-features-for-fm.html
>
> This patch series contains a standardized DEEMPHASIS control.
> Note that this patch series is outdated, but patch 2/5 is OK.

So do you want me to take that patch and make it the part of this patch
set or do you want me to create a separate RFC with a patch set that
contains all those controls?

Just to give some description:

SI476X_CID_RSSI_THRESHOLD, SI476X_CID_SNR_THRESHOLD,
SI476X_CID_MAX_TUNE_ERROR are used to determine at which level of SNR,
RSSI the station station should be considered valid and what margin of
error is to be used(SI476X_CID_MAX_TUNE_ERROR) for those parameters.

SI476X_CID_HARMONICS_COUNT is the amount of AC grid noise harmonics
build-in hardware(or maybe FW) will try to filter out in AM mode.

It seems to me that the controls described above are quite chip specific
should I also include them in the RFC?

>> +	{
>> +		.ops	= &si476x_ctrl_ops,
>> +		.id	= SI476X_CID_RDS_RECEPTION,
>> +		.type	= V4L2_CTRL_TYPE_BOOLEAN,
>> +		.name	= "rds",
>> +		.min	= 0,
>> +		.max	= 1,
>> +		.step	= 1,
>> +	},
> If this control returns whether or not RDS is detected, then this control
> should be removed. VIDIOC_G_TUNER will return that information in rxsubchans.

This control allows to turn on/off RDS processing on the radio chip
itself. In IRQ mode in decreases the amount of
IRQs generated by the chip. And in polling(no-IRQ) mode it decreases I2C
traffic significantly(We've had a run of the boards that had
4-tuners on a single I2C bus, working in polling mode).

>
>> +};
>> +
>> +struct si476x_radio;
>> +
>> +/**
>> + * struct si476x_radio_ops - vtable of tuner functions
>> + *
>> + * This table holds pointers to functions implementing particular
>> + * operations depending on the mode in which the tuner chip was
>> + * configured to start in. If the function is not supported
>> + * corresponding element is set to #NULL.
>> + *
>> + * @tune_freq: Tune chip to a specific frequency
>> + * @seek_start: Star station seeking
>> + * @rsq_status: Get Recieved Signal Quality(RSQ) status
>> + * @rds_blckcnt: Get recived RDS blocks count
>> + * @phase_diversity: Change phase diversity mode of the tuner
>> + * @phase_div_status: Get phase diversity mode status
>> + * @acf_status: Get the status of Automatically Controlled
>> + * Features(ACF)
>> + * @agc_status: Get Automatic Gain Control(AGC) status
>> + */
>> +struct si476x_radio_ops {
>> +	int (*tune_freq)(struct si476x_core *, struct si476x_tune_freq_args *);
>> +	int (*seek_start)(struct si476x_core *, bool, bool);
>> +	int (*rsq_status)(struct si476x_core *, struct si476x_rsq_status_args *,
>> +			  struct si476x_rsq_status_report *);
>> +	int (*rds_blckcnt)(struct si476x_core *, bool,
>> +			   struct si476x_rds_blockcount_report *);
>> +
>> +	int (*phase_diversity)(struct si476x_core *,
>> +			       enum si476x_phase_diversity_mode);
>> +	int (*phase_div_status)(struct si476x_core *);
>> +	int (*acf_status)(struct si476x_core *,
>> +			  struct si476x_acf_status_report *);
>> +	int (*agc_status)(struct si476x_core *,
>> +			  struct si476x_agc_status_report *);
>> +};
>> +
>> +/**
>> + * struct si476x_radio - radio device
>> + *
>> + * @core: Pointer to underlying core device
>> + * @videodev: Pointer to video device created by V4L2 subsystem
>> + * @ops: Vtable of functions. See struct si476x_radio_ops for details
>> + * @kref: Reference counter
>> + * @core_lock: An r/w semaphore to brebvent the deletion of underlying
>> + * core structure is the radio device is being used
>> + */
>> +struct si476x_radio {
>> +	struct v4l2_device v4l2dev;
>> +	struct video_device videodev;
>> +	struct v4l2_ctrl_handler ctrl_handler;
>> +
>> +	struct si476x_core  *core;
>> +	/* This field should not be accesses unless core lock is held */
>> +	const struct si476x_radio_ops *ops;
>> +
>> +	u32 rangelow;
>> +	u32 rangehigh;
>> +	u32 spacing;
>> +	u32 audmode;
>> +};
>> +
>> +static inline struct si476x_radio *v4l2_dev_to_radio(struct v4l2_device *d)
>> +{
>> +	return container_of(d, struct si476x_radio, v4l2dev);
>> +}
>> +
>> +static inline struct si476x_radio *v4l2_ctrl_handler_to_radio(struct v4l2_ctrl_handler *d)
>> +{
>> +	return container_of(d, struct si476x_radio, ctrl_handler);
>> +}
>> +
>> +
>> +static int si476x_radio_initialize_mode(struct si476x_radio *);
>> +
>> +/*
>> + * si476x_vidioc_querycap - query device capabilities
>> + */
>> +static int si476x_querycap(struct file *file, void *priv,
>> +			   struct v4l2_capability *capability)
>> +{
>> +	struct si476x_radio *radio = video_drvdata(file);
>> +
>> +	strlcpy(capability->driver, radio->v4l2dev.name,
>> +		sizeof(capability->driver));
>> +	strlcpy(capability->card,   DRIVER_CARD, sizeof(capability->card));
>> +	strlcpy(capability->bus_info, radio->v4l2dev.name, sizeof(capability->bus_info));
> Bus info needs the proper prefix. See the latest querycap documentation:
>
> http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-querycap
>
>> +
>> +	capability->device_caps = V4L2_CAP_TUNER
>> +		| V4L2_CAP_RADIO
>> +		| V4L2_CAP_RDS_CAPTURE
>> +		| V4L2_CAP_READWRITE
>> +		| V4L2_CAP_HW_FREQ_SEEK;
>> +	capability->capabilities = \
> Remove the trailing \
>
>> +		capability->device_caps | V4L2_CAP_DEVICE_CAPS;
>> +	return 0;
>> +}
>> +
>> +static int si476x_enum_freq_bands(struct file *file, void *priv,
>> +				  struct v4l2_frequency_band *band)
>> +{
>> +	int err;
>> +	struct si476x_radio *radio = video_drvdata(file);
>> +
>> +	if (band->tuner != 0)
>> +		return -EINVAL;
> This needs a check against non-blocking mode and it should return -EAGAIN
> if it is non-blocking. HWSEEK while in non-blocking mode is currently not
> supported by the API.
>
>> +
>> +	switch (radio->core->chip_id) {
>> +		/* AM/FM tuners -- all bands are supported */
>> +	case SI476X_CHIP_SI4761:
>> +	case SI476X_CHIP_SI4762:
>> +	case SI476X_CHIP_SI4763:
>> +	case SI476X_CHIP_SI4764:
>> +		if (band->index < ARRAY_SIZE(si476x_bands)) {
>> +			*band = si476x_bands[band->index];
>> +			err = 0;
>> +		} else {
>> +			err = -EINVAL;
>> +		}
>> +		break;
>> +		/* FM companion tuner chips -- only FM bands are
>> +		 * supported */
>> +	case SI476X_CHIP_SI4768:
>> +	case SI476X_CHIP_SI4769:
>> +		if (band->index == SI476X_BAND_FM) {
>> +			*band = si476x_bands[band->index];
>> +			err = 0;
>> +		} else {
>> +			err = -EINVAL;
>> +		}
>> +		break;
>> +	default:
>> +		err = -EINVAL;
>> +	}
>> +
>> +	return err;
>> +}
>> +
>> +static int si476x_g_tuner(struct file *file, void *priv,
>> +			  struct v4l2_tuner *tuner)
>> +{
>> +	int err;
>> +	struct si476x_rsq_status_report report;
>> +	struct si476x_radio *radio = video_drvdata(file);
>> +
>> +	if (tuner->index != 0)
>> +		return -EINVAL;
>> +
>> +	tuner->type       = V4L2_TUNER_RADIO;
>> +	tuner->capability = V4L2_TUNER_CAP_LOW /* Measure frequncies
> frequncies -> frequencies
>
>> +						 * in multiples of
>> +						 * 62.5 Hz */
>> +		| V4L2_TUNER_CAP_STEREO
>> +		| V4L2_TUNER_CAP_HWSEEK_BOUNDED
>> +		| V4L2_TUNER_CAP_HWSEEK_WRAP;
> You probably should also set V4L2_TUNER_CAP_HWSEEK_PROG_LIM. See
> http://hverkuil.home.xs4all.nl/spec/media.html#vidioc-s-hw-freq-seek
>
>> +
>> +	switch (radio->core->chip_id) {
>> +		/* AM/FM tuners -- all bands are supported */
>> +	case SI476X_CHIP_SI4764:
>> +		if (radio->core->diversity_mode == SI476X_PHDIV_SECONDARY_ANTENNA ||
>> +		    radio->core->diversity_mode == SI476X_PHDIV_SECONDARY_COMBINING) {
>> +			strlcpy(tuner->name, "FM (secondary)", sizeof(tuner->name));
>> +			tuner->capability = 0;
>> +			tuner->rxsubchans = 0;
>> +			break;
>> +		}
>> +
>> +		if (radio->core->diversity_mode == SI476X_PHDIV_PRIMARY_ANTENNA ||
>> +		    radio->core->diversity_mode == SI476X_PHDIV_PRIMARY_COMBINING)
>> +			strlcpy(tuner->name, "AM/FM (primary)", sizeof(tuner->name));
>> +
>> +	case SI476X_CHIP_SI4761: /* FALLTHROUGH */
>> +	case SI476X_CHIP_SI4762:
>> +	case SI476X_CHIP_SI4763:
>> +		if (radio->core->chip_id != SI476X_CHIP_SI4764)
>> +			strlcpy(tuner->name, "AM/FM", sizeof(tuner->name));
>> +
>> +		tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO
>> +			| V4L2_TUNER_SUB_RDS;
>> +		tuner->capability |= V4L2_TUNER_CAP_RDS
>> +			| V4L2_TUNER_CAP_RDS_BLOCK_IO
>> +			| V4L2_TUNER_CAP_FREQ_BANDS;
>> +
>> +		tuner->rangelow = si476x_bands[SI476X_BAND_AM].rangelow;
>> +
>> +		break;
>> +		/* FM companion tuner chips -- only FM bands are
>> +		 * supported */
>> +	case SI476X_CHIP_SI4768:
>> +	case SI476X_CHIP_SI4769:
>> +		tuner->rxsubchans = V4L2_TUNER_SUB_RDS;
>> +		tuner->capability |= V4L2_TUNER_CAP_RDS
>> +			| V4L2_TUNER_CAP_RDS_BLOCK_IO
>> +			| V4L2_TUNER_CAP_FREQ_BANDS;
>> +		tuner->rangelow = si476x_bands[SI476X_BAND_FM].rangelow;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	tuner->audmode = radio->audmode;
>> +
>> +	tuner->afc = 1;
>> +	tuner->rangehigh = si476x_bands[SI476X_BAND_FM].rangehigh;
>> +
>> +	si476x_core_lock(radio->core);
>> +	{
>> +		struct si476x_rsq_status_args args = {
>> +			.primary	= false,
>> +			.rsqack		= false,
>> +			.attune		= false,
>> +			.cancel		= false,
>> +			.stcack		= false,
>> +		};
>> +		if (radio->ops->rsq_status) {
>> +			err = radio->ops->rsq_status(radio->core,
>> +						     &args, &report);
>> +			if (err < 0) {
>> +				tuner->signal = 0;
>> +			} else {
>> +				/*
>> +				  tuner->signal value range: 0x0000 .. 0xFFFF,
>> +				  report.rssi: -128 .. 127
>> +				*/
>> +				tuner->signal = (report.rssi + 128) * 257;
>> +			}
>> +		} else {
>> +			tuner->signal = 0;
>> +			err = -EINVAL;
>> +		}
>> +	}
>> +	si476x_core_unlock(radio->core);
>> +
>> +	return err;
>> +}
>> +
>> +static int si476x_s_tuner(struct file *file, void *priv,
>> +				 struct v4l2_tuner *tuner)
>> +{
>> +	struct si476x_radio *radio = video_drvdata(file);
>> +
>> +	if (tuner->index != 0)
>> +		return -EINVAL;
>> +	else if (tuner->audmode == V4L2_TUNER_MODE_MONO ||
> No need for the 'else' keyword.
>
>> +		 tuner->audmode == V4L2_TUNER_MODE_STEREO)
>> +		radio->audmode = tuner->audmode;
> If audmode is neither mono nor stereo, then you should fall back to stereo.
>
>> +
>> +	return 0;
>> +}
>> +
>> +static int si476x_switch_func(struct si476x_radio *radio, enum si476x_func func)
>> +{
>> +	int err;
>> +
>> +	/*
>> +	   Since power/up down is a very time consuming operation,
>> +	   try to avoid doing it if the requested mode matches the one
>> +	   the tuner is in
>> +	*/
>> +	if (func == radio->core->power_up_parameters.func)
>> +		return 0;
>> +
>> +	err = si476x_core_stop(radio->core, true);
>> +	if (err < 0)
>> +		return err;
>> +
>> +	radio->core->power_up_parameters.func = func;
>> +
>> +	err = si476x_core_start(radio->core, true);
>> +	if (!err)
>> +		err = si476x_radio_initialize_mode(radio);
>> +
>> +	return err;
>> +}
>> +
>> +static int si476x_g_frequency(struct file *file, void *priv,
>> +			      struct v4l2_frequency *f)
>> +{
>> +	int err;
>> +	struct si476x_radio *radio = video_drvdata(file);
>> +
>> +	if (f->tuner != 0 ||
>> +	    f->type  != V4L2_TUNER_RADIO)
>> +		return -EINVAL;
>> +
>> +	si476x_core_lock(radio->core);
>> +
>> +	f->type = V4L2_TUNER_RADIO;
> This line is obviously not needed.
>
>> +	if (radio->ops->rsq_status) {
>> +		struct si476x_rsq_status_report report;
>> +		struct si476x_rsq_status_args   args = {
>> +			.primary	= false,
>> +			.rsqack		= false,
>> +			.attune		= true,
>> +			.cancel		= false,
>> +			.stcack		= false,
>> +		};
>> +
>> +		err = radio->ops->rsq_status(radio->core, &args, &report);
>> +		if (!err)
>> +			f->frequency = si476x_to_v4l2(radio->core,
>> +						      report.readfreq);
>> +	} else {
>> +		err = -EINVAL;
>> +	}
>> +
>> +	si476x_core_unlock(radio->core);
>> +
>> +	return err;
>> +}
>> +
>> +static int si476x_s_frequency(struct file *file, void *priv,
>> +			      struct v4l2_frequency *f)
>> +{
>> +	int err;
>> +	struct si476x_radio *radio = video_drvdata(file);
>> +
>> +	if (f->tuner != 0 ||
>> +	    f->type  != V4L2_TUNER_RADIO)
>> +		return -EINVAL;
>> +
>> +	si476x_core_lock(radio->core);
>> +
>> +	/* Remap rangewlow - 1 and rangehigh + 1 */
>> +	if (f->frequency == si476x_bands[SI476X_BAND_FM].rangelow - 1 ||
>> +	    f->frequency == si476x_bands[SI476X_BAND_AM].rangelow - 1)
>> +		f->frequency += 1;
>> +
>> +	if (f->frequency == si476x_bands[SI476X_BAND_FM].rangehigh + 1 ||
>> +	    f->frequency == si476x_bands[SI476X_BAND_AM].rangehigh + 1)
>> +		f->frequency -= 1;
> Huh?
>
> I think you are working around a v4l2-compliance test where I use rangelow-1 and
> rangehigh+1 to test if s_frequency will correctly clamp frequencies. But obviously
> the point is to clamp any out-of-range frequency to the closest valid frequency
> range.
>
> In other words, an out-of-range frequency value shouldn't result in an error,
> but it should be mapped to the closest valid frequency.

Oh, I see. I didn't understand the purpose of that check initially and
thought that this rangehigh + 1/rangelow - 1 was some sort of a special
use-case. I'll fix it in the next version.

Andrey Smirnov

