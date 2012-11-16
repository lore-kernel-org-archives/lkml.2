Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2KPWW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 17:22:59 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56103 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab2KPWW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 17:22:56 -0500
MIME-Version: 1.0
In-Reply-To: <1351017872-32488-6-git-send-email-andrey.smirnov@convergeddevices.net>
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
	<1351017872-32488-6-git-send-email-andrey.smirnov@convergeddevices.net>
Date: Sat, 17 Nov 2012 01:22:55 +0300
Message-ID: <CALW4P++EJHNC=rmJfKfN-6x9z5cR86QhNZ+VuzPwEe7OmpazDQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] Add a V4L2 driver for SI476X MFD
From: Alexey Klimov <klimov.linux@gmail.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrey,

On Tue, Oct 23, 2012 at 10:44 PM, Andrey Smirnov
<andrey.smirnov@convergeddevices.net> wrote:
> This commit adds a driver that exposes all the radio related
> functionality of the Si476x series of chips via the V4L2 subsystem.
>
> Signed-off-by: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
> ---
>  drivers/media/radio/Kconfig        |   17 +
>  drivers/media/radio/Makefile       |    1 +
>  drivers/media/radio/radio-si476x.c | 1549 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 1567 insertions(+)
>  create mode 100644 drivers/media/radio/radio-si476x.c
>
> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index 8090b87..3c79d09 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -16,6 +16,23 @@ config RADIO_SI470X
>         bool "Silicon Labs Si470x FM Radio Receiver support"
>         depends on VIDEO_V4L2
>
> +config RADIO_SI476X
> +       tristate "Silicon Laboratories Si476x I2C FM Radio"
> +       depends on I2C && VIDEO_V4L2
> +       select MFD_CORE
> +       select MFD_SI476X_CORE
> +       select SND_SOC_SI476X
> +       ---help---
> +         Choose Y here if you have this FM radio chip.
> +
> +         In order to control your radio card, you will need to use programs
> +         that are compatible with the Video For Linux 2 API.  Information on
> +         this API and pointers to "v4l2" programs may be found at
> +         <file:Documentation/video4linux/API.html>.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called radio-si476x.
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
> index 0000000..c8fa90f
> --- /dev/null
> +++ b/drivers/media/radio/radio-si476x.c
> @@ -0,0 +1,1549 @@
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/slab.h>
> +#include <linux/atomic.h>
> +#include <linux/videodev2.h>
> +#include <linux/mutex.h>
> +#include <linux/debugfs.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-device.h>
> +
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
> +#define SI476X_PHDIV_STATUS_LINK_LOCKED(status) (0b10000000 & (status))
> +
> +#define DRIVER_NAME "si476x-radio"
> +#define DRIVER_CARD "SI476x AM/FM Receiver"
> +
> +enum si476x_freq_bands {
> +       SI476X_BAND_FM,
> +       SI476X_BAND_AM,
> +};
> +
> +static const struct v4l2_frequency_band si476x_bands[] = {
> +       [SI476X_BAND_FM] = {
> +               .type           = V4L2_TUNER_RADIO,
> +               .index          = SI476X_BAND_FM,
> +               .capability     = V4L2_TUNER_CAP_LOW
> +               | V4L2_TUNER_CAP_STEREO
> +               | V4L2_TUNER_CAP_RDS
> +               | V4L2_TUNER_CAP_RDS_BLOCK_IO
> +               | V4L2_TUNER_CAP_FREQ_BANDS,
> +               .rangelow       =  64 * FREQ_MUL,
> +               .rangehigh      = 108 * FREQ_MUL,
> +               .modulation     = V4L2_BAND_MODULATION_FM,
> +       },
> +       [SI476X_BAND_AM] = {
> +               .type           = V4L2_TUNER_RADIO,
> +               .index          = SI476X_BAND_AM,
> +               .capability     = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_FREQ_BANDS,
> +               .rangelow       = 0.52 * FREQ_MUL,
> +               .rangehigh      = 30 * FREQ_MUL,
> +               .modulation     = V4L2_BAND_MODULATION_AM,
> +       },
> +};
> +
> +static inline bool si476x_radio_freq_is_inside_of_the_band(u32 freq, int band)
> +{
> +       return freq >= si476x_bands[band].rangelow &&
> +               freq <= si476x_bands[band].rangehigh;
> +}
> +
> +static inline bool si476x_radio_range_is_inside_of_the_band(u32 low, u32 high, int band)
> +{
> +       return low  >= si476x_bands[band].rangelow &&
> +               high <= si476x_bands[band].rangehigh;
> +}
> +
> +#define PRIVATE_CTL_IDX(x) (x - V4L2_CID_PRIVATE_BASE)
> +
> +static int si476x_radio_s_ctrl(struct v4l2_ctrl *ctrl);
> +static int si476x_radio_g_volatile_ctrl(struct v4l2_ctrl *ctrl);
> +
> +static const char * const deemphasis[] = {
> +       "75 us",
> +       "50 us",
> +};
> +
> +enum phase_diversity_modes_idx {
> +       SI476X_IDX_PHDIV_DISABLED,
> +       SI476X_IDX_PHDIV_PRIMARY_COMBINING,
> +       SI476X_IDX_PHDIV_PRIMARY_ANTENNA,
> +       SI476X_IDX_PHDIV_SECONDARY_ANTENNA,
> +       SI476X_IDX_PHDIV_SECONDARY_COMBINING,
> +};
> +
> +static const char * const phase_diversity_modes[] = {
> +       [SI476X_IDX_PHDIV_DISABLED]             = "disabled",
> +       [SI476X_IDX_PHDIV_PRIMARY_COMBINING]    = "primary w/secondary",
> +       [SI476X_IDX_PHDIV_PRIMARY_ANTENNA]      = "primary(primary antenna)",
> +       [SI476X_IDX_PHDIV_SECONDARY_ANTENNA]    = "primary(seconadary antenna)",
> +       [SI476X_IDX_PHDIV_SECONDARY_COMBINING]  = "secondary w/primary",
> +};
> +
> +static inline enum phase_diversity_modes_idx
> +si476x_phase_diversity_mode_to_idx(enum si476x_phase_diversity_mode mode)
> +{
> +       switch (mode) {
> +       default:                /* FALLTHROUGH */
> +       case SI476X_PHDIV_DISABLED:
> +               return SI476X_IDX_PHDIV_DISABLED;
> +       case SI476X_PHDIV_PRIMARY_COMBINING:
> +               return SI476X_IDX_PHDIV_PRIMARY_COMBINING;
> +       case SI476X_PHDIV_PRIMARY_ANTENNA:
> +               return SI476X_IDX_PHDIV_PRIMARY_ANTENNA;
> +       case SI476X_PHDIV_SECONDARY_ANTENNA:
> +               return SI476X_IDX_PHDIV_SECONDARY_ANTENNA;
> +       case SI476X_PHDIV_SECONDARY_COMBINING:
> +               return SI476X_IDX_PHDIV_SECONDARY_COMBINING;
> +       }
> +}
> +
> +static inline enum si476x_phase_diversity_mode
> +si476x_phase_diversity_idx_to_mode(enum phase_diversity_modes_idx idx)
> +{
> +       static const int idx_to_value[] = {
> +               [SI476X_IDX_PHDIV_DISABLED]             = SI476X_PHDIV_DISABLED,
> +               [SI476X_IDX_PHDIV_PRIMARY_COMBINING]    = SI476X_PHDIV_PRIMARY_COMBINING,
> +               [SI476X_IDX_PHDIV_PRIMARY_ANTENNA]      = SI476X_PHDIV_PRIMARY_ANTENNA,
> +               [SI476X_IDX_PHDIV_SECONDARY_ANTENNA]    = SI476X_PHDIV_SECONDARY_ANTENNA,
> +               [SI476X_IDX_PHDIV_SECONDARY_COMBINING]  = SI476X_PHDIV_SECONDARY_COMBINING,
> +       };
> +
> +       return idx_to_value[idx];
> +}
> +
> +static const struct v4l2_ctrl_ops si476x_ctrl_ops = {
> +       .g_volatile_ctrl        = si476x_radio_g_volatile_ctrl,
> +       .s_ctrl                 = si476x_radio_s_ctrl,
> +};
> +
> +
> +enum si476x_ctrl_idx {
> +       SI476X_IDX_RSSI_THRESHOLD,
> +       SI476X_IDX_SNR_THRESHOLD,
> +       SI476X_IDX_MAX_TUNE_ERROR,
> +       SI476X_IDX_HARMONICS_COUNT,
> +       SI476X_IDX_DEEMPHASIS,
> +       SI476X_IDX_RDS_RECEPTION,
> +       SI476X_IDX_DIVERSITY_MODE,
> +       SI476X_IDX_INTERCHIP_LINK,
> +};
> +
> +static struct v4l2_ctrl_config si476x_ctrls[] = {
> +       /*
> +          Tuning parameters
> +          'max tune errors' is shared for both AM/FM mode of operation
> +       */
> +       [SI476X_IDX_RSSI_THRESHOLD] = {
> +               .ops    = &si476x_ctrl_ops,
> +               .id     = SI476X_CID_RSSI_THRESHOLD,
> +               .name   = "valid rssi threshold",
> +               .type   = V4L2_CTRL_TYPE_INTEGER,
> +               .min    = -128,
> +               .max    = 127,
> +               .step   = 1,
> +       },
> +       [SI476X_IDX_SNR_THRESHOLD] = {
> +               .ops    = &si476x_ctrl_ops,
> +               .id     = SI476X_CID_SNR_THRESHOLD,
> +               .type   = V4L2_CTRL_TYPE_INTEGER,
> +               .name   = "valid snr threshold",
> +               .min    = -128,
> +               .max    = 127,
> +               .step   = 1,
> +       },
> +       [SI476X_IDX_MAX_TUNE_ERROR] = {
> +               .ops    = &si476x_ctrl_ops,
> +               .id     = SI476X_CID_MAX_TUNE_ERROR,
> +               .type   = V4L2_CTRL_TYPE_INTEGER,
> +               .name   = "max tune errors",
> +               .min    = 0,
> +               .max    = 126 * 2,
> +               .step   = 2,
> +       },
> +       /*
> +          Region specific parameters
> +       */
> +       [SI476X_IDX_HARMONICS_COUNT] = {
> +               .ops    = &si476x_ctrl_ops,
> +               .id     = SI476X_CID_HARMONICS_COUNT,
> +               .type   = V4L2_CTRL_TYPE_INTEGER,
> +
> +               .name   = "count of harmonics to reject",
> +               .min    = 0,
> +               .max    = 20,
> +               .step   = 1,
> +       },
> +       [SI476X_IDX_DEEMPHASIS] = {
> +               .ops    = &si476x_ctrl_ops,
> +               .id     = SI476X_CID_DEEMPHASIS,
> +               .type   = V4L2_CTRL_TYPE_MENU,
> +               .name   = "de-emphassis",
> +               .qmenu  = deemphasis,
> +               .min    = 0,
> +               .max    = ARRAY_SIZE(deemphasis) - 1,
> +               .def    = 0,
> +       },
> +       [SI476X_IDX_RDS_RECEPTION] = {
> +               .ops    = &si476x_ctrl_ops,
> +               .id     = SI476X_CID_RDS_RECEPTION,
> +               .type   = V4L2_CTRL_TYPE_BOOLEAN,
> +               .name   = "rds",
> +               .min    = 0,
> +               .max    = 1,
> +               .step   = 1,
> +       },
> +       [SI476X_IDX_DIVERSITY_MODE] = {
> +               .ops    = &si476x_ctrl_ops,
> +               .id     = SI476X_CID_DIVERSITY_MODE,
> +               .type   = V4L2_CTRL_TYPE_MENU,
> +               .name   = "phase diversity mode",
> +               .qmenu  = phase_diversity_modes,
> +               .min    = 0,
> +               .max    = ARRAY_SIZE(phase_diversity_modes) - 1,
> +       },
> +       [SI476X_IDX_INTERCHIP_LINK] = {
> +               .ops    = &si476x_ctrl_ops,
> +               .id     = SI476X_CID_INTERCHIP_LINK,
> +               .type   = V4L2_CTRL_TYPE_BOOLEAN,
> +               .flags  = V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_VOLATILE,
> +               .name   = "inter-chip link",
> +               .min    = 0,
> +               .max    = 1,
> +               .step   = 1,
> +       },
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
> +       int (*tune_freq)(struct si476x_core *, struct si476x_tune_freq_args *);
> +       int (*seek_start)(struct si476x_core *, bool, bool);
> +       int (*rsq_status)(struct si476x_core *, struct si476x_rsq_status_args *,
> +                         struct si476x_rsq_status_report *);
> +       int (*rds_blckcnt)(struct si476x_core *, bool,
> +                          struct si476x_rds_blockcount_report *);
> +
> +       int (*phase_diversity)(struct si476x_core *,
> +                              enum si476x_phase_diversity_mode);
> +       int (*phase_div_status)(struct si476x_core *);
> +       int (*acf_status)(struct si476x_core *,
> +                         struct si476x_acf_status_report *);
> +       int (*agc_status)(struct si476x_core *,
> +                         struct si476x_agc_status_report *);
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
> +       struct v4l2_device v4l2dev;
> +       struct video_device videodev;
> +       struct v4l2_ctrl_handler ctrl_handler;
> +
> +       struct si476x_core  *core;
> +       /* This field should not be accesses unless core lock is held */
> +       const struct si476x_radio_ops *ops;
> +
> +       struct dentry   *debugfs;
> +       u32 audmode;
> +};
> +
> +static inline struct si476x_radio *v4l2_dev_to_radio(struct v4l2_device *d)
> +{
> +       return container_of(d, struct si476x_radio, v4l2dev);
> +}
> +
> +static inline struct si476x_radio *v4l2_ctrl_handler_to_radio(struct v4l2_ctrl_handler *d)
> +{
> +       return container_of(d, struct si476x_radio, ctrl_handler);
> +}
> +
> +/*
> + * si476x_vidioc_querycap - query device capabilities
> + */
> +static int si476x_radio_querycap(struct file *file, void *priv,
> +                                struct v4l2_capability *capability)
> +{
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       strlcpy(capability->driver, radio->v4l2dev.name,
> +               sizeof(capability->driver));
> +       strlcpy(capability->card,   DRIVER_CARD, sizeof(capability->card));
> +       snprintf(capability->bus_info, sizeof(capability->bus_info),
> +                "platform:%s", radio->v4l2dev.name);
> +
> +       capability->device_caps = V4L2_CAP_TUNER
> +               | V4L2_CAP_RADIO
> +               | V4L2_CAP_HW_FREQ_SEEK;
> +
> +       si476x_core_lock(radio->core);
> +       if (!si476x_core_is_a_secondary_tuner(radio->core))
> +               capability->device_caps |= V4L2_CAP_RDS_CAPTURE
> +                       | V4L2_CAP_READWRITE;
> +       si476x_core_unlock(radio->core);
> +
> +       capability->capabilities = capability->device_caps | V4L2_CAP_DEVICE_CAPS;
> +       return 0;
> +}
> +
> +static int si476x_radio_enum_freq_bands(struct file *file, void *priv,
> +                                       struct v4l2_frequency_band *band)
> +{
> +       int err;
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       if (band->tuner != 0)
> +               return -EINVAL;
> +
> +       switch (radio->core->chip_id) {
> +               /* AM/FM tuners -- all bands are supported */
> +       case SI476X_CHIP_SI4761:
> +       case SI476X_CHIP_SI4764:
> +               if (band->index < ARRAY_SIZE(si476x_bands)) {
> +                       *band = si476x_bands[band->index];
> +                       err = 0;
> +               } else {
> +                       err = -EINVAL;
> +               }
> +               break;
> +               /* FM companion tuner chips -- only FM bands are
> +                * supported */
> +       case SI476X_CHIP_SI4768:
> +               if (band->index == SI476X_BAND_FM) {
> +                       *band = si476x_bands[band->index];
> +                       err = 0;
> +               } else {
> +                       err = -EINVAL;
> +               }
> +               break;
> +       default:
> +               err = -EINVAL;
> +       }
> +
> +       return err;
> +}
> +
> +static int si476x_radio_g_tuner(struct file *file, void *priv,
> +                               struct v4l2_tuner *tuner)
> +{
> +       int err;
> +       struct si476x_rsq_status_report report;
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       struct si476x_rsq_status_args args = {
> +               .primary        = false,
> +               .rsqack         = false,
> +               .attune         = false,
> +               .cancel         = false,
> +               .stcack         = false,
> +       };
> +
> +       if (tuner->index != 0)
> +               return -EINVAL;
> +
> +       tuner->type       = V4L2_TUNER_RADIO;
> +       tuner->capability = V4L2_TUNER_CAP_LOW /* Measure frequencies
> +                                                * in multiples of
> +                                                * 62.5 Hz */
> +               | V4L2_TUNER_CAP_STEREO
> +               | V4L2_TUNER_CAP_HWSEEK_BOUNDED
> +               | V4L2_TUNER_CAP_HWSEEK_WRAP
> +               | V4L2_TUNER_CAP_HWSEEK_PROG_LIM;
> +
> +       si476x_core_lock(radio->core);
> +
> +       if (si476x_core_is_a_secondary_tuner(radio->core)) {
> +               strlcpy(tuner->name, "FM (secondary)", sizeof(tuner->name));
> +               tuner->rxsubchans = 0;
> +               tuner->rangelow = si476x_bands[SI476X_BAND_FM].rangelow;
> +       } else if (si476x_core_has_am(radio->core)) {
> +               if (si476x_core_is_a_primary_tuner(radio->core))
> +                       strlcpy(tuner->name, "AM/FM (primary)", sizeof(tuner->name));
> +               else
> +                       strlcpy(tuner->name, "AM/FM", sizeof(tuner->name));
> +
> +               tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO
> +                       | V4L2_TUNER_SUB_RDS;
> +               tuner->capability |= V4L2_TUNER_CAP_RDS
> +                       | V4L2_TUNER_CAP_RDS_BLOCK_IO
> +                       | V4L2_TUNER_CAP_FREQ_BANDS;
> +
> +               tuner->rangelow = si476x_bands[SI476X_BAND_AM].rangelow;
> +       } else {
> +               strlcpy(tuner->name, "FM", sizeof(tuner->name));
> +               tuner->rxsubchans = V4L2_TUNER_SUB_RDS;
> +               tuner->capability |= V4L2_TUNER_CAP_RDS
> +                       | V4L2_TUNER_CAP_RDS_BLOCK_IO
> +                       | V4L2_TUNER_CAP_FREQ_BANDS;
> +               tuner->rangelow = si476x_bands[SI476X_BAND_FM].rangelow;
> +       }
> +
> +       tuner->audmode = radio->audmode;
> +
> +       tuner->afc = 1;
> +       tuner->rangehigh = si476x_bands[SI476X_BAND_FM].rangehigh;
> +
> +       err = radio->ops->rsq_status(radio->core,
> +                                    &args, &report);
> +       if (err < 0) {
> +               tuner->signal = 0;
> +       } else {
> +               /*
> +                * tuner->signal value range: 0x0000 .. 0xFFFF,
> +                * report.rssi: -128 .. 127
> +                */
> +               tuner->signal = (report.rssi + 128) * 257;
> +       }
> +       si476x_core_unlock(radio->core);
> +
> +       return err;
> +}
> +
> +static int si476x_radio_s_tuner(struct file *file, void *priv,
> +                               struct v4l2_tuner *tuner)
> +{
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       if (tuner->index != 0)
> +               return -EINVAL;
> +
> +       if (tuner->audmode == V4L2_TUNER_MODE_MONO ||
> +           tuner->audmode == V4L2_TUNER_MODE_STEREO)
> +               radio->audmode = tuner->audmode;
> +       else
> +               radio->audmode = V4L2_TUNER_MODE_STEREO;
> +
> +       return 0;
> +}
> +
> +static int si476x_radio_init_vtable(struct si476x_radio *radio, enum si476x_func func)
> +{
> +       static const struct si476x_radio_ops fm_ops = {
> +               .tune_freq              = si476x_core_cmd_fm_tune_freq,
> +               .seek_start             = si476x_core_cmd_fm_seek_start,
> +               .rsq_status             = si476x_core_cmd_fm_rsq_status,
> +               .rds_blckcnt            = si476x_core_cmd_fm_rds_blockcount,
> +               .phase_diversity        = si476x_core_cmd_fm_phase_diversity,
> +               .phase_div_status       = si476x_core_cmd_fm_phase_div_status,
> +               .acf_status             = si476x_core_cmd_fm_acf_status,
> +               .agc_status             = si476x_core_cmd_agc_status,
> +       };
> +
> +       static const struct si476x_radio_ops am_ops = {
> +               .tune_freq              = si476x_core_cmd_am_tune_freq,
> +               .seek_start             = si476x_core_cmd_am_seek_start,
> +               .rsq_status             = si476x_core_cmd_am_rsq_status,
> +               .rds_blckcnt            = NULL,
> +               .phase_diversity        = NULL,
> +               .phase_div_status       = NULL,
> +               .acf_status             = si476x_core_cmd_am_acf_status,
> +               .agc_status             = NULL,
> +       };
> +
> +       switch (func) {
> +       case SI476X_FUNC_FM_RECEIVER:
> +               radio->ops = &fm_ops;
> +               return 0;
> +
> +       case SI476X_FUNC_AM_RECEIVER:
> +               radio->ops = &am_ops;
> +               return 0;
> +       default:
> +               WARN(1, "Unexpected tuner function value\n");
> +               return -EINVAL;
> +       }
> +}
> +
> +static int si476x_radio_pretune(struct si476x_radio *radio, enum si476x_func func)
> +{
> +       int retval;
> +
> +       struct si476x_tune_freq_args args = {
> +               .zifsr          = false,
> +               .hd             = false,
> +               .injside        = SI476X_INJSIDE_AUTO,
> +               .tunemode       = SI476X_TM_VALIDATED_NORMAL_TUNE,
> +               .smoothmetrics  = SI476X_SM_INITIALIZE_AUDIO,
> +               .antcap         = 0,
> +       };
> +
> +       switch (func) {
> +       case SI476X_FUNC_FM_RECEIVER:
> +               args.freq = v4l2_to_si476x(radio->core,
> +                                          92 * FREQ_MUL);
> +               retval = radio->ops->tune_freq(radio->core, &args);
> +               break;
> +       case SI476X_FUNC_AM_RECEIVER:
> +               args.freq = v4l2_to_si476x(radio->core,
> +                                          0.6 * FREQ_MUL);
> +               retval = radio->ops->tune_freq(radio->core, &args);
> +               break;
> +       default:
> +               WARN(1, "Unexpected tuner function value\n");
> +               retval = -EINVAL;
> +       }
> +
> +       return retval;
> +}
> +static int si476x_radio_do_post_powerup_init(struct si476x_radio *radio, enum si476x_func func)
> +{
> +       int err;
> +
> +       /* regcache_mark_dirty(radio->core->regmap); */
> +       err = regcache_sync_region(radio->core->regmap,
> +                                  SI476X_PROP_DIGITAL_IO_INPUT_SAMPLE_RATE,
> +                                  SI476X_PROP_DIGITAL_IO_OUTPUT_FORMAT);
> +               if (err < 0)
> +                       return err;
> +
> +       err = regcache_sync_region(radio->core->regmap,
> +                                  SI476X_PROP_AUDIO_DEEMPHASIS,
> +                                  SI476X_PROP_AUDIO_PWR_LINE_FILTER);
> +       if (err < 0)
> +               return err;
> +
> +       err = regcache_sync_region(radio->core->regmap,
> +                                  SI476X_PROP_INT_CTL_ENABLE,
> +                                  SI476X_PROP_INT_CTL_ENABLE);
> +       if (err < 0)
> +               return err;
> +
> +       /*
> +        * Is there any point in restoring SNR and the like
> +        * when switching between AM/FM?
> +        */
> +       err = regcache_sync_region(radio->core->regmap,
> +                                  SI476X_PROP_VALID_MAX_TUNE_ERROR,
> +                                  SI476X_PROP_VALID_MAX_TUNE_ERROR);
> +       if (err < 0)
> +               return err;
> +
> +       err = regcache_sync_region(radio->core->regmap,
> +                                  SI476X_PROP_VALID_SNR_THRESHOLD,
> +                                  SI476X_PROP_VALID_RSSI_THRESHOLD);
> +       if (err < 0)
> +               return err;
> +
> +       if (func == SI476X_FUNC_FM_RECEIVER) {
> +               if (si476x_core_has_diversity(radio->core)) {
> +                       err = si476x_core_cmd_fm_phase_diversity(radio->core,
> +                                                                radio->core->diversity_mode);
> +                       if (err < 0)
> +                               return err;
> +               }
> +
> +               err = regcache_sync_region(radio->core->regmap,
> +                                          SI476X_PROP_FM_RDS_INTERRUPT_SOURCE,
> +                                          SI476X_PROP_FM_RDS_CONFIG);
> +               if (err < 0)
> +                       return err;
> +       }
> +
> +       return si476x_radio_init_vtable(radio, func);
> +
> +}
> +
> +static int si476x_radio_change_func(struct si476x_radio *radio, enum si476x_func func)
> +{
> +       int err;
> +       bool soft;
> +       /*
> +        * Since power/up down is a very time consuming operation,
> +        * try to avoid doing it if the requested mode matches the one
> +        * the tuner is in
> +        */
> +       if (func == radio->core->power_up_parameters.func)
> +               return 0;
> +
> +       soft = true;
> +       err = si476x_core_stop(radio->core, soft);
> +       if (err < 0) {
> +               /*
> +                * OK, if the chip does not want to play nice let's
> +                * try to reset it in more brutal way
> +                */
> +               soft = false;
> +               err = si476x_core_stop(radio->core, soft);
> +               if (err < 0)
> +                       return err;
> +       }
> +       /*
> +         Set the desired radio tuner function
> +        */
> +       radio->core->power_up_parameters.func = func;
> +
> +       err = si476x_core_start(radio->core, soft);
> +       if (err < 0)
> +               return err;
> +
> +       /*
> +        * No need to do the rest of manipulations for the bootlader
> +        * mode
> +        */
> +       if (func != SI476X_FUNC_FM_RECEIVER &&
> +           func != SI476X_FUNC_AM_RECEIVER)
> +               return err;
> +
> +       return si476x_radio_do_post_powerup_init(radio, func);
> +}
> +
> +static int si476x_radio_g_frequency(struct file *file, void *priv,
> +                             struct v4l2_frequency *f)
> +{
> +       int err;
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       if (f->tuner != 0 ||
> +           f->type  != V4L2_TUNER_RADIO)
> +               return -EINVAL;
> +
> +       si476x_core_lock(radio->core);
> +
> +       if (radio->ops->rsq_status) {
> +               struct si476x_rsq_status_report report;
> +               struct si476x_rsq_status_args   args = {
> +                       .primary        = false,
> +                       .rsqack         = false,
> +                       .attune         = true,
> +                       .cancel         = false,
> +                       .stcack         = false,
> +               };
> +
> +               err = radio->ops->rsq_status(radio->core, &args, &report);
> +               if (!err)
> +                       f->frequency = si476x_to_v4l2(radio->core,
> +                                                     report.readfreq);
> +       } else {
> +               err = -EINVAL;
> +       }
> +
> +       si476x_core_unlock(radio->core);
> +
> +       return err;
> +}
> +
> +static int si476x_radio_s_frequency(struct file *file, void *priv,
> +                                   struct v4l2_frequency *f)
> +{
> +       int err;
> +       struct si476x_tune_freq_args args;
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       const u32 midrange = (si476x_bands[SI476X_BAND_AM].rangehigh +
> +                             si476x_bands[SI476X_BAND_FM].rangelow) / 2;
> +       const int band = (f->frequency > midrange) ? SI476X_BAND_FM : SI476X_BAND_AM;
> +       const enum si476x_func func = (band == SI476X_BAND_AM) ?
> +               SI476X_FUNC_AM_RECEIVER : SI476X_FUNC_FM_RECEIVER;
> +
> +       if (f->tuner != 0 ||
> +           f->type  != V4L2_TUNER_RADIO)
> +               return -EINVAL;
> +
> +       si476x_core_lock(radio->core);
> +
> +       f->frequency = clamp(f->frequency,
> +                            si476x_bands[band].rangelow,
> +                            si476x_bands[band].rangehigh);
> +
> +       if (si476x_radio_freq_is_inside_of_the_band(f->frequency, SI476X_BAND_AM) &&
> +           (!si476x_core_has_am(radio->core) || si476x_core_is_a_secondary_tuner(radio->core))) {
> +               err = -EINVAL;
> +               goto unlock;
> +       }
> +
> +       err = si476x_radio_change_func(radio, func);
> +       if (err < 0)
> +               goto unlock;
> +
> +       args.zifsr              = false;
> +       args.hd                 = false;
> +       args.injside            = SI476X_INJSIDE_AUTO;
> +       args.freq               = v4l2_to_si476x(radio->core,
> +                                                f->frequency);
> +       args.tunemode           = SI476X_TM_VALIDATED_NORMAL_TUNE;
> +       args.smoothmetrics      = SI476X_SM_INITIALIZE_AUDIO;
> +       args.antcap             = 0;
> +
> +       err = radio->ops->tune_freq(radio->core, &args);
> +
> +unlock:
> +       si476x_core_unlock(radio->core);
> +       return err;
> +}
> +
> +static int si476x_radio_s_hw_freq_seek(struct file *file, void *priv,
> +                                      const struct v4l2_hw_freq_seek *seek)
> +{
> +       int err;
> +       enum si476x_func func;
> +       u32 rangelow, rangehigh;
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       if (file->f_flags & O_NONBLOCK)
> +               return -EAGAIN;
> +
> +       if (seek->tuner != 0 ||
> +           seek->type  != V4L2_TUNER_RADIO)
> +               return -EINVAL;
> +
> +       si476x_core_lock(radio->core);
> +
> +       if(!seek->rangelow) {
> +               err = regmap_read(radio->core->regmap,
> +                                 SI476X_PROP_SEEK_BAND_BOTTOM,
> +                                 &rangelow);
> +               if (!err)
> +                       rangelow = si476x_to_v4l2(radio->core, rangelow);
> +               else
> +                       goto unlock;
> +       }
> +       if(!seek->rangehigh) {
> +               err = regmap_read(radio->core->regmap,
> +                                 SI476X_PROP_SEEK_BAND_TOP,
> +                                 &rangehigh);
> +               if (!err)
> +                       rangehigh = si476x_to_v4l2(radio->core, rangehigh);
> +               else
> +                       goto unlock;
> +       }
> +
> +       if (rangelow > rangehigh) {
> +               err = -EINVAL;
> +               goto unlock;
> +       }
> +
> +       if (si476x_radio_range_is_inside_of_the_band(rangelow, rangehigh,
> +                                                    SI476X_BAND_FM)) {
> +               func = SI476X_FUNC_FM_RECEIVER;
> +
> +       } else if (si476x_core_has_am(radio->core) &&
> +                  si476x_radio_range_is_inside_of_the_band(rangelow, rangehigh,
> +                                                           SI476X_BAND_AM)) {
> +               func = SI476X_FUNC_AM_RECEIVER;
> +       } else {
> +               err = -EINVAL;
> +               goto unlock;
> +       }
> +
> +       err = si476x_radio_change_func(radio, func);
> +       if (err < 0) {
> +               goto unlock;
> +       }
> +
> +       if (seek->rangehigh) {
> +               err = regmap_write(radio->core->regmap,
> +                                  SI476X_PROP_SEEK_BAND_TOP,
> +                                  v4l2_to_si476x(radio->core,
> +                                                 seek->rangehigh));
> +               if (err)
> +                       goto unlock;
> +       }
> +       if (seek->rangelow) {
> +               err = regmap_write(radio->core->regmap,
> +                                  SI476X_PROP_SEEK_BAND_BOTTOM,
> +                                  v4l2_to_si476x(radio->core,
> +                                                 seek->rangelow));
> +               if (err)
> +                       goto unlock;
> +       }
> +       if (seek->spacing) {
> +               err = regmap_write(radio->core->regmap,
> +                                    SI476X_PROP_SEEK_FREQUENCY_SPACING,
> +                                    v4l2_to_si476x(radio->core,
> +                                                   seek->spacing));
> +               if (err)
> +                       goto unlock;
> +       }
> +
> +       err = radio->ops->seek_start(radio->core,
> +                                    seek->seek_upward,
> +                                    seek->wrap_around);
> +unlock:
> +       si476x_core_unlock(radio->core);
> +
> +
> +
> +       return err;
> +}
> +
> +static int si476x_radio_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +       int retval;
> +       struct si476x_radio *radio = v4l2_ctrl_handler_to_radio(ctrl->handler);
> +
> +       si476x_core_lock(radio->core);
> +
> +       switch (ctrl->id) {
> +       case SI476X_CID_INTERCHIP_LINK:
> +               if (si476x_core_has_diversity(radio->core)) {
> +                       if (radio->ops->phase_diversity) {
> +                               retval = radio->ops->phase_div_status(radio->core);
> +                               if (retval < 0)
> +                                       break;
> +
> +                               ctrl->val = !!SI476X_PHDIV_STATUS_LINK_LOCKED(retval);
> +                               retval = 0;
> +                               break;
> +                       } else {
> +                               retval = -ENOTTY;
> +                               break;
> +                       }
> +               }
> +               retval = -EINVAL;
> +               break;
> +       default:
> +               retval = -EINVAL;
> +               break;
> +       }
> +       si476x_core_unlock(radio->core);
> +       return retval;
> +
> +}
> +
> +static int si476x_radio_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +       int retval;
> +       enum si476x_phase_diversity_mode mode;
> +       struct si476x_radio *radio = v4l2_ctrl_handler_to_radio(ctrl->handler);
> +
> +       si476x_core_lock(radio->core);
> +
> +       switch (ctrl->id) {
> +       case SI476X_CID_HARMONICS_COUNT:
> +               retval = regmap_update_bits(radio->core->regmap,
> +                                           SI476X_PROP_AUDIO_PWR_LINE_FILTER,
> +                                           SI476X_PROP_PWR_HARMONICS_MASK,
> +                                           ctrl->val);
> +               break;
> +       case V4L2_CID_POWER_LINE_FREQUENCY:
> +               switch (ctrl->val) {
> +               case V4L2_CID_POWER_LINE_FREQUENCY_DISABLED:
> +                       retval = regmap_update_bits(radio->core->regmap,
> +                                                   SI476X_PROP_AUDIO_PWR_LINE_FILTER,
> +                                                   SI476X_PROP_PWR_ENABLE_MASK,
> +                                                   0);
> +                       break;
> +               case V4L2_CID_POWER_LINE_FREQUENCY_50HZ:
> +                       retval = regmap_update_bits(radio->core->regmap,
> +                                                   SI476X_PROP_AUDIO_PWR_LINE_FILTER,
> +                                                   SI476X_PROP_PWR_GRID_MASK,
> +                                                   SI476X_PROP_PWR_GRID_50HZ);
> +                       break;
> +               case V4L2_CID_POWER_LINE_FREQUENCY_60HZ:
> +                       retval = regmap_update_bits(radio->core->regmap,
> +                                                   SI476X_PROP_AUDIO_PWR_LINE_FILTER,
> +                                                   SI476X_PROP_PWR_GRID_MASK,
> +                                                   SI476X_PROP_PWR_GRID_60HZ);
> +                       break;
> +               default:
> +                       retval = -EINVAL;
> +                       break;
> +               }
> +               break;
> +       case SI476X_CID_RSSI_THRESHOLD:
> +               retval = regmap_write(radio->core->regmap,
> +                                     SI476X_PROP_VALID_RSSI_THRESHOLD,
> +                                     ctrl->val);
> +               break;
> +       case SI476X_CID_SNR_THRESHOLD:
> +               retval = regmap_write(radio->core->regmap,
> +                                     SI476X_PROP_VALID_SNR_THRESHOLD,
> +                                     ctrl->val);
> +               break;
> +       case SI476X_CID_MAX_TUNE_ERROR:
> +               retval = regmap_write(radio->core->regmap,
> +                                     SI476X_PROP_VALID_MAX_TUNE_ERROR,
> +                                     ctrl->val);
> +               break;
> +       case SI476X_CID_RDS_RECEPTION:
> +               /*
> +                * It looks like RDS related properties are
> +                * inaccesable when tuner is in AM mode, so cache the
> +                * changes
> +                */
> +               if(si476x_core_is_in_am_receiver_mode(radio->core))
> +                       regcache_cache_only(radio->core->regmap, true);
> +
> +               if (ctrl->val) {
> +                       retval = regmap_write(radio->core->regmap,
> +                                             SI476X_PROP_FM_RDS_INTERRUPT_FIFO_COUNT,
> +                                             radio->core->rds_fifo_depth);
> +                       if (retval < 0)
> +                               break;
> +
> +                       if (radio->core->client->irq) {
> +                               retval = regmap_write(radio->core->regmap,
> +                                                     SI476X_PROP_FM_RDS_INTERRUPT_SOURCE,
> +                                                     SI476X_RDSRECV);
> +                               if (retval < 0)
> +                                       break;
> +                       }
> +
> +                       /* Drain RDS FIFO before enabling RDS processing */
> +                       retval = si476x_core_cmd_fm_rds_status(radio->core, false,
> +                                                              true, true, NULL);
> +                       if (retval < 0)
> +                               break;
> +
> +                       retval = regmap_update_bits(radio->core->regmap,
> +                                                   SI476X_PROP_FM_RDS_CONFIG,
> +                                                   SI476X_PROP_RDSEN_MASK,
> +                                                   SI476X_PROP_RDSEN);
> +               } else {
> +                       retval = regmap_update_bits(radio->core->regmap,
> +                                                   SI476X_PROP_FM_RDS_CONFIG,
> +                                                   SI476X_PROP_RDSEN_MASK,
> +                                                   !SI476X_PROP_RDSEN);
> +               }
> +
> +               if(si476x_core_is_in_am_receiver_mode(radio->core))
> +                       regcache_cache_only(radio->core->regmap, false);
> +               break;
> +       case SI476X_CID_DEEMPHASIS:
> +               retval = regmap_write(radio->core->regmap,
> +                                     SI476X_PROP_AUDIO_DEEMPHASIS,
> +                                     ctrl->val);
> +               break;
> +
> +       case SI476X_CID_DIVERSITY_MODE:
> +               mode = si476x_phase_diversity_idx_to_mode(ctrl->val);
> +
> +               if (mode == radio->core->diversity_mode) {
> +                       retval = 0;
> +                       break;
> +               }
> +
> +               if(si476x_core_is_in_am_receiver_mode(radio->core)) {
> +                       /*
> +                        * Diversity cannot be configured while tuner
> +                        * is in AM mode so save tha changes and carry on.
> +                        */
> +                       radio->core->diversity_mode = mode;
> +                       retval = 0;
> +               } else {
> +                       retval = radio->ops->phase_diversity(radio->core, mode);
> +                       if (!retval)
> +                               radio->core->diversity_mode = mode;
> +               }
> +               break;
> +
> +       default:
> +               retval = -EINVAL;
> +               break;
> +       }
> +
> +       si476x_core_unlock(radio->core);
> +
> +       return retval;
> +}
> +
> +static int si476x_radio_g_chip_ident(struct file *file, void *fh,
> +                                    struct v4l2_dbg_chip_ident *chip)
> +{
> +       if (chip->match.type == V4L2_CHIP_MATCH_HOST &&
> +           v4l2_chip_match_host(&chip->match))
> +               return 0;
> +       return -EINVAL;
> +}
> +
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +static int si476x_radio_g_register(struct file *file, void *fh,
> +                                  struct v4l2_dbg_register *reg)
> +{
> +       int err;
> +       unsigned int value;
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       si476x_core_lock(radio->core);
> +       reg->size = 2;
> +       err = regmap_read(radio->core->regmap,
> +                         (unsigned int)reg->reg, &value);
> +       reg->val = value;
> +       si476x_core_unlock(radio->core);
> +
> +       return err;
> +}
> +static int si476x_radio_s_register(struct file *file, void *fh,
> +                                  struct v4l2_dbg_register *reg)
> +{
> +
> +       int err;
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       si476x_core_lock(radio->core);
> +       err = regmap_write(radio->core->regmap,
> +                          (unsigned int)reg->reg,
> +                          (unsigned int)reg->val);
> +       si476x_core_unlock(radio->core);
> +
> +       return err;
> +}
> +#endif
> +
> +static int si476x_radio_fops_open(struct file *file)
> +{
> +       struct si476x_radio *radio = video_drvdata(file);
> +       int err;
> +
> +       err = v4l2_fh_open(file);
> +       if (err)
> +               return err;
> +
> +       if (v4l2_fh_is_singular_file(file)) {
> +               si476x_core_lock(radio->core);
> +               err = si476x_core_set_power_state(radio->core,
> +                                                 SI476X_POWER_UP_FULL);
> +               if (err < 0)
> +                       goto done;
> +
> +               err = si476x_radio_do_post_powerup_init(radio,
> +                                                       radio->core->power_up_parameters.func);
> +               if (err < 0)
> +                       goto power_down;
> +
> +               err = si476x_radio_pretune(radio,
> +                                          radio->core->power_up_parameters.func);
> +               if (err < 0)
> +                       goto power_down;
> +
> +               si476x_core_unlock(radio->core);
> +               /* Must be done after si476x_core_unlock to prevent a deadlock */
> +               v4l2_ctrl_handler_setup(&radio->ctrl_handler);
> +       }
> +
> +       return err;
> +
> +power_down:
> +       si476x_core_set_power_state(radio->core,
> +                                   SI476X_POWER_DOWN);
> +done:
> +       si476x_core_unlock(radio->core);
> +       v4l2_fh_release(file);
> +
> +       return err;
> +}
> +
> +static int si476x_radio_fops_release(struct file *file)
> +{
> +       int err;
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       if (v4l2_fh_is_singular_file(file) &&
> +           atomic_read(&radio->core->is_alive))
> +               si476x_core_set_power_state(radio->core,
> +                                           SI476X_POWER_DOWN);
> +
> +       err = v4l2_fh_release(file);
> +
> +       return err;
> +}
> +
> +static ssize_t si476x_radio_fops_read(struct file *file, char __user *buf,
> +                                     size_t count, loff_t *ppos)
> +{
> +       ssize_t      rval;
> +       size_t       fifo_len;
> +       unsigned int copied;
> +
> +       struct si476x_radio *radio = video_drvdata(file);
> +
> +       /* block if no new data available */
> +       if (kfifo_is_empty(&radio->core->rds_fifo)) {
> +               if (file->f_flags & O_NONBLOCK)
> +                       return -EWOULDBLOCK;
> +
> +               rval = wait_event_interruptible(radio->core->rds_read_queue,
> +                                               (!kfifo_is_empty(&radio->core->rds_fifo) ||
> +                                                !atomic_read(&radio->core->is_alive)));
> +               if (rval < 0)
> +                       return -EINTR;
> +
> +               if (!atomic_read(&radio->core->is_alive))
> +                       return -ENODEV;
> +       }
> +
> +       fifo_len = kfifo_len(&radio->core->rds_fifo);
> +
> +       if (kfifo_to_user(&radio->core->rds_fifo, buf,
> +                         min(fifo_len, count),
> +                         &copied) != 0) {
> +               dev_warn(&radio->videodev.dev,
> +                        "Error during FIFO to userspace copy\n");
> +               rval = -EIO;
> +       } else {
> +               rval = (ssize_t)copied;
> +       }
> +
> +       return rval;
> +}
> +
> +static unsigned int si476x_radio_fops_poll(struct file *file,
> +                               struct poll_table_struct *pts)
> +{
> +       struct si476x_radio *radio = video_drvdata(file);
> +       unsigned long req_events = poll_requested_events(pts);
> +       int err = v4l2_ctrl_poll(file, pts);
> +
> +       if (req_events & (POLLIN | POLLRDNORM)) {
> +               if (atomic_read(&radio->core->is_alive))
> +                       poll_wait(file, &radio->core->rds_read_queue, pts);
> +
> +               if (!atomic_read(&radio->core->is_alive))
> +                       err = POLLHUP;
> +
> +               if (!kfifo_is_empty(&radio->core->rds_fifo))
> +                       err = POLLIN | POLLRDNORM;
> +       }
> +
> +       return err;

Could you please check this function? Is it better to declare "err" as
unsigned int? It looks like v4l2_ctrl_poll() returns unsigned int and
this function needs to return unsigned int also.

-- 
Best regards, Klimov Alexey
