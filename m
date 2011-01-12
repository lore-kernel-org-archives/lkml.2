Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1ALR0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:26:50 -0500
Received: from thunk.org ([69.25.196.29]:44053 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab1ALR0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:26:48 -0500
Date: Wed, 12 Jan 2011 12:26:46 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Oops while going into hibernate
Message-ID: <20110112172646.GB13496@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Sebastian Ott <sebott@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.02.1101121443230.1900@localhost6.localdomain6>
 <20110112162655.GA13496@thunk.org>
 <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1101121755400.2011@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I don't have a machine set up to test hibernation easily at
hand, I'd really appreciate it if you could try this patch to
determine which inode had the NULL jinode --- and then once you get
the device and inode number, to use debugfs's "ncheck" command to map
the inode number to a pathname.

If you could do that, it would be a huge help.

Thanks, regards,

						- Ted

P.S.  Also, if you could try suspending once or twice, with different
programs running, to see if the inode number and pathname are constant
or vary, that would also be helpful.

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index d8b992e..7d6d7d7 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -252,8 +252,15 @@ static inline int ext4_journal_force_commit(journal_t *journal)
 
 static inline int ext4_jbd2_file_inode(handle_t *handle, struct inode *inode)
 {
-	if (ext4_handle_valid(handle))
+	if (ext4_handle_valid(handle)) {
+		if (unlikely(EXT4_I(inode)->jinode == NULL)) {
+			/* Should never happen */
+			ext4_msg(inode->i_sb, KERN_CRIT, 
+				 "inode #%lu has NULL jinode", inode->i_ino);
+			BUG();
+		}
 		return jbd2_journal_file_inode(handle, EXT4_I(inode)->jinode);
+	}
 	return 0;
 }
 
