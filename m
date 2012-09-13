Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab2IMXtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:49:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759157Ab2IMXt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:49:26 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/16] MPILIB: Reinstate mpi_cmp[_ui]() and export for RSA
 signature verification
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: linux-crypto@vger.kernel.org, zohar@us.ibm.com, dmitry.kasatkin@intel.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 00:49:15 +0100
Message-ID: <20120913234915.3575.50626.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
References: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reinstate and export mpi_cmp() and mpi_cmp_ui() from the MPI library for use by
RSA signature verification as per RFC3447 section 5.2.2 step 1.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 lib/mpi/Makefile  |    1 +
 lib/mpi/mpi-cmp.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)
 create mode 100644 lib/mpi/mpi-cmp.c


diff --git a/lib/mpi/Makefile b/lib/mpi/Makefile
index 45ca90a..019a68c 100644
--- a/lib/mpi/Makefile
+++ b/lib/mpi/Makefile
@@ -14,6 +14,7 @@ mpi-y = \
 	generic_mpih-add1.o		\
 	mpicoder.o			\
 	mpi-bit.o			\
+	mpi-cmp.o			\
 	mpih-cmp.o			\
 	mpih-div.o			\
 	mpih-mul.o			\
diff --git a/lib/mpi/mpi-cmp.c b/lib/mpi/mpi-cmp.c
new file mode 100644
index 0000000..1871e7b
--- /dev/null
+++ b/lib/mpi/mpi-cmp.c
@@ -0,0 +1,70 @@
+/* mpi-cmp.c  -  MPI functions
+ * Copyright (C) 1998, 1999 Free Software Foundation, Inc.
+ *
+ * This file is part of GnuPG.
+ *
+ * GnuPG is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * GnuPG is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
+ */
+
+#include "mpi-internal.h"
+
+int mpi_cmp_ui(MPI u, unsigned long v)
+{
+	mpi_limb_t limb = v;
+
+	mpi_normalize(u);
+	if (!u->nlimbs && !limb)
+		return 0;
+	if (u->sign)
+		return -1;
+	if (u->nlimbs > 1)
+		return 1;
+
+	if (u->d[0] == limb)
+		return 0;
+	else if (u->d[0] > limb)
+		return 1;
+	else
+		return -1;
+}
+EXPORT_SYMBOL_GPL(mpi_cmp_ui);
+
+int mpi_cmp(MPI u, MPI v)
+{
+	mpi_size_t usize, vsize;
+	int cmp;
+
+	mpi_normalize(u);
+	mpi_normalize(v);
+	usize = u->nlimbs;
+	vsize = v->nlimbs;
+	if (!u->sign && v->sign)
+		return 1;
+	if (u->sign && !v->sign)
+		return -1;
+	if (usize != vsize && !u->sign && !v->sign)
+		return usize - vsize;
+	if (usize != vsize && u->sign && v->sign)
+		return vsize + usize;
+	if (!usize)
+		return 0;
+	cmp = mpihelp_cmp(u->d, v->d, usize);
+	if (!cmp)
+		return 0;
+	if ((cmp < 0 ? 1 : 0) == (u->sign ? 1 : 0))
+		return 1;
+	return -1;
+}
+EXPORT_SYMBOL_GPL(mpi_cmp);

