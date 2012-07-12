Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab2GLWjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:39:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44509 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759666Ab2GLWix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:38:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Jayaraman <sjayaraman@suse.com>,
        Sachin Prabhu <sprabhu@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [ 058/187] cifs: fix parsing of password mount option
Date: Thu, 12 Jul 2012 15:33:34 -0700
Message-Id: <20120712191527.751421797@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suresh Jayaraman <sjayaraman@suse.com>

commit e73f843a3235a19de38359c91586e9eadef12238 upstream.

The double delimiter check that allows a comma in the password parsing code is
unconditional. We set "tmp_end" to the end of the string and we continue to
check for double delimiter. In the case where the password doesn't contain a
comma we end up setting tmp_end to NULL and eventually setting "options" to
"end". This results in the premature termination of the options string and hence
the values of UNCip and UNC are being set to NULL. This results in mount failure
with "Connecting to DFS root not implemented yet" error.

This error is usually not noticable as we have password as the last option in
the superblock mountdata. But when we call expand_dfs_referral() from
cifs_mount() and try to compose mount options for the submount, the resulting
mountdata will be of the form

   ",ver=1,user=foo,pass=bar,ip=x.x.x.x,unc=\\server\share"

and hence results in the above error. This bug has been seen with older NAS
servers running Samba 3.0.24.

Fix this by moving the double delimiter check inside the conditional loop.

Changes since -v1

   - removed the wrong strlen() micro optimization.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.com>
Acked-by: Sachin Prabhu <sprabhu@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1585,24 +1585,26 @@ cifs_parse_mount_options(const char *mou
 			 * If yes, we have encountered a double deliminator
 			 * reset the NULL character to the deliminator
 			 */
-			if (tmp_end < end && tmp_end[1] == delim)
+			if (tmp_end < end && tmp_end[1] == delim) {
 				tmp_end[0] = delim;
 
-			/* Keep iterating until we get to a single deliminator
-			 * OR the end
-			 */
-			while ((tmp_end = strchr(tmp_end, delim)) != NULL &&
-			       (tmp_end[1] == delim)) {
-				tmp_end = (char *) &tmp_end[2];
-			}
+				/* Keep iterating until we get to a single
+				 * deliminator OR the end
+				 */
+				while ((tmp_end = strchr(tmp_end, delim))
+					!= NULL && (tmp_end[1] == delim)) {
+						tmp_end = (char *) &tmp_end[2];
+				}
 
-			/* Reset var options to point to next element */
-			if (tmp_end) {
-				tmp_end[0] = '\0';
-				options = (char *) &tmp_end[1];
-			} else
-				/* Reached the end of the mount option string */
-				options = end;
+				/* Reset var options to point to next element */
+				if (tmp_end) {
+					tmp_end[0] = '\0';
+					options = (char *) &tmp_end[1];
+				} else
+					/* Reached the end of the mount option
+					 * string */
+					options = end;
+			}
 
 			/* Now build new password string */
 			temp_len = strlen(value);


