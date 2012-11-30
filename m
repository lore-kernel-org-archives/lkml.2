Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993311Ab2K3TGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:06:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:59843 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993098Ab2K3TCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>, Ralf Baechle <ralf@linux-mips.org>,
        Shuah Khan <shuah.khan@hp.com>
Subject: [ 50/54] MPI: Fix compilation on MIPS with GCC 4.4 and newer
Date: Fri, 30 Nov 2012 10:56:21 -0800
Message-Id: <20121130185212.938237697@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Lauss <manuel.lauss@gmail.com>

commit a3cea9894157c20a5b1ec08b7e0b5f2019740c10 upstream.

Since 4.4 GCC on MIPS no longer recognizes the "h" constraint,
leading to this build failure:

  CC      lib/mpi/generic_mpih-mul1.o
lib/mpi/generic_mpih-mul1.c: In function 'mpihelp_mul_1':
lib/mpi/generic_mpih-mul1.c:50:3: error: impossible constraint in 'asm'

This patch updates MPI with the latest umul_ppm implementations for MIPS.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
Cc: Linux-MIPS <linux-mips@linux-mips.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: James Morris <jmorris@namei.org>
Patchwork: https://patchwork.linux-mips.org/patch/4612/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Shuah Khan <shuah.khan@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/mpi/longlong.h |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -703,7 +703,14 @@ do { \
 	**************  MIPS  *****************
 	***************************************/
 #if defined(__mips__) && W_TYPE_SIZE == 32
-#if __GNUC__ > 2 || __GNUC_MINOR__ >= 7
+#if __GNUC__ >= 4 && __GNUC_MINOR__ >= 4
+#define umul_ppmm(w1, w0, u, v)			\
+do {						\
+	UDItype __ll = (UDItype)(u) * (v);	\
+	w1 = __ll >> 32;			\
+	w0 = __ll;				\
+} while (0)
+#elif __GNUC__ > 2 || __GNUC_MINOR__ >= 7
 #define umul_ppmm(w1, w0, u, v) \
 	__asm__ ("multu %2,%3" \
 	: "=l" ((USItype)(w0)), \
@@ -728,7 +735,15 @@ do { \
 	**************  MIPS/64  **************
 	***************************************/
 #if (defined(__mips) && __mips >= 3) && W_TYPE_SIZE == 64
-#if __GNUC__ > 2 || __GNUC_MINOR__ >= 7
+#if __GNUC__ >= 4 && __GNUC_MINOR__ >= 4
+#define umul_ppmm(w1, w0, u, v) \
+do {									\
+	typedef unsigned int __ll_UTItype __attribute__((mode(TI)));	\
+	__ll_UTItype __ll = (__ll_UTItype)(u) * (v);			\
+	w1 = __ll >> 64;						\
+	w0 = __ll;							\
+} while (0)
+#elif __GNUC__ > 2 || __GNUC_MINOR__ >= 7
 #define umul_ppmm(w1, w0, u, v) \
 	__asm__ ("dmultu %2,%3" \
 	: "=l" ((UDItype)(w0)), \


