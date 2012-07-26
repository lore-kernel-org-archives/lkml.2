Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752422Ab2GZMoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 08:44:16 -0400
Received: from osrc3.amd.com ([217.9.48.20]:41069 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab2GZMnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 08:43:53 -0400
Date: Thu, 26 Jul 2012 14:43:46 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 13/13] driver core: firmware loader: cache devices
 firmware during suspend/resume cycle
Message-ID: <20120726124346.GF30717@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-14-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343149213-10160-14-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:00:13AM +0800, Ming Lei wrote:
> This patch implements caching devices' firmware automatically
> during system syspend/resume cycle, so any device drivers can
> call request_firmware or request_firmware_nowait inside resume
> path to get the cached firmware if they have loaded firmwares
> successfully at least once before entering suspend.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/firmware_class.c |   32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 0918b26..59384e0 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -24,6 +24,7 @@
>  #include <linux/list.h>
>  #include <linux/async.h>
>  #include <linux/pm.h>
> +#include <linux/suspend.h>
>  
>  #include "base.h"
>  
> @@ -106,6 +107,8 @@ struct firmware_cache {
>  	wait_queue_head_t      wait_queue;
>  	int cnt;
>  	struct delayed_work work;
> +

stray newline

> +	struct notifier_block   pm_notify;

variable names should be either all aligned or none at all but not
something in between.

>  };
>  
>  struct firmware_buf {
> @@ -1202,6 +1205,31 @@ static void device_uncache_firmwares_delay(unsigned long delay)
>  			msecs_to_jiffies(delay));
>  }
>  
> +#ifdef CONFIG_PM
> +static int fw_pm_notify(struct notifier_block *notify_block,
> +					unsigned long mode, void *unused)
> +{
> +	switch (mode) {
> +	case PM_HIBERNATION_PREPARE:
> +	case PM_SUSPEND_PREPARE:
> +		device_cache_firmwares();
> +		break;
> +
> +	case PM_POST_SUSPEND:
> +	case PM_POST_HIBERNATION:
> +	case PM_POST_RESTORE:
> +		device_uncache_firmwares_delay(10 * MSEC_PER_SEC);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +#else
> +static int fw_pm_notify(struct notifier_block *notify_block,
> +					unsigned long mode, void *unused)
> +{}

static inline int fw_pm...

> +#endif
> +
>  static void __init fw_cache_init(void)
>  {
>  	spin_lock_init(&fw_cache.lock);
> @@ -1214,6 +1242,9 @@ static void __init fw_cache_init(void)
>  	init_waitqueue_head(&fw_cache.wait_queue);
>  	INIT_DELAYED_WORK(&fw_cache.work,
>  		device_uncache_firmwares_work);
> +	fw_cache.pm_notify.notifier_call = fw_pm_notify;
> +
> +	register_pm_notifier(&fw_cache.pm_notify);
>  }
>  
>  static int __init firmware_class_init(void)
> @@ -1224,6 +1255,7 @@ static int __init firmware_class_init(void)
>  
>  static void __exit firmware_class_exit(void)
>  {
> +	unregister_pm_notifier(&fw_cache.pm_notify);
>  	class_unregister(&firmware_class);
>  }

Ok, that should be it.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
