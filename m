Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab2GaM4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:56:10 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:37108 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab2GaM4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:56:07 -0400
X-AuditID: b753bd60-932c5ba0000047ca-3f-5017d5e49c28
X-AuditID: b753bd60-932c5ba0000047ca-3f-5017d5e49c28
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH] sysctl: fix improper indication of integer sysctl parameter
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Date: Tue, 31 Jul 2012 22:03:14 +0900
Message-ID: <20120731130314.24441.85882.stgit@ltc137.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes the improper type casting of integer
sysctl parameters.

When we read the sysctl parameter, they are always treated
as signed integer, and are casted into unsigned long type
in the current kernel. If we set a value equivalent to
(the maximum value in signed integer + 1) which is a power
of 2 and just causes the overflow, they outputs unexpected
value.

This bug can be reproduced as follows.

Example)
 # echo $((1<<31)) > /proc/sys/fs/lease-break-time
 # cat /proc/sys/fs/lease-break-time
 -18446744071562067968
   (It should be -2147483648.)
or
 # echo XXX > /proc/sys/fs/pipe-max-size
   (where XXX is an arbitrary number between (1<<30 + 1) and
    (1<<31 - 1) since the pipe-max-size is rounded up to a
    power of 2 in kernel.)
 # cat /proc/sys/fs/pipe-max-size
 -18446744071562067968
   (It should be -2147483648.)

To fix this problem, this patch casts the negative integer
into unsigned int type, instead of unsigned long type.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
---

 kernel/sysctl.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 97186b9..e282b5b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1789,7 +1789,7 @@ static int do_proc_dointvec_conv(bool *negp, unsigned long *lvalp,
 		int val = *valp;
 		if (val < 0) {
 			*negp = true;
-			*lvalp = (unsigned long)-val;
+			*lvalp = (unsigned int)-val;
 		} else {
 			*negp = false;
 			*lvalp = (unsigned long)val;
@@ -1982,7 +1982,7 @@ static int do_proc_dointvec_minmax_conv(bool *negp, unsigned long *lvalp,
 		int val = *valp;
 		if (val < 0) {
 			*negp = true;
-			*lvalp = (unsigned long)-val;
+			*lvalp = (unsigned int)-val;
 		} else {
 			*negp = false;
 			*lvalp = (unsigned long)val;
@@ -2197,7 +2197,7 @@ static int do_proc_dointvec_jiffies_conv(bool *negp, unsigned long *lvalp,
 		unsigned long lval;
 		if (val < 0) {
 			*negp = true;
-			lval = (unsigned long)-val;
+			lval = (unsigned int)-val;
 		} else {
 			*negp = false;
 			lval = (unsigned long)val;
@@ -2220,7 +2220,7 @@ static int do_proc_dointvec_userhz_jiffies_conv(bool *negp, unsigned long *lvalp
 		unsigned long lval;
 		if (val < 0) {
 			*negp = true;
-			lval = (unsigned long)-val;
+			lval = (unsigned int)-val;
 		} else {
 			*negp = false;
 			lval = (unsigned long)val;
@@ -2241,7 +2241,7 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
 		unsigned long lval;
 		if (val < 0) {
 			*negp = true;
-			lval = (unsigned long)-val;
+			lval = (unsigned int)-val;
 		} else {
 			*negp = false;
 			lval = (unsigned long)val;

