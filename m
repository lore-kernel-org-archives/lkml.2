Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab2DXWrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:47:33 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706Ab2DXWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:37:22 -0400
Message-Id: <20120424223253.530067498@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Zeev Tarantov <zeev.tarantov@gmail.com>,
        "Signed-off-by: David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [ 01/42] Perf: fix build breakage
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Zeev Tarantov <zeev.tarantov@gmail.com>

[Patch not needed upstream as this is a backport build bugfix - gregkh

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

Signed-off-by: Zeev Tarantov <zeev.tarantov@gmail.com>
Cc: Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/hist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -165,8 +165,8 @@ struct hist_entry *__hists__add_entry(st
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


