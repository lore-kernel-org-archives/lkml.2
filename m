Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab1A0Ipm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 03:45:42 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:29491 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338Ab1A0Ipl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 03:45:41 -0500
Message-ID: <29E928B8732A4CB19946EEA9F004FACB@hacdom.okisemi.com>
From: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
To: "David Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>,
        <andrew.chih.howe.khor@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>
References: <4D3D0373.30003@dsn.okisemi.com> <20110125.133240.59688304.davem@davemloft.net>
Subject: Re: [PATCH] pch_gbe: Fix the issue that the receiving data is not normal.
Date: Thu, 27 Jan 2011 17:45:35 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

Thank you for your comment.
I will confirm them  and will submit the patch modified.

Best regards
Toshiharu Okada(OKI semiconductor)
----- Original Message ----- 
From: "David Miller" <davem@davemloft.net>
To: <toshiharu-linux@dsn.okisemi.com>
Cc: <netdev@vger.kernel.org>; <linux-kernel@vger.kernel.org>; 
<qi.wang@intel.com>; <yong.y.wang@intel.com>; 
<andrew.chih.howe.khor@intel.com>; <joel.clark@intel.com>; 
<kok.howg.ewe@intel.com>
Sent: Wednesday, January 26, 2011 6:32 AM
Subject: Re: [PATCH] pch_gbe: Fix the issue that the receiving data is not 
normal.


From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Date: Mon, 24 Jan 2011 13:43:31 +0900

> This PCH_GBE driver had an issue that the receiving data is not normal.
> This driver had not removed correctly the padding data
> which the DMA include in receiving data.
>
> This patch fixed this issue.
>
> Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

There are bugs in these changes:

>  if (skb_copy_flag) { /* recycle  skb */
>  struct sk_buff *new_skb;
>  new_skb =
> -     netdev_alloc_skb(netdev,
> -      length + NET_IP_ALIGN);
> +     netdev_alloc_skb(netdev, length);
>  if (new_skb) {
>  if (!skb_padding_flag) {
>  skb_reserve(new_skb,
> - NET_IP_ALIGN);
> + PCH_GBE_DMA_PADDING);
>  }
>  memcpy(new_skb->data, skb->data,
>  length);

If "!skb_padding_flag" then you will write past the end of the SKB
data in that memcpy.

You cannot allocate only "length" then proceed to reserve 
PCH_GBE_DMA_PADDING
and then add "length" worth of data on top of that.  In such a cause you
must allocate at least "length + PCH_GBE_DMA_PADDING".

Furthermore you _MUST_ respect NET_IP_ALIGN.  Some platforms set this value
to "0", because otherwise performance suffers greatly.

There are two seperate issues, removing the padding bytes provided by
the device, and aligning the IP headers as wanted by the cpu
architecutre.  Therefore they should be handled seperately, and we
therefore should still see references to NET_IP_ALIGN in your patch.
--
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

