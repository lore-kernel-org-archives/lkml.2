Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab1DSUR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:17:27 -0400
Received: from kroah.org ([198.145.64.141]:35598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab1DSURX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:47 2011
Message-Id: <20110419201047.451610546@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [40/70] UBIFS: fix oops when R/O file-system is fsynced
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

commit 78530bf7f2559b317c04991b52217c1608d5a58d upstream.

This patch fixes severe UBIFS bug: UBIFS oopses when we 'fsync()' an
file on R/O-mounter file-system. We (the UBIFS authors) incorrectly
thought that VFS would not propagate 'fsync()' down to the file-system
if it is read-only, but this is not the case.

It is easy to exploit this bug using the following simple perl script:

use strict;
use File::Sync qw(fsync sync);

die "File path is not specified" if not defined $ARGV[0];
my $path = $ARGV[0];

open FILE, "<", "$path" or die "Cannot open $path: $!";
fsync(\*FILE) or die "cannot fsync $path: $!";
close FILE or die "Cannot close $path: $!";

Thanks to Reuben Dowle <Reuben.Dowle@navico.com> for reporting about this
issue.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reported-by: Reuben Dowle <Reuben.Dowle@navico.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/file.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1309,6 +1309,9 @@ int ubifs_fsync(struct file *file, int d
 
 	dbg_gen("syncing inode %lu", inode->i_ino);
 
+	if (inode->i_sb->s_flags & MS_RDONLY)
+		return 0;
+
 	/*
 	 * VFS has already synchronized dirty pages for this inode. Synchronize
 	 * the inode unless this is a 'datasync()' call.


