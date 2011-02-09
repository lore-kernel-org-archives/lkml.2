Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1BIRfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 12:35:36 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:58962 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1BIRff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 12:35:35 -0500
Date: Wed, 9 Feb 2011 09:35:32 -0800
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Message-ID: <20110209173532.GB21766@ovro.caltech.edu>
References: <1297208267-27087-1-git-send-email-iws@ovro.caltech.edu>
 <1297208267-27087-2-git-send-email-iws@ovro.caltech.edu>
 <20110209083325.GA7256@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209083325.GA7256@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Wed, 09 Feb 2011 09:35:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 12:33:25AM -0800, Dmitry Torokhov wrote:
> Hi Ira,
> 
> On Tue, Feb 08, 2011 at 03:37:46PM -0800, Ira W. Snyder wrote:
> > This driver allows userspace to access the data processing FPGAs on the
> > OVRO CARMA board. It has two modes of operation:
> > 
> 
> Thank you for making the changes, some more comments below.
> 
> > +
> > +#define inode_to_dev(inode) container_of(inode->i_cdev, struct fpga_device, cdev)
> > +
> 
> Does not seem to be used.
> 

Leftovers from earlier versions, will remove.

> > +/*
> > + * Data Buffer Allocation Helpers
> > + */
> > +
> > +static int data_map_buffer(struct device *dev, struct data_buf *buf)
> > +{
> > +	return videobuf_dma_map(dev, &buf->vb);
> > +}
> > +
> > +static void data_unmap_buffer(struct device *dev, struct data_buf *buf)
> > +{
> > +	videobuf_dma_unmap(dev, &buf->vb);
> > +}
> 
> Why can't we all videobuf_dma_map() and videobuf_dma_unmap() directly?
> What these helpers supposed to solve?
> 

The helpers were useful in the past. Now they are not. Will change.

