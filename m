Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1GMU6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:58:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab1GMU6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:58:33 -0400
Date: Wed, 13 Jul 2011 22:58:18 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: acme@redhat.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCHv2] perf tools: Add missing 'node' alias to the hw_cache array
Message-ID: <20110713205818.GB7827@jolsa.brq.redhat.com>
References: <1310483256-5772-1-git-send-email-jolsa@redhat.com>
 <1310484647.14978.33.camel@twins>
 <20110713204348.GA7827@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110713204348.GA7827@jolsa.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resent with proper lkml email.. sry

---
On Tue, Jul 12, 2011 at 05:30:47PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-07-12 at 17:07 +0200, Jiri Olsa wrote:
> > Adding "node" as a alias for NODE cache events.
> > 
> > The addition of NODE cache events broke the parse_alias function,
> > so any mismatched event caused the segfault, like:
> > 
> >   # ./perf stat -e krava ls
> > 
> > The hw_cache array needs to follow PERF_COUNT_HW_CACHE_MAX enum.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  tools/perf/util/parse-events.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> > index 41982c3..f599b91 100644
> > --- a/tools/perf/util/parse-events.c
> > +++ b/tools/perf/util/parse-events.c
> > @@ -89,10 +89,11 @@ static const char *sw_event_names[PERF_COUNT_SW_MAX] = {
> >  static const char *hw_cache[][MAX_ALIASES] = {
> >   { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
> >   { "L1-icache",	"l1-i",		"l1i",		"L1-instruction",	},
> > - { "LLC",	"L2"							},
> > + { "LLC",	"L2",							},
> >   { "dTLB",	"d-tlb",	"Data-TLB",				},
> >   { "iTLB",	"i-tlb",	"Instruction-TLB",			},
> >   { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
> > + { "node",								},
> >  };
> >  
> >  static const char *hw_cache_op[][MAX_ALIASES] = {
> 
> Looks like there's more to fix, hw_cache_stat would also need a fixup.

The hw_cache_stat is missing the NODE cache operation definition,
but the array itself has proper bounds, so should be ok.

I checked the original patch and looks like all read/write/prefetch
should be enabled..  I added them

> But wouldn't it be better to fix the tools not to crash if these _MAX
> numbers don't match up?

I added proper maximums to hw_cache/hw_cache_op/hw_cache_result
arrays definitions, so it will not segfault if any of them is not
properly updated in future.

attaching new patch

thanks,
jirka


---
Adding "node" as a simple alias for NODE cache events.

The addition of NODE cache events broke the parse_alias function,
so any mismatched event caused the segfault, like:

  # ./perf stat -e krava ls

The hw_cache/hw_cache_op/hw_cache_result arrays needs to follow
PERF_COUNT_HW_CACHE_*MAX enums. Adding those MAXs to be size
of those arrays, so possible ommision in future wil not lead to
segfault.

Adding read/write/prefetch as allowed operations for node cache
event.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 41982c3..c0e21ae 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -86,22 +86,24 @@ static const char *sw_event_names[PERF_COUNT_SW_MAX] = {
 
 #define MAX_ALIASES 8
 
-static const char *hw_cache[][MAX_ALIASES] = {
+static const char *hw_cache[PERF_COUNT_HW_CACHE_MAX][MAX_ALIASES] = {
  { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
  { "L1-icache",	"l1-i",		"l1i",		"L1-instruction",	},
- { "LLC",	"L2"							},
+ { "LLC",	"L2",							},
  { "dTLB",	"d-tlb",	"Data-TLB",				},
  { "iTLB",	"i-tlb",	"Instruction-TLB",			},
  { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
+ { "node",								},
 };
 
-static const char *hw_cache_op[][MAX_ALIASES] = {
+static const char *hw_cache_op[PERF_COUNT_HW_CACHE_OP_MAX][MAX_ALIASES] = {
  { "load",	"loads",	"read",					},
  { "store",	"stores",	"write",				},
  { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
 };
 
-static const char *hw_cache_result[][MAX_ALIASES] = {
+static const char *hw_cache_result[PERF_COUNT_HW_CACHE_RESULT_MAX]
+				  [MAX_ALIASES] = {
  { "refs",	"Reference",	"ops",		"access",		},
  { "misses",	"miss",							},
 };
@@ -124,6 +126,7 @@ static unsigned long hw_cache_stat[C(MAX)] = {
  [C(DTLB)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
  [C(ITLB)]	= (CACHE_READ),
  [C(BPU)]	= (CACHE_READ),
+ [C(NODE)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
 };
 
 #define for_each_subsystem(sys_dir, sys_dirent, sys_next)	       \
@@ -393,7 +396,7 @@ parse_generic_hw_event(const char **str, struct perf_event_attr *attr)
 						PERF_COUNT_HW_CACHE_OP_MAX);
 			if (cache_op >= 0) {
 				if (!is_cache_op_valid(cache_type, cache_op))
-					return 0;
+					return EVT_FAILED;
 				continue;
 			}
 		}
-- 
1.7.4

