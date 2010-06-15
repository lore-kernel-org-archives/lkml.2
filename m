Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab0FOExP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 00:53:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44627 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab0FOExO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 00:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qzcMPXFLxcxZiEQbEbzJoh8RufV96Ii/S8PCxi6teOsqxmXKViv4GNPooE+yWAgG/a
         Ag0PRwn2yLFeGWG37sYFGRv2Bol1twLQFjDe1si5YJUjNYNWDSTFPfP+vI1cCiuevKOd
         kANXbEZ3ikBnFrxidHMHM8glHR/Xh+WbxZ3aA=
MIME-Version: 1.0
In-Reply-To: <CEE6BB42CAD6E947908279175AF8470A025E5ADB79@EXDCVYMBSTM006.EQ1STM.local>
References: <1275394887-26445-1-git-send-email-linus.walleij@stericsson.com>
	<AANLkTil_NK2tuk4m6o8r4LIG0DsToC2O7jJ605nZMMtT@mail.gmail.com>
	<CEE6BB42CAD6E947908279175AF8470A025E5ADB79@EXDCVYMBSTM006.EQ1STM.local>
Date: Mon, 14 Jun 2010 21:53:13 -0700
X-Google-Sender-Auth: S1OANWP_BHwLMMRicwVyFFe5yZk
Message-ID: <AANLkTilc_sUbxf-n89rflG5bGKiGnFIh1pJbhRi42doj@mail.gmail.com>
Subject: Re: [PATCH 08/18] DMAENGINE: ste_dma40: lock fix
From: Dan Williams <dan.j.williams@intel.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jonas ABERG <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 9:41 AM, Linus WALLEIJ
<linus.walleij@stericsson.com> wrote:
> On 06/12/2010 12:38 AM, Dan Williams wrote:
>
>> On Tue, Jun 1, 2010 at 5:21 AM, Linus Walleij
>> <linus.walleij@stericsson.com> wrote:
>>> From: Jonas Aaberg <jonas.aberg@stericsson.com>
>>>
>>> Fix up some locking issues found by enabling lock debugging.
>>>
>>> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
>>> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
>>> ---
>>>  drivers/dma/ste_dma40.c |   14 +++++++-------
>>>  1 files changed, 7 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c index
>>> aba86bb..c4b0d37 100644
>>> --- a/drivers/dma/ste_dma40.c
>>> +++ b/drivers/dma/ste_dma40.c
>> [..]
>>>  static int d40_channel_execute_command(struct d40_chan *d40c, @@
>>> -1990,8 +1992,6 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
>>>        if (d40d == NULL)
>>>                return NULL;
>>>
>>> -       memset(d40d, 0, sizeof(struct d40_desc));
>>> -
>>
>> This one isn't a locking bug fix.
>
> Well, actually it was overwriting a spinlock, so I would considering
> a locking bug area atleast.

Ah, I missed that you call dma_async_tx_descriptor_init() every prep.
It may be worthwhile to select ASYNC_TX_DISABLE_CHANNEL_SWITCH to get
rid of the unused fields for async_tx channel switching *.

> But if you prefer we split this one-liner into a separate patch.

You never take the embedded lock so there was not a problem, but you
can leave it in as an innocuous cleanup.

Thanks,
Dan

* I'm now thinking that channel switching should be an opt-in request
rather than opt-out, because I can foresee a driver relying on the
size reductions it affords.  With the logic flipped we can disable the
driver that has this dependence.
