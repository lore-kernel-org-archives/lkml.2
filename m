Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab2JHFMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:12:39 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:6082 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab2JHFMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:12:38 -0400
X-IronPort-AV: E=Sophos;i="4.80,549,1344204000"; 
   d="scan'208";a="176191747"
Date: Mon, 8 Oct 2012 07:12:34 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Ryan Mallon <rmallon@gmail.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, shubhrajyoti@ti.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/13] drivers/media/tuners: use macros for i2c_msg
 initialization
In-Reply-To: <5071FCC3.5070200@gmail.com>
Message-ID: <alpine.DEB.2.02.1210080707560.1972@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-7-git-send-email-Julia.Lawall@lip6.fr> <5071FCC3.5070200@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can see, the comments on this are:

&b[0] should be just b
There should be a newline before the elements of a multi-element array
Some one-element array buffers should just be variables
sizeof(val) should be used

I will redo the patches to include the first two, but not the others.

I will send another set of patches for the third one.  It seems like the 
conclusion is that the buffer should always be a variable if it can, but 
the message should always be an array for uniformity in the call to 
i2c_transfer.

I believe that the fourth one is not correct.  The variable in question is 
a pointer, so sizeof would give the wrong result.  If it is preferred, I 
could not use sizeof for the other structure in the same code, but it 
seems just a little safer to use it.

thanks,
julia


On Mon, 8 Oct 2012, Ryan Mallon wrote:

