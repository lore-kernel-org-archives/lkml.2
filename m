Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab1CRLDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:03:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60459 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752981Ab1CRLDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:03:46 -0400
Date: Fri, 18 Mar 2011 11:03:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Cc: <linux-i2c@vger.kernel.org>, <arnd@arndb.de>, <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <hthebaud@insidefr.com>,
        <matti.j.aaltonen@nokia.com>
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-ID: <20110318110348.728f6036@lxorguk.ukuu.org.uk>
In-Reply-To: <1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
	<1300444824-13713-2-git-send-email-waldemar.rymarkiewicz@tieto.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 11:40:24 +0100
Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com> wrote:

> Add new driver for MicroRead NFC chip connected to i2c bus.

Ok we now have two devices and they have differing APIs and own device
names and both from the same company. This has to stop right now and the
existing one wants sorting out accordingly (while you are it fix the fact
any user can blow the kernel log away in that one by issuing bogus ioctls
at it, thats not a good thing)

NAK to this in its current form.

If we are going to have multiple nfc devices (and we are) then we need
a /dev/nfc%d device range to dump them in and we need some API
commonality.

Your API seems fairly sane (except your nfc-microread.txt needs to
document or point properly to the HCI messages in question

> +The application can use ioctl(MICROREAD_IOC_RESET)to reset the hardware.

And a reset is a generic sort of interface so we should probably have
NFC_IOC_RESET to go with /dev/nfc%d naming.

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

So a process spinning trying to open it can spew all over the log - looks
bogus to me (similar problems in the existing driver)



> +	if (count > info->buflen) {
> +		dev_err(&client->dev, "%s: no enough space in read buffer.",
> +				__func__);
> +		ret = -ENOMEM;
> +		goto done;

More bogus log spewing and an odd error code for good measure

> +	lrc = calc_lrc(info->buf, len + 1);
> +	if (lrc != info->buf[len + 1]) {
> +		dev_err(&client->dev, "%s: incorrect i2c frame.", __func__);
> +		ret = -EFAULT;
> +		goto done;

So I can also spew all over the log by putting a deliberately busted
sender next to it.

> +	}
> +
> +	ret = len + 2;
> +
> +	if (copy_to_user(buf, info->buf, len + 2)) {
> +		dev_err(&client->dev, "%s: error copying to user.", __func__);
> +		ret = -EFAULT;

And another one.

> +static ssize_t microread_write(struct file *file, const char __user *buf,
> +			size_t count, loff_t *f_pos)
> +{
> +	struct microread_info *info = container_of(file->private_data,
> +					struct microread_info, mdev);
> +	struct i2c_client *client = info->i2c_dev;
> +	int ret;
> +	u16 len;
> +
> +	dev_dbg(&client->dev, "%s: info: %p, size %d (bytes).", __func__,
> +					info, count);
> +
> +	if (count > info->buflen) {
> +		dev_err(&client->dev, "%s: no enought space in TX buffer.",
> +				__func__);
> +		return -EINVAL;
> +	}

And another

> +
> +	len = min_t(u16, count, info->buflen);
> +
> +	mutex_lock(&info->mutex);
> +	if (copy_from_user(info->buf, buf, len)) {
> +		dev_err(&client->dev, "%s: error copying from user.",
> +				__func__);

Etc - these all want cleaning up


> +static unsigned int microread_poll(struct file *file, poll_table *wait)
> +{
> +	struct microread_info *info = container_of(file->private_data,
> +					struct microread_info, mdev);
> +	struct i2c_client *client = info->i2c_dev;
> +	int ret = (POLLOUT | POLLWRNORM);
> +
> +	dev_vdbg(&client->dev, "%s: info: %p client %p", __func__, info,
> +			client);
> +
> +	mutex_lock(&info->mutex);
> +	poll_wait(file, &info->rx_waitq, wait);
> +
> +	mutex_lock(&info->rx_mutex);
> +	if (info->irq_state)
> +		ret |= (POLLIN | POLLRDNORM);
> +	mutex_unlock(&info->rx_mutex);
> +	mutex_unlock(&info->mutex);

What is the intended behaviour on a reset while I am polling ?

> +static long microread_ioctl(struct file *file, unsigned int cmd,
> +							unsigned long arg)
> +{
> +	struct microread_info *info = container_of(file->private_data,
> +					struct microread_info, mdev);
> +	struct i2c_client *client = info->i2c_dev;
> +	struct microread_nfc_platform_data *pdata =
> +				dev_get_platdata(&client->dev);
> +	int ret = 0;
> +
> +	dev_dbg(&client->dev, "%s: info: %p cmd %d", __func__, info, cmd);
> +
> +	mutex_lock(&info->mutex);
> +
> +	switch (cmd) {
> +	case MICROREAD_IOC_CONFIGURE:
> +	case MICROREAD_IOC_CONNECT:
> +		goto done;

Ermm nope.. why do we have do nothing ioctls ?

> +	case MICROREAD_IOC_RESET:
> +		microread_reset_hw(pdata);

> +	default:
> +		dev_err(&client->dev, "%s; not supported ioctl 0x%x", __func__,
> +			cmd);

And more spewage


> +static irqreturn_t microread_irq(int irq, void *dev)
> +{
> +	struct microread_info *info = dev;
> +	struct i2c_client *client = info->i2c_dev;
> +
> +	dev_dbg(&client->dev, "irq: info %p client %p ", info,	client);
> +
> +	if (irq != client->irq)
> +		return IRQ_NONE;

How can this occur - why is this test needed ????

> +
> +	mutex_lock(&info->rx_mutex);
> +	info->irq_state = 1;
> +	mutex_unlock(&info->rx_mutex);

Would it not be lighter to use atomic bit ops ?


> +	info->mdev.minor = MISC_DYNAMIC_MINOR;
> +	info->mdev.name = MICROREAD_DEV_NAME;
> +	info->mdev.fops = &microread_fops;
> +	info->mdev.parent = &client->dev;
> +
> +	ret = misc_register(&info->mdev);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "%s: register chr dev failed (ret %d)",
> +			__func__, ret);
> +			goto free_irq;
> +	}

And at this point you want a thing to hand out nfc%d names not to use
misc device with random per device API. The same app ought to be able to
work with many nfc readers.

> +static int microread_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	return -ENOSYS;
> +}
> +
> +static int microread_resume(struct i2c_client *client)
> +{
> +	return -ENOSYS;
> +}

So why provide them ??


Alan
