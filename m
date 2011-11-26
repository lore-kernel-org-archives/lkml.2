Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1KZLLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 06:11:50 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48599 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174Ab1KZLLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 06:11:47 -0500
Date: Sat, 26 Nov 2011 11:12:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tom.leiming@gmail.com
Cc: tony@atomide.com, greg@kroah.com, arnd@arndb.de,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH 3/3] drivers/misc: introduce face detection module
 driver(fdif)
Message-ID: <20111126111247.43cb5d35@lxorguk.ukuu.org.uk>
In-Reply-To: <1322281904-14526-4-git-send-email-tom.leiming@gmail.com>
References: <1322281904-14526-1-git-send-email-tom.leiming@gmail.com>
	<1322281904-14526-4-git-send-email-tom.leiming@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Nov 2011 12:31:44 +0800
tom.leiming@gmail.com wrote:

> From: Ming Lei <ming.lei@canonical.com>
> 
> One face detection IP[1] is integared inside OMAP4 SoC, so
> introduce this driver to make face detection function work
> on OMAP4 SoC.
> 
> This driver is platform independent, so in theory can
> be used to drive same IP module on other platforms.
> 
> [1], ch9 of OMAP4 TRM
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>

If you are submitting it then it ought to have your sign off too. This
looks hardly ready for submission however.

> +config FDIF
> +	tristate "Face Detection module"
> +	help
> +	  The FDIF is a face detection module, which can be integrated into
> +	  SoCs to detect the location of human beings' face in one image. At
> +	  least now, TI OMAP4 has the module inside.

So we have a completelt device specific API for what is becoming a more
general feature and on some hardware is tied to camera and the like. This
seems wrong

IMHO this should be part of video4linux because that'll make the
integrated stuff work sanely and for your cases it still provided the
right kind of mmap and format interfaces you need.

Detailed review below but basically this isn't ready to merge and it
shouldn't be merged from an interface point of view. Please work out how
to integrate the face detection into video4linux2 with the V4L folks.

> +#define FDIF_DEV	MKDEV(FDIF_MAJOR, 0)
> +#define FDIF_MAX_MINORS	8

No custom majors please.


> +static irqreturn_t handle_detection(int irq, void *__fdif);

Minor thing but you could just order the users right ...

> +/*only support one fdif device now*/
> +static struct fdif	*g_fdif;

So why 8 minors ?


