Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421Ab1DZV2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:28:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:60444 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932326Ab1DZVOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327301"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: drosenberg@vsecurity.com, davem@davemloft.net, ak@linux.intel.com,
        jmm@debian.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [49/106] irda: prevent integer underflow in IRLMP_ENUMDEVICES
Message-Id: <20110426211329.4F22C3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

commit fdac1e0697356ac212259f2147aa60c72e334861 upstream.

If the user-provided len is less than the expected offset, the
IRLMP_ENUMDEVICES getsockopt will do a copy_to_user() with a very large
size value.  While this isn't be a security issue on x86 because it will
get caught by the access_ok() check, it may leak large amounts of kernel
heap on other architectures.  In any event, this patch fixes it.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/irda/af_irda.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6.35.y/net/irda/af_irda.c
===================================================================
--- linux-2.6.35.y.orig/net/irda/af_irda.c
+++ linux-2.6.35.y/net/irda/af_irda.c
@@ -2278,6 +2278,14 @@ static int __irda_getsockopt(struct sock
 
 	switch (optname) {
 	case IRLMP_ENUMDEVICES:
+
+		/* Offset to first device entry */
+		offset = sizeof(struct irda_device_list) -
+			sizeof(struct irda_device_info);
+
+		if (len < offset)
+			return -EINVAL;
+
 		/* Ask lmp for the current discovery log */
 		discoveries = irlmp_get_discoveries(&list.len, self->mask.word,
 						    self->nslots);
@@ -2287,15 +2295,9 @@ static int __irda_getsockopt(struct sock
 		err = 0;
 
 		/* Write total list length back to client */
-		if (copy_to_user(optval, &list,
-				 sizeof(struct irda_device_list) -
-				 sizeof(struct irda_device_info)))
+		if (copy_to_user(optval, &list, offset))
 			err = -EFAULT;
 
-		/* Offset to first device entry */
-		offset = sizeof(struct irda_device_list) -
-			sizeof(struct irda_device_info);
-
 		/* Copy the list itself - watch for overflow */
 		if(list.len > 2048)
 		{
