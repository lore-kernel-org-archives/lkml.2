Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab2HGTo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:44:57 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:14624 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2HGToz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:44:55 -0400
Date: Tue, 7 Aug 2012 21:44:54 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: William Hubbs <w.d.hubbs@gmail.com>,
        Chris Brannon <chris@the-brannons.com>,
        Kirk Reiser <kirk@braille.uwo.ca>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>, speakup@braille.uwo.ca,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: speakup: i18n.c: Fix leak in msg_set()
Message-ID: <alpine.LNX.2.00.1208072142510.3227@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we end up returning -EINVAL from the function we will leak the
memory allocated to 'newstr' which has been allocated but not yet
assigned to anything.
Fix the leak by properly freeing the memory again before we return.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/speakup/i18n.c | 1 +
 1 file changed, 1 insertion(+)

 Compile tested only.

diff --git a/drivers/staging/speakup/i18n.c b/drivers/staging/speakup/i18n.c
index ca01734..7c1658b 100644
--- a/drivers/staging/speakup/i18n.c
+++ b/drivers/staging/speakup/i18n.c
@@ -555,6 +555,7 @@ ssize_t msg_set(enum msg_index_t index, char *text, size_t length)
 			&& index <= MSG_FORMATTED_END)
 				&& !fmt_validate(speakup_default_msgs[index],
 				newstr)) {
+				kfree(newstr);
 				return -EINVAL;
 			}
 			spk_lock(flags);
-- 
1.7.11.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

