Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761297Ab2EJS3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:29:09 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:28061 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761259Ab2EJS3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:29:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBACxOgk8Y9geI/2dsb2JhbAANNoVztlABAQEBAyMEUQEQCxUDAgIFFgsCAgkDAgECAUUGCgMBBQIBAYd8A6wlihiBL4h+hRWBGASpJQ
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="179485453"
Message-ID: <4FAC08EF.6010805@teksavvy.com>
Date: Thu, 10 May 2012 14:29:03 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ingo van Lil <inguin@gmx.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 22/52] asix: Fix tx transfer padding for full-speed USB
References: <20120510173134.851728856@linuxfoundation.org> <4FAC081D.5080202@teksavvy.com>
In-Reply-To: <4FAC081D.5080202@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-05-10 02:25 PM, Mark Lord wrote:
> On 12-05-10 01:31 PM, Greg KH wrote:
>> 3.3-stable review patch.  If anyone has any objections, please let me know.
> ..
>> From: Ingo van Lil <inguin@gmx.de>
>> [ Upstream commit 2a5809499e35b53a6044fd34e72b242688b7a862 ]
>>
>> The asix.c USB Ethernet driver avoids ending a tx transfer with a zero-
>> length packet by appending a four-byte padding to transfers whose length
>> is a multiple of maxpacket. However, the hard-coded 512 byte maxpacket
>> length is valid for high-speed USB only; full-speed USB uses 64 byte
>> packets.
>>
>> Signed-off-by: Ingo van Lil <inguin@gmx.de>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  drivers/net/usb/asix.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- a/drivers/net/usb/asix.c
>> +++ b/drivers/net/usb/asix.c
>> @@ -403,7 +403,7 @@ static struct sk_buff *asix_tx_fixup(str
>>  	u32 packet_len;
>>  	u32 padbytes = 0xffff0000;
>>  
>> -	padlen = ((skb->len + 4) % 512) ? 0 : 4;
>> +	padlen = ((skb->len + 4) & (dev->maxpacket - 1)) ? 0 : 4;
>>  
>>  	if ((!skb_cloned(skb)) &&
>>  	    ((headroom + tailroom) >= (4 + padlen))) {
>> @@ -425,7 +425,7 @@ static struct sk_buff *asix_tx_fixup(str
>>  	cpu_to_le32s(&packet_len);
>>  	skb_copy_to_linear_data(skb, &packet_len, sizeof(packet_len));
>>  
>> -	if ((skb->len % 512) == 0) {
>> +	if (padlen) {
>>  		cpu_to_le32s(&padbytes);
>>  		memcpy(skb_tail_pointer(skb), &padbytes, sizeof(padbytes));
>>  		skb_put(skb, sizeof(padbytes));
>>
>>
> 
> This patch changes behaviour even for high-speed USB.
> Was this intentional, and why?

Never mind.. I missed the skb_push(skb, 4) line
that the diff doesn't show above.

Okay by me.

