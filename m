Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0IUVUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 17:20:34 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:63559 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0IUVUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 17:20:32 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: netdev@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        padovan@profusion.mobi, marcel@holtmann.org, davem@davemloft.net,
        mathewm@codeaurora.org
Subject: Deadlock in Bluetooth code in 2.6.36
Date: Tue, 21 Sep 2010 18:20:12 -0300
Message-Id: <1285104013-9946-1-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to discuss here a problem we are having in the Bluetooth Layer.

There we have the Enhanced Retransmission Mode(ERTM) which is  a reliable mode
of operation of the Bluetooth L2CAP layer. Think on it like a simplified
version of TCP.

The problem we were facing was a deadlock. ERTM uses a backlog queue to
queue incoming packets while the user held the lock. The problem is that
at some moment the user doesn't have memory anymore to alloc new skbs and
sleeps to wait for memory with the lock held, that stalls the ERTM connection
because we can't read the acknowledgements packets in the backlog queue to
free memory and then make the allocation of outcoming skb successful.

Looks like the solution to this issue is release the lock before go to sleep
waiting for memory and then lock the sock lock again when we wake up and have
memory.  That's the solution TCP does through sk_stream_alloc_skb() and
sk_stream_wait_memory(). The sock lock is released and locked again inside
sk_wait_event() macro.
For bluetooth we do that in different way, we alloc memory through
sock_alloc_send_skb() which differently from sk_stream_alloc_skb() sleeps
with the lock held when waiting for memory.

The following patch is more like a proof of concept that sleeping
without the lock fixes the problem for L2CAP. Mat Martineau also found out
that some time ago.

My questions here is on how to fix this properly. Maybe
sock_alloc_send_skb() should not be used with SOCK_STREAM and reliable
protocols and I'm not aware of that? And should I use something like
sk_stream_alloc_skb() instead?

Any comments are welcome. With lucky we can fix that for 2.6.36 and
together with others fixes we have queued deliver a fully functional
L2CAP layer on 2.6.36.

Thanks,

---

Gustavo F. Padovan (1):
      Bluetooth: Fix deadlock in the ERTM logic

 net/bluetooth/l2cap.c |    4 ++++
  1 files changed, 4 insertions(+), 0 deletions(-)

