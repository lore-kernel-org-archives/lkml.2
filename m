Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab1AaWvw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:51:52 -0500
Received: from web63908.mail.re1.yahoo.com ([69.147.97.123]:28176 "HELO
	web63908.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754145Ab1AaWvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:51:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=GCdsToY90MDBeVLMDiZo0+h7b5Fhcg1NM2M77F3ZoixXVvWoNKx+2vjrJiANLTixYy0y9kjCQviifWGIgPj7NrXcmeerT42O5vFa58nfbG992zKtdLHzUc1Qx4xddE/hIGquw8D8Q0Nhtk5t4WWFZRQETC2qlFi8FHO2pvFCXjQ=;
Message-ID: <782169.94654.qm@web63908.mail.re1.yahoo.com>
X-YMail-OSG: .ysnBt0VM1nXL1nClCMrUKpXriZ8pW1NmPLZm0RxZvezqQc
 SkR26S3P9MF1BxDPBjllr_cn1vXejy82lDjDnKpaJcrlAfmDyxab.wvwGPBa
 .e8sJtkC2AbCsp2cMp02jAxo_N7bOOu7QiJNb9.q7nstB_akfIllI_vM6RSE
 RtFHCbaXBTIzqwOUfY3gjpBlLLL.TRxDuy03AZgv9q6KmqUeFV7BiedIA9HL
 LEzdKHR8CpDnMSMTQUoDb.2XvHMZUFuB_BLQ0oc1No9Vctz_Ncag3bqMk2rT
 CziqBSgzFiVFkbMpqxCRNUQ--
X-Mailer: YahooMailRC/555 YahooMailWebService/0.8.107.285259
Date: Mon, 31 Jan 2011 14:51:49 -0800 (PST)
From: PK <runningdoglackey@yahoo.com>
Subject: Re: Problems with /proc/net/tcp6 - possible bug - ipv6
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote
> 
> Please give this patch a  try:
> 
> --------------------
> From  d80bc0fd262ef840ed4e82593ad6416fa1ba3fc4 Mon Sep 17 00:00:00 2001
> From: David  S. Miller <davem@davemloft.net>
> Date: Mon, 24  Jan 2011 16:01:58 -0800
> Subject: [PATCH] ipv6: Always clone offlink  routes.


That patch and all the others seem to be in the official tree, so I pulled 
earlier
today to test against.

I no longer see kernel warnings or any problems with /proc/net/tcp6, but the 
tcp6
layer still has issues with tcp_tw_recycle and a listening socket + looped
connect/disconnects.

First there are intermittent net unreachable connection failures when trying to 
connect
to a local closed tcp6 port, and eventually connection attempts start failing 
with
timeouts.  At that point the tcp6 layer seems quite hosed.  It usually gets
to that point within a few minutes of starting the loop.  Stopping the script 
after that
point seems to have no positive effect.

https://github.com/runningdogx/net6-bug

Using that script, I get something like the following output, although sometimes 
it
takes a few more minutes before the timeouts begin.  Using 127.0.0.1 to test
against tcp4 shows no net unreachables and no timeouts.  All the errors 
displayed
once the timestamped loops start are from attempts to connect to a port that's
supposed to be closed.

Kernel log is empty since boot.
All this still in a standard ubuntu 10.10 amd64 smp vm.

----output----
# ruby net6-bug/tcp6br.rb ::1 3333

If you're not root, you'll need to enable tcp_tw_recycle yourself
Server listening on ::1:3333

Chose port 55555 (should be closed) to test if stack is functioning
14:28:06  SYN_S:1  SYN_R:0  TWAIT:7  FW1:0  FW2:0  CLOSING:0  LACK:0
14:28:11  SYN_S:1  SYN_R:0  TWAIT:8  FW1:0  FW2:0  CLOSING:0  LACK:0
14:28:16  SYN_S:1  SYN_R:0  TWAIT:12  FW1:0  FW2:0  CLOSING:0  LACK:0
14:28:21  SYN_S:1  SYN_R:0  TWAIT:12  FW1:0  FW2:0  CLOSING:0  LACK:0
14:28:26  SYN_S:1  SYN_R:0  TWAIT:12  FW1:0  FW2:0  CLOSING:0  LACK:0
14:28:31  SYN_S:1  SYN_R:0  TWAIT:17  FW1:0  FW2:0  CLOSING:0  LACK:0
14:28:36  SYN_S:0  SYN_R:0  TWAIT:15  FW1:1  FW2:0  CLOSING:0  LACK:0
tcp socket error: Net Unreachable
14:28:41  SYN_S:1  SYN_R:0  TWAIT:17  FW1:0  FW2:0  CLOSING:0  LACK:0
14:28:46  SYN_S:1  SYN_R:0  TWAIT:16  FW1:0  FW2:0  CLOSING:0  LACK:0
14:28:51  SYN_S:1  SYN_R:0  TWAIT:19  FW1:0  FW2:0  CLOSING:0  LACK:1
14:28:56  SYN_S:1  SYN_R:0  TWAIT:18  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:01  SYN_S:1  SYN_R:0  TWAIT:19  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:06  SYN_S:1  SYN_R:0  TWAIT:10  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:11  SYN_S:1  SYN_R:0  TWAIT:8  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:16  SYN_S:1  SYN_R:0  TWAIT:8  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:21  SYN_S:1  SYN_R:0  TWAIT:7  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:26  SYN_S:1  SYN_R:0  TWAIT:4  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:31  SYN_S:1  SYN_R:0  TWAIT:5  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:36  SYN_S:1  SYN_R:0  TWAIT:5  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:41  SYN_S:1  SYN_R:0  TWAIT:4  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:46  SYN_S:1  SYN_R:0  TWAIT:5  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:51  SYN_S:1  SYN_R:0  TWAIT:3  FW1:0  FW2:0  CLOSING:0  LACK:0
14:29:56  SYN_S:1  SYN_R:0  TWAIT:4  FW1:0  FW2:0  CLOSING:0  LACK:0
14:30:01  SYN_S:1  SYN_R:0  TWAIT:5  FW1:4  FW2:0  CLOSING:0  LACK:1
tcp socket error: Net Unreachable
14:30:06  SYN_S:1  SYN_R:0  TWAIT:6  FW1:2  FW2:0  CLOSING:0  LACK:1
14:30:32  SYN_S:1  SYN_R:0  TWAIT:5  FW1:0  FW2:0  CLOSING:0  LACK:0
14:30:37  SYN_S:1  SYN_R:0  TWAIT:5  FW1:0  FW2:0  CLOSING:0  LACK:0
14:30:42  SYN_S:1  SYN_R:0  TWAIT:3  FW1:0  FW2:0  CLOSING:0  LACK:0
14:30:47  SYN_S:1  SYN_R:0  TWAIT:3  FW1:0  FW2:0  CLOSING:0  LACK:0
!! TCP SOCKET TIMED OUT CONNECTING TO A LOCAL CLOSED PORT
14:34:02  SYN_S:1  SYN_R:0  TWAIT:0  FW1:0  FW2:0  CLOSING:0  LACK:0
!! TCP SOCKET TIMED OUT CONNECTING TO A LOCAL CLOSED PORT
14:37:16  SYN_S:1  SYN_R:0  TWAIT:0  FW1:0  FW2:0  CLOSING:0  LACK:0
!! TCP SOCKET TIMED OUT CONNECTING TO A LOCAL CLOSED PORT
14:40:30  SYN_S:1  SYN_R:0  TWAIT:0  FW1:0  FW2:0  CLOSING:0  LACK:0
^C


      
