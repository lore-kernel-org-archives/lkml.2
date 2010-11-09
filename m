Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0KIQ5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:57:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab0KIQ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:57:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: cdhmanning@gmail.com
Subject: Re: [PATCH 9/9] Add yaffs kernel glue
Date: Tue, 9 Nov 2010 17:57:04 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1288803204-3849-1-git-send-email-cdhmanning@gmail.com> <1288803204-3849-10-git-send-email-cdhmanning@gmail.com>
In-Reply-To: <1288803204-3849-10-git-send-email-cdhmanning@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011091757.04632.arnd@arndb.de>
X-Provags-ID: V02:K0:VgF+LIuB/Ov5/k32olzRxdBYh9dldh31cRp9me6+sFp
 Q6XnHUtsKENy+JvR6NMFd+AH5owwl3NKBt2uQyk+pL21D9jeBk
 xGZR/c4EdzhsyBNcTUJ0BlYPqBjBL8ag+sND1mdwgePQ9JOxiN
 DZQA9QBGPpos/fviDD8daAj6Vz9JltPVLtfH12gSIpDUbAr8xZ
 VWvn+qlMPF77hFomUx4cA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 November 2010, cdhmanning@gmail.com wrote:

> +unsigned int yaffs_trace_mask = YAFFS_TRACE_BAD_BLOCKS | YAFFS_TRACE_ALWAYS;
> +unsigned int yaffs_wr_attempts = YAFFS_WR_ATTEMPTS;
> +unsigned int yaffs_auto_checkpoint = 1;
> +unsigned int yaffs_gc_control = 1;
> +unsigned int yaffs_bg_enable = 1;
> +
> +/* Module Parameters */
> +module_param(yaffs_trace_mask, uint, 0644);
> +module_param(yaffs_wr_attempts, uint, 0644);
> +module_param(yaffs_auto_checkpoint, uint, 0644);
> +module_param(yaffs_gc_control, uint, 0644);
> +module_param(yaffs_bg_enable, uint, 0644);

Should some of these be per-mount options rather than global settings?

> +static void yaffs_put_super(struct super_block *sb);
> +
> +static ssize_t yaffs_file_write(struct file *f, const char *buf, size_t n,
> +				loff_t * pos);
> +static ssize_t yaffs_hold_space(struct file *f);
> +static void yaffs_release_space(struct file *f);
> +
> +static int yaffs_file_flush(struct file *file, fl_owner_t id);

A good rule in the kernel coding style is to avoid forward declarations
for static functions by ordering the code in call order. This makes it
clear that you do not have recursions and it is the order that people
expect when reading the code.

> +#ifdef CONFIG_YAFFS_XATTR
> +int yaffs_setxattr(struct dentry *dentry, const char *name,
> +		   const void *value, size_t size, int flags);
> +ssize_t yaffs_getxattr(struct dentry *dentry, const char *name, void *buff,
> +		       size_t size);
> +int yaffs_removexattr(struct dentry *dentry, const char *name);
> +ssize_t yaffs_listxattr(struct dentry *dentry, char *buff, size_t size);
> +#endif

More importantly, do not put declarations for global functions or extern
declarations for variables into C files. These really belong into headers
in order ensure that the caller and the callee agree on the type.

By convention, do not enclose declarations in #ifdef.

