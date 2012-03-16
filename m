Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946405Ab2CPXlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:41:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946369Ab2CPXkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:40:52 -0400
Message-Id: <20120316233812.834856254@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:35 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 25/41] tcp: fix tcp_shift_skb_data() to not shift SACKed data below snd_una
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 4648dc97af9d496218a05353b0e442b3dfa6aaab ]

This commit fixes tcp_shift_skb_data() so that it does not shift
SACKed data below snd_una.

This fixes an issue whose symptoms exactly match reports showing
tp->sacked_out going negative since 3.3.0-rc4 (see "WARNING: at
net/ipv4/tcp_input.c:3418" thread on netdev).

Since 2008 (832d11c5cd076abc0aa1eaf7be96c81d1a59ce41)
tcp_shift_skb_data() had been shifting SACKed ranges that were below
snd_una. It checked that the *end* of the skb it was about to shift
from was above snd_una, but did not check that the end of the actual
shifted range was above snd_una; this commit adds that check.

Shifting SACKed ranges below snd_una is problematic because for such
ranges tcp_sacktag_one() short-circuits: it does not declare anything
as SACKed and does not increase sacked_out.

Before the fixes in commits cc9a672ee522d4805495b98680f4a3db5d0a0af9
and daef52bab1fd26e24e8e9578f8fb33ba1d0cb412, shifting SACKed ranges
below snd_una happened to work because tcp_shifted_skb() was always
(incorrectly) passing in to tcp_sacktag_one() an skb whose end_seq
tcp_shift_skb_data() had already guaranteed was beyond snd_una. Hence
tcp_sacktag_one() never short-circuited and always increased
tp->sacked_out in this case.

After those two fixes, my testing has verified that shifting SACKed
ranges below snd_una could cause tp->sacked_out to go negative with
the following sequence of events:

(1) tcp_shift_skb_data() sees an skb whose end_seq is beyond snd_una,
    then shifts a prefix of that skb that is below snd_una

(2) tcp_shifted_skb() increments the packet count of the
    already-SACKed prev sk_buff

(3) tcp_sacktag_one() sees the end of the new SACKed range is below
    snd_una, so it short-circuits and doesn't increase tp->sacked_out

(5) tcp_clean_rtx_queue() sees the SACKed skb has been ACKed,
    decrements tp->sacked_out by this "inflated" pcount that was
    missing a matching increase in tp->sacked_out, and hence
    tp->sacked_out underflows to a u32 like 0xFFFFFFFF, which casted
    to s32 is negative.

(6) this leads to the warnings seen in the recent "WARNING: at
    net/ipv4/tcp_input.c:3418" thread on the netdev list; e.g.:
    tcp_input.c:3418  WARN_ON((int)tp->sacked_out < 0);

More generally, I think this bug can be tickled in some cases where
two or more ACKs from the receiver are lost and then a DSACK arrives
that is immediately above an existing SACKed skb in the write queue.

This fix changes tcp_shift_skb_data() to abort this sequence at step
(1) in the scenario above by noticing that the bytes are below snd_una
and not shifting them.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1588,6 +1588,10 @@ static struct sk_buff *tcp_shift_skb_dat
 		}
 	}
 
+	/* tcp_sacktag_one() won't SACK-tag ranges below snd_una */
+	if (!after(TCP_SKB_CB(skb)->seq + len, tp->snd_una))
+		goto fallback;
+
 	if (!skb_shift(prev, skb, len))
 		goto fallback;
 	if (!tcp_shifted_skb(sk, skb, state, pcount, len, mss, dup_sack))


