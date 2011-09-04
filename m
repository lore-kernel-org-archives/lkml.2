Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab1IDK15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 06:27:57 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:45915 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1IDK1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 06:27:00 -0400
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Avi Kivity <avi@redhat.com>, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH] parse-events: Allow expressions in __print_symbolic() fields
Date: Sun,  4 Sep 2011 11:25:59 +0100
Message-Id: <1315131959-7452-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __print_symbolic() function takes a sequence of key-value pairs for
pretty-printing a constant.  The new kvm:kvm_exit print fmt uses the
expression:

  __print_symbolic(..., { 0x040 + 1, "DB excp" }, ...)

Currently only atoms are supported and this print fmt fails to parse.
This patch adds support for expressions instead of just atoms so that
0x040 + 1 is parsed successfully.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 parse-events.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 1cdc3a9..e9b7e7d 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -2110,6 +2110,13 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
+
+		if (type == EVENT_OP)
+			type = process_op(event, arg, &token);
+
+		if (type == EVENT_ERROR)
+			goto out_free;
+
 		if (test_type_token(type, token, EVENT_DELIM, ","))
 			goto out_free;
 
-- 
1.7.5.4

