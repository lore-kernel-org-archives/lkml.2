Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab1DMQNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:13:25 -0400
Received: from kroah.org ([198.145.64.141]:52954 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932867Ab1DMQNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:47 2011
Message-Id: <20110413161047.667721513@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Sterba <dsterba@suse.cz>, Patrick McHardy <kaber@trash.net>
Subject: [49/71] netfilter: h323: bug in parsing of ASN1 SEQOF field
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: David Sterba <dsterba@suse.cz>

commit b4232a22776aa5d063f890d21ca69870dbbe431b upstream.

Static analyzer of clang found a dead store which appears to be a bug in
reading count of items in SEQOF field, only the lower byte of word is
stored. This may lead to corrupted read and communication shutdown.

The bug has been in the module since it's first inclusion into linux
kernel.

[Patrick: the bug is real, but without practical consequence since the
 largest amount of sequence-of members we parse is 30.]

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_h323_asn1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -631,7 +631,7 @@ static int decode_seqof(bitstr_t *bs, co
 		CHECK_BOUND(bs, 2);
 		count = *bs->cur++;
 		count <<= 8;
-		count = *bs->cur++;
+		count += *bs->cur++;
 		break;
 	case SEMI:
 		BYTE_ALIGN(bs);


