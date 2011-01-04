Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1ADPai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:30:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:58100 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1ADPag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:30:36 -0500
Date: Tue, 4 Jan 2011 13:30:00 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@elte.hu
Subject: Re: [GIT PULL||RFC 00/11] perf library and regression testing
 improvements
Message-ID: <20110104152959.GH19989@ghostprotocols.net>
References: <AANLkTinjkC=4yQbiLxF7=G1izFa2pOuR=WvRXbha3wsj@mail.gmail.com>
 <20110104140338.GA19989@ghostprotocols.net>
 <AANLkTi=osr9ZB9OzPxZ_99FU1A5JzCA3rMM64fxws34S@mail.gmail.com>
 <20110104141958.GC19989@ghostprotocols.net>
 <20110104142715.GD19989@ghostprotocols.net>
 <AANLkTik93yG1e80a8MBYDfFBu1YwZ+BA6LqOh-EsLHO_@mail.gmail.com>
 <20110104143658.GF19989@ghostprotocols.net>
 <AANLkTin6udBreRt0zYcmDfCZZDwLjkwhg93-hFafy=4f@mail.gmail.com>
 <AANLkTinqf+5cOv-pDMnhGt2dkHEkM2q_GcG6Aa-LzNAe@mail.gmail.com>
 <AANLkTik=kHNPPbAo7ynD4AY68Vd3t1bxW_2stZx2QAFH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik=kHNPPbAo7ynD4AY68Vd3t1bxW_2stZx2QAFH@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 04, 2011 at 04:10:17PM +0100, Stephane Eranian escreveu:
> Ok, The problem comes both files picking up a different verison for
> perf_event.h.
> 
> In my case, util/evsel.c was using /usr/include/linux/perf_event.h whereas
> builtin-stat.c was using ../../include/linux/perf_event.h. Both have a different
> struct perf_event_attr.
> 
> When I remove the /usr/include/linux/perf_event.h file, then I cannot compile
> perf anymore:
> In file included from perf.c:15:
> util/parse-events.h:7:30: error: linux/perf_event.h: No such file or directory
> 
> Looks like something changed in the Makefile and the util modules don't know
> where to pickup perf_event.h

With the patch below now we have all as:

[acme@felicio linux]$ find tools/ -name "*.[ch]" | xargs grep 'include.\+perf_event\.h'
tools/perf/util/session.h:#include "../../../include/linux/perf_event.h"
tools/perf/util/header.h:#include "../../../include/linux/perf_event.h"
tools/perf/util/evsel.h:#include "../../../include/linux/perf_event.h"
tools/perf/perf.h:#include "../../include/linux/perf_event.h"
[acme@felicio linux]$

Can you try it so that I can get your Acked-by and Tested-by?

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 863d78d..a0ccd69 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -3,7 +3,7 @@
 
 #include <linux/list.h>
 #include <stdbool.h>
-#include <linux/perf_event.h>
+#include "../../../include/linux/perf_event.h"
 #include "types.h"
 #include "xyarray.h"
  
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 1c9043c..cefef9a 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -4,9 +4,9 @@
  * Parse symbolic events/counts passed in as options:
  */
 
-#include <linux/perf_event.h>
+#include <linux/list.h>
+#include "types.h"
 
-struct list_head;
 struct perf_evsel;
 
 extern struct list_head evsel_list;
