Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761093Ab2KAMQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 08:16:42 -0400
Received: from mx0.aculab.com ([213.249.233.131]:53652 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756264Ab2KAMQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:16:39 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 3/9] net: xfrm: use this_cpu_ptr per-cpu helper
Date: Thu, 1 Nov 2012 12:15:50 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7086@saturn3.aculab.com>
In-Reply-To: <50923956.5090206@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 3/9] net: xfrm: use this_cpu_ptr per-cpu helper
thread-index: Ac24DvJGr57KwqY8QU2JzE4svQI8SgAGrdWw
References: <509109F9.3030904@gmail.com> <0000013ab7e4a640-60bd5b38-a1fc-4730-b918-4109211ffea0-000000@email.amazonses.com> <50923956.5090206@gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Shan Wei" <shanwei88@gmail.com>, "Christoph Lameter" <cl@linux.com>
Cc: <steffen.klassert@secunet.com>, "David Miller" <davem@davemloft.net>,
        "NetDev" <netdev@vger.kernel.org>,
        "Herbert Xu" <herbert@gondor.hengli.com.au>,
        "Kernel-Maillist" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA1CGkv3024535

> this_cpu_read
> |-----_this_cpu_generic_read
> 
> #define _this_cpu_generic_read(pcp)                                     \
> ({      typeof(pcp) ret__;                                              \
>         preempt_disable();                                              \
>         ret__ = *this_cpu_ptr(&(pcp));                                  \
>         preempt_enable();                                               \
>         ret__;                                                          \
> })
> 
> 
> this_cpu_read operations locate per-cpu variable with preemption safeï¼Œ not
> disable interrupts. why is it atomic vs interrupts?

Hmmm...  what effect do those preemt_dis/enable() actually have?
Since a pre-empt can happen either side of them, the value
the caller sees can be for the wrong cpu anyway.

The only time I could see them being necessary is if
*this_cpu_ptr() itself needs mutex protection in order to
function correctly - and that is likely to be port specific.
On i386/amd64 where (I guess) it is an access offset by fs/gs
this isn't necessary and just wastes cpu cycles.

If the caller cares which cpu the value comes from (eg to
increment a counter) then the caller would need to disable
pre-emption across the whole operation.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
