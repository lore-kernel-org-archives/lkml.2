Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab1GASOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:14:08 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64928 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1GASOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:14:05 -0400
Message-ID: <4E0E0D03.2080203@gmail.com>
Date: Fri, 01 Jul 2011 20:08:03 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sergiu Iordache <sergiu@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] char drivers: ramoops debugfs entry
References: <1309483720-1407-1-git-send-email-sergiu@chromium.org> <1309483720-1407-4-git-send-email-sergiu@chromium.org>
In-Reply-To: <1309483720-1407-4-git-send-email-sergiu@chromium.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/07/2011 03:28, Sergiu Iordache ha scritto:
> While ramoops writes to ram, accessing the dump requires using /dev/mem
> and knowing the memory location (or a similar solution). This patch
> provides a debugfs interface through which the respective memory
> area can be easily accessed. It also adds an entry to expose the record
> size which must be used to divide the memory area into individual dumps
> and a dump count entry.
>

Good.

> The entries added are:
> /sys/kernel/debug/ramoops/full - memory dump of the whole reserved area.
> /sys/kernel/debug/ramoops/count - number of dumps currently present
> (will be 0 after a restart).

Is this count really needed?

>
> Change-Id: Ifbab9af833be9ee0bc1c33bc9871f2fc0eb9d228
> Signed-off-by: Sergiu Iordache<sergiu@chromium.org>
> ---
> The patch was built on the 2.6.38 kernel and is based on the following
> patches which were applied from the mmotm tree:
> ramoops-add-new-line-to-each-print
> ramoops-use-module-parameters-instead-of-platform-data-if-not-available
> ramoops-use-module-parameters-instead-of-platform-data-if-not-available-checkpatch-fixes
>
>   drivers/char/ramoops.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 101 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
> index f34077e..9c0e30e 100644
> --- a/drivers/char/ramoops.c
> +++ b/drivers/char/ramoops.c
> @@ -30,9 +30,15 @@
>   #include<linux/platform_device.h>
>   #include<linux/slab.h>
>   #include<linux/ramoops.h>
> +#include<linux/uaccess.h>
> +#include<linux/debugfs.h>
>
>   #define RAMOOPS_KERNMSG_HDR "===="
>   #define MIN_MEM_SIZE 4096UL
> +#define RAMOOPS_DIR "ramoops"
> +#define RAMOOPS_FULL "full"
> +#define RAMOOPS_RS "record_size"
> +#define RAMOOPS_COUNT "count"
>
>   static ulong record_size = 4096UL;
>   module_param(record_size, ulong, 0400);
> @@ -67,6 +73,39 @@ static struct ramoops_context {
>
>   static struct platform_device *dummy;
>   static struct ramoops_platform_data *dummy_data;
> +static DEFINE_MUTEX(ramoops_mutex);
> +
> +/* Debugfs entries for ramoops */
> +static struct dentry *ramoops_dir, *ramoops_full_entry, *ramoops_rs_entry,
> +				*ramoops_count_entry;
> +
> +/* Entry to have access to the whole memory area */
> +static ssize_t ramoops_read_full(struct file *file, char __user *buf,
> +					size_t count, loff_t *ppos)
> +{
> +	struct ramoops_context *cxt =&oops_cxt;
> +
> +	mutex_lock(&ramoops_mutex);
> +	if (*ppos + count>  cxt->size)
> +		count = cxt->size - *ppos;
> +	if (*ppos>  cxt->size) {
> +		count = 0;
> +		goto out;
> +	}
> +	if (copy_to_user(buf, cxt->virt_addr + *ppos, count)) {
> +		count = -EFAULT;
> +		goto out;
> +	}
> +	*ppos += count;
> +
> +out:
> +	mutex_unlock(&ramoops_mutex);
> +	return count;
> +}
> +
> +static const struct file_operations ramoops_full_fops = {
> +	.read = ramoops_read_full,
> +};
>
>   static void ramoops_do_dump(struct kmsg_dumper *dumper,
>   		enum kmsg_dump_reason reason, const char *s1, unsigned long l1,
> @@ -89,6 +128,7 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
>   	if (reason == KMSG_DUMP_OOPS&&  !cxt->dump_oops)
>   		return;
>
> +	mutex_lock(&ramoops_mutex);
>   	buf = cxt->virt_addr + (cxt->count * cxt->record_size);
>   	buf_orig = buf;
>
> @@ -110,6 +150,7 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
>   	memcpy(buf + l1_cpy, s2 + s2_start, l2_cpy);
>
>   	cxt->count = (cxt->count + 1) % cxt->max_count;
> +	mutex_unlock(&ramoops_mutex);
>   }
>
>   static int __init ramoops_probe(struct platform_device *pdev)
> @@ -168,6 +209,51 @@ static int __init ramoops_probe(struct platform_device *pdev)
>   		goto fail1;
>   	}
>
> +	/* Initialize debugfs entry so the memory can be easily accessed */
> +	ramoops_dir = debugfs_create_dir(RAMOOPS_DIR, NULL);
> +	if (ramoops_dir == NULL) {
> +		err = -ENOMEM;
> +		pr_err("debugfs directory entry creation failed\n");
> +		goto out;
> +	}
> +
> +	ramoops_full_entry = debugfs_create_file(RAMOOPS_FULL, 0444,
> +					ramoops_dir, NULL,&ramoops_full_fops);
> +
> +	if (ramoops_full_entry == NULL) {
> +		err = -ENOMEM;
> +		pr_err("debugfs full entry creation failed\n");
> +		goto no_ramoops_full;
> +	}
> +
> +	/*
> +	 * Since ramoops returns records of record_size it is useful to
> +	 * know the record size from userspace so we can parse the result
> +	 * Since the record size is usually small we don't mind converting
> +	 * it to a u32 from ulong.
> +	 */
> +	ramoops_rs_entry = debugfs_create_u32(RAMOOPS_RS, 0444,
> +					ramoops_dir, (u32 *)&cxt->record_size);
> +

Like above. The result can be parsed in an easy way due to 
RAMOOPS_KERNMSG_HDR.

Marco
