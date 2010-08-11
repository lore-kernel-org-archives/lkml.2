Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab0HKX7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:59:44 -0400
Received: from kroah.org ([198.145.64.141]:43699 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014Ab0HKX7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:23 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:04 2010
Message-Id: <20100811235504.528889428@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [097/111] ext4: Fix optional-arg mount options
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 15121c18a22ae483279f76dc9e554334b800d0f7 upstream.

We have 2 mount options, "barrier" and "auto_da_alloc" which may or
may not take a 1/0 argument.  This causes the ext4 superblock mount
code to subtract uninitialized pointers and pass the result to
kmalloc, which results in very noisy failures.

Per Ted's suggestion, initialize the args struct so that
we know whether match_token() found an argument for the
option, and skip match_int() if not.

Also, return error (0) from parse_options if we thought
we found an argument, but match_int() Fails.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1218,6 +1218,11 @@ static int parse_options(char *options,
 		if (!*p)
 			continue;
 
+		/*
+		 * Initialize args struct so we know whether arg was
+		 * found; some options take optional arguments.
+		 */
+		args[0].to = args[0].from = 0;
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_bsd_df:
@@ -1503,10 +1508,11 @@ set_qf_format:
 			clear_opt(sbi->s_mount_opt, BARRIER);
 			break;
 		case Opt_barrier:
-			if (match_int(&args[0], &option)) {
-				set_opt(sbi->s_mount_opt, BARRIER);
-				break;
-			}
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				option = 1;	/* No argument, default to 1 */
 			if (option)
 				set_opt(sbi->s_mount_opt, BARRIER);
 			else
@@ -1579,10 +1585,11 @@ set_qf_format:
 			set_opt(sbi->s_mount_opt,NO_AUTO_DA_ALLOC);
 			break;
 		case Opt_auto_da_alloc:
-			if (match_int(&args[0], &option)) {
-				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
-				break;
-			}
+			if (args[0].from) {
+				if (match_int(&args[0], &option))
+					return 0;
+			} else
+				option = 1;	/* No argument, default to 1 */
 			if (option)
 				clear_opt(sbi->s_mount_opt, NO_AUTO_DA_ALLOC);
 			else


