Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2JGQvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:51:05 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:19991 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab2JGQu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:50:59 -0400
X-IronPort-AV: E=Sophos;i="4.80,547,1344204000"; 
   d="scan'208";a="176157429"
Date: Sun, 7 Oct 2012 18:50:31 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: walter harms <wharms@bfs.de>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Michael Buesch <m@bues.ch>,
        kernel-janitors@vger.kernel.org, rmallon@gmail.com,
        shubhrajyoti@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/13] drivers/media/tuners/fc0011.c: use macros for
 i2c_msg initialization
In-Reply-To: <5071B147.3010708@bfs.de>
Message-ID: <alpine.DEB.2.02.1210071845030.2745@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-11-git-send-email-Julia.Lawall@lip6.fr> <5071B147.3010708@bfs.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2012, walter harms wrote:

>
>
> Am 07.10.2012 17:38, schrieb Julia Lawall:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Introduce use of I2c_MSG_READ/WRITE/OP, for readability.
>>
>> A length expressed as an explicit constant is also re-expressed as the size
>> of the buffer in each case.
>>
>> A simplified version of the semantic patch that makes this change is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression a,b,c;
>> identifier x;
>> @@
>>
>> struct i2c_msg x =
>> - {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
>> + I2C_MSG_READ(a,b,c)
>>  ;
>>
>> @@
>> expression a,b,c;
>> identifier x;
>> @@
>>
>> struct i2c_msg x =
>> - {.addr = a, .buf = b, .len = c, .flags = 0}
>> + I2C_MSG_WRITE(a,b,c)
>>  ;
>>
>> @@
>> expression a,b,c,d;
>> identifier x;
>> @@
>>
>> struct i2c_msg x =
>> - {.addr = a, .buf = b, .len = c, .flags = d}
>> + I2C_MSG_OP(a,b,c,d)
>>  ;
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>>  drivers/media/tuners/fc0011.c |    9 +++------
>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/tuners/fc0011.c b/drivers/media/tuners/fc0011.c
>> index e488254..5dbba98 100644
>> --- a/drivers/media/tuners/fc0011.c
>> +++ b/drivers/media/tuners/fc0011.c
>> @@ -80,8 +80,7 @@ struct fc0011_priv {
>>  static int fc0011_writereg(struct fc0011_priv *priv, u8 reg, u8 val)
>>  {
>>  	u8 buf[2] = { reg, val };
>> -	struct i2c_msg msg = { .addr = priv->addr,
>> -		.flags = 0, .buf = buf, .len = 2 };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->addr, buf, sizeof(buf));
>>
>>  	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
>>  		dev_err(&priv->i2c->dev,
>> @@ -97,10 +96,8 @@ static int fc0011_readreg(struct fc0011_priv *priv, u8 reg, u8 *val)
>>  {
>>  	u8 dummy;
>>  	struct i2c_msg msg[2] = {
>> -		{ .addr = priv->addr,
>> -		  .flags = 0, .buf = &reg, .len = 1 },
>> -		{ .addr = priv->addr,
>> -		  .flags = I2C_M_RD, .buf = val ? : &dummy, .len = 1 },
>> +		I2C_MSG_WRITE(priv->addr, &reg, sizeof(reg)),
>> +		I2C_MSG_READ(priv->addr, val ? : &dummy, sizeof(dummy)),
>>  	};
>>
>
> This dummy looks strange, can it be that this is used uninitialised ?

I'm not sure to understand the question.  The read, when it happens in 
i2c_transfer will initialize dummy.  On the other hand, I don't know what 
i2c_transfer does when the buffer is NULL and the size is 1.  It does not 
look very elegant at least.

julia