> On 08/10/12 02:38, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Introduce use of I2c_MSG_READ/WRITE/OP, for readability.
>>
>> A length expressed as an explicit constant is also re-expressed as the size
>> of the buffer, when this is possible.
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
>>  drivers/media/tuners/fc0012.c       |    8 +++-----
>>  drivers/media/tuners/fc0013.c       |    8 +++-----
>>  drivers/media/tuners/mc44s803.c     |    8 +++-----
>>  drivers/media/tuners/mt2060.c       |   13 +++++--------
>>  drivers/media/tuners/mt2063.c       |   23 ++++++-----------------
>>  drivers/media/tuners/mt2131.c       |   13 +++++--------
>>  drivers/media/tuners/mt2266.c       |   13 +++++--------
>>  drivers/media/tuners/mxl5005s.c     |    8 ++++----
>>  drivers/media/tuners/tda827x.c      |   29 +++++++++++------------------
>>  drivers/media/tuners/tuner-i2c.h    |   12 ++++--------
>>  drivers/media/tuners/tuner-simple.c |    5 +----
>>  drivers/media/tuners/xc4000.c       |    9 +++------
>>  drivers/media/tuners/xc5000.c       |    9 +++------
>>  13 files changed, 56 insertions(+), 102 deletions(-)
>>
>> diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
>> index 308135a..01dac7e 100644
>> --- a/drivers/media/tuners/fc0012.c
>> +++ b/drivers/media/tuners/fc0012.c
>> @@ -24,9 +24,7 @@
>>  static int fc0012_writereg(struct fc0012_priv *priv, u8 reg, u8 val)
>>  {
>>  	u8 buf[2] = {reg, val};
>> -	struct i2c_msg msg = {
>> -		.addr = priv->addr, .flags = 0, .buf = buf, .len = 2
>> -	};
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->addr, buf, sizeof(buf));
>>
>>  	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
>>  		err("I2C write reg failed, reg: %02x, val: %02x", reg, val);
>> @@ -38,8 +36,8 @@ static int fc0012_writereg(struct fc0012_priv *priv, u8 reg, u8 val)
>>  static int fc0012_readreg(struct fc0012_priv *priv, u8 reg, u8 *val)
>>  {
>>  	struct i2c_msg msg[2] = {
>> -		{ .addr = priv->addr, .flags = 0, .buf = &reg, .len = 1 },
>> -		{ .addr = priv->addr, .flags = I2C_M_RD, .buf = val, .len = 1 },
>> +		I2C_MSG_WRITE(priv->addr, &reg, sizeof(reg)),
>> +		I2C_MSG_READ(priv->addr, val, 1),
>>  	};
>>
>>  	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
>> diff --git a/drivers/media/tuners/fc0013.c b/drivers/media/tuners/fc0013.c
>> index bd8f0f1..174f0b0 100644
>> --- a/drivers/media/tuners/fc0013.c
>> +++ b/drivers/media/tuners/fc0013.c
>> @@ -27,9 +27,7 @@
>>  static int fc0013_writereg(struct fc0013_priv *priv, u8 reg, u8 val)
>>  {
>>  	u8 buf[2] = {reg, val};
>> -	struct i2c_msg msg = {
>> -		.addr = priv->addr, .flags = 0, .buf = buf, .len = 2
>> -	};
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->addr, buf, sizeof(buf));
>>
>>  	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
>>  		err("I2C write reg failed, reg: %02x, val: %02x", reg, val);
>> @@ -41,8 +39,8 @@ static int fc0013_writereg(struct fc0013_priv *priv, u8 reg, u8 val)
>>  static int fc0013_readreg(struct fc0013_priv *priv, u8 reg, u8 *val)
>>  {
>>  	struct i2c_msg msg[2] = {
>> -		{ .addr = priv->addr, .flags = 0, .buf = &reg, .len = 1 },
>> -		{ .addr = priv->addr, .flags = I2C_M_RD, .buf = val, .len = 1 },
>> +		I2C_MSG_WRITE(priv->addr, &reg, sizeof(reg)),
>> +		I2C_MSG_READ(priv->addr, val, 1),
>>  	};
>>
>>  	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
>> diff --git a/drivers/media/tuners/mc44s803.c b/drivers/media/tuners/mc44s803.c
>> index f1b7640..df47e03 100644
>> --- a/drivers/media/tuners/mc44s803.c
>> +++ b/drivers/media/tuners/mc44s803.c
>> @@ -37,9 +37,8 @@
>>  static int mc44s803_writereg(struct mc44s803_priv *priv, u32 val)
>>  {
>>  	u8 buf[3];
>> -	struct i2c_msg msg = {
>> -		.addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = 3
>> -	};
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->cfg->i2c_address, buf,
>> +					   sizeof(buf));
>>
>>  	buf[0] = (val & 0xff0000) >> 16;
>>  	buf[1] = (val & 0xff00) >> 8;
>> @@ -59,8 +58,7 @@ static int mc44s803_readreg(struct mc44s803_priv *priv, u8 reg, u32 *val)
>>  	u8 buf[3];
>>  	int ret;
>>  	struct i2c_msg msg[] = {
>> -		{ .addr = priv->cfg->i2c_address, .flags = I2C_M_RD,
>> -		  .buf = buf, .len = 3 },
>> +		I2C_MSG_READ(priv->cfg->i2c_address, buf, sizeof(buf)),
>>  	};
>>
>>  	wval = MC44S803_REG_SM(MC44S803_REG_DATAREG, MC44S803_ADDR) |
>> diff --git a/drivers/media/tuners/mt2060.c b/drivers/media/tuners/mt2060.c
>> index 13381de..5fb2e77 100644
>> --- a/drivers/media/tuners/mt2060.c
>> +++ b/drivers/media/tuners/mt2060.c
>> @@ -42,8 +42,8 @@ MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
>>  static int mt2060_readreg(struct mt2060_priv *priv, u8 reg, u8 *val)
>>  {
>>  	struct i2c_msg msg[2] = {
>> -		{ .addr = priv->cfg->i2c_address, .flags = 0,        .buf = &reg, .len = 1 },
>> -		{ .addr = priv->cfg->i2c_address, .flags = I2C_M_RD, .buf = val,  .len = 1 },
>> +		I2C_MSG_WRITE(priv->cfg->i2c_address, &reg, sizeof(reg)),
>> +		I2C_MSG_READ(priv->cfg->i2c_address, val, 1),
>
> Same here, should consistently use either sizeof(val) or 1 for single
> length items.
>
>>  	};
>>
>>  	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
>> @@ -57,9 +57,8 @@ static int mt2060_readreg(struct mt2060_priv *priv, u8 reg, u8 *val)
>>  static int mt2060_writereg(struct mt2060_priv *priv, u8 reg, u8 val)
>>  {
>>  	u8 buf[2] = { reg, val };
>> -	struct i2c_msg msg = {
>> -		.addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = 2
>> -	};
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->cfg->i2c_address, buf,
>> +					   sizeof(buf));
>>
>>  	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
>>  		printk(KERN_WARNING "mt2060 I2C write failed\n");
>> @@ -71,9 +70,7 @@ static int mt2060_writereg(struct mt2060_priv *priv, u8 reg, u8 val)
>>  // Writes a set of consecutive registers
>>  static int mt2060_writeregs(struct mt2060_priv *priv,u8 *buf, u8 len)
>>  {
>> -	struct i2c_msg msg = {
>> -		.addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = len
>> -	};
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->cfg->i2c_address, buf, len);
>>  	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
>>  		printk(KERN_WARNING "mt2060 I2C write failed (len=%i)\n",(int)len);
>>  		return -EREMOTEIO;
>> diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
>> index 0ed9091..c29f6f6 100644
>> --- a/drivers/media/tuners/mt2063.c
>> +++ b/drivers/media/tuners/mt2063.c
>> @@ -250,12 +250,8 @@ static u32 mt2063_write(struct mt2063_state *state, u8 reg, u8 *data, u32 len)
>>  	struct dvb_frontend *fe = state->frontend;
>>  	int ret;
>>  	u8 buf[60];
>> -	struct i2c_msg msg = {
>> -		.addr = state->config->tuner_address,
>> -		.flags = 0,
>> -		.buf = buf,
>> -		.len = len + 1
>> -	};
>> +	struct i2c_msg msg = I2C_MSG_WRITE(state->config->tuner_address, buf,
>> +					   len + 1);
>>
>>  	dprintk(2, "\n");
>>
>> @@ -313,17 +309,10 @@ static u32 mt2063_read(struct mt2063_state *state,
>>  	for (i = 0; i < cnt; i++) {
>>  		u8 b0[] = { subAddress + i };
>>  		struct i2c_msg msg[] = {
>> -			{
>> -				.addr = state->config->tuner_address,
>> -				.flags = 0,
>> -				.buf = b0,
>> -				.len = 1
>> -			}, {
>> -				.addr = state->config->tuner_address,
>> -				.flags = I2C_M_RD,
>> -				.buf = pData + i,
>> -				.len = 1
>> -			}
>> +			I2C_MSG_WRITE(state->config->tuner_address, b0,
>> +				      sizeof(b0)),
>> +			I2C_MSG_READ(state->config->tuner_address,
>> +				     pData + i, 1)
>
> Same here. The b0 "array" is pretty ugly, could easily be fixed in a
> follow up patch.
>
>>  		};
>>
>>  		status = i2c_transfer(state->i2c, msg, 2);
>> diff --git a/drivers/media/tuners/mt2131.c b/drivers/media/tuners/mt2131.c
>> index f83b0c1..a154901 100644
>> --- a/drivers/media/tuners/mt2131.c
>> +++ b/drivers/media/tuners/mt2131.c
>> @@ -53,10 +53,8 @@ static u8 mt2131_config2[] = {
>>  static int mt2131_readreg(struct mt2131_priv *priv, u8 reg, u8 *val)
>>  {
>>  	struct i2c_msg msg[2] = {
>> -		{ .addr = priv->cfg->i2c_address, .flags = 0,
>> -		  .buf = &reg, .len = 1 },
>> -		{ .addr = priv->cfg->i2c_address, .flags = I2C_M_RD,
>> -		  .buf = val,  .len = 1 },
>> +		I2C_MSG_WRITE(priv->cfg->i2c_address, &reg, sizeof(reg)),
>> +		I2C_MSG_READ(priv->cfg->i2c_address, val, 1),
>>  	};
>>
>>  	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
>> @@ -69,8 +67,8 @@ static int mt2131_readreg(struct mt2131_priv *priv, u8 reg, u8 *val)
>>  static int mt2131_writereg(struct mt2131_priv *priv, u8 reg, u8 val)
>>  {
>>  	u8 buf[2] = { reg, val };
>> -	struct i2c_msg msg = { .addr = priv->cfg->i2c_address, .flags = 0,
>> -			       .buf = buf, .len = 2 };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->cfg->i2c_address, buf,
>> +					   sizeof(buf));
>>
>>  	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
>>  		printk(KERN_WARNING "mt2131 I2C write failed\n");
>> @@ -81,8 +79,7 @@ static int mt2131_writereg(struct mt2131_priv *priv, u8 reg, u8 val)
>>
>>  static int mt2131_writeregs(struct mt2131_priv *priv,u8 *buf, u8 len)
>>  {
>> -	struct i2c_msg msg = { .addr = priv->cfg->i2c_address,
>> -			       .flags = 0, .buf = buf, .len = len };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->cfg->i2c_address, buf, len);
>>
>>  	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
>>  		printk(KERN_WARNING "mt2131 I2C write failed (len=%i)\n",
>> diff --git a/drivers/media/tuners/mt2266.c b/drivers/media/tuners/mt2266.c
>> index bca4d75..a714728 100644
>> --- a/drivers/media/tuners/mt2266.c
>> +++ b/drivers/media/tuners/mt2266.c
>> @@ -57,8 +57,8 @@ MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
>>  static int mt2266_readreg(struct mt2266_priv *priv, u8 reg, u8 *val)
>>  {
>>  	struct i2c_msg msg[2] = {
>> -		{ .addr = priv->cfg->i2c_address, .flags = 0,        .buf = &reg, .len = 1 },
>> -		{ .addr = priv->cfg->i2c_address, .flags = I2C_M_RD, .buf = val,  .len = 1 },
>> +		I2C_MSG_WRITE(priv->cfg->i2c_address, &reg, sizeof(reg)),
>> +		I2C_MSG_READ(priv->cfg->i2c_address, val, 1),
>
> And again.
>
>>  	};
>>  	if (i2c_transfer(priv->i2c, msg, 2) != 2) {
>>  		printk(KERN_WARNING "MT2266 I2C read failed\n");
>> @@ -71,9 +71,8 @@ static int mt2266_readreg(struct mt2266_priv *priv, u8 reg, u8 *val)
>>  static int mt2266_writereg(struct mt2266_priv *priv, u8 reg, u8 val)
>>  {
>>  	u8 buf[2] = { reg, val };
>> -	struct i2c_msg msg = {
>> -		.addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = 2
>> -	};
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->cfg->i2c_address, buf,
>> +					   sizeof(buf));
>>  	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
>>  		printk(KERN_WARNING "MT2266 I2C write failed\n");
>>  		return -EREMOTEIO;
>> @@ -84,9 +83,7 @@ static int mt2266_writereg(struct mt2266_priv *priv, u8 reg, u8 val)
>>  // Writes a set of consecutive registers
>>  static int mt2266_writeregs(struct mt2266_priv *priv,u8 *buf, u8 len)
>>  {
>> -	struct i2c_msg msg = {
>> -		.addr = priv->cfg->i2c_address, .flags = 0, .buf = buf, .len = len
>> -	};
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->cfg->i2c_address, buf, len);
>>  	if (i2c_transfer(priv->i2c, &msg, 1) != 1) {
>>  		printk(KERN_WARNING "MT2266 I2C write failed (len=%i)\n",(int)len);
>>  		return -EREMOTEIO;
>> diff --git a/drivers/media/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
>> index b473b76..c913322 100644
>> --- a/drivers/media/tuners/mxl5005s.c
>> +++ b/drivers/media/tuners/mxl5005s.c
>> @@ -3848,8 +3848,8 @@ static int mxl5005s_reset(struct dvb_frontend *fe)
>>  	int ret = 0;
>>
>>  	u8 buf[2] = { 0xff, 0x00 };
>> -	struct i2c_msg msg = { .addr = state->config->i2c_address, .flags = 0,
>> -			       .buf = buf, .len = 2 };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(state->config->i2c_address, buf,
>> +					   sizeof(buf));
>>
>>  	dprintk(2, "%s()\n", __func__);
>>
>> @@ -3874,8 +3874,8 @@ static int mxl5005s_writereg(struct dvb_frontend *fe, u8 reg, u8 val, int latch)
>>  {
>>  	struct mxl5005s_state *state = fe->tuner_priv;
>>  	u8 buf[3] = { reg, val, MXL5005S_LATCH_BYTE };
>> -	struct i2c_msg msg = { .addr = state->config->i2c_address, .flags = 0,
>> -			       .buf = buf, .len = 3 };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(state->config->i2c_address, buf,
>> +					   sizeof(buf));
>>
>>  	if (latch == 0)
>>  		msg.len = 2;
>> diff --git a/drivers/media/tuners/tda827x.c b/drivers/media/tuners/tda827x.c
>> index a0d1762..15a4802 100644
>> --- a/drivers/media/tuners/tda827x.c
>> +++ b/drivers/media/tuners/tda827x.c
>> @@ -159,8 +159,7 @@ static int tda827xo_set_params(struct dvb_frontend *fe)
>>  	u8 buf[14];
>>  	int rc;
>>
>> -	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
>> -			       .buf = buf, .len = sizeof(buf) };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_addr, buf, sizeof(buf));
>>  	int i, tuner_freq, if_freq;
>>  	u32 N;
>>
>> @@ -233,8 +232,7 @@ static int tda827xo_sleep(struct dvb_frontend *fe)
>>  {
>>  	struct tda827x_priv *priv = fe->tuner_priv;
>>  	static u8 buf[] = { 0x30, 0xd0 };
>> -	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
>> -			       .buf = buf, .len = sizeof(buf) };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_addr, buf, sizeof(buf));
>>
>>  	dprintk("%s:\n", __func__);
>>  	tuner_transfer(fe, &msg, 1);
>> @@ -255,7 +253,7 @@ static int tda827xo_set_analog_params(struct dvb_frontend *fe,
>>  	u32 N;
>>  	int i;
>>  	struct tda827x_priv *priv = fe->tuner_priv;
>> -	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0 };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_addr, NULL, 0);
>>  	unsigned int freq = params->frequency;
>>
>>  	tda827x_set_std(fe, params);
>> @@ -335,8 +333,7 @@ static void tda827xo_agcf(struct dvb_frontend *fe)
>>  {
>>  	struct tda827x_priv *priv = fe->tuner_priv;
>>  	unsigned char data[] = { 0x80, 0x0c };
>> -	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
>> -			       .buf = data, .len = 2};
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_addr, data, sizeof(data));
>>
>>  	tuner_transfer(fe, &msg, 1);
>>  }
>> @@ -445,8 +442,7 @@ static int tda827xa_sleep(struct dvb_frontend *fe)
>>  {
>>  	struct tda827x_priv *priv = fe->tuner_priv;
>>  	static u8 buf[] = { 0x30, 0x90 };
>> -	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
>> -			       .buf = buf, .len = sizeof(buf) };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_addr, buf, sizeof(buf));
>>
>>  	dprintk("%s:\n", __func__);
>>
>> @@ -465,7 +461,7 @@ static void tda827xa_lna_gain(struct dvb_frontend *fe, int high,
>>  	unsigned char buf[] = {0x22, 0x01};
>>  	int arg;
>>  	int gp_func;
>> -	struct i2c_msg msg = { .flags = 0, .buf = buf, .len = sizeof(buf) };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(0, buf, sizeof(buf));
>>
>>  	if (NULL == priv->cfg) {
>>  		dprintk("tda827x_config not defined, cannot set LNA gain!\n");
>> @@ -518,8 +514,7 @@ static int tda827xa_set_params(struct dvb_frontend *fe)
>>  	struct tda827xa_data *frequency_map = tda827xa_dvbt;
>>  	u8 buf[11];
>>
>> -	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
>> -			       .buf = buf, .len = sizeof(buf) };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_addr, buf, sizeof(buf));
>>
>>  	int i, tuner_freq, if_freq, rc;
>>  	u32 N;
>> @@ -665,8 +660,8 @@ static int tda827xa_set_analog_params(struct dvb_frontend *fe,
>>  	u32 N;
>>  	int i;
>>  	struct tda827x_priv *priv = fe->tuner_priv;
>> -	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
>> -			       .buf = tuner_reg, .len = sizeof(tuner_reg) };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_addr, tuner_reg,
>> +					   sizeof(tuner_reg));
>>  	unsigned int freq = params->frequency;
>>
>>  	tda827x_set_std(fe, params);
>> @@ -760,8 +755,7 @@ static void tda827xa_agcf(struct dvb_frontend *fe)
>>  {
>>  	struct tda827x_priv *priv = fe->tuner_priv;
>>  	unsigned char data[] = {0x80, 0x2c};
>> -	struct i2c_msg msg = {.addr = priv->i2c_addr, .flags = 0,
>> -			      .buf = data, .len = 2};
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_addr, data, sizeof(data));
>>  	tuner_transfer(fe, &msg, 1);
>>  }
>>
>> @@ -855,8 +849,7 @@ static int tda827x_probe_version(struct dvb_frontend *fe)
>>  	u8 data;
>>  	int rc;
>>  	struct tda827x_priv *priv = fe->tuner_priv;
>> -	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = I2C_M_RD,
>> -			       .buf = &data, .len = 1 };
>> +	struct i2c_msg msg = I2C_MSG_READ(priv->i2c_addr, &data, sizeof(data));
>>
>>  	rc = tuner_transfer(fe, &msg, 1);
>>
>> diff --git a/drivers/media/tuners/tuner-i2c.h b/drivers/media/tuners/tuner-i2c.h
>> index 18f0056..a8a6da6 100644
>> --- a/drivers/media/tuners/tuner-i2c.h
>> +++ b/drivers/media/tuners/tuner-i2c.h
>> @@ -35,8 +35,7 @@ struct tuner_i2c_props {
>>
>>  static inline int tuner_i2c_xfer_send(struct tuner_i2c_props *props, char *buf, int len)
>>  {
>> -	struct i2c_msg msg = { .addr = props->addr, .flags = 0,
>> -			       .buf = buf, .len = len };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(props->addr, buf, len);
>>  	int ret = i2c_transfer(props->adap, &msg, 1);
>>
>>  	return (ret == 1) ? len : ret;
>> @@ -44,8 +43,7 @@ static inline int tuner_i2c_xfer_send(struct tuner_i2c_props *props, char *buf,
>>
>>  static inline int tuner_i2c_xfer_recv(struct tuner_i2c_props *props, char *buf, int len)
>>  {
>> -	struct i2c_msg msg = { .addr = props->addr, .flags = I2C_M_RD,
>> -			       .buf = buf, .len = len };
>> +	struct i2c_msg msg = I2C_MSG_READ(props->addr, buf, len);
>>  	int ret = i2c_transfer(props->adap, &msg, 1);
>>
>>  	return (ret == 1) ? len : ret;
>> @@ -55,10 +53,8 @@ static inline int tuner_i2c_xfer_send_recv(struct tuner_i2c_props *props,
>>  					   char *obuf, int olen,
>>  					   char *ibuf, int ilen)
>>  {
>> -	struct i2c_msg msg[2] = { { .addr = props->addr, .flags = 0,
>> -				    .buf = obuf, .len = olen },
>> -				  { .addr = props->addr, .flags = I2C_M_RD,
>> -				    .buf = ibuf, .len = ilen } };
>> +	struct i2c_msg msg[2] = { I2C_MSG_WRITE(props->addr, obuf, olen),
>> +				  I2C_MSG_READ(props->addr, ibuf, ilen) };
>
> Consistent coding style with other initialisers would be:
>
> 	struct i2c_msg msg[2] = {
> 		I2C_MSG_WRITE(props->addr, obuf, olen),
> 		I2C_MSG_READ(props->addr, ibuf, ilen),
> 	};
>
>>  	int ret = i2c_transfer(props->adap, msg, 2);
>>
>>  	return (ret == 2) ? ilen : ret;
>> diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
>> index 39e7e58..df5ba78 100644
>> --- a/drivers/media/tuners/tuner-simple.c
>> +++ b/drivers/media/tuners/tuner-simple.c
>> @@ -1065,10 +1065,7 @@ struct dvb_frontend *simple_tuner_attach(struct dvb_frontend *fe,
>>  	 */
>>  	if (i2c_adap != NULL) {
>>  		u8 b[1];
>> -		struct i2c_msg msg = {
>> -			.addr = i2c_addr, .flags = I2C_M_RD,
>> -			.buf = b, .len = 1,
>> -		};
>> +		struct i2c_msg msg = I2C_MSG_READ(i2c_addr, b, sizeof(b));
>
> More silly "arrays" :-/. Can be fixed later.
>
>>
>>  		if (fe->ops.i2c_gate_ctrl)
>>  			fe->ops.i2c_gate_ctrl(fe, 1);
>> diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
>> index 4937712..7b65b6b 100644
>> --- a/drivers/media/tuners/xc4000.c
>> +++ b/drivers/media/tuners/xc4000.c
>> @@ -256,8 +256,7 @@ static void xc_debug_dump(struct xc4000_priv *priv);
>>
>>  static int xc_send_i2c_data(struct xc4000_priv *priv, u8 *buf, int len)
>>  {
>> -	struct i2c_msg msg = { .addr = priv->i2c_props.addr,
>> -			       .flags = 0, .buf = buf, .len = len };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_props.addr, buf, len);
>>  	if (i2c_transfer(priv->i2c_props.adap, &msg, 1) != 1) {
>>  		if (priv->ignore_i2c_write_errors == 0) {
>>  			printk(KERN_ERR "xc4000: I2C write failed (len=%i)\n",
>> @@ -550,10 +549,8 @@ static int xc4000_readreg(struct xc4000_priv *priv, u16 reg, u16 *val)
>>  	u8 buf[2] = { reg >> 8, reg & 0xff };
>>  	u8 bval[2] = { 0, 0 };
>>  	struct i2c_msg msg[2] = {
>> -		{ .addr = priv->i2c_props.addr,
>> -			.flags = 0, .buf = &buf[0], .len = 2 },
>> -		{ .addr = priv->i2c_props.addr,
>> -			.flags = I2C_M_RD, .buf = &bval[0], .len = 2 },
>> +		I2C_MSG_WRITE(priv->i2c_props.addr, &buf[0], sizeof(buf)),
>> +		I2C_MSG_READ(priv->i2c_props.addr, &bval[0], sizeof(bval)),
>
> &buf[0] == buf. Might as well fix this now, the way it is written is
> just silly.
>
>>  	};
>>
>>  	if (i2c_transfer(priv->i2c_props.adap, msg, 2) != 2) {
>> diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
>> index dc93cf3..33b6b1e 100644
>> --- a/drivers/media/tuners/xc5000.c
>> +++ b/drivers/media/tuners/xc5000.c
>> @@ -253,8 +253,7 @@ static int xc5000_TunerReset(struct dvb_frontend *fe);
>>
>>  static int xc_send_i2c_data(struct xc5000_priv *priv, u8 *buf, int len)
>>  {
>> -	struct i2c_msg msg = { .addr = priv->i2c_props.addr,
>> -			       .flags = 0, .buf = buf, .len = len };
>> +	struct i2c_msg msg = I2C_MSG_WRITE(priv->i2c_props.addr, buf, len);
>>
>>  	if (i2c_transfer(priv->i2c_props.adap, &msg, 1) != 1) {
>>  		printk(KERN_ERR "xc5000: I2C write failed (len=%i)\n", len);
>> @@ -285,10 +284,8 @@ static int xc5000_readreg(struct xc5000_priv *priv, u16 reg, u16 *val)
>>  	u8 buf[2] = { reg >> 8, reg & 0xff };
>>  	u8 bval[2] = { 0, 0 };
>>  	struct i2c_msg msg[2] = {
>> -		{ .addr = priv->i2c_props.addr,
>> -			.flags = 0, .buf = &buf[0], .len = 2 },
>> -		{ .addr = priv->i2c_props.addr,
>> -			.flags = I2C_M_RD, .buf = &bval[0], .len = 2 },
>> +		I2C_MSG_WRITE(priv->i2c_props.addr, &buf[0], sizeof(buf)),
>> +		I2C_MSG_READ(priv->i2c_props.addr, &bval[0], sizeof(bval)),
>
> Same here, change &buf[0] to buf.
>
>>  	};
>>
>>  	if (i2c_transfer(priv->i2c_props.adap, msg, 2) != 2) {
>>
>
> ~Ryan
>
>
