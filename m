Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab1DXBBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:01:54 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21808 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab1DXBBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:01:52 -0400
Date: Sun, 24 Apr 2011 02:55:36 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: james_p_freyensee@linux.intel.com
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 3/4] Intel PTI implementaiton of MIPI 1149.7.
In-Reply-To: <1303515150-1718-4-git-send-email-james_p_freyensee@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1104240212390.28014@swampdragon.chaosbits.net>
References: <james_p_freyensee@linux.intel.com> <1303515150-1718-4-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Apr 2011, james_p_freyensee@linux.intel.com wrote:

> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> The PTI (Parallel Trace Interface) driver directs
> trace data routed from various parts in the system out
> through an Intel Penwell PTI port and out of the mobile
> device for analysis with a debugging tool (Lauterbach or Fido).
> Though n_tracesink and n_tracerouter line discipline drivers
> are used to extract modem tracing data to the PTI driver
> and other parts of an Intel mobile solution, the PTI driver
> can be used independent of n_tracesink and n_tracerouter.
> 
> You should select this driver if the target kernel is meant for
> an Intel Atom (non-netbook) mobile device containing a MIPI
> P1149.7 standard implementation.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>

A few comments below.

...
> +#define DRIVERNAME		"pti"
> +#define PCINAME			"pciPTI"
> +#define TTYNAME			"ttyPTI"
> +#define CHARNAME		"pti"
> +#define PTITTY_MINOR_START	0
> +#define PTITTY_MINOR_NUM	2
> +#define MAX_APP_IDS		16   /* 128 channel ids / u8 bit size */
> +#define MAX_OS_IDS		16   /* 128 channel ids / u8 bit size */
> +#define MAX_MODEM_IDS		16   /* 128 channel ids / u8 bit size */
> +#define MODEM_BASE_ID		71   /* modem master ID address    */
...

Would be nice if the values of these defines would line up nicely.


...
> +static struct pci_device_id pci_ids[] __devinitconst = {
> +		{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x82B) },
> +		{0}
...

Why are there spaces after the opening { and before the closing } for the 
first entry, but not the second. Looks like you need to pick a 
consistent style.


