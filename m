Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab2HaIAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 04:00:25 -0400
Received: from mga01.intel.com ([192.55.52.88]:15266 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801Ab2HaIAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 04:00:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,346,1344236400"; 
   d="scan'208";a="216566646"
Message-ID: <50406F60.5040707@intel.com>
Date: Fri, 31 Aug 2012 11:01:36 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH v2 07/12] rbtree: adjust root color in rb_insert_color()
 only when necessary
References: <1342139517-3451-1-git-send-email-walken@google.com> <1342139517-3451-8-git-send-email-walken@google.com>
In-Reply-To: <1342139517-3451-8-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/07/12 03:31, Michel Lespinasse wrote:
> The root node of an rbtree must always be black. However, rb_insert_color()
> only needs to maintain this invariant when it has been broken - that is,
> when it exits the loop due to the current (red) node being the root.
> In all other cases (exiting after tree rotations, or exiting due to
> an existing black parent) the invariant is already satisfied, so there
> is no need to adjust the root node color.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> ---
>  lib/rbtree.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/rbtree.c b/lib/rbtree.c
> index 12abb8a..d0be5fc 100644
> --- a/lib/rbtree.c
> +++ b/lib/rbtree.c
> @@ -91,8 +91,21 @@ void rb_insert_color(struct rb_node *node, struct rb_root *root)
>  {
>  	struct rb_node *parent, *gparent;
>  
> -	while ((parent = rb_parent(node)) && rb_is_red(parent))
> -	{
> +	while (true) {

This breaks tools/perf build in linux-next:

../../lib/rbtree.c: In function 'rb_insert_color':
../../lib/rbtree.c:95:9: error: 'true' undeclared (first use in this function)
../../lib/rbtree.c:95:9: note: each undeclared identifier is reported only once for each function it appears in
../../lib/rbtree.c: In function '__rb_erase_color':
../../lib/rbtree.c:216:9: error: 'true' undeclared (first use in this function)
../../lib/rbtree.c: In function 'rb_erase':
../../lib/rbtree.c:368:2: error: unknown type name 'bool'
make: *** [util/rbtree.o] Error 1

How about:

From: Adrian Hunter <adrian.hunter@intel.com>
Date: Fri, 31 Aug 2012 10:49:27 +0300
Subject: [PATCH] perf tools: fix build for another rbtree.c change

Fixes:

../../lib/rbtree.c: In function 'rb_insert_color':
../../lib/rbtree.c:95:9: error: 'true' undeclared (first use in this function)
../../lib/rbtree.c:95:9: note: each undeclared identifier is reported only once for each function it appears in
../../lib/rbtree.c: In function '__rb_erase_color':
../../lib/rbtree.c:216:9: error: 'true' undeclared (first use in this function)
../../lib/rbtree.c: In function 'rb_erase':
../../lib/rbtree.c:368:2: error: unknown type name 'bool'
make: *** [util/rbtree.o] Error 1

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/include/linux/rbtree.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
index 7a243a1..2a030c5 100644
--- a/tools/perf/util/include/linux/rbtree.h
+++ b/tools/perf/util/include/linux/rbtree.h
@@ -1 +1,2 @@
+#include <stdbool.h>
 #include "../../../../include/linux/rbtree.h"
-- 
1.7.11.4

