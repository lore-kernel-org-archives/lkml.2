Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab2BEW0b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:31 -0500
Received: from 1wt.eu ([62.212.114.60]:61933 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003Ab2BEW01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:27 -0500
Message-Id: <20120205220951.247956479@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:31 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 42/91] cifs: fix possible memory corruption in CIFSFindNext
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 9438fabb73eb48055b58b89fc51e0bc4db22fabd upstream.

The name_len variable in CIFSFindNext is a signed int that gets set to
the resume_name_len in the cifs_search_info. The resume_name_len however
is unsigned and for some infolevels is populated directly from a 32 bit
value sent by the server.

If the server sends a very large value for this, then that value could
look negative when converted to a signed int. That would make that
value pass the PATH_MAX check later in CIFSFindNext. The name_len would
then be used as a length value for a memcpy. It would then be treated
as unsigned again, and the memcpy scribbles over a ton of memory.

Fix this by making the name_len an unsigned value in CIFSFindNext.

Reported-by: Darren Lavender <dcl@hppine99.gbr.hp.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/cifs/cifssmb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/fs/cifs/cifssmb.c
===================================================================
--- longterm-2.6.27.orig/fs/cifs/cifssmb.c	2012-02-05 22:34:33.755917316 +0100
+++ longterm-2.6.27/fs/cifs/cifssmb.c	2012-02-05 22:34:40.813915010 +0100
@@ -3649,7 +3649,8 @@
 	T2_FNEXT_RSP_PARMS *parms;
 	char *response_data;
 	int rc = 0;
-	int bytes_returned, name_len;
+	int bytes_returned;
+	unsigned int name_len;
 	__u16 params, byte_count;
 
 	cFYI(1, ("In FindNext"));


