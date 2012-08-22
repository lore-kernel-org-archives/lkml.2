Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2HVFPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:15:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58297 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2HVFPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:15:09 -0400
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        John W Linville <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <50345B12.1050600@lwfinger.net>
References: <50345B12.1050600@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Aug 2012 07:15:03 +0200
Message-ID: <1345612503.5158.566.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 23:07 -0500, Larry Finger wrote:
> Hi,
> 
> The commit entitled "tcp: reduce out_of_order memory use" turns out to cause 
> problems with a number of USB drivers.
> 
> The first one called to my attention was for staging/r8712u. For this driver, 
> there are problems with SSL communications as reported in 
> https://bugzilla.redhat.com/show_bug.cgi?id=847525.
> 
> Other drivers including rtl8187, rtl8192cu and rt2800usb cannot connect to a 
> WPA1- or WEP-encrypted AP, but work fine with WPA2. The rtl8192cu problem is 
> reported in https://bugzilla.kernel.org/show_bug.cgi?id=46171.
> 
> I find it hard to understand why this patch should cause these effects; however, 
> I have verified that a kernel generated from "git checkout e86b2919" works fine. 
> This commit is immediately before the patch in question.
> 
> Note, this patch was applied during the merge between 3.3 and 3.4. The 
> regression has been undiscovered for some time.
> 
> Any help on this problem will be appreciated.
> 
> Larry

This particular commit is the start of a patches batch that ended in the
generic TCP coalescing mechanism.

It is known to have problem on drivers doing skb_clone() in their rx
path.

Current kernels should be ok, because coalescing doesnt happen if the
destination skb is cloned (skb_cloned(to) in skb_try_coalesce())

For 3.4 kernel, I guess I need to backport this skb_cloned(to) check fo
stable 3.4 kernel

But these skb_clone() in various USB drivers should be killed for good,
they really can kill the box because of skb->truesize lies.

Please test following patch (for 3.4 kernels)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 257b617..c45ac2d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4496,7 +4496,9 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		 * to avoid future tcp_collapse_ofo_queue(),
 		 * probably the most expensive function in tcp stack.
 		 */
-		if (skb->len <= skb_tailroom(skb1) && !tcp_hdr(skb)->fin) {
+		if (skb->len <= skb_tailroom(skb1) &&
+		    !skb_cloned(skb1) &&
+		    !tcp_hdr(skb)->fin) {
 			NET_INC_STATS_BH(sock_net(sk),
 					 LINUX_MIB_TCPRCVCOALESCE);
 			BUG_ON(skb_copy_bits(skb, 0,


