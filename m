Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab2DWGii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:38:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55117 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab2DWGih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:38:37 -0400
Date: Mon, 23 Apr 2012 09:37:04 +0300
From: Zeev Tarantov <zeev.tarantov@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: commit 1cb41fe7e34a43a1d27dfdb6d65699786dd44c20 in stable (v3.3.3)
 breaks perf
Message-ID: <20120423063704.GA3465@myhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc correctly complains:

util/hist.c: In function ‘__hists__add_entry’:
util/hist.c:240:27: error: invalid type argument of ‘->’ (have ‘struct hist_entry’)
util/hist.c:241:23: error: invalid type argument of ‘->’ (have ‘struct hist_entry’)

for this new code:

+                       if (he->ms.map != entry->ms.map) {
+                               he->ms.map = entry->ms.map;
+                               if (he->ms.map)
+                                       he->ms.map->referenced = true;
+                       }

because "entry" is a "struct hist_entry", not a pointer to a struct.

In mainline, "entry" is a pointer to struct passed as argument to the function.
So this is broken during backporting. But obviously not compile tested. 
Greg wrote on G+ that those who did not test 3.3.3-rc1 have no right to complain, but I'm complaining anyway. :P

See trivial patch to fix this.
-Z.T.

P.S.
I don't need credit for the patch so it's ok if my diff doesn't apply because of messed up whitespace.
Just fix it.

Signed-off-by: Zeev Tarantov <zeev.tarantov@gmail.com>

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index a47a6f1..1794b92 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -237,8 +237,8 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			 * mis-adjust symbol addresses when computing
 			 * the history counter to increment.
 			 */
-			if (he->ms.map != entry->ms.map) {
-				he->ms.map = entry->ms.map;
+			if (he->ms.map != entry.ms.map) {
+				he->ms.map = entry.ms.map;
 				if (he->ms.map)
 					he->ms.map->referenced = true;
 			}

