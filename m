Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab0HIOAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:00:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45813 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0HIOAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:00:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kXe/deEto1PA1iTYhQwKVuRkBw07ALLeOhIK38uc7lq6o4CB/vUxzIDBkG03sbmr6z
         CXs3WC6yaG7MmC7jP5yciW66P+ddZdZqTgWvCb4mPVP/01l9GyVsHRTQsPc2CSSTi5Mb
         SOUa8/zIapuP+PkgmHaori85JkhYjrj3TFolw=
Message-ID: <4C6009FE.4020702@gmail.com>
Date: Mon, 09 Aug 2010 07:00:30 -0700
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b3pre) Gecko/20100727 Shredder/3.2a1pre
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        David Airlie <airlied@linux.ie>, DRI <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm: fix fallouts from slow-work -> wq conversion
References: <i3n3dh$t48$1@dough.gmane.org> <20100809063742.GA1632@arch.tripp.de> <20100809083053.GB2169@osiris.boeblingen.de.ibm.com> <20100809083451.GC2169@osiris.boeblingen.de.ibm.com> <4C5FC49B.9040208@kernel.org> <4C5FCC14.6030901@gmail.com> <20100809094630.GA1603@arch.tripp.de> <4C5FCF0C.2000100@gmail.com> <4C5FD1D1.9060302@gmail.com> <20100809101406.GA1633@arch.tripp.de> <4C5FD65B.8080800@gmail.com>
In-Reply-To: <4C5FD65B.8080800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 03:20 AM, Tejun Heo wrote:
>  From 9a919c46dfa48a9c1f465174609b90253eb8ffc1 Mon Sep 17 00:00:00 2001
> From: Tejun Heo<tj@kernel.org>
> Date: Mon, 9 Aug 2010 12:01:27 +0200
>
> Commit 991ea75c (drm: use workqueue instead of slow-work), which made
> drm to use wq instead of slow-work, didn't account for the return
> value difference between delayed_slow_work_enqueue() and
> queue_delayed_work().  The former returns 0 on success and -errno on
> failures while the latter never fails and only uses the return value
> to indicate whether the work was already pending or not.
>
> This misconversion triggered spurious error messages.  Remove the now
> unnecessary return value check and error message.


> diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
> index 4598130..b9e4dbf 100644
> --- a/drivers/gpu/drm/drm_crtc_helper.c
> +++ b/drivers/gpu/drm/drm_crtc_helper.c
> @@ -839,7 +839,6 @@ static void output_poll_execute(struct work_struct *work)
>   	struct drm_connector *connector;
>   	enum drm_connector_status old_status, status;
>   	bool repoll = false, changed = false;
> -	int ret;
>
>   	mutex_lock(&dev->mode_config.mutex);
>   	list_for_each_entry(connector,&dev->mode_config.connector_list, head) {
> @@ -874,11 +873,8 @@ static void output_poll_execute(struct work_struct *work)
>   			dev->mode_config.funcs->output_poll_changed(dev);
>   	}
>
> -	if (repoll) {
> -		ret = queue_delayed_work(system_nrt_wq, delayed_work, DRM_OUTPUT_POLL_PERIOD);
> -		if (ret)
> -			DRM_ERROR("delayed enqueue failed %d\n", ret);
> -	}
> +	if (repoll)
> +		queue_delayed_work(system_nrt_wq, delayed_work, DRM_OUTPUT_POLL_PERIOD);
>   }
>
>   void drm_kms_helper_poll_disable(struct drm_device *dev)
> @@ -893,18 +889,14 @@ void drm_kms_helper_poll_enable(struct drm_device *dev)
>   {
>   	bool poll = false;
>   	struct drm_connector *connector;
> -	int ret;
>
>   	list_for_each_entry(connector,&dev->mode_config.connector_list, head) {
>   		if (connector->polled)
>   			poll = true;
>   	}
>
> -	if (poll) {
> -		ret = queue_delayed_work(system_nrt_wq,&dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
> -		if (ret)
> -			DRM_ERROR("delayed enqueue failed %d\n", ret);
> -	}
> +	if (poll)
> +		queue_delayed_work(system_nrt_wq,&dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
>   }
>   EXPORT_SYMBOL(drm_kms_helper_poll_enable);


I was getting the same spurious error messages, and this patches fixes it, thanks.
