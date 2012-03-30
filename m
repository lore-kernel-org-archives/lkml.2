Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934689Ab2C3XKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:10:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37370 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933890Ab2C3VD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:03:57 -0400
Message-Id: <20120330195724.712260091@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:57:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Liz Clark <liz.clark@hp.com>
Subject: [ 018/108] TTY: Wrong unicode value copied in con_set_unimap()
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liz Clark <liz.clark@hp.com>

commit 4a4c61b7ce26bfc9d49ea4bd121d52114bad9f99 upstream.

Bugzilla 40012: PIO_UNIMAP bug: error updating Unicode-to-font map
https://bugzilla.kernel.org/show_bug.cgi?id=40012

The unicode font map for the virtual console is a 32x32x64 table which
allocates rows dynamically as entries are added.  The unicode value
increases sequentially and should count all entries even in empty
rows.  The defect is when copying the unicode font map in con_set_unimap(),
the unicode value is not incremented properly.  The wrong unicode value
is entered in the new font map.

Signed-off-by: Liz Clark <liz.clark@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/consolemap.c |   51 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 43 insertions(+), 8 deletions(-)

--- a/drivers/tty/vt/consolemap.c
+++ b/drivers/tty/vt/consolemap.c
@@ -516,6 +516,7 @@ int con_set_unimap(struct vc_data *vc, u
 	int err = 0, err1, i;
 	struct uni_pagedir *p, *q;
 
+	/* Save original vc_unipagdir_loc in case we allocate a new one */
 	p = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
 	if (p->readonly) return -EIO;
 	
@@ -528,26 +529,57 @@ int con_set_unimap(struct vc_data *vc, u
 		err1 = con_clear_unimap(vc, NULL);
 		if (err1) return err1;
 		
+		/*
+		 * Since refcount was > 1, con_clear_unimap() allocated a
+		 * a new uni_pagedir for this vc.  Re: p != q
+		 */
 		q = (struct uni_pagedir *)*vc->vc_uni_pagedir_loc;
-		for (i = 0, l = 0; i < 32; i++)
+
+		/*
+		 * uni_pgdir is a 32*32*64 table with rows allocated
+		 * when its first entry is added.  The unicode value must
+		 * still be incremented for empty rows.  We are copying
+		 * entries from "p" (old) to "q" (new).
+		 */
+		l = 0;		/* unicode value */
+		for (i = 0; i < 32; i++)
 		if ((p1 = p->uni_pgdir[i]))
 			for (j = 0; j < 32; j++)
-			if ((p2 = p1[j]))
+			if ((p2 = p1[j])) {
 				for (k = 0; k < 64; k++, l++)
 				if (p2[k] != 0xffff) {
+					/*
+					 * Found one, copy entry for unicode
+					 * l with fontpos value p2[k].
+					 */
 					err1 = con_insert_unipair(q, l, p2[k]);
 					if (err1) {
 						p->refcount++;
 						*vc->vc_uni_pagedir_loc = (unsigned long)p;
 						con_release_unimap(q);
 						kfree(q);
-						return err1; 
+						return err1;
 					}
-              			}
-              	p = q;
-	} else if (p == dflt)
+				}
+			} else {
+				/* Account for row of 64 empty entries */
+				l += 64;
+			}
+		else
+			/* Account for empty table */
+			l += 32 * 64;
+
+		/*
+		 * Finished copying font table, set vc_uni_pagedir to new table
+		 */
+		p = q;
+	} else if (p == dflt) {
 		dflt = NULL;
-	
+	}
+
+	/*
+	 * Insert user specified unicode pairs into new table.
+	 */
 	while (ct--) {
 		unsigned short unicode, fontpos;
 		__get_user(unicode, &list->unicode);
@@ -557,11 +589,14 @@ int con_set_unimap(struct vc_data *vc, u
 		list++;
 	}
 	
+	/*
+	 * Merge with fontmaps of any other virtual consoles.
+	 */
 	if (con_unify_unimap(vc, p))
 		return err;
 
 	for (i = 0; i <= 3; i++)
-		set_inverse_transl(vc, p, i); /* Update all inverse translations */
+		set_inverse_transl(vc, p, i); /* Update inverse translations */
 	set_inverse_trans_unicode(vc, p);
   
 	return err;


