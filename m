Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0J0QhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 12:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab0J0QhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 12:37:12 -0400
Message-ID: <4CC8550B.4060403@redhat.com>
Date: Wed, 27 Oct 2010 14:36:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [GIT PULL for 2.6.37-rc1] V4L/DVB updates
References: <4CC8380D.3040802@redhat.com> <4CC84597.4000204@gmail.com> <4CC84846.6020304@redhat.com> <4CC84B14.1030303@gmail.com>
In-Reply-To: <4CC84B14.1030303@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-10-2010 13:53, Jiri Slaby escreveu:
> On 10/27/2010 05:41 PM, Mauro Carvalho Chehab wrote:
>> Hi Jiri,
>>
>> Em 27-10-2010 13:30, Jiri Slaby escreveu:
>>> On 10/27/2010 04:32 PM, Mauro Carvalho Chehab wrote:
>>>> Linus,
>>>>
>>>> Please pull from
>>>> 	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus
>>> ...
>>>> Mauro Carvalho Chehab (72):
>>> ...
>>>>       [media] tda18271: allow restricting max out to 4 bytes
>>>
>>> Even though you know this one breaks at least one driver you want it merged?
>>
>> We need to fix that issue with af9015, but, without this patch, cx231xx is broken, as it
>> doesn't accept more than 4 bytes per I2C transfer. I tested the patch here with some possible
>> restrictions for I2C size. Also, Mkrufky tested it with other different hardware.
> 
> I think the rule is "no regressions". Was cx231xx broken by some recent
> change or was it broken forever?
> 
> Anyway the patch itself is in -next as of next-20101019. What the hell
> is -next good for then if people skip it? (Yes, 10 workdays is too few
> for people to really test kernels. Especially when we are talking about
> DVB.)
> 
>> What I don't understand is that the only change that this patch caused for af9015 is to change
>> the I2C max size that used to be 16. The patch I sent you reverted this behaviour, by using
>> the proper macro value, instead of a magic number, but you reported that this didn't fix your
>> problem.
> 
> What about this hunk? Could it be a source of the problem?
> @@ -326,24 +352,7 @@ int tda18271_init_regs(struct dvb_frontend *fe)
>         regs[R_EB22] = 0x48;
>         regs[R_EB23] = 0xb0;
> 
> -       switch (priv->small_i2c) {
> -       case TDA18271_08_BYTE_CHUNK_INIT:
> -               tda18271_write_regs(fe, 0x00, 0x08);
> -               tda18271_write_regs(fe, 0x08, 0x08);
> -               tda18271_write_regs(fe, 0x10, 0x08);
> -               tda18271_write_regs(fe, 0x18, 0x08);
> -               tda18271_write_regs(fe, 0x20, 0x07);
> -               break;
> -       case TDA18271_16_BYTE_CHUNK_INIT:
> -               tda18271_write_regs(fe, 0x00, 0x10);
> -               tda18271_write_regs(fe, 0x10, 0x10);
> -               tda18271_write_regs(fe, 0x20, 0x07);
> -               break;
> -       case TDA18271_39_BYTE_CHUNK_INIT:
> -       default:
>                 tda18271_write_regs(fe, 0x00, TDA18271_NUM_REGS);
> -               break;
> -       }
> 
>         /* setup agc1 gain */
>         regs[R_EB17] = 0x00;
> 
> Previously it wrote 3 values, now it writes only one.

No. Previously, the init_regs were manually breaking the 0x39 register initialization
on several calls to tda18271_write_regs().

What the patch did were to move the logic of breaking the data into smaller groups
to happen inside tda18271_write_regs().

So, while the old logic broke it on 3 writes, being the first one from registers
0x00 to 0x0f, the second from 0x10 to 0x1f and the third from 0x20 to 0x27, the new
code breaks it inside tda18271_write_regs().

The old logic is broken, since there are some parts of the code calling tda18271_write_regs()
with a size that were bigger than the maximum supported size.

If you take a look at the code, before this patch, you'll see places where more than the maximum
allowed size is used. For example:

http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/common/tuners/tda18271-common.c;h=e1f678281a58d327752dfcf24dc72ccf1d93ff79;hb=1724c8fa7eb33d68898e060a08a8e6a88348b62f#l385

The driver is wring 11 values:
	tda18271_write_regs(fe, R_EP3, 11);

This doesn't honor the max size of 8 bytes, if small_i2c = TDA18271_08_BYTE_CHUNK_INIT.

My patch basically did:

1) it moved the logic that restricts the maximum size to be inside tda18271_write_regs();
2) it added a new max size of 4 bytes;
3) It renamed the magic values associated with small_i2c.

Basically, af9015 broke due to (3), as .small_i2c = 1 means nothing. It should be using
.small_i2c = TDA18271_16_BYTE_CHUNK_INIT, instead.

What I don't understand is why a patch doing this change didn't fix the issue. Please
test the patch I posted on the original -next thread. Let's try to identify why
tda18271_write_regs() is not breaking the data into smaller writes.

Cheers,
Mauro
