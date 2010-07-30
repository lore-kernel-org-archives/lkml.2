Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab0G3Sgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:36:55 -0400
Received: from kroah.org ([198.145.64.141]:57971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759782Ab0G3Ryj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:39 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:36 2010
Message-Id: <20100730175136.563162019@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:50:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [033/205] tcp: fix crash in tcp_xmit_retransmit_queue
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>

commit 45e77d314585869dfe43c82679f7e08c9b35b898 upstream.

It can happen that there are no packets in queue while calling
tcp_xmit_retransmit_queue(). tcp_write_queue_head() then returns
NULL and that gets deref'ed to get sacked into a local var.

There is no work to do if no packets are outstanding so we just
exit early.

This oops was introduced by 08ebd1721ab8fd (tcp: remove tp->lost_out
guard to make joining diff nicer).

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
Reported-by: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>
Tested-by: Lennart Schulte <lennart.schulte@nets.rwth-aachen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp_output.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2206,6 +2206,9 @@ void tcp_xmit_retransmit_queue(struct so
 	int mib_idx;
 	int fwd_rexmitting = 0;
 
+	if (!tp->packets_out)
+		return;
+
 	if (!tp->lost_out)
 		tp->retransmit_high = tp->snd_una;
 


