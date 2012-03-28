Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab2C1Lct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:32:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34043 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146Ab2C1Lcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:32:48 -0400
MIME-Version: 1.0
In-Reply-To: <1332875657_117263@CP5-2952>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org>
 <1332873382-29373-9-git-send-email-djkurtz@chromium.org> <1332875657_117263@CP5-2952>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Wed, 28 Mar 2012 19:32:27 +0800
X-Google-Sender-Auth: PcOkJ_pJSjVTkajVUDGVNjc0_v8
Message-ID: <CAGS+omCX+_T9sDbtmdhivn4wb6b8LMGYwKxXak4G_HxeQ1Kfsw@mail.gmail.com>
Subject: Re: [PATCH 08/13 v4] drm/i915/intel_i2c: handle zero-length writes
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

On Wed, Mar 28, 2012 at 3:14 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 28 Mar 2012 02:36:17 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
>> A common method of probing an i2c bus is trying to do a zero-length write.
>> Handle this case by checking the length first before decrementing it.
>>
>> This is actually important, since attempting a zero-length write is one
>> of the ways that i2cdetect and i2c_new_probed_device detect whether
>> there is device present on the bus with a given address.
>>
>> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
>> ---
>>  drivers/gpu/drm/i915/intel_i2c.c |    5 +++--
>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
>> index c12db72..5a94e9b 100644
>> --- a/drivers/gpu/drm/i915/intel_i2c.c
>> +++ b/drivers/gpu/drm/i915/intel_i2c.c
>> @@ -248,9 +248,10 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
>>       u32 val, loop;
>>
>>       val = loop = 0;
>> -     do {
>> +     while (len && loop < 4) {
> while (len-- && loop < 4)
>
>>               val |= *buf++ << (8 * loop);
>> -     } while (--len && ++loop < 4);
>> +             len -= 1;
> Otherwise this looks too pythonesque ;-)

Unfortunately there is a bug in both my original patch (it wasn't
incrementing loop), and in your suggested cleanup (it always
decrements len, even when it is already 0... or if the loop test
fails).  How about the following; despite its pythonic nature, it
always completes with len holding the number of bytes remaining.

	val = loop = 0;
	while (len && loop < 4) {
		val |= *buf++ << (8 * loop++);
		len -= 1;
	}

>> +     }
>
> --
> Chris Wilson, Intel Open Source Technology Centre
