Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032725Ab2CPK2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:28:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031019Ab2CPK2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:28:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] afs: Read of file returns EBADMSG
To: torvalds@linux-foundation.org
Cc: linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        David Howells <dhowells@redhat.com>, <stable@kernel.org>
Date: Fri, 16 Mar 2012 10:28:07 +0000
Message-ID: <20120316102807.21424.24579.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

A read of a large file on an afs mount failed:

# cat junk.file > /dev/null
cat: junk.file: Bad message

Looking at the trace, call->offset wrapped since it is only an
unsigned short. In afs_extract_data:


        _enter("{%u},{%zu},%d,,%zu", call->offset, len, last, count);
...

        if (call->offset < count) {
                if (last) {
                        _leave(" = -EBADMSG [%d < %zu]", call->offset, count);
                        return -EBADMSG;
                }


Which matches the trace:

[cat   ] ==> afs_extract_data({65132},{524},1,,65536)
[cat   ] <== afs_extract_data() = -EBADMSG [0 < 65536]

call->offset went from 65132 to 0. Fix this by making call->offset an
unsigned int.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: <stable@kernel.org>
---

 fs/afs/internal.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index d2b0888..a306bb6 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -109,7 +109,7 @@ struct afs_call {
 	unsigned		reply_size;	/* current size of reply */
 	unsigned		first_offset;	/* offset into mapping[first] */
 	unsigned		last_to;	/* amount of mapping[last] */
-	unsigned short		offset;		/* offset into received data store */
+	unsigned		offset;		/* offset into received data store */
 	unsigned char		unmarshall;	/* unmarshalling phase */
 	bool			incoming;	/* T if incoming call */
 	bool			send_pages;	/* T if data from mapping should be sent */

