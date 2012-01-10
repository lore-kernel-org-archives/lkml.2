Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab2AJXSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:18:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933846Ab2AJXAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:00:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:50:24 2012
Message-Id: <20120110215023.930621417@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:48:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [35/42] igmp: Avoid zero delay when receiving odd mixture of IGMP queries
In-Reply-To: <20120110215031.GA19398@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit a8c1f65c79cbbb2f7da782d4c9d15639a9b94b27 upstream.

Commit 5b7c84066733c5dfb0e4016d939757b38de189e4 ('ipv4: correct IGMP
behavior on v3 query during v2-compatibility mode') added yet another
case for query parsing, which can result in max_delay = 0.  Substitute
a value of 1, as in the usual v3 case.

Reported-by: Simon McVittie <smcv@debian.org>
References: http://bugs.debian.org/654876
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/ipv4/igmp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -875,6 +875,8 @@ static void igmp_heard_query(struct in_d
 		 * to be intended in a v3 query.
 		 */
 		max_delay = IGMPV3_MRC(ih3->code)*(HZ/IGMP_TIMER_SCALE);
+		if (!max_delay)
+			max_delay = 1;	/* can't mod w/ 0 */
 	} else { /* v3 */
 		if (!pskb_may_pull(skb, sizeof(struct igmpv3_query)))
 			return;


