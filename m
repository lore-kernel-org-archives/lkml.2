Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1BHK2E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:28:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:59129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab1BHK2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:28:03 -0500
Message-Id: <0d30dc$l0idpo@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,441,1291622400"; 
   d="scan'208";a="705247032"
Date: Tue, 08 Feb 2011 10:27:58 +0000
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] drm: Never change the connector status to unknown whilst polling
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1296039205-3193-1-git-send-email-chris@chris-wilson.co.uk>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1296039205-3193-1-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bringing this to Andy's attention...

On Wed, 26 Jan 2011 10:53:25 +0000, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> When polling for a hotplug event, if the connector detect probe returns
> unknown, reuse the current status and do not trigger a hotplug event.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/gpu/drm/drm_crtc.c        |    1 +
>  drivers/gpu/drm/drm_crtc_helper.c |   11 +++++++----
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index 2baa670..f6678f6 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -459,6 +459,7 @@ void drm_connector_init(struct drm_device *dev,
>  	INIT_LIST_HEAD(&connector->probed_modes);
>  	INIT_LIST_HEAD(&connector->modes);
>  	connector->edid_blob_ptr = NULL;
> +	connector->status = connector_status_unknown;
>  
>  	list_add_tail(&connector->head, &dev->mode_config.connector_list);
>  	dev->mode_config.num_connector++;
> diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
> index 952b3d4..b3afb38 100644
> --- a/drivers/gpu/drm/drm_crtc_helper.c
> +++ b/drivers/gpu/drm/drm_crtc_helper.c
> @@ -862,7 +862,6 @@ static void output_poll_execute(struct work_struct *work)
>  	struct delayed_work *delayed_work = to_delayed_work(work);
>  	struct drm_device *dev = container_of(delayed_work, struct drm_device, mode_config.output_poll_work);
>  	struct drm_connector *connector;
> -	enum drm_connector_status old_status;
>  	bool repoll = false, changed = false;
>  
>  	if (!drm_kms_helper_poll)
> @@ -870,6 +869,7 @@ static void output_poll_execute(struct work_struct *work)
>  
>  	mutex_lock(&dev->mode_config.mutex);
>  	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
> +		enum drm_connector_status old_status, new_status;
>  
>  		/* if this is HPD or polled don't check it -
>  		   TV out for instance */
> @@ -883,15 +883,18 @@ static void output_poll_execute(struct work_struct *work)
>  		/* if we are connected and don't want to poll for disconnect
>  		   skip it */
>  		if (old_status == connector_status_connected &&
> -		    !(connector->polled & DRM_CONNECTOR_POLL_DISCONNECT) &&
> -		    !(connector->polled & DRM_CONNECTOR_POLL_HPD))
> +		    (connector->polled & (DRM_CONNECTOR_POLL_DISCONNECT | DRM_CONNECTOR_POLL_HPD)) == 0)
>  			continue;
>  
> -		connector->status = connector->funcs->detect(connector, false);
> +		new_status = connector->funcs->detect(connector, false);
> +		if (new_status != connector_status_unknown)
> +			connector->status = new_status;
> +
>  		DRM_DEBUG_KMS("[CONNECTOR:%d:%s] status updated from %d to %d\n",
>  			      connector->base.id,
>  			      drm_get_connector_name(connector),
>  			      old_status, connector->status);
> +
>  		if (old_status != connector->status)
>  			changed = true;
>  	}
> -- 
> 1.7.2.3
> 

-- 
Chris Wilson, Intel Open Source Technology Centre
