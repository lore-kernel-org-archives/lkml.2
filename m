Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1CJNxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 08:53:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54674 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1CJNxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 08:53:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Thu, 10 Mar 2011 14:52:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        hthebaud@insidefr.com, Jari Vanhala <ext-jari.vanhala@nokia.com>,
        Matti Aaltonen <matti.j.aaltonen@nokia.com>
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
In-Reply-To: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101452.54862.arnd@arndb.de>
X-Provags-ID: V02:K0:sI2qq0+QRtDPha71ZvPW27yO/oy4iwUGwEaNUidCkyT
 zOnhQ81jaYMbZhgB6Xnc72mLAF+riRsbg7p/G1d5uQR6s4q6Jx
 u9BsWWJOvSRZVftqZFPJSZ4X4cQ0ZZYQcuerCQH8AO2m25y11c
 jMY2+2xHU4gELh94enSFrm+tIn720hltMv5JPMvRRru3HjPr0K
 ae28QNZ5/sbOG0PbI1hgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 March 2011, Waldemar Rymarkiewicz wrote:
> Add new driver for MicroRead NFC chip connected to i2c bus.
> 
> See Documentation/nfc/nfc-microread.txt.

The imlpementation looks fairly clean, no objections on that.

However, this is the second NFC driver (at least), and that means
it's time to come up with a generic way of talking to NFC devices
from user space. We cannot allow every NFC controller to have
another set of arbitrary ioctl numbers.

What I suggest you do is to work with the maintainers of the existing
pn544 driver (Matti and Jari) to create an NFC core library that
takes care of the character device interface and that can be
shared between the two drivers. Instead of each driver registering a
misc device, make it call a nfc_device_register() function that
is implemented in a common module.

You will need a structure like

struct nfc_device {
	struct device *dev; /* points to i2c/platform/... hardware device */
	const struct nfc_operations *ops;
	struct mutex mutex;
};

struct nfc_operations {
	/* pin before calling the functions */
	struct module *owner;

	/* called from file operations */
	int (*open)(struct nfc_device *dev);
	void (*close)(struct nfc_device *dev);

	/* called from ioctl */
	int (*configure)(struct nfc_device *dev);
	int (*connect)(struct nfc_device *dev);
	int (*reset)(struct nfc_device *);

	size_t (*read_avail)(struct nfc_device *); /* for poll, read */
	ssize_t (*read)(struct nfc_device *, void __user *buf, size_t len);
	size_t (*write_avail)(struct nfc_device *); /* for write */
	ssize_t (*write)(struct nfc_device *, void __user *buf, size_t len);
};

extern int nfc_device_register(struct nfc_device *dev);
extern void nfc_device_unregister(struct nfc_device *dev);
extern void nfc_wake_up(struct nfc_device *dev); /* on interrupt */

> +The below platform data should be set when configuring board.
> +
> +struct microread_nfc_platform_data {
> +	unsigned int rst_gpio;
> +	unsigned int irq_gpio;
> +	unsigned int ioh_gpio;

Not your problem directly, but I think we need to find a way to encode
gpio pins in resources like we do for interrupts.

> +	int (*request_hardware) (struct i2c_client *client);
> +	void (*release_hardware) (void);

Why do you need these in platform data? Can't you just request
the i2c device at the time when you create the platform_device?

> +struct microread_info {
> +	struct i2c_client *i2c_dev;
> +	struct miscdevice mdev;
> +
> +	u8 state;
> +	u8 irq_state;
> +	int irq;
> +	u16 buflen;
> +	u8 *buf;
> +	wait_queue_head_t rx_waitq;
> +	struct mutex rx_mutex;
> +	struct mutex mutex;
> +};

mdev, rx_waitq and mutex would go into the common module.
I would expect that you also need a tx_waitq. What happens
when the buffer is full?

> +static inline int microread_is_busy(struct microread_info *info)
> +{
> +	return (info->state == MICROREAD_STATE_BUSY);
> +}
> +
> +static int microread_open(struct inode *inode, struct file *file)
> +{
> +	struct microread_info *info = container_of(file->private_data,
> +					struct microread_info, mdev);
> +	struct i2c_client *client = info->i2c_dev;
> +	int ret = 0;
> +
> +	dev_vdbg(&client->dev, "%s: info: %p", __func__, info);
> +
> +	mutex_lock(&info->mutex);
> +
> +	if (microread_is_busy(info)) {
> +		dev_err(&client->dev, "%s: info %p: device is busy.", __func__,
> +				info);
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	info->state = MICROREAD_STATE_BUSY;
> +done:
> +	mutex_unlock(&info->mutex);
> +	return ret;
> +}

Note that the microread_is_busy() logic does not protect you from having
multiple concurrent readers, because multiple threads may share a single
file descriptor.

> +long microread_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
...
> +const struct file_operations microread_fops = {
> +	.owner		= THIS_MODULE,

Some of your identifiers are not 'static'. Please make sure that only symbols
that are used across files are in the global namespace.

	Arnd
