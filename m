Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2AQV7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 16:59:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2AQV7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 16:59:22 -0500
Date: Tue, 17 Jan 2012 13:59:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ramoops: use pstore interface
Message-Id: <20120117135921.3f68701e.akpm@linux-foundation.org>
In-Reply-To: <20120107171516.GE2618@outflux.net>
References: <20120107171516.GE2618@outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jan 2012 09:15:16 -0800
Kees Cook <keescook@chromium.org> wrote:

> Instead of using /dev/mem directly, use the common pstore infrastructure
> to handle Oops gathering and extraction.

um, why?  This changelog provides no reason for anyone to apply the
patch!

>
> ...
>
> -static void ramoops_do_dump(struct kmsg_dumper *dumper,
> -		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
> -		const char *s2, unsigned long l2)
> +static int ramoops_pstore_open(struct pstore_info *psi)
> +{
> +	struct ramoops_context *cxt = (struct ramoops_context *)psi->data;

Unneeded and undesirable cast of void*.  Multiple instances of this.

> +	cxt->read_count = 0;
> +	return 0;
> +}
> +
> +static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
> +				   struct timespec *time,
> +				   char **buf,
> +				   struct pstore_info *psi)
> +{
> +	ssize_t size;
> +	char *rambuf;
> +	struct ramoops_context *cxt = (struct ramoops_context *)psi->data;
> +
> +	if (cxt->read_count >= cxt->max_count)
> +		return -EINVAL;
> +	*id = cxt->read_count++;
> +	/* Only supports dmesg output so far. */
> +	*type = PSTORE_TYPE_DMESG;
> +	/* TODO(kees): Bogus time for the moment. */

Is this hard to fix now?

> +	time->tv_sec = 0;
> +	time->tv_nsec = 0;
> +
> +	rambuf = cxt->virt_addr + (*id * cxt->record_size);
> +	size = strnlen(rambuf, cxt->record_size);
> +	*buf = kmalloc(size, GFP_KERNEL);
> +	if (*buf == NULL)
> +		return -ENOMEM;
> +	memcpy(*buf, rambuf, size);
> +
> +	return size;
> +}

Note that pstore_get_records() will treat the -ve errno returns from
->read() in the same manner as EOF.  IOW, your error codes will be
dropped on the floor.  This appears to be a bug in pstore_get_records().

> +static int ramoops_pstore_write(enum pstore_type_id type,
> +				enum kmsg_dump_reason reason,
> +				u64 *id,
> +				unsigned int part,
> +				size_t size, struct pstore_info *psi)
>  {
> -	struct ramoops_context *cxt = container_of(dumper,
> -			struct ramoops_context, dump);
> -	unsigned long s1_start, s2_start;
> -	unsigned long l1_cpy, l2_cpy;
> -	int res, hdr_size;
> -	char *buf, *buf_orig;
> +	char *buf;
> +	size_t res;
>  	struct timeval timestamp;
> +	struct ramoops_context *cxt = (struct ramoops_context *)psi->data;
> +	size_t available = cxt->record_size;
>  
> +	/* Only store dmesg dumps. */
> +	if (type != PSTORE_TYPE_DMESG)
> +		return -EINVAL;
> +
> +	/* Only store crash dumps. */
>  	if (reason != KMSG_DUMP_OOPS &&
> -	    reason != KMSG_DUMP_PANIC &&
> -	    reason != KMSG_DUMP_KEXEC)
> -		return;
> +	    reason != KMSG_DUMP_PANIC)
> +		return -EINVAL;
>  
>  	/* Only dump oopses if dump_oops is set */
>  	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)

The above three comments describe what the code does, which was
obvious.  They failed to describe why it does this, which was
unobvious.  Sigh.

> -		return;
> +		return -EINVAL;
> +
> +	/* Explicitly only take the first part of any new crash.
> +	 * If our buffer is larger than kmsg_bytes, this can never happen,
> +	 * and if our buffer is smaller than kmsg_bytes, we don't want the
> +	 * report split across multiple records. */
> +	if (part != 1)
> +		return -ENOSPC;
>  
>  	buf = cxt->virt_addr + (cxt->count * cxt->record_size);
> -	buf_orig = buf;
>  
> -	memset(buf, '\0', cxt->record_size);
>  	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
>  	buf += res;
> +	available -= res;
> +
>  	do_gettimeofday(&timestamp);
>
> ...
>

