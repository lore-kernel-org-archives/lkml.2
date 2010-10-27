Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab0J0Qgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:36:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46599 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0J0Qgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gXl6YaDU26h68jgNdFMNNPoOu/HZ4tMi11sb+1N6Y5VQfXvBxSCplP7Cuml6KZzbUH
         E3L5GpQcY9FWltBMqVvbgaZ+GaHM5ITFAGlXeK78L8FCS+F57ABBBMm53PnAWtQkKHdE
         sLg3ZK/PJG9qWBT3rseKs2fK21rU/v58FI5uU=
Message-ID: <4CC85513.5060407@gmail.com>
Date: Wed, 27 Oct 2010 18:36:35 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: DVB: af9015 defunct [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CC07DB4.20205@gmail.com> <4CC1577F.9060207@gmail.com> <4CC19804.1080109@redhat.com> <4CC19A6E.8010909@gmail.com> <4CC84F60.7000409@redhat.com>
In-Reply-To: <4CC84F60.7000409@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 06:12 PM, Mauro Carvalho Chehab wrote:
> Em 22-10-2010 12:06, Jiri Slaby escreveu:
>> On 10/22/2010 03:56 PM, Mauro Carvalho Chehab wrote:
>>> --- a/drivers/media/dvb/dvb-usb/af9015.c
>>> +++ b/drivers/media/dvb/dvb-usb/af9015.c
>>> @@ -1144,7 +1144,7 @@ static struct qt1010_config af9015_qt1010_config = {
>>>  
>>>  static struct tda18271_config af9015_tda18271_config = {
>>>  	.gate = TDA18271_GATE_DIGITAL,
>>> -	.small_i2c = 1,
>>> +	.small_i2c = TDA18271_16_BYTE_CHUNK_INIT;,
>>
>> No, it doesn't help (note the i2c line which prints the small_i2c entry):
>> dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in cold state, will
>> try to load a firmware
>> dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
>> dvb-usb: found a 'Leadtek WinFast DTV Dongle Gold' in warm state.
>> dvb-usb: will pass the complete MPEG2 transport stream to the software
>> demuxer.
>> DVB: registering new adapter (Leadtek WinFast DTV Dongle Gold)
>> af9013: firmware version:4.95.0.0
>> DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
>> af9015_tuner_attach: i2c 16
>> tda18271 16-00c0: creating new instance
>> TDA18271HD/C2 detected @ 16-00c0
>> af9015: command failed:1
> 
>> tda18271_write_regs: [16-00c0|M] ERROR: idx = 0x0, len = 39,
>> i2c_transfer returned: -1
> 
> Hmm...
> 
> int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
> {
> ...
>         switch (priv->small_i2c) {
>         case TDA18271_03_BYTE_CHUNK_INIT:
>                 max = 3;
>                 break;
>         case TDA18271_08_BYTE_CHUNK_INIT:
>                 max = 8;
>                 break;
>         case TDA18271_16_BYTE_CHUNK_INIT:
>                 max = 16;
>                 break;
>         case TDA18271_39_BYTE_CHUNK_INIT:
>         default:
>                 max = 39;
>         }
> 
> 
> with small_i2c = 1, the driver will not restrict the maximum length size.

Actually it will make it 39.

> It's weird that the patch didn't fix it. Are you sure that reverting this
> patch is enough to make the driver work?

Yes, I'm 100% sure.

> Please test this one.
> 
> It will properly log the size of the message the driver tried to use, and will
> reduce the max number of bytes per I2C transfer to 8.

Yes, this one works. And to be sure that 16 doesn't work I unplugged and
replugged the device (I didn't last time). And boom, it works too. So
.small_i2c = TDA18271_16_BYTE_CHUNK_INIT fixes the issue as well.

> --- a/drivers/media/dvb/dvb-usb/af9015.c
> +++ b/drivers/media/dvb/dvb-usb/af9015.c
> @@ -1131,7 +1131,7 @@ static struct qt1010_config af9015_qt1010_config = {
>  
>  static struct tda18271_config af9015_tda18271_config = {
>  	.gate = TDA18271_GATE_DIGITAL,
> -	.small_i2c = 1,
> +	.small_i2c = TDA18271_08_BYTE_CHUNK_INIT,
>  };
>  
>  static struct mxl5005s_config af9015_mxl5003_config = {

thanks,
-- 
js
