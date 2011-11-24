Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1KXQ25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 11:28:57 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:13338
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755906Ab1KXQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 11:28:56 -0500
X-SpamScore: -5
X-BigFish: VPS-5(z33fclz1432N98dKzz1202hzz8275bh8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LV6B41-01-LJ0-02
X-M-MSG: 
Date: Thu, 24 Nov 2011 17:28:45 +0100
From: Robert Richter <robert.richter@amd.com>
To: <acme@redhat.com>
CC: <mingo@redhat.com>, <eranian@google.com>, <linux-kernel@vger.kernel.org>,
        <fweisbec@gmail.com>, <efault@gmx.de>, <peterz@infradead.org>
Subject: libperf interface stability
Message-ID: <20111124162845.GB7795@erda.amd.com>
References: <new-submission>
 <tip-06daaaba7c211ca6a8227b9a54dbc86dd837f034@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-06daaaba7c211ca6a8227b9a54dbc86dd837f034@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.10 07:49:49, tip-bot for Arnaldo Carvalho de Melo wrote:
> Commit-ID:  06daaaba7c211ca6a8227b9a54dbc86dd837f034
> Gitweb:     http://git.kernel.org/tip/06daaaba7c211ca6a8227b9a54dbc86dd837f034
> Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> AuthorDate: Wed, 21 Jul 2010 17:58:25 -0300
> Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
> CommitDate: Tue, 27 Jul 2010 11:24:31 -0300
> 
> perf hist: Introduce routine to measure lenght of formatted entry
> 
> Will be used to figure out the window width needed in the new tree
> widget.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/hist.c |   27 +++++++++++++++++++++++++++
>  tools/perf/util/hist.h |    3 +++
>  2 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
> index 0bc6790..f93095f 100644
> --- a/tools/perf/util/hist.c
> +++ b/tools/perf/util/hist.c
> @@ -850,6 +850,33 @@ print_entries:
>  	return ret;
>  }
>  
> +/*
> + * See hists__fprintf to match the column widths
> + */
> +unsigned int hists__sort_list_width(struct hists *self)
> +{
> +	struct sort_entry *se;
> +	int ret = 9; /* total % */
> +
> +	if (symbol_conf.show_cpu_utilization) {
> +		ret += 7; /* count_sys % */
> +		ret += 6; /* count_us % */
> +		if (perf_guest) {

Arnaldo,

this accesses a global variable that is not part of libperf. Linking
it causes undefined references, see below for example code. This
applies at least to following symbols: perf_guest, perf_host,
use_browser, perf_version_string. To fix this we need to extend the
library interface. As a workaround the references must be added to the
application using libperf:

bool perf_host;
bool perf_guest;
const char perf_version_string[] = "undefined";
int use_browser = -1;

Also there are library dependencies to -lelf -ldw -lm -lbfd even if
its functionality is not used. It would be better to load libraries
dynamically then or to have switches to disable code using them.

Is libperf supposed to be a library interface in general, or is it for
internal perf tools usage only? It would be good to have a well
defined, stable libperf interface for tools other than perf.

-Robert


$ cd tools/perf
$ cat linktest.c 
#include "util/evsel.h"
#include "util/evlist.h"
#include "util/cpumap.h"
#include "util/thread_map.h"

int main(void)
{
	perf_evlist__mmap(NULL, 0, 0);
	return 0;
}

$ gcc -I util/include/ -DNO_NEWT_SUPPORT -DNO_DWARF -lelf -ldw -lm -lbfd linktest.c libperf.a -o linktest
libperf.a(hist.o): In function `hists__sort_list_width':
tools/perf/util/hist.c:1074: undefined reference to `perf_guest'
tools/perf/util/hist.c:1074: undefined reference to `perf_guest'
libperf.a(hist.o): In function `hist_entry__pcnt_snprintf':
tools/perf/util/hist.c:779: undefined reference to `perf_guest'
libperf.a(hist.o): In function `hists__fprintf':
tools/perf/util/hist.c:938: undefined reference to `perf_guest'
tools/perf/util/hist.c:945: undefined reference to `perf_guest'
libperf.a(event.o):tools/perf/util/event.c:697: more undefined references to `perf_guest' follow
libperf.a(event.o): In function `thread__find_addr_map':
tools/perf/util/event.c:681: undefined reference to `perf_host'
tools/perf/util/event.c:673: undefined reference to `perf_host'
tools/perf/util/event.c:707: undefined reference to `perf_host'
tools/perf/util/event.c:684: undefined reference to `perf_guest'
tools/perf/util/event.c:703: undefined reference to `perf_guest'
libperf.a(debug.o): In function `eprintf':
tools/perf/util/debug.c:25: undefined reference to `use_browser'
libperf.a(header.o): In function `do_write_string':
tools/perf/util/header.c:126: undefined reference to `perf_version_string'
libperf.a(header.o): In function `do_write':
tools/perf/util/header.c:94: undefined reference to `perf_version_string'
collect2: ld returned 1 exit status


> +			ret += 13; /* count_guest_sys % */
> +			ret += 12; /* count_guest_us % */
> +		}
> +	}
> +
> +	if (symbol_conf.show_nr_samples)
> +		ret += 11;
> +
> +	list_for_each_entry(se, &hist_entry__sort_list, list)
> +		if (!se->elide)
> +			ret += 2 + hists__col_len(self, se->se_width_idx);
> +
> +	return ret;
> +}
> +
>  static void hists__remove_entry_filter(struct hists *self, struct hist_entry *h,
>  				       enum hist_filter filter)
>  {
> diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
> index 92962b2..65a48db 100644
> --- a/tools/perf/util/hist.h
> +++ b/tools/perf/util/hist.h
> @@ -141,4 +141,7 @@ int hist_entry__tui_annotate(struct hist_entry *self);
>  
>  int hists__tui_browse_tree(struct rb_root *self, const char *help);
>  #endif
> +
> +unsigned int hists__sort_list_width(struct hists *self);
> +
>  #endif	/* __PERF_HIST_H */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

