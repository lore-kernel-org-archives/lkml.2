Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab0KJWZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:25:51 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58704 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab0KJWZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:25:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=dEoGZegyRcbt+s82t/YJEEDWuQnElCDDP9WlcIiHliKlEbbca/PzmbWHkhS8Lg/Oaz
         uOMvUou91LwVKKiwTSfdMKAAci9IwGVgBuFwHBiWJ8CZ3kTVqzRt995+k3tn2xTEIudX
         eklEFUyIaw6EbKtqYJCIPTSqj+5oB0pydh6m0=
MIME-Version: 1.0
In-Reply-To: <1289427037.9605.3.camel@nisroch>
References: <cover.1289423299.git.luto@mit.edu> <cb559f4c96f82d5bf0c132b3330aecd4885a0dda.1289423199.git.luto@mit.edu>
 <1289427037.9605.3.camel@nisroch>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 10 Nov 2010 17:25:27 -0500
X-Google-Sender-Auth: 1rB_lYqxtjkc4WIEXc9vnCHF_8w
Message-ID: <AANLkTimfrVPaxgGXyLU-YTQBMNz_BBVMhfH+MO_CH2Cn@mail.gmail.com>
Subject: Re: [PATCH 2/2] nouveau: Acknowledge HPD irq in handler, not bottom half
To: bskeggs@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 5:10 PM, Ben Skeggs <bskeggs@redhat.com> wrote:
> On Wed, 2010-11-10 at 16:32 -0500, Andy Lutomirski wrote:
>> The old code generated an interrupt storm bad enough to completely
>> take down my system.
>>
>> This only fixes the bits that are defined nouveau_regs.h.  Newer hardware
>> uses another register that isn't described, and I don't have that hardware
>> to test.
> Thanks for looking at this.  I'll take a closer look at the problem
> today and see what I can come up with too, that'll work with the newer
> hardware too.

It should be as simple as adding an hpd1 field to the hpd_state and
making exactly the same change.  (It would be nice to put the register
definitions into nouveau_regs.h as well -- I didn't really want to
muck around with a bunch of magic numbers that I can't test.)

I tried writing 0xffffffff to the display IRQ control in the handler
to explicitly acknowledge the IRQ, but either I did it wrong or it had
no effect.

I imagine that this explains the unreproducible crashes I had on F13 as well.

--Andy

>
> Ben.
>>
>> Signed-off-by: Andy Lutomirski <luto@mit.edu>
>> Cc: <stable@kernel.org>
>> ---
>>  drivers/gpu/drm/nouveau/nouveau_drv.h  |    5 +++++
>>  drivers/gpu/drm/nouveau/nouveau_irq.c  |    1 +
>>  drivers/gpu/drm/nouveau/nv50_display.c |   17 +++++++++++++----
>>  3 files changed, 19 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
>> index b1be617..b6c62cc 100644
>> --- a/drivers/gpu/drm/nouveau/nouveau_drv.h
>> +++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
>> @@ -531,6 +531,11 @@ struct drm_nouveau_private {
>>       struct work_struct irq_work;
>>       struct work_struct hpd_work;
>>
>> +     struct {
>> +             spinlock_t lock;
>> +             uint32_t hpd0_bits;
>> +     } hpd_state;
>> +
>>       struct list_head vbl_waiting;
>>
>>       struct {
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
>> index 794b0ee..b62a601 100644
>> --- a/drivers/gpu/drm/nouveau/nouveau_irq.c
>> +++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
>> @@ -52,6 +52,7 @@ nouveau_irq_preinstall(struct drm_device *dev)
>>       if (dev_priv->card_type >= NV_50) {
>>               INIT_WORK(&dev_priv->irq_work, nv50_display_irq_handler_bh);
>>               INIT_WORK(&dev_priv->hpd_work, nv50_display_irq_hotplug_bh);
>> +             spin_lock_init(&dev_priv->hpd_state.lock);
>>               INIT_LIST_HEAD(&dev_priv->vbl_waiting);
>>       }
>>  }
>> diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
>> index 83a7d27..0df08e3 100644
>> --- a/drivers/gpu/drm/nouveau/nv50_display.c
>> +++ b/drivers/gpu/drm/nouveau/nv50_display.c
>> @@ -1014,7 +1014,12 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
>>       uint32_t unplug_mask, plug_mask, change_mask;
>>       uint32_t hpd0, hpd1 = 0;
>>
>> -     hpd0 = nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL) & nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_INTR);
>> +     spin_lock_irq(&dev_priv->hpd_state.lock);
>> +     hpd0 = dev_priv->hpd_state.hpd0_bits;
>> +     dev_priv->hpd_state.hpd0_bits = 0;
>> +     spin_unlock_irq(&dev_priv->hpd_state.lock);
>> +
>> +     hpd0 &= nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_INTR);
>>       if (dev_priv->chipset >= 0x90)
>>               hpd1 = nv_rd32(dev, 0xe074) & nv_rd32(dev, 0xe070);
>>
>> @@ -1058,7 +1063,6 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
>>                       helper->dpms(connector->encoder, DRM_MODE_DPMS_OFF);
>>       }
>>
>> -     nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL, nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL));
>>       if (dev_priv->chipset >= 0x90)
>>               nv_wr32(dev, 0xe074, nv_rd32(dev, 0xe074));
>>
>> @@ -1072,8 +1076,13 @@ nv50_display_irq_handler(struct drm_device *dev)
>>       uint32_t delayed = 0;
>>
>>       if (nv_rd32(dev, NV50_PMC_INTR_0) & NV50_PMC_INTR_0_HOTPLUG) {
>> -             if (!work_pending(&dev_priv->hpd_work))
>> -                     queue_work(dev_priv->wq, &dev_priv->hpd_work);
>> +             uint32_t hpd0_bits = nv_rd32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL);
>> +             nv_wr32(dev, NV50_PCONNECTOR_HOTPLUG_CTRL, hpd0_bits);
>> +             spin_lock(&dev_priv->hpd_state.lock);
>> +             dev_priv->hpd_state.hpd0_bits |= hpd0_bits;
>> +             spin_unlock(&dev_priv->hpd_state.lock);
>> +
>> +             queue_work(dev_priv->wq, &dev_priv->hpd_work);
>>       }
>>
>>       while (nv_rd32(dev, NV50_PMC_INTR_0) & NV50_PMC_INTR_0_DISPLAY) {
>
>
>
