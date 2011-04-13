Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab1DMQNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:13:47 -0400
Received: from kroah.org ([198.145.64.141]:53090 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932987Ab1DMQNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:39 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:49 2011
Message-Id: <20110413161049.635731174@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "David S. Miller" <davem@davemloft.net>,
        Moritz Muehlenhoff <jmm@debian.org>
Subject: [67/71] irda: prevent integer underflow in IRLMP_ENUMDEVICES
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -2277,6 +2277,14 @@ static int __irda_getsockopt(struct sock
 
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
@@ -2286,15 +2294,9 @@ static int __irda_getsockopt(struct sock
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


