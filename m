Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab2JJXN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:13:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51214 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758066Ab2JJXB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:01:59 -0400
X-Sasl-enc: up3IpSuacttwbHNfc2+DS/DwAuNhiMQn/OMCNJNKlr6T 1349910118
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 030/122] jbd2: dont write superblock when if its empty
Date: Thu, 11 Oct 2012 07:53:16 +0900
Message-Id: <20121010225343.555706113@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit eeecef0af5ea4efd763c9554cf2bd80fc4a0efd3 upstream.

This sequence:

# truncate --size=1g fsfile
# mkfs.ext4 -F fsfile
# mount -o loop,ro fsfile /mnt
# umount /mnt
# dmesg | tail

results in an IO error when unmounting the RO filesystem:

[  318.020828] Buffer I/O error on device loop1, logical block 196608
[  318.027024] lost page write due to I/O error on loop1
[  318.032088] JBD2: Error -5 detected when updating journal superblock for loop1-8.

This was a regression introduced by commit 24bcc89c7e7c: "jbd2: split
updating of journal superblock and marking journal empty".

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/journal.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1354,6 +1354,11 @@ static void jbd2_mark_journal_empty(jour
 
 	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
 	read_lock(&journal->j_state_lock);
+	/* Is it already empty? */
+	if (sb->s_start == 0) {
+		read_unlock(&journal->j_state_lock);
+		return;
+	}
 	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
 		  journal->j_tail_sequence);
 