> > +static int data_alloc_buffers(struct fpga_device *priv)
> > +{
> > +	struct data_buf *buf;
> > +	int i, ret;
> > +
> > +	for (i = 0; i < MAX_DATA_BUFS; i++) {
> > +
> > +		/* allocate a buffer */
> > +		buf = data_alloc_buffer(priv->bufsize);
> > +		if (!buf)
> > +			continue;
> 
> break?
> 
> > +
> > +		/* map it for DMA */
> > +		ret = data_map_buffer(priv->dev, buf);
> > +		if (ret) {
> > +			data_free_buffer(buf);
> > +			continue;
> 
> and here as well?
> 

Yep, break is fine also.

> > +		}
> > +
> > +		/* add it to the list of free buffers */
> > +		list_add_tail(&buf->entry, &priv->free);
> > +		priv->num_buffers++;
> > +	}
> > +
> > +	/* Make sure we allocated the minimum required number of buffers */
> > +	if (priv->num_buffers < MIN_DATA_BUFS) {
> > +		dev_err(priv->dev, "Unable to allocate enough data buffers\n");
> > +		data_free_buffers(priv);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* Warn if we are running in a degraded state, but do not fail */
> > +	if (priv->num_buffers < MAX_DATA_BUFS) {
> > +		dev_warn(priv->dev, "Unable to allocate one second worth of "
> > +				    "buffers, using %d buffers instead\n", i);
> 
> The latest style is not break strings even if they exceed 80 column
> limit to make sure they are easily greppable.
> 

I usually just follow checkpatch warnings. I'll combine the strings onto
one line.

> > +static void data_dma_cb(void *data)
> > +{
> > +	struct fpga_device *priv = data;
> > +	struct data_buf *buf;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&priv->lock, flags);
> > +
> > +	/* clear the FPGA status and re-enable interrupts */
> > +	data_enable_interrupts(priv);
> > +
> > +	/* If the inflight list is empty, we've got a bug */
> > +	BUG_ON(list_empty(&priv->inflight));
> > +
> > +	/* Grab the first buffer from the inflight list */
> > +	buf = list_first_entry(&priv->inflight, struct data_buf, entry);
> > +	list_del_init(&buf->entry);
> > +
> > +	/* Add it to the used list */
> > +	list_add_tail(&buf->entry, &priv->used);
> 
> or
> 	list_move_tail(&buf->entry, &priv->used);
> 

Using list_move_tail() didn't occur to me. I'll change it.

> > +
> > +static irqreturn_t data_irq(int irq, void *dev_id)
> > +{
> > +	struct fpga_device *priv = dev_id;
> > +	struct data_buf *buf;
> > +	u32 status;
> > +	int i;
> > +
> > +	/* detect spurious interrupts via FPGA status */
> > +	for (i = 0; i < 4; i++) {
> > +		status = fpga_read_reg(priv, i, MMAP_REG_STATUS);
> > +		if (!(status & (CORL_DONE | CORL_ERR))) {
> > +			dev_err(priv->dev, "spurious irq detected (FPGA)\n");
> > +			return IRQ_NONE;
> > +		}
> > +	}
> > +
> > +	/* detect spurious interrupts via raw IRQ pin readback */
> > +	status = ioread32be(priv->regs + SYS_IRQ_INPUT_DATA);
> > +	if (status & IRQ_CORL_DONE) {
> > +		dev_err(priv->dev, "spurious irq detected (IRQ)\n");
> > +		return IRQ_NONE;
> > +	}
> > +
> > +	spin_lock(&priv->lock);
> > +
> > +	/* hide the interrupt by switching the IRQ driver to GPIO */
> > +	data_disable_interrupts(priv);
> > +
> > +	/* Check that we actually have a free buffer */
> > +	if (list_empty(&priv->free)) {
> > +		priv->num_dropped++;
> > +		data_enable_interrupts(priv);
> > +		goto out_unlock;
> > +	}
> > +
> > +	buf = list_first_entry(&priv->free, struct data_buf, entry);
> > +	list_del_init(&buf->entry);
> > +
> > +	/* Check the buffer size */
> > +	BUG_ON(buf->size != priv->bufsize);
> > +
> > +	/* Submit a DMA transfer to get the correlation data */
> > +	if (data_submit_dma(priv, buf)) {
> > +		dev_err(priv->dev, "Unable to setup DMA transfer\n");
> > +		list_add_tail(&buf->entry, &priv->free);
> > +		data_enable_interrupts(priv);
> > +		goto out_unlock;
> > +	}
> > +
> > +	/* DMA setup succeeded, GO!!! */
> > +	list_add_tail(&buf->entry, &priv->inflight);
> > +	dma_async_memcpy_issue_pending(priv->chan);
> > +
> > +out_unlock:
> > +	spin_unlock(&priv->lock);
> > +	return IRQ_HANDLED;
> > +}
> 
> Hmm, I wonder if we could simplify this a bit by using list_move()...
> 
> 	bool submitted = false;
> 	...
> 
> 	if (list_empty(&priv->free)) {
> 		priv->num_dropped++;
> 		goto out;
> 	}
> 
> 	buf = list_first_entry(&priv->free, struct data_buf, entry);
> 	BUG_ON(buf->size != priv->bufsize);
> 
> 	/* Submit a DMA transfer to get the correlation data */
> 	if (data_submit_dma(priv, buf)) {
> 		dev_err(priv->dev, "Unable to setup DMA transfer\n");
> 		goto out;
> 	}
> 
> 	/* DMA setup succeeded, GO!!! */
> 	list_move_tail(&buf->entry, &priv->inflight);
> 	dma_async_memcpy_issue_pending(priv->chan);
> 	submitted = true;
> 
> out:
> 	if (!submitted)
> 		data_enable_interrupts(priv);
> 	spin_unlock(&priv->lock);
> 	return IRQ_HANDLED;
> }
> 
> OTOH, we can't have more than 1 in-flight buffer, can we? Should
> we even have a list?
> 

This looks like a good change. I didn't know about list_move_tail()
before you mentioned it. Good catch.

You are correct that it is not possible to have more than one in flight
buffer at the same time. It was previously possible in an earlier
version of the driver. That was before I was forced to come up with the
ugly IRQ disabling scheme due to the hardware design.

What would you replace the inflight list with? A "struct data_buf
*inflight;" in the priv structure?

> > +
> > +/*
> > + * Realtime Device Enable Helpers
> > + */
> > +
> > +/**
> > + * data_device_enable() - enable the device for buffered dumping
> > + * @priv: the driver's private data structure
> > + *
> > + * Enable the device for buffered dumping. Allocates buffers and hooks up
> > + * the interrupt handler. When this finishes, data will come pouring in.
> > + *
> > + * LOCKING: must hold dev->mutex
> > + * CONTEXT: user context only
> > + *
> > + * Returns 0 on success, -ERRNO otherwise
> > + */
> > +static int data_device_enable(struct fpga_device *priv)
> > +{
> > +	u32 val;
> > +	int ret;
> > +
> > +	/* multiple enables are safe: they do nothing */
> > +	if (priv->enabled)
> > +		return 0;
> > +
> > +	/* check that the FPGAs are programmed */
> > +	val = ioread32be(priv->regs + SYS_FPGA_CONFIG_STATUS);
> > +	if (!(val & (1 << 18))) {
> > +		dev_err(priv->dev, "DATA-FPGAs are not enabled\n");
> > +		return -ENODATA;
> > +	}
> > +
> > +	/* read the FPGAs to calculate the buffer size */
> > +	ret = data_calculate_bufsize(priv);
> > +	if (ret) {
> > +		dev_err(priv->dev, "unable to calculate buffer size\n");
> > +		goto out_error;
> > +	}
> > +
> > +	/* allocate the correlation data buffers */
> > +	ret = data_alloc_buffers(priv);
> > +	if (ret) {
> > +		dev_err(priv->dev, "unable to allocate buffers\n");
> > +		goto out_error;
> > +	}
> > +
> > +	/* setup the source scatterlist for dumping correlation data */
> > +	ret = data_setup_corl_table(priv);
> > +	if (ret) {
> > +		dev_err(priv->dev, "unable to setup correlation DMA table\n");
> > +		goto out_error;
> > +	}
> > +
> > +	/* switch to the external FPGA IRQ line */
> > +	data_enable_interrupts(priv);
> 
> Not after setting interrupt handler? Can't that lead to "unhandled
> interrupt" scenarios?
> 

Yes, good catch.

> > +
> > +	/* hookup the irq handler */
> > +	ret = request_irq(priv->irq, data_irq, IRQF_SHARED, drv_name, priv);
> > +	if (ret) {
> > +		dev_err(priv->dev, "unable to request IRQ handler\n");
> > +		goto out_error;
> > +	}
> > +
> > +	/* success, we're enabled */
> > +	priv->enabled = true;
> > +	return 0;
> > +
> > +out_error:
> > +	sg_free_table(&priv->corl_table);
> > +	priv->corl_nents = 0;
> > +
> > +	data_free_buffers(priv);
> > +	return ret;
> > +}
> > +
> > +/**
> > + * data_device_disable() - disable the device for buffered dumping
> > + * @priv: the driver's private data structure
> > + *
> > + * Disable the device for buffered dumping. Stops new DMA transactions from
> > + * being generated, waits for all outstanding DMA to complete, and then frees
> > + * all buffers.
> > + *
> > + * LOCKING: must hold dev->mutex
> > + * CONTEXT: user only
> > + *
> > + * Returns 0 on success, -ERRNO otherwise
> > + */
> > +static int data_device_disable(struct fpga_device *priv)
> > +{
> > +	struct list_head *list;
> > +	int ret;
> > +
> > +	/* allow multiple disable */
> > +	if (!priv->enabled)
> > +		return 0;
> > +
> > +	/* switch to the internal GPIO IRQ line */
> > +	data_disable_interrupts(priv);
> > +
> > +	/* unhook the irq handler */
> > +	free_irq(priv->irq, priv);
> > +
> > +	/*
> > +	 * wait for all outstanding DMA to complete
> > +	 *
> > +	 * Device interrupts are disabled, so no more buffers can be added to
> > +	 * the inflight list. Therefore we do not need any locking.
> > +	 */
> > +	list = &priv->inflight;
> > +	while (!list_empty(list)) {
> > +		ret = wait_event_interruptible(priv->wait, list_empty(list));
> > +		if (ret)
> > +			return ret;
> > +	}
> 
> Simply
> 
> 	ret = wait_event_interruptible(priv->wait, list_empty(&prov->inflight));
> 	if (ret)
> 		return ret;
> 
> is enough, no need to loop.
> 
> > +
> > +	/* free the correlation table */
> > +	sg_free_table(&priv->corl_table);
> > +	priv->corl_nents = 0;
> > +
> > +	/* free all of the buffers */
> > +	data_free_buffers(priv);
> > +	priv->enabled = false;
> 
> I think this should be:
> 
> 	/*
> 	 * We are taking lock not to protect priv->enabled but to make
> 	 * sure there are no readers in process of altering free/used
> 	 * lists while we are setting the flag.
> 	 */
> 	spin_lock_irq(&priv->lock);
> 	priv->enabled = false;
> 	spin_unlock_irq(&priv->lock);
> 
> 	/*
> 	 * Wake up readers so they error out and hopefully close their
> 	 * file descriptors.
> 	 */
> 	wake_up(&priv->wait);
> 
> 	/* We now know that readers will not touch free/used lists */
> 	data_free_buffers();
> 
> Also please see the comments in data_read().
> 
> 

Yes, looks good.

> > +	return 0;
> > +}
> > +
> > +/*
> > + * SYSFS Attributes
> > + */
> > +
> > +/*
> > + * Count the number of entries in the given list
> > + */
> > +static unsigned int list_num_entries(struct list_head *list)
> > +{
> > +	struct list_head *entry;
> > +	unsigned int ret = 0;
> > +
> > +	list_for_each(entry, list)
> > +		ret++;
> > +
> > +	return ret;
> > +}
> > +
> > +static ssize_t data_num_buffers_show(struct device *dev,
> > +				     struct device_attribute *attr, char *buf)
> > +{
> > +	struct fpga_device *priv = dev_get_drvdata(dev);
> > +	return snprintf(buf, PAGE_SIZE, "%u\n", priv->num_buffers);
> > +}
> > +
> > +static ssize_t data_bufsize_show(struct device *dev,
> > +				 struct device_attribute *attr, char *buf)
> > +{
> > +	struct fpga_device *priv = dev_get_drvdata(dev);
> > +	return snprintf(buf, PAGE_SIZE, "%zu\n", priv->bufsize);
> > +}
> > +
> > +static ssize_t data_inflight_show(struct device *dev,
> > +				  struct device_attribute *attr, char *buf)
> > +{
> > +	struct fpga_device *priv = dev_get_drvdata(dev);
> > +	unsigned int num = list_num_entries(&priv->inflight);
> > +	return snprintf(buf, PAGE_SIZE, "%u\n", num);
> > +}
> > +
> > +static ssize_t data_free_show(struct device *dev,
> > +			      struct device_attribute *attr, char *buf)
> > +{
> > +	struct fpga_device *priv = dev_get_drvdata(dev);
> > +	unsigned int num = list_num_entries(&priv->free);
> > +	return snprintf(buf, PAGE_SIZE, "%u\n", num);
> > +}
> > +
> > +static ssize_t data_used_show(struct device *dev,
> > +			      struct device_attribute *attr, char *buf)
> > +{
> > +	struct fpga_device *priv = dev_get_drvdata(dev);
> > +	unsigned int num = list_num_entries(&priv->used);
> > +	return snprintf(buf, PAGE_SIZE, "%u\n", num);
> > +}
> > +
> > +static ssize_t data_num_dropped_show(struct device *dev,
> > +				     struct device_attribute *attr, char *buf)
> > +{
> > +	struct fpga_device *priv = dev_get_drvdata(dev);
> > +	return snprintf(buf, PAGE_SIZE, "%u\n", priv->num_dropped);
> > +}
> > +
> > +static ssize_t data_en_show(struct device *dev, struct device_attribute *attr,
> > +			    char *buf)
> > +{
> > +	struct fpga_device *priv = dev_get_drvdata(dev);
> > +	ssize_t count;
> > +
> > +	count = mutex_lock_interruptible(&priv->mutex);
> > +	if (count)
> > +		return count;
> > +
> > +	count = snprintf(buf, PAGE_SIZE, "%u\n", priv->enabled);
> > +	mutex_unlock(&priv->mutex);
> 
> No locking needed.
> 
> > +	return count;
> > +}
> > +
> > +static ssize_t data_en_set(struct device *dev, struct device_attribute *attr,
> > +			   const char *buf, size_t count)
> > +{
> > +	struct fpga_device *priv = dev_get_drvdata(dev);
> > +	unsigned long enable;
> > +	int ret;
> > +
> > +	ret = strict_strtoul(buf, 0, &enable);
> > +	if (ret) {
> > +		dev_err(priv->dev, "unable to parse enable input\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	ret = mutex_lock_interruptible(&priv->mutex);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (enable)
> > +		ret = data_device_enable(priv);
> > +	else
> > +		ret = data_device_disable(priv);
> > +
> 
> Have you considered enabling the device when someone opens the device
> node and closing it when last user drops off?
> 
> 

Yes. Unfortunately it is not possible. Blame my userspace software
engineers, who refused this model of operation.

I must meet the requirement that the device must remain open while the
DATA-FPGAs are reconfigured. This means that the FPGAs are completely
powered down, and a new FPGA bitfile is loaded into them.

After a reconfiguration, the data buffer size may change.

The userspace coders were willing to use a sysfs file to enable/disable
reading from the device, but they were not willing to open/close the
device each time. It was the best compromise they would accept.

I'm not happy about it either.

> > +	if (ret) {
> > +		dev_err(priv->dev, "device %s failed\n",
> > +			enable ? "enable" : "disable");
> > +		count = ret;
> > +		goto out_unlock;
> > +	}
> > +
> > +out_unlock:
> > +	mutex_unlock(&priv->mutex);
> > +	return count;
> > +}
> > +
> > +static DEVICE_ATTR(num_buffers, S_IRUGO, data_num_buffers_show, NULL);
> > +static DEVICE_ATTR(buffer_size, S_IRUGO, data_bufsize_show, NULL);
> > +static DEVICE_ATTR(num_inflight, S_IRUGO, data_inflight_show, NULL);
> > +static DEVICE_ATTR(num_free, S_IRUGO, data_free_show, NULL);
> > +static DEVICE_ATTR(num_used, S_IRUGO, data_used_show, NULL);
> > +static DEVICE_ATTR(num_dropped, S_IRUGO, data_num_dropped_show, NULL);
> > +static DEVICE_ATTR(enable, S_IWUSR | S_IRUGO, data_en_show, data_en_set);
> > +
> > +static struct attribute *data_sysfs_attrs[] = {
> > +	&dev_attr_num_buffers.attr,
> > +	&dev_attr_buffer_size.attr,
> > +	&dev_attr_num_inflight.attr,
> > +	&dev_attr_num_free.attr,
> > +	&dev_attr_num_used.attr,
> > +	&dev_attr_num_dropped.attr,
> > +	&dev_attr_enable.attr,
> > +	NULL,
> > +};
> > +
> > +static const struct attribute_group rt_sysfs_attr_group = {
> > +	.attrs = data_sysfs_attrs,
> > +};
> 
> As I mentioned, consider switching to debugfs - you won't need multiple
> attributes and will be able to get full picture (number of
> free/used/in-flight/etc) in one file and will not be constrained with
> ABI concerns.
> 

I will look into it.

> > +
> > +/*
> > + * FPGA Realtime Data Character Device
> > + */
> > +
> > +static int data_open(struct inode *inode, struct file *filp)
> > +{
> > +	/*
> > +	 * The miscdevice layer puts our struct miscdevice into the
> > +	 * filp->private_data field. We use this to find our private
> > +	 * data and then overwrite it with our own private structure.
> > +	 */
> > +	struct fpga_device *priv = container_of(filp->private_data,
> > +						struct fpga_device, miscdev);
> > +	struct fpga_reader *reader;
> > +	int ret;
> > +
> > +	/* allocate private data */
> > +	reader = kzalloc(sizeof(*reader), GFP_KERNEL);
> > +	if (!reader)
> > +		return -ENOMEM;
> > +
> > +	reader->priv = priv;
> > +	reader->buf = NULL;
> > +
> > +	filp->private_data = reader;
> > +	ret = nonseekable_open(inode, filp);
> > +	if (ret) {
> > +		dev_err(priv->dev, "nonseekable-open failed\n");
> > +		kfree(reader);
> > +		return ret;
> > +	}
> > +
> 
> I wonder if the device should allow only exclusive open... Unless you
> distribute copies of data between all readers.
> 

I wish to allow multiple different processes to mmap() the device. This
requires open(), followed by mmap(). I only care about a single realtime
data reader (which calls read()). Splitting the two use cases into two
drivers seemed like a big waste of time and effort. I have no idea how
to accomplish a single read()er while allowing multiple mmap()ers.

> > +	return 0;
> > +}
> > +
> > +static int data_release(struct inode *inode, struct file *filp)
> > +{
> > +	struct fpga_reader *reader = filp->private_data;
> > +
> > +	/* free the per-reader structure */
> > +	data_free_buffer(reader->buf);
> > +	kfree(reader);
> > +	filp->private_data = NULL;
> > +	return 0;
> > +}
> > +
> > +static ssize_t data_read(struct file *filp, char __user *ubuf, size_t count,
> > +			 loff_t *f_pos)
> > +{
> > +	struct fpga_reader *reader = filp->private_data;
> > +	struct fpga_device *priv = reader->priv;
> > +	struct list_head *used = &priv->used;
> > +	struct data_buf *dbuf;
> > +	size_t avail;
> > +	void *data;
> > +	int ret;
> > +
> > +	/* check if we already have a partial buffer */
> > +	if (reader->buf) {
> > +		dbuf = reader->buf;
> > +		goto have_buffer;
> > +	}
> > +
> > +	spin_lock_irq(&priv->lock);
> > +
> > +	/* Block until there is at least one buffer on the used list */
> > +	while (list_empty(used)) {
> 
> I believe we should stop and return error when device is disabled so the
> condition should be:
> 
> 	while (!reader->buf && list_empty() && priv->enabled)
> 
> 

The requirement is that the device stay open during reconfiguration.
This provides for that. Readers just block for as long as the device is
not producing data.

> > +		spin_unlock_irq(&priv->lock);
> > +
> > +		if (filp->f_flags & O_NONBLOCK)
> > +			return -EAGAIN;
> > +
> > +		ret = wait_event_interruptible(priv->wait, !list_empty(used));
> 
> 		ret = wait_event_interruptible(priv->wait,
> 					!list_empty(used) || !priv->enabled);
> > +		if (ret)
> > +			return ret;
> > +
> > +		spin_lock_irq(&priv->lock);
> > +	}
> > +
> 
> 	if (!priv->enabled) {
> 		spin_unlock_irq(&priv->lock);
> 		return -ENXIO;
> 	}
> 
> 	if (reader->buf) {
> 		dbuf = reader->buf;
> 	} else {
> 		dbuf = list_first_entry(used, struct data_buf, entry);
> 		list_del_init(&dbuf->entry);
> 	}
> 
> > +	/* Grab the first buffer off of the used list */
> > +	dbuf = list_first_entry(used, struct data_buf, entry);
> > +	list_del_init(&dbuf->entry);
> > +
> > +	spin_unlock_irq(&priv->lock);
> > +
> > +	/* Buffers are always mapped: unmap it */
> > +	data_unmap_buffer(priv->dev, dbuf);
> > +
> > +	/* save the buffer for later */
> > +	reader->buf = dbuf;
> > +	reader->buf_start = 0;
> > +
> > +	/* we removed a buffer from the used list: wake any waiters */
> > +	wake_up(&priv->wait);
> 
> I do not think anyone waits on this...
> 
> > +
> > +have_buffer:
> > +	/* Get the number of bytes available */
> > +	avail = dbuf->size - reader->buf_start;
> > +	data = dbuf->vb.vaddr + reader->buf_start;
> > +
> > +	/* Get the number of bytes we can transfer */
> > +	count = min(count, avail);
> > +
> > +	/* Copy the data to the userspace buffer */
> > +	if (copy_to_user(ubuf, data, count))
> > +		return -EFAULT;
> > +
> > +	/* Update the amount of available space */
> > +	avail -= count;
> > +
> > +	/* Lock against concurrent enable/disable */
> > +	ret = mutex_lock_interruptible(&priv->mutex);
> > +	if (ret)
> > +		return ret;
> 
> Mutex is not needed here, we shall rely on priv->lock. Map buffer
> beforehand, take lock, check if the device is enabled and if it still is
> put the buffer on free list. Release lock and exit if device was
> enabled; otherwise dispose the buffer.
> 
> > +
> > +	/* Still some space available: save the buffer for later */
> > +	if (avail != 0) {
> > +		reader->buf_start += count;
> > +		reader->buf = dbuf;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/*
> > +	 * No space is available in this buffer
> > +	 *
> > +	 * This is a complicated decision:
> > +	 * - if the device is not enabled: free the buffer
> > +	 * - if the buffer is too small: free the buffer
> > +	 */
> > +	if (!priv->enabled || dbuf->size != priv->bufsize) {
> > +		data_free_buffer(dbuf);
> > +		reader->buf = NULL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/*
> > +	 * The buffer is safe to recycle: remap it and finish
> > +	 *
> > +	 * If this fails, we pretend that the read never happened, and return
> > +	 * -EFAULT to userspace. They'll retry the read again.
> > +	 */
> > +	ret = data_map_buffer(priv->dev, dbuf);
> > +	if (ret) {
> > +		dev_err(priv->dev, "unable to remap buffer for DMA\n");
> > +		count = -EFAULT;
> > +		goto out_unlock;
> > +	}
> > +
> > +	/* Add the buffer back to the free list */
> > +	reader->buf = NULL;
> > +	spin_lock_irq(&priv->lock);
> > +	list_add_tail(&dbuf->entry, &priv->free);
> > +	spin_unlock_irq(&priv->lock);
> > +
> > +out_unlock:
> > +	mutex_unlock(&priv->mutex);
> > +	return count;
> > +}
> > +
> > +static unsigned int data_poll(struct file *filp, struct poll_table_struct *tbl)
> > +{
> > +	struct fpga_reader *reader = filp->private_data;
> > +	struct fpga_device *priv = reader->priv;
> > +	unsigned int mask = 0;
> > +
> > +	poll_wait(filp, &priv->wait, tbl);
> > +
> > +	spin_lock_irq(&priv->lock);
> > +
> 
> Like I mentioned, the spinlock is not useful here - all threads will get
> woken up and will try to read since you are not resetting the wakeup
> condition.
> 

Whoops, I forgot this from your previous review. Sorry.

> > +	if (!list_empty(&priv->used))
> > +		mask |= POLLIN | POLLRDNORM;
> 
> I think you should also add:
> 
> 	if (!priv->)
> 		mask |= POLLHUP | POLLERR;
> 
> to tell the readers that they should close their file descriptors. 
> 

Did you mean "!priv->enabled"? If so, see the comments above about
keeping the device open across reconfiguration.

Thanks for the review, I'll start making more improvements now. :)
Ira
