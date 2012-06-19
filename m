Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2FSNDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 09:03:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:11474 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab2FSNDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 09:03:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113748948"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] mpilib: use DIV_ROUN_UP macro
Date: Tue, 19 Jun 2012 16:02:47 +0300
Message-Id: <1340110967-11011-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And remove MIN, MAX and ABS macros that are duplicates kernel's native
implementation.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/digsig.c           |    3 ++-
 lib/mpi/mpi-internal.h |    4 ----
 lib/mpi/mpicoder.c     |    4 ++--
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/lib/digsig.c b/lib/digsig.c
index 286d558..a83eefc 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -27,6 +27,7 @@
 #include <keys/user-type.h>
 #include <linux/mpi.h>
 #include <linux/digsig.h>
+#include <linux/kernel.h>
 
 static struct crypto_shash *shash;
 
@@ -120,7 +121,7 @@ static int digsig_verify_rsa(struct key *key,
 	}
 
 	mblen = mpi_get_nbits(pkey[0]);
-	mlen = (mblen + 7)/8;
+	mlen = DIV_ROUND_UP(mblen, 8);
 
 	if (mlen == 0)
 		goto err;
diff --git a/lib/mpi/mpi-internal.h b/lib/mpi/mpi-internal.h
index 77adcf6..60cf765 100644
--- a/lib/mpi/mpi-internal.h
+++ b/lib/mpi/mpi-internal.h
@@ -65,10 +65,6 @@
 typedef mpi_limb_t *mpi_ptr_t;	/* pointer to a limb */
 typedef int mpi_size_t;		/* (must be a signed type) */
 
-#define ABS(x) (x >= 0 ? x : -x)
-#define MIN(l, o) ((l) < (o) ? (l) : (o))
-#define MAX(h, i) ((h) > (i) ? (h) : (i))
-
 static inline int RESIZE_IF_NEEDED(MPI a, unsigned b)
 {
 	if (a->alloced < b)
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index f0fa659..2dce8b6 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -41,8 +41,8 @@ MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 	buffer += 2;
 	nread = 2;
 
-	nbytes = (nbits + 7) / 8;
-	nlimbs = (nbytes + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB;
+	nbytes = DIV_ROUND_UP(nbits, 8);
+	nlimbs = DIV_ROUND_UP(nbytes, BYTES_PER_MPI_LIMB);
 	val = mpi_alloc(nlimbs);
 	if (!val)
 		return NULL;
-- 
1.7.10

