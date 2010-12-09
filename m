Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0LIHJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 02:09:47 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:26798 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335Ab0LIHJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 02:09:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAB8PAE15LdBk/2dsb2JhbACjbXm/ZYVKBA
Date: Thu, 9 Dec 2010 18:09:38 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Big git diff speedup by avoiding x86 "fast string" memcmp
Message-ID: <20101209070938.GA3949@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was actually discussing this with Linus a while back, and finally
got around to testing it out now that I have a modern CPU to measure
it on! CCing linux-arch because it would be interesting to know
whether your tuned functions do better than gcc or not (I would
suspect not).

BTW. patch and numbers are on top of my scaling series, just for
an idea of what it does, I just want to generate some interesting
discussion.

If people are interested in running benchmarks, I'll be pushing out
a new update soon, after some more testing and debugging here.

The standard memcmp function on a Westmere system shows up hot in
profiles in the `git diff` workload (both parallel and single threaded),
and it is likely due to the costs associated with trapping into
microcode, and little opportunity to improve memory access (dentry
name is not likely to take up more than a cacheline).

So replace it with an open-coded byte comparison. This increases code
size by 24 bytes in the critical __d_lookup_rcu function, but the
speedup is huge, averaging 10 runs of each:

git diff st   user   sys   elapsed  CPU
before        1.15   2.57  3.82      97.1
after         1.14   2.35  3.61      96.8

git diff mt   user   sys   elapsed  CPU
before        1.27   3.85  1.46     349
after         1.26   3.54  1.43     333

Elapsed time for single threaded git diff at 95.0% confidence:
        -0.21  +/- 0.01
        -5.45% +/- 0.24%

Parallel case doesn't gain much, but that's because userspace runs
out of work to feed it -- efficiency is way up, though.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c	2010-12-09 05:07:19.000000000 +1100
+++ linux-2.6/fs/dcache.c	2010-12-09 17:37:30.000000000 +1100
@@ -1423,7 +1423,7 @@ static struct dentry *__d_instantiate_un
 			goto next;
 		if (qstr->len != len)
 			goto next;
-		if (memcmp(qstr->name, name, len))
+		if (dentry_memcmp(qstr->name, name, len))
 			goto next;
 		__dget_dlock(alias);
 		spin_unlock(&alias->d_lock);
@@ -1771,7 +1771,7 @@ struct dentry *__d_lookup_rcu(struct den
 		} else {
 			if (tlen != len)
 				continue;
-			if (memcmp(tname, str, tlen))
+			if (dentry_memcmp(tname, str, tlen))
 				continue;
 		}
 		/*
@@ -1901,7 +1901,7 @@ struct dentry *__d_lookup(struct dentry
 		} else {
 			if (tlen != len)
 				goto next;
-			if (memcmp(tname, str, tlen))
+			if (dentry_memcmp(tname, str, tlen))
 				goto next;
 		}
 
Index: linux-2.6/include/linux/dcache.h
===================================================================
--- linux-2.6.orig/include/linux/dcache.h	2010-12-09 05:07:52.000000000 +1100
+++ linux-2.6/include/linux/dcache.h	2010-12-09 05:08:36.000000000 +1100
@@ -47,6 +47,20 @@ struct dentry_stat_t {
 };
 extern struct dentry_stat_t dentry_stat;
 
+static inline int dentry_memcmp(const unsigned char *cs,
+				const unsigned char *ct, size_t count)
+{
+	while (count) {
+		int ret = (*cs != *ct);
+		if (ret)
+			return ret;
+		cs++;
+		ct++;
+		count--;
+	}
+	return 0;
+}
+
 /* Name hashing routines. Initial hash value */
 /* Hash courtesy of the R5 hash in reiserfs modulo sign bits */
 #define init_name_hash()		0
