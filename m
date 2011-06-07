Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab1FGSEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:04:34 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:36347 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755961Ab1FGSEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:04:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ue6kv2KahVX3g9Y4PEcFRuqo3OjlRlFEA9ogpcTuXYr9yQcd0tEq+I35FqaQcZvQvQVmCZ+KkjDoihGDJeKsMFp6AOY5miCkWQXQHPpn2cnHrwwdyeFnOs/iQZ1mduc3;
Date: Tue, 7 Jun 2011 11:04:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org, Matt_Domsch@dell.com
Subject: Re: [PATCH 3/3] efi: Add support for using efivars as a pstore
 backend
Message-Id: <20110607110428.86f92ee2.rdunlap@xenotime.net>
In-Reply-To: <1307389135-8150-3-git-send-email-mjg@redhat.com>
References: <1307389135-8150-1-git-send-email-mjg@redhat.com>
	<1307389135-8150-3-git-send-email-mjg@redhat.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  6 Jun 2011 15:38:55 -0400 Matthew Garrett wrote:

> EFI provides an area of nonvolatile storage managed by the firmware. We
> can use this as a pstore backend to maintain copies of oopses, aiding
> diagnosis.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  drivers/firmware/efivars.c |  158 +++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/efi.h        |    3 +
>  2 files changed, 159 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 5f29aaf..89e6a3a 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -161,18 +164,28 @@ utf8_strsize(efi_char16_t *data, unsigned long maxlength)
>  }
>  
>  static efi_status_t
> -get_var_data(struct efivars *efivars, struct efi_variable *var)
> +get_var_data_locked(struct efivars *efivars, struct efi_variable *var)

__get_var_data() would be a more common/typical name for this (unlocked,
needs locking version), I think.

>  {
>  	efi_status_t status;
>  
> -	spin_lock(&efivars->lock);
>  	var->DataSize = 1024;
>  	status = efivars->ops->get_variable(var->VariableName,
>  					    &var->VendorGuid,
>  					    &var->Attributes,
>  					    &var->DataSize,
>  					    var->Data);
> +	return status;
> +}
> +
> +static efi_status_t
> +get_var_data(struct efivars *efivars, struct efi_variable *var)
> +{
> +	efi_status_t status;
> +
> +	spin_lock(&efivars->lock);
> +	status = get_var_data_locked(efivars, var);
>  	spin_unlock(&efivars->lock);
> +
>  	if (status != EFI_SUCCESS) {
>  		printk(KERN_WARNING "efivars: get_variable() failed 0x%lx!\n",
>  			status);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
