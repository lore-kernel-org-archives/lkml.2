Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1IUDbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 23:31:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:16788 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab1IUDbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 23:31:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,414,1312182000"; 
   d="scan'208";a="53841586"
Message-ID: <4E795A9C.4040508@linux.intel.com>
Date: Wed, 21 Sep 2011 11:31:40 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: tony.luck@intel.com, linux-kernel@vger.kernel.org, mikew@google.com,
        saguchi@redhat.com
Subject: Re: [PATCH] efi: Avoid sysfs spew on reboot and panic
References: <1316552853-2000-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1316552853-2000-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011/9/21 5:07, Matthew Garrett 写道:
> Right now all pstore accesses to efivars will delete or create new sysfs
> nodes. This is less than ideal if we've paniced or are rebooting, since
> we're in entirely the wrong context to do this kind of thing. Add the
> reason to the pstore callback and make sure we only manipulate the files
> if we're still going to be alive afterwards.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>
> Reported-by: Seiji Aguchi<saguchi@redhat.com>
> ---
>   drivers/acpi/apei/erst.c   |    6 ++++--
>   drivers/firmware/efivars.c |   17 +++++++++++++----
>   fs/pstore/platform.c       |    7 ++++---
>   include/linux/kmsg_dump.h  |    1 +
>   include/linux/pstore.h     |    5 ++++-
>   5 files changed, 26 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
> index 2ca59dc..a6b5dc1 100644
> --- a/drivers/acpi/apei/erst.c
> +++ b/drivers/acpi/apei/erst.c
> @@ -934,7 +934,8 @@ static int erst_close_pstore(struct pstore_info *psi);
>   static ssize_t erst_reader(u64 *id, enum pstore_type_id *type,
>   			   struct timespec *time, struct pstore_info *psi);
>   static u64 erst_writer(enum pstore_type_id type, unsigned int part,
> -		       size_t size, struct pstore_info *psi);
> +		       enum kmsg_dump_reason reason, size_t size,
> +		       struct pstore_info *psi);
>   static int erst_clearer(enum pstore_type_id type, u64 id,
>   			struct pstore_info *psi);
>
> @@ -1041,7 +1042,8 @@ out:
>   }
>
>   static u64 erst_writer(enum pstore_type_id type, unsigned int part,
> -		       size_t size, struct pstore_info *psi)
> +		       enum kmsg_dump_reason reason, size_t size,
> +		       struct pstore_info *psi)
>   {
>   	struct cper_pstore_record *rcd = (struct cper_pstore_record *)
>   					(erst_info.buf - sizeof(*rcd));
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index eb80b54..0510319 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -491,7 +491,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>   }
>
>   static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
> -			    size_t size, struct pstore_info *psi)
> +			    enum kmsg_dump_reason reason, size_t size,
> +			    struct pstore_info *psi)
>   {
>   	char name[DUMP_NAME_LEN];
>   	char stub_name[DUMP_NAME_LEN];
> @@ -544,6 +545,14 @@ static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
>
>   	spin_unlock(&efivars->lock);
>
> +	/*
> +	 * If it's more severe than KMSG_DUMP_OOPS then we're already dead.
> +	 * Don't bother playing with sysfs.
> +	 */
> +
> +	if (reason>  KMSG_DUMP_OOPS)
> +		return part;
> +
>   	if (found)
>   		efivar_unregister(found);
>
> @@ -552,14 +561,13 @@ static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
>   					  utf16_strsize(efi_name,
>   							DUMP_NAME_LEN * 2),
>   					  efi_name,&vendor);
> -
>   	return part;
>   };
>
>   static int efi_pstore_erase(enum pstore_type_id type, u64 id,
>   			    struct pstore_info *psi)
>   {
> -	efi_pstore_write(type, id, 0, psi);
> +	efi_pstore_write(type, id, KMSG_DUMP_UNKNOWN, 0, psi);
>
>   	return 0;
>   }
> @@ -581,7 +589,8 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>   }
>
>   static u64 efi_pstore_write(enum pstore_type_id type, unsigned int part,
> -			    size_t size, struct pstore_info *psi)
> +			    enum kmsg_dump_reason reason, size_t size,
> +			    struct pstore_info *psi)
>   {
>   	return 0;
>   }
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index c5300ec..02117cc 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -51,7 +51,8 @@ void pstore_set_kmsg_bytes(int bytes)
>   static int	oopscount;
>
>   static char *reason_str[] = {
> -	"Oops", "Panic", "Kexec", "Restart", "Halt", "Poweroff", "Emergency"
> +	"Unknown", "Oops", "Panic", "Kexec", "Restart", "Halt", "Poweroff",
> +	"Emergency"
>   };
>
>   /*
> @@ -97,7 +98,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>   		memcpy(dst, s1 + s1_start, l1_cpy);
>   		memcpy(dst + l1_cpy, s2 + s2_start, l2_cpy);
>
> -		id = psinfo->write(PSTORE_TYPE_DMESG, part,
> +		id = psinfo->write(PSTORE_TYPE_DMESG, part, reason,
>   				   hsize + l1_cpy + l2_cpy, psinfo);
>   		if (reason == KMSG_DUMP_OOPS&&  pstore_is_mounted())
>   			pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id,
> @@ -207,7 +208,7 @@ int pstore_write(enum pstore_type_id type, char *buf, size_t size)
>
>   	mutex_lock(&psinfo->buf_mutex);
>   	memcpy(psinfo->buf, buf, size);
> -	id = psinfo->write(type, 0, size, psinfo);
> +	id = psinfo->write(type, 0, KMSG_DUMP_UNKNOWN, size, psinfo);

I can't say it is wrong because no real caller for this function, but I can't
say it is right, yet. KMSG_DUMP_UNKNOWN here looks too arbirary. Do you have
any reason to use this type here ?

>   	if (pstore_is_mounted())
>   		pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id, psinfo->buf,
>   			      size, CURRENT_TIME, psinfo);
> diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
> index ee0c952..b5ffe79 100644
> --- a/include/linux/kmsg_dump.h
> +++ b/include/linux/kmsg_dump.h
> @@ -16,6 +16,7 @@
>   #include<linux/list.h>
>
>   enum kmsg_dump_reason {
> +	KMSG_DUMP_UNKNOWN,
>   	KMSG_DUMP_OOPS,
>   	KMSG_DUMP_PANIC,
>   	KMSG_DUMP_KEXEC,
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> index cc03bbf..fa049e8 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -22,6 +22,8 @@
>   #ifndef _LINUX_PSTORE_H
>   #define _LINUX_PSTORE_H
>
> +#include<linux/kmsg_dump.h>
> +
>   /* types */
>   enum pstore_type_id {
>   	PSTORE_TYPE_DMESG	= 0,
> @@ -40,7 +42,8 @@ struct pstore_info {
>   	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
>   			struct timespec *time, struct pstore_info *psi);
>   	u64		(*write)(enum pstore_type_id type, unsigned int part,
> -			size_t size, struct pstore_info *psi);
> +			enum kmsg_dump_reason reason, size_t size,
> +			struct pstore_info *psi);
>   	int		(*erase)(enum pstore_type_id type, u64 id,
>   			struct pstore_info *psi);
>   	void		*data;

