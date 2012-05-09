Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361Ab2EIFw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38620 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079Ab2EIFwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:22 -0400
Message-Id: <20120509055029.784819231@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:50:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Zeev Tarantov <zeev.tarantov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 001/167] Perf: fix build breakage
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/perf/util/hist.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -237,8 +237,8 @@ struct hist_entry *__hists__add_entry(st
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


