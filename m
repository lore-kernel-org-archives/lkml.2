Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2JWGIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:08:53 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:65129 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab2JWGIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:08:52 -0400
Subject: Re: 3.7-rc2 regression : file copied to CIFS-mounted directory
 corrupted
From: Eric Dumazet <eric.dumazet@gmail.com>
To: jongman.heo@samsung.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>
In-Reply-To: <22207427.56211350970373630.JavaMail.weblogic@epml04>
References: <22207427.56211350970373630.JavaMail.weblogic@epml04>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Oct 2012 08:08:48 +0200
Message-ID: <1350972528.8609.1431.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 05:38 +0000, Jongman Heo wrote:
> Hmm,
> 
> I've just met the issue, with the commit 5640f768 reverted.
> It seems that the issue does not always happen. So, my bisection may not be correct.
> 
> At this moment, I don't have enough time to do bisection again..
> 
> Regards.

What happens, if instead of reverting you try the following ?

If this solves the problem, then we shall find the driver that assumes
frags are order-0 pages only.

diff --git a/net/core/sock.c b/net/core/sock.c
index 8a146cf..a743e7c 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1726,7 +1726,7 @@ struct sk_buff *sock_alloc_send_skb(struct sock *sk, unsigned long size,
 EXPORT_SYMBOL(sock_alloc_send_skb);
 
 /* On 32bit arches, an skb frag is limited to 2^15 */
-#define SKB_FRAG_PAGE_ORDER	get_order(32768)
+#define SKB_FRAG_PAGE_ORDER	0
 
 bool sk_page_frag_refill(struct sock *sk, struct page_frag *pfrag)
 {


