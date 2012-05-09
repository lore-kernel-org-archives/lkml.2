Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab2EIGEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:04:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38974 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756540Ab2EIFxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:39 -0400
Message-Id: <20120509055048.404100850@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 136/167] [PATCH] Fix __read_seqcount_begin() to use ACCESS_ONCE for sequence
 value read
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/seqlock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index c6db9fb..bb1fac5 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -141,7 +141,7 @@ static inline unsigned __read_seqcount_begin(const seqcount_t *s)
 	unsigned ret;
 
 repeat:
-	ret = s->sequence;
+	ret = ACCESS_ONCE(s->sequence);
 	if (unlikely(ret & 1)) {
 		cpu_relax();
 		goto repeat;
-- 
1.7.10



