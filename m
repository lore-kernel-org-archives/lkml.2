Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936Ab1ESSIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:08:14 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45102 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933818Ab1ESSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:11 -0400
X-Sasl-enc: gQiCVs7UB8wxk9VL9y3AAYIZD0KJFA98BxlY0qnZKa/d 1305828490
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:56 2011
Message-Id: <20110519180556.205254396@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Shilovsky <piastry@etersoft.ru>,
        Steve French <sfrench@us.ibm.com>
Subject: [20/71] CIFS: Fix memory over bound bug in cifs_parse_mount_options
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Shilovsky <piastry@etersoft.ru>

commit 4906e50b37e6f6c264e7ee4237343eb2b7f8d16d upstream.

While password processing we can get out of options array bound if
the next character after array is delimiter. The patch adds a check
if we reach the end.

Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -822,8 +822,7 @@ static int
 cifs_parse_mount_options(char *options, const char *devname,
 			 struct smb_vol *vol)
 {
-	char *value;
-	char *data;
+	char *value, *data, *end;
 	unsigned int  temp_len, i, j;
 	char separator[2];
 	short int override_uid = -1;
@@ -866,6 +865,7 @@ cifs_parse_mount_options(char *options,
 	if (!options)
 		return 1;
 
+	end = options + strlen(options);
 	if (strncmp(options, "sep=", 4) == 0) {
 		if (options[4] != 0) {
 			separator[0] = options[4];
@@ -930,6 +930,7 @@ cifs_parse_mount_options(char *options,
 			the only illegal character in a password is null */
 
 			if ((value[temp_len] == 0) &&
+			    (value + temp_len < end) &&
 			    (value[temp_len+1] == separator[0])) {
 				/* reinsert comma */
 				value[temp_len] = separator[0];


