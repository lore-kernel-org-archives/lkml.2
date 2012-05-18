Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946257Ab2ERXDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:03:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946199Ab2ERXC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:02:56 -0400
Message-Id: <20120518211600.010480077@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 06/54] Fix __read_seqcount_begin() to use ACCESS_ONCE for sequence value read
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2f624278626677bfaf73fef97f86b37981621f5c upstream.

We really need to use a ACCESS_ONCE() on the sequence value read in
__read_seqcount_begin(), because otherwise the compiler might end up
reloading the value in between the test and the return of it.  As a
result, it might end up returning an odd value (which means that a write
is in progress).

If the reader is then fast enough that that odd value is still the
current one when the read_seqcount_retry() is done, we might end up with
a "successful" read sequence, even despite the concurrent write being
active.

In practice this probably never really happens - there just isn't
anything else going on around the read of the sequence count, and the
common case is that we end up having a read barrier immediately
afterwards.

So the code sequence in which gcc might decide to reaload from memory is
small, and there's no reason to believe it would ever actually do the
reload.  But if the compiler ever were to decide to do so, it would be
incredibly annoying to debug.  Let's just make sure.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/seqlock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -141,7 +141,7 @@ static inline unsigned __read_seqcount_b
 	unsigned ret;
 
 repeat:
-	ret = s->sequence;
+	ret = ACCESS_ONCE(s->sequence);
 	if (unlikely(ret & 1)) {
 		cpu_relax();
 		goto repeat;


