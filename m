Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab1IFVTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 17:19:32 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24526 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1IFVT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 17:19:27 -0400
Date: Tue, 6 Sep 2011 23:21:04 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Rocher <rocher.jeremy@gmail.com>,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH] misc/pti: give 'comm' function scope in
 pti_control_frame_built_and_sent()
Message-ID: <alpine.LNX.2.00.1109062317580.7016@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/misc/pti.c::pti_control_frame_built_and_sent() we assign
'comm' to 'thread_name_p' if (!thread_name). The problem is that 'comm'
then goes out of scope and later we use 'thread_name_p' which now
refers to an out-of-scope variable.
To fix that, simply move 'comm' up to have function scope.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/misc/pti.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

 Only compile tested.

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index 06df187..0b56e3f 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -165,6 +165,11 @@ static void pti_write_to_aperture(struct pti_masterchannel *mc,
 static void pti_control_frame_built_and_sent(struct pti_masterchannel *mc,
 					     const char *thread_name)
 {
+	/*
+	 * Since we access the comm member in current's task_struct, we only
+	 * need to be as large as what 'comm' in that structure is.
+	 */
+	char comm[TASK_COMM_LEN];
 	struct pti_masterchannel mccontrol = {.master = CONTROL_ID,
 					      .channel = 0};
 	const char *thread_name_p;
@@ -172,13 +177,6 @@ static void pti_control_frame_built_and_sent(struct pti_masterchannel *mc,
 	u8 control_frame[CONTROL_FRAME_LEN];
 
 	if (!thread_name) {
-		/*
-		 * Since we access the comm member in current's task_struct,
-		 * we only need to be as large as what 'comm' in that
-		 * structure is.
-		 */
-		char comm[TASK_COMM_LEN];
-
 		if (!in_interrupt())
 			get_task_comm(comm, current);
 		else
-- 
1.7.6.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

