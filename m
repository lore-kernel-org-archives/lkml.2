Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063Ab0J0MVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:21:38 -0400
Received: from exprod5og102.obsmtp.com ([64.18.0.143]:35002 "EHLO
	exprod5og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab0J0MVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:21:37 -0400
Message-ID: <4CC81900.5070508@ge.com>
Date: Wed, 27 Oct 2010 13:20:16 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 16/30] staging/vme_user: mark user-space buffers with
 __user
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-17-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-17-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 12:21:35.0059 (UTC) FILETIME=[7F107230:01CB75D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:11, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/devices/vme_user.c |   25 +++++++++++--------------
>  1 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index ead30d2..a7b97be 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -129,8 +129,8 @@ static const int type[VME_DEVS] = {	MASTER_MINOR,	MASTER_MINOR,
>  
>  static int vme_user_open(struct inode *, struct file *);
>  static int vme_user_release(struct inode *, struct file *);
> -static ssize_t vme_user_read(struct file *, char *, size_t, loff_t *);
> -static ssize_t vme_user_write(struct file *, const char *, size_t, loff_t *);
> +static ssize_t vme_user_read(struct file *, char __user *, size_t, loff_t *);
> +static ssize_t vme_user_write(struct file *, const char __user *, size_t, loff_t *);
>  static loff_t vme_user_llseek(struct file *, loff_t, int);
>  static long vme_user_unlocked_ioctl(struct file *, unsigned int, unsigned long);
>  
> @@ -246,7 +246,7 @@ static ssize_t resource_to_user(int minor, char __user *buf, size_t count,
>   * page) transfers will lock the user space buffer into memory and then
>   * transfer the data directly from the user space buffers out to VME.
>   */
> -static ssize_t resource_from_user(unsigned int minor, const char *buf,
> +static ssize_t resource_from_user(unsigned int minor, const char __user *buf,
>  	size_t count, loff_t *ppos)
>  {
>  	ssize_t retval;
> @@ -293,7 +293,7 @@ static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
>  	return retval;
>  }
>  
> -static ssize_t buffer_from_user(unsigned int minor, const char *buf,
> +static ssize_t buffer_from_user(unsigned int minor, const char __user *buf,
>  	size_t count, loff_t *ppos)
>  {
>  	void *image_ptr;
> @@ -312,7 +312,7 @@ static ssize_t buffer_from_user(unsigned int minor, const char *buf,
>  	return retval;
>  }
>  
> -static ssize_t vme_user_read(struct file *file, char *buf, size_t count,
> +static ssize_t vme_user_read(struct file *file, char __user *buf, size_t count,
>  			loff_t *ppos)
>  {
>  	unsigned int minor = MINOR(file->f_dentry->d_inode->i_rdev);
> @@ -356,7 +356,7 @@ static ssize_t vme_user_read(struct file *file, char *buf, size_t count,
>  	return retval;
>  }
>  
> -static ssize_t vme_user_write(struct file *file, const char *buf, size_t count,
> +static ssize_t vme_user_write(struct file *file, const char __user *buf, size_t count,
>  			 loff_t *ppos)
>  {
>  	unsigned int minor = MINOR(file->f_dentry->d_inode->i_rdev);
> @@ -455,6 +455,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
>  	unsigned int minor = MINOR(inode->i_rdev);
>  	int retval;
>  	dma_addr_t pci_addr;
> +	void __user *argp = (void __user *)arg;
>  
>  	statistics.ioctls++;
>  
> @@ -474,8 +475,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
>  				&master.size, &master.aspace,
>  				&master.cycle, &master.dwidth);
>  
> -			copied = copy_to_user((char *)arg, &master,
> -				sizeof(struct vme_master));
> +			copied = copy_to_user(argp, &master, sizeof(struct vme_master));
>  			if (copied != 0) {
>  				printk(KERN_WARNING "Partial copy to "
>  					"userspace\n");
> @@ -487,8 +487,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
>  
>  		case VME_SET_MASTER:
>  
> -			copied = copy_from_user(&master, (char *)arg,
> -				sizeof(master));
> +			copied = copy_from_user(&master, argp, sizeof(master));
>  			if (copied != 0) {
>  				printk(KERN_WARNING "Partial copy from "
>  					"userspace\n");
> @@ -518,8 +517,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
>  				&slave.size, &pci_addr, &slave.aspace,
>  				&slave.cycle);
>  
> -			copied = copy_to_user((char *)arg, &slave,
> -				sizeof(struct vme_slave));
> +			copied = copy_to_user(argp, &slave, sizeof(struct vme_slave));
>  			if (copied != 0) {
>  				printk(KERN_WARNING "Partial copy to "
>  					"userspace\n");
> @@ -531,8 +529,7 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
>  
>  		case VME_SET_SLAVE:
>  
> -			copied = copy_from_user(&slave, (char *)arg,
> -				sizeof(slave));
> +			copied = copy_from_user(&slave, argp, sizeof(slave));
>  			if (copied != 0) {
>  				printk(KERN_WARNING "Partial copy from "
>  					"userspace\n");


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
