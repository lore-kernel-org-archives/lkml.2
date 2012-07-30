Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2G3Iql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 04:46:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49619 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2G3Iqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 04:46:39 -0400
Message-ID: <501649E8.6010002@canonical.com>
Date: Mon, 30 Jul 2012 10:46:32 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: =?UTF-8?B?T3J0d2luIEdsw7xjaw==?= <odi@odi.ch>, airlied@redhat.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com
Subject: Re: drm/nouveau: crash regression in 3.5
References: <500D916A.60703@odi.ch> <20120724170002.GA3129@joi.lan> <500ED9EC.5040309@odi.ch> <20120724205746.GA8707@joi.lan> <500FB279.1020904@odi.ch> <20120725184205.GA3119@joi.lan> <50113E76.9090706@odi.ch> <20120729201532.GA3566@joi.lan>
In-Reply-To: <20120729201532.GA3566@joi.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 29-07-12 22:15, Marcin Slusarz schreef:
> On Thu, Jul 26, 2012 at 02:56:22PM +0200, Ortwin Glück wrote:
>> On 25.07.2012 20:42, Marcin Slusarz wrote:
>>> Good, below patch should fix this panic.
>>>
>>> Note that you can hit an oops in drm_handle_vblank because patch from
>>> http://lists.freedesktop.org/archives/dri-devel/2012-May/023498.html
>>> has not been applied (yet?).
>> After applying your patch, it still crashes, although with a slightly 
>> different stack trace. I then also applied the second patch, but that 
>> doesn't make any difference. New log attached.
>>
>> Looks like interrupt occurs before nouveau_software_context_new() is 
>> called? Shouldn't the initialization be done from 
>> nouveau_irq_preinstall() so it is available when the irq occurs? Again, 
>> I am not an expert here. Just guessing...
> No, the real problem is: with "noaccel" we don't register "software engine",
> but vblank ISR relies on its existance and happily derefences NULL pointer.
>
> Now, this patch should fix it for real...
>
> ---
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> Subject: [PATCH] drm/nouveau: disable vblank interrupts before registering PDISPLAY ISR
>
> Currently, we register vblank IRQ handler and later we disable vblank
> interrupts. So, for the short amount of time, we rely on vblank ISR
> to operate correctly, even if vblank interrupts are never going to be
> used later.
>
> In "noaccel" case, software engine - which is used by vblank ISR - is not
> registered, so if vblank interrupt triggers in a wrong moment, we can hit
> NULL pointer dereference in nouveau_software_vblank.
>
> To fix it, disable vblank interrupts before registering PDISPLAY ISR.
>
> Reported-by: Ortwin Glück <odi@odi.ch>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: stable@vger.kernel.org [3.5]
>
I can confirm this bug when I was working on adding d0 vblank, but it seems
to me like nv*_display_create would be a more logical place to put the disable
call. This will make it more clear that vblank is disabled before the irq is registered.

Also maybe add a WARN_ON(!nv_engine(dev, NVOBJ_ENGINE_SW)); in
nouveau_vblank_enable and/or return -EINVAL in that case?

If you add the modification to nouveau_vblank_enable:
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

~Maarten
