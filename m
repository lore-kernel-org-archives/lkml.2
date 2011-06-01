Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab1FAIvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:51:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162374Ab1FAITn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:19:43 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:20 2011
Message-Id: <20110601081120.160369117@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:10:22 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Patrick McHardy <kaber@trash.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [052/165] netfilter: nf_ct_sip: fix SDP parsing in TCP SIP messages for some Cisco phones
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1530
Lines: 49


From: Patrick McHardy <kaber@trash.net>

[ Upstream commit e6e4d9ed11fb1fab8b3256a3dc14d71b5e984ac4 ]

Some Cisco phones do not place the Content-Length field at the end of the
SIP message. This is valid, due to a misunderstanding of the specification
the parser expects the SDP body to start directly after the Content-Length
field. Fix the parser to scan for \r\n\r\n to locate the beginning of the
SDP body.

Reported-by: Teresa Kang <teresa_kang@gemtek.com.tw>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/netfilter/nf_conntrack_sip.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1419,6 +1419,7 @@ static int sip_help_tcp(struct sk_buff *
 	const char *dptr, *end;
 	s16 diff, tdiff = 0;
 	int ret = NF_ACCEPT;
+	bool term;
 	typeof(nf_nat_sip_seq_adjust_hook) nf_nat_sip_seq_adjust;
 
 	if (ctinfo != IP_CT_ESTABLISHED &&
@@ -1453,10 +1454,15 @@ static int sip_help_tcp(struct sk_buff *
 		if (dptr + matchoff == end)
 			break;
 
-		if (end + strlen("\r\n\r\n") > dptr + datalen)
-			break;
-		if (end[0] != '\r' || end[1] != '\n' ||
-		    end[2] != '\r' || end[3] != '\n')
+		term = false;
+		for (; end + strlen("\r\n\r\n") <= dptr + datalen; end++) {
+			if (end[0] == '\r' && end[1] == '\n' &&
+			    end[2] == '\r' && end[3] == '\n') {
+				term = true;
+				break;
+			}
+		}
+		if (!term)
 			break;
 		end += strlen("\r\n\r\n") + clen;
 


