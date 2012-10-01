Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374Ab2JAXIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:08:25 -0400
Received: from 1wt.eu ([62.212.114.60]:35644 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690Ab2JAXDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:11 -0400
Message-Id: <20121001225157.823530006@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
        Stefan Bader <stefan.bader@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 005/180] jbd2: clear BH_Delay & BH_Unwritten in journal_unmap_buffer
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 15291164b22a357cb211b618adfef4fa82fc0de3 upstream.

journal_unmap_buffer()'s zap_buffer: code clears a lot of buffer head
state ala discard_buffer(), but does not touch _Delay or _Unwritten as
discard_buffer() does.

This can be problematic in some areas of the ext4 code which assume
that if they have found a buffer marked unwritten or delay, then it's
a live one.  Perhaps those spots should check whether it is mapped
as well, but if jbd2 is going to tear down a buffer, let's really
tear it down completely.

Without this I get some fsx failures on sub-page-block filesystems
up until v3.2, at which point 4e96b2dbbf1d7e81f22047a50f862555a6cb87cb
and 189e868fa8fdca702eb9db9d8afc46b5cb9144c9 make the failures go
away, because buried within that large change is some more flag
clearing.  I still think it's worth doing in jbd2, since
->invalidatepage leads here directly, and it's the right place
to clear away these flags.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org

BugLink: http://bugs.launchpad.net/bugs/929781
CVE-2011-4086

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/jbd2/transaction.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a051270..5c156ad 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1822,6 +1822,8 @@ zap_buffer_unlocked:
 	clear_buffer_mapped(bh);
 	clear_buffer_req(bh);
 	clear_buffer_new(bh);
+	clear_buffer_delay(bh);
+	clear_buffer_unwritten(bh);
 	bh->b_bdev = NULL;
 	return may_free;
 }
-- 
1.7.2.1.45.g54fbc



