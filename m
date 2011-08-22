Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1HVHiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 03:38:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51955 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1HVHiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 03:38:02 -0400
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: david.wagner@free-electrons.com
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Mon, 22 Aug 2011 10:39:47 +0300
In-Reply-To: <1313587042-30846-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1313587042-30846-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1313998793.2644.49.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for the patch, it is quite good I think, but I still have few
comments. I did not review very carefully because of limited amount of
free time.

There are few checkpatch.pl complaints, could you please take a look?

Note, often I give a comment for one place, but there are many other
similar places with the same stuff.

On Wed, 2011-08-17 at 15:17 +0200, david.wagner@free-electrons.com
wrote:
> TODO:
>  * the modules keeps a table of the devices which length is the maximum number
>    of UBI volumes.  There should be a better solution (linked list or, as
>    Christoph Hellwig suggests, a radix tree (idr)).

Wold be nice to do the same change for UBI, BTW :-)

> Here is the v3 of ubiblk implementing ioctls for on-demand creation/removal of
> ubiblk device ; is it what you were thinking of ?

Looks like.

[snip]

> +config MTD_UBI_UBIBLK
> +	tristate "Read-only block transition layer on top of UBI"
> +	help
> +	   Read-only block interface on top of UBI.
> +
> +	   This option adds ubiblk, which creates a read-ony block device from
> +	   UBI volumes.  It makes it possible to use block filesystems on top of
> +	   UBI (and thus, on top of MTDs while avoiding bad blocks).

s/block filesystems/R/O block filesystems/
s/on top of UBI/on top of UBI volumes/
s/and thus, on top of MTDs/and hence, on top of MTD devices/
> +
> +	   ubiblk devices are created by sending appropriate ioctl to the
> +	   ubiblk_ctrl device node.

s/sending/invoking/

[snip]

Would be good to add a section to the UBI Documentation describing
ubiblk by sending a patch against mtd-www:

http://git.infradead.org/mtd-www.git

[snip]

> +/*
> + * Structure representing a ubiblk device, proxying a UBI volume
> + */
> +struct ubiblk_dev {
> +	struct ubi_volume_desc *vol_desc;
> +	struct ubi_volume_info *vol_info;

Since this piece of code is part of drivers/mtd/ubi/, I think that it
makes sense to make it very consistent with the rest of the code. It is
then better to use consistent names for variables of this type: "desc"
and "vi".

> +	int ubi_num;
> +	int vol_id;
> +
> +	/* Block stuff */
> +	struct gendisk *gd;
> +	struct request_queue *rq;
> +	struct task_struct *thread;

Here is one comment I got from hch once which I also saved in the git
history: 6f904ff0e39ea88f81eb77e8dfb4e1238492f0a8

    hch: a convention I tend to use and I've seen in various places
    is to always use _task for the storage of the task_struct pointer,
    and thread everywhere else.  This especially helps with having
    foo_thread for the actual thread and foo_task for a global
    variable keeping the task_struct pointer

Let's follow it and call this field "<something_meaningful>_task", e.g.,
"req_task" (request queue/dispatcher/etc task) ? Keep using "_thread"
for other stuff.

You can also change UBI correspondingly.

> +	/* Protects the access to the UBI volume */
> +	struct mutex lock;

Lets call all locks <something_meaningful>_lock, e.g., volumes_lock or
vol_lock.

> +
> +	/* Avoids concurrent accesses to the request queue */
> +	spinlock_t queue_lock;
> +};

And for consistency, it is better to use kerneldoc comments, like the
rest of UBI, but if you hate them, I will not insist.

[snip]

> +	mutex_lock(&dev->lock);
> +	set_capacity(dev->gd,
> +		     (vol_info->size * vol_info->usable_leb_size) >> 9);
> +	mutex_unlock(&dev->lock);
> +	pr_debug("Resized ubiblk%d_%d to %d LEBs\n", vol_info->ubi_num,
> +		 vol_info->vol_id, vol_info->size);

If you find a way to properly use dev_dbg() instead of pr_debug(), your
messages will be automatically prefixed with "ubiblk%d_%d", and your
messages will be shorter - so less code, smaller binary size. See below
my other comment.

[snip]

