Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab2JGRTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 13:19:10 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:26302 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342Ab2JGRTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 13:19:00 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="176158484"
Date: Sun, 7 Oct 2012 19:18:57 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: walter harms <wharms@bfs.de>
cc: Julia Lawall <julia.lawall@lip6.fr>, Antti Palosaari <crope@iki.fi>,
        kernel-janitors@vger.kernel.org, rmallon@gmail.com,
        shubhrajyoti@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for
 i2c_msg initialization
In-Reply-To: <5071B834.1010200@bfs.de>
Message-ID: <alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr> <5071AEF3.6080108@bfs.de> <alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6> <5071B834.1010200@bfs.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2012, walter harms wrote:

>
>
> Am 07.10.2012 18:44, schrieb Julia Lawall:
>> On Sun, 7 Oct 2012, walter harms wrote:
>>
>>>
>>>
>>> Am 07.10.2012 17:38, schrieb Julia Lawall:
>>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>>
>>>> Introduce use of I2c_MSG_READ/WRITE/OP, for readability.
>>>>
>>>> In the second i2c_msg structure, a length expressed as an explicit
>>>> constant
>>>> is also re-expressed as the size of the buffer, reg.
>>>>
>>>> A simplified version of the semantic patch that makes this change is as
>>>> follows: (http://coccinelle.lip6.fr/)
>>>>
>>>> // <smpl>
>>>> @@
>>>> expression a,b,c;
>>>> identifier x;
>>>> @@
>>>>
>>>> struct i2c_msg x =
>>>> - {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
>>>> + I2C_MSG_READ(a,b,c)
>>>>  ;
>>>>
>>>> @@
>>>> expression a,b,c;
>>>> identifier x;
>>>> @@
>>>>
>>>> struct i2c_msg x =
>>>> - {.addr = a, .buf = b, .len = c, .flags = 0}
>>>> + I2C_MSG_WRITE(a,b,c)
>>>>  ;
>>>>
>>>> @@
>>>> expression a,b,c,d;
>>>> identifier x;
>>>> @@
>>>>
>>>> struct i2c_msg x =
>>>> - {.addr = a, .buf = b, .len = c, .flags = d}
>>>> + I2C_MSG_OP(a,b,c,d)
>>>>  ;
>>>> // </smpl>
>>>>
>>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>>>
>>>> ---
>>>>  drivers/media/tuners/e4000.c |   20 +++-----------------
>>>>  1 file changed, 3 insertions(+), 17 deletions(-)
>>>>
>>>> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
>>>> index 1b33ed3..8f182fc 100644
>>>> --- a/drivers/media/tuners/e4000.c
>>>> +++ b/drivers/media/tuners/e4000.c
>>>> @@ -26,12 +26,7 @@ static int e4000_wr_regs(struct e4000_priv *priv,
>>>> u8 reg, u8 *val, int len)
>>>>      int ret;
>>>>      u8 buf[1 + len];
>>>>      struct i2c_msg msg[1] = {
>>>> -        {
>>>> -            .addr = priv->cfg->i2c_addr,
>>>> -            .flags = 0,
>>>> -            .len = sizeof(buf),
>>>> -            .buf = buf,
>>>> -        }
>>>> +        I2C_MSG_WRITE(priv->cfg->i2c_addr, buf, sizeof(buf))
>>>>      };
>>>>
>>>
>>> Any reason why struct i2c_msg is an array ?
>>
>> I assumed that it looked more harmonious with the other uses of
>> i2c_transfer, which takes as arguments an array and the number of elements.
>>
>> But there are some files that instead use i2c_transfer(priv->i2c, &msg, 1).
>> I can change them all to do that if that is preferred.  But maybe I will
>> wait a little bit to see if there are other issues to address at the
>> same time.
>>
>> thanks,
>> julia
>>
>
> Hi Julia,
> please be aware i am not the maintainer only a distant watcher :)
>
> do you really thing that a macro is appropriate here ? I feel uneasy about it
> but i can not offer an other solution.

Some people thought that it would be nice to have the macros rather than 
the inlined field initializations, especially since there is no flag for 
write.  A separate question is whether an array of one element is useful, 
or whether one should systematically use & on a simple variable of the 
structure type.  I'm open to suggestions about either point.

julia
