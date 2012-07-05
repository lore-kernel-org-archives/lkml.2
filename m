Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2GENS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:18:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab2GENSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:18:24 -0400
Date: Thu, 5 Jul 2012 09:18:02 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH 1/2] Duplicate a shared code between write and erase
 callbacks
Message-ID: <20120705131802.GE5637@redhat.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAD8@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAD8@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 11:34:58PM +0000, Seiji Aguchi wrote:
> This patch duplicates a code of erase callback shared with write callback so that they work independently.

Can you expand this changelog to explain why this is needed and what
problem you are trying to fix?  I know you talked about it in the patch
series header, but the header doesn't get committed.

Cheers,
Don

> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> ---
>  drivers/firmware/efivars.c |   46 +++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 45 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c index 47408e8..4929254 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -756,7 +756,51 @@ static int efi_pstore_write(enum pstore_type_id type,  static int efi_pstore_erase(enum pstore_type_id type, u64 id,
>  			    struct pstore_info *psi)
>  {
> -	efi_pstore_write(type, 0, &id, (unsigned int)id, 0, psi);
> +	char stub_name[DUMP_NAME_LEN];
> +	efi_char16_t efi_name[DUMP_NAME_LEN];
> +	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> +	struct efivars *efivars = psi->data;
> +	struct efivar_entry *entry, *found = NULL;
> +	int i;
> +
> +	sprintf(stub_name, "dump-type%u-%llu-", type, id);
> +
> +	spin_lock(&efivars->lock);
> +
> +	for (i = 0; i < DUMP_NAME_LEN; i++)
> +		efi_name[i] = stub_name[i];
> +
> +	/*
> +	 * Clean up any entries with the same name
> +	 */
> +
> +	list_for_each_entry(entry, &efivars->list, list) {
> +		get_var_data_locked(efivars, &entry->var);
> +
> +		if (efi_guidcmp(entry->var.VendorGuid, vendor))
> +			continue;
> +		if (utf16_strncmp(entry->var.VariableName, efi_name,
> +				  utf16_strlen(efi_name)))
> +			continue;
> +		/* Needs to be a prefix */
> +		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
> +			continue;
> +
> +		/* found */
> +		found = entry;
> +		efivars->ops->set_variable(entry->var.VariableName,
> +					   &entry->var.VendorGuid,
> +					   PSTORE_EFI_ATTRIBUTES,
> +					   0, NULL);
> +	}
> +
> +	if (found)
> +		list_del(&found->list);
> +
> +	spin_unlock(&efivars->lock);
> +
> +	if (found)
> +		efivar_unregister(found);
>  
>  	return 0;
>  }
> --
> 1.7.1
> 
> 
