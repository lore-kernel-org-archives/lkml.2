Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab1I3E7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:59:13 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37507 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab1I3E7M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:59:12 -0400
MIME-Version: 1.0
In-Reply-To: <4E850BE6.2050306@fnarfbargle.com>
References: <4E847ED4.5090703@fnarfbargle.com>
	<CADnq5_PUcDVL+RPZPDGiAxHjn=vL7dnNsiQYG2F5e6GWnoX7Kg@mail.gmail.com>
	<4E848CDE.1020707@fnarfbargle.com>
	<4E850BE6.2050306@fnarfbargle.com>
Date: Fri, 30 Sep 2011 00:59:12 -0400
Message-ID: <CADnq5_NJuGLWB-1d+TGqTxW6ZOOQ4QeQj1e6dXOffL5egZuw1g@mail.gmail.com>
Subject: Re: Radeon regression fix
From: Alex Deucher <alexdeucher@gmail.com>
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 8:23 PM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
> On 29/09/11 23:21, Brad Campbell wrote:
>>
>> On 29/09/11 22:36, Alex Deucher wrote:
>>>
>>> On Thu, Sep 29, 2011 at 10:21 AM, Brad Campbell<brad@fnarfbargle.com>
>>> wrote:
>>>>
>>>> This patch fixes a regression introduced between 2.6.39& 3.1-rc1 whereby
>>>> the displayport AUX channel stopped re-trying commands that elicited
>>>> a DEFER
>>>> response.
>>>>
>>>
>>> It should still be retrying, just restructured slightly. The retry
>>> logic just moved into radeon_dp_i2c_aux_ch(),
>>> radeon_dp_aux_native_write(), and radeon_dp_aux_native_read(), e.g.,
>>>
>>> else if ((ack& AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
>>> udelay(400);
>>>
>>> Perhaps the delay is causing a problem. Does removing the udelay(400);
>>> help?
>
> Looking at it with a nights sleep, it's obvious the code path in
> aux_native_write is ok. Is this a bit cleaner than the last patch?

Looks pretty good.  I was thinking of something more like this (sorry
for the lack of a patch, I'm away from my source trees at the moment):

	while (1) {
		ret = radeon_process_aux_ch(dig_connector->dp_i2c_bus,
					    msg, msg_bytes, recv, recv_bytes, delay, &ack);

		if (ret < 0)
			return ret;
		if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
			return ret;
		else if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
			udelay(400);
		else if (ret == 0)
			return -EPROTO;
		else
			return -EIO;
	}

Thanks for tracking this down.

Alex

>
> diff --git a/drivers/gpu/drm/radeon/atombios_dp.c
> b/drivers/gpu/drm/radeon/atombios_dp.c
> index 7ad43c6..aacc97d 100644
> --- a/drivers/gpu/drm/radeon/atombios_dp.c
> +++ b/drivers/gpu/drm/radeon/atombios_dp.c
> @@ -158,14 +158,17 @@ static int radeon_dp_aux_native_read(struct
> radeon_connector *radeon_connector,
>        while (1) {
>                ret = radeon_process_aux_ch(dig_connector->dp_i2c_bus,
>                                            msg, msg_bytes, recv, recv_bytes,
> delay, &ack);
> -               if (ret == 0)
> +               if (ret == 0){
> +                       if ((ack & AUX_NATIVE_REPLY_MASK) ==
> AUX_NATIVE_REPLY_DEFER){
> +                               udelay(400);
> +                               continue;
> +                       }
>                        return -EPROTO;
> +               }
>                if (ret < 0)
>                        return ret;
>                if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
>                        return ret;
> -               else if ((ack & AUX_NATIVE_REPLY_MASK) ==
> AUX_NATIVE_REPLY_DEFER)
> -                       udelay(400);
>                else
>                        return -EIO;
>        }
>
