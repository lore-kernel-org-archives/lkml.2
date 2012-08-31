Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab2HaIea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 04:34:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:15529 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab2HaIe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 04:34:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,346,1344236400"; 
   d="scan'208";a="187280965"
Message-ID: <5040775C.3070205@intel.com>
Date: Fri, 31 Aug 2012 11:35:40 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Shishkin, Alexander" <alexander.shishkin@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH v2 07/12] rbtree: adjust root color in rb_insert_color()
 only when necessary
References: <1342139517-3451-1-git-send-email-walken@google.com> <1342139517-3451-8-git-send-email-walken@google.com> <50406F60.5040707@intel.com> <CANN689EBA6yPk3pS-yXZ1-ticG7eU3mY1mWMWp2S3xhJ73ODFA@mail.gmail.com> <20120831011541.ddf8ed78.akpm@linux-foundation.org>
In-Reply-To: <20120831011541.ddf8ed78.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/12 11:15, Andrew Morton wrote:
> On Fri, 31 Aug 2012 01:07:24 -0700 Michel Lespinasse <walken@google.com> wrote:
> 
>> On Fri, Aug 31, 2012 at 1:01 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:
>>> This breaks tools/perf build in linux-next:
>>>
>>> ../../lib/rbtree.c: In function 'rb_insert_color':
>>> ../../lib/rbtree.c:95:9: error: 'true' undeclared (first use in this function)
>>> ../../lib/rbtree.c:95:9: note: each undeclared identifier is reported only once for each function it appears in
>>> ../../lib/rbtree.c: In function '__rb_erase_color':
>>> ../../lib/rbtree.c:216:9: error: 'true' undeclared (first use in this function)
>>> ../../lib/rbtree.c: In function 'rb_erase':
>>> ../../lib/rbtree.c:368:2: error: unknown type name 'bool'
>>> make: *** [util/rbtree.o] Error 1
>>
>> I thought Andrew had a patch
>> rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation
>> that fixed this though a Makefile change ?
> 
> Yup.  But it's unclear why we should include the header via the cc
> command line?

Dunno

AFAICS tools/perf/util/include/linux is for fixing up the
differences between kernel headers and exported kernel headers.
Hence my change:

diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
index 7a243a1..2a030c5 100644
--- a/tools/perf/util/include/linux/rbtree.h
+++ b/tools/perf/util/include/linux/rbtree.h
@@ -1 +1,2 @@
+#include <stdbool.h>
 #include "../../../../include/linux/rbtree.h"

Alex?

> 
> 
> From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Subject: rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation
> 
> Commit 2cfaf9cc68190c24fdd05e4d104099b3f27c7a44 (rbtree: adjust root color
> in rb_insert_color() only when necessary) introduces bool type and constants
> to the rbtree.c, and breaks compilation of tools/perf:
> 
> ../../lib/rbtree.c: In function `rb_insert_color':
> ../../lib/rbtree.c:95:9: error: `true' undeclared (first use in this function)
> ../../lib/rbtree.c:95:9: note: each undeclared identifier is reported only once
> or each function it appears in
> ../../lib/rbtree.c: In function `__rb_erase_color':
> ../../lib/rbtree.c:216:9: error: `true' undeclared (first use in this function)
> ../../lib/rbtree.c: In function `rb_erase':
> ../../lib/rbtree.c:368:2: error: unknown type name `bool'
> make: *** [util/rbtree.o] Error 1
> 
> This patch is the easiest solution I can think of.
> 
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Acked-by: Michel Lespinasse <walken@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  tools/perf/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN tools/perf/Makefile~rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation tools/perf/Makefile
> --- a/tools/perf/Makefile~rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation
> +++ a/tools/perf/Makefile
> @@ -806,7 +806,7 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
>  
>  $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
> -	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' -include stdbool.h $<
>  
>  $(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -Wno-redundant-decls $<
> _
> 
> 
> 

