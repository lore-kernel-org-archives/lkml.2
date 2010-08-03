Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0HCIOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 04:14:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62143 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab0HCIOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 04:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:mime-version:content-type
         :content-transfer-encoding:x-mailer:thread-index:content-language;
        b=P0WaBWNkCeSZ0/Jp3CSdow2/EykXO+pJoGUL+ClCmn19lr9CfrUAn66fB6kZjMEk/6
         OB2Ll4bzEX5ozOklME4aNfzgg49E9WizRCRRF9aBegnuQ0pXiKN8rUBy0x8k6aDdbgIJ
         5bwHTPTEbklFLml2X7BsPEwt1kNix6Gmlh8DI=
From: "Andy Chittenden" <andyc.bluearc@gmail.com>
To: "'David S. Miller'" <davem@davemloft.net>,
        "'Alexey Kuznetsov'" <kuznet@ms2.inr.ac.ru>,
        "'Pekka Savola \(ipv6'" <pekkas@netcore.fi>,
        "'James Morris'" <jmorris@namei.org>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Patrick McHardy'" <kaber@trash.net>,
        "'Eric Dumazet'" <eric.dumazet@gmail.com>,
        <William.Allen.Simpson@gmail.com>,
        "'Gilad Ben-Yossef'" <gilad@codefidence.com>,
        "=?iso-8859-1?Q?'Ilpo_J=E4rvinen'?=" <ilpo.jarvinen@helsinki.fi>,
        <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>
Subject: [PATCH] [Bug 16494] NFS client over TCP hangs due to packet loss
Date: Tue, 3 Aug 2010 09:14:31 +0100
Message-ID: <4c57cfe8.887b0e0a.2f79.4772@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acsy4+Ym1XbCjbCOR4Oi4FAImm0DJg==
Content-Language: en-gb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know whether this patch is the correct fix or not but it enables the
NFS client to recover.

Kernel version: 2.6.34.1 and 2.6.32.

Fixes <https://bugzilla.kernel.org/show_bug.cgi?id=16494>. It clears down
any previous shutdown attempts so that reconnects on a socket that's been
shutdown leave the socket in a usable state (otherwise tcp_sendmsg() returns
-EPIPE).

# diff -up /home/company/software/src/linux-2.6.34.1/net/ipv4/tcp_output.c
net/ipv4
--- /home/company/software/src/linux-2.6.34.1/net/ipv4/tcp_output.c
2010-07-27 08:46:46.917000000 +0100
+++ net/ipv4/tcp_output.c       2010-07-27 09:19:16.000000000 +0100
@@ -2522,6 +2522,13 @@ static void tcp_connect_init(struct sock
        struct tcp_sock *tp = tcp_sk(sk);
        __u8 rcv_wscale;

+       /* clear down any previous shutdown attempts so that
+        * reconnects on a socket that's been shutdown leave the
+        * socket in a usable state (otherwise tcp_sendmsg() returns
+        * -EPIPE).
+        */
+       sk->sk_shutdown = 0;
+
        /* We'll fix this up when we get a response from the other end.
         * See tcp_input.c:tcp_rcv_state_process case TCP_SYN_SENT.
         */

Signed-off-by: Andy Chittenden <andyc.bluearc@gmail.com>



