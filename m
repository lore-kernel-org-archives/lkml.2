Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0GMBgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 21:36:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37137 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116Ab0GMBgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 21:36:02 -0400
Date: Mon, 12 Jul 2010 18:35:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v2] acer-wmi: fix memory leaks in wmab_execute error
 path
Message-Id: <20100712183547.2a873fac.akpm@linux-foundation.org>
In-Reply-To: <1278650256.26099.4.camel@mola>
References: <1278650256.26099.4.camel@mola>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jul 2010 12:37:36 +0800 Axel Lin <axel.lin@gmail.com> wrote:

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

I think it's best to remove the multiple-return-points approach in
favour of the "goto single return point which undoes things" approach. 
that way we reduce the risk of later introducing more leaks.

Please review:

From: Andrew Morton <akpm@linux-foundation.org>

avoid multiple return points
remove unneeded cast
remove unneeded initialisation of `status'

Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Axel Lin <axel.lin@gmail.com>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acer-wmi.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN drivers/platform/x86/acer-wmi.c~acer-wmi-fix-memory-leaks-in-wmab_execute-error-path-v2-fix drivers/platform/x86/acer-wmi.c
--- a/drivers/platform/x86/acer-wmi.c~acer-wmi-fix-memory-leaks-in-wmab_execute-error-path-v2-fix
+++ a/drivers/platform/x86/acer-wmi.c
@@ -571,7 +571,7 @@ static acpi_status AMW0_set_capabilities
 {
 	struct wmab_args args;
 	struct wmab_ret ret;
-	acpi_status status = AE_OK;
+	acpi_status status;
 	struct acpi_buffer out = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
 
@@ -594,13 +594,13 @@ static acpi_status AMW0_set_capabilities
 	if (ACPI_FAILURE(status))
 		return status;
 
-	obj = (union acpi_object *) out.pointer;
+	obj = out.pointer;
 	if (obj && obj->type == ACPI_TYPE_BUFFER &&
 	obj->buffer.length == sizeof(struct wmab_ret)) {
 		ret = *((struct wmab_ret *) obj->buffer.pointer);
 	} else {
-		kfree(out.pointer);
-		return AE_ERROR;
+		status = AE_ERROR;
+		goto out;
 	}
 
 	if (ret.eax & 0x1)
@@ -614,25 +614,21 @@ static acpi_status AMW0_set_capabilities
 	 * But we need to kfree(out.pointer) if next wmab_execute fail.
 	 */
 	status = wmab_execute(&args, &out);
-	if (ACPI_FAILURE(status)) {
-		kfree(out.pointer);
-		return status;
-	}
+	if (ACPI_FAILURE(status))
+		goto out;
 
 	obj = (union acpi_object *) out.pointer;
 	if (obj && obj->type == ACPI_TYPE_BUFFER
 	&& obj->buffer.length == sizeof(struct wmab_ret)) {
 		ret = *((struct wmab_ret *) obj->buffer.pointer);
 	} else {
-		kfree(out.pointer);
-		return AE_ERROR;
+		status = AE_ERROR;
+		goto out;
 	}
 
 	if (ret.eax & 0x1)
 		interface->capability |= ACER_CAP_BLUETOOTH;
 
-	kfree(out.pointer);
-
 	/*
 	 * This appears to be safe to enable, since all Wistron based laptops
 	 * appear to use the same EC register for brightness, even if they
@@ -641,7 +637,10 @@ static acpi_status AMW0_set_capabilities
 	if (quirks->brightness >= 0)
 		interface->capability |= ACER_CAP_BRIGHTNESS;
 
-	return AE_OK;
+	status = AE_OK;
+out:
+	kfree(out.pointer);
+	return status;
 }
 
 static struct wmi_interface AMW0_interface = {
_

