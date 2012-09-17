Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab2IQBTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:19:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33609 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922Ab2IQAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:11 -0400
Message-Id: <20120917003643.221879833@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <edumazet@google.com>,
        Dave Jones <davej@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 123/135] staging: r8712u: fix bug in r8712_recv_indicatepkt()
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit abf02cfc179bb4bd30d05f582d61b3b8f429b813 upstream.

64bit arches have a buggy r8712u driver, let's fix it.

skb->tail must be set properly or network stack behavior is undefined.

Addresses https://bugzilla.redhat.com/show_bug.cgi?id=847525
Addresses https://bugzilla.kernel.org/show_bug.cgi?id=45071

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Dave Jones <davej@redhat.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/rtl8712/recv_linux.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8712/recv_linux.c b/drivers/staging/rtl8712/recv_linux.c
index 0e26d5f..495ee12 100644
--- a/drivers/staging/rtl8712/recv_linux.c
+++ b/drivers/staging/rtl8712/recv_linux.c
@@ -117,13 +117,8 @@ void r8712_recv_indicatepkt(struct _adapter *padapter,
 	if (skb == NULL)
 		goto _recv_indicatepkt_drop;
 	skb->data = precv_frame->u.hdr.rx_data;
-#ifdef NET_SKBUFF_DATA_USES_OFFSET
-	skb->tail = (sk_buff_data_t)(precv_frame->u.hdr.rx_tail -
-		     precv_frame->u.hdr.rx_head);
-#else
-	skb->tail = (sk_buff_data_t)precv_frame->u.hdr.rx_tail;
-#endif
 	skb->len = precv_frame->u.hdr.len;
+	skb_set_tail_pointer(skb, skb->len);
 	if ((pattrib->tcpchk_valid == 1) && (pattrib->tcp_chkrpt == 1))
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 	else


