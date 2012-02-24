Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab2BXKci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:32:38 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46477 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab2BXKcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:32:36 -0500
X-AuditID: b753bd60-9fe84ba000000655-84-4f476741e6b2
X-AuditID: b753bd60-9fe84ba000000655-84-4f476741e6b2
Message-ID: <4F47673B.6000103@hitachi.com>
Date: Fri, 24 Feb 2012 19:32:27 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: ananth@in.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        jbaron@redhat.com, rostedt@goodmis.org, srikar@linux.vnet.ibm.com
Subject: Re: [PATCH] perf - ensure offset provided during probe addition is
 not greater than function length
References: <4F45FABE.90104@linux.vnet.ibm.com> <4F473F33.4060409@linux.vnet.ibm.com>
In-Reply-To: <4F473F33.4060409@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/24 16:41), Prashanth Nageshappa wrote:
> perf probe allows kprobe to be inserted at any offset from a function
> start, which results in adding kprobes to unintended location.
> (example: perf probe do_fork+10000 is allowed even though size of
> do_fork is ~904)
> 
> This patch will ensure probe addition fails when the offset specified
> is greater than size of the function.
> 
> 
> Signed-off-by: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>

This seems good to me.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you,

> ---
> 
>  tools/perf/util/probe-finder.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 5d73262..d298f94 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -672,7 +672,7 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
>  static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
>  				  bool retprobe, struct probe_trace_point *tp)
>  {
> -	Dwarf_Addr eaddr;
> +	Dwarf_Addr eaddr, highaddr;
>  	const char *name;
> 
>  	/* Copy the name of probe point */
> @@ -683,6 +683,16 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
>  				   dwarf_diename(sp_die));
>  			return -ENOENT;
>  		}
> +		if (dwarf_highpc(sp_die, &highaddr) != 0) {
> +			pr_warning("Failed to get end address of %s\n",
> +				   dwarf_diename(sp_die));
> +			return -ENOENT;
> +		}
> +		if (paddr > highaddr) {
> +			pr_warning("Offset specified is greater than size of %s\n",
> +				   dwarf_diename(sp_die));
> +			return -EINVAL;
> +		}
>  		tp->symbol = strdup(name);
>  		if (tp->symbol == NULL)
>  			return -ENOMEM;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
