Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab0HLXdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 19:33:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64390 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0HLXdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 19:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DeRwmfXvrha3H1d90cyIrSAuGm4WTtlrxOwCusrsayABL5iUoeAUb4I26jBQ7OLHzp
         4mf3swFCCxdjYWC0qCokmp9nYUMt2c+N9CqhpWIMtYEz34PygunzwtSwyoAwx+aIvYcU
         Lo2hFeLE6er3qbRZlaViMm3devs3Ep02WLVfA=
MIME-Version: 1.0
In-Reply-To: <AANLkTinmhGPHQDX0gmnY9j+K61abgnukw2DrTBG3EUuJ@mail.gmail.com>
References: <1281066910.2168.10.camel@pasglop>
	<AANLkTinmhGPHQDX0gmnY9j+K61abgnukw2DrTBG3EUuJ@mail.gmail.com>
Date: Fri, 13 Aug 2010 09:33:35 +1000
Message-ID: <AANLkTi=BowHspOUSDmwkdN3o9qhh6rJtEZwCnTRP-VrS@mail.gmail.com>
Subject: Re: [PATCH] drm: Fix support for PCI domains
From: Dave Airlie <airlied@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        dri-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 7:30 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Aug 6, 2010 at 05:55, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> (For some reason I thought that went in ages ago ...)
>>
>> This fixes support for PCI domains in what should hopefully be a backward
>> compatible way along with a change to libdrm.
>>
>> When the interface version is set to 1.4, we assume userspace understands
>> domains and the world is at peace. We thus pass proper domain numbers
>> instead of 0 to userspace.
>>
>> The newer libdrm will then try 1.4 first, and fallback to 1.1, along with
>> ignoring domains in the later case (well, except on alpha of course)
>>
>> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> ---
>>  drivers/gpu/drm/drm_ioctl.c |    1 +
>>  include/drm/drmP.h          |   18 +++++++++++++-----
>>  include/drm/drm_core.h      |    2 +-
>>  3 files changed, 15 insertions(+), 6 deletions(-)
>
>> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
>> index c1b9871..6d4bad5 100644
>> --- a/include/drm/drmP.h
>> +++ b/include/drm/drmP.h
>> @@ -1071,11 +1071,19 @@ static __inline__ int drm_core_check_feature(struct drm_device *dev,
>>        return ((dev->driver->driver_features & feature) ? 1 : 0);
>>  }
>>
>> -#ifdef __alpha__
>> -#define drm_get_pci_domain(dev) dev->hose->index
>> -#else
>> -#define drm_get_pci_domain(dev) 0
>> -#endif
>> +static inline int drm_get_pci_domain(struct drm_device *dev)
>> +{
>> +#ifndef __alpha__
>> +       /* For historical reasons, drm_get_pci_domain() is busticated
>> +        * on most archs and has to remain so for userspace interface
>> +        * < 1.4, except on alpha which was right from the beginning
>> +        */
>> +       if (dev->if_version < 0x10004)
>> +               return 0;
>> +#endif /* __alpha__ */
>> +
>> +       return pci_domain_nr(dev->pdev->bus);
>
> error: implicit declaration of function ‘pci_domain_nr’
> on m68k without PCI.

I don't think I want to add an ifdef CONFIG_PCI into the drm layer for
this, since we seem to be okay everywhere else,

lets ask jbarnes, not sure if its safe to just add this to the
!CONFIG_PCI section of the linux/pci.h

Dave.

>
>
