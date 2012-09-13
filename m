Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab2IMXug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:50:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759236Ab2IMXua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:50:30 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/16] MPILIB: Provide a function to read raw data into an MPI
To: herbert@gondor.hengli.com.au, rusty@rustcorp.com.au
Cc: linux-crypto@vger.kernel.org, zohar@us.ibm.com, dmitry.kasatkin@intel.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 14 Sep 2012 00:50:14 +0100
Message-ID: <20120913235014.3575.79467.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
References: <20120913234802.3575.77103.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a function to read raw data of a predetermined size into an MPI rather
than expecting the size to be encoded within the data.  The data is assumed to
represent an unsigned integer, and the resulting MPI will be positive.

The function looks like this:

	MPI mpi_read_raw_data(const void *, size_t);

This is useful for reading ASN.1 integer primitives where the length is encoded
in the ASN.1 metadata.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/mpi.h |    1 +
 lib/mpi/mpicoder.c  |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)


diff --git a/include/linux/mpi.h b/include/linux/mpi.h
index d02cca6..5af1b81 100644
--- a/include/linux/mpi.h
+++ b/include/linux/mpi.h
@@ -76,6 +76,7 @@ void mpi_swap(MPI a, MPI b);
 
 /*-- mpicoder.c --*/
 MPI do_encode_md(const void *sha_buffer, unsigned nbits);
+MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes);
 MPI mpi_read_from_buffer(const void *buffer, unsigned *ret_nread);
 int mpi_fromstr(MPI val, const char *str);
 u32 mpi_get_keyid(MPI a, u32 *keyid);
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index f0fa659..3962b7f 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -18,10 +18,65 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
  */
 
+#include <linux/bitops.h>
+#include <asm-generic/bitops/count_zeros.h>
 #include "mpi-internal.h"
 
 #define MAX_EXTERN_MPI_BITS 16384
 
+/**
+ * mpi_read_raw_data - Read a raw byte stream as a positive integer
+ * @xbuffer: The data to read
+ * @nbytes: The amount of data to read
+ */
+MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes)
+{
+	const uint8_t *buffer = xbuffer;
+	int i, j;
+	unsigned nbits, nlimbs;
+	mpi_limb_t a;
+	MPI val = NULL;
+
+	while (nbytes >= 0 && buffer[0] == 0) {
+		buffer++;
+		nbytes--;
+	}
+
+	nbits = nbytes * 8;
+	if (nbits > MAX_EXTERN_MPI_BITS) {
+		pr_info("MPI: mpi too large (%u bits)\n", nbits);
+		return NULL;
+	}
+	if (nbytes > 0)
+		nbits -= count_leading_zeros(buffer[0]);
+	else
+		nbits = 0;
+
+	nlimbs = (nbytes + BYTES_PER_MPI_LIMB - 1) / BYTES_PER_MPI_LIMB;
+	val = mpi_alloc(nlimbs);
+	if (!val)
+		return NULL;
+	val->nbits = nbits;
+	val->sign = 0;
+	val->nlimbs = nlimbs;
+
+	if (nbytes > 0) {
+		i = BYTES_PER_MPI_LIMB - nbytes % BYTES_PER_MPI_LIMB;
+		i %= BYTES_PER_MPI_LIMB;
+		for (j = nlimbs; j > 0; j--) {
+			a = 0;
+			for (; i < BYTES_PER_MPI_LIMB; i++) {
+				a <<= 8;
+				a |= *buffer++;
+			}
+			i = 0;
+			val->d[j - 1] = a;
+		}
+	}
+	return val;
+}
+EXPORT_SYMBOL_GPL(mpi_read_raw_data);
+
 MPI mpi_read_from_buffer(const void *xbuffer, unsigned *ret_nread)
 {
 	const uint8_t *buffer = xbuffer;

