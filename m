Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0K0KcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:32:07 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34780 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930Ab0K0K0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:26:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimE
Message-Id: <aef682c21ef964429896add1eb2c796fe758da03.1290852960.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:45:08 +1100
Subject: [PATCH 38/46] fs: prefetch inode data in dcache lookup
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gains another 5% or so on the cached git diff workload by
prefetching the important first cacheline of the inode in while
we do the actual name compare and other operations on the dentry.

There was no measurable slowdown in the single file stat case, or
the creat case (where negative dentries would be common). (actually
there was about a 5 nanosecond speedup in these cases, but I can't
say it is significant.

Workload is 100 git diffs in sequence:
real		user		sys

vanilla single thread
0m9.753s	0m1.860s 	0m7.230s
0m9.752s	0m1.960s 	0m7.270s
0m9.754s	0m1.870s 	0m7.290s
0m9.749s	0m1.910s 	0m7.330s
0m9.750s	0m2.110s 	0m7.060s

scale single thread
0m7.678s	0m1.990s 	0m5.090s
0m7.682s	0m2.090s 	0m5.000s
0m7.681s	0m1.970s 	0m5.100s
0m7.679s	0m1.810s 	0m5.280s
0m7.679s	0m1.970s 	0m5.100s

Single threaded case has about 25% higher throughput. The actual
kernel's throughput is increased by about 45%. This is incredibly
significant for a single threaded performance increase in core
kernel code in 2010.

vanilla multi thread (preloadindex=true)
0m6.517s	0m1.430s 	0m20.200s
0m6.514s	0m1.360s	0m20.230s
0m6.521s	0m1.410s 	0m20.090s
0m6.519s	0m1.410s 	0m20.060s
0m6.521s	0m1.610s 	0m20.140s

scale multi thread (preloadindex=true)
0m3.301s	0m0.840s 	0m3.300s
0m3.304s	0m0.940s 	0m3.320s
0m3.291s	0m0.930s 	0m3.170s
0m3.292s	0m0.900s 	0m3.230s
0m3.277s	0m0.770s 	0m3.230s

Parallel case throughput is very nearly doubled, despite git being
unable to produce enough work to keep all CPUs busy (118% CPU used
over the duration of the test). System time shows that scalability
of path walk has already turned to shit in the vanilla kernel.

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 58faf37..fa6e7a5 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1658,6 +1658,9 @@ seqretry:
 		tlen = dentry->d_name.len;
 		tname = dentry->d_name.name;
 		i = dentry->d_inode;
+		prefetch(tname);
+		if (i)
+			prefetch(i);
 		/*
 		 * This seqcount check is required to ensure name and
 		 * len are loaded atomically, so as not to walk off the
-- 
1.7.1

