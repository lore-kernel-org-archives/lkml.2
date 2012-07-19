Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2GSJE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:04:26 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:47711 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab2GSJEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:04:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Colin Cross <ccross@android.com>
Subject: Re: [PATCH] PM / Sleep: call early resume handlers when suspend_noirq fails
Date: Thu, 19 Jul 2012 11:10:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1342663694-3645-1-git-send-email-ccross@android.com>
In-Reply-To: <1342663694-3645-1-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201207191110.01193.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 19, 2012, Colin Cross wrote:
> Commit cf579dfb82550e34de7ccf3ef090d8b834ccd3a9 (PM / Sleep: Introduce
> "late suspend" and "early resume" of devices) introduced a bug where
> suspend_late handlers would be called, but if dpm_suspend_noirq returned
> an error the early_resume handlers would never be called.  All devices
> would end up on the dpm_late_early_list, and would never be resumed
> again.
> 
> Fix it by calling dpm_resume_early when dpm_suspend_noirq returns
> an error.
> 
> Signed-off-by: Colin Cross <ccross@android.com>

Nice catch, thanks!

Applied, with a CC to -stable.

Thanks,
Rafael


> ---
>  drivers/base/power/main.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> index 9cb845e..742fcbe 100644
> --- a/drivers/base/power/main.c
> +++ b/drivers/base/power/main.c
> @@ -989,8 +989,16 @@ static int dpm_suspend_late(pm_message_t state)
>  int dpm_suspend_end(pm_message_t state)
>  {
>  	int error = dpm_suspend_late(state);
> +	if (error)
> +		return error;
>  
> -	return error ? : dpm_suspend_noirq(state);
> +	error = dpm_suspend_noirq(state);
> +	if (error) {
> +		dpm_resume_early(state);
> +		return error;
> +	}
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(dpm_suspend_end);
>  
> 

