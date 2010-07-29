Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0G2MBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 08:01:55 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41912 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab0G2MBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 08:01:54 -0400
X-AuditID: b753bd60-a8cc1ba000005a63-4e-4c516daeee03
Message-ID: <4C516DAA.7030202@hitachi.com>
Date: Thu, 29 Jul 2010 21:01:46 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCHv10 2.6.35-rc6-tip 11/14]  perf: perf interface for uprobes
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6> <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100727111105.24690.48335.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srikar,

Srikar Dronamraju wrote:
> Enhances perf probe to accept pid and user vaddr.
> Provides very basic support for uprobes.
[...]
> @@ -162,6 +190,14 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
>  	bool need_dwarf = perf_probe_event_need_dwarf(pev);
>  	int fd, ntevs;
>  
> +	if (pev->upid) {
> +		if (need_dwarf) {
> +			pr_warning("Debuginfo-analysis is not supported.\n");

This should be "Debuginfo-analysis is not supported with -p/--pid option.\n"

> +			return -ENOSYS;
> +		}
> +		return convert_name_to_addr(pev);
> +	}
> +



And I found a small bug.

# ./perf probe -vf -p 3199 "setenv %ax"
probe-definition(0): setenv %ax
symbol:setenv file:(null) line:0 offset:0 return:0 lazy:(null)
parsing arg: %ax into %ax
1 arguments
Opening /debug/tracing/uprobe_events write=1
Add new event:
Writing event: p:probe_3199/setenv 3199:0x47e680
 %ax
Failed to write event: Invalid argument
  Error: Failed to add events. (-1)

# ./perf probe -l
  probe_3199:setenv    (on 3199:0x000000000047e680)

When writing an event, there is a "\n" right after probe point (3199:0x47e680\n)

> @@ -1066,10 +1213,22 @@ char *synthesize_probe_trace_command(struct probe_trace_event *tev)
>  	if (buf == NULL)
>  		return NULL;
>  
> -	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s+%lu",
> -			 tp->retprobe ? 'r' : 'p',
> -			 tev->group, tev->event,
> -			 tp->symbol, tp->offset);
> +	if (tev->upid)
> +		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %d:%s\n",

Here is a "\n".


Thank you,

-- 
Masami HIRAMATSU
2nd Research Dept.
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
