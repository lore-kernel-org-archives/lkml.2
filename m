Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105Ab0EKSSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:18:31 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:56761 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022Ab0EKSS2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:18:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bn1LCjfbwAlddhTxLG6q4V+inLc0hLQJIb8xa35oIyQo3ZZUQbwE0eScQTVH0yj/9N
         SGAOZPjdEl2I6vWdMYspWaiG3fGRdtlpsa9S2bT1Kj5Q/6uuPsvlE3c6+8n89tCPJ4Ur
         bV07abXa+a6eUsYx3BjnCmdzk4SNz8xCgxj0M=
MIME-Version: 1.0
In-Reply-To: <20100511104818.8382a7de.akpm@linux-foundation.org>
References: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com>
	 <89kc63$grtht6@fmsmga002.fm.intel.com>
	 <20100511104818.8382a7de.akpm@linux-foundation.org>
Date: Tue, 11 May 2010 23:48:27 +0530
Message-ID: <AANLkTinchPgyuDt1YWZKCSWco5kT57m6VGDPtbAq3BvG@mail.gmail.com>
Subject: Re: DRM Error on Acer Aspire One
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
       Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Tue, May 11, 2010 at 8:18 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 11 May 2010 17:10:53 +0100 Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
>> On Tue, 11 May 2010 20:30:07 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>> > Hello,
>> >
>> > With latest git kernel, I am getting following DRM error and not
>> > getting XWindows :
>>
>> [snip]
>>
>> Hmm, there are still patches for capturing error state that haven't gone
>> upstream, shame on me.
>>
>> That error is a secondary issue to the GPU hang that is being reported. If
>> it is a regression caused by a kernel update it would be very useful if
>> you could bisect to the erroneous commit.
>
> It helps if one reads the code and the trace...
>
> i915_error_object_create() is using KM_USER0 from softirq context.
> That's a bug, and a pretty serious one.  If some innocent civilian is
> writing highmem data to disk and this timer interrupt fires and trashes
> his KM_USER0 slot, the disk contents will be corrupted.
>
> Something like this...
>
> --- a/drivers/gpu/drm/i915/i915_irq.c~a
> +++ a/drivers/gpu/drm/i915/i915_irq.c
> @@ -456,11 +456,15 @@ i915_error_object_create(struct drm_devi
>
>        for (page = 0; page < page_count; page++) {
>                void *s, *d = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> +               unsigned long flags;
> +
>                if (d == NULL)
>                        goto unwind;
> -               s = kmap_atomic(src_priv->pages[page], KM_USER0);
> +               local_irq_save(flags);
> +               s = kmap_atomic(src_priv->pages[page], KM_IRQ0);
>                memcpy(d, s, PAGE_SIZE);
> -               kunmap_atomic(s, KM_USER0);
> +               kunmap_atomic(s, KM_IRQ0);
> +               local_irq_restore(flags);
>                dst->pages[page] = d;
>        }
>        dst->page_count = page_count;
> _
>
> Please let's get a tested fix for this into 2.6.34.
>

I tested your patch with latest linus git and it works, it fixes the
softirq error.

Now I am only getting DRM errors :

[   42.276059] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
elapsed... GPU hung
[   42.276398] render error detected, EIR: 0x00000000
[   42.276460] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request
returns -5 (awaiting 18 at 17)

Thanks,
--
Jaswinder Singh.
