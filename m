Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0GLQEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:04:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42277 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327Ab0GLQES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:04:18 -0400
Date: Mon, 12 Jul 2010 21:25:31 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 12/13]  [RFC] perf: Show Potential
 probe points.
Message-ID: <20100712155531.GC23776@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103432.27491.61687.sendpatchset@localhost6.localdomain6>
 <20100712144144.GD25238@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100712144144.GD25238@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> What if strlist__new() fails?
> 

 Okay will add a check. 

> 

> Humm, here I think perhaps we should try to do as the kernel and
> introduce some form of:
> 
> map_groups__for_each_map(self, pos)
> 
> Like we have for list_for_each_entry, strlist__for_each, for_each_lang,
> for_each_script, etc.
> 
> Matter of coding style, following the culture of the kernel is a goal
> for these tools, to encourage kernel hackers to contribute to these
> tools.

Okay. 

> 
> 
> Also here please follow the style of the other routines that print
> entries, i.e.:
> 
> size_t dso__fprintf_symbols(self, type, fp)
> 
> like this:
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 971d0a0..85fe580 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -370,9 +370,21 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
>  	return fprintf(fp, "%s", sbuild_id);
>  }
> 
> -size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
> +size_t dso__fprintf_symbols(struct dso *self, enum map_type type, FILE *fp)
>  {
> +	size_t ret = 0;
>  	struct rb_node *nd;
> +
> +	for (nd = rb_first(&self->symbols[type]); nd; nd = rb_next(nd)) {
> +		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
> +		ret += symbol__fprintf(pos, fp);
> +	}
> +
> +	return ret;
> +}
> +
> +size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
> +{
>  	size_t ret = fprintf(fp, "dso: %s (", self->short_name);
> 
>  	if (self->short_name != self->long_name)
> @@ -381,12 +393,8 @@ size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
>  		       self->loaded ? "" : "NOT ");
>  	ret += dso__fprintf_buildid(self, fp);
>  	ret += fprintf(fp, ")\n");
> -	for (nd = rb_first(&self->symbols[type]); nd; nd = rb_next(nd)) {
> -		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
> -		ret += symbol__fprintf(pos, fp);
> -	}
> 
> -	return ret;
> +	return ret + dso__fprintf_symbols(self, type, fp);
>  }
> 
>  int kallsyms__parse(const char *filename, void *arg,
> diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
> index 261a3e3..714d286 100644
> --- a/tools/perf/util/symbol.h
> +++ b/tools/perf/util/symbol.h
> @@ -177,6 +177,7 @@ size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
>  size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
> 
>  size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
> +size_t dso__fprintf_symbols(struct dso *self, enum map_type type, FILE *fp);
>  size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
> 
>  enum dso_origin {
> 
> ------------------------------------
> 
> This way we reduce the resulting code size while following the existing
> style.

Okay.
