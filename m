Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003Ab0GASXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:23:50 -0400
Received: from kroah.org ([198.145.64.141]:40587 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757959Ab0GASXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:42 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:13 2010
Message-Id: <20100701173213.813166594@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:31:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Moyer <jmoyer@redhat.com>, Rik van Riel <riel@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
Subject: [patch 083/149] do_generic_file_read: clear page errors when issuing a fresh read of the page
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Moyer <jmoyer@redhat.com>

commit 91803b499cca2fe558abad709ce83dc896b80950 upstream.

I/O errors can happen due to temporary failures, like multipath
errors or losing network contact with the iSCSI server. Because
of that, the VM will retry readpage on the page.

However, do_generic_file_read does not clear PG_error.  This
causes the system to be unable to actually use the data in the
page cache page, even if the subsequent readpage completes
successfully!

The function filemap_fault has had a ClearPageError before
readpage forever.  This patch simply adds the same to
do_generic_file_read.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Larry Woodman <lwoodman@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/filemap.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1120,6 +1120,12 @@ page_not_up_to_date_locked:
 		}
 
 readpage:
+		/*
+		 * A previous I/O error may have been due to temporary
+		 * failures, eg. multipath errors.
+		 * PG_error will be set again if readpage fails.
+		 */
+		ClearPageError(page);
 		/* Start the actual read. The read will unlock the page. */
 		error = mapping->a_ops->readpage(filp, page);
 


