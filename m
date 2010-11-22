Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0KVMAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 07:00:19 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34383 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434Ab0KVMAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 07:00:18 -0500
Date: Mon, 22 Nov 2010 12:00:02 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Namhyung Kim <namhyung@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scripts: Fix gfp-translate for recent changes to gfp.h
Message-ID: <20101122120002.GB1890@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent changes to gfp.h to satisfy sparse broke
scripts/gfp-translate. This patch fixes it up to work with old and new
versions of gfp.h .

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 scripts/gfp-translate |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/scripts/gfp-translate b/scripts/gfp-translate
index d81b968..128937e 100644
--- a/scripts/gfp-translate
+++ b/scripts/gfp-translate
@@ -63,7 +63,12 @@ fi
 
 # Extract GFP flags from the kernel source
 TMPFILE=`mktemp -t gfptranslate-XXXXXX` || exit 1
-grep "^#define __GFP" $SOURCE/include/linux/gfp.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
+grep ___GFP $SOURCE/include/linux/gfp.h > /dev/null
+if [ $? -eq 0 ]; then
+	grep "^#define ___GFP" $SOURCE/include/linux/gfp.h | sed -e 's/u$//' | grep -v GFP_BITS > $TMPFILE
+else
+	grep "^#define __GFP" $SOURCE/include/linux/gfp.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
+fi
 
 # Parse the flags
 IFS="