> +static struct address_space_operations yaffs_file_address_operations = {
> +	.readpage = yaffs_readpage,
> +	.writepage = yaffs_writepage,
> +	.write_begin = yaffs_write_begin,
> +	.write_end = yaffs_write_end,
> +};
> +
> +static const struct file_operations yaffs_file_operations = {
> +	.read = do_sync_read,
> +	.write = do_sync_write,

These and other *_operations definitions will naturally move to the
end of the file then, as they are in most file systems.

> +static void yaffs_gross_lock(struct yaffs_dev *dev)
> +{
> +	T(YAFFS_TRACE_LOCK, (TSTR("yaffs locking %p\n"), current));
> +	mutex_lock(&(yaffs_dev_to_lc(dev)->gross_lock));
> +	T(YAFFS_TRACE_LOCK, (TSTR("yaffs locked %p\n"), current));
> +}

I'd recommend removing all your custom trace logic. If you want
to have tracing for important events, use the trace point infrastructure
we have in the kernel, which integrates much better with existing tools.

For simple debugging messages, use pr_debug or dev_dbg.

> +static loff_t yaffs_dir_llseek(struct file *file, loff_t offset, int origin)
> +{
> +	long long retval;
> +
> +	lock_kernel();

Sorry, but lock_kernel() is really getting removed now, you have to
change all users to other, more local, locks. llseek typically uses
inode->i_mutex.

> +#ifdef CONFIG_YAFFS_DISABLE_LAZY_LOAD
> +	param->disable_lazy_load = 1;
> +#endif
> +#ifdef CONFIG_YAFFS_XATTR
> +	param->enable_xattr = 1;
> +#endif
> +	if (options.lazy_loading_overridden)
> +		param->disable_lazy_load = !options.lazy_loading_enabled;
> +
> +#ifdef CONFIG_YAFFS_DISABLE_TAGS_ECC
> +	param->no_tags_ecc = 1;
> +#endif
> +
> +#ifdef CONFIG_YAFFS_DISABLE_BACKGROUND
> +#else
> +	param->defered_dir_update = 1;
> +#endif
> +
> +	if (options.tags_ecc_overridden)
> +		param->no_tags_ecc = !options.tags_ecc_on;
> +
> +#ifdef CONFIG_YAFFS_EMPTY_LOST_AND_FOUND
> +	param->empty_lost_n_found = 1;
> +#endif
> +
> +#ifdef CONFIG_YAFFS_DISABLE_BLOCK_REFRESHING
> +	param->refresh_period = 0;
> +#else
> +	param->refresh_period = 500;
> +#endif
> +
> +#ifdef CONFIG_YAFFS_ALWAYS_CHECK_CHUNK_ERASED
> +	param->always_check_erased = 1;
> +#endif

Do you really need this many compile time options? How do you expect
a distribution to find reasonable settings for these?

> +static int yaffs_stats_proc_read(char *page,
> +				 char **start,
> +				 off_t offset, int count, int *eof, void *data)
> +{
> +	struct list_head *item;
> +	char *buf = page;
> +	int n = 0;
> +
> +	mutex_lock(&yaffs_context_lock);
> +
> +	/* Locate and print the Nth entry.  Order N-squared but N is small. */
> +	list_for_each(item, &yaffs_context_list) {
> +		struct yaffs_linux_context *dc =
> +		    list_entry(item, struct yaffs_linux_context, context_list);
> +		struct yaffs_dev *dev = dc->dev;
> +
> +		int erased_chunks;
> +
> +		erased_chunks =
> +		    dev->n_erased_blocks * dev->param.chunks_per_block;
> +
> +		buf += sprintf(buf, "%d, %d, %d, %u, %u, %u, %u\n",
> +			       n, dev->n_free_chunks, erased_chunks,
> +			       dev->bg_gcs, dev->oldest_dirty_gc_count,
> +			       dev->n_obj, dev->n_tnodes);
> +	}
> +	mutex_unlock(&yaffs_context_lock);
> +
> +	return buf - page < count ? buf - page : count;
> +}

A debugging file like this does not belong into procfs. You might argue
for a debugfs file, ideally one per mount, but not having it initially
might be even better.

> +static struct {
> +	char *mask_name;
> +	unsigned mask_bitfield;
> +} mask_flags[] = {
> +	{
> +	"allocate", YAFFS_TRACE_ALLOCATE}, {
> +	"always", YAFFS_TRACE_ALWAYS}, {
> +	"background", YAFFS_TRACE_BACKGROUND}, {
> +	"bad_blocks", YAFFS_TRACE_BAD_BLOCKS}, {
> +	"buffers", YAFFS_TRACE_BUFFERS}, {
> +	"bug", YAFFS_TRACE_BUG}, {
> +	"checkpt", YAFFS_TRACE_CHECKPOINT}, {
> +	"deletion", YAFFS_TRACE_DELETION}, {
> +	"erase", YAFFS_TRACE_ERASE}, {
> +	"error", YAFFS_TRACE_ERROR}, {
> +	"gc_detail", YAFFS_TRACE_GC_DETAIL}, {
> +	"gc", YAFFS_TRACE_GC}, {
> +	"lock", YAFFS_TRACE_LOCK}, {
> +	"mtd", YAFFS_TRACE_MTD}, {
> +	"nandaccess", YAFFS_TRACE_NANDACCESS}, {
> +	"os", YAFFS_TRACE_OS}, {
> +	"scan_debug", YAFFS_TRACE_SCAN_DEBUG}, {
> +	"scan", YAFFS_TRACE_SCAN}, {
> +	"tracing", YAFFS_TRACE_TRACING}, {
> +	"sync", YAFFS_TRACE_SYNC}, {
> +	"write", YAFFS_TRACE_WRITE}, {
> +	"verify", YAFFS_TRACE_VERIFY}, {
> +	"verify_nand", YAFFS_TRACE_VERIFY_NAND}, {
> +	"verify_full", YAFFS_TRACE_VERIFY_FULL}, {
> +	"verify_all", YAFFS_TRACE_VERIFY_ALL}, {
> +	"all", 0xffffffff}, {
> +	"none", 0}, {
> +NULL, 0},};

> +static int yaffs_proc_write_trace_options(struct file *file, const char *buf,
> +					  unsigned long count, void *data)

I'd say the entire /proc tracing interface should go away. You can probably
just rip it all out now, and add proper ftrace support at a later stage.

	Arnd
