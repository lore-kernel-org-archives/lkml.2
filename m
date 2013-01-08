Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab3AHXgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:36:47 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53533 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab3AHXgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:36:43 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tyler Hicks <tyhicks@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 21/77] eCryptfs: Extend array bounds for all filename chars
Date: Tue, 8 Jan 2013 18:35:00 -0500
Message-ID: <1357688156-25387-22-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tyler Hicks <tyhicks@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 0f751e641a71157aa584c2a2e22fda52b52b8a56 upstream.

>From mhalcrow's original commit message:

    Characters with ASCII values greater than the size of
    filename_rev_map[] are valid filename characters.
    ecryptfs_decode_from_filename() will access kernel memory beyond
    that array, and ecryptfs_parse_tag_70_packet() will then decrypt
    those characters. The attacker, using the FNEK of the crafted file,
    can then re-encrypt the characters to reveal the kernel memory past
    the end of the filename_rev_map[] array. I expect low security
    impact since this array is statically allocated in the text area,
    and the amount of memory past the array that is accessible is
    limited by the largest possible ASCII filename character.

This patch solves the issue reported by mhalcrow but with an
implementation suggested by Linus to simply extend the length of
filename_rev_map[] to 256. Characters greater than 0x7A are mapped to
0x00, which is how invalid characters less than 0x7A were previously
being handled.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Michael Halcrow <mhalcrow@google.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ecryptfs/crypto.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 1cc0876..45dc658 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1934,7 +1934,7 @@ static unsigned char *portable_filename_chars = ("-.0123456789ABCD"
 
 /* We could either offset on every reverse map or just pad some 0x00's
  * at the front here */
-static const unsigned char filename_rev_map[] = {
+static const unsigned char filename_rev_map[256] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 7 */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 15 */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 23 */
@@ -1950,7 +1950,7 @@ static const unsigned char filename_rev_map[] = {
 	0x00, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, /* 103 */
 	0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32, 0x33, 0x34, /* 111 */
 	0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, /* 119 */
-	0x3D, 0x3E, 0x3F
+	0x3D, 0x3E, 0x3F /* 123 - 255 initialized to 0x00 */
 };
 
 /**
-- 
1.7.12.1

