Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab2GENcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:32:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012Ab2GENcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:32:18 -0400
Date: Thu, 5 Jul 2012 09:32:01 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Message-ID: <20120705133201.GG5637@redhat.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 11:35:47PM +0000, Seiji Aguchi wrote:
> This patch introduces a following rule checking if an existing entry in NVRAM are erasable to avoid missing 
> a critical message ,such as panic, before an user check it.

I am not a big fan of this policy.

> 
>     - In case where an existing entry is panic or emergency
>       -  It is not erasable because if panic/emergency event is lost, we have no way to detect 
>          the root cause. We shouldn't overwrite them for any reason.

Ok.

> 
>     - In case where an existing entry is oops/shutdown/halt/poweroff
>       -  It is erasable if an error ,panic, emergency or oops, happen in new event.
>            - Oops is erasable because system may still be running and its message may be saved 
>              into /var/log/messages.

Then why save it to begin with?

>            - Also, normal event ,shutdown/halt/poweroff, is erasable because error message is 
>              more important than normal message.

Then why happens if you are using these messages to debug a problem on
your system?  It would seem one could be misled unless you set a flag
stating that a log was overwritten somewhere.

> 
>     - In case where an existing entry is unknown event
>       -  It is erasable because any event supported by pstore outweighs unsupported events.

Again, how does an 'unknown' event get recorded?  Shouldn't all events be
known?

I would rather see no records overwritten and just make sure there is
enough space for a dozen or so records to buffer multiple panics before
userspace can run.

Implementing policy like this in the kernel seems like it would be a
constant battle between everyone's view point of what is important and not
important.

I would rather take the viewpoint, if it is important to log it in a space
limited NVRAM, then it is important enough not to overwrite until
userspace explicitly asks it to be deleted.  Otherwise why log it, if it
is not important?

Cheers,
Don

> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  drivers/firmware/efivars.c |   48 +++++++++++++++++++++++++++++++++++++++++++-
>  fs/pstore/platform.c       |    4 +-
>  include/linux/pstore.h     |    5 ++++
>  3 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c index 4929254..54d9bc6 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -685,6 +685,45 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>  	return 0;
>  }
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
> +
> +	/* check if exisiting message is erasable */
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
> +	}
> +
> +	return is_erasable;
> +}
> +
>  static int efi_pstore_write(enum pstore_type_id type,
>  		enum kmsg_dump_reason reason, u64 *id,
>  		unsigned int part, size_t size, struct pstore_info *psi) @@ -706,7 +745,7 @@ static int efi_pstore_write(enum pstore_type_id type,
>  		efi_name[i] = stub_name[i];
>  
>  	/*
> -	 * Clean up any entries with the same name
> +	 * Search for erasable entry
>  	 */
>  
>  	list_for_each_entry(entry, &efivars->list, list) { @@ -721,6 +760,13 @@ static int efi_pstore_write(enum pstore_type_id type,
>  		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
>  			continue;
>  
> +		if (!can_erase_entry(entry, reason)) {
> +			/* return without writing new entry */
> +			spin_unlock(&efivars->lock);
> +			*id = part;
> +			return ret;
> +		}
> +
>  		/* found */
>  		found = entry;
>  		efivars->ops->set_variable(entry->var.VariableName,
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c index 03ce7a9..32715eb 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -68,7 +68,7 @@ void pstore_set_kmsg_bytes(int bytes)
>  /* Tag each group of saved records with a sequence number */
>  static int	oopscount;
>  
> -static const char *get_reason_str(enum kmsg_dump_reason reason)
> +const char *pstore_get_reason_str(enum kmsg_dump_reason reason)
>  {
>  	switch (reason) {
>  	case KMSG_DUMP_PANIC:
> @@ -104,7 +104,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
>  	int		is_locked = 0;
>  	int		ret;
>  
> -	why = get_reason_str(reason);
> +	why = pstore_get_reason_str(reason);
>  
>  	if (in_nmi()) {
>  		is_locked = spin_trylock(&psinfo->buf_lock); diff --git a/include/linux/pstore.h b/include/linux/pstore.h index e1461e1..e9347e9 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -54,12 +54,17 @@ struct pstore_info {
>  
>  #ifdef CONFIG_PSTORE
>  extern int pstore_register(struct pstore_info *);
> +extern const char *pstore_get_reason_str(enum kmsg_dump_reason reason);
>  #else
>  static inline int
>  pstore_register(struct pstore_info *psi)  {
>  	return -ENODEV;
>  }
> +static const char *pstore_get_reason_str(enum kmsg_dump_reason reason) 
> +{
> +	return NULL;
> +}
>  #endif
>  
>  #endif /*_LINUX_PSTORE_H*/
> --
> 1.7.1
> 
> 
