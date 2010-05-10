Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0EJR3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:29:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58661 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0EJR3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:29:07 -0400
Date: Mon, 10 May 2010 14:28:54 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       systemtap <systemtap@sources.redhat.com>,
       Roland McGrath <roland@redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip] perf probe: Don't compile CFI related code if
	elfutils is old
Message-ID: <20100510172854.GD30926@ghostprotocols.net>
References: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510171207.26029.97604.stgit@localhost6.localdomain6>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 10, 2010 at 01:12:07PM -0400, Masami Hiramatsu escreveu:
> Check elfutils version, and if it is old don't compile
> CFI analysis code. This allows to compile perf with
> old elfutils.

_ELFUTILS_PREREQ was introduced in:

commit fbc7245df72ce0142f0a21fa0f4f88c97278bf60
Author: Roland McGrath <roland@redhat.com>
Date:   Tue Dec 16 17:03:03 2008 -0800

Which was released in elfutils 0.138, guess this is coverage enough?
Richard, which version is in your machine?

- Arnaldo
 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Reported-by: Robert Richter <robert.richter@amd.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
>  tools/perf/util/probe-finder.c |    4 ++++
>  tools/perf/util/probe-finder.h |    3 +++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 562b144..93583eb 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -668,6 +668,7 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
>  	ret = dwarf_getlocation_addr(&fb_attr, pf->addr, &pf->fb_ops, &nops, 1);
>  	if (ret <= 0 || nops == 0) {
>  		pf->fb_ops = NULL;
> +#if _ELFUTILS_PREREQ(0, 142)
>  	} else if (nops == 1 && pf->fb_ops[0].atom == DW_OP_call_frame_cfa &&
>  		   pf->cfi != NULL) {
>  		Dwarf_Frame *frame;
> @@ -677,6 +678,7 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
>  				   (uintmax_t)pf->addr);
>  			return -ENOENT;
>  		}
> +#endif
>  	}
>  
>  	/* Find each argument */
> @@ -956,8 +958,10 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
>  		return -EBADF;
>  	}
>  
> +#if _ELFUTILS_PREREQ(0, 142)
>  	/* Get the call frame information from this dwarf */
>  	pf.cfi = dwarf_getcfi(dbg);
> +#endif
>  
>  	off = 0;
>  	line_list__init(&pf.lcache);
> diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
> index 66f1980..e1f61dc 100644
> --- a/tools/perf/util/probe-finder.h
> +++ b/tools/perf/util/probe-finder.h
> @@ -29,6 +29,7 @@ extern int find_line_range(int fd, struct line_range *lr);
>  
>  #include <dwarf.h>
>  #include <libdw.h>
> +#include <version.h>
>  
>  struct probe_finder {
>  	struct perf_probe_event	*pev;		/* Target probe event */
> @@ -44,7 +45,9 @@ struct probe_finder {
>  	struct list_head	lcache;		/* Line cache for lazy match */
>  
>  	/* For variable searching */
> +#if _ELFUTILS_PREREQ(0, 142)
>  	Dwarf_CFI		*cfi;		/* Call Frame Information */
> +#endif
>  	Dwarf_Op		*fb_ops;	/* Frame base attribute */
>  	struct perf_probe_arg	*pvar;		/* Current target variable */
>  	struct kprobe_trace_arg	*tvar;		/* Current result variable */
> 
> 
> -- 
> Masami Hiramatsu
> e-mail: mhiramat@redhat.com
