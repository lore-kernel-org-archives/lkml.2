Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1KPWUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:20:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab1KPWUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:20:36 -0500
Date: Wed, 16 Nov 2011 17:20:28 -0500
From: Don Zickus <dzickus@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>, Mike Waychison <mikew@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH v2] pstore: pass allocated memory region back to caller
Message-ID: <20111116222028.GK8685@redhat.com>
References: <20111116211329.GA8328@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116211329.GA8328@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 01:13:29PM -0800, Kees Cook wrote:
> The buf_lock cannot be held while populating the inodes, so make the backend
> pass forward an allocated and filled buffer instead. This solves the following
> backtrace. The effect is that "buf" is only ever used to notify the backends
> that something was written to it, and shouldn't be used in the read path.
> 
> To replace the buf_lock during the read path, isolate the open/read/close
> loop with a separate mutex to maintain serialized access to the backend.

This is an interesting approach.  But are we leaving psinfo data exposed
when you have a reader and writer at the same time?

I was also trying to figure out if we managed to pass giant blobs of data down
to the backend on the writer side too (instead of breaking it up) if that
could relieve some lock pressure too.

Cheers,
Don


> 
> [   59.691019] BUG: sleeping function called from invalid context at .../mm/slub.c:847
> [   59.691019] in_atomic(): 0, irqs_disabled(): 1, pid: 1819, name: mount
> [   59.691019] Pid: 1819, comm: mount Not tainted 3.0.8 #1
> [   59.691019] Call Trace:
> [   59.691019]  [<810252d5>] __might_sleep+0xc3/0xca
> [   59.691019]  [<810a26e6>] kmem_cache_alloc+0x32/0xf3
> [   59.691019]  [<810b53ac>] ? __d_lookup_rcu+0x6f/0xf4
> [   59.691019]  [<810b68b1>] alloc_inode+0x2a/0x64
> [   59.691019]  [<810b6903>] new_inode+0x18/0x43
> [   59.691019]  [<81142447>] pstore_get_inode.isra.1+0x11/0x98
> [   59.691019]  [<81142623>] pstore_mkfile+0xae/0x26f
> [   59.691019]  [<810a2a66>] ? kmem_cache_free+0x19/0xb1
> [   59.691019]  [<8116c821>] ? ida_get_new_above+0x140/0x158
> [   59.691019]  [<811708ea>] ? __init_rwsem+0x1e/0x2c
> [   59.691019]  [<810b67e8>] ? inode_init_always+0x111/0x1b0
> [   59.691019]  [<8102127e>] ? should_resched+0xd/0x27
> [   59.691019]  [<8137977f>] ? _cond_resched+0xd/0x21
> [   59.691019]  [<81142abf>] pstore_get_records+0x52/0xa7
> [   59.691019]  [<8114254b>] pstore_fill_super+0x7d/0x91
> [   59.691019]  [<810a7ff5>] mount_single+0x46/0x82
> [   59.691019]  [<8114231a>] pstore_mount+0x15/0x17
> [   59.691019]  [<811424ce>] ? pstore_get_inode.isra.1+0x98/0x98
> [   59.691019]  [<810a8199>] mount_fs+0x5a/0x12d
> [   59.691019]  [<810b9174>] ? alloc_vfsmnt+0xa4/0x14a
> [   59.691019]  [<810b9474>] vfs_kern_mount+0x4f/0x7d
> [   59.691019]  [<810b9d7e>] do_kern_mount+0x34/0xb2
> [   59.691019]  [<810bb15f>] do_mount+0x5fc/0x64a
> [   59.691019]  [<810912fb>] ? strndup_user+0x2e/0x3f
> [   59.691019]  [<810bb3cb>] sys_mount+0x66/0x99
> [   59.691019]  [<8137b537>] sysenter_do_call+0x12/0x26
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>  - diffed on top of https://lkml.org/lkml/2011/11/16/342
>  - merged the backend changes for bisect sanity
> 
>  drivers/acpi/apei/erst.c   |   31 ++++++++++++++++++++++---------
>  drivers/firmware/efivars.c |    9 +++++++--
>  fs/pstore/platform.c       |   13 ++++++++-----
>  include/linux/pstore.h     |    4 +++-
>  4 files changed, 40 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> index 3616c67..6a9e3ba 100644
> --- a/drivers/acpi/apei/erst.c
> +++ b/drivers/acpi/apei/erst.c
> @@ -932,7 +932,8 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
>  static int erst_open_pstore(struct pstore_info *psi);
>  static int erst_close_pstore(struct pstore_info *psi);
>  static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
> -			   struct timespec *time, struct pstore_info *psi);
> +			   struct timespec *time, char **buf,
> +			   struct pstore_info *psi);
>  static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
>  		       u64 *id, unsigned int part,
>  		       size_t size, struct pstore_info *psi);
> @@ -987,17 +988,23 @@ static int erst_close_pstore(struct pstore_info *psi)
>  }
>  
>  static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
> -			   struct timespec *time, struct pstore_info *psi)
> +			   struct timespec *time, char **buf,
> +			   struct pstore_info *psi)
>  {
>  	int rc;
>  	ssize_t len = 0;
>  	u64 record_id;
> -	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
> -					(erst_info.buf - sizeof(*rcd));
> +	struct cper_pstore_record *rcd;
> +	size_t rcd_len = sizeof(*rcd) + erst_info.bufsize;
>  
>  	if (erst_disable)
>  		return -ENODEV;
>  
> +	rcd = kmalloc(rcd_len, GFP_KERNEL);
> +	if (!rcd) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
>  skip:
>  	rc = erst_get_record_id_next(&reader_pos, &record_id);
>  	if (rc)
> @@ -1005,22 +1012,27 @@ skip:
>  
>  	/* no more record */
>  	if (record_id == APEI_ERST_INVALID_RECORD_ID) {
> -		rc = -1;
> +		rc = -EINVAL;
>  		goto out;
>  	}
>  
> -	len = erst_read(record_id, &rcd->hdr, sizeof(*rcd) +
> -			erst_info.bufsize);
> +	len = erst_read(record_id, &rcd->hdr, rcd_len);
>  	/* The record may be cleared by others, try read next record */
>  	if (len == -ENOENT)
>  		goto skip;
> -	else if (len < 0) {
> -		rc = -1;
> +	else if (len < sizeof(*rcd)) {
> +		rc = -EIO;
>  		goto out;
>  	}
>  	if (uuid_le_cmp(rcd->hdr.creator_id, CPER_CREATOR_PSTORE) != 0)
>  		goto skip;
>  
> +	*buf = kmalloc(len, GFP_KERNEL);
> +	if (*buf == NULL) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +	memcpy(*buf, rcd->data, len - sizeof(*rcd));
>  	*id = record_id;
>  	if (uuid_le_cmp(rcd->sec_hdr.section_type,
>  			CPER_SECTION_TYPE_DMESG) == 0)
> @@ -1038,6 +1050,7 @@ skip:
>  	time->tv_nsec = 0;
>  
>  out:
> +	kfree(rcd);
>  	return (rc < 0) ? rc : (len - sizeof(*rcd));
>  }
>  
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index f67ddfb..0a53a05 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -457,7 +457,8 @@ static int efi_pstore_close(struct pstore_info *psi)
>  }
>  
>  static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
> -			       struct timespec *timespec, struct pstore_info *psi)
> +			       struct timespec *timespec,
> +			       char **buf, struct pstore_info *psi)
>  {
>  	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
>  	struct efivars *efivars = psi->data;
> @@ -478,7 +479,11 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>  				timespec->tv_nsec = 0;
>  				get_var_data_locked(efivars, &efivars->walk_entry->var);
>  				size = efivars->walk_entry->var.DataSize;
> -				memcpy(psi->buf, efivars->walk_entry->var.Data, size);
> +				*buf = kmalloc(size, GFP_KERNEL);
> +				if (*buf == NULL)
> +					return -ENOMEM;
> +				memcpy(*buf, efivars->walk_entry->var.Data,
> +				       size);
>  				efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
>  					           struct efivar_entry, list);
>  				return size;
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index b22322f..f146d89 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -167,6 +167,7 @@ int pstore_register(struct pstore_info *psi)
>  	}
>  
>  	psinfo = psi;
> +	mutex_init(&psinfo->read_mutex);
>  	spin_unlock(&pstore_lock);
>  
>  	if (owner && !try_module_get(owner)) {
> @@ -195,30 +196,32 @@ EXPORT_SYMBOL_GPL(pstore_register);
>  void pstore_get_records(int quiet)
>  {
>  	struct pstore_info *psi = psinfo;
> +	char			*buf = NULL;
>  	ssize_t			size;
>  	u64			id;
>  	enum pstore_type_id	type;
>  	struct timespec		time;
>  	int			failed = 0, rc;
> -	unsigned long		flags;
>  
>  	if (!psi)
>  		return;
>  
> -	spin_lock_irqsave(&psinfo->buf_lock, flags);
> +	mutex_lock(&psi->read_mutex);
>  	rc = psi->open(psi);
>  	if (rc)
>  		goto out;
>  
> -	while ((size = psi->read(&id, &type, &time, psi)) > 0) {
> -		rc = pstore_mkfile(type, psi->name, id, psi->buf, (size_t)size,
> +	while ((size = psi->read(&id, &type, &time, &buf, psi)) > 0) {
> +		rc = pstore_mkfile(type, psi->name, id, buf, (size_t)size,
>  				  time, psi);
> +		kfree(buf);
> +		buf = NULL;
>  		if (rc && (rc != -EEXIST || !quiet))
>  			failed++;
>  	}
>  	psi->close(psi);
>  out:
> -	spin_unlock_irqrestore(&psinfo->buf_lock, flags);
> +	mutex_unlock(&psi->read_mutex);
>  
>  	if (failed)
>  		printk(KERN_WARNING "pstore: failed to load %d record(s) from '%s'\n",
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> index b38ddf9..e1461e1 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -38,10 +38,12 @@ struct pstore_info {
>  	spinlock_t	buf_lock;	/* serialize access to 'buf' */
>  	char		*buf;
>  	size_t		bufsize;
> +	struct mutex	read_mutex;	/* serialize open/read/close */
>  	int		(*open)(struct pstore_info *psi);
>  	int		(*close)(struct pstore_info *psi);
>  	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
> -			struct timespec *time, struct pstore_info *psi);
> +			struct timespec *time, char **buf,
> +			struct pstore_info *psi);
>  	int		(*write)(enum pstore_type_id type,
>  			enum kmsg_dump_reason reason, u64 *id,
>  			unsigned int part, size_t size, struct pstore_info *psi);
> -- 
> 1.7.0.4
> 
