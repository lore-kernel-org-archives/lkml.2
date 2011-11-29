Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1K2EuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 23:50:10 -0500
Received: from mga14.intel.com ([143.182.124.37]:10584 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab1K2EuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 23:50:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,589,1315206000"; 
   d="scan'208";a="80069288"
Message-ID: <4ED4647D.4060305@linux.intel.com>
Date: Tue, 29 Nov 2011 12:50:05 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Marco Stornelli <marco.stornelli@gmail.com>,
        Tony Luck <tony.luck@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] ramoops: use pstore interface
References: <20111128200951.GA3492@www.outflux.net>
In-Reply-To: <20111128200951.GA3492@www.outflux.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/11/29 4:09, Kees Cook 写道:
> Instead of using /dev/mem directly, use the common pstore infrastructure
> to handle Oops gathering and extraction.
>
> Signed-off-by: Kees Cook<keescook@chromium.org>
> ---
> This depends on the pstore changes waiting for -next in:
> http://git.kernel.org/?p=linux/kernel/git/aegl/linux.git;a=shortlog;h=refs/heads/next
> ---
>   Documentation/ramoops.txt |    8 +-
>   drivers/char/Kconfig      |    1 +
>   drivers/char/ramoops.c    |  206 ++++++++++++++++++++++++++++++++++-----------
>   3 files changed, 160 insertions(+), 55 deletions(-)
>
> diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
> index 8fb1ba7..a0b9d8e 100644
> --- a/Documentation/ramoops.txt
> +++ b/Documentation/ramoops.txt
> @@ -3,7 +3,7 @@ Ramoops oops/panic logger
>
>   Sergiu Iordache<sergiu@chromium.org>
>
> -Updated: 8 August 2011
> +Updated: 17 November 2011
>
>   0. Introduction
>
> @@ -71,6 +71,6 @@ timestamp and a new line. The dump then continues with the actual data.
>
>   4. Reading the data
>
> -The dump data can be read from memory (through /dev/mem or other means).
> -Getting the module parameters, which are needed in order to parse the data, can
> -be done through /sys/module/ramoops/parameters/* .
> +The dump data can be read from the pstore filesystem. The format for these
> +files is "dmesg-ramoops-N", where N is the record number in memory. To delete
> +a stored record from RAM, simply unlink the respective pstore file.

I think the definition of "mem_address" in the doc is not very clear. It is not 
a normal memory instead of a persistent RAM. I suggest adding more descriptions.
It's better if there is a real example.

> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 4364303..f166499 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -603,6 +603,7 @@ source "drivers/s390/char/Kconfig"
>   config RAMOOPS
>   	tristate "Log panic/oops to a RAM buffer"
>   	depends on HAS_IOMEM
> +	depends on PSTORE
>   	default n
>   	help
>   	  This enables panic and oops messages to be logged to a circular
> diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
> index 7c7f42a..c544213 100644
> --- a/drivers/char/ramoops.c
> +++ b/drivers/char/ramoops.c
> @@ -2,6 +2,7 @@
>    * RAM Oops/Panic logger
>    *
>    * Copyright (C) 2010 Marco Stornelli<marco.stornelli@gmail.com>
> + * Copyright (C) 2011 Kees Cook<keescook@chromium.org>
>    *
>    * This program is free software; you can redistribute it and/or
>    * modify it under the terms of the GNU General Public License
> @@ -24,7 +25,7 @@
>   #include<linux/kernel.h>
>   #include<linux/err.h>
>   #include<linux/module.h>
> -#include<linux/kmsg_dump.h>
> +#include<linux/pstore.h>
>   #include<linux/time.h>
>   #include<linux/err.h>
>   #include<linux/io.h>
> @@ -56,74 +57,154 @@ module_param(dump_oops, int, 0600);
>   MODULE_PARM_DESC(dump_oops,
>   		"set to 1 to dump oopses, 0 to only dump panics (default 1)");
>
> -static struct ramoops_context {
> -	struct kmsg_dumper dump;
> +struct ramoops_context {
>   	void *virt_addr;
>   	phys_addr_t phys_addr;
>   	unsigned long size;
> -	unsigned long record_size;
> +	size_t record_size;
>   	int dump_oops;
> -	int count;
> -	int max_count;
> -} oops_cxt;
> +	unsigned int count;
> +	unsigned int max_count;
> +	unsigned int read_count;
> +	struct pstore_info pstore;
> +};
>
>   static struct platform_device *dummy;
>   static struct ramoops_platform_data *dummy_data;
>
> -static void ramoops_do_dump(struct kmsg_dumper *dumper,
> -		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
> -		const char *s2, unsigned long l2)
> +static int ramoops_pstore_open(struct pstore_info *psi)
> +{
> +	struct ramoops_context *cxt = (struct ramoops_context *)psi->data;
> +
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
> +	if (cxt->read_count>= cxt->max_count)
> +		return -EINVAL;
> +	*id = cxt->read_count++;
> +	/* Only supports dmesg output so far. */
> +	*type = PSTORE_TYPE_DMESG;
> +	/* TODO(kees): Bogus time for the moment. */
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
> +
> +static int ramoops_pstore_write(enum pstore_type_id type,
> +				enum kmsg_dump_reason reason,
> +				u64 *id,
> +				unsigned int part,
> +				size_t size, struct pstore_info *psi)
>   {
> -	struct ramoops_context *cxt = container_of(dumper,
> -			struct ramoops_context, dump);
> -	unsigned long s1_start, s2_start;
> -	unsigned long l1_cpy, l2_cpy;
> -	int res, hdr_size;
> -	char *buf, *buf_orig;
> +	char *buf;
> +	size_t res;
>   	struct timeval timestamp;
> +	struct ramoops_context *cxt = (struct ramoops_context *)psi->data;
> +	size_t available = cxt->record_size;
>
> +	/* Only store dmesg dumps. */
> +	if (type != PSTORE_TYPE_DMESG)
> +		return -EINVAL;
> +
> +	/* Only store crash dumps. */
>   	if (reason != KMSG_DUMP_OOPS&&
>   	reason != KMSG_DUMP_PANIC&&
>   	reason != KMSG_DUMP_KEXEC)

As Andrew mentioned here (http://lkml.org/lkml/2011/11/28/495),
who should take this responsibility to fix this issue when conflicting

