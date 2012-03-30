Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023Ab2C3UyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:54:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34299 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab2C3UyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:54:14 -0400
Date: Fri, 30 Mar 2012 16:49:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        gregkh@linuxfoundation.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, X86 <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-doc@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [Xen-devel] [PATCH RFC V5 1/6] debugfs: Add support to print u32
 array in debugfs
Message-ID: <20120330204912.GA29329@phenom.dumpdata.com>
References: <20120323080503.14568.43092.sendpatchset@codeblue>
 <20120323080606.14568.31335.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120323080606.14568.31335.sendpatchset@codeblue>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4F761D61.009F,ss=1,re=-2.300,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 01:36:28PM +0530, Raghavendra K T wrote:
> From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 
> Move the code from Xen to debugfs to make the code common
> for other users as well.
> 
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Greg,

I was thinking to stick this patch in my queue, but I need your
OK since it touches fs/debugfs/file.c.

> ---
> diff --git a/arch/x86/xen/debugfs.c b/arch/x86/xen/debugfs.c
> index ef1db19..c8377fb 100644
> --- a/arch/x86/xen/debugfs.c
> +++ b/arch/x86/xen/debugfs.c
> @@ -19,107 +19,3 @@ struct dentry * __init xen_init_debugfs(void)
>  	return d_xen_debug;
>  }
>  
> -struct array_data
> -{
> -	void *array;
> -	unsigned elements;
> -};
> -
> -static int u32_array_open(struct inode *inode, struct file *file)
> -{
> -	file->private_data = NULL;
> -	return nonseekable_open(inode, file);
> -}
> -
> -static size_t format_array(char *buf, size_t bufsize, const char *fmt,
> -			   u32 *array, unsigned array_size)
> -{
> -	size_t ret = 0;
> -	unsigned i;
> -
> -	for(i = 0; i < array_size; i++) {
> -		size_t len;
> -
> -		len = snprintf(buf, bufsize, fmt, array[i]);
> -		len++;	/* ' ' or '\n' */
> -		ret += len;
> -
> -		if (buf) {
> -			buf += len;
> -			bufsize -= len;
> -			buf[-1] = (i == array_size-1) ? '\n' : ' ';
> -		}
> -	}
> -
> -	ret++;		/* \0 */
> -	if (buf)
> -		*buf = '\0';
> -
> -	return ret;
> -}
> -
> -static char *format_array_alloc(const char *fmt, u32 *array, unsigned array_size)
> -{
> -	size_t len = format_array(NULL, 0, fmt, array, array_size);
> -	char *ret;
> -
> -	ret = kmalloc(len, GFP_KERNEL);
> -	if (ret == NULL)
> -		return NULL;
> -
> -	format_array(ret, len, fmt, array, array_size);
> -	return ret;
> -}
> -
> -static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
> -			      loff_t *ppos)
> -{
> -	struct inode *inode = file->f_path.dentry->d_inode;
> -	struct array_data *data = inode->i_private;
> -	size_t size;
> -
> -	if (*ppos == 0) {
> -		if (file->private_data) {
> -			kfree(file->private_data);
> -			file->private_data = NULL;
> -		}
> -
> -		file->private_data = format_array_alloc("%u", data->array, data->elements);
> -	}
> -
> -	size = 0;
> -	if (file->private_data)
> -		size = strlen(file->private_data);
> -
> -	return simple_read_from_buffer(buf, len, ppos, file->private_data, size);
> -}
> -
> -static int xen_array_release(struct inode *inode, struct file *file)
> -{
> -	kfree(file->private_data);
> -
> -	return 0;
> -}
> -
> -static const struct file_operations u32_array_fops = {
> -	.owner	= THIS_MODULE,
> -	.open	= u32_array_open,
> -	.release= xen_array_release,
> -	.read	= u32_array_read,
> -	.llseek = no_llseek,
> -};
> -
> -struct dentry *xen_debugfs_create_u32_array(const char *name, umode_t mode,
> -					    struct dentry *parent,
> -					    u32 *array, unsigned elements)
> -{
> -	struct array_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
> -
> -	if (data == NULL)
> -		return NULL;
> -
> -	data->array = array;
> -	data->elements = elements;
> -
> -	return debugfs_create_file(name, mode, parent, data, &u32_array_fops);
> -}
> diff --git a/arch/x86/xen/debugfs.h b/arch/x86/xen/debugfs.h
> index 78d2549..12ebf33 100644
> --- a/arch/x86/xen/debugfs.h
> +++ b/arch/x86/xen/debugfs.h
> @@ -3,8 +3,4 @@
>  
>  struct dentry * __init xen_init_debugfs(void);
>  
> -struct dentry *xen_debugfs_create_u32_array(const char *name, umode_t mode,
> -					    struct dentry *parent,
> -					    u32 *array, unsigned elements);
> -
>  #endif /* _XEN_DEBUGFS_H */
> diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
> index 4926974..b74cebb 100644
> --- a/arch/x86/xen/spinlock.c
> +++ b/arch/x86/xen/spinlock.c
> @@ -314,7 +314,7 @@ static int __init xen_spinlock_debugfs(void)
>  	debugfs_create_u64("time_blocked", 0444, d_spin_debug,
>  			   &spinlock_stats.time_blocked);
>  
> -	xen_debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
> +	debugfs_create_u32_array("histo_blocked", 0444, d_spin_debug,
>  				     spinlock_stats.histo_spin_blocked, HISTO_BUCKETS + 1);
>  
>  	return 0;
> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index ef023ee..cb6cff3 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -20,6 +20,7 @@
>  #include <linux/namei.h>
>  #include <linux/debugfs.h>
>  #include <linux/io.h>
> +#include <linux/slab.h>
>  
>  static ssize_t default_read_file(struct file *file, char __user *buf,
>  				 size_t count, loff_t *ppos)
> @@ -528,6 +529,133 @@ struct dentry *debugfs_create_blob(const char *name, umode_t mode,
>  }
>  EXPORT_SYMBOL_GPL(debugfs_create_blob);
>  
> +struct array_data {
> +	void *array;
> +	u32 elements;
> +};
> +
> +static int u32_array_open(struct inode *inode, struct file *file)
> +{
> +	file->private_data = NULL;
> +	return nonseekable_open(inode, file);
> +}
> +
> +static size_t format_array(char *buf, size_t bufsize, const char *fmt,
> +			   u32 *array, u32 array_size)
> +{
> +	size_t ret = 0;
> +	u32 i;
> +
> +	for (i = 0; i < array_size; i++) {
> +		size_t len;
> +
> +		len = snprintf(buf, bufsize, fmt, array[i]);
> +		len++;	/* ' ' or '\n' */
> +		ret += len;
> +
> +		if (buf) {
> +			buf += len;
> +			bufsize -= len;
> +			buf[-1] = (i == array_size-1) ? '\n' : ' ';
> +		}
> +	}
> +
> +	ret++;		/* \0 */
> +	if (buf)
> +		*buf = '\0';
> +
> +	return ret;
> +}
> +
> +static char *format_array_alloc(const char *fmt, u32 *array,
> +						u32 array_size)
> +{
> +	size_t len = format_array(NULL, 0, fmt, array, array_size);
> +	char *ret;
> +
> +	ret = kmalloc(len, GFP_KERNEL);
> +	if (ret == NULL)
> +		return NULL;
> +
> +	format_array(ret, len, fmt, array, array_size);
> +	return ret;
> +}
> +
> +static ssize_t u32_array_read(struct file *file, char __user *buf, size_t len,
> +			      loff_t *ppos)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct array_data *data = inode->i_private;
> +	size_t size;
> +
> +	if (*ppos == 0) {
> +		if (file->private_data) {
> +			kfree(file->private_data);
> +			file->private_data = NULL;
> +		}
> +
> +		file->private_data = format_array_alloc("%u", data->array,
> +							      data->elements);
> +	}
> +
> +	size = 0;
> +	if (file->private_data)
> +		size = strlen(file->private_data);
> +
> +	return simple_read_from_buffer(buf, len, ppos,
> +					file->private_data, size);
> +}
> +
> +static int u32_array_release(struct inode *inode, struct file *file)
> +{
> +	kfree(file->private_data);
> +
> +	return 0;
> +}
> +
> +static const struct file_operations u32_array_fops = {
> +	.owner	 = THIS_MODULE,
> +	.open	 = u32_array_open,
> +	.release = u32_array_release,
> +	.read	 = u32_array_read,
> +	.llseek  = no_llseek,
> +};
> +
> +/**
> + * debugfs_create_u32_array - create a debugfs file that is used to read u32
> + * array.
> + * @name: a pointer to a string containing the name of the file to create.
> + * @mode: the permission that the file should have.
> + * @parent: a pointer to the parent dentry for this file.  This should be a
> + *          directory dentry if set.  If this parameter is %NULL, then the
> + *          file will be created in the root of the debugfs filesystem.
> + * @array: u32 array that provides data.
> + * @elements: total number of elements in the array.
> + *
> + * This function creates a file in debugfs with the given name that exports
> + * @array as data. If the @mode variable is so set it can be read from.
> + * Writing is not supported. Seek within the file is also not supported.
> + * Once array is created its size can not be changed.
> + *
> + * The function returns a pointer to dentry on success. If debugfs is not
> + * enabled in the kernel, the value -%ENODEV will be returned.
> + */
> +struct dentry *debugfs_create_u32_array(const char *name, umode_t mode,
> +					    struct dentry *parent,
> +					    u32 *array, u32 elements)
> +{
> +	struct array_data *data = kmalloc(sizeof(*data), GFP_KERNEL);
> +
> +	if (data == NULL)
> +		return NULL;
> +
> +	data->array = array;
> +	data->elements = elements;
> +
> +	return debugfs_create_file(name, mode, parent, data, &u32_array_fops);
> +}
> +EXPORT_SYMBOL_GPL(debugfs_create_u32_array);
> +
>  #ifdef CONFIG_HAS_IOMEM
>  
>  /*
> diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
> index 6169c26..5cb4435 100644
> --- a/include/linux/debugfs.h
> +++ b/include/linux/debugfs.h
> @@ -93,6 +93,10 @@ struct dentry *debugfs_create_regset32(const char *name, mode_t mode,
>  int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
>  			 int nregs, void __iomem *base, char *prefix);
>  
> +struct dentry *debugfs_create_u32_array(const char *name, umode_t mode,
> +					struct dentry *parent,
> +					u32 *array, u32 elements);
> +
>  bool debugfs_initialized(void);
>  
>  #else
> @@ -219,6 +223,13 @@ static inline bool debugfs_initialized(void)
>  	return false;
>  }
>  
> +struct dentry *debugfs_create_u32_array(const char *name, umode_t mode,
> +					struct dentry *parent,
> +					u32 *array, u32 elements)
> +{
> +	return ERR_PTR(-ENODEV);
> +}
> +
>  #endif
>  
>  #endif
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
