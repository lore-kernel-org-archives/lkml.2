Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab0EWMwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 08:52:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab0EWMwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 08:52:12 -0400
Message-ID: <4BF924E3.5020702@redhat.com>
Date: Sun, 23 May 2010 09:51:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] Add the viafb video capture driver
References: <1273098884-21848-1-git-send-email-corbet@lwn.net> <1273098884-21848-6-git-send-email-corbet@lwn.net>
In-Reply-To: <1273098884-21848-6-git-send-email-corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

Jonathan Corbet wrote:
> Add a driver for the video capture port on VIA integrated chipsets.  This
> version has a remaining OLPCism or two and expects to be talking to an
> ov7670; those can be improved as the need arises.
> 
> This work was supported by the One Laptop Per Child project.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

The driver is OK to my eyes. I just found 2 minor coding style issues.
it is ok to me if you want to sent it via your git tree.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>


PS.: sorry for not reviewing it earlier... I was a little busy during this
cycle, and I had some travels that delayed my tasks even further, causing
-ETOMANYPATCHES on my queue.

> ---
>  drivers/media/video/Kconfig      |   10 +
>  drivers/media/video/Makefile     |    2 +
>  drivers/media/video/via-camera.c | 1368 ++++++++++++++++++++++++++++++++++++++
>  drivers/media/video/via-camera.h |   93 +++
>  drivers/video/via/accel.c        |    2 +-
>  drivers/video/via/via-core.c     |   16 +-
>  include/linux/via-core.h         |    4 +-
>  include/media/v4l2-chip-ident.h  |    4 +
>  8 files changed, 1495 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/media/video/via-camera.c
>  create mode 100644 drivers/media/video/via-camera.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index f8fc865..198636b 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -833,6 +833,16 @@ config VIDEO_CAFE_CCIC
>  	  CMOS camera controller.  This is the controller found on first-
>  	  generation OLPC systems.
>  
> +config VIDEO_VIA_CAMERA
> +	tristate "VIAFB camera controller support"
> +	depends on FB_VIA
> +	select VIDEOBUF_DMA_SG
> +	select VIDEO_OV7670
> +	help
> +	   Driver support for the integrated camera controller in VIA
> +	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
> +	   with ov7670 sensors.
> +
>  config SOC_CAMERA
>  	tristate "SoC camera support"
>  	depends on VIDEO_V4L2 && HAS_DMA && I2C
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index b88b617..089bb24 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -123,6 +123,8 @@ obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
>  
>  obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
>  
> +obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
> +
>  obj-$(CONFIG_USB_DABUSB)        += dabusb.o
>  obj-$(CONFIG_USB_OV511)         += ov511.o
>  obj-$(CONFIG_USB_SE401)         += se401.o
> diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
> new file mode 100644
> index 0000000..7b1ff0c
> --- /dev/null
> +++ b/drivers/media/video/via-camera.c
> @@ -0,0 +1,1368 @@
> +/*
> + * Driver for the VIA Chrome integrated camera controller.
> + *
> + * Copyright 2009,2010 Jonathan Corbet <corbet@lwn.net>
> + * Distributable under the terms of the GNU General Public License, version 2
> + *
> + * This work was supported by the One Laptop Per Child project
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/pci.h>
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/pci.h>
> +#include <linux/platform_device.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-chip-ident.h>
> +#include <media/videobuf-dma-sg.h>
> +#include <linux/device.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/pm_qos_params.h>
> +#include <linux/via-core.h>
> +#include <linux/via-gpio.h>
> +#include <linux/via_i2c.h>
> +
> +#include "via-camera.h"
> +
> +MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
> +MODULE_DESCRIPTION("VIA framebuffer-based camera controller driver");
> +MODULE_LICENSE("GPL");
> +
> +static int flip_image;
> +module_param(flip_image, bool, 0444);
> +MODULE_PARM_DESC(flip_image,
> +		"If set, the sensor will be instructed to flip the image "
> +		"vertically.");
> +
> +#ifdef CONFIG_OLPC_XO_1_5
> +static int override_serial;
> +module_param(override_serial, bool, 0444);
> +MODULE_PARM_DESC(override_serial,
> +		"The camera driver will normally refuse to load if "
> +		"the XO 1.5 serial port is enabled.  Set this option "
> +		"to force the issue.");
> +#endif
> +
> +/*
> + * Basic window sizes.
> + */
> +#define VGA_WIDTH	640
> +#define VGA_HEIGHT	480
> +#define QCIF_WIDTH	176
> +#define	QCIF_HEIGHT	144
> +
> +/*
> + * The structure describing our camera.
> + */
> +enum viacam_opstate { S_IDLE = 0, S_RUNNING = 1 };
> +
> +static struct via_camera {
> +	struct v4l2_device v4l2_dev;
> +	struct video_device vdev;
> +	struct v4l2_subdev *sensor;
> +	struct platform_device *platdev;
> +	struct viafb_dev *viadev;
> +	struct mutex lock;
> +	enum viacam_opstate opstate;
> +	unsigned long flags;
> +	/*
> +	 * GPIO info for power/reset management
> +	 */
> +	int power_gpio;
> +	int reset_gpio;
> +	/*
> +	 * I/O memory stuff.
> +	 */
> +	void __iomem *mmio;	/* Where the registers live */
> +	void __iomem *fbmem;	/* Frame buffer memory */
> +	u32 fb_offset;		/* Reserved memory offset (FB) */
> +	/*
> +	 * Capture buffers and related.	 The controller supports
> +	 * up to three, so that's what we have here.  These buffers
> +	 * live in frame buffer memory, so we don't call them "DMA".
> +	 */
> +	unsigned int cb_offsets[3];	/* offsets into fb mem */
> +	u8 *cb_addrs[3];		/* Kernel-space addresses */
> +	int n_cap_bufs;			/* How many are we using? */
> +	int next_buf;
> +	struct videobuf_queue vb_queue;
> +	struct list_head buffer_queue;	/* prot. by reg_lock */
> +	/*
> +	 * User tracking.
> +	 */
> +	int users;
> +	struct file *owner;
> +	/*
> +	 * Video format information.  sensor_format is kept in a form
> +	 * that we can use to pass to the sensor.  We always run the
> +	 * sensor in VGA resolution, though, and let the controller
> +	 * downscale things if need be.	 So we keep the "real*
> +	 * dimensions separately.
> +	 */
> +	struct v4l2_pix_format sensor_format;
> +	struct v4l2_pix_format user_format;
> +} via_cam_info;
> +
> +/*
> + * Flag values, manipulated with bitops
> + */
> +#define CF_DMA_ACTIVE	 0	/* A frame is incoming */
> +#define CF_CONFIG_NEEDED 1	/* Must configure hardware */
> +
> +
> +/*
> + * Nasty ugly v4l2 boilerplate.
> + */
> +#define sensor_call(cam, optype, func, args...) \
> +	v4l2_subdev_call(cam->sensor, optype, func, ##args)
> +
> +/*
> + * Debugging and related.
> + */
> +#define cam_err(cam, fmt, arg...) \
> +	dev_err(&(cam)->platdev->dev, fmt, ##arg);
> +#define cam_warn(cam, fmt, arg...) \
> +	dev_warn(&(cam)->platdev->dev, fmt, ##arg);
> +#define cam_dbg(cam, fmt, arg...) \
> +	dev_dbg(&(cam)->platdev->dev, fmt, ##arg);
> +
> +
> +/*--------------------------------------------------------------------------*/
> +/*
> + * Sensor power/reset management.  This piece is OLPC-specific for
> + * sure; other configurations will have things connected differently.
> + */
> +static int via_sensor_power_setup(struct via_camera *cam)
> +{
> +	int ret;
> +
> +	cam->power_gpio = viafb_gpio_lookup("VGPIO3");
> +	cam->reset_gpio = viafb_gpio_lookup("VGPIO2");
> +	if (cam->power_gpio < 0 || cam->reset_gpio < 0) {
> +		dev_err(&cam->platdev->dev, "Unable to find GPIO lines\n");
> +		return -EINVAL;
> +	}
> +	ret = gpio_request(cam->power_gpio, "viafb-camera");
> +	if (ret) {
> +		dev_err(&cam->platdev->dev, "Unable to request power GPIO\n");
> +		return ret;
> +	}
> +	ret = gpio_request(cam->reset_gpio, "viafb-camera");
> +	if (ret) {
> +		dev_err(&cam->platdev->dev, "Unable to request reset GPIO\n");
> +		gpio_free(cam->power_gpio);
> +		return ret;
> +	}
> +	gpio_direction_output(cam->power_gpio, 0);
> +	gpio_direction_output(cam->reset_gpio, 0);
> +	return 0;
> +}
> +
> +/*
> + * Power up the sensor and perform the reset dance.
> + */
> +static void via_sensor_power_up(struct via_camera *cam)
> +{
> +	gpio_set_value(cam->power_gpio, 1);
> +	gpio_set_value(cam->reset_gpio, 0);
> +	msleep(20);  /* Probably excessive */
> +	gpio_set_value(cam->reset_gpio, 1);
> +	msleep(20);
> +}
> +
> +static void via_sensor_power_down(struct via_camera *cam)
> +{
> +	gpio_set_value(cam->power_gpio, 0);
> +	gpio_set_value(cam->reset_gpio, 0);
> +}
> +
> +
> +static void via_sensor_power_release(struct via_camera *cam)
> +{
> +	via_sensor_power_down(cam);
> +	gpio_free(cam->power_gpio);
> +	gpio_free(cam->reset_gpio);
> +}
> +
> +/* --------------------------------------------------------------------------*/
> +/* Sensor ops */
> +
> +/*
> + * Manage the ov7670 "flip" bit, which needs special help.
> + */
> +static int viacam_set_flip(struct via_camera *cam)
> +{
> +	struct v4l2_control ctrl;
> +
> +	memset(&ctrl, 0, sizeof(ctrl));
> +	ctrl.id = V4L2_CID_VFLIP;
> +	ctrl.value = flip_image;
> +	return sensor_call(cam, core, s_ctrl, &ctrl);
> +}
> +
> +/*
> + * Configure the sensor.  It's up to the caller to ensure
> + * that the camera is in the correct operating state.
> + */
> +static int viacam_configure_sensor(struct via_camera *cam)
> +{
> +	struct v4l2_format fmt;
> +	int ret;
> +
> +	fmt.fmt.pix = cam->sensor_format;
> +	ret = sensor_call(cam, core, init, 0);
> +	if (ret == 0)
> +		ret = sensor_call(cam, video, s_fmt, &fmt);
> +	/*
> +	 * OV7670 does weird things if flip is set *before* format...
> +	 */
> +	if (ret == 0)
> +		ret = viacam_set_flip(cam);
> +	return ret;
> +}
> +
> +
> +
> +/* --------------------------------------------------------------------------*/
> +/*
> + * Some simple register accessors; they assume that the lock is held.
> + *
> + * Should we want to support the second capture engine, we could
> + * hide the register difference by adding 0x1000 to registers in the
> + * 0x300-350 range.
> + */
> +static inline void viacam_write_reg(struct via_camera *cam,
> +		int reg, int value)
> +{
> +	iowrite32(value, cam->mmio + reg);
> +}
> +
> +static inline int viacam_read_reg(struct via_camera *cam, int reg)
> +{
> +	return ioread32(cam->mmio + reg);
> +}
> +
> +static inline void viacam_write_reg_mask(struct via_camera *cam,
> +		int reg, int value, int mask)
> +{
> +	int tmp = viacam_read_reg(cam, reg);
> +
> +	tmp = (tmp & ~mask) | (value & mask);
> +	viacam_write_reg(cam, reg, tmp);
> +}
> +
> +
> +/* --------------------------------------------------------------------------*/
> +/* Interrupt management and handling */
> +
> +static irqreturn_t viacam_quick_irq(int irq, void *data)
> +{
> +	struct via_camera *cam = data;
> +	irqreturn_t ret = IRQ_NONE;
> +	int icv;
> +
> +	/*
> +	 * All we do here is to clear the interrupts and tell
> +	 * the handler thread to wake up.
> +	 */
> +	spin_lock(&cam->viadev->reg_lock);
> +	icv = viacam_read_reg(cam, VCR_INTCTRL);
> +	if (icv & VCR_IC_EAV) {
> +		icv |= VCR_IC_EAV|VCR_IC_EVBI|VCR_IC_FFULL;
> +		viacam_write_reg(cam, VCR_INTCTRL, icv);
> +		ret = IRQ_WAKE_THREAD;
> +	}
> +	spin_unlock(&cam->viadev->reg_lock);
> +	return ret;
> +}
> +
> +/*
> + * Find the next videobuf buffer which has somebody waiting on it.
> + */
> +static struct videobuf_buffer *viacam_next_buffer(struct via_camera *cam)
> +{
> +	unsigned long flags;
> +	struct videobuf_buffer *buf = NULL;
> +
> +	spin_lock_irqsave(&cam->viadev->reg_lock, flags);
> +	if (cam->opstate != S_RUNNING)
> +		goto out;
> +	if (list_empty(&cam->buffer_queue))
> +		goto out;
> +	buf = list_entry(cam->buffer_queue.next, struct videobuf_buffer, queue);
> +	if (!waitqueue_active(&buf->done)) {/* Nobody waiting */
> +		buf = NULL;
> +		goto out;
> +	}
> +	list_del(&buf->queue);
> +	buf->state = VIDEOBUF_ACTIVE;
> +out:
> +	spin_unlock_irqrestore(&cam->viadev->reg_lock, flags);
> +	return buf;
> +}
> +
> +/*
> + * The threaded IRQ handler.
> + */
> +static irqreturn_t viacam_irq(int irq, void *data)
> +{
> +	int bufn;
> +	struct videobuf_buffer *vb;
> +	struct via_camera *cam = data;
> +	struct videobuf_dmabuf *vdma;
> +
> +	/*
> +	 * If there is no place to put the data frame, don't bother
> +	 * with anything else.
> +	 */
> +	vb = viacam_next_buffer(cam);
> +	if (vb == NULL)
> +		goto done;
> +	/*
> +	 * Figure out which buffer we just completed.
> +	 */
> +	bufn = (viacam_read_reg(cam, VCR_INTCTRL) & VCR_IC_ACTBUF) >> 3;
> +	bufn -= 1;
> +	if (bufn < 0)
> +		bufn = cam->n_cap_bufs - 1;
> +	/*
> +	 * Copy over the data and let any waiters know.
> +	 */
> +	vdma = videobuf_to_dma(vb);
> +	viafb_dma_copy_out_sg(cam->cb_offsets[bufn], vdma->sglist, vdma->sglen);
> +	vb->state = VIDEOBUF_DONE;
> +	vb->size = cam->user_format.sizeimage;
> +	wake_up(&vb->done);
> +done:
> +	return IRQ_HANDLED;
> +}
> +
> +
> +/*
> + * These functions must mess around with the general interrupt
> + * control register, which is relevant to much more than just the
> + * camera.  Nothing else uses interrupts, though, as of this writing.
> + * Should that situation change, we'll have to improve support at
> + * the via-core level.
> + */
> +static void viacam_int_enable(struct via_camera *cam)
> +{
> +	viacam_write_reg(cam, VCR_INTCTRL,
> +			VCR_IC_INTEN|VCR_IC_EAV|VCR_IC_EVBI|VCR_IC_FFULL);
> +	viafb_irq_enable(VDE_I_C0AVEN);
> +}
> +
> +static void viacam_int_disable(struct via_camera *cam)
> +{
> +	viafb_irq_disable(VDE_I_C0AVEN);
> +	viacam_write_reg(cam, VCR_INTCTRL, 0);
> +}
> +
> +
> +
> +/* --------------------------------------------------------------------------*/
> +/* Controller operations */
> +
> +/*
> + * Set up our capture buffers in framebuffer memory.
> + */
> +static int viacam_ctlr_cbufs(struct via_camera *cam)
> +{
> +	int nbuf = cam->viadev->camera_fbmem_size/cam->sensor_format.sizeimage;
> +	int i;
> +	unsigned int offset;
> +
> +	/*
> +	 * See how many buffers we can work with.
> +	 */
> +	if (nbuf >= 3) {
> +		cam->n_cap_bufs = 3;
> +		viacam_write_reg_mask(cam, VCR_CAPINTC, VCR_CI_3BUFS,
> +				VCR_CI_3BUFS);
> +	} else if (nbuf == 2) {
> +		cam->n_cap_bufs = 2;
> +		viacam_write_reg_mask(cam, VCR_CAPINTC, 0, VCR_CI_3BUFS);
> +	} else {
> +		cam_warn(cam, "Insufficient frame buffer memory\n");
> +		return -ENOMEM;
> +	}
> +	/*
> +	 * Set them up.
> +	 */
> +	offset = cam->fb_offset;
> +	for (i = 0; i < cam->n_cap_bufs; i++) {
> +		cam->cb_offsets[i] = offset;
> +		cam->cb_addrs[i] = cam->fbmem + offset;
> +		viacam_write_reg(cam, VCR_VBUF1 + i*4, offset & VCR_VBUF_MASK);
> +		offset += cam->sensor_format.sizeimage;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Set the scaling register for downscaling the image.
> + *
> + * This register works like this...  Vertical scaling is enabled
> + * by bit 26; if that bit is set, downscaling is controlled by the
> + * value in bits 16:25.	 Those bits are divided by 1024 to get
> + * the scaling factor; setting just bit 25 thus cuts the height
> + * in half.
> + *
> + * Horizontal scaling works about the same, but it's enabled by
> + * bit 11, with bits 0:10 giving the numerator of a fraction
> + * (over 2048) for the scaling value.
> + *
> + * This function is naive in that, if the user departs from
> + * the 3x4 VGA scaling factor, the image will distort.	We
> + * could work around that if it really seemed important.
> + */
> +static void viacam_set_scale(struct via_camera *cam)
> +{
> +	unsigned int avscale;
> +	int sf;
> +
> +	if (cam->user_format.width == VGA_WIDTH)
> +		avscale = 0;
> +	else {
> +		sf = (cam->user_format.width*2048)/VGA_WIDTH;
> +		avscale = VCR_AVS_HEN | sf;
> +	}
> +	if (cam->user_format.height < VGA_HEIGHT) {
> +		sf = (1024*cam->user_format.height)/VGA_HEIGHT;
> +		avscale |= VCR_AVS_VEN | (sf << 16);
> +	}
> +	viacam_write_reg(cam, VCR_AVSCALE, avscale);
> +}
> +
> +
> +/*
> + * Configure image-related information into the capture engine.
> + */
> +static void viacam_ctlr_image(struct via_camera *cam)
> +{
> +	int cicreg;
> +
> +	/*
> +	 * Disable clock before messing with stuff - from the via
> +	 * sample driver.
> +	 */
> +	viacam_write_reg(cam, VCR_CAPINTC, ~VCR_CI_ENABLE);
> +	viacam_write_reg(cam, VCR_CAPINTC, ~(VCR_CI_ENABLE|VCR_CI_CLKEN));
> +	/*
> +	 * Disable a bunch of stuff.
> +	 */
> +	viacam_write_reg(cam, VCR_HORRANGE, 0x06200120);
> +	viacam_write_reg(cam, VCR_VERTRANGE, 0x01de0000);
> +	viacam_set_scale(cam);
> +	/*
> +	 * Image size info.
> +	 */
> +	viacam_write_reg(cam, VCR_MAXDATA,
> +			(cam->sensor_format.height << 16) |
> +			(cam->sensor_format.bytesperline >> 3));
> +	viacam_write_reg(cam, VCR_MAXVBI, 0);
> +	viacam_write_reg(cam, VCR_VSTRIDE,
> +			cam->user_format.bytesperline & VCR_VS_STRIDE);
> +	/*
> +	 * Set up the capture interface control register,
> +	 * everything but the "go" bit.
> +	 *
> +	 * The FIFO threshold is a bit of a magic number; 8 is what
> +	 * VIA's sample code uses.
> +	 */
> +	cicreg = VCR_CI_CLKEN |
> +		0x08000000 |		/* FIFO threshold */
> +		VCR_CI_FLDINV |		/* OLPC-specific? */
> +		VCR_CI_VREFINV |	/* OLPC-specific? */
> +		VCR_CI_DIBOTH |		/* Capture both fields */
> +		VCR_CI_CCIR601_8;
> +	if (cam->n_cap_bufs == 3)
> +		cicreg |= VCR_CI_3BUFS;
> +	/*
> +	 * YUV formats need different byte swapping than RGB.
> +	 */
> +	if (cam->user_format.pixelformat == V4L2_PIX_FMT_YUYV)
> +		cicreg |= VCR_CI_YUYV;
> +	else
> +		cicreg |= VCR_CI_UYVY;
> +	viacam_write_reg(cam, VCR_CAPINTC, cicreg);
> +}
> +
> +
> +static int viacam_config_controller(struct via_camera *cam)
> +{
> +	int ret;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&cam->viadev->reg_lock, flags);
> +	ret = viacam_ctlr_cbufs(cam);
> +	if (!ret)
> +		viacam_ctlr_image(cam);
> +	spin_unlock_irqrestore(&cam->viadev->reg_lock, flags);
> +	clear_bit(CF_CONFIG_NEEDED, &cam->flags);
> +	return ret;
> +}
> +
> +/*
> + * Make it start grabbing data.
> + */
> +static void viacam_start_engine(struct via_camera *cam)
> +{
> +	spin_lock_irq(&cam->viadev->reg_lock);
> +	cam->next_buf = 0;
> +	viacam_write_reg_mask(cam, VCR_CAPINTC, VCR_CI_ENABLE, VCR_CI_ENABLE);
> +	viacam_int_enable(cam);
> +	(void) viacam_read_reg(cam, VCR_CAPINTC); /* Force post */
> +	cam->opstate = S_RUNNING;
> +	spin_unlock_irq(&cam->viadev->reg_lock);
> +}
> +
> +
> +static void viacam_stop_engine(struct via_camera *cam)
> +{
> +	spin_lock_irq(&cam->viadev->reg_lock);
> +	viacam_int_disable(cam);
> +	viacam_write_reg_mask(cam, VCR_CAPINTC, 0, VCR_CI_ENABLE);
> +	(void) viacam_read_reg(cam, VCR_CAPINTC); /* Force post */
> +	cam->opstate = S_IDLE;
> +	spin_unlock_irq(&cam->viadev->reg_lock);
> +}
> +
> +
> +/* --------------------------------------------------------------------------*/
> +/* Videobuf callback ops */
> +
> +/*
> + * buffer_setup.  The purpose of this one would appear to be to tell
> + * videobuf how big a single image is.	It's also evidently up to us
> + * to put some sort of limit on the maximum number of buffers allowed.
> + */
> +static int viacam_vb_buf_setup(struct videobuf_queue *q,
> +		unsigned int *count, unsigned int *size)
> +{
> +	struct via_camera *cam = q->priv_data;
> +
> +	*size = cam->user_format.sizeimage;
> +	if (*count == 0 || *count > 6)	/* Arbitrary number */
> +		*count = 6;
> +	return 0;
> +}
> +
> +/*
> + * Prepare a buffer.
> + */
> +static int viacam_vb_buf_prepare(struct videobuf_queue *q,
> +		struct videobuf_buffer *vb, enum v4l2_field field)
> +{
> +	struct via_camera *cam = q->priv_data;
> +
> +	vb->size = cam->user_format.sizeimage;
> +	vb->width = cam->user_format.width; /* bytesperline???? */
> +	vb->height = cam->user_format.height;
> +	vb->field = field;
> +	if (vb->state == VIDEOBUF_NEEDS_INIT) {
> +		int ret = videobuf_iolock(q, vb, NULL);
> +		if (ret)
> +			return ret;
> +	}
> +	vb->state = VIDEOBUF_PREPARED;
> +	return 0;
> +}
> +
> +/*
> + * We've got a buffer to put data into.
> + *
> + * FIXME: check for a running engine and valid buffers?
> + */
> +static void viacam_vb_buf_queue(struct videobuf_queue *q,
> +		struct videobuf_buffer *vb)
> +{
> +	struct via_camera *cam = q->priv_data;
> +
> +	/*
> +	 * Note that videobuf holds the lock when it calls
> +	 * us, so we need not (indeed, cannot) take it here.
> +	 */
> +	vb->state = VIDEOBUF_QUEUED;
> +	list_add_tail(&vb->queue, &cam->buffer_queue);
> +}
> +
> +/*
> + * Free a buffer.
> + */
> +static void viacam_vb_buf_release(struct videobuf_queue *q,
> +		struct videobuf_buffer *vb)
> +{
> +	videobuf_dma_unmap(q, videobuf_to_dma(vb));
> +	videobuf_dma_free(videobuf_to_dma(vb));
> +	vb->state = VIDEOBUF_NEEDS_INIT;
> +}
> +
> +static const struct videobuf_queue_ops viacam_vb_ops = {
> +	.buf_setup	= viacam_vb_buf_setup,
> +	.buf_prepare	= viacam_vb_buf_prepare,
> +	.buf_queue	= viacam_vb_buf_queue,
> +	.buf_release	= viacam_vb_buf_release,
> +};
> +
> +/* --------------------------------------------------------------------------*/
> +/* File operations */
> +
> +static int viacam_open(struct file *filp)
> +{
> +	struct via_camera *cam = video_drvdata(filp);
> +
> +	filp->private_data = cam;
> +	/*
> +	 * Note the new user.  If this is the first one, we'll also
> +	 * need to power up the sensor.
> +	 */
> +	mutex_lock(&cam->lock);
> +	if (cam->users == 0) {
> +		int ret = viafb_request_dma();
> +
> +		if (ret) {
> +			mutex_unlock(&cam->lock);
> +			return ret;
> +		}
> +		via_sensor_power_up(cam);
> +		set_bit(CF_CONFIG_NEEDED, &cam->flags);
> +		/*
> +		 * Hook into videobuf.	Evidently this cannot fail.
> +		 */
> +		videobuf_queue_sg_init(&cam->vb_queue, &viacam_vb_ops,
> +				&cam->platdev->dev, &cam->viadev->reg_lock,
> +				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
> +				sizeof(struct videobuf_buffer), cam);
> +	}
> +	(cam->users)++;
> +	mutex_unlock(&cam->lock);
> +	return 0;
> +}
> +
> +static int viacam_release(struct file *filp)
> +{
> +	struct via_camera *cam = video_drvdata(filp);
> +
> +	mutex_lock(&cam->lock);
> +	(cam->users)--;
> +	/*
> +	 * If the "owner" is closing, shut down any ongoing
> +	 * operations.
> +	 */
> +	if (filp == cam->owner) {
> +		videobuf_stop(&cam->vb_queue);
> +		if (cam->opstate != S_IDLE)
> +			viacam_stop_engine(cam);
> +		cam->owner = NULL;
> +	}
> +	/*
> +	 * Last one out needs to turn out the lights.
> +	 */
> +	if (cam->users == 0) {
> +		videobuf_mmap_free(&cam->vb_queue);
> +		via_sensor_power_down(cam);
> +		viafb_release_dma();
> +	}
> +	mutex_unlock(&cam->lock);
> +	return 0;
> +}
> +
> +/*
> + * Read a frame from the device.
> + */
> +static ssize_t viacam_read(struct file *filp, char __user *buffer,
> +		size_t len, loff_t *pos)
> +{
> +	struct via_camera *cam = video_drvdata(filp);
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	/*
> +	 * Enforce the V4l2 "only one owner gets to read data" rule.
> +	 */
> +	if (cam->owner && cam->owner != filp) {
> +		ret = -EBUSY;
> +		goto out_unlock;
> +	}
> +	cam->owner = filp;
> +	/*
> +	 * Do we need to configure the hardware?
> +	 */
> +	if (test_bit(CF_CONFIG_NEEDED, &cam->flags)) {
> +		ret = viacam_configure_sensor(cam);
> +		if (!ret)
> +			ret = viacam_config_controller(cam);
> +		if (ret)
> +			goto out_unlock;
> +	}
> +	/*
> +	 * Fire up the capture engine, then have videobuf do
> +	 * the heavy lifting.  Someday it would be good to avoid
> +	 * stopping and restarting the engine each time.
> +	 */
> +	INIT_LIST_HEAD(&cam->buffer_queue);
> +	viacam_start_engine(cam);
> +	ret = videobuf_read_stream(&cam->vb_queue, buffer, len, pos, 0,
> +			filp->f_flags & O_NONBLOCK);
> +	viacam_stop_engine(cam);
> +	/* videobuf_stop() ?? */
> +
> +out_unlock:
> +	mutex_unlock(&cam->lock);
> +	return ret;
> +}
> +
> +
> +static unsigned int viacam_poll(struct file *filp, struct poll_table_struct *pt)
> +{
> +	struct via_camera *cam = video_drvdata(filp);
> +
> +	return videobuf_poll_stream(filp, &cam->vb_queue, pt);
> +}
> +
> +
> +static int viacam_mmap(struct file *filp, struct vm_area_struct *vma)
> +{
> +	struct via_camera *cam = video_drvdata(filp);
> +
> +	return videobuf_mmap_mapper(&cam->vb_queue, vma);
> +}
> +
> +
> +
> +static const struct v4l2_file_operations viacam_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= viacam_open,
> +	.release	= viacam_release,
> +	.read		= viacam_read,
> +	.poll		= viacam_poll,
> +	.mmap		= viacam_mmap,
> +	.ioctl		= video_ioctl2,
> +};
> +
> +/*----------------------------------------------------------------------------*/
> +/*
> + * The long list of v4l2 ioctl ops
> + */
> +
> +static int viacam_g_chip_ident(struct file *file, void *priv,
> +		struct v4l2_dbg_chip_ident *ident)
> +{
> +	struct via_camera *cam = priv;
> +
> +	ident->ident = V4L2_IDENT_NONE;
> +	ident->revision = 0;
> +	if (v4l2_chip_match_host(&ident->match)) {
> +		ident->ident = V4L2_IDENT_VIA_VX855;
> +		return 0;
> +	}
> +	return sensor_call(cam, core, g_chip_ident, ident);
> +}
> +
> +/*
> + * Control ops are passed through to the sensor.
> + */
> +static int viacam_queryctrl(struct file *filp, void *priv,
> +		struct v4l2_queryctrl *qc)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, core, queryctrl, qc);
> +	mutex_unlock(&cam->lock);
> +	return ret;
> +}
> +
> +
> +static int viacam_g_ctrl(struct file *filp, void *priv,
> +		struct v4l2_control *ctrl)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, core, g_ctrl, ctrl);
> +	mutex_unlock(&cam->lock);
> +	return ret;
> +}
> +
> +
> +static int viacam_s_ctrl(struct file *filp, void *priv,
> +		struct v4l2_control *ctrl)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, core, s_ctrl, ctrl);
> +	mutex_unlock(&cam->lock);
> +	return ret;
> +}
> +
> +/*
> + * Only one input.
> + */
> +static int viacam_enum_input(struct file *filp, void *priv,
> +		struct v4l2_input *input)
> +{
> +	if (input->index != 0)
> +		return -EINVAL;
> +
> +	input->type = V4L2_INPUT_TYPE_CAMERA;
> +	input->std = V4L2_STD_ALL; /* Not sure what should go here */
> +	strcpy(input->name, "Camera");
> +	return 0;
> +}
> +
> +static int viacam_g_input(struct file *filp, void *priv, unsigned int *i)
> +{
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int viacam_s_input(struct file *filp, void *priv, unsigned int i)
> +{
> +	if (i != 0)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static int viacam_s_std(struct file *filp, void *priv, v4l2_std_id *std)
> +{
> +	return 0;
> +}
> +
> +/*
> + * Video format stuff.	Here is our default format until
> + * user space messes with things.
> + */
> +static struct v4l2_pix_format viacam_def_pix_format = {
> +	.width		= VGA_WIDTH,
> +	.height		= VGA_HEIGHT,
> +	.pixelformat	= V4L2_PIX_FMT_YUYV,
> +	.field		= V4L2_FIELD_NONE,
> +	.bytesperline	= VGA_WIDTH*2,
> +	.sizeimage	= VGA_WIDTH*VGA_HEIGHT*2,

CodingStyle: please use spaces between values/operators. Not sure why, but
newer versions of checkpatch.pl don't complain anymore on some cases.

> +};
> +
> +static int viacam_enum_fmt_vid_cap(struct file *filp, void *priv,
> +		struct v4l2_fmtdesc *fmt)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, video, enum_fmt, fmt);
> +	mutex_unlock(&cam->lock);
> +	return ret;
> +}
> +
> +/*
> + * Figure out proper image dimensions, but always force the
> + * sensor to VGA.
> + */
> +static void viacam_fmt_pre(struct v4l2_pix_format *userfmt,
> +		struct v4l2_pix_format *sensorfmt)
> +{
> +	*sensorfmt = *userfmt;
> +	if (userfmt->width < QCIF_WIDTH || userfmt->height < QCIF_HEIGHT) {
> +		userfmt->width = QCIF_WIDTH;
> +		userfmt->height = QCIF_HEIGHT;
> +	}
> +	if (userfmt->width > VGA_WIDTH || userfmt->height > VGA_HEIGHT) {
> +		userfmt->width = VGA_WIDTH;
> +		userfmt->height = VGA_HEIGHT;
> +	}
> +	sensorfmt->width = VGA_WIDTH;
> +	sensorfmt->height = VGA_HEIGHT;
> +}
> +
> +static void viacam_fmt_post(struct v4l2_pix_format *userfmt,
> +		struct v4l2_pix_format *sensorfmt)
> +{
> +	userfmt->pixelformat = sensorfmt->pixelformat;
> +	userfmt->field = sensorfmt->field;
> +	userfmt->bytesperline = 2*userfmt->width;

CodingStyle: please use spaces between values/operators. Not sure why, but
newer versions of checkpatch.pl don't complain anymore on some cases.

> +	userfmt->sizeimage = userfmt->bytesperline*userfmt->height;
> +}
> +
> +static int viacam_try_fmt_vid_cap(struct file *filp, void *priv,
> +		struct v4l2_format *fmt)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +	struct v4l2_format sfmt;
> +
> +	viacam_fmt_pre(&fmt->fmt.pix, &sfmt.fmt.pix);
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, video, try_fmt, &sfmt);
> +	mutex_unlock(&cam->lock);
> +	viacam_fmt_post(&fmt->fmt.pix, &sfmt.fmt.pix);
> +	return ret;
> +}
> +
> +static int viacam_g_fmt_vid_cap(struct file *filp, void *priv,
> +		struct v4l2_format *fmt)
> +{
> +	struct via_camera *cam = priv;
> +
> +	fmt->fmt.pix = cam->user_format;
> +	return 0;
> +}
> +
> +static int viacam_s_fmt_vid_cap(struct file *filp, void *priv,
> +		struct v4l2_format *fmt)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +	struct v4l2_format sfmt;
> +
> +	/*
> +	 * Camera must be idle or we can't mess with the
> +	 * video setup.
> +	 */
> +	if (cam->opstate != S_IDLE)
> +		return -EBUSY;
> +	/*
> +	 * Let the sensor code look over and tweak the
> +	 * requested formatting.
> +	 */
> +	mutex_lock(&cam->lock);
> +	viacam_fmt_pre(&fmt->fmt.pix, &sfmt.fmt.pix);
> +	ret = sensor_call(cam, video, try_fmt, &sfmt);
> +	if (ret)
> +		goto out;
> +	viacam_fmt_post(&fmt->fmt.pix, &sfmt.fmt.pix);
> +	/*
> +	 * OK, let's commit to the new format.
> +	 */
> +	cam->user_format = fmt->fmt.pix;
> +	cam->sensor_format = sfmt.fmt.pix;
> +	ret = viacam_configure_sensor(cam);
> +	if (!ret)
> +		ret = viacam_config_controller(cam);
> +out:
> +	mutex_unlock(&cam->lock);
> +	return ret;
> +}
> +
> +static int viacam_querycap(struct file *filp, void *priv,
> +		struct v4l2_capability *cap)
> +{
> +	strcpy(cap->driver, "via-camera");
> +	strcpy(cap->card, "via-camera");
> +	cap->version = 1;
> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
> +		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
> +	return 0;
> +}
> +
> +/*
> + * Streaming operations - pure videobuf stuff.
> + */
> +static int viacam_reqbufs(struct file *filp, void *priv,
> +		struct v4l2_requestbuffers *rb)
> +{
> +	struct via_camera *cam = priv;
> +
> +	return videobuf_reqbufs(&cam->vb_queue, rb);
> +}
> +
> +static int viacam_querybuf(struct file *filp, void *priv,
> +		struct v4l2_buffer *buf)
> +{
> +	struct via_camera *cam = priv;
> +
> +	return videobuf_querybuf(&cam->vb_queue, buf);
> +}
> +
> +static int viacam_qbuf(struct file *filp, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct via_camera *cam = priv;
> +
> +	return videobuf_qbuf(&cam->vb_queue, buf);
> +}
> +
> +static int viacam_dqbuf(struct file *filp, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct via_camera *cam = priv;
> +
> +	return videobuf_dqbuf(&cam->vb_queue, buf, filp->f_flags & O_NONBLOCK);
> +}
> +
> +static int viacam_streamon(struct file *filp, void *priv, enum v4l2_buf_type t)
> +{
> +	struct via_camera *cam = priv;
> +	int ret = 0;
> +
> +	if (t != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +	if (cam->opstate != S_IDLE)
> +		return -EBUSY;
> +	/*
> +	 * Enforce the V4l2 "only one owner gets to read data" rule.
> +	 */

This is not really a V4L2 rule, but a hardware limitation. On most devices,
only one stream can be produced. 

> +	if (cam->owner && cam->owner != filp)
> +		return -EBUSY;
> +	cam->owner = filp;
> +	/*
> +	 * Configure things if need be.
> +	 */
> +	if (test_bit(CF_CONFIG_NEEDED, &cam->flags)) {
> +		mutex_lock(&cam->lock);
> +		ret = viacam_configure_sensor(cam);
> +		if (!ret)
> +			ret = viacam_config_controller(cam);
> +		mutex_unlock(&cam->lock);
> +	}
> +	/*
> +	 * If the CPU goes into C3, the DMA transfer gets corrupted and
> +	 * users start filing unsightly bug reports.  Put in a "latency"
> +	 * requirement which will keep the CPU out of the deeper sleep
> +	 * states.
> +	 */
> +	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, "viafb-dma", 50);
> +	/*
> +	 * Fire things up.
> +	 */
> +	if (!ret) {
> +		INIT_LIST_HEAD(&cam->buffer_queue);
> +		ret = videobuf_streamon(&cam->vb_queue);
> +		if (!ret)
> +			viacam_start_engine(cam);
> +	}
> +	return ret;
> +}
> +
> +static int viacam_streamoff(struct file *filp, void *priv, enum v4l2_buf_type t)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	if (t != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +	pm_qos_remove_requirement(PM_QOS_CPU_DMA_LATENCY, "viafb-dma");
> +	viacam_stop_engine(cam);
> +	/*
> +	 * Videobuf will recycle all of the outstanding buffers, but
> +	 * we should be sure we don't retain any references to
> +	 * any of them.
> +	 */
> +	ret = videobuf_streamoff(&cam->vb_queue);
> +	INIT_LIST_HEAD(&cam->buffer_queue);
> +	return ret;
> +}
> +
> +#ifdef CONFIG_VIDEO_V4L1_COMPAT
> +static int viacam_vidiocgmbuf(struct file *filp, void *priv,
> +		struct video_mbuf *mbuf)
> +{
> +	struct via_camera *cam = priv;
> +
> +	return videobuf_cgmbuf(&cam->vb_queue, mbuf, 6);
> +}
> +#endif
> +
> +/* G/S_PARM */
> +
> +static int viacam_g_parm(struct file *filp, void *priv,
> +		struct v4l2_streamparm *parm)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, video, g_parm, parm);
> +	mutex_unlock(&cam->lock);
> +	parm->parm.capture.readbuffers = cam->n_cap_bufs;
> +	return ret;
> +}
> +
> +static int viacam_s_parm(struct file *filp, void *priv,
> +		struct v4l2_streamparm *parm)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, video, s_parm, parm);
> +	mutex_unlock(&cam->lock);
> +	parm->parm.capture.readbuffers = cam->n_cap_bufs;
> +	return ret;
> +}
> +
> +static int viacam_enum_framesizes(struct file *filp, void *priv,
> +		struct v4l2_frmsizeenum *sizes)
> +{
> +	if (sizes->index != 0)
> +		return -EINVAL;
> +	sizes->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
> +	sizes->stepwise.min_width = QCIF_WIDTH;
> +	sizes->stepwise.min_height = QCIF_HEIGHT;
> +	sizes->stepwise.max_width = VGA_WIDTH;
> +	sizes->stepwise.max_height = VGA_HEIGHT;
> +	sizes->stepwise.step_width = sizes->stepwise.step_height = 1;
> +	return 0;
> +}
> +
> +static int viacam_enum_frameintervals(struct file *filp, void *priv,
> +		struct v4l2_frmivalenum *interval)
> +{
> +	struct via_camera *cam = priv;
> +	int ret;
> +
> +	mutex_lock(&cam->lock);
> +	ret = sensor_call(cam, video, enum_frameintervals, interval);
> +	mutex_unlock(&cam->lock);
> +	return ret;
> +}
> +
> +
> +
> +static const struct v4l2_ioctl_ops viacam_ioctl_ops = {
> +	.vidioc_g_chip_ident	= viacam_g_chip_ident,
> +	.vidioc_queryctrl	= viacam_queryctrl,
> +	.vidioc_g_ctrl		= viacam_g_ctrl,
> +	.vidioc_s_ctrl		= viacam_s_ctrl,
> +	.vidioc_enum_input	= viacam_enum_input,
> +	.vidioc_g_input		= viacam_g_input,
> +	.vidioc_s_input		= viacam_s_input,
> +	.vidioc_s_std		= viacam_s_std,
> +	.vidioc_enum_fmt_vid_cap = viacam_enum_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap = viacam_try_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap	= viacam_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap	= viacam_s_fmt_vid_cap,
> +	.vidioc_querycap	= viacam_querycap,
> +	.vidioc_reqbufs		= viacam_reqbufs,
> +	.vidioc_querybuf	= viacam_querybuf,
> +	.vidioc_qbuf		= viacam_qbuf,
> +	.vidioc_dqbuf		= viacam_dqbuf,
> +	.vidioc_streamon	= viacam_streamon,
> +	.vidioc_streamoff	= viacam_streamoff,
> +	.vidioc_g_parm		= viacam_g_parm,
> +	.vidioc_s_parm		= viacam_s_parm,
> +	.vidioc_enum_framesizes = viacam_enum_framesizes,
> +	.vidioc_enum_frameintervals = viacam_enum_frameintervals,
> +#ifdef CONFIG_VIDEO_V4L1_COMPAT
> +	.vidiocgmbuf		= viacam_vidiocgmbuf,
> +#endif
> +};
> +
> +/*----------------------------------------------------------------------------*/
> +
> +/*
> + * Power management.
> + */
> +
> +/*
> + * Setup stuff.
> + */
> +
> +static struct video_device viacam_v4l_template = {
> +	.name		= "via-camera",
> +	.minor		= -1,
> +	.tvnorms	= V4L2_STD_NTSC_M,
> +	.current_norm	= V4L2_STD_NTSC_M,
> +	.fops		= &viacam_fops,
> +	.ioctl_ops	= &viacam_ioctl_ops,
> +	.release	= video_device_release_empty, /* Check this */
> +};
> +
> +
> +static __devinit int viacam_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +	struct i2c_adapter *sensor_adapter;
> +	struct viafb_dev *viadev = pdev->dev.platform_data;
> +
> +	/*
> +	 * Note that there are actually two capture channels on
> +	 * the device.	We only deal with one for now.	That
> +	 * is encoded here; nothing else assumes it's dealing with
> +	 * a unique capture device.
> +	 */
> +	struct via_camera *cam = &via_cam_info;
> +
> +	/*
> +	 * Ensure that frame buffer memory has been set aside for
> +	 * this purpose.  As an arbitrary limit, refuse to work
> +	 * with less than two frames of VGA 16-bit data.
> +	 *
> +	 * If we ever support the second port, we'll need to set
> +	 * aside more memory.
> +	 */
> +	if (viadev->camera_fbmem_size < (VGA_HEIGHT*VGA_WIDTH*4)) {
> +		printk(KERN_ERR "viacam: insufficient FB memory reserved\n");
> +		return -ENOMEM;
> +	}
> +	if (viadev->engine_mmio == NULL) {
> +		printk(KERN_ERR "viacam: No I/O memory, so no pictures\n");
> +		return -ENOMEM;
> +	}
> +	/*
> +	 * Basic structure initialization.
> +	 */
> +	cam->platdev = pdev;
> +	cam->viadev = viadev;
> +	cam->users = 0;
> +	cam->owner = NULL;
> +	cam->opstate = S_IDLE;
> +	cam->user_format = cam->sensor_format = viacam_def_pix_format;
> +	mutex_init(&cam->lock);
> +	INIT_LIST_HEAD(&cam->buffer_queue);
> +	cam->mmio = viadev->engine_mmio;
> +	cam->fbmem = viadev->fbmem;
> +	cam->fb_offset = viadev->camera_fbmem_offset;
> +	cam->flags = 1 << CF_CONFIG_NEEDED;
> +	/*
> +	 * Tell V4L that we exist.
> +	 */
> +	ret = v4l2_device_register(&pdev->dev, &cam->v4l2_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to register v4l2 device\n");
> +		return ret;
> +	}
> +	/*
> +	 * Convince the system that we can do DMA.
> +	 */
> +	pdev->dev.dma_mask = &viadev->pdev->dma_mask;
> +	dma_set_mask(&pdev->dev, 0xffffffff);
> +	/*
> +	 * Fire up the capture port.  The write to 0x78 looks purely
> +	 * OLPCish; any system will need to tweak 0x1e.
> +	 */
> +	via_write_reg_mask(VIASR, 0x78, 0, 0x80);
> +	via_write_reg_mask(VIASR, 0x1e, 0xc0, 0xc0);
> +	/*
> +	 * Get the sensor powered up.
> +	 */
> +	ret = via_sensor_power_setup(cam);
> +	if (ret)
> +		goto out_unregister;
> +	via_sensor_power_up(cam);
> +
> +	/*
> +	 * See if we can't find it on the bus.	The VIA_PORT_31 assumption
> +	 * is OLPC-specific.  0x42 assumption is ov7670-specific.
> +	 */
> +	sensor_adapter = viafb_find_i2c_adapter(VIA_PORT_31);
> +	cam->sensor = v4l2_i2c_new_subdev(&cam->v4l2_dev, sensor_adapter,
> +			"ov7670", "ov7670", 0x42 >> 1, NULL);
> +	if (cam->sensor == NULL) {
> +		dev_err(&pdev->dev, "Unable to find the sensor!\n");
> +		ret = -ENODEV;
> +		goto out_power_down;
> +	}
> +	/*
> +	 * Get the IRQ.
> +	 */
> +	viacam_int_disable(cam);
> +	ret = request_threaded_irq(viadev->pdev->irq, viacam_quick_irq,
> +			viacam_irq, IRQF_SHARED, "via-camera", cam);
> +	if (ret)
> +		goto out_power_down;
> +	/*
> +	 * Tell V4l2 that we exist.
> +	 */
> +	cam->vdev = viacam_v4l_template;
> +	cam->vdev.v4l2_dev = &cam->v4l2_dev;
> +	ret = video_register_device(&cam->vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret)
> +		goto out_irq;
> +	video_set_drvdata(&cam->vdev, cam);
> +
> +	/* Power the sensor down until somebody opens the device */
> +	via_sensor_power_down(cam);
> +	return 0;
> +
> +out_irq:
> +	free_irq(viadev->pdev->irq, cam);
> +out_power_down:
> +	via_sensor_power_release(cam);
> +out_unregister:
> +	v4l2_device_unregister(&cam->v4l2_dev);
> +	return ret;
> +}
> +
> +static __devexit int viacam_remove(struct platform_device *pdev)
> +{
> +	struct via_camera *cam = &via_cam_info;
> +	struct viafb_dev *viadev = pdev->dev.platform_data;
> +
> +	video_unregister_device(&cam->vdev);
> +	v4l2_device_unregister(&cam->v4l2_dev);
> +	free_irq(viadev->pdev->irq, cam);
> +	via_sensor_power_release(cam);
> +	return 0;
> +}
> +
> +
> +static struct platform_driver viacam_driver = {
> +	.driver = {
> +		.name = "viafb-camera",
> +	},
> +	.probe = viacam_probe,
> +	.remove = viacam_remove,
> +};
> +
> +
> +#ifdef CONFIG_OLPC_XO_1_5
> +/*
> + * The OLPC folks put the serial port on the same pin as
> + * the camera.	They also get grumpy if we break the
> + * serial port and keep them from using it.  So we have
> + * to check the serial enable bit and not step on it.
> + */
> +#define VIACAM_SERIAL_DEVFN 0x88
> +#define VIACAM_SERIAL_CREG 0x46
> +#define VIACAM_SERIAL_BIT 0x40
> +
> +static __devinit int viacam_check_serial_port(void)
> +{
> +	struct pci_bus *pbus = pci_find_bus(0, 0);
> +	u8 cbyte;
> +
> +	pci_bus_read_config_byte(pbus, VIACAM_SERIAL_DEVFN,
> +			VIACAM_SERIAL_CREG, &cbyte);
> +	if ((cbyte & VIACAM_SERIAL_BIT) == 0)
> +		return 0; /* Not enabled */
> +	if (override_serial == 0) {
> +		printk(KERN_NOTICE "Via camera: serial port is enabled, " \
> +				"refusing to load.\n");
> +		printk(KERN_NOTICE "Specify override_serial=1 to force " \
> +				"module loading.\n");
> +		return -EBUSY;
> +	}
> +	printk(KERN_NOTICE "Via camera: overriding serial port\n");
> +	pci_bus_write_config_byte(pbus, VIACAM_SERIAL_DEVFN,
> +			VIACAM_SERIAL_CREG, cbyte & ~VIACAM_SERIAL_BIT);
> +	return 0;
> +}
> +#endif
> +
> +
> +
> +
> +static int viacam_init(void)
> +{
> +#ifdef CONFIG_OLPC_XO_1_5
> +	if (viacam_check_serial_port())
> +		return -EBUSY;
> +#endif
> +	return platform_driver_register(&viacam_driver);
> +}
> +module_init(viacam_init);
> +
> +static void viacam_exit(void)
> +{
> +	platform_driver_unregister(&viacam_driver);
> +}
> +module_exit(viacam_exit);
> diff --git a/drivers/media/video/via-camera.h b/drivers/media/video/via-camera.h
> new file mode 100644
> index 0000000..b12a4b3
> --- /dev/null
> +++ b/drivers/media/video/via-camera.h
> @@ -0,0 +1,93 @@
> +/*
> + * VIA Camera register definitions.
> + */
> +#define VCR_INTCTRL	0x300	/* Capture interrupt control */
> +#define   VCR_IC_EAV	  0x0001   /* End of active video status */
> +#define	  VCR_IC_EVBI	  0x0002   /* End of VBI status */
> +#define   VCR_IC_FBOTFLD  0x0004   /* "flipping" Bottom field is active */
> +#define   VCR_IC_ACTBUF	  0x0018   /* Active video buffer  */
> +#define   VCR_IC_VSYNC	  0x0020   /* 0 = VB, 1 = active video */
> +#define   VCR_IC_BOTFLD	  0x0040   /* Bottom field is active */
> +#define   VCR_IC_FFULL	  0x0080   /* FIFO full */
> +#define   VCR_IC_INTEN	  0x0100   /* End of active video int. enable */
> +#define   VCR_IC_VBIINT	  0x0200   /* End of VBI int enable */
> +#define   VCR_IC_VBIBUF	  0x0400   /* Current VBI buffer */
> +
> +#define VCR_TSC		0x308	/* Transport stream control */
> +#define VCR_TSC_ENABLE    0x000001   /* Transport stream input enable */
> +#define VCR_TSC_DROPERR   0x000002   /* Drop error packets */
> +#define VCR_TSC_METHOD    0x00000c   /* DMA method (non-functional) */
> +#define VCR_TSC_COUNT     0x07fff0   /* KByte or packet count */
> +#define VCR_TSC_CBMODE	  0x080000   /* Change buffer by byte count */
> +#define VCR_TSC_PSSIG	  0x100000   /* Packet starting signal disable */
> +#define VCR_TSC_BE	  0x200000   /* MSB first (serial mode) */
> +#define VCR_TSC_SERIAL	  0x400000   /* Serial input (0 = parallel) */
> +
> +#define VCR_CAPINTC	0x310	/* Capture interface control */
> +#define   VCR_CI_ENABLE   0x00000001  /* Capture enable */
> +#define   VCR_CI_BSS	  0x00000002  /* WTF "bit stream selection" */
> +#define   VCR_CI_3BUFS	  0x00000004  /* 1 = 3 buffers, 0 = 2 buffers */
> +#define   VCR_CI_VIPEN	  0x00000008  /* VIP enable */
> +#define   VCR_CI_CCIR601_8  0	        /* CCIR601 input stream, 8 bit */
> +#define   VCR_CI_CCIR656_8  0x00000010  /* ... CCIR656, 8 bit */
> +#define   VCR_CI_CCIR601_16 0x00000020  /* ... CCIR601, 16 bit */
> +#define   VCR_CI_CCIR656_16 0x00000030  /* ... CCIR656, 16 bit */
> +#define   VCR_CI_HDMODE   0x00000040  /* CCIR656-16 hdr decode mode; 1=16b */
> +#define   VCR_CI_BSWAP    0x00000080  /* Swap bytes (16-bit) */
> +#define   VCR_CI_YUYV	  0	      /* Byte order 0123 */
> +#define   VCR_CI_UYVY	  0x00000100  /* Byte order 1032 */
> +#define   VCR_CI_YVYU	  0x00000200  /* Byte order 0321 */
> +#define   VCR_CI_VYUY	  0x00000300  /* Byte order 3012 */
> +#define   VCR_CI_VIPTYPE  0x00000400  /* VIP type */
> +#define   VCR_CI_IFSEN    0x00000800  /* Input field signal enable */
> +#define   VCR_CI_DIODD	  0	      /* De-interlace odd, 30fps */
> +#define   VCR_CI_DIEVEN   0x00001000  /*    ...even field, 30fps */
> +#define   VCR_CI_DIBOTH   0x00002000  /*    ...both fields, 60fps */
> +#define   VCR_CI_DIBOTH30 0x00003000  /*    ...both fields, 30fps interlace */
> +#define   VCR_CI_CONVTYPE 0x00004000  /* 4:2:2 to 4:4:4; 1 = interpolate */
> +#define   VCR_CI_CFC	  0x00008000  /* Capture flipping control */
> +#define   VCR_CI_FILTER   0x00070000  /* Horiz filter mode select
> +					 000 = none
> +					 001 = 2 tap
> +					 010 = 3 tap
> +					 011 = 4 tap
> +					 100 = 5 tap */
> +#define   VCR_CI_CLKINV   0x00080000  /* Input CLK inverted */
> +#define   VCR_CI_VREFINV  0x00100000  /* VREF inverted */
> +#define   VCR_CI_HREFINV  0x00200000  /* HREF inverted */
> +#define   VCR_CI_FLDINV   0x00400000  /* Field inverted */
> +#define   VCR_CI_CLKPIN	  0x00800000  /* Capture clock pin */
> +#define   VCR_CI_THRESH   0x0f000000  /* Capture fifo threshold */
> +#define   VCR_CI_HRLE     0x10000000  /* Positive edge of HREF */
> +#define   VCR_CI_VRLE     0x20000000  /* Positive edge of VREF */
> +#define   VCR_CI_OFLDINV  0x40000000  /* Field output inverted */
> +#define   VCR_CI_CLKEN    0x80000000  /* Capture clock enable */
> +
> +#define VCR_HORRANGE	0x314	/* Active video horizontal range */
> +#define VCR_VERTRANGE	0x318	/* Active video vertical range */
> +#define VCR_AVSCALE	0x31c	/* Active video scaling control */
> +#define   VCR_AVS_HEN	  0x00000800   /* Horizontal scale enable */
> +#define   VCR_AVS_VEN	  0x04000000   /* Vertical enable */
> +#define VCR_VBIHOR	0x320	/* VBI Data horizontal range */
> +#define VCR_VBIVERT	0x324	/* VBI data vertical range */
> +#define VCR_VBIBUF1	0x328	/* First VBI buffer */
> +#define VCR_VBISTRIDE	0x32c	/* VBI stride */
> +#define VCR_ANCDATACNT	0x330	/* Ancillary data count setting */
> +#define VCR_MAXDATA	0x334	/* Active data count of active video */
> +#define VCR_MAXVBI	0x338	/* Maximum data count of VBI */
> +#define VCR_CAPDATA	0x33c	/* Capture data count */
> +#define VCR_VBUF1	0x340	/* First video buffer */
> +#define VCR_VBUF2	0x344	/* Second video buffer */
> +#define VCR_VBUF3	0x348	/* Third video buffer */
> +#define VCR_VBUF_MASK	0x1ffffff0	/* Bits 28:4 */
> +#define VCR_VBIBUF2	0x34c	/* Second VBI buffer */
> +#define VCR_VSTRIDE	0x350	/* Stride of video + coring control */
> +#define   VCR_VS_STRIDE_SHIFT 4
> +#define   VCR_VS_STRIDE   0x00001ff0  /* Stride (8-byte units) */
> +#define   VCR_VS_CCD	  0x007f0000  /* Coring compare data */
> +#define   VCR_VS_COREEN   0x00800000  /* Coring enable */
> +#define VCR_TS0ERR	0x354	/* TS buffer 0 error indicator */
> +#define VCR_TS1ERR	0x358	/* TS buffer 0 error indicator */
> +#define VCR_TS2ERR	0x35c	/* TS buffer 0 error indicator */
> +
> +/* Add 0x1000 for the second capture engine registers */
> diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
> index e44893e..04bec05 100644
> --- a/drivers/video/via/accel.c
> +++ b/drivers/video/via/accel.c
> @@ -370,7 +370,7 @@ int viafb_init_engine(struct fb_info *info)
>  	viapar->shared->vq_vram_addr = viapar->fbmem_free;
>  	viapar->fbmem_used += VQ_SIZE;
>  
> -#if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)
> +#if defined(CONFIG_VIDEO_VIA_CAMERA) || defined(CONFIG_VIDEO_VIA_CAMERA_MODULE)
>  	/*
>  	 * Set aside a chunk of framebuffer memory for the camera
>  	 * driver.  Someday this driver probably needs a proper allocator
> diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
> index 15fcaab..ce13fc9 100644
> --- a/drivers/video/via/via-core.c
> +++ b/drivers/video/via/via-core.c
> @@ -95,6 +95,13 @@ EXPORT_SYMBOL_GPL(viafb_irq_disable);
>  
>  /* ---------------------------------------------------------------------- */
>  /*
> + * Currently, the camera driver is the only user of the DMA code, so we
> + * only compile it in if the camera driver is being built.  Chances are,
> + * most viafb systems will not need to have this extra code for a while.
> + * As soon as another user comes long, the ifdef can be removed.
> + */
> +#if defined(CONFIG_VIDEO_VIA_CAMERA) || defined(CONFIG_VIDEO_VIA_CAMERA_MODULE)
> +/*
>   * Access to the DMA engine.  This currently provides what the camera
>   * driver needs (i.e. outgoing only) but is easily expandable if need
>   * be.
> @@ -322,7 +329,7 @@ int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg)
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(viafb_dma_copy_out_sg);
> -
> +#endif /* CONFIG_VIDEO_VIA_CAMERA */
>  
>  /* ---------------------------------------------------------------------- */
>  /*
> @@ -507,7 +514,12 @@ static struct viafb_subdev_info {
>  	},
>  	{
>  		.name = "viafb-i2c",
> -	}
> +	},
> +#if defined(CONFIG_VIDEO_VIA_CAMERA) || defined(CONFIG_VIDEO_VIA_CAMERA_MODULE)
> +	{
> +		.name = "viafb-camera",
> +	},
> +#endif
>  };
>  #define N_SUBDEVS ARRAY_SIZE(viafb_subdevs)
>  
> diff --git a/include/linux/via-core.h b/include/linux/via-core.h
> index 7ffb521..38bffd8 100644
> --- a/include/linux/via-core.h
> +++ b/include/linux/via-core.h
> @@ -81,7 +81,7 @@ struct viafb_dev {
>  	unsigned long fbmem_start;
>  	long fbmem_len;
>  	void __iomem *fbmem;
> -#if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)
> +#if defined(CONFIG_VIDEO_VIA_CAMERA) || defined(CONFIG_VIDEO_VIA_CAMERA_MODULE)
>  	long camera_fbmem_offset;
>  	long camera_fbmem_size;
>  #endif
> @@ -138,6 +138,7 @@ void viafb_irq_disable(u32 mask);
>  #define   VDE_I_LVDSSIEN  0x40000000  /* LVDS Sense enable */
>  #define   VDE_I_ENABLE	  0x80000000  /* Global interrupt enable */
>  
> +#if defined(CONFIG_VIDEO_VIA_CAMERA) || defined(CONFIG_VIDEO_VIA_CAMERA_MODULE)
>  /*
>   * DMA management.
>   */
> @@ -172,6 +173,7 @@ int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg);
>   */
>  #define VGA_WIDTH	640
>  #define VGA_HEIGHT	480
> +#endif /* CONFIG_VIDEO_VIA_CAMERA */
>  
>  /*
>   * Indexed port operations.  Note that these are all multi-op
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index 56abf21..d1c4bd3 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -107,6 +107,10 @@ enum {
>  	V4L2_IDENT_VPX3216B = 3216,
>  	V4L2_IDENT_VPX3220A = 3220,
>  
> +	/* VX855 just ident 3409 */
> +	/* Other via devs could use 3314, 3324, 3327, 3336, 3364, 3353 */
> +	V4L2_IDENT_VIA_VX855 = 3409,
> +
>  	/* module tvp5150 */
>  	V4L2_IDENT_TVP5150 = 5150,
>  


-- 

Cheers,
Mauro
