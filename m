Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2BLCG0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 21:06:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41685 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab2BLCGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 21:06:25 -0500
Date: Sat, 11 Feb 2012 18:06:22 -0800
From: mark gross <markgross@thegnar.org>
To: Jean Pihet <jean.pihet@newoldbits.com>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Gross <markgross@thegnar.org>,
        Venkatesh Pallipadi <venki@google.com>, Jean Pihet <j-pihet@ti.com>
Subject: Re: [PATCH 1/2] PM / QoS: unconditionally build the feature
Message-ID: <20120212020622.GE18742@gs62>
Reply-To: markgross@thegnar.org
References: <1328603646-2714-1-git-send-email-j-pihet@ti.com>
 <1328603646-2714-2-git-send-email-j-pihet@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328603646-2714-2-git-send-email-j-pihet@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acked-by <markgross@thegnar.org>

On Tue, Feb 07, 2012 at 09:34:05AM +0100, Jean Pihet wrote:
> The PM QoS feature depends on CONFIG_PM which depends on
> PM_SLEEP || PM_RUNTIME. This breaks CPU C-states with kernels
> not having these CONFIGs.
> 
> This patch allows the feature in all cases.
> 
> Reported-by: Venkatesh Pallipadi <venki@google.com>
> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Mark Gross <markgross@thegnar.org>
> ---
>  include/linux/pm_qos.h |   29 +----------------------------
>  kernel/power/Makefile  |    3 ++-
>  2 files changed, 3 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
> index e5bbcba..105be69 100644
> --- a/include/linux/pm_qos.h
> +++ b/include/linux/pm_qos.h
> @@ -63,7 +63,6 @@ static inline int dev_pm_qos_request_active(struct dev_pm_qos_request *req)
>  	return req->dev != 0;
>  }
>  
> -#ifdef CONFIG_PM
>  int pm_qos_update_target(struct pm_qos_constraints *c, struct plist_node *node,
>  			 enum pm_qos_req_action action, int value);
>  void pm_qos_add_request(struct pm_qos_request *req, int pm_qos_class,
> @@ -78,6 +77,7 @@ int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier);
>  int pm_qos_request_active(struct pm_qos_request *req);
>  s32 pm_qos_read_value(struct pm_qos_constraints *c);
>  
> +#ifdef CONFIG_PM
>  s32 __dev_pm_qos_read_value(struct device *dev);
>  s32 dev_pm_qos_read_value(struct device *dev);
>  int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
> @@ -95,33 +95,6 @@ void dev_pm_qos_constraints_destroy(struct device *dev);
>  int dev_pm_qos_add_ancestor_request(struct device *dev,
>  				    struct dev_pm_qos_request *req, s32 value);
>  #else
> -static inline int pm_qos_update_target(struct pm_qos_constraints *c,
> -				       struct plist_node *node,
> -				       enum pm_qos_req_action action,
> -				       int value)
> -			{ return 0; }
> -static inline void pm_qos_add_request(struct pm_qos_request *req,
> -				      int pm_qos_class, s32 value)
> -			{ return; }
> -static inline void pm_qos_update_request(struct pm_qos_request *req,
> -					 s32 new_value)
> -			{ return; }
> -static inline void pm_qos_remove_request(struct pm_qos_request *req)
> -			{ return; }
> -
> -static inline int pm_qos_request(int pm_qos_class)
> -			{ return 0; }
> -static inline int pm_qos_add_notifier(int pm_qos_class,
> -				      struct notifier_block *notifier)
> -			{ return 0; }
> -static inline int pm_qos_remove_notifier(int pm_qos_class,
> -					 struct notifier_block *notifier)
> -			{ return 0; }
> -static inline int pm_qos_request_active(struct pm_qos_request *req)
> -			{ return 0; }
> -static inline s32 pm_qos_read_value(struct pm_qos_constraints *c)
> -			{ return 0; }
> -
>  static inline s32 __dev_pm_qos_read_value(struct device *dev)
>  			{ return 0; }
>  static inline s32 dev_pm_qos_read_value(struct device *dev)
> diff --git a/kernel/power/Makefile b/kernel/power/Makefile
> index 07e0e28..66d808e 100644
> --- a/kernel/power/Makefile
> +++ b/kernel/power/Makefile
> @@ -1,7 +1,8 @@
>  
>  ccflags-$(CONFIG_PM_DEBUG)	:= -DDEBUG
>  
> -obj-$(CONFIG_PM)		+= main.o qos.o
> +obj-y				+= qos.o
> +obj-$(CONFIG_PM)		+= main.o
>  obj-$(CONFIG_VT_CONSOLE_SLEEP)	+= console.o
>  obj-$(CONFIG_FREEZER)		+= process.o
>  obj-$(CONFIG_SUSPEND)		+= suspend.o
> -- 
> 1.7.5.4
> 
