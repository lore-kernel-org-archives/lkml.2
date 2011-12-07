Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab1LGRDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:03:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab1LGRDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:03:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:56:00 2011
Message-Id: <20111207165600.608220604@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:54:35 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Tyler Hicks <tyhicks@canonical.com>
Subject: [02/27] eCryptfs: Extend array bounds for all filename chars
In-Reply-To: <20111207165611.GA19872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/crypto.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1934,7 +1934,7 @@ static unsigned char *portable_filename_
 
 /* We could either offset on every reverse map or just pad some 0x00's
  * at the front here */
-static const unsigned char filename_rev_map[] = {
+static const unsigned char filename_rev_map[256] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 7 */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 15 */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 23 */
@@ -1950,7 +1950,7 @@ static const unsigned char filename_rev_
 	0x00, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, /* 103 */
 	0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32, 0x33, 0x34, /* 111 */
 	0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, /* 119 */
-	0x3D, 0x3E, 0x3F
+	0x3D, 0x3E, 0x3F /* 123 - 255 initialized to 0x00 */
 };
 
 /**


