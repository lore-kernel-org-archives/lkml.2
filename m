Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab0JBMIP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 08:08:15 -0400
Received: from web53707.mail.re2.yahoo.com ([206.190.37.28]:23904 "HELO
	web53707.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753091Ab0JBMIO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 08:08:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=cCQIMETqBsF6Eb8fG6i5xTUNaRBOaOO1P/TU6EiGHjG+PCMn3tcBK14Gb7pZt/6SQ/WPk+eHzE/5jkW2BPVge0UoOhD48Z3ZY6tF405rGNvmJ2obgziUPfzcIc0kUiXyVFDLIR6FV6E6wFyiB9OQ+UOVtiOzyb6OoDncqXNS04c=;
Message-ID: <590816.4455.qm@web53707.mail.re2.yahoo.com>
X-YMail-OSG: RY1NOmoVM1kQtWF0gMcKSKRztvpK_rj24zBTiGPuuSsgsys
 raWW_Taar.12Gwcj4HuOKJbAGfxamjr_bQByYF7J9LkVZBYddP4V72ctj0.W
 3st7dnM8DNBapT21COIN.VNTgMDQNGh7O1VFempv4pqVxK2I4jZOq6gv0w0A
 8bM3hefJJM6G39eT1KmwSFy4R46Sq5cEFElLZ0Q4MCzAJGD1BQGxw03zurbX
 DWHk2U_Vy_t8GjTSMLCnEG3CFls83A9353cFEuvWogBnkPsW6yf342yeJmzn
 QMdtdzFo2.NEo0qetW1NN83YE_hDwWN7Z0m4EiJvKdg--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Sat, 2 Oct 2010 05:08:13 -0700 (PDT)
From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 1/2] net: Fix the condition passed to sk_wait_event()
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first part of the split up patch submitted in http://www.spinics.net/lists/netdev/msg142617.html

This patch fixes the sk_wait_event() condition in the sk_stream_wait_connect() function. With this change, we correctly check for the TCPF_ESTABLISHED and TCPF_CLOSE_WAIT states and avoid potentially returning success when there is an error on the socket.

Signed-off-by: Nagendra Singh Tomar <tomer_iisc@yahoo.com>
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



