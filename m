Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab1FWRiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:38:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:35648 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847Ab1FWRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:38:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 236/247] irda: prevent integer underflow in IRLMP_ENUMDEVICES
Date: Thu, 23 Jun 2011 13:35:04 -0400
Message-Id: <1308850515-15242-177-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit fdac1e0697356ac212259f2147aa60c72e334861 upstream.

If the user-provided len is less than the expected offset, the
IRLMP_ENUMDEVICES getsockopt will do a copy_to_user() with a very large
size value.  While this isn't be a security issue on x86 because it will
get caught by the access_ok() check, it may leak large amounts of kernel
heap on other architectures.  In any event, this patch fixes it.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/irda/af_irda.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/irda/af_irda.c b/net/irda/af_irda.c
index 6fae047..e63c226 100644
--- a/net/irda/af_irda.c
+++ b/net/irda/af_irda.c
@@ -2278,6 +2278,14 @@ static int __irda_getsockopt(struct socket *sock, int level, int optname,
 
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
@@ -2287,15 +2295,9 @@ static int __irda_getsockopt(struct socket *sock, int level, int optname,
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
-- 
1.7.4.4

