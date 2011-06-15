Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab1FORML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:12:11 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:43922 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1FORMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:12:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=whitecape.org; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=whitecape.org;
	 b=EtDGRPoRb1ooa5bPLuL2jJGPE7/NqfJAD9pNOJp0qvjGcFZZvdAtTAG0g7wpF
	NxJ98KcxneT99XlJURsZwvN0UoiDOfXyuQzUmNgCECAyg3W7CZA2mTwiPBtr/pxl
	2Cw6Qo9dbgLV0eSuJKYhxmbRQJO4lNbMN9ea72tj/VT8Zo=
Message-ID: <4DF8E7D1.7030104@whitecape.org>
Date: Wed, 15 Jun 2011 10:11:45 -0700
From: Kenneth Graunke <kenneth@whitecape.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110503 Thunderbird/3.1.10
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Eric Anholt <eric@anholt.net>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: Re: [Intel-gfx] [PATCH 3.0-rc3] i915: Fix gen6 (SNB) GPU stalling
References: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
In-Reply-To: <1308070307-2630-1-git-send-email-daniel.blueman@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2011 09:51 AM, Daniel J Blueman wrote:
> On 14 June 2011 13:23, Eric Anholt<eric@anholt.net>  wrote:
>> On Tue, 14 Jun 2011 12:18:36 +0800, Daniel J Blueman<daniel.blueman@gmail.com>  wrote:
>>> Hi Eric,
>>>
>>> The frequent ~1.5s pauses I hit with SNB hardware in the gnome3 UI (eg
>>> whenever you hit the top-left of the screen to show all windows) are
>>> nicely addressed by your recent wake patch [1] (ported to -rc3). Thus
>>> I see no 'missed IRQ' kernel messages.
>>>
>>> As this addresses a significant usability regression, are you happy to
>>> add it to the 3.0-rc queue? I think it has very good value in -stable
>>> also (assuming correctness). What do you think?
>>
>> This one had significant performance impacts, and later hacks in this
>> series worked around the problem to approximately the same level of
>> success with less impact, and we don't actually have a justification of
>> why any of them work.  We were still hoping to come up with some clue,
>> and haven't yet.
>
> True; that is quite heavy handed delay looping.
>
> It's a pity the usual Intel font didn't make it to the programmer's
> reference manuals. Anyway, unmasking the blitter user interrupt in the hardware
> status mask register addresses the root cause. Out of reset it's FFFFFFFFh,
> so we don't need to read it here.
>
> It would be good to get this into -rc4. -stable probably needs some additional
> tweaks.
>
> Signed-off-by: Daniel J Blueman<daniel.blueman@gmail.com>
> ---
>   drivers/gpu/drm/i915/i915_irq.c |    6 ++++++
>   1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index b9fafe3..9a98c1b 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -1827,6 +1827,12 @@ int ironlake_irq_postinstall(struct drm_device *dev)
>   		ironlake_enable_display_irq(dev_priv, DE_PCU_EVENT);
>   	}
>
> +	if (IS_GEN6(dev))
> +		/* allow blitter user interrupt to generate a MSI write from
> +		   the ISR */
> +		I915_WRITE(GEN6_BLITTER_HWSTAM,
> +			0xffffffff&  ~GEN6_BLITTER_USER_INTERRUPT);
> +
>   	return 0;
>   }
>

Tested-by: Kenneth Graunke <kenneth@whitecape.org>

With i915.semaphores=0 on my Lenovo T420s, I reliably saw missed IRQs 
from the blitter when using GNOME Shell or running GLBenchmark 
2.0/Egypt.  Applying this patch fixes the issue, making my system much 
more responsive.

Thanks, Daniel!
