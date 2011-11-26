Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1KZWQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 17:16:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39827 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab1KZWQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 17:16:16 -0500
Message-ID: <4ED1652A.8080701@gmail.com>
Date: Sat, 26 Nov 2011 23:16:10 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: tom.leiming@gmail.com
CC: tony@atomide.com, greg@kroah.com, arnd@arndb.de,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/3] drivers/misc: introduce face detection module driver(fdif)
References: <1322281904-14526-1-git-send-email-tom.leiming@gmail.com> <1322281904-14526-4-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1322281904-14526-4-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: LMML

On 11/26/2011 05:31 AM, tom.leiming@gmail.com wrote:
> From: Ming Lei <ming.lei@canonical.com>
> 
> One face detection IP[1] is integared inside OMAP4 SoC, so
> introduce this driver to make face detection function work
> on OMAP4 SoC.

Face detection IP is of course not specific to OMAP, I've seen it in other SoCs
already and integrated with the video capture pipeline.

And it clearly belongs to the media subsystem, there is already an infrastructure
there that don't need to be re-invented, like buffer management and various IO
method support.

I think there is not much needed on top of that to support FD. We have already
various mem-to-mem devices in V4L2, like video or image encoders or video
post-processors.

> 
> This driver is platform independent, so in theory can
> be used to drive same IP module on other platforms.
> 
> [1], ch9 of OMAP4 TRM
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/misc/Kconfig  |    7 +
>  drivers/misc/Makefile |    1 +
>  drivers/misc/fdif.c   |  874 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fdif.h  |   67 ++++
>  include/linux/major.h |    1 +
>  5 files changed, 950 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/fdif.c
>  create mode 100644 include/linux/fdif.h
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 5664696..884d8c7 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -500,6 +500,13 @@ config USB_SWITCH_FSA9480
>  	  stereo and mono audio, video, microphone and UART data to use
>  	  a common connector port.
>  
> +config FDIF
> +	tristate "Face Detection module"
> +	help
> +	  The FDIF is a face detection module, which can be integrated into
> +	  SoCs to detect the location of human beings' face in one image. At
> +	  least now, TI OMAP4 has the module inside.
> +
>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index b26495a..0ed85ef 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -47,4 +47,5 @@ obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
>  obj-y				+= lis3lv02d/
>  obj-y				+= carma/
>  obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
> +obj-$(CONFIG_FDIF)		+= fdif.o
>  obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
> diff --git a/drivers/misc/fdif.c b/drivers/misc/fdif.c
> new file mode 100644
> index 0000000..84a7049
> --- /dev/null
> +++ b/drivers/misc/fdif.c
> @@ -0,0 +1,874 @@
> +/*
> + *      fdif.c  --  face detection module driver
> + *
> + *      Copyright (C) 2011  Ming Lei (ming.lei@canonical.com)
> + *
> + *      This program is free software; you can redistribute it and/or modify
> + *      it under the terms of the GNU General Public License as published by
> + *      the Free Software Foundation; either version 2 of the License, or
> + *      (at your option) any later version.
> + *
> + *      This program is distributed in the hope that it will be useful,
> + *      but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *      GNU General Public License for more details.
> + *
> + *      You should have received a copy of the GNU General Public License
> + *      along with this program; if not, write to the Free Software
> + *      Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +/*****************************************************************************/
> +
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/signal.h>
> +#include <linux/wait.h>
> +#include <linux/poll.h>
> +#include <linux/module.h>
> +#include <linux/major.h>
> +#include <linux/cdev.h>
> +#include <linux/mman.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/delay.h>
> +#include <linux/user_namespace.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/fdif.h>
> +#include <asm/uaccess.h>
> +#include <asm/byteorder.h>
> +#include <asm/io.h>
> +
> +#undef	DEBUG
> +
> +#define FDIF_DEV	MKDEV(FDIF_MAJOR, 0)
> +#define FDIF_MAX_MINORS	8
> +
> +#define	WORK_MEM_SIZE	(52*1024)
> +
> +#define	FACE_SIZE_20_PIXELS	0
> +#define	FACE_SIZE_25_PIXELS	1
> +#define	FACE_SIZE_32_PIXELS	2
> +#define	FACE_SIZE_40_PIXELS	3
> +
> +#define FACE_DIR_UP		0
> +#define FACE_DIR_RIGHT		1
> +#define FACE_DIR_LIFT		2
> +
> +/* 9.5 FDIF Register Manua of TI OMAP4 TRM */
> +#define FDIF_REVISION		0x0
> +#define FDIF_HWINFO		0x4
> +#define FDIF_SYSCONFIG		0x10
> +#define SOFTRESET		(1 << 0)
> +
> +#define FDIF_IRQSTATUS_RAW_j	(0x24 + 2*0x10)
> +#define FDIF_IRQSTATUS_j	(0x28 + 2*0x10)
> +#define FDIF_IRQENABLE_SET_j	(0x2c + 2*0x10)
> +#define FDIF_IRQENABLE_CLR_j	(0x30 + 2*0x10)
> +#define FINISH_IRQ		(1 << 8)
> +#define ERR_IRQ			(1 << 0)
> +
> +#define FDIF_PICADDR		0x60
> +#define FDIF_CTRL		0x64
> +#define CTRL_MAX_TAGS		0x0A
> +
> +#define FDIF_WKADDR		0x68
> +#define FD_CTRL			0x80
> +#define CTRL_FINISH		(1 << 2)
> +#define CTRL_RUN		(1 << 1)
> +#define CTRL_SRST		(1 << 0)
> +
> +
> +#define FD_DNUM			0x84
> +#define FD_DCOND		0x88
> +#define FD_STARTX		0x8c
> +#define FD_STARTY		0x90
> +#define FD_SIZEX		0x94
> +#define FD_SIZEY		0x98
> +#define FD_LHIT			0x9c
> +#define FD_CENTERX_i		0x160
> +#define FD_CENTERY_i		0x164
> +#define FD_CONFSIZE_i		0x168
> +#define FD_ANGLE_i		0x16c
> +
> +static irqreturn_t handle_detection(int irq, void *__fdif);
> +
> +struct fdif {
> +	struct platform_device	*pdev;
> +	void __iomem		*base;
> +	struct mutex		mutex;
> +	int			open_count;
> +	int			irq;
> +	struct device		*dev;
> +	dma_addr_t		pict_dma;
> +	dma_addr_t		work_dma;
> +
> +	/* wake up if a face detection completed */
> +	wait_queue_head_t 	wait;
> +
> +	int			read_idx;
> +
> +	/*setting*/
> +	struct fdif_setting	s;
> +
> +	/*face detection result*/
> +	int			face_cnt;
> +	struct fdif_result	faces[MAX_FACE_COUNT];
> +};
> +
> +static struct class	*fdif_class;
> +
> +/*only support one fdif device now*/
> +static struct fdif	*g_fdif;
> +
> +static inline void fdif_writel(void __iomem *base, u32 reg, u32 val)
> +{
> +	__raw_writel(val, base + reg);
> +}
> +
> +static inline u32 fdif_readl(void __iomem *base, u32 reg)
> +{
> +	return __raw_readl(base + reg);
> +}
> +
> +#ifdef DEBUG
> +static void dump_fdif_setting(struct fdif *fdif, const char *func)
> +{
> +	printk("%s: %s\n", func, __func__);
> +	printk("picture addr:%8p, work mem addr:%8p\n",
> +			fdif->s.pict_addr, fdif->s.work_mem_addr);
> +	printk("face size=%2d, face dir=%2d, lhit=%d\n",
> +			fdif->s.min_face_size, fdif->s.face_dir,
> +			fdif->s.lhit);
> +	printk("startx =%4d starty=%4d sizex=%4d sizey=%4d\n",
> +			fdif->s.startx, fdif->s.starty,
> +			fdif->s.sizex, fdif->s.sizey);
> +}
> +
> +static void dump_fdif_results(struct fdif *fdif, const char *func)
> +{
> +	int idx;
> +
> +	printk("%s: %s\n", func, __func__);
> +
> +	printk("found %d faces\n", fdif->face_cnt);
> +	for(idx=0; idx < fdif->face_cnt; idx++) {
> +		struct fdif_result *fr = &fdif->faces[idx];
> +		printk("	No.%d x=%3d y=%2d sz=%2d ang=%3d conf=%2d\n",
> +				idx, fr->centerx, fr->centery,
> +				fr->size, fr->angle, fr->confidence);
> +	}
> +}
> +
> +static void dump_fdif_regs(struct fdif *fdif, const char *func)
> +{
> +	printk("%s:%s\n", __func__, func);
> +	printk("FDIF_CTRL=%08x FDIF_SYSCONFIG=%08x\n",
> +			fdif_readl(fdif->base, FDIF_CTRL),
> +			fdif_readl(fdif->base, FDIF_SYSCONFIG));
> +	printk("FDIF_IRQSTATUS_RAW_j=%08x FDIF_IRQSTATUS_j=%08x\n",
> +			fdif_readl(fdif->base, FDIF_IRQSTATUS_RAW_j),
> +			fdif_readl(fdif->base, FDIF_IRQSTATUS_j));
> +	printk("FDIF_PICADDR=%08x FDIF_WKADDR=%08x\n",
> +			fdif_readl(fdif->base, FDIF_PICADDR),
> +			fdif_readl(fdif->base, FDIF_WKADDR));
> +	printk("FD_CTRL=%04x\n", fdif_readl(fdif->base, FD_CTRL));
> +}
> +
> +#else
> +static inline void dump_fdif_setting(struct fdif *fdif, const char *func)
> +{
> +}
> +static inline void dump_fdif_results(struct fdif *fdif, const char *func)
> +{
> +}
> +static inline void dump_fdif_regs(struct fdif *fdif, const char *func)
> +{
> +}
> +#endif
> +
> +static void free_buffer(struct fdif *fdif)
> +{
> +	int order;
> +
> +	order = get_order(PICT_SIZE_X * PICT_SIZE_Y);
> +	free_pages((unsigned long)fdif->s.pict_addr, order);
> +
> +	order = get_order(WORK_MEM_SIZE);
> +	free_pages((unsigned long)fdif->s.work_mem_addr, order);
> +}
> +
> +static int allocate_buffer(struct fdif *fdif)
> +{
> +	struct device *dev = &fdif->pdev->dev;
> +	int order, ret;
> +
> +	order = get_order(PICT_SIZE_X * PICT_SIZE_Y);
> +	fdif->s.pict_addr = (void *)__get_free_pages(GFP_KERNEL, order);
> +	if (!fdif->s.pict_addr) {
> +		dev_err(dev, "fdif pict buffer allocation(%d) failed\n",
> +				order);
> +		ret = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	order = get_order(WORK_MEM_SIZE);
> +	fdif->s.work_mem_addr = (void *)__get_free_pages(GFP_KERNEL, order);
> +	if (!fdif->s.work_mem_addr) {
> +		dev_err(dev, "fdif buffer allocation(%d) failed\n",
> +				order);
> +		ret = -ENOMEM;
> +		goto err_mem;
> +	}
> +	return 0;
> +
> +err_mem:
> +	free_buffer(fdif);
> +err_out:
> +	return ret;
> +}
> +
> +static int fdif_probe(struct platform_device *pdev)
> +{
> +	struct device	*dev = &pdev->dev;
> +	struct fdif *fdif;
> +	struct resource *res;
> +	int ret;
> +
> +	fdif = kzalloc(sizeof(*fdif), GFP_KERNEL);
> +	if (!fdif) {
> +		dev_err(dev, "Memory allocation failed\n");
> +		ret = -ENOMEM;
> +		goto end_probe;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(dev, "fdif get resource failed\n");
> +		ret = -ENODEV;
> +		goto err_iomap;
> +	}
> +
> +	fdif->base = ioremap(res->start, resource_size(res));
> +	if (!fdif->base) {
> +		dev_err(dev, "fdif ioremap failed\n");
> +		ret = -ENOMEM;
> +		goto err_iomap;
> +	}
> +
> +	fdif->irq = platform_get_irq(pdev, 0);
> +	if (fdif->irq < 0) {
> +		dev_err(dev, "fdif get irq failed\n");
> +		ret = -ENODEV;
> +		goto err_get_irq;
> +	}
> +
> +	ret = request_irq(fdif->irq, handle_detection, 0, "fdif", fdif);
> +	if (ret)
> +		goto err_get_irq;
> +
> +	init_waitqueue_head(&fdif->wait);
> +	mutex_init(&fdif->mutex);
> +
> +	pm_suspend_ignore_children(dev, true);
> +	fdif->dev = device_create(fdif_class, dev,
> +			MKDEV(FDIF_MAJOR, 0),
> +			NULL, "fdif");
> +	if (!fdif->dev) {
> +		ret = -ENOMEM;
> +		goto err_device_create;
> +	}
> +
> +	fdif->pdev = pdev;
> +	platform_set_drvdata(pdev, fdif);
> +
> +	pm_runtime_get_sync(dev);
> +	dev_info(dev, "fdif version=%8x hwinfo=%08x\n",
> +			fdif_readl(fdif->base, FDIF_REVISION),
> +			fdif_readl(fdif->base, FDIF_HWINFO));
> +	pm_runtime_put(dev);
> +
> +	g_fdif = fdif;
> +	return 0;
> +
> +err_device_create:
> +	free_irq(fdif->irq, fdif);
> +err_get_irq:
> +	iounmap(fdif->base);
> +err_iomap:
> +	kfree(fdif);
> +end_probe:
> +	return ret;
> +}
> +
> +static int fdif_remove(struct platform_device *pdev)
> +{
> +	struct fdif *fdif = platform_get_drvdata(pdev);
> +
> +	device_destroy(fdif_class, MKDEV(FDIF_MAJOR, 0));
> +	free_irq(fdif->irq, fdif);
> +	iounmap(fdif->base);
> +	kfree(fdif);
> +	return 0;
> +}
> +
> +static int fdif_suspend(struct platform_device *pdev, pm_message_t msg)
> +{
> +	return 0;
> +}
> +
> +static int fdif_resume(struct platform_device *pdev)
> +{
> +	return 0;
> +}
> +
> +static struct platform_device_id fdif_device_ids[] = {
> +	{.name = "fdif"},
> +	{},
> +};
> +
> +struct platform_driver fdif_driver = {
> +	.probe =	fdif_probe,
> +	.remove =	fdif_remove,
> +	.suspend =	fdif_suspend,
> +	.resume =	fdif_resume,
> +	.driver = {
> +		.name  =	"fdif",
> +		.owner =	THIS_MODULE,
> +	},
> +	.id_table = 	fdif_device_ids,
> +};
> +
> +static void install_default_setting(struct fdif *fdif)
> +{
> +	fdif->s.min_face_size	= FACE_SIZE_25_PIXELS;
> +	fdif->s.face_dir	= FACE_DIR_UP;
> +	fdif->s.startx		= 0;
> +	fdif->s.starty		= 0;
> +	fdif->s.sizex		= 0x140;
> +	fdif->s.sizey		= 0xf0;
> +	fdif->s.lhit		= 0x5;
> +}
> +
> +static void commit_image_setting(struct fdif *fdif)
> +{
> +	unsigned long conf;
> +	struct device *dev = &fdif->pdev->dev;
> +
> +	fdif->pict_dma = dma_map_single(dev, fdif->s.pict_addr,
> +		                PICT_SIZE_X*PICT_SIZE_Y,
> +				DMA_TO_DEVICE);
> +	fdif_writel(fdif->base, FDIF_PICADDR, fdif->pict_dma);
> +
> +	conf = (fdif->s.min_face_size & 0x3) ||
> +		((fdif->s.face_dir & 0x3) << 2);
> +	fdif_writel(fdif->base, FD_DCOND, conf);
> +
> +	fdif_writel(fdif->base, FD_STARTX, fdif->s.startx);
> +	fdif_writel(fdif->base, FD_STARTY, fdif->s.starty);
> +	fdif_writel(fdif->base, FD_SIZEX, fdif->s.sizex);
> +	fdif_writel(fdif->base, FD_SIZEY, fdif->s.sizey);
> +	fdif_writel(fdif->base, FD_LHIT, fdif->s.lhit);
> +}
> +
> +static void start_detect(struct fdif *fdif)
> +{
> +	unsigned long conf;
> +
> +	dump_fdif_setting(fdif, __func__);
> +	dump_fdif_regs(fdif, __func__);
> +
> +	fdif->face_cnt = -1;
> +	commit_image_setting(fdif);
> +
> +	/*enable finish irq*/
> +	conf = FINISH_IRQ;
> +	fdif_writel(fdif->base, FDIF_IRQENABLE_SET_j, conf);
> +
> +	/*set RUN flag*/
> +	conf = CTRL_RUN;
> +	fdif_writel(fdif->base, FD_CTRL, conf);
> +}
> +
> +static void stop_detect(struct fdif *fdif)
> +{
> +	unsigned long conf;
> +	struct device *dev = &fdif->pdev->dev;
> +
> +	dma_unmap_single(dev, fdif->pict_dma,
> +				PICT_SIZE_X*PICT_SIZE_Y,
> +				DMA_TO_DEVICE);
> +	/*disable finish irq*/
> +	conf = FINISH_IRQ;
> +	fdif_writel(fdif->base, FDIF_IRQENABLE_CLR_j, conf);
> +
> +	/*mark FINISH flag*/
> +	conf = CTRL_FINISH;
> +	fdif_writel(fdif->base, FD_CTRL, conf);
> +}
> +
> +/*softreset fdif*/
> +static int softreset_fdif(struct fdif *fdif)
> +{
> +	unsigned long conf;
> +	int to = 0;
> +
> +	conf = fdif_readl(fdif->base, FDIF_SYSCONFIG);
> +	conf |= SOFTRESET;
> +	fdif_writel(fdif->base, FDIF_SYSCONFIG, conf);
> +
> +	while ((conf & SOFTRESET) && to++ < 2000) {
> +		conf = fdif_readl(fdif->base, FDIF_SYSCONFIG);
> +		udelay(2);
> +	}
> +
> +	if (to == 2000)
> +		printk(KERN_ERR "%s: reset failed\n", __func__);
> +
> +	return to == 2000;
> +}
> +
> +static int read_faces(struct fdif *fdif)
> +{
> +	int cnt;
> +	int idx = 0;
> +
> +	cnt = fdif_readl(fdif->base, FD_DNUM) & 0x3f;
> +
> +	fdif->face_cnt = cnt;
> +	fdif->read_idx = 0;
> +
> +	while(idx < cnt) {
> +		struct fdif_result *fr = &fdif->faces[idx];
> +
> +		fr->centerx = fdif_readl(fdif->base,
> +				FD_CENTERX_i + idx * 0x10) & 0x1ff;
> +		fr->centery = fdif_readl(fdif->base,
> +				FD_CENTERY_i + idx * 0x10) & 0xff;
> +		fr->angle = fdif_readl(fdif->base,
> +				FD_ANGLE_i + idx * 0x10) & 0x1ff;
> +		fr->size = fdif_readl(fdif->base,
> +				FD_CONFSIZE_i + idx * 0x10);
> +		fr->confidence = (fr->size >> 8) & 0xf;
> +		fr->size = fr->size & 0xff;
> +
> +		idx++;
> +	}
> +
> +	stop_detect(fdif);
> +	dump_fdif_results(fdif, __func__);
> +	wake_up(&fdif->wait);
> +
> +	return fdif->face_cnt;
> +}
> +
> +static irqreturn_t handle_detection(int irq, void *__fdif)
> +{
> +	unsigned long irqsts;
> +	struct fdif *fdif = __fdif;
> +
> +	dump_fdif_regs(fdif, __func__);
> +
> +	/*clear irq status*/
> +	irqsts = fdif_readl(fdif->base, FDIF_IRQSTATUS_j);
> +	fdif_writel(fdif->base, FDIF_IRQSTATUS_j, irqsts);
> +
> +	if (irqsts & FINISH_IRQ) {
> +		read_faces(fdif);
> +	} else if (irqsts & ERR_IRQ) {
> +		dev_err(&fdif->pdev->dev, "err irq!");
> +		softreset_fdif(fdif);
> +	} else {
> +		dev_err(&fdif->pdev->dev, "spurious irq!");
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void fdif_global_init(struct fdif *fdif)
> +{
> +	unsigned long conf;
> +	struct device *dev = &fdif->pdev->dev;
> +
> +	/*softreset fdif*/
> +	softreset_fdif(fdif);
> +
> +	/*set max tags*/
> +	conf = fdif_readl(fdif->base, FDIF_CTRL);
> +	conf &= ~0x1e;
> +	conf |= (CTRL_MAX_TAGS << 1);
> +	fdif_writel(fdif->base, FDIF_CTRL, conf);
> +
> +	/*enable error irq*/
> +	conf = ERR_IRQ;
> +	fdif_writel(fdif->base, FDIF_IRQENABLE_SET_j, conf);
> +
> +	fdif->work_dma = dma_map_single(dev,
> +				fdif->s.work_mem_addr,
> +		                WORK_MEM_SIZE,
> +				DMA_TO_DEVICE);
> +	fdif_writel(fdif->base, FDIF_WKADDR, fdif->work_dma);
> +}
> +
> +static void fdif_global_deinit(struct fdif *fdif)
> +{
> +	unsigned long conf;
> +	struct device *dev = &fdif->pdev->dev;
> +
> +	/*enable error irq*/
> +	conf = ERR_IRQ;
> +	fdif_writel(fdif->base, FDIF_IRQENABLE_CLR_j, conf);
> +
> +	dma_unmap_single(dev, fdif->work_dma,
> +			WORK_MEM_SIZE, DMA_TO_DEVICE);
> +}
> +
> +/*
> + * file operations
> + */
> +static int fdif_open(struct inode *inode, struct file *file)
> +{
> +	struct fdif *fdif = g_fdif;
> +	int ret = 0;
> +
> +	if (iminor(inode) || !fdif) {
> +		printk("fdif: device is not correct!\n");
> +		return -ENODEV;
> +	}
> +
> +	mutex_lock(&fdif->mutex);
> +
> +	if (!fdif->open_count++) {
> +
> +		ret = allocate_buffer(fdif);
> +		if (ret)
> +			goto err_mem;
> +
> +		install_default_setting(fdif);
> +
> +		pm_runtime_get_sync(&fdif->pdev->dev);
> +		fdif_global_init(fdif);
> +	}
> +
> +	file->private_data = fdif;
> +	goto err_out;
> +
> +err_mem:
> +	free_buffer(fdif);
> +err_out:
> +	mutex_unlock(&fdif->mutex);
> +
> +	return ret;
> +}
> +
> +static int fdif_release(struct inode *inode, struct file *file)
> +{
> +	struct fdif *fdif = file->private_data;
> +
> +	if (!fdif)
> +		return -ENODEV;
> +
> +	mutex_lock(&fdif->mutex);
> +
> +	if (!--fdif->open_count) {
> +		stop_detect(fdif);
> +		fdif_global_deinit(fdif);
> +		pm_runtime_put(&fdif->pdev->dev);
> +		free_buffer(fdif);
> +	}
> +
> +	mutex_unlock(&fdif->mutex);
> +	return 0;
> +}
> +
> +static ssize_t fdif_read(struct file *file, char __user *buf, size_t nbytes,
> +			   loff_t *ppos)
> +{
> +	struct fdif *fdif = file->private_data;
> +	ssize_t ret = 0;
> +	unsigned len;
> +	loff_t pos = *ppos;
> +	int size;
> +
> +	/*not support unaligned read*/
> +	if ((long)pos % sizeof(struct fdif_result))
> +		return -EFAULT;
> +
> +	/*wait for completation of current detection*/
> +	wait_event_interruptible(fdif->wait, fdif->face_cnt != -1);
> +
> +	mutex_lock(&fdif->mutex);
> +	if (fdif->face_cnt == -1) {
> +		ret = -ERESTARTSYS;
> +		goto err;
> +	}
> +
> +	if (fdif->read_idx < 0) {
> +		ret = -EFAULT;
> +		goto err;
> +	}
> +
> +	if (fdif->face_cnt <= fdif->read_idx)
> +		goto err;
> +
> +	size = (fdif->face_cnt - fdif->read_idx) *
> +		sizeof(struct fdif_result);
> +	if (pos < size) {
> +		len = size - pos;
> +		if (len > nbytes)
> +			len = nbytes;
> +
> +		len -= len % sizeof(struct fdif_result);
> +
> +		if (copy_to_user(buf, &fdif->faces[fdif->read_idx], len)) {
> +			ret = -EFAULT;
> +			goto err;
> +		}
> +
> +		fdif->read_idx += len / sizeof(struct fdif_result);
> +		*ppos += len;
> +		ret += len;
> +	}
> +err:
> +	mutex_unlock(&fdif->mutex);
> +	return ret;
> +}
> +
> +#ifdef DEBUG
> +static void print_cmd(int cmd, void __user *p)
> +{
> +	char buf[64];
> +	int arg, l = 63;
> +
> +	switch (cmd) {
> +	case FDIF_START:
> +		strcpy(buf, "START");
> +		break;
> +	case FDIF_GET_FACE_CNT:
> +		strcpy(buf, "GET_CNT");
> +		break;
> +	case FDIF_STOP:
> +		strcpy(buf, "STOP");
> +		break;
> +	case FDIF_RESET:
> +		strcpy(buf, "RESET");
> +		break;
> +	case FDIF_GET_SETTING:
> +		strcpy(buf, "GET_SETTING");
> +		break;
> +	case FDIF_SET_MIN_FACE_SIZE:
> +		l = sprintf(buf, "SET_MIN_FACE_SIZE: %d",
> +			(get_user(arg,(unsigned int __user *)p) ? : arg));
> +		break;
> +	case FDIF_SET_STARTXY:
> +		l = sprintf(buf, "SET_STARTXY: %d",
> +			(get_user(arg,(unsigned int __user *)p) ? : arg));
> +		break;
> +	case FDIF_SET_SIZEXY:
> +		l = sprintf(buf, "SET_SIZEXY: %d",
> +			(get_user(arg,(unsigned int __user *)p) ? : arg));
> +		break;
> +	case FDIF_SET_FACE_DIR:
> +		l = sprintf(buf, "SET_FACE_DIR: %d",
> +			(get_user(arg,(unsigned int __user *)p) ? : arg));
> +		break;
> +	case FDIF_SET_LHIT:
> +		l = sprintf(buf, "SET_LHIT: %d",
> +			(get_user(arg,(unsigned int __user *)p) ? : arg));
> +		break;
> +	default:
> +		strcpy(buf, "????");
> +	}
> +
> +	buf[l] = '\0';
> +
> +	printk("%s: %s\n", __func__, buf);
> +}
> +#else
> +static inline void print_cmd(int cmd, void __user *p)
> +{
> +}
> +#endif
> +
> +static long fdif_ioctl(struct file *file, unsigned int cmd,
> +			unsigned long arg)
> +{
> +	struct fdif *fdif = file->private_data;
> +	int ret = 0;
> +	int val;
> +
> +	if (!(file->f_mode & FMODE_WRITE))
> +		return -EPERM;
> +
> +	print_cmd(cmd, (void __user *)arg);
> +
> +	mutex_lock(&fdif->mutex);
> +	switch (cmd) {
> +	case FDIF_START:
> +		start_detect(fdif);
> +		break;
> +	case FDIF_GET_FACE_CNT:
> +		if (put_user(fdif->face_cnt, (u32 __user *)arg))
> +			ret = -EFAULT;
> +		break;
> +	case FDIF_STOP:
> +		stop_detect(fdif);
> +		break;
> +	case FDIF_RESET:
> +		softreset_fdif(fdif);
> +		break;
> +	case FDIF_GET_SETTING:
> +		ret = (copy_to_user((void __user *)arg, &fdif->s,
> +				sizeof(struct fdif_setting)) ?
> +				-EFAULT : 0);
> +		break;
> +	case FDIF_SET_MIN_FACE_SIZE:
> +		ret = get_user(val, (int __user *)arg) ? -EFAULT : 0;
> +		if (!ret)
> +			fdif->s.min_face_size = val;
> +		break;
> +	case FDIF_SET_STARTXY:
> +		ret = get_user(val, (int __user *)arg) ? -EFAULT : 0;
> +		if (!ret) {
> +			fdif->s.startx = val & 0xffff;
> +			fdif->s.starty = (val >> 16) & 0xffff;
> +		}
> +		break;
> +	case FDIF_SET_SIZEXY:
> +		ret = get_user(val, (int __user *)arg) ? -EFAULT : 0;
> +		if (!ret) {
> +			fdif->s.sizex = val & 0xffff;
> +			fdif->s.sizey = (val >> 16) & 0xffff;
> +		}
> +		break;
> +	case FDIF_SET_FACE_DIR:
> +		ret = get_user(val, (int __user *)arg) ? -EFAULT : 0;
> +		if (!ret)
> +			fdif->s.face_dir = val;
> +		break;
> +	case FDIF_SET_LHIT:
> +		ret = get_user(val, (int __user *)arg) ? -EFAULT : 0;
> +		if (!ret)
> +			fdif->s.lhit = val;
> +		break;
> +	default:
> +		ret = -1;
> +	}
> +	mutex_unlock(&fdif->mutex);
> +
> +	return ret;
> +}
> +
> +static int fdif_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct fdif *fdif = file->private_data;
> +	unsigned long off;
> +	unsigned long start;
> +	u32 len;
> +
> +	if (!fdif)
> +		return -ENODEV;
> +
> +	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
> +		return -EINVAL;
> +
> +	off = vma->vm_pgoff << PAGE_SHIFT;
> +
> +	mutex_lock(&fdif->mutex);
> +	start = virt_to_phys(fdif->s.pict_addr);
> +	len = PAGE_ALIGN((start & ~PAGE_MASK) +
> +			PICT_SIZE_X * PICT_SIZE_Y);
> +	if (off >= len) {
> +		mutex_unlock(&fdif->mutex);
> +		return -EINVAL;
> +	}
> +	mutex_unlock(&fdif->mutex);
> +
> +	start &= PAGE_MASK;
> +	if ((vma->vm_end - vma->vm_start + off) > len)
> +		return -EINVAL;
> +	off += start;
> +
> +	vma->vm_pgoff = off >> PAGE_SHIFT;
> +	vma->vm_flags |= VM_IO | VM_RESERVED;
> +	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
> +
> +	if (remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
> +			     vma->vm_end - vma->vm_start, vma->vm_page_prot))
> +		return -EAGAIN;
> +
> +	return 0;
> +}
> +
> +static unsigned int fdif_poll(struct file *file,
> +				struct poll_table_struct *wait)
> +{
> +	struct fdif *fdif = file->private_data;
> +	unsigned int mask = 0;
> +
> +	poll_wait(file, &fdif->wait, wait);
> +	if (file->f_mode & FMODE_WRITE && fdif->face_cnt != -1)
> +		mask |= POLLOUT | POLLWRNORM;
> +	return mask;
> +}
> +
> +const struct file_operations fdif_file_operations = {
> +	.owner =	  THIS_MODULE,
> +	.read =		  fdif_read,
> +	.poll =		  fdif_poll,
> +	.unlocked_ioctl = fdif_ioctl,
> +	.mmap =		  fdif_mmap,
> +	.open =		  fdif_open,
> +	.release =	  fdif_release,
> +};
> +
> +static int __init fdif_init(void)
> +{
> +	int retval;
> +
> +	fdif_class = class_create(THIS_MODULE, "fdif");
> +	if (IS_ERR(fdif_class)) {
> +		printk(KERN_ERR "Unable to creat fdif class\n");
> +		retval = -ENOMEM;
> +		goto out;
> +	}
> +
> +	retval = platform_driver_register(&fdif_driver);
> +	if (retval) {
> +		printk(KERN_ERR "Unable to register fdif driver\n");
> +		goto err_driver_register;
> +	}
> +
> +	if ((retval = register_chrdev(FDIF_MAJOR, "fdif",
> +				&fdif_file_operations))) {
> +		printk(KERN_ERR "Unable to get fdif device major %d\n",
> +		       FDIF_MAJOR);
> +		goto err_chr;
> +	}
> +	return 0;
> +
> +err_chr:
> +	platform_driver_unregister(&fdif_driver);
> +err_driver_register:
> +	class_destroy(fdif_class);
> +out:
> +	return retval;
> +}
> +
> +static void fdif_cleanup(void)
> +{
> +	unregister_chrdev(FDIF_MAJOR, "fdif");
> +	platform_driver_unregister(&fdif_driver);
> +	class_destroy(fdif_class);
> +}
> +
> +module_init(fdif_init);
> +module_exit(fdif_cleanup);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:fdif");
> +MODULE_AUTHOR("Ming Lei <ming.lei@canonical.com>");
> diff --git a/include/linux/fdif.h b/include/linux/fdif.h
> new file mode 100644
> index 0000000..c0494c2
> --- /dev/null
> +++ b/include/linux/fdif.h
> @@ -0,0 +1,67 @@
> +/*****************************************************************************/
> +
> +/*
> + *	fdif.h	---	face detection header file
> + *
> + *	Copyright (C) 2011
> + *          Ming Lei (ming.lei@canonical.com)
> + *
> + *	This program is free software; you can redistribute it and/or modify
> + *	it under the terms of the GNU General Public License as published by
> + *	the Free Software Foundation; either version 2 of the License, or
> + *	(at your option) any later version.
> + *
> + *	This program is distributed in the hope that it will be useful,
> + *	but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *	GNU General Public License for more details.
> + *
> + *	You should have received a copy of the GNU General Public License
> + *	along with this program; if not, write to the Free Software
> + *	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + */
> +
> +/*****************************************************************************/
> +
> +#ifndef _LINUX_FDIF_H
> +#define _LINUX_FDIF_H
> +
> +#include <linux/types.h>
> +#include <linux/magic.h>
> +
> +#define MAX_FACE_COUNT  35
> +#define PICT_SIZE_X     320
> +#define PICT_SIZE_Y     240
> +
> +struct fdif_setting {
> +	void			*pict_addr;
> +	void			*work_mem_addr;
> +	int 			min_face_size;
> +	int			face_dir;
> +	int			startx, starty;
> +	int			sizex, sizey;
> +	int			lhit;
> +};
> +
> +struct fdif_result {
> +	unsigned short centerx;
> +	unsigned short centery;
> +	unsigned short angle;
> +	unsigned short size;
> +	unsigned short confidence;
> +};
> +
> +#define FDIF_START		_IOR('F', 0x24, unsigned int)
> +#define FDIF_GET_FACE_CNT	_IOR('F', 0x25, unsigned int)
> +#define FDIF_STOP		_IOR('F', 0x26, unsigned int)
> +#define FDIF_RESET		_IOR('F', 0x27, unsigned int)
> +
> +#define FDIF_GET_SETTING	_IOR('F', 0x28, struct fdif_setting)
> +#define FDIF_SET_MIN_FACE_SIZE	_IOR('F', 0x2a, unsigned int)
> +#define FDIF_SET_STARTXY	_IOR('F', 0x2b, unsigned int)
> +#define FDIF_SET_SIZEXY		_IOR('F', 0x2c, unsigned int)
> +#define FDIF_SET_FACE_DIR	_IOR('F', 0x2d, unsigned int)
> +#define FDIF_SET_LHIT		_IOR('F', 0x2e, unsigned int)
> +
> +#endif /* _LINUX_FDIF_H */
> diff --git a/include/linux/major.h b/include/linux/major.h
> index 6a8ca98..57d1c98 100644
> --- a/include/linux/major.h
> +++ b/include/linux/major.h
> @@ -174,4 +174,5 @@
>  #define BLOCK_EXT_MAJOR		259
>  #define SCSI_OSD_MAJOR		260	/* open-osd's OSD scsi device */
>  
> +#define FDIF_MAJOR		261
>  #endif
