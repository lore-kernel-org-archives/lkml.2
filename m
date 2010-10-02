Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab0JBXtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 19:49:18 -0400
Received: from web53706.mail.re2.yahoo.com ([206.190.37.27]:43503 "HELO
	web53706.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751915Ab0JBXtR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 19:49:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LEMZpK6FE1NDmkJdp9erKZY67QgMECYnWcq7+lSTw7mWoOamukiBEHkJYA5gzxFUIV/ORxgInjslz0L80e5V5WyOEB36EwTOZrXPItkboztcQXA+s+Tb3zJGM85Jr6q81AEhxKXDBXZI49I/U3yFeUVNx9Sl/IOfwJ7hdzuo3yw=;
Message-ID: <339313.23381.qm@web53706.mail.re2.yahoo.com>
X-YMail-OSG: _ZVY0rMVM1nwviEyF6d_H47D804nEw98bnZHNpQI6FAlngT
 WS_J.C6wwVrqmS.eY0IKD_w36JNVTLRXTJYQ3DQVlyWFue_GHDBRx5H5Ygpj
 fUjcHP.qCAkemLPeEZBjU69KrULJKeHoPZQyNHZU4sG1TDZlxDAPIg3BuGZm
 LDBYEfGY3Vj.InsweM1J88L5WsUmONP1XJ9GoXNYD.XEpdiAP7RauOIzFctL
 ueXlkRsMQvJbBBXGnYqKxpm9EkwoAIsyjyu1dZbj4e4U9n9OjwgWYycZigtK
 tVXbpm9w33qWNuLFZktxiRzeP5LyWNEX8s_s-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sat, 2 Oct 2010 16:49:16 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: [PATCH 1/2] net: Fix the condition passed to sk_wait_event()
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the sk_wait_event() condition in the sk_stream_wait_connect() 
function. With this change, we correctly check for the TCPF_ESTABLISHED and 
TCPF_CLOSE_WAIT states and avoid potentially returning success when there
might be an error on the socket.

Signed-off-by: Nagendra Singh Tomar <tomer_iisc@xxxxxxxxx>
---
--- linux-2.6.35.7/net/core/stream.c.orig	2010-03-24 09:30:00.000000000 +0530
+++ linux-2.6.35.7/net/core/stream.c	2010-03-24 09:30:17.000000000 +0530
@@ -73,9 +73,8 @@ int sk_stream_wait_connect(struct sock *
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 		sk->sk_write_pending++;
 		done = sk_wait_event(sk, timeo_p,
-				     !sk->sk_err &&
-				     !((1 << sk->sk_state) &
-				       ~(TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)));
+				     ((1 << sk->sk_state) &
+				       (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)));
 		finish_wait(sk_sleep(sk), &wait);
 		sk->sk_write_pending--;
 	} while (!done);

---



      
