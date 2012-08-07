Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab2HGXnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 19:43:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997Ab2HGW11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:27:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 010/122] smack: off by one error
Date: Tue,  7 Aug 2012 15:24:58 -0700
Message-Id: <20120807221949.167564072@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 3b9fc37280c521b086943f9aedda767f5bf3b2d3 upstream.

Consider the input case of a rule that consists entirely of non space
symbols followed by a \0. Say 64 + \0

In this case strlen(data) = 64
kzalloc of subject and object are 64 byte objects
sscanfdata, "%s %s %s", subject, ...)

will put 65 bytes into subject.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/smack/smackfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -325,11 +325,11 @@ static int smk_parse_long_rule(const cha
 	int datalen;
 	int rc = -1;
 
-	/*
-	 * This is probably inefficient, but safe.
-	 */
+	/* This is inefficient */
 	datalen = strlen(data);
-	subject = kzalloc(datalen, GFP_KERNEL);
+
+	/* Our first element can be 64 + \0 with no spaces */
+	subject = kzalloc(datalen + 1, GFP_KERNEL);
 	if (subject == NULL)
 		return -1;
 	object = kzalloc(datalen, GFP_KERNEL);