> +	fdif->irq = platform_get_irq(pdev, 0);
> +	if (fdif->irq < 0) {

0 would also be a fail here surely - you can't support polling

> +	dev_info(dev, "fdif version=%8x hwinfo=%08x\n",
> +			fdif_readl(fdif->base, FDIF_REVISION),
> +			fdif_readl(fdif->base, FDIF_HWINFO));

Should be debug for productioncode

> +	device_destroy(fdif_class, MKDEV(FDIF_MAJOR, 0));


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

dev_err

There are several that want fixing


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

Pity the rest of the code uses a mutex for locking and the IRQ code
doesn't bother with locking at all. That doesn't look safe to me.

> +	} else if (irqsts & ERR_IRQ) {
> +		dev_err(&fdif->pdev->dev, "err irq!");

Not exactly user informative.

> +		softreset_fdif(fdif);
> +	} else {

This is only true if the IRQ is shared. Also the core IRQ code handles
spurious IRQ jams, and thirdly you shouldn't return HANDLED if you didn't
handle it.

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

So if its misconfigured or not found it would be a good idea to allow
users to spew stuff in the logs. Just return the error code.

The !fdif case here is meaningless. Either it matters in which case your
open isn't properly locked versus a remove, or it doesn't, in which case
your test is bogus.

> +static int fdif_release(struct inode *inode, struct file *file)
> +{
> +	struct fdif *fdif = file->private_data;
> +
> +	if (!fdif)
> +		return -ENODEV;

What if I unplugged the device while it was in use... ? What is your
locking model for all this.

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

Wrong error code - EFAULT is a bad address in userspace really, and it'll
confuse folks if they get other stuff.

> +	if (fdif->read_idx < 0) {
> +		ret = -EFAULT;
> +		goto err;

Ditto

> +		if (copy_to_user(buf, &fdif->faces[fdif->read_idx], len)) {
> +			ret = -EFAULT;
> +			goto err;
> +		}

If you copy multiple objects and at least one is consumed you should be
returning the bytes succesfully copied, and EFAULT only if none were.


> +static long fdif_ioctl(struct file *file, unsigned int cmd,
> +			unsigned long arg)
> +{
> +	struct fdif *fdif = file->private_data;
> +	int ret = 0;
> +	int val;
> +
> +	if (!(file->f_mode & FMODE_WRITE))
> +		return -EPERM;

This could do with explanation as it seems a slightly odd permissions
arrangement.

> +	case FDIF_STOP:
> +		stop_detect(fdif);

If I call this twice in a row you unmapped existing unmapped memory. No
consideration appears to have been made of the most basic misbehaviour by
user space applications. This is a general problem and some of these look
exploitable.

> +	case FDIF_SET_MIN_FACE_SIZE:
> +		ret = get_user(val, (int __user *)arg) ? -EFAULT : 0;
> +		if (!ret)
> +			fdif->s.min_face_size = val;

No range checks needed ?

> +		break;
> +	case FDIF_SET_STARTXY:
> +		ret = get_user(val, (int __user *)arg) ? -EFAULT : 0;
> +		if (!ret) {
> +			fdif->s.startx = val & 0xffff;
> +			fdif->s.starty = (val >> 16) & 0xffff;
> +		}

Limits you to 16bit co-ordinates - hardly future proof

> +static int fdif_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct fdif *fdif = file->private_data;
> +	unsigned long off;
> +	unsigned long start;
> +	u32 len;
> +
> +	if (!fdif)
> +		return -ENODEV;

Same commentd as everywhere else


> +static unsigned int fdif_poll(struct file *file,
> +				struct poll_table_struct *wait)
> +{
> +	struct fdif *fdif = file->private_data;
> +	unsigned int mask = 0;
> +
> +	poll_wait(file, &fdif->wait, wait);
> +	if (file->f_mode & FMODE_WRITE && fdif->face_cnt != -1)

What locks fdif->face_cnt here ?


> +static int __init fdif_init(void)
> +{
> +	int retval;
> +
> +	fdif_class = class_create(THIS_MODULE, "fdif");

Please don't create new classes

> +	if (IS_ERR(fdif_class)) {
> +		printk(KERN_ERR "Unable to creat fdif class\n");

And use pr_err

> +	retval = platform_driver_register(&fdif_driver);
> +	if (retval) {
> +		printk(KERN_ERR "Unable to register fdif driver\n");

Ditto

> +		goto err_driver_register;
> +	}
> +
> +	if ((retval = register_chrdev(FDIF_MAJOR, "fdif",
> +				&fdif_file_operations))) {
> +		printk(KERN_ERR "Unable to get fdif device major %d\n",
> +		       FDIF_MAJOR);

And please don't make up major numbers. They are allocated via lanana and
you don't need one you can use a generic one - although if you slot this
within V4L2 that problem also goes away


> +struct fdif_setting {
> +	void			*pict_addr;
> +	void			*work_mem_addr;
> +	int 			min_face_size;
> +	int			face_dir;
> +	int			startx, starty;
> +	int			sizex, sizey;
> +	int			lhit;
> +};

Changes size between 32 and 64bits. Please make all ioctl sizing stable
and 32/64bit safe.

> +struct fdif_result {
> +	unsigned short centerx;
> +	unsigned short centery;
> +	unsigned short angle;
> +	unsigned short size;
> +	unsigned short confidence;
> +};

So we have x and y as int above, and unsigned short here ??

> +#define FDIF_MAJOR		261

NAK

