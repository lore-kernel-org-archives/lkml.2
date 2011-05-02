Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1EBXPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 19:15:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36425 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab1EBXPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 19:15:37 -0400
Date: Mon, 2 May 2011 16:12:34 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when
 tasks are frozen
Message-ID: <20110502231234.GA6430@suse.de>
References: <201105030044.51661.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105030044.51661.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 12:44:51AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Some drivers erroneously use request_firmware() from their ->resume()
> (or ->thaw(), or ->restore()) callbacks, which is not going to work
> unless the firmware has been built in.  This causes system resume to
> stall until the firmware-loading timeout expires, which makes users
> think that the resume has failed and reboot their machines
> unnecessarily.  For this reason, make _request_firmware() print a
> warning when it has been called when tasks are frozen and it's
> impossible to start any new usermode helpers.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/firmware_class.c |    3 +++
>  include/linux/kmod.h          |    1 +
>  kernel/kmod.c                 |    8 ++++++++
>  3 files changed, 12 insertions(+)
> 
> Index: linux-2.6/include/linux/kmod.h
> ===================================================================
> --- linux-2.6.orig/include/linux/kmod.h
> +++ linux-2.6/include/linux/kmod.h
> @@ -113,5 +113,6 @@ extern void usermodehelper_init(void);
>  
>  extern int usermodehelper_disable(void);
>  extern void usermodehelper_enable(void);
> +extern bool usermodehelper_is_disabled(void);
>  
>  #endif /* __LINUX_KMOD_H__ */
> Index: linux-2.6/kernel/kmod.c
> ===================================================================
> --- linux-2.6.orig/kernel/kmod.c
> +++ linux-2.6/kernel/kmod.c
> @@ -301,6 +301,14 @@ void usermodehelper_enable(void)
>  	usermodehelper_disabled = 0;
>  }
>  
> +/**
> + * usermodehelper_is_disabled - check if new helpers are allowed to be started
> + */
> +bool usermodehelper_is_disabled(void)
> +{
> +	return usermodehelper_disabled;
> +}
> +
>  static void helper_lock(void)
>  {
>  	atomic_inc(&running_helpers);
> Index: linux-2.6/drivers/base/firmware_class.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/firmware_class.c
> +++ linux-2.6/drivers/base/firmware_class.c
> @@ -521,6 +521,9 @@ static int _request_firmware(const struc
>  	if (!firmware_p)
>  		return -EINVAL;
>  
> +	if (WARN_ON(usermodehelper_is_disabled()))
> +		return -EBUSY;

But you can safely call this function with nowait set, and this warning
should not be triggered, right?

thanks,

greg k-h
