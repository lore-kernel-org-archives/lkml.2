Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1I3FjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 01:39:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43442 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1I3FjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 01:39:21 -0400
MIME-Version: 1.0
In-Reply-To: <4E855050.8080403@fnarfbargle.com>
References: <4E847ED4.5090703@fnarfbargle.com>
	<CADnq5_PUcDVL+RPZPDGiAxHjn=vL7dnNsiQYG2F5e6GWnoX7Kg@mail.gmail.com>
	<4E848CDE.1020707@fnarfbargle.com>
	<4E850BE6.2050306@fnarfbargle.com>
	<CADnq5_NJuGLWB-1d+TGqTxW6ZOOQ4QeQj1e6dXOffL5egZuw1g@mail.gmail.com>
	<4E855050.8080403@fnarfbargle.com>
Date: Fri, 30 Sep 2011 01:39:20 -0400
Message-ID: <CADnq5_M7i8Bj+FPubBS+soRa4dv46gzKR+EZYzjE71a==o=ApQ@mail.gmail.com>
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

On Fri, Sep 30, 2011 at 1:14 AM, Brad Campbell
<lists2009@fnarfbargle.com> wrote:
> On 30/09/11 12:59, Alex Deucher wrote:
>>
>> On Thu, Sep 29, 2011 at 8:23 PM, Brad Campbell
>
>>> Looking at it with a nights sleep, it's obvious the code path in
>>> aux_native_write is ok. Is this a bit cleaner than the last patch?
>>
>> Looks pretty good.  I was thinking of something more like this (sorry
>> for the lack of a patch, I'm away from my source trees at the moment):
>>
>>        while (1) {
>>                ret = radeon_process_aux_ch(dig_connector->dp_i2c_bus,
>>                                            msg, msg_bytes, recv,
>> recv_bytes, delay,&ack);
>>
>>                if (ret<  0)
>>                        return ret;
>>                if ((ack&  AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
>>                        return ret;
>>                else if ((ack&  AUX_NATIVE_REPLY_MASK) ==
>> AUX_NATIVE_REPLY_DEFER)
>>                        udelay(400);
>>                else if (ret == 0)
>>                        return -EPROTO;
>>                else
>>                        return -EIO;
>>        }
>
> Yep, that looks cleaner.
>
> My only thought was the pre-3.0 code had a limit to the number of retries.
> Was that for a specific reason or is it ok to attempt to retry indefinitely
> if we receive a DEFER ?

I need to double check the DP spec, but I think it's 4.  The while (1)
loops in radeon_dp_aux_native_write() and radeon_dp_aux_native_read()
should probably be changed to:
for (retry = 0; retry < 4; retry++)
to match what we do in radeon_dp_i2c_aux_ch().

Alex
