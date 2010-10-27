Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab0J0PyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:54:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34359 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0J0PyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KpTzb4Qy5zQzEzOJTkyMQ+n9HZ8Chg4S0UhWHLoLROk1K3SMEOSS7JPiLP2L7D0ofK
         hLZUcJoMSad3gUmwbRZjFxXiRdAxEUViAfQaV59BzwBEvaitpanEybERKj8ytv1fRKAG
         yN75qqbFEMPjUaKAbL+qwKU6IoXs7TxbkDvO0=
Message-ID: <4CC84B14.1030303@gmail.com>
Date: Wed, 27 Oct 2010 17:53:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com> <4CC84597.4000204@gmail.com> <4CC84846.6020304@redhat.com>
In-Reply-To: <4CC84846.6020304@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 05:41 PM, Mauro Carvalho Chehab wrote:
> Hi Jiri,
> 
> Em 27-10-2010 13:30, Jiri Slaby escreveu:
>> On 10/27/2010 04:32 PM, Mauro Carvalho Chehab wrote:
>>> Linus,
>>>
>>> Please pull from
>>> 	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
>> ...
>>> Mauro Carvalho Chehab (72):
>> ...
>>>       [media] tda18271: allow restricting max out to 4 bytes
>>
>> Even though you know this one breaks at least one driver you want it merged?
> 
> We need to fix that issue with af9015, but, without this patch, cx231xx is broken, as it
> doesn't accept more than 4 bytes per I2C transfer. I tested the patch here with some possible
> restrictions for I2C size. Also, Mkrufky tested it with other different hardware.

I think the rule is "no regressions". Was cx231xx broken by some recent
change or was it broken forever?

Anyway the patch itself is in -next as of next-20101019. What the hell
is -next good for then if people skip it? (Yes, 10 workdays is too few
for people to really test kernels. Especially when we are talking about
DVB.)

> What I don't understand is that the only change that this patch caused for af9015 is to change
> the I2C max size that used to be 16. The patch I sent you reverted this behaviour, by using
> the proper macro value, instead of a magic number, but you reported that this didn't fix your
> problem.

What about this hunk? Could it be a source of the problem?
@@ -326,24 +352,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
        regs[R_EB22] = 0x48;
        regs[R_EB23] = 0xb0;

-       switch (priv->small_i2c) {
-       case TDA18271_08_BYTE_CHUNK_INIT:
-               tda18271_write_regs(fe, 0x00, 0x08);
-               tda18271_write_regs(fe, 0x08, 0x08);
-               tda18271_write_regs(fe, 0x10, 0x08);
-               tda18271_write_regs(fe, 0x18, 0x08);
-               tda18271_write_regs(fe, 0x20, 0x07);
-               break;
-       case TDA18271_16_BYTE_CHUNK_INIT:
-               tda18271_write_regs(fe, 0x00, 0x10);
-               tda18271_write_regs(fe, 0x10, 0x10);
-               tda18271_write_regs(fe, 0x20, 0x07);
-               break;
-       case TDA18271_39_BYTE_CHUNK_INIT:
-       default:
                tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS);
-               break;
-       }

        /* setup agc1 gain */
        regs[R_EB17] = 0x00;

Previously it wrote 3 values, now it writes only one.

> So, we need to figure out what af9015 is doing different than the other patches, and add patch 
> the issue with af9015. It shouldn't be hard to fix. I'll keep working with you in order to solve
> the issue, although I don't have any af90xx hardware here, so, I need your help with the tests.

I will test whatever you send me. I have nothing to test yet...

So I personally NACK this patch whatever it means.

thanks,
-- 
js
