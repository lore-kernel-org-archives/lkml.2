Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2CMAaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:30:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:48895 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965232Ab2CMAYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:53 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Pavel Shilovsky <piastry@etersoft.ru>,
        Steve French <sfrench@us.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 173/196] CIFS: Fix memory over bound bug in cifs_parse_mount_options
Date: Mon, 12 Mar 2012 20:21:26 -0400
Message-Id: <1331598109-31424-128-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shilovsky <piastry@etersoft.ru>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4906e50b37e6f6c264e7ee4237343eb2b7f8d16d upstream.

While password processing we can get out of options array bound if
the next character after array is delimiter. The patch adds a check
if we reach the end.

Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/cifs/connect.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f6afb59..cebbc29 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -800,8 +800,7 @@ static int
 cifs_parse_mount_options(char *options, const char *devname,
 			 struct smb_vol *vol)
 {
-	char *value;
-	char *data;
+	char *value, *data, *end;
 	unsigned int  temp_len, i, j;
 	char separator[2];
 	short int override_uid = -1;
@@ -844,6 +843,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 	if (!options)
 		return 1;
 
+	end = options + strlen(options);
 	if (strncmp(options, "sep=", 4) == 0) {
 		if (options[4] != 0) {
 			separator[0] = options[4];
@@ -908,6 +908,7 @@ cifs_parse_mount_options(char *options, const char *devname,
 			the only illegal character in a password is null */
 
 			if ((value[temp_len] == 0) &&
+			    (value + temp_len < end) &&
 			    (value[temp_len+1] == separator[0])) {
 				/* reinsert comma */
 				value[temp_len] = separator[0];
-- 
1.7.9.3

