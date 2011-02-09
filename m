Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab1BIFAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 00:00:01 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:2889 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856Ab1BIFAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 00:00:00 -0500
Message-ID: <12CF314023A64E13A83B8E6AEF56D177@hacdom.okisemi.com>
From: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
To: "David Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <tomoya-linux@dsn.okisemi.com>
References: <4D50FDAA.1060506@dsn.okisemi.com> <20110208.163522.232741523.davem@davemloft.net>
Subject: Re: [PATCH] pch_gbe: Fix the issue that the receiving data is not normal.
Date: Wed, 9 Feb 2011 13:58:44 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 08 Feb 2011 16:35:22 -0800 (PST)
>> Hi Devid
>>
>> I resubmit this patch modified.
>> Please check them.
>
>Your memcpy+memcpy sequences are equivalent to memmove(), please
>use that instead.
>

I use memmove().

>I have to say this function is insanely complicated.  There seems
>to be 16 different ways RX packets are processed.  I can't believe
>that is needs to be like this.

If processing is arranged, There are 4 different ways RX packets are 
processed.

[Case1]
"rx_csum is enable " and
 "NET_IP_ALIGN == 0"

 DMA buffer is used as SKB as it is.

[Case2]
"rx_csum is enable " and
 "NET_IP_ALIGN != 0"

 Because alignment differs, the new_skb is newly allocated, and data is 
copied to new_skb.

[Case3]
"rx_csum is disable " and
 "length < copybreak" or "NET_IP_ALIGN != PCH_GBE_DMA_PADDING"

 Because alignment differs, the new_skb is newly allocated, and data is 
copied to new_skb.
 Padding data is deleted at the time of a copy.

[Case4]
"rx_csum is disable " and
 "length >= copybreak" and "NET_IP_ALIGN == PCH_GBE_DMA_PADDING"

 Padding data is deleted by moving header data.

I rewrite without using skb_copy_flag and skb_padding simply.

Best regards
Toshiharu Okada(OKI semiconductor) 

