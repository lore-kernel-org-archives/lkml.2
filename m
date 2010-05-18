Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab0ERRVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:21:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab0ERRVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:21:13 -0400
Message-ID: <4BF2CD2F.8000104@redhat.com>
Date: Tue, 18 May 2010 13:23:59 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 10/13] trace: Common code for kprobes/uprobes traceevents
References: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6> <20100518170024.20070.25438.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100518170024.20070.25438.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Srikar Dronamraju wrote:
> Move common parts of trace_kprobe.c and adjust
> kernel/trace/trace_kprobe.c after moving common code to
> kernel/trace/trace_probe.h
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Looks good!
I have just a few comments.

> diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
> new file mode 100644
> index 0000000..66a4498
> --- /dev/null
> +++ b/kernel/trace/trace_probe.h
> @@ -0,0 +1,111 @@
> +/*
> + * Uprobes-based tracing events

Isn't it a common header for kprobes and uprobes? :)

Maybe "Probe-based dynamic events common header" ?

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + *
> + * Copyright (C) IBM Corporation, 2010
> + * Author:	Srikar Dronamraju
> + */
> +
> +#include <linux/seq_file.h>
> +#include <linux/slab.h>
> +#include <linux/smp.h>
> +#include <linux/debugfs.h>
> +#include <linux/types.h>
> +#include <linux/string.h>
> +#include <linux/ctype.h>
> +#include <linux/ptrace.h>
> +#include <linux/perf_event.h>
> +
> +#include "trace.h"
> +#include "trace_output.h"
> +
> +#define MAX_TRACE_ARGS 128
> +#define MAX_ARGSTR_LEN 63
> +#define MAX_EVENT_NAME_LEN 64
> +#define UPROBE_EVENT_SYSTEM "uprobes"

You should *just move* the common code in this patch.
Additional uprobes code can be introduced in next patch.

> +#define KPROBE_EVENT_SYSTEM "kprobes"
> +
> +/* Reserved field names */
> +#define FIELD_STRING_IP "__probe_ip"
> +#define FIELD_STRING_NARGS "__probe_nargs"
> +#define FIELD_STRING_RETIP "__probe_ret_ip"
> +#define FIELD_STRING_FUNC "__probe_func"
> +#define FIELD_STRING_PID "__probe_pid"
> +
> +static const char *reserved_field_names[] = {
> +	"common_type",
> +	"common_flags",
> +	"common_preempt_count",
> +	"common_pid",
> +	"common_tgid",
> +	"common_lock_depth",
> +	FIELD_STRING_IP,
> +	FIELD_STRING_NARGS,
> +	FIELD_STRING_RETIP,
> +	FIELD_STRING_FUNC,
> +	FIELD_STRING_PID,
> +};
> +
> +/* Flags for trace_probe */
> +#define TP_FLAG_TRACE	1
> +#define TP_FLAG_PROFILE	2
> +#define UPROBE_ENABLED	4

If this is a trace_probe flag, it is better to start with TP_FLAG_.

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

