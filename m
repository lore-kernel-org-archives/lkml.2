Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2GHU4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 16:56:52 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:61319 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752294Ab2GHU4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 16:56:50 -0400
X-IronPort-AV: E=Sophos;i="4.77,547,1336341600"; 
   d="scan'208";a="166046554"
Date: Sun, 8 Jul 2012 22:56:47 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Paul Menzel <paulepanter@users.sourceforge.net>
cc: David Airlie <airlied@linux.ie>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 4/7] drivers/gpu/drm: remove invalid reference to list
 iterator variable
In-Reply-To: <1341780745.4660.8.camel@mattotaupa>
Message-ID: <alpine.DEB.2.02.1207082255440.2017@localhost6.localdomain6>
References: <1341747464-1772-1-git-send-email-Julia.Lawall@lip6.fr>  <1341747464-1772-5-git-send-email-Julia.Lawall@lip6.fr> <1341780745.4660.8.camel@mattotaupa>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2012, Paul Menzel wrote:

> Dear Julia,
>
>
> Am Sonntag, den 08.07.2012, 13:37 +0200 schrieb Julia Lawall:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> If list_for_each_entry, etc complete a traversal of the list, the iterator
>> variable ends up pointing to an address at an offset from the list head,
>> and not a meaningful structure.  Thus this value should not be used after
>> the end of the iterator.
>>
>> In the first two cases, a a break is added after the switch; the break in
>
> s,a a,a,

Thanks.

>> the switch would jump out of the switch, but not out of the complete
>> iteration.
>>
>> In the first case, the null test on connector is removed, because the
>> iterator variable of list_for_each_entry is never null.
>>
>> In the third case, entry->base.crtc.fb is not a meaningful value.  What
>> seems to be intended is crtc->fb, which gets the information from the last
>> element of the list.
>
> maybe three separate patches would have been better?

OK, I wasn't sure what would be best.  I'll send three patches now.

>> These problems were found using Coccinelle (http://coccinelle.lip6.fr/).
>
> I always liked your example Coccinelle code snippets. Could you add them
> again to your commit messages? That would be awesome!

Sure.  I didn't include it because there was a 0/7 message that has the 
complete semantic patch.

julia

>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>>  drivers/gpu/drm/gma500/mdfld_intel_display.c |    4 +---
>>  drivers/gpu/drm/gma500/oaktrail_crtc.c       |    1 +
>>  drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c          |    2 +-
>>  3 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/gma500/mdfld_intel_display.c b/drivers/gpu/drm/gma500/mdfld_intel_display.c
>> index 3f3cd61..fc1ced0 100644
>> --- a/drivers/gpu/drm/gma500/mdfld_intel_display.c
>> +++ b/drivers/gpu/drm/gma500/mdfld_intel_display.c
>> @@ -755,9 +755,6 @@ static int mdfld_crtc_mode_set(struct drm_crtc *crtc,
>>  					sizeof(struct drm_display_mode));
>>
>>  	list_for_each_entry(connector, &mode_config->connector_list, head) {
>> -		if (!connector)
>> -			continue;
>> -
>>  		encoder = connector->encoder;
>>
>>  		if (!encoder)
>> @@ -779,6 +776,7 @@ static int mdfld_crtc_mode_set(struct drm_crtc *crtc,
>>  			is_hdmi = true;
>>  			break;
>>  		}
>> +		break;
>>  	}
>>
>>  	/* Disable the VGA plane that we never use */
>> diff --git a/drivers/gpu/drm/gma500/oaktrail_crtc.c b/drivers/gpu/drm/gma500/oaktrail_crtc.c
>> index f821c83..4b2172e 100644
>> --- a/drivers/gpu/drm/gma500/oaktrail_crtc.c
>> +++ b/drivers/gpu/drm/gma500/oaktrail_crtc.c
>> @@ -329,6 +329,7 @@ static int oaktrail_crtc_mode_set(struct drm_crtc *crtc,
>>  			is_mipi = true;
>>  			break;
>>  		}
>> +		break;
>>  	}
>>
>>  	/* Disable the VGA plane that we never use */
>> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
>> index 070fb23..634611a 100644
>> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
>> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
>> @@ -93,7 +93,7 @@ static int vmw_ldu_commit_list(struct vmw_private *dev_priv)
>>
>>  		if (crtc == NULL)
>>  			return 0;
>> -		fb = entry->base.crtc.fb;
>> +		fb = crtc->fb;
>>
>>  		return vmw_kms_write_svga(dev_priv, w, h, fb->pitches[0],
>>  					  fb->bits_per_pixel, fb->depth);
>
> Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
>
>
> Thanks,
>
> Paul
>
