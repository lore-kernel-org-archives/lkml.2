Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2DWGbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:31:13 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58485 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2DWGbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:31:12 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-3f-4f94f72d6f61
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/13] perf annotate: Parse instruction
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
	<1334867644-2722-3-git-send-email-acme@infradead.org>
Date: Mon, 23 Apr 2012 15:30:27 +0900
In-Reply-To: <1334867644-2722-3-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Thu, 19 Apr 2012 17:33:57 -0300")
Message-ID: <87ty0b3qpo.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 19 Apr 2012 17:33:57 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> For lines with instructions find the name and operands, breaking those
> tokens for consumption by the browser.
>

Just a minor nit below...


> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-6aazb9f5o3d9zi28e6rruv12@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/annotate.c |   65 +++++++++++++++++++++++++++++++++++++++++++-
>  tools/perf/util/annotate.h |    3 ++
>  2 files changed, 67 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index ef1d57d..a72585a 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -80,16 +80,50 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
>  
>  static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privsize)
>  {
> -	struct disasm_line *dl = malloc(sizeof(*dl) + privsize);
> +	struct disasm_line *dl = zalloc(sizeof(*dl) + privsize);
>  
>  	if (dl != NULL) {
>  		dl->offset = offset;
>  		dl->line = strdup(line);
>  		if (dl->line == NULL)
>  			goto out_delete;
> +
> +		if (offset != -1) {

To avoid deep nesting, how about this:

	if (dl == NULL)
		return NULL;

	<snip>

	if (offset == -1)
		return dl;

Thanks,
Namhyung


> +			char *name = dl->line, tmp;
> +
> +			while (isspace(name[0]))
> +				++name;
> +
> +			if (name[0] == '\0')
> +				goto out_delete;
> +
> +			dl->operands = name + 1;
> +
> +			while (dl->operands[0] != '\0' &&
> +			       !isspace(dl->operands[0]))
> +				++dl->operands;
> +
> +			tmp = dl->operands[0];
> +			dl->operands[0] = '\0';
> +			dl->name = strdup(name);
> +
> +			if (dl->name == NULL)
> +				goto out_free_line;
> +
> +			dl->operands[0] = tmp;
> +
> +			if (dl->operands[0] != '\0') {
> +				dl->operands++;
> +				while (isspace(dl->operands[0]))
> +					++dl->operands;
> +			}
> +		}
>  	}
>  
>  	return dl;
> +
> +out_free_line:
> +	free(dl->line);
>  out_delete:
>  	free(dl);
>  	return NULL;
> @@ -98,6 +132,7 @@ out_delete:
>  void disasm_line__free(struct disasm_line *dl)
>  {
>  	free(dl->line);
> +	free(dl->name);
>  	free(dl);
>  }
>  
> @@ -591,6 +626,34 @@ void disasm__purge(struct list_head *head)
>  	}
>  }
>  
> +static size_t disasm_line__fprintf(struct disasm_line *dl, FILE *fp)
> +{
> +	size_t printed;
> +
> +	if (dl->offset == -1)
> +		return fprintf(fp, "%s\n", dl->line);
> +
> +	printed = fprintf(fp, "%#" PRIx64 " %s", dl->offset, dl->name);
> +
> +	if (dl->operands[0] != '\0') {
> +		printed += fprintf(fp, "%.*s %s\n", 6 - (int)printed, " ",
> +				   dl->operands);
> +	}
> +
> +	return printed + fprintf(fp, "\n");
> +}
> +
> +size_t disasm__fprintf(struct list_head *head, FILE *fp)
> +{
> +	struct disasm_line *pos;
> +	size_t printed = 0;
> +
> +	list_for_each_entry(pos, head, node)
> +		printed += disasm_line__fprintf(pos, fp);
> +
> +	return printed;
> +}
> +
>  int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
>  			 bool print_lines, bool full_paths, int min_pcnt,
>  			 int max_lines)
> diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
> index 8bb68bb..dd7636d 100644
> --- a/tools/perf/util/annotate.h
> +++ b/tools/perf/util/annotate.h
> @@ -11,10 +11,13 @@ struct disasm_line {
>  	struct list_head node;
>  	s64		 offset;
>  	char		 *line;
> +	char		 *name;
> +	char		 *operands;
>  };
>  
>  void disasm_line__free(struct disasm_line *dl);
>  struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disasm_line *pos);
> +size_t disasm__fprintf(struct list_head *head, FILE *fp);
>  
>  struct sym_hist {
>  	u64		sum;
