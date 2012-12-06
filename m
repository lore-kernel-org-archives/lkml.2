Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab2LFPlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:41:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34033 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab2LFPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:41:08 -0500
MIME-Version: 1.0
In-Reply-To: <1354734003-92714-1-git-send-email-tim.gardner@canonical.com>
References: <1354734003-92714-1-git-send-email-tim.gardner@canonical.com>
Date: Thu, 6 Dec 2012 10:41:06 -0500
Message-ID: <CADnq5_PBhkw9aOcobnhupKD79YbXoBSvczTgTf3Jz+Nom3aG7w@mail.gmail.com>
Subject: Re: [PATCH 3.7-rc8] drm: Fix possible EDID memory allocation oops
From: Alex Deucher <alexdeucher@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 2:00 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> The result of drm_property_create_blob() is not checked for success
> which could lead to a NULL pointer dereference.
>
> I was led to this by a smatch warning:
>
> drivers/gpu/drm/drm_crtc.c:3186 drm_mode_connector_update_edid_property() error: potential null dereference 'connector->edid_blob_ptr'.  (drm_property_create_blob returns null)
>
> drm_property_create_blob() calls kzalloc() which can return NULL.
>
> Cc: David Airlie <airlied@linux.ie>
> Cc: dri-devel@lists.freedesktop.org
> Cc: stable@vger.kernel.org # 3.0+
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> ---
>
> This bug actually exists in the original commit f453ba0460742ad027ae0c4c7d61e62817b3e7ef
> (2.6.29), but I only checked as far back as 3.0 for stable.
>
>  drivers/gpu/drm/drm_crtc.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index ef1b221..31872ba 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -3180,6 +3180,10 @@ int drm_mode_connector_update_edid_property(struct drm_connector *connector,
>         size = EDID_LENGTH * (1 + edid->extensions);
>         connector->edid_blob_ptr = drm_property_create_blob(connector->dev,
>                                                             size, edid);
> +       if (!connector->edid_blob_ptr) {
> +               pr_err("drm: Could not allocate %d edid blob bytes.\n", size);
> +               return -ENOMEM;
> +       }
>
>         ret = drm_connector_property_set_value(connector,
>                                                dev->mode_config.edid_property,
> --
> 1.7.9.5
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
