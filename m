Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab1DYUZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:32 -0400
Received: from 1wt.eu ([62.212.114.60]:34518 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342Ab1DYUZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:15 -0400
Message-Id: <20110425200239.815172404@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 157/173] irda: prevent integer underflow in IRLMP_ENUMDEVICES
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
Cc: Moritz Muehlenhoff <jmm@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/irda/af_irda.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -2164,6 +2164,14 @@ static int irda_getsockopt(struct socket
 
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
@@ -2173,15 +2181,9 @@ static int irda_getsockopt(struct socket
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


