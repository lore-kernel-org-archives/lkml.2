Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2LRLaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 06:30:17 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47335 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754094Ab2LRLaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 06:30:15 -0500
Message-ID: <1355830214.19706.39.camel@joe-AO722>
Subject: Re: [PATCH 2/8] Thermal: Create zone level APIs
From: Joe Perches <joe@perches.com>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hongbo.zhang@linaro.org, wni@nvidia.com
Date: Tue, 18 Dec 2012 03:30:14 -0800
In-Reply-To: <1355822977-4804-3-git-send-email-durgadoss.r@intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
	 <1355822977-4804-3-git-send-email-durgadoss.r@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-18 at 14:59 +0530, Durgadoss R wrote:
> This patch adds a new thermal_zone structure to
> thermal.h. Also, adds zone level APIs to the thermal
> framework.

[]

> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c

> +#define GET_INDEX(tz, ptr, indx, type)			\
> +	do {						\
> +		int i;					\
> +		indx = -EINVAL;				\
> +		if (!tz || !ptr)			\
> +			break;				\
> +		mutex_lock(&type##_list_lock);		\
> +		for (i = 0; i < tz->type##_indx; i++) {	\
> +			if (tz->type##s[i] == ptr) {	\
> +				indx = i;		\
> +				break;			\
> +			}				\
> +		}					\
> +		mutex_unlock(&type##_list_lock);	\
> +	} while (0)

A statement expression macro returning int would be
more kernel style like and better to use.

(sorry about the whitespace, evolution 3.6 is crappy)

#define GET_INDEX(tx, ptr, type)				\
({								\
	int rtn = -EINVAL;					\
	do {							\
		int i;						\
		if (!tz || !ptr)				\
			break;					\
		mutex_lock(&type##_list_lock);			\
		for (i = 0; i < tz->type##_indx; i++) {		\
			if (tz->type##s[i] == ptr) {		\
				rtn = i;			\
				break;				\
			}					\
		}						\
		mutex_unlock(&type##_list_lock);		\
	} while (0);						\
	rtn;							\
})


> +static void remove_sensor_from_zone(struct thermal_zone *tz,
> +				struct thermal_sensor *ts)
> +{
> +	int j, indx;
> +
> +	GET_INDEX(tz, ts, indx, sensor);

This becomes

	indx = GET_INDEX(tx, ts, sensor);

> +	if (indx < 0)
> +		return;


