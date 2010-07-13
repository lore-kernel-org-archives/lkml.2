Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab0GMBDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:03:31 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49067 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab0GMBD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:03:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Uw+O7jkDFkUk+uhf4EbiOIxHPkkztvfStMkjGAcg70bsPeoSkbdMxbYsEffQFpjCH+
         NjuXv1/SyWepTj1JHvg/jsvDhM5Ac15MbudtIUDBoyJl4Lr+rv/MxSSwOXKkxny1Udk8
         5yyFcHXiTfg7Oxkc5s1IMGQf1X2WJSxVkKbhc=
Subject: Re: [PATCH v2] acer-wmi: fix memory leaks in wmab_execute error
	path
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
        platform-driver-x86@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1278650256.26099.4.camel@mola>
References: <1278650256.26099.4.camel@mola>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 13 Jul 2010 09:03:55 +0800
Message-Id: <1278983035.13580.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Andrew,
I just found acer-wmi-fix-memory-leaks-in-wmab_execute-error-path.patch added to -mm tree.
But I think the V2 version is the correct one.
If the second wmab_execute fail (for any reason) , we need to free the existing buffer before return status.
Sould I resend the patch?


Regards,
Axel

於 五，2010-07-09 於 12:37 +0800，Axel Lin 提到：
> When acpi_evaluate_object() is passed ACPI_ALLOCATE_BUFFER,
> the caller must kfree the returned buffer if AE_OK is returned.
> 
> Call Trace:
> wmab_execute
>   -> wmi_evaluate_method
>     -> acpi_evaluate_object
> 
> Thus if callers of wmab_execute() pass ACPI_ALLOCATE_BUFFER,
> the return buffer must be kfreed if wmab_execute return AE_OK.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/acer-wmi.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index 1ea6c43..3f44446 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -555,6 +555,7 @@ static acpi_status AMW0_find_mailled(void)
>  	obj->buffer.length == sizeof(struct wmab_ret)) {
>  		ret = *((struct wmab_ret *) obj->buffer.pointer);
>  	} else {
> +		kfree(out.pointer);
>  		return AE_ERROR;
>  	}
>  
> @@ -598,6 +599,7 @@ static acpi_status AMW0_set_capabilities(void)
>  	obj->buffer.length == sizeof(struct wmab_ret)) {
>  		ret = *((struct wmab_ret *) obj->buffer.pointer);
>  	} else {
> +		kfree(out.pointer);
>  		return AE_ERROR;
>  	}
>  
> @@ -607,15 +609,22 @@ static acpi_status AMW0_set_capabilities(void)
>  	args.ebx = 2 << 8;
>  	args.ebx |= ACER_AMW0_BLUETOOTH_MASK;
>  
> +	/*
> +	 * It's ok to use existing buffer for next wmab_execute call.
> +	 * But we need to kfree(out.pointer) if next wmab_execute fail.
> +	 */
>  	status = wmab_execute(&args, &out);
> -	if (ACPI_FAILURE(status))
> +	if (ACPI_FAILURE(status)) {
> +		kfree(out.pointer);
>  		return status;
> +	}
>  
>  	obj = (union acpi_object *) out.pointer;
>  	if (obj && obj->type == ACPI_TYPE_BUFFER
>  	&& obj->buffer.length == sizeof(struct wmab_ret)) {
>  		ret = *((struct wmab_ret *) obj->buffer.pointer);
>  	} else {
> +		kfree(out.pointer);
>  		return AE_ERROR;
>  	}
>  

