Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab2IXNeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:34:21 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1615 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2IXNeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:34:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2] media: davinci: vpif: display: separate out subdev from output
Date: Mon, 24 Sep 2012 15:32:20 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc3-durdane; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        VGER <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <1348483451-20668-1-git-send-email-prabhakar.lad@ti.com> <201209241350.00893.hverkuil@xs4all.nl> <CA+V-a8t5qYBAY4xjFQOM5UcdrLRfuta-mbeO0qbTZ-EFR8=LwA@mail.gmail.com>
In-Reply-To: <CA+V-a8t5qYBAY4xjFQOM5UcdrLRfuta-mbeO0qbTZ-EFR8=LwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209241532.21024.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon September 24 2012 15:21:44 Prabhakar Lad wrote:
> Hi Hans,
> 
> On Mon, Sep 24, 2012 at 5:20 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Mon September 24 2012 12:59:11 Hans Verkuil wrote:
> >> On Mon September 24 2012 12:44:11 Prabhakar wrote:
> >> > From: Lad, Prabhakar <prabhakar.lad@ti.com>
> >> >
> >> > vpif_display relied on a 1-1 mapping of output and subdev. This is not
> >> > necessarily the case. Separate the two. So there is a list of subdevs
> >> > and a list of outputs. Each output refers to a subdev and has routing
> >> > information. An output does not have to have a subdev.
> >> >
> >> > The initial output for each channel is set to the fist output.
> >> >
> >> > Currently missing is support for associating multiple subdevs with
> >> > an output.
> >> >
> >> > Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> >> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> >> > Cc: Hans Verkuil <hans.verkuil@cisco.com>
> >> > Cc: Sekhar Nori <nsekhar@ti.com>
> >>
> >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> >
> > I'm retracting this Ack. I did see something that wasn't right but I thought
> > it was harmless, but after thinking some more I believe it should be fixed.
> > Luckily, it's easy to fix. See below. Since we need a new version anyway I
> > also added a comment to a few minor issues that can be fixed at the same time.
> >
> >>
> >> Regards,
> >>
> >>       Hans
> >>
> >> > ---
> >> >  This patch is dependent on the patch series from Hans
> >> >  (http://www.mail-archive.com/linux-media@vger.kernel.org/msg52270.html)
> >> >
> >> >  Changes for V2:
> >> >  1: Changed v4l2_device_call_until_err() call to v4l2_subdev_call() for
> >> >     s_routing, since this call is for specific subdev, pointed out by Hans.
> >> >
> >> >  arch/arm/mach-davinci/board-da850-evm.c       |   29 +++++-
> >> >  arch/arm/mach-davinci/board-dm646x-evm.c      |   39 ++++++-
> >> >  drivers/media/platform/davinci/vpif_display.c |  136 ++++++++++++++++++++-----
> >> >  include/media/davinci/vpif_types.h            |   20 +++-
> >> >  4 files changed, 183 insertions(+), 41 deletions(-)
> >> >
> >> > diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> >> > index 3081ea4..23a7012 100644
> >> > --- a/arch/arm/mach-davinci/board-da850-evm.c
> >> > +++ b/arch/arm/mach-davinci/board-da850-evm.c
> >> > @@ -46,6 +46,7 @@
> >> >  #include <mach/spi.h>
> >> >
> >> >  #include <media/tvp514x.h>
> >> > +#include <media/adv7343.h>
> >> >
> >> >  #define DA850_EVM_PHY_ID           "davinci_mdio-0:00"
> >> >  #define DA850_LCD_PWR_PIN          GPIO_TO_PIN(2, 8)
> >> > @@ -1257,16 +1258,34 @@ static struct vpif_subdev_info da850_vpif_subdev[] = {
> >> >     },
> >> >  };
> >> >
> >> > -static const char const *vpif_output[] = {
> >> > -           "Composite",
> >> > -           "S-Video",
> >> > +static const struct vpif_output da850_ch0_outputs[] = {
> >> > +   {
> >> > +           .output = {
> >> > +                   .index = 0,
> >> > +                   .name = "Composite",
> >> > +                   .type = V4L2_OUTPUT_TYPE_ANALOG,
> >> > +           },
> >> > +           .subdev_name = "adv7343",
> >> > +           .output_route = ADV7343_COMPOSITE_ID,
> >> > +   },
> >> > +   {
> >> > +           .output = {
> >> > +                   .index = 1,
> >> > +                   .name = "S-Video",
> >> > +                   .type = V4L2_OUTPUT_TYPE_ANALOG,
> >> > +           },
> >> > +           .subdev_name = "adv7343",
> >> > +           .output_route = ADV7343_SVIDEO_ID,
> >> > +   },
> >> >  };
> >> >
> >> >  static struct vpif_display_config da850_vpif_display_config = {
> >> >     .subdevinfo   = da850_vpif_subdev,
> >> >     .subdev_count = ARRAY_SIZE(da850_vpif_subdev),
> >> > -   .output       = vpif_output,
> >> > -   .output_count = ARRAY_SIZE(vpif_output),
> >> > +   .chan_config[0] = {
> >> > +           .outputs = da850_ch0_outputs,
> >> > +           .output_count = ARRAY_SIZE(da850_ch0_outputs),
> >> > +   },
> >> >     .card_name    = "DA850/OMAP-L138 Video Display",
> >> >  };
> >> >
> >> > diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> >> > index ad249c7..c206768 100644
> >> > --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> >> > +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> >> > @@ -26,6 +26,7 @@
> >> >  #include <linux/i2c/pcf857x.h>
> >> >
> >> >  #include <media/tvp514x.h>
> >> > +#include <media/adv7343.h>
> >> >
> >> >  #include <linux/mtd/mtd.h>
> >> >  #include <linux/mtd/nand.h>
> >> > @@ -496,18 +497,44 @@ static struct vpif_subdev_info dm646x_vpif_subdev[] = {
> >> >     },
> >> >  };
> >> >
> >> > -static const char *output[] = {
> >> > -   "Composite",
> >> > -   "Component",
> >> > -   "S-Video",
> >> > +static const struct vpif_output dm6467_ch0_outputs[] = {
> >> > +   {
> >> > +           .output = {
> >> > +                   .index = 0,
> >> > +                   .name = "Composite",
> >> > +                   .type = V4L2_OUTPUT_TYPE_ANALOG,
> >> > +           },
> >> > +           .subdev_name = "adv7343",
> >> > +           .output_route = ADV7343_COMPOSITE_ID,
> >> > +   },
> >> > +   {
> >> > +           .output = {
> >> > +                   .index = 1,
> >> > +                   .name = "Component",
> >> > +                   .type = V4L2_OUTPUT_TYPE_ANALOG,
> >> > +           },
> >> > +           .subdev_name = "adv7343",
> >> > +           .output_route = ADV7343_COMPONENT_ID,
> >> > +   },
> >> > +   {
> >> > +           .output = {
> >> > +                   .index = 2,
> >> > +                   .name = "S-Video",
> >> > +                   .type = V4L2_OUTPUT_TYPE_ANALOG,
> >> > +           },
> >> > +           .subdev_name = "adv7343",
> >> > +           .output_route = ADV7343_SVIDEO_ID,
> >> > +   },
> >> >  };
> >> >
> >> >  static struct vpif_display_config dm646x_vpif_display_config = {
> >> >     .set_clock      = set_vpif_clock,
> >> >     .subdevinfo     = dm646x_vpif_subdev,
> >> >     .subdev_count   = ARRAY_SIZE(dm646x_vpif_subdev),
> >> > -   .output         = output,
> >> > -   .output_count   = ARRAY_SIZE(output),
> >> > +   .chan_config[0] = {
> >> > +           .outputs = dm6467_ch0_outputs,
> >> > +           .output_count = ARRAY_SIZE(dm6467_ch0_outputs),
> >> > +   },
> >> >     .card_name      = "DM646x EVM",
> >> >  };
> >> >
> >> > diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
> >> > index 8d1ce09..f68780f 100644
> >> > --- a/drivers/media/platform/davinci/vpif_display.c
> >> > +++ b/drivers/media/platform/davinci/vpif_display.c
> >> > @@ -308,7 +308,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
> >> >             channel2_intr_assert();
> >> >             channel2_intr_enable(1);
> >> >             enable_channel2(1);
> >> > -           if (vpif_config_data->ch2_clip_en)
> >> > +           if (vpif_config_data->chan_config[VPIF_CHANNEL2_VIDEO].clip_en)
> >> >                     channel2_clipping_enable(1);
> >> >     }
> >> >
> >> > @@ -317,7 +317,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
> >> >             channel3_intr_assert();
> >> >             channel3_intr_enable(1);
> >> >             enable_channel3(1);
> >> > -           if (vpif_config_data->ch3_clip_en)
> >> > +           if (vpif_config_data->chan_config[VPIF_CHANNEL3_VIDEO].clip_en)
> >> >                     channel3_clipping_enable(1);
> >> >     }
> >> >
> >> > @@ -1174,14 +1174,16 @@ static int vpif_streamoff(struct file *file, void *priv,
> >> >     if (buftype == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> >> >             /* disable channel */
> >> >             if (VPIF_CHANNEL2_VIDEO == ch->channel_id) {
> >> > -                   if (vpif_config_data->ch2_clip_en)
> >> > +                   if (vpif_config_data->
> >> > +                           chan_config[VPIF_CHANNEL2_VIDEO].clip_en)
> >> >                             channel2_clipping_enable(0);
> >> >                     enable_channel2(0);
> >> >                     channel2_intr_enable(0);
> >> >             }
> >> >             if ((VPIF_CHANNEL3_VIDEO == ch->channel_id) ||
> >> >                                     (2 == common->started)) {
> >> > -                   if (vpif_config_data->ch3_clip_en)
> >> > +                   if (vpif_config_data->
> >> > +                           chan_config[VPIF_CHANNEL3_VIDEO].clip_en)
> >> >                             channel3_clipping_enable(0);
> >> >                     enable_channel3(0);
> >> >                     channel3_intr_enable(0);
> >> > @@ -1214,41 +1216,118 @@ static int vpif_enum_output(struct file *file, void *fh,
> >> >  {
> >> >
> >> >     struct vpif_display_config *config = vpif_dev->platform_data;
> >> > +   struct vpif_display_chan_config *chan_cfg;
> >> > +   struct vpif_fh *vpif_handler = fh;
> >> > +   struct channel_obj *ch = vpif_handler->channel;
> >> >
> >> > -   if (output->index >= config->output_count) {
> >> > +   chan_cfg = &config->chan_config[ch->channel_id];
> >> > +   if (output->index >= chan_cfg->output_count) {
> >> >             vpif_dbg(1, debug, "Invalid output index\n");
> >> >             return -EINVAL;
> >> >     }
> >> >
> >> > -   strcpy(output->name, config->output[output->index]);
> >> > -   output->type = V4L2_OUTPUT_TYPE_ANALOG;
> >> > +   memcpy(output, &chan_cfg->outputs[output->index].output,
> >> > +           sizeof(*output));
> >
> >         *output = chan_cfg->outputs[output->index].output;
> >
> >> >     output->std = VPIF_V4L2_STD;
> >
> Should I move 'VPIF_V4L2_STD' this macro to vpif_types.h ?

No. VPIF_V4L2_STD == V4L2_STD_ALL, so just use V4L2_STD_ALL directly.

> > This should be part of chan_cfg->outputs[output->index].output and not be
> > overridden. If the output is a HDTV output, then std should be 0, otherwise
> > it should be whatever the std is that is supported by the output.
> >
> > Really no different to what we do in vpif_capture.
> >
> Ok
> 
> >> >
> >> >     return 0;
> >> >  }
> >> >
> >> > +/**
> >> > + * vpif_output_to_subdev() - Maps output to sub device
> >> > + * @vpif_cfg - global config ptr
> >> > + * @chan_cfg - channel config ptr
> >> > + * @index - Given output index from application
> >> > + *
> >> > + * lookup the sub device information for a given output index.
> >> > + * we report all the output to application. output table also
> >> > + * has sub device name for the each output
> >> > + */
> >> > +static int
> >> > +vpif_output_to_subdev(struct vpif_display_config *vpif_cfg,
> >> > +                 struct vpif_display_chan_config *chan_cfg, int index)
> >> > +{
> >> > +   struct vpif_subdev_info *subdev_info;
> >> > +   const char *subdev_name;
> >> > +   int i;
> >> > +
> >> > +   vpif_dbg(2, debug, "vpif_output_to_subdev\n");
> >> > +
> >> > +   if (chan_cfg->outputs == NULL)
> >> > +           return -1;
> >> > +
> >> > +   subdev_name = chan_cfg->outputs[index].subdev_name;
> >> > +   if (subdev_name == NULL)
> >> > +           return -1;
> >> > +
> >> > +   /* loop through the sub device list to get the sub device info */
> >> > +   for (i = 0; i < vpif_cfg->subdev_count; i++) {
> >> > +           subdev_info = &vpif_cfg->subdevinfo[i];
> >> > +           if (!strcmp(subdev_info->name, subdev_name))
> >> > +                   return i;
> >> > +   }
> >> > +   return -1;
> >> > +}
> >> > +
> >> > +/**
> >> > + * vpif_set_output() - Select an output
> >> > + * @vpif_cfg - global config ptr
> >> > + * @ch - channel
> >> > + * @index - Given output index from application
> >> > + *
> >> > + * Select the given output.
> >> > + */
> >> > +static int vpif_set_output(struct vpif_display_config *vpif_cfg,
> >> > +                 struct channel_obj *ch, int index)
> >> > +{
> >> > +   struct vpif_display_chan_config *chan_cfg =
> >> > +           &vpif_cfg->chan_config[ch->channel_id];
> >> > +   struct vpif_subdev_info *subdev_info = NULL;
> >> > +   struct v4l2_subdev *sd = NULL;
> >> > +   u32 input = 0, output = 0;
> >> > +   int sd_index;
> >> > +   int ret;
> >> > +
> >> > +   sd_index = vpif_output_to_subdev(vpif_cfg, chan_cfg, index);
> >> > +   if (sd_index >= 0) {
> >> > +           sd = vpif_obj.sd[sd_index];
> >> > +           subdev_info = &vpif_cfg->subdevinfo[sd_index];
> >> > +   }
> >> > +
> >> > +   if (sd) {
> >> > +           input = chan_cfg->outputs[index].input_route;
> >> > +           output = chan_cfg->outputs[index].output_route;
> >> > +           ret = v4l2_subdev_call(sd, video, s_routing, input, output, 0);
> >> > +           if (ret < 0) {
> >
> > Replace with:
> >
> >                 if (ret < 0 && ret != -ENOIOCTLCMD) {
> >
> > It's OK if the subdev doesn't support this s_routing operation.
> >
> Ok
> 
> >> > +                   vpif_err("Failed to set output\n");
> >> > +                   return ret;
> >> > +           }
> >> > +
> >> > +   }
> >> > +   ch->output_idx = index;
> >> > +   ch->sd = sd;
> >
> > Just like in the capture case you should update tvnorms:
> >
> >         ch->video_dev->tvnorms = chan_cfg->inputs[index].output.std;
> >
> > Make sure tvnorms is no longer set in vpif_video_template.
> > Ditto for current_norm. Since vpif_display.c supports g_std the current_norm
> > field shouldn't be used anymore.
> >
> > The capture case also updates vpifparams.iface:
> >
> >         ch->vpifparams.iface = chan_cfg->vpif_if;
> >
> > Isn't that needed for output as well?
> >
> The iface is never used  in display, so there isnt any necessity to assign it.

But it is used in vpif.c through vpif_set_video_params()!

Regards,

	Hans
