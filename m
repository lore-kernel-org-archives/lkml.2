Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab2CUVQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 17:16:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47498 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755668Ab2CUVQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 17:16:31 -0400
Message-Id: <20120321211448.417848299@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 21 Mar 2012 14:14:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        David Howells <dhowells@redhat.com>
Subject: [ 2/8] afs: Read of file returns EBADMSG
In-Reply-To: <20120321211522.GA28233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 2c724fb92732c0b2a5629eb8af74e82eb62ac947 upstream.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


