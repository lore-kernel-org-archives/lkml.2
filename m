Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1L1ALM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 19:11:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35870 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab1L1ALK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 19:11:10 -0500
Message-ID: <4EFA5E9B.8040106@lwfinger.net>
Date: Tue, 27 Dec 2011 18:11:07 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] b43: fix regression in PIO case
References: <alpine.DEB.2.00.1112261608140.12108@axis700.grange> <alpine.DEB.2.00.1112261824000.12108@axis700.grange> <CACna6ry1tKXtUSQHknkEbzBq_gZUyxn1-9Guba2a56xzx242SA@mail.gmail.com> <alpine.DEB.2.00.1112272359240.6684@axis700.grange> <4EFA58FD.9060605@lwfinger.net> <alpine.DEB.2.00.1112280052030.9949@axis700.grange>
In-Reply-To: <alpine.DEB.2.00.1112280052030.9949@axis700.grange>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2011 06:00 PM, Guennadi Liakhovetski wrote:
> On Tue, 27 Dec 2011, Larry Finger wrote:
>
>> On 12/27/2011 05:05 PM, Guennadi Liakhovetski wrote:
>>> On Tue, 27 Dec 2011, Rafał Miłecki wrote:
>>>
>>>> W dniu 26 grudnia 2011 18:28 użytkownik Guennadi Liakhovetski
>>>> <g.liakhovetski@gmx.de>   napisał:
>>>>> This patch fixes the regression, introduced by
>>>>>
>>>>> commit 17030f48e31adde5b043741c91ba143f5f7db0fd
>>>>> From: Rafał Miłecki<zajec5@gmail.com>
>>>>> Date: Thu, 11 Aug 2011 17:16:27 +0200
>>>>> Subject: [PATCH] b43: support new RX header, noticed to be used in
>>>>> 598.314+ fw
>>>>>
>>>>> in PIO case.
>>>>>
>>>>> Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
>>>>> ---
>>>>> diff --git a/drivers/net/wireless/b43/pio.c
>>>>> b/drivers/net/wireless/b43/pio.c
>>>>> index ce8a4bd..b64b64c 100644
>>>>> --- a/drivers/net/wireless/b43/pio.c
>>>>> +++ b/drivers/net/wireless/b43/pio.c
>>>>> @@ -617,9 +617,19 @@ static bool pio_rx_frame(struct b43_pio_rxqueue *q)
>>>>>          const char *err_msg = NULL;
>>>>>          struct b43_rxhdr_fw4 *rxhdr =
>>>>>                  (struct b43_rxhdr_fw4 *)wl->pio_scratchspace;
>>>>> +       size_t rxhdr_size = sizeof(*rxhdr);
>>>>>
>>>>>          BUILD_BUG_ON(sizeof(wl->pio_scratchspace)<   sizeof(*rxhdr));
>>>>> -       memset(rxhdr, 0, sizeof(*rxhdr));
>>>>> +       switch (dev->fw.hdr_format) {
>>>>> +       case B43_FW_HDR_410:
>>>>> +       case B43_FW_HDR_351:
>>>>> +               rxhdr_size -= sizeof(rxhdr->format_598) -
>>>>> +                       sizeof(rxhdr->format_351);
>>>>> +               break;
>>>>> +       case B43_FW_HDR_598:
>>>>> +               break;
>>>>> +       }
>>>>> +       memset(rxhdr, 0, rxhdr_size);
>>>>
>>>> Huuh, that's really tricky. Can you just do "normal" conditions as
>>>> Larry suggested, please?
>>>
>>> Sorry? I absolutely see nothing tricky there. Do you think this would look
>>> "less tricky" to you:
>>>
>>> 	switch (dev->fw.hdr_format) {
>>> 	case B43_FW_HDR_410:
>>> 	case B43_FW_HDR_351:
>>> 		rxhdr_size = offsetof(struct b43_rxhdr_fw4,
>>> 					format_351) +
>>> 			sizeof(rxhdr_size->format_351);
>>> 		break;
>>> 	case B43_FW_HDR_598:
>>> 		rxhdr_size = sizeof(*rxhdr);
>>> 		break;
>>> 	}
>>>
>>
>> How about this?
>>
>> Index: wireless-testing-new/drivers/net/wireless/b43/pio.c
>> ===================================================================
>> --- wireless-testing-new.orig/drivers/net/wireless/b43/pio.c
>> +++ wireless-testing-new/drivers/net/wireless/b43/pio.c
>> @@ -617,9 +617,20 @@ static bool pio_rx_frame(struct b43_pio_
>>          const char *err_msg = NULL;
>>          struct b43_rxhdr_fw4 *rxhdr =
>>                  (struct b43_rxhdr_fw4 *)wl->pio_scratchspace;
>> +       size_t rxhdr_size;
>>
>>          BUILD_BUG_ON(sizeof(wl->pio_scratchspace)<  sizeof(*rxhdr));
>> -       memset(rxhdr, 0, sizeof(*rxhdr));
>> +       switch (dev->fw.hdr_format) {
>> +       case B43_FW_HDR_410:
>> +       case B43_FW_HDR_351:
>> +               rxhdr_size = sizeof(rxhdr->format_351);
>> +               break;
>> +       case B43_FW_HDR_598:
>> +       default:
>> +               rxhdr_size = sizeof(rxhdr->format_598);
>> +               break;
>> +       }
>> +       memset(rxhdr, 0, rxhdr_size);
>>
>>          /* Check if we have data and wait for it to get ready. */
>>          if (q->rev>= 8) {
>
> I am sorry, I'm either being blind and stupid or you're trying to do
> something quite wrong there. struct b43_rxhdr_fw4 has a bunch of fields
> first, then at the end it has a union of two fields: format_598 and
> format_351, right? rxhdr is pointing at the struct itself. Before the
> offending patch memset() used to clean the whole struct. Now in your above
> version you calculate the size of one of those union fields and nullify
> that many bytes from the _beginning_ of the whole struct.
>
> I've seen myself being wrong before, but here... I'll let you judge
> though.

No, you are right. I misread the code. Your patch above would work and is 
probably as clean as one can expect.

Larry


