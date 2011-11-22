Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab1KVW01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:26:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52606 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab1KVW00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:26:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] PM / Hibernation: Refactor and simplify hibernation_snapshot() code
Date: Tue, 22 Nov 2011 23:29:09 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: pavel@ucw.cz, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20111122212500.11648.2252.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111122212500.11648.2252.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111222329.09534.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 22, 2011, Srivatsa S. Bhat wrote:
> The goto statements in hibernation_snapshot() are a bit complex.
> Refactor the code to remove some of them, thereby simplifying the
> implementation.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
> This is on top of the patch posted at https://lkml.org/lkml/2011/11/21/498
> 
>  kernel/power/hibernate.c |   22 +++++++++-------------
>  1 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index a6b0503..ebf62c3 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -333,7 +333,7 @@ static int create_image(int platform_mode)
>   */
>  int hibernation_snapshot(int platform_mode)
>  {
> -	pm_message_t msg = PMSG_RECOVER;
> +	pm_message_t msg;
>  	int error;
>  
>  	error = platform_begin(platform_mode);
> @@ -362,26 +362,26 @@ int hibernation_snapshot(int platform_mode)
>  
>  	error = dpm_prepare(PMSG_FREEZE);
>  	if (error) {
> -		dpm_complete(msg);
> +		dpm_complete(PMSG_RECOVER);
>  		goto Cleanup;
>  	}
>  
>  	suspend_console();
>  	pm_restrict_gfp_mask();
> +
>  	error = dpm_suspend(PMSG_FREEZE);
> -	if (error)
> -		goto Recover_platform;
>  
> -	if (hibernation_test(TEST_DEVICES))
> -		goto Recover_platform;
> +	if (error || hibernation_test(TEST_DEVICES))
> +		platform_recover(platform_mode);
> +	else
> +		error = create_image(platform_mode);
>  
> -	error = create_image(platform_mode);
>  	/*
> -	 * Control returns here (1) after the image has been created or the
> +	 * In the case that we call create_image() above, the control
> +	 * returns here (1) after the image has been created or the
>  	 * image creation has failed and (2) after a successful restore.
>  	 */
>  
> - Resume_devices:
>  	/* We may need to release the preallocated image pages here. */
>  	if (error || !in_suspend)
>  		swsusp_free();
> @@ -399,10 +399,6 @@ int hibernation_snapshot(int platform_mode)
>  	platform_end(platform_mode);
>  	return error;
>  
> - Recover_platform:
> -	platform_recover(platform_mode);
> -	goto Resume_devices;
> -
>   Cleanup:
>  	swsusp_free();
>  	goto Close;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