> + *  regroup the appropriate message segments together reconstituting each
> + *  message.
> + */
> +static void pti_write_to_aperture(struct pti_masterchannel *mc,
> +				  u8 *buf,
> +				  int len)
> +{
> +	int dwordcnt, final, i;
> +	u32 ptiword;
> +	u8 *p;
> +	u32 __iomem *aperture;
> +
> +	p = buf;
...

Perhaps save a few lines by doing

static void pti_write_to_aperture(struct pti_masterchannel *mc,
                               u8 *buf,
                               int len)
{
     int dwordcnt, final, i;
     u32 ptiword;
     u32 __iomem *aperture;
     u8 *p = buf;


...
> +void pti_writedata(struct pti_masterchannel *mc, u8 *buf, int count)
> +{
> +	/*
> +	 * since this function is exported, this is treated like an
> +	 * API function, thus, all parameters should
> +	 * be checked for validity.
> +	 */
> +	if ((mc != NULL) && (buf != NULL) && (count > 0))
> +		pti_write_to_aperture(mc, buf, count);
> +	return;
...

Pointless return; statement.


...
> +static void __devexit pti_pci_remove(struct pci_dev *pdev)
> +{
> +	struct pti_dev *drv_data;
> +
> +	drv_data = pci_get_drvdata(pdev);
> +	if (drv_data != NULL) {

Perhaps

static void __devexit pti_pci_remove(struct pci_dev *pdev)
{
     struct pti_dev *drv_data = pci_get_drvdata(pdev);
     
     if (drv_data) {


...
> +static int pti_tty_driver_open(struct tty_struct *tty, struct file *filp)
> +{
> +	int ret = 0;
> +
> +	/*
> +	 * we actually want to allocate a new channel per open, per
> +	 * system arch.  HW gives more than plenty channels for a single
> +	 * system task to have its own channel to write trace data. This
> +	 * also removes a locking requirement for the actual write
> +	 * procedure.
> +	 */
> +	ret = tty_port_open(&drv_data->port, tty, filp);
> +
> +	return ret;
> +}
...

Why not get rid of the pointless 'ret' variable and simplify this down to

static int pti_tty_driver_open(struct tty_struct *tty, struct file *filp)
{     
     /*
      * we actually want to allocate a new channel per open, per
      * system arch.  HW gives more than plenty channels for a single
      * system task to have its own channel to write trace data. This
      * also removes a locking requirement for the actual write
      * procedure.
      */
     return tty_port_open(&drv_data->port, tty, filp);
}

??


...
> +static void pti_tty_driver_close(struct tty_struct *tty, struct file *filp)
> +{
> +	tty_port_close(&drv_data->port, tty, filp);
> +
> +	return;
> +}

Just kill that superfluous return statement.


...
> +static void pti_tty_cleanup(struct tty_struct *tty)
> +{
> +	struct pti_tty *pti_tty_data;
> +	struct pti_masterchannel *mc;
> +
> +	pti_tty_data = tty->driver_data;
> +
> +	if (pti_tty_data != NULL) {
> +		mc = pti_tty_data->mc;
> +		pti_release_masterchannel(mc);
> +		pti_tty_data->mc = NULL;
> +	}
> +
> +	if (pti_tty_data != NULL)
> +		kfree(pti_tty_data);
> +
> +	tty->driver_data = NULL;
> +}

How about this instead?

static void pti_tty_cleanup(struct tty_struct *tty)
{
     if (!tty->driver_data)
             return;
     pti_release_masterchannel(tty->driver_data->mc);
     kfree(tty->driver_data);
}

...
> +static int pti_tty_driver_write(struct tty_struct *tty,
> +	const unsigned char *buf, int len)
> +{
> +	struct pti_masterchannel *mc;
> +	struct pti_tty *pti_tty_data;
> +
> +	pti_tty_data = tty->driver_data;
> +	mc = pti_tty_data->mc;
> +	pti_write_to_aperture(mc, (u8 *)buf, len);
> +
> +	return len;
> +}

I'd like to suggest this as an alternative:

static int pti_tty_driver_write(struct tty_struct *tty,
     const unsigned char *buf, int len)
{
     pti_write_to_aperture(tty->driver_data->mc, (u8 *)buf, len);
     return len;
}


..
> +static int pti_char_open(struct inode *inode, struct file *filp)
> +{
> +	struct pti_masterchannel *mc;
> +
> +	mc = pti_request_masterchannel(0);
> +	if (mc == NULL)
> +		return -ENOMEM;
> +	filp->private_data = mc;
> +	return 0;
> +}

Ok, so I admit that I haven't looked to check if it's actually important 
that filp->private_data does not get overwritten if 
pti_request_masterchannel() returns NULL, but if we assume that it is not 
important, then this would be an improvement IMHO:

static int pti_char_open(struct inode *inode, struct file *filp)
{
     filp->private_data = pti_request_masterchannel(0);
     if (!filp->private_data)
             return -ENOMEM; 
     return 0;
}


...
> +
> +/**
> + * pti_char_release()-  Close a char channel to the PTI device. Part
> + * of the misc device implementation.
> + *
> + * @inode: Not used in this implementaiton.
> + * @filp:  Contains private_data that contains the master, channel
> + *         ID to be released by the PTI device.
> + *
> + * Returns:
> + *	always 0

Why not void then?


> +	pti_release_masterchannel(filp->private_data);
> +	return 0;
> +}
> +
> +/**
> + * pti_char_write()-  Write trace debugging data through the char
> + * interface to the PTI HW.  Part of the misc device implementation.
> + *
> + * @filp:  Contains private data which is used to obtain
> + *         master, channel write ID.
> + * @data:  trace data to be written.
> + * @len:   # of byte to write.
> + * @ppose: Not used in this function implementation.
> + *
> + * Returns:
> + *	int, # of bytes written
> + *	otherwise, error value
> + *
> + * Notes: From side discussions with Alan Cox and experimenting
> + * with PTI debug HW like Nokia's Fido box and Lauterbach
> + * devices, 8192 byte write buffer used by USER_COPY_SIZE was
> + * deemed an appropriate size for this type of usage with
> + * debugging HW.
> + */
> +static ssize_t pti_char_write(struct file *filp, const char __user *data,
> +			      size_t len, loff_t *ppose)
> +{
> +	struct pti_masterchannel *mc;
> +	void *kbuf;
> +	const char __user *tmp;
> +	size_t size = USER_COPY_SIZE, n = 0;

It would be nice to declare these two variables on two sepperate lines 
IMO.

> +
> +	tmp = data;
> +	mc = filp->private_data;
> +
> +	kbuf = kmalloc(size, GFP_KERNEL);
> +	if (kbuf == NULL)  {
> +		pr_err("%s(%d): buf allocation failed\n",
> +			__func__, __LINE__);
> +		return 0;

Shouldn't you be returning -ENOMEM here?

> +	}
> +
> +	do {
> +		if (len - n > USER_COPY_SIZE)
> +			size = USER_COPY_SIZE;
> +		else
> +			size = len - n;
> +
> +		if (copy_from_user(kbuf, tmp, size)) {
> +			kfree(kbuf);
> +			return n ? n : -EFAULT;
> +		}
> +
> +		pti_write_to_aperture(mc, kbuf, size);
> +		n  += size;
> +		tmp += size;
> +
> +	} while (len > n);
> +
> +	kfree(kbuf);
> +	kbuf = NULL;
> +

 kbuff is a local variable. What's the point in assigning NULL to it just 
before you return? Just get rid of that silly assignment.


...
> + * pti_char_release()-  Close a char channel to the PTI device. Part
> + * of the misc device implementation.
> + *
> + * @inode: Not used in this implementaiton.
> + * @filp:  Contains private_data that contains the master, channel
> + *         ID to be released by the PTI device.
> + *
> + * Returns:
> + *	always 0

So why not void?

...
> + * pti_console_setup()-  Initialize console variables used by the driver.
> + *
> + * @c:     Not used.
> + * @opts:  Not used.
> + *
> + * Returns:
> + *	always 0.

Why not void?


...
> + * pti_port_activate()- Used to start/initialize any items upon
> + * first opening of tty_port().
> + *
> + * @port- The tty port number of the PTI device.
> + * @tty-  The tty struct associated with this device.
> + *
> + * Returns:
> + *	always returns 0

Shouldn't it just return void then?


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

