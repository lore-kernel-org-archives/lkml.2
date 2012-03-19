Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab2CSLEz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 07:04:55 -0400
Received: from avalon.kleine-koenig.org ([78.46.226.219]:34910 "EHLO
	avalon.kleine-koenig.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab2CSLEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 07:04:53 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2012 07:04:52 EDT
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] telephony/ixj: Fix warning about sequence points
Date: Mon, 19 Mar 2012 11:57:44 +0100
Message-Id: <1332154664-10968-1-git-send-email-uwe@kleine-koenig.org>
X-Mailer: git-send-email 1.7.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the statement

	j->caplist[j->caps].handle = j->caps++;

there is no sequence point between the usage of j->caps on the LHS of the
assignment and the incrementation on its RHS. So it's not defined in Standard C
if j->caps is already incremented when used on the LHS even though the postfix
++ operator is used. To properly fix that the incrementation has to be done in
a seperate expression.

This fixes:
	drivers/telephony/ixj.c: In function ‘add_caps’:
	drivers/telephony/ixj.c:5930:38: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5950:38: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5954:38: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5965:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5976:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5988:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:5998:38: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6003:38: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6008:38: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6013:38: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6019:38: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6026:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6031:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6036:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6041:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6049:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6057:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6065:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]
	drivers/telephony/ixj.c:6071:39: warning: operation on ‘j->caps’ may be undefined [-Wsequence-point]

Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>
---
 drivers/telephony/ixj.c |   57 +++++++++++++++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index d5f923b..f960279 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -5927,7 +5927,8 @@ static void add_caps(IXJ *j)
 	j->caplist[j->caps].cap = PHONE_VENDOR_QUICKNET;
 	strcpy(j->caplist[j->caps].desc, "Quicknet Technologies, Inc. (www.quicknet.net)");
 	j->caplist[j->caps].captype = vendor;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 	j->caplist[j->caps].captype = device;
 	switch (j->cardtype) {
 	case QTI_PHONEJACK:
@@ -5947,11 +5948,13 @@ static void add_caps(IXJ *j)
 		break;
 	}
 	j->caplist[j->caps].cap = j->cardtype;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 	strcpy(j->caplist[j->caps].desc, "POTS");
 	j->caplist[j->caps].captype = port;
 	j->caplist[j->caps].cap = pots;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
  	/* add devices that can do speaker/mic */
 	switch (j->cardtype) {
@@ -5962,7 +5965,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "SPEAKER");
 		j->caplist[j->caps].captype = port;
 		j->caplist[j->caps].cap = speaker;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
         default:
      		break;
 	}
@@ -5973,7 +5977,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "HANDSET");
 		j->caplist[j->caps].captype = port;
 		j->caplist[j->caps].cap = handset;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 		break;
         default:
      		break;
@@ -5985,7 +5990,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "PSTN");
 		j->caplist[j->caps].captype = port;
 		j->caplist[j->caps].cap = pstn;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 		break;
         default:
      		break;
@@ -5995,50 +6001,59 @@ static void add_caps(IXJ *j)
 	strcpy(j->caplist[j->caps].desc, "ULAW");
 	j->caplist[j->caps].captype = codec;
 	j->caplist[j->caps].cap = ULAW;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
 	strcpy(j->caplist[j->caps].desc, "LINEAR 16 bit");
 	j->caplist[j->caps].captype = codec;
 	j->caplist[j->caps].cap = LINEAR16;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
 	strcpy(j->caplist[j->caps].desc, "LINEAR 8 bit");
 	j->caplist[j->caps].captype = codec;
 	j->caplist[j->caps].cap = LINEAR8;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
 	strcpy(j->caplist[j->caps].desc, "Windows Sound System");
 	j->caplist[j->caps].captype = codec;
 	j->caplist[j->caps].cap = WSS;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
 	/* software ALAW codec, made from ULAW */
 	strcpy(j->caplist[j->caps].desc, "ALAW");
 	j->caplist[j->caps].captype = codec;
 	j->caplist[j->caps].cap = ALAW;
-	j->caplist[j->caps].handle = j->caps++;
+	j->caplist[j->caps].handle = j->caps;
+	j->caps++;
 
 	/* version 12 of the 8020 does the following codecs in a broken way */
 	if (j->dsp.low != 0x20 || j->ver.low != 0x12) {
 		strcpy(j->caplist[j->caps].desc, "G.723.1 6.3kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = G723_63;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 
 		strcpy(j->caplist[j->caps].desc, "G.723.1 5.3kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = G723_53;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 
 		strcpy(j->caplist[j->caps].desc, "TrueSpeech 4.8kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = TS48;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 
 		strcpy(j->caplist[j->caps].desc, "TrueSpeech 4.1kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = TS41;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 	}
 
 	/* 8020 chips can do TS8.5 native, and 8021/8022 can load it */
@@ -6046,7 +6061,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "TrueSpeech 8.5kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = TS85;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 	}
 
 	/* 8021 chips can do G728 */
@@ -6054,7 +6070,8 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "G.728 16kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = G728;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 	}
 
 	/* 8021/8022 chips can do G729 if loaded */
@@ -6062,13 +6079,15 @@ static void add_caps(IXJ *j)
 		strcpy(j->caplist[j->caps].desc, "G.729A 8kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = G729;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 	}
 	if (j->dsp.low != 0x20 && j->flags.g729_loaded) {
 		strcpy(j->caplist[j->caps].desc, "G.729B 8kbps");
 		j->caplist[j->caps].captype = codec;
 		j->caplist[j->caps].cap = G729B;
-		j->caplist[j->caps].handle = j->caps++;
+		j->caplist[j->caps].handle = j->caps;
+		j->caps++;
 	}
 }
 
-- 
1.7.9.1

