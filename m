Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2D3JaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:30:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab2D3JaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:30:09 -0400
From: Jan Kara <jack@suse.cz>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, Jan Kara <jack@suse.cz>, mgorman@suse.de,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] Describe race of direct read and fork for unaligned buffers
Date: Mon, 30 Apr 2012 11:30:07 +0200
Message-Id: <1335778207-6511-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a long standing problem (or a surprising feature) in our implementation
of get_user_pages() (used by direct IO). Since several attempts to fix it
failed (e.g.
http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg06542.html, or
http://lkml.indiana.edu/hypermail/linux/kernel/0903.1/01498.html refused in
http://comments.gmane.org/gmane.linux.kernel.mm/31569) and it's not completely
clear whether we really want to fix it given the costs, let's at least document
it.

CC: mgorman@suse.de
CC: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---

--- a/man2/open.2	2012-04-27 00:07:51.736883092 +0200
+++ b/man2/open.2	2012-04-27 00:29:59.489892980 +0200
@@ -769,7 +769,12 @@
 and the file offset must all be multiples of the logical block size
 of the file system.
 Under Linux 2.6, alignment to 512-byte boundaries
-suffices.
+suffices. However, if the user buffer is not page aligned and direct read
+runs in parallel with a
+.BR fork (2)
+of the reader process, it may happen that the read data is split between
+pages owned by the original process and its child. Thus effectively read
+data is corrupted.
 .LP
 The
 .B O_DIRECT
