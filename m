Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2CMUu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:50:27 -0400
Received: from ozlabs.org ([203.10.76.45]:56602 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab2CMUu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:50:26 -0400
Date: Wed, 14 Mar 2012 07:50:10 +1100
From: Anton Blanchard <anton@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: [PATCH] afs: Read of file returns EBADMSG
Message-ID: <20120314075010.4bd92311@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
Cc: <stable@kernel.org>
---

Index: linux-build/fs/afs/internal.h
===================================================================
--- linux-build.orig/fs/afs/internal.h	2012-03-14 07:47:22.169945898 +1100
+++ linux-build/fs/afs/internal.h	2012-03-14 07:47:32.398126509 +1100
@@ -109,7 +109,7 @@ struct afs_call {
 	unsigned		reply_size;	/* current size of reply */
 	unsigned		first_offset;	/* offset into mapping[first] */
 	unsigned		last_to;	/* amount of mapping[last] */
-	unsigned short		offset;		/* offset into received data store */
+	unsigned		offset;		/* offset into received data store */
 	unsigned char		unmarshall;	/* unmarshalling phase */
 	bool			incoming;	/* T if incoming call */
 	bool			send_pages;	/* T if data from mapping should be sent */
