Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab0J0RGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:06:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab0J0RGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:06:14 -0400
Message-ID: <4CC85BD1.5080907@redhat.com>
Date: Wed, 27 Oct 2010 15:05:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: DVB: af9015 defunct [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CC07DB4.20205@gmail.com> <4CC1577F.9060207@gmail.com> <4CC19804.1080109@redhat.com> <4CC19A6E.8010909@gmail.com> <4CC84F60.7000409@redhat.com> <4CC85513.5060407@gmail.com>
In-Reply-To: <4CC85513.5060407@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-10-2010 14:36, Jiri Slaby escreveu:

>> It will properly log the size of the message the driver tried to use, and will
>> reduce the max number of bytes per I2C transfer to 8.
> 
> Yes, this one works. And to be sure that 16 doesn't work I unplugged and
> replugged the device (I didn't last time). And boom, it works too. So
> .small_i2c = TDA18271_16_BYTE_CHUNK_INIT fixes the issue as well.

Ok, I'm adding the enclosing patch to the tree, adding a proper description
about the regression. 

I'll be adding it to the tree.

Thanks!
Mauro

---

commit 7655e594945289b418af39f6669fea4666a7b520
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Wed Oct 27 14:55:34 2010 -0200

    [media] af9015: Fix max I2C message size when used with tda18271
    
    Changeset 1724c8fa7eb33d68898e060a08a8e6a88348b62f added an option to change
    the maximum I2C size to 8 bytes. However, it forgot to replace the previous
    usage at af9015 to use the newly defined macro value
    (TDA18271_16_BYTE_CHUNK_INIT).
    
    A latter changeset (e350d44fed8eb86a7192a579e3687fcd76a4645b) extended the
    possible values for .small_i2c field and, instead of using a random sequence
    of numbers, it used a number that makes more sense (e. g. the actual limit,
    in terms of bytes).
    
    However, as af9015 were using .small_i2c = 1, this become undefined, and the
    restriction of a max size of 16 was gone.
    
    While here, fix the reported msg size at tda18271-common.c.
    
    Reported-by: Jiri Slaby <jirislaby@gmail.com>
    Tested-by: Jiri Slaby <jirislaby@gmail.com>
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
index 3ef19a8..31c0a0e 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1131,7 +1131,7 @@ static struct qt1010_config af9015_qt1010_config = {
 
 static struct tda18271_config af9015_tda18271_config = {
 	.gate = TDA18271_GATE_DIGITAL,
-	.small_i2c = 1,
+	.small_i2c = TDA18271_16_BYTE_CHUNK_INIT,
 };
 
 static struct mxl5005s_config af9015_mxl5003_config = {


