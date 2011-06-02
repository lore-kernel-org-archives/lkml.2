Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab1FBW3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:29:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:47812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab1FBW3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:29:00 -0400
Date: Fri, 3 Jun 2011 07:28:41 +0900
From: Greg KH <gregkh@suse.de>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kobject: mark object as not initialized after release
Message-ID: <20110602222841.GB13482@suse.de>
References: <1307032187-15823-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307032187-15823-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 09:29:47AM -0700, Laura Abbott wrote:
> During kobject initalization, state_initialized is set to 1. This state
> is never set back to 0, even after release. This results in re-initialized
> object warnings if the kobject needs to be reinitialized after release. On
> a statically allocated platform device and driver:
> 
> platform_device_register(&my_device)
> platform_driver_register(&my_matching_driver)
> platform_device_unregister(&my_device)
> platform_device_register(&my_device)
> 
> gives
> 
> kobject (bf000128): tried to init an initialized object, something is seriously wrong.
> [<c0053964>] (unwind_backtrace+0x0/0x128) from [<c02bd444>] (kobject_init+0x38/0x8c)
> [<c02bd444>] (kobject_init+0x38/0x8c) from [<c03445cc>] (device_initialize+0x20/0x68)
> [<c03445cc>] (device_initialize+0x20/0x68) from [<c0348924>] (platform_device_register+0x10/0x1c)
> [<c0348924>] (platform_device_register+0x10/0x1c) from [<bf00305c>] (platform_driver_test_init+0x5c/0x7c [platform_driver_test])
> [<bf00305c>] (platform_driver_test_init+0x5c/0x7c [platform_driver_test]) from [<c00466e8>] (do_one_initcall+0xd0/0x1a4)
> [<c00466e8>] (do_one_initcall+0xd0/0x1a4) from [<c0109ea4>] (sys_init_module+0x90/0x1ac)
> 
> since the kobject that is part of the platform device (mydevice.dev.kobj) never
> had the state_initialized reset despite eventually calling kobject_release.
> 
> Fix this by setting state_initialized on a released kobject back to 0 as any
> state referenced after releasing is undefined.

Nope.

We've been through this before numerous times, please see the archives
for why I will not accept this change (hint, don't use a static kobject.
If you do, you had better know exactly how to use it correctly...)

> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>  lib/kobject.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 82dc34c..00390e3 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -577,7 +577,10 @@ static void kobject_cleanup(struct kobject *kobj)
>  
>  static void kobject_release(struct kref *kref)
>  {
> -	kobject_cleanup(container_of(kref, struct kobject, kref));
> +	struct kobject *kobj = container_of(kref, struct kobject, kref);
> +
> +	kobject_cleanup(kobj);
> +	kobj->state_initialized = 0;
>  }

You really didn't test this code, did you.  It's totally broken and will
cause crashes all over the place (hint, run it with slab debugging...)

{sigh}

greg k-h
