Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0GBCT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 22:19:28 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:46406 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314Ab0GBCT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 22:19:26 -0400
X-Greylist: delayed 737 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2010 22:19:26 EDT
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201007020206.o62260bc016340@turbo.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: remove unnecessary input_free_device calls
To: axel.lin@gmail.com (Axel Lin)
Date: Fri, 2 Jul 2010 11:36:00 +0930 (CST)
Cc: linux-kernel@vger.kernel.org (linux-kernel),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       mjg@redhat.com (Matthew Garrett), len.brown@intel.com (Len Brown),
       akpm@linux-foundation.org (Andrew Morton),
       stefani@seibold.net (Stefani Seibold), ak@linux.intel.com (Andi Kleen),
       platform-driver-x86@vger.kernel.org
In-Reply-To: <1278034977.24246.6.camel@mola> from "Axel Lin" at Jul 02, 2010 09:42:57 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> input_free_device should only be used if input_register_device()
> was not called yet or if it failed.
>
> This patch removes unnecessary input_free_device calls.

Yes, indeed.  Good catch.  The patch looks good to me - thanks.

Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/fujitsu-laptop.c |   21 ++++++++-------------
>  1 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index e325aeb..dab1a0e 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -686,8 +686,10 @@ static int acpi_fujitsu_add(struct acpi_device *device)
>  	set_bit(KEY_UNKNOWN, input->keybit);
>  
>  	error = input_register_device(input);
> -	if (error)
> -		goto err_free_input_dev;
> +	if (error) {
> +		input_free_device(input);
> +		goto err_stop;
> +	}
>  
>  	result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
>  	if (result) {
> @@ -725,8 +727,6 @@ static int acpi_fujitsu_add(struct acpi_device *device)
>  
>  err_unregister_input_dev:
>  	input_unregister_device(input);
> -err_free_input_dev:
> -	input_free_device(input);
>  err_stop:
>  	return result;
>  }
> @@ -737,9 +737,6 @@ static int acpi_fujitsu_remove(struct acpi_device *device, int type)
>  	struct input_dev *input = fujitsu->input;
>  
>  	input_unregister_device(input);
> -
> -	input_free_device(input);
> -
>  	fujitsu->acpi_handle = NULL;
>  
>  	return 0;
> @@ -855,8 +852,10 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
>  	set_bit(KEY_UNKNOWN, input->keybit);
>  
>  	error = input_register_device(input);
> -	if (error)
> -		goto err_free_input_dev;
> +	if (error) {
> +		input_free_device(input);
> +		goto err_free_fifo;
> +	}
>  
>  	result = acpi_bus_get_power(fujitsu_hotkey->acpi_handle, &state);
>  	if (result) {
> @@ -930,8 +929,6 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
>  
>  err_unregister_input_dev:
>  	input_unregister_device(input);
> -err_free_input_dev:
> -	input_free_device(input);
>  err_free_fifo:
>  	kfifo_free(&fujitsu_hotkey->fifo);
>  err_stop:
> @@ -953,8 +950,6 @@ static int acpi_fujitsu_hotkey_remove(struct acpi_device *device, int type)
>  
>  	input_unregister_device(input);
>  
> -	input_free_device(input);
> -
>  	kfifo_free(&fujitsu_hotkey->fifo);
>  
>  	fujitsu_hotkey->acpi_handle = NULL;
> -- 
> 1.5.4.3
> 
> 
> 
