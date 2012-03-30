Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966260Ab2C3VnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:43:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:36000 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965188Ab2C3Vbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:31:35 -0400
X-Sasl-enc: K0UmI3yhcT48cfSdCBV2umWqTVX7mcV4IhT3ooYlmLWq 1333143094
X-Mailbox-Line: From gregkh@linuxfoundation.org Fri Mar 30 12:48:53 2012
Message-Id: <20120330194853.727136288@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 136/175] jbd2: clear BH_Delay & BH_Unwritten in journal_unmap_buffer
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 15291164b22a357cb211b618adfef4fa82fc0de3 upstream.

journal_unmap_buffer()'s zap_buffer: code clears a lot of buffer head
state ala discard_buffer(), but does not touch _Delay or _Unwritten as
discard_buffer() does.

This can be problematic in some areas of the ext4 code which assume
that if they have found a buffer marked unwritten or delay, then it's
a live one.  Perhaps those spots should check whether it is mapped
as well, but if jbd2 is going to tear down a buffer, let's really
tear it down completely.

Without this I get some fsx failures on sub-page-block filesystems
up until v3.2, at which point 4e96b2dbbf1d7e81f22047a50f862555a6cb87cb
and 189e868fa8fdca702eb9db9d8afc46b5cb9144c9 make the failures go
away, because buried within that large change is some more flag
clearing.  I still think it's worth doing in jbd2, since
->invalidatepage leads here directly, and it's the right place
to clear away these flags.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/transaction.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1949,6 +1949,8 @@ zap_buffer_unlocked:
 	clear_buffer_mapped(bh);
 	clear_buffer_req(bh);
 	clear_buffer_new(bh);
+	clear_buffer_delay(bh);
+	clear_buffer_unwritten(bh);
 	bh->b_bdev = NULL;
 	return may_free;
 }


