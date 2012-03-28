Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2C1Lq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:46:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33611 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2C1Lq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:46:58 -0400
MIME-Version: 1.0
In-Reply-To: <1332874994_117123@CP5-2952>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org>
 <1332873382-29373-14-git-send-email-djkurtz@chromium.org> <1332874994_117123@CP5-2952>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 28 Mar 2012 19:39:17 +0800
X-Google-Sender-Auth: 4S0X2iH4txO97BtAB2Zi2tpYu8w
Message-ID: <CAGS+omBXmUfqGd9GYg4DhAmvn0Z1wkzGv8EZ3032_j0PikZn6g@mail.gmail.com>
Subject: Re: [PATCH 13/13 v4] drm/i915/intel_i2c: reuse GMBUS2 value read in
 polling loop
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 3:02 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 28 Mar 2012 02:36:22 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
>> Save the GMBUS2 value read while polling for state changes, and then
>> reuse this value when determining for which reason the loops were exited.
>> This is a small optimization which saves a couple of bus accesses for
>> memory mapped IO registers.
>>
>> To avoid "assigning in if clause" checkpatch errors", use a ret variable
>> to store the wait_for macro return value.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> ---
>>  drivers/gpu/drm/i915/intel_i2c.c |   32 ++++++++++++++++++++------------
>>  1 files changed, 20 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
>> index c71f3dc..174fc71 100644
>> --- a/drivers/gpu/drm/i915/intel_i2c.c
>> +++ b/drivers/gpu/drm/i915/intel_i2c.c
>> @@ -210,6 +210,7 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
>>       int reg_offset = dev_priv->gpio_mmio_base;
>>       u16 len = msg->len;
>>       u8 *buf = msg->buf;
>> +     u32 gmbus2;
> Does the temporary really need such broad scoping?
>
>>       I915_WRITE(GMBUS1 + reg_offset,
>>                  gmbus1 |
>> @@ -219,13 +220,15 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
>>                  GMBUS_SLAVE_READ | GMBUS_SW_RDY);
>>       POSTING_READ(GMBUS2 + reg_offset);
> Might as well shave this read as well.

Do you know why POSTING_READ() was there in the first place?
As far as I can tell, these are used to ensure memory barriers are
inserted between a group of writes, and subsequent reads to memory
mapped io registers.
However, the normal I915_READ() and I915_WRITE() macros already call
readl() / writel(), which already have an explicit mb().
So, can we just get rid of all of them, or am I missing something?

If so, I propose we do that in another patch, and leave this one alone.

>
>>       do {
>> +             int ret;
>>               u32 val, loop = 0;
>>
>> -             if (wait_for(I915_READ(GMBUS2 + reg_offset) &
>> -                          (GMBUS_SATOER | GMBUS_HW_RDY),
>> -                          50))
>> +             ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
>> +                            (GMBUS_SATOER | GMBUS_HW_RDY),
>> +                            50);
>> +             if (ret)
>>                       return -ETIMEDOUT;
>> -             if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
>> +             if (gmbus2 & GMBUS_SATOER)
>>                       return -ENXIO;
>>
>>               val = I915_READ(GMBUS3 + reg_offset);
>> @@ -245,6 +248,7 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
>>       u16 len = msg->len;
>>       u8 *buf = msg->buf;
>>       u32 val, loop;
>> +     u32 gmbus2;
>>
>>       val = loop = 0;
>>       while (len && loop < 4) {
>> @@ -260,6 +264,7 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
>>                  GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
>>       POSTING_READ(GMBUS2 + reg_offset);
>>       while (len) {
>> +             int ret;
>>               val = loop = 0;
>>               do {
>>                       val |= *buf++ << (8 * loop);
>> @@ -268,11 +273,12 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
>>               I915_WRITE(GMBUS3 + reg_offset, val);
>>               POSTING_READ(GMBUS2 + reg_offset);
>
> And here.
>
> --
> Chris Wilson, Intel Open Source Technology Centre
