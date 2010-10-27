Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab0J0RLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:11:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab0J0RLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:11:39 -0400
Message-ID: <4CC85D34.7010603@redhat.com>
Date: Wed, 27 Oct 2010 15:11:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: DVB: af9015 defunct [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org> <4CC07DB4.20205@gmail.com> <4CC1577F.9060207@gmail.com> <4CC19804.1080109@redhat.com> <4CC19A6E.8010909@gmail.com> <4CC84F60.7000409@redhat.com> <4CC85633.6030707@iki.fi>
In-Reply-To: <4CC85633.6030707@iki.fi>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 27-10-2010 14:41, Antti Palosaari escreveu:
> On 10/27/2010 07:12 PM, Mauro Carvalho Chehab wrote:
>> int tda18271_write_regs(struct dvb_frontend *fe, int idx, int len)
>> {
>> ...
>>          switch (priv->small_i2c) {
>>          case TDA18271_03_BYTE_CHUNK_INIT:
>>                  max = 3;
>>                  break;
>>          case TDA18271_08_BYTE_CHUNK_INIT:
>>                  max = 8;
>>                  break;
>>          case TDA18271_16_BYTE_CHUNK_INIT:
>>                  max = 16;
>>                  break;
>>          case TDA18271_39_BYTE_CHUNK_INIT:
>>          default:
>>                  max = 39;
>>          }
>>
>>
>> with small_i2c = 1, the driver will not restrict the maximum length size.
>>
>> It's weird that the patch didn't fix it. Are you sure that reverting this
>> patch is enough to make the driver work?
>>
>> Please test this one.
>>
>> It will properly log the size of the message the driver tried to use, and will
>> reduce the max number of bytes per I2C transfer to 8.
> 
> All in all, this small_i2c was added (Michael Krufky and I) when this tuner was taken in use with af9015 and it was 16 bytes initially. I think those other chunks are added later.

Yeah, another change added a max restriction of 8.

> AF9015 I2C adapter can write 21 bytes at once.
> Correct solution is to add option which splits writes as wanted (like option .i2c_wr_max) to the TDA18271. I have no HW to test.

Changing to 21 won't change anything in practice, as it will still use 3 URB's for transferring data.
Only at setup, it needs to write values on more than 16 registers.

The current way that .small_i2c is defined is like that: it specifies the maximum amount of data
that can be transferred.

I won't object to change it from an enum into an integer, although I would
do it only if we need to touch on that code for another reason.

Cheers,
Mauro