> +static int ubiblk_notify(struct notifier_block *nb,
> +			 unsigned long notification_type, void *ns_ptr)
> +{
> +	struct ubi_notification *nt = ns_ptr;
> +
> +	switch (notification_type) {
> +	case UBI_VOLUME_ADDED:
> +		break;
> +	case UBI_VOLUME_REMOVED:
> +		ubiblk_remove(&nt->vi);
> +		break;
> +	case UBI_VOLUME_RESIZED:
> +		ubiblk_resized(&nt->vi);
> +		break;
> +	case UBI_VOLUME_UPDATED:
> +		break;
> +	case UBI_VOLUME_RENAMED:
> +		break;
> +	default:
> +		break;

Please, remove cases which do nothing and let them end up in "default:".

[snip]

> +static long ubiblk_ctrl_ioctl(struct file *file, unsigned int cmd,
> +			      unsigned long arg)
> +{
> +	int err = 0;
> +	void __user *argp = (void __user *)arg;
> +
> +	struct ubi_volume_desc *vol_desc;
> +	struct ubi_volume_info vol_info;
> +	struct ubiblk_ctrl_req req;
> +
> +	if (!capable(CAP_SYS_RESOURCE))
> +		return -EPERM;
> +
> +	err = copy_from_user(&req, argp, sizeof(struct ubiblk_ctrl_req));
> +	if (err)
> +		return -EFAULT;
> +
> +	if (req.ubi_num < 0 || req.vol_id < 0)
> +		return -EINVAL;
> +
> +	vol_desc = ubi_open_volume(req.ubi_num, req.vol_id, UBI_READONLY);
> +	if (IS_ERR(vol_desc)) {
> +		pr_err("Opening volume %d on device %d failed\n",
> +		       req.vol_id, req.ubi_num);

Because dynamic_debug usually adds prefixes to messages, or pr_fmt is
usually used to add a prefix, I suggest to make all pr_* / dev_*
messages to start with small letter.

Also, should we use dev_* macros instead? I have always thought that
pr_* is used only if you do not have "struct device", no? But you do
have it, AFAICS:

1. For messages which are not related to a specific ubiblk device,
ubi_blk_ctrl_dev.this_device (may be ubi_blk_ctrk_dev then can be
shortened to ctrl_dev?)

2. For messages that are about a specific device - not exactly sure, but
I bet there is a struct device for your ubiblk_%d_%d device. Probably
disk_to_dev(<struct ubiblk_dev>->gd)

Try to find this out and test. We should not use pr_* unless there is a
good reason why dev_* does not work.

> +		return PTR_ERR(vol_desc);
> +	}
> +
> +	ubi_get_volume_info(vol_desc, &vol_info);
> +
> +	switch (cmd) {
> +	case UBIBLK_IOCADD:
> +		pr_info("Creating a ubiblk device proxing ubi%d:%d\n",
> +			req.ubi_num, req.vol_id);
> +		ubiblk_create(&vol_info);

Please, return the error code!

> +		break;
> +	case UBIBLK_IOCDEL:
> +		pr_info("Removing ubiblk from ubi%d:%d\n",
> +			req.ubi_num, req.vol_id);
> +		ubiblk_remove(&vol_info);

And here!

[snip]

> +static int __init ubi_ubiblk_init(void)
> +{
> +	int ret = 0;
> +
> +	pr_info("UBIBLK starting\n");

Please, kill this message, it looks more like tracing, not info. I
suggest you to add one single message at the end like "blah blah
initialized, major number %d".

> +
> +	ret = register_blkdev(0, "ubiblk");
> +	if (ret <= 0) {
> +		pr_err("UBIBLK: could not register_blkdev\n");
> +		return -ENODEV;
> +	}
> +	ubiblk_major = ret;
> +	pr_info("UBIBLK: device's major: %d\n", ubiblk_major);

Please, kill this message as well, or turn it into pr_debug()/dev_dbg().

Talking about messages:

1. Remove this UBIBLK: prefix from all of them. Rationale: if dynamic
debug is enabled, the dynamic debug infrastructure will add it for you,
see "Documentation/dynamic-debug-howto.txt". Otherwise you can always
define "pr_fmt" and add the prefix you wish.

[snip]

> +static void __exit ubi_ubiblk_exit(void)
> +{
> +	int i;
> +
> +	pr_info("UBIBLK: going to exit\n");

Please, kill these. Again, if you really feel like it - add one single
message like "blah exited" at the end.

[snip]

> +/* Structure to be passed to UBIBLK_IOCADD or IOCDEL ioctl */
> +struct ubiblk_ctrl_req {
> +	__s32 ubi_num;
> +	__s32 vol_id;
> +};
> +
> +/* ioctl commands of the UBI control character device */

Please, document here that you share "O" with UBI. Also document this in
UBI in a separate patch.

> +
> +#define UBIBLK_CTRL_IOC_MAGIC 'O'
> +
> +/* Create a ubiblk device from a UBI volume */
> +#define UBIBLK_IOCADD _IOW(UBIBLK_CTRL_IOC_MAGIC, 0x10, struct ubiblk_ctrl_req)
> +/* Delete a ubiblk device */
> +#define UBIBLK_IOCDEL _IOW(UBIBLK_CTRL_IOC_MAGIC, 0x11, struct ubiblk_ctrl_req)
> +
> +#endif


-- 
Best Regards,
Artem Bityutskiy

