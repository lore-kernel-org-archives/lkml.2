Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857Ab1ESSYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:24:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41192 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933811Ab1ESSHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:07:45 -0400
X-Sasl-enc: 2vwtEff3JrXVRJ91jP0hE7jzLEndcgkdVH7K+8eeYJH6 1305828464
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:54 2011
Message-Id: <20110519180554.769933507@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [05/71] cifs: handle errors from coalesce_t2
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 16541ba11c4f04ffe94b073e301f00b749fb84a1 upstream.

cifs_demultiplex_thread calls coalesce_t2 to try and merge follow-on t2
responses into the original mid buffer. coalesce_t2 however can return
errors, but the caller doesn't handle that situation properly. Fix the
thread to treat such a case as it would a malformed packet. Mark the
mid as being malformed and issue the callback.

Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -631,12 +631,16 @@ incomplete_rcv:
 				isMultiRsp = true;
 				if (mid_entry->resp_buf) {
 					/* merge response - fix up 1st*/
-					if (coalesce_t2(smb_buffer,
-							mid_entry->resp_buf)) {
+					length = coalesce_t2(smb_buffer,
+							mid_entry->resp_buf);
+					if (length > 0) {
+						length = 0;
 						mid_entry->multiRsp = true;
 						break;
 					} else {
-						/* all parts received */
+						/* all parts received or
+						 * packet is malformed
+						 */
 						mid_entry->multiEnd = true;
 						goto multi_t2_fnd;
 					}


