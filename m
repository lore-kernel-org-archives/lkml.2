Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2DQUx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:53:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56415 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab2DQUxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:53:55 -0400
Subject: Re: 3.4.0-rc2: skb_put() -> skb_over_panic
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: a.beregalov@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20120417.164748.432392687904063236.davem@davemloft.net>
References: <1334502964.28012.1.camel@edumazet-glaptop>
	 <CAA1sL1SJyY7fYJn7OKqo5Pa=b4-r9DW90-5WVGBf==tFjVEBpg@mail.gmail.com>
	 <1334695506.2472.46.camel@edumazet-glaptop>
	 <20120417.164748.432392687904063236.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Apr 2012 22:53:51 +0200
Message-ID: <1334696031.2472.50.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 16:47 -0400, David Miller wrote:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 17 Apr 2012 22:45:06 +0200
> 
> > Could you check if commit a21d45726acacc963d8baddf74607d9b74e2b723
> > (tcp: avoid order-1 allocations on wifi and tx path)
> > was in your tree ?
> 
> I was about to say that I think this is the guilty commit too.
> 
> Good thing I held off the -stable submission of that change
> for a bit :-)

Fix should be easy I think, but yes you can hold stable submission of
course.

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 376b2cf..7ac6423 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1096,6 +1096,7 @@ static void __pskb_trim_head(struct sk_buff *skb, int len)
 	eat = min_t(int, len, skb_headlen(skb));
 	if (eat) {
 		__skb_pull(skb, eat);
+		skb->avail_size -= eat;
 		len -= eat;
 		if (!len)
 			return;


