Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab0DBMrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 08:47:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59351 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab0DBMrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 08:47:17 -0400
Date: Fri, 2 Apr 2010 14:47:13 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 1/3] arch/powerpc/platforms: Eliminate use after free
Message-ID: <Pine.LNX.4.64.1004021440020.17695@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

dlpar_free_cc_nodes frees its argument, so dlpar_online_cpu should not be
called on the same value.  Skip over the call to dlpar_online_cpu by
jumping directly to out.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E,E2;
@@

dlpar_free_cc_nodes(E)
...
(
  E = E2
|
* E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/powerpc/platforms/pseries/dlpar.c         |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index e1682bc..1540a41 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -433,6 +433,7 @@ static ssize_t dlpar_cpu_probe(const char *buf, size_t count)
 	if (rc) {
 		dlpar_release_drc(drc_index);
 		dlpar_free_cc_nodes(dn);
+		goto out;
 	}
 
 	rc = dlpar_online_cpu(dn);
