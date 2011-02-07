Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1BGKI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:08:29 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56197 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1BGKI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:08:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ITbBu3RUyI07wqb0J2mXMrZSIpgv+IGO5MrXvV9gwvfmtC+qmOBhvkj/CS4uStAitQ
         440tc6BfIZVFIz0mSHJZ9UxSVsOAntg2sqpvEZuU3BbwXVNXWdXzd+eBVg3UKKATZ1rK
         qQ0HnGXgHtKIl0ZA79JXonYlA6tPFSoSRDaqw=
Subject: Re: x25: possible skb leak on bad facilities
From: Andrew Hendry <andrew.hendry@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: apw@canonical.com, john@calva.com, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tim.gardner@canonical.com
In-Reply-To: <AANLkTik8hg5G2FYDCoRgh72v-_euGWKix9Fxm89UdXie@mail.gmail.com>
References: <20110131130826.GC16804@shadowen.org>
	 <AANLkTik-ywwtNg2AxAXtsKYJviDp=1zCZ-43JXp9i3g6@mail.gmail.com>
	 <20110206.202824.260090071.davem@davemloft.net>
	 <AANLkTik8hg5G2FYDCoRgh72v-_euGWKix9Fxm89UdXie@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 21:08:15 +1100
Message-ID: <1297073295.9577.13.camel@jaunty>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Originally x25_parse_facilities returned
-1 for an error
 0 meaning 0 length facilities
>0 the length of the facilities parsed.

5ef41308f94dc introduced more error checking in x25_parse_facilities
however used 0 to indicate bad parsing
a6331d6f9a429 followed this further for DTE facilities, again using 0 for bad parsing.

The meaning of 0 got confused in the callers.
If the facilities are messed up we can't determine where the data starts.
So patch makes all parsing errors return -1 and ensures callers close and don't use the skb further.

Reported-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Hendry <andrew.hendry@gmail.com>


---
 net/x25/x25_facilities.c |   28 +++++++++++++++++++---------
 net/x25/x25_in.c         |   14 +++++++++++---
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/net/x25/x25_facilities.c b/net/x25/x25_facilities.c
index 55187c8..4062075 100644
--- a/net/x25/x25_facilities.c
+++ b/net/x25/x25_facilities.c
@@ -27,9 +27,19 @@
 #include <net/sock.h>
 #include <net/x25.h>
 
-/*
- * Parse a set of facilities into the facilities structures. Unrecognised
- *	facilities are written to the debug log file.
+/**
+ * x25_parse_facilities - Parse facilities from skb into the facilities structs
+ *
+ * @skb: sk_buff to parse
+ * @facilities: Regular facilites, updated as facilities are found
+ * @dte_facs: ITU DTE facilities, updated as DTE facilities are found
+ * @vc_fac_mask: mask is updated with all facilities found
+ *
+ * Return codes:
+ *  -1 - Parsing error, caller should drop call and clean up
+ *   0 - Parse OK, this skb has no facilities
+ *  >0 - Parse OK, returns the length of the facilities header
+ *
  */
 int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 		struct x25_dte_facilities *dte_facs, unsigned long *vc_fac_mask)
@@ -62,7 +72,7 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 		switch (*p & X25_FAC_CLASS_MASK) {
 		case X25_FAC_CLASS_A:
 			if (len < 2)
-				return 0;
+				return -1;
 			switch (*p) {
 			case X25_FAC_REVERSE:
 				if((p[1] & 0x81) == 0x81) {
@@ -107,7 +117,7 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 			break;
 		case X25_FAC_CLASS_B:
 			if (len < 3)
-				return 0;
+				return -1;
 			switch (*p) {
 			case X25_FAC_PACKET_SIZE:
 				facilities->pacsize_in  = p[1];
@@ -130,7 +140,7 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 			break;
 		case X25_FAC_CLASS_C:
 			if (len < 4)
-				return 0;
+				return -1;
 			printk(KERN_DEBUG "X.25: unknown facility %02X, "
 			       "values %02X, %02X, %02X\n",
 			       p[0], p[1], p[2], p[3]);
@@ -139,18 +149,18 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 			break;
 		case X25_FAC_CLASS_D:
 			if (len < p[1] + 2)
-				return 0;
+				return -1;
 			switch (*p) {
 			case X25_FAC_CALLING_AE:
 				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
-					return 0;
+					return -1;
 				dte_facs->calling_len = p[2];
 				memcpy(dte_facs->calling_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLING_AE;
 				break;
 			case X25_FAC_CALLED_AE:
 				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
-					return 0;
+					return -1;
 				dte_facs->called_len = p[2];
 				memcpy(dte_facs->called_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLED_AE;
diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
index f729f02..15de65f 100644
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -91,10 +91,10 @@ static int x25_state1_machine(struct sock *sk, struct sk_buff *skb, int frametyp
 {
 	struct x25_address source_addr, dest_addr;
 	int len;
+	struct x25_sock *x25 = x25_sk(sk);
 
 	switch (frametype) {
 		case X25_CALL_ACCEPTED: {
-			struct x25_sock *x25 = x25_sk(sk);
 
 			x25_stop_timer(sk);
 			x25->condition = 0x00;
@@ -113,14 +113,16 @@ static int x25_state1_machine(struct sock *sk, struct sk_buff *skb, int frametyp
 						&dest_addr);
 			if (len > 0)
 				skb_pull(skb, len);
+			else if (len < 0)
+				goto out_clear;
 
 			len = x25_parse_facilities(skb, &x25->facilities,
 						&x25->dte_facilities,
 						&x25->vc_facil_mask);
 			if (len > 0)
 				skb_pull(skb, len);
-			else
-				return -1;
+			else if (len < 0)
+				goto out_clear;
 			/*
 			 *	Copy any Call User Data.
 			 */
@@ -144,6 +146,12 @@ static int x25_state1_machine(struct sock *sk, struct sk_buff *skb, int frametyp
 	}
 
 	return 0;
+
+out_clear:
+	x25_write_internal(sk, X25_CLEAR_REQUEST);
+	x25->state = X25_STATE_2;
+	x25_start_t23timer(sk);
+	return 0;
 }
 
 /*
-- 
1.7.1



On Mon, 2011-02-07 at 17:29 +1100, Andrew Hendry wrote:
> The issue is a bit more complex than Andy's patch, I think I have a full fix.
> Burning it in on test system now, if thats OK ill post patch in a few hours.
> 
> 
> On Mon, Feb 7, 2011 at 3:28 PM, David Miller <davem@davemloft.net> wrote:
> > From: Andrew Hendry <andrew.hendry@gmail.com>
> > Date: Tue, 1 Feb 2011 22:55:13 +1100
> >
> >> There are two callers, when I was crashing it I don't remember it
> >> using the backlog path.
> >> x25_process_rx_frame is called from both x25_backlog_rcv and also
> >> x25_receive_data (via x25_lapb_receive_frame)
> >>
> >> But reviewing that second path now it looks like it will also leak, -1
> >> would make it skip the kfree_skb there as well.
> >> So patch looks good to me, when I have some time I'll run it through
> >> the environment I had setup originally to confirm.
> >
> > Andrew, have you had a chance to do this yet?
> >


