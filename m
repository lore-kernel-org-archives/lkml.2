Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1DSUQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:16:53 -0400
Received: from kroah.org ([198.145.64.141]:47557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab1DSUQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:16:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:44 2011
Message-Id: <20110419201043.940587460@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:08:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [07/70] cifs: wrap received signature check in srv_mutex
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 157c249114508aa71daa308a426e15d81a4eed00 upstream.

While testing my patchset to fix asynchronous writes, I hit a bunch
of signature problems when testing with signing on. The problem seems
to be that signature checks on receive can be running at the same
time as a process that is sending, or even that multiple receives can
be checking signatures at the same time, clobbering the same data
structures.

While we're at it, clean up the comments over cifs_calculate_signature
and add a note that the srv_mutex should be held when calling this
function.

This patch seems to fix the problems for me, but I'm not clear on
whether it's the best approach. If it is, then this should probably
go to stable too.

Cc: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsencrypt.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -30,12 +30,13 @@
 #include <linux/ctype.h>
 #include <linux/random.h>
 
-/* Calculate and return the CIFS signature based on the mac key and SMB PDU */
-/* the 16 byte signature must be allocated by the caller  */
-/* Note we only use the 1st eight bytes */
-/* Note that the smb header signature field on input contains the
-	sequence number before this function is called */
-
+/*
+ * Calculate and return the CIFS signature based on the mac key and SMB PDU.
+ * The 16 byte signature must be allocated by the caller. Note we only use the
+ * 1st eight bytes and that the smb header signature field on input contains
+ * the sequence number before this function is called. Also, this function
+ * should be called with the server->srv_mutex held.
+ */
 static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
 				struct TCP_Server_Info *server, char *signature)
 {
@@ -209,8 +210,10 @@ int cifs_verify_signature(struct smb_hdr
 					cpu_to_le32(expected_sequence_number);
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
+	mutex_lock(&server->srv_mutex);
 	rc = cifs_calculate_signature(cifs_pdu, server,
 		what_we_think_sig_should_be);
+	mutex_unlock(&server->srv_mutex);
 
 	if (rc)
 		return rc;


