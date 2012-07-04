Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933523Ab2GDBJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 21:09:23 -0400
Received: from [216.239.45.130] ([216.239.45.130]:51374 "EHLO
	glucid-laptop-imager.hot.corp.google.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753915Ab2GDBJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 21:09:22 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2012 21:09:21 EDT
Message-ID: <4FF3963E.2030804@google.com>
Date: Tue, 03 Jul 2012 18:02:54 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH 2/2] write callback: Check if existing entry is erasable
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 04:35 PM, Seiji Aguchi wrote:
> This patch introduces a following rule checking if an existing entry in NVRAM are erasable to avoid missing
> a critical message ,such as panic, before an user check it.
>
>      - In case where an existing entry is panic or emergency
>        -  It is not erasable because if panic/emergency event is lost, we have no way to detect
>           the root cause. We shouldn't overwrite them for any reason.
>
>      - In case where an existing entry is oops/shutdown/halt/poweroff
>        -  It is erasable if an error ,panic, emergency or oops, happen in new event.
>             - Oops is erasable because system may still be running and its message may be saved
>               into /var/log/messages.
>             - Also, normal event ,shutdown/halt/poweroff, is erasable because error message is
>               more important than normal message.
>
>      - In case where an existing entry is unknown event
>        -  It is erasable because any event supported by pstore outweighs unsupported events.
>
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>   drivers/firmware/efivars.c |   48 +++++++++++++++++++++++++++++++++++++++++++-
>   fs/pstore/platform.c       |    4 +-
>   include/linux/pstore.h     |    5 ++++
>   3 files changed, 54 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c index 4929254..54d9bc6 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -685,6 +685,45 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>   	return 0;
>   }
>
> +
> +static bool can_erase_entry(struct efivar_entry *entry, enum kmsg_dump_reason
> +			   new_reason)
> +{
> +	int prev_reason = 0;
> +	const char *prev_why;
> +	bool is_erasable = 0;
> +
> +	/* Get a reason of previous message */
> +	while (1) {
> +		prev_why =  pstore_get_reason_str(prev_reason);
> +		if (!strncmp(entry->var.Data, prev_why, strlen(prev_why)))
> +			break;
> +		prev_reason++;
> +	}

This loop should probably be hardened to cope with bad data.  The patch 
description and code below show intention to overwrite garbage data, but 
this loop will never exit on garbage data.

> +
> +	/* check if exisiting message is erasable */

existing

> +
> +	switch (prev_reason) {
> +	case KMSG_DUMP_PANIC:
> +	case KMSG_DUMP_EMERG:
> +		/* Never erase panic or emergency message */
> +		break;
> +	case KMSG_DUMP_OOPS:
> +	case KMSG_DUMP_RESTART:
> +	case KMSG_DUMP_HALT:
> +	case KMSG_DUMP_POWEROFF:
> +		/* Can erase if new one is error message */
> +		if (new_reason <= KMSG_DUMP_EMERG)
> +			is_erasable = 1;
> +		break;
> +	default:
> +		/* Can erase unknown message */
> +		is_erasable = 1;

It is probably safer to actually complain here at compile time if a 
reason is missing.  prev_reason is an enum though, so if all cases are 
accounted for and no default is specified, gcc should complain if a new 
KMSG_DUMP enum value is added to the codebase without considering this 
logic here.

> +	}
> +
> +	return is_erasable;
> +}
> +
>   static int efi_pstore_write(enum pstore_type_id type,
>   		enum kmsg_dump_reason reason, u64 *id,
>   		unsigned int part, size_t size, struct pstore_info *psi) @@ -706,7 +745,7 @@ static int efi_pstore_write(enum pstore_type_id type,
>   		efi_name[i] = stub_name[i];
>
>   	/*
> -	 * Clean up any entries with the same name
> +	 * Search for erasable entry
>   	 */
>
>   	list_for_each_entry(entry, &efivars->list, list) { @@ -721,6 +760,13 @@ static int efi_pstore_write(enum pstore_type_id type,
>   		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
>   			continue;
>
> +		if (!can_erase_entry(entry, reason)) {
> +			/* return without writing new entry */
> +			spin_unlock(&efivars->lock);
> +			*id = part;
> +			return ret;
> +		}

I'm not sure how comfortable I am with the code duplication here.  Was 
using a flag not workable?

> +
>   		/* found */
>   		found = entry;
>   		efivars->ops->set_variable(entry->var.VariableName,
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c index 03ce7a9..32715eb 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -68,7 +68,7 @@ void pstore_set_kmsg_bytes(int bytes)
>   /* Tag each group of saved records with a sequence number */
>   static int	oopscount;
>
> -static const char *get_reason_str(enum kmsg_dump_reason reason)
> +const char *pstore_get_reason_str(enum kmsg_dump_reason reason)
>   {
>   	switch (reason) {
>   	case KMSG_DUMP_PANIC:
> @@ -104,7 +104,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>   	int		is_locked = 0;
>   	int		ret;
>
> -	why = get_reason_str(reason);
> +	why = pstore_get_reason_str(reason);
>
>   	if (in_nmi()) {
>   		is_locked = spin_trylock(&psinfo->buf_lock); diff --git a/include/linux/pstore.h b/include/linux/pstore.h index e1461e1..e9347e9 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -54,12 +54,17 @@ struct pstore_info {
>
>   #ifdef CONFIG_PSTORE
>   extern int pstore_register(struct pstore_info *);
> +extern const char *pstore_get_reason_str(enum kmsg_dump_reason reason);
>   #else
>   static inline int
>   pstore_register(struct pstore_info *psi)  {
>   	return -ENODEV;
>   }
> +static const char *pstore_get_reason_str(enum kmsg_dump_reason reason)
> +{
> +	return NULL;
> +}
>   #endif
>
>   #endif /*_LINUX_PSTORE_H*/
> --
> 1.7.1
>
>


