Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab1DZVOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:14:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:60586 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334Ab1DZVOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="684327417"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: Artem.Bityutskiy@nokia.com, ak@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [62/106] UBIFS: fix oops when R/O file-system is fsync'ed
Message-Id: <20110426211343.01AB53E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reported-by: Reuben Dowle <Reuben.Dowle@navico.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/file.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/fs/ubifs/file.c
===================================================================
--- linux-2.6.35.y.orig/fs/ubifs/file.c
+++ linux-2.6.35.y/fs/ubifs/file.c
@@ -1315,6 +1315,9 @@ int ubifs_fsync(struct file *file, int d
 
 	dbg_gen("syncing inode %lu", inode->i_ino);
 
+	if (inode->i_sb->s_flags & MS_RDONLY)
+		return 0;
+
 	/*
 	 * VFS has already synchronized dirty pages for this inode. Synchronize
 	 * the inode unless this is a 'datasync()' call.
