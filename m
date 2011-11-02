Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1KCBdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:33:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab1KCBdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:33:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:52 2011
Message-Id: <20111102221452.753088329@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [029/107] cifs: fix possible memory corruption in CIFSFindNext
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

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
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3596,7 +3596,8 @@ int CIFSFindNext(const int xid, struct c
 	T2_FNEXT_RSP_PARMS *parms;
 	char *response_data;
 	int rc = 0;
-	int bytes_returned, name_len;
+	int bytes_returned;
+	unsigned int name_len;
 	__u16 params, byte_count;
 
 	cFYI(1, ("In FindNext"));


