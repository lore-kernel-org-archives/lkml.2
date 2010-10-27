Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab0J0QMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:12:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761298Ab0J0QMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:12:48 -0400
Message-ID: <4CC84F60.7000409@redhat.com>
Date: Wed, 27 Oct 2010 14:12:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: DVB: af9015 defunct [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CC07DB4.20205@gmail.com> <4CC1577F.9060207@gmail.com> <4CC19804.1080109@redhat.com> <4CC19A6E.8010909@gmail.com>
In-Reply-To: <4CC19A6E.8010909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-10-2010 12:06, Jiri Slaby escreveu:
> On 10/22/2010 03:56 PM, Mauro Carvalho Chehab wrote:
>> --- a/drivers/media/dvb/dvb-usb/af9015.c
>> +++ b/drivers/media/dvb/dvb-usb/af9015.c
>> @@ -1144,7 +1144,7 @@ static struct qt1010_config af9015_qt1010_config = {
>>  
>>  static struct tda18271_config af9015_tda18271_config = {
>>  	.gate = TDA18271_GATE_DIGITAL,
>> -	.small_i2c = 1,
>> +	.small_i2c = TDA18271_16_BYTE_CHUNK_INIT;,
> 
> No, it doesn't help (note the i2c line which prints the small_i2c entry):
> dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in cold state, will
> try to load a firmware
> dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
> dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software
> demuxer.
> DVB: registering new adapter (Leadtek WinFast DTV Dongle Gold)
> af9013: firmware version:4.95.0.0
> DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
> af9015_tuner_attach: i2c 16
> tda18271 16-00c0: creating new instance
> TDA18271HD/C2 detected @ 16-00c0
> af9015: command failed:1

> tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x0, len = 39,
> i2c_transfer returned: -1

Hmm...

int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
{
...
        switch (priv->small_i2c) {
        case TDA18271_03_BYTE_CHUNK_INIT:
                max = 3;
                break;
        case TDA18271_08_BYTE_CHUNK_INIT:
                max = 8;
                break;
        case TDA18271_16_BYTE_CHUNK_INIT:
                max = 16;
                break;
        case TDA18271_39_BYTE_CHUNK_INIT:
        default:
                max = 39;
        }


with small_i2c = 1, the driver will not restrict the maximum length size.

It's weird that the patch didn't fix it. Are you sure that reverting this
patch is enough to make the driver work?

Please test this one.

It will properly log the size of the message the driver tried to use, and will
reduce the max number of bytes per I2C transfer to 8.

Cheers,
Mauro

---

Fix tda18271 usage with af9015 

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tda18271-common.c b/drivers/media/common/tuners/tda18271-common.c
index 195b30e..5466d47 100644
--- a/drivers/media/common/tuners/tda18271-common.c
+++ b/drivers/media/common/tuners/tda18271-common.c
@@ -237,7 +237,7 @@ int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
 
 	if (ret != 1)
 		tda_err("ERROR: idx = 0x%x, len = %d, "
-			"i2c_transfer returned: %d\n", idx, len, ret);
+			"i2c_transfer returned: %d\n", idx, max, ret);
 
 	return (ret == 1 ? 0 : ret);
 }
diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 3ef19a8..e3c9bb5 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1131,7 +1131,7 @@ static struct qt1010_config af9015_qt1010_config = {
 
 static struct tda18271_config af9015_tda18271_config = {
 	.gate = TDA18271_GATE_DIGITAL,
-	.small_i2c = 1,
+	.small_i2c = TDA18271_08_BYTE_CHUNK_INIT,
 };
 
 static struct mxl5005s_config af9015_mxl5003_config = {

	
