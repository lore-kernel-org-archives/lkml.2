Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0CYXSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 19:18:52 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38823 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0CYXSv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 19:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ek2L3jnWNa62sWV7xiA96QD8xT8LTaDeyppJ1YMjj+xfEpF4QirOKF+8VEmTidsfvh
         WFc5khE6D0ugtHJeyzhkjtpAxplGB1WSmRxqdQsr3mw6EASkgYQYgv986MQ8bWTK3s/Q
         oPhfouJIAd+z5ZzILNytUGf+DapMeDzvRxFZc=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1003252146070.4413@axis700.grange>
References: <1269529381-16914-1-git-send-email-linus.walleij@stericsson.com>
	 <Pine.LNX.4.64.1003252146070.4413@axis700.grange>
Date: Fri, 26 Mar 2010 00:18:49 +0100
Message-ID: <63386a3d1003251618q5786df4eoae906d6e3b6b4b3e@mail.gmail.com>
Subject: Re: [PATCH 2/2] DMAENGINE: generic channel status
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Nicolas Ferre <nicolas.ferre@atmel.com>, Pavel Machek <pavel@ucw.cz>,
       Li Yang <leoli@freescale.com>, Paul Mundt <lethal@linux-sh.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Magnus Damm <damm@opensource.se>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Joe Perches <joe@perches.com>, Roland Dreier <rdreier@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/25 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:

> General: you converted all drivers to the new .device_tx_status() API, but
> since they don't implement "residue," you left it uninitialised
> everywhere. Wouldn't it be better to set it to 0 or total length,
> depending on the complete / not complete status?

The total length is a bit hard to know without understanding all drivers
I'm afraid, but I can sure add txtstatus->residue = 0; everywhere,
I'll fix.

>> +struct dma_tx_state {
>> +     dma_cookie_t last;
>> +     dma_cookie_t used;
>> +     u32 residue;
>
> In the original proposal by Dan Williams the last member was "unsigned
> long pos." I don't think, even on 64-bit systems anyone would kick off a >
> 4GB transfer, but who knows... And - I don't particularly like the name
> "pos," but I do like the idea of returning bytes transfered better, than
> bytes left. Can we change this?

As Dan says consistency with other systems suggests something
residue or bytes_left.

>> - * @device_is_tx_complete: poll for transaction completion
>> + * @device_tx_status: poll for transaction completion, the optional
>> + *   txstate parameter can be supplied with a pointer to get a
>> + *   struct with some transfer information, else the call will just
>
> Maybe "with auxiliary transfer status information, otherwise..."

OK

>> @@ -572,7 +592,13 @@ static inline void dma_async_issue_pending(struct dma_chan *chan)
>>  static inline enum dma_status dma_async_is_tx_complete(struct dma_chan *chan,
>>       dma_cookie_t cookie, dma_cookie_t *last, dma_cookie_t *used)
>>  {
>> -     return chan->device->device_is_tx_complete(chan, cookie, last, used);
>> +     struct dma_tx_state state;
>> +     enum dma_status status;
>> +
>> +     status = chan->device->device_tx_status(chan, cookie, &state);
>> +     *last = state.last;
>> +     *used = state.used;
>
> Both last and used can be NULL.

Good you spotted this! Thanks.

Linus
