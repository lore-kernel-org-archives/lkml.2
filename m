Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2HGSKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 14:10:16 -0400
Received: from toro.web-alm.net ([62.245.132.31]:60210 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824Ab2HGSKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 14:10:15 -0400
Message-ID: <50215817.6070009@osadl.org>
Date: Tue, 07 Aug 2012 20:01:59 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] drm/edid: Fix potential memory leak in edid_load()
References: <1344342186-6561-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1344342186-6561-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 02:23 PM, Alexey Khoroshilov wrote:
> Do not leak memory by updating pointer with potentially
> NULL realloc return value.
>
> Found by Linux Driver Verification project (linuxtesting.org).
Thanks, Alexey!

Reviewed-by: Carsten Emde <C.Emde@osadl.org>

> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>   drivers/gpu/drm/drm_edid_load.c |    8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
> index 66d4a28..0303935 100644
> --- a/drivers/gpu/drm/drm_edid_load.c
> +++ b/drivers/gpu/drm/drm_edid_load.c
> @@ -119,7 +119,7 @@ static int edid_load(struct drm_connector *connector, char *name,
>   {
>   	const struct firmware *fw;
>   	struct platform_device *pdev;
> -	u8 *fwdata = NULL, *edid;
> +	u8 *fwdata = NULL, *edid, *new_edid;
>   	int fwsize, expected;
>   	int builtin = 0, err = 0;
>   	int i, valid_extensions = 0;
> @@ -195,12 +195,14 @@ static int edid_load(struct drm_connector *connector, char *name,
>   		    "\"%s\" for connector \"%s\"\n", valid_extensions,
>   		    edid[0x7e], name, connector_name);
>   		edid[0x7e] = valid_extensions;
> -		edid = krealloc(edid, (valid_extensions + 1) * EDID_LENGTH,
> +		new_edid = krealloc(edid, (valid_extensions + 1) * EDID_LENGTH,
>   		    GFP_KERNEL);
> -		if (edid == NULL) {
> +		if (new_edid == NULL) {
>   			err = -ENOMEM;
> +			kfree(edid);
>   			goto relfw_out;
>   		}
> +		edid = new_edid;
>   	}
>
>   	connector->display_info.raw_edid = edid;
