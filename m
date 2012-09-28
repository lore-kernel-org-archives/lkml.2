Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032198Ab2I1UY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:24:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63188 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032169Ab2I1UYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:24:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>, Dave Jones <davej@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [ 054/218] staging: r8712u: fix bug in r8712_recv_indicatepkt()
Date: Fri, 28 Sep 2012 13:14:31 -0700
Message-Id: <20120928201507.728251784@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/staging/rtl8712/recv_linux.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/staging/rtl8712/recv_linux.c
+++ b/drivers/staging/rtl8712/recv_linux.c
@@ -117,13 +117,8 @@ void r8712_recv_indicatepkt(struct _adap
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


