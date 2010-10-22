Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab0JVN4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:56:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844Ab0JVN4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:56:43 -0400
Message-ID: <4CC19804.1080109@redhat.com>
Date: Fri, 22 Oct 2010 11:56:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: DVB: af9015 defunct [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CC07DB4.20205@gmail.com> <4CC1577F.9060207@gmail.com>
In-Reply-To: <4CC1577F.9060207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-10-2010 07:21, Jiri Slaby escreveu:
> On 10/21/2010 07:51 PM, Jiri Slaby wrote:
>> On 10/21/2010 12:01 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2010-10-20-15-01 has been uploaded to
>>
>> Well, this release happens to be a multimedia failure :(.
>>
>> I hit another regression against mmotm 2010-10-13-17-13, where
>> 0413:6029 (DVB USB tuner) can't be inited when plugged in. Even lsusb
>> waits inifitely.
> 
> Revert of this commit helps:


Ah, the problem is here (drivers/media/dvb/dvb-usb/af9015.c):

static struct tda18271_config af9015_tda18271_config = {
	.gate = TDA18271_GATE_DIGITAL,
	.small_i2c = 1,
};

small_i2c is an enum, currently defined as:

enum tda18271_small_i2c {
        TDA18271_39_BYTE_CHUNK_INIT = 0,
	TDA18271_16_BYTE_CHUNK_INIT = 16,
	TDA18271_08_BYTE_CHUNK_INIT = 8,
	TDA18271_03_BYTE_CHUNK_INIT = 3,
};

The value is just a magic number, but having it associated with the max
I2C size makes more sense than a random value.

The value, before the patch was:

enum tda18271_small_i2c {
        TDA18271_39_BYTE_CHUNK_INIT = 0,
	TDA18271_16_BYTE_CHUNK_INIT = 1,
	TDA18271_08_BYTE_CHUNK_INIT = 2,
};

So, it seems that the max I2C size for af9015 is 16 bytes. The proper init
should be:

	.small_i2c = TDA18271_16_BYTE_CHUNK_INIT;

Please check if the enclosed patch fixes the issue.

Thanks,
Mauro

---

[media] af9015: Properly initialize tda18271.small_i2c

As reported by Jiri, a regression at mm series is happening on af9015:

tda18271 18-00c0: creating new instance
TDA18271HD/C2 detected @ 18-00c0
af9015: command failed:1
tda18271_write_regs: [18-00c0|M] ERROR: idx = 0x0, len = 39,
i2c_transfer returned: -1
af9015: command failed:1

The cause is that tda18271.small_i2c is an enum. Drivers should use the value
alias, instead of its number, as the "magic" number may change anytime.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 759cbf8..f5e4066 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1144,7 +1144,7 @@ static struct qt1010_config af9015_qt1010_config = {
 
 static struct tda18271_config af9015_tda18271_config = {
 	.gate = TDA18271_GATE_DIGITAL,
-	.small_i2c = 1,
+	.small_i2c = TDA18271_16_BYTE_CHUNK_INIT;,
 };
 
 static struct mxl5005s_config af9015_mxl5003_config = {
