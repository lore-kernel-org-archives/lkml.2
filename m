Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab2DSX4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 19:56:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47125 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2DSX4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 19:56:04 -0400
Message-ID: <4F90A60D.6090701@gmail.com>
Date: Thu, 19 Apr 2012 17:55:57 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 02/13] perf annotate: Parse instruction
References: <1334867644-2722-1-git-send-email-acme@infradead.org> <1334867644-2722-3-git-send-email-acme@infradead.org>
In-Reply-To: <1334867644-2722-3-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/19/12 2:33 PM, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo<acme@redhat.com>
>
> For lines with instructions find the name and operands, breaking those
> tokens for consumption by the browser.
>
> Cc: David Ahern<dsahern@gmail.com>
> Cc: Frederic Weisbecker<fweisbec@gmail.com>
> Cc: Mike Galbraith<efault@gmx.de>
> Cc: Namhyung Kim<namhyung@gmail.com>
> Cc: Paul Mackerras<paulus@samba.org>
> Cc: Peter Zijlstra<peterz@infradead.org>
> Cc: Stephane Eranian<eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-6aazb9f5o3d9zi28e6rruv12@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo<acme@redhat.com>
> ---
>   tools/perf/util/annotate.c |   65 +++++++++++++++++++++++++++++++++++++++++++-
>   tools/perf/util/annotate.h |    3 ++
>   2 files changed, 67 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
> index ef1d57d..a72585a 100644
> --- a/tools/perf/util/annotate.c
> +++ b/tools/perf/util/annotate.c
> @@ -80,16 +80,50 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
>
>   static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privsize)
>   {
> -	struct disasm_line *dl = malloc(sizeof(*dl) + privsize);
> +	struct disasm_line *dl = zalloc(sizeof(*dl) + privsize);
>
>   	if (dl != NULL) {
>   		dl->offset = offset;
>   		dl->line = strdup(line);
>   		if (dl->line == NULL)
>   			goto out_delete;
> +
> +		if (offset != -1) {
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
> +			while (dl->operands[0] != '\0'&&
> +			       !isspace(dl->operands[0]))
> +				++dl->operands;
> +
> +			tmp = dl->operands[0];
> +			dl->operands[0] = '\0';
> +			dl->name = strdup(name);

This strdup seems unnecessary. The parsing seems to be:

dl->line = "\W*name\W*operands"
    dl->name = -^    ^- = dl_operands

so name and operands are 2 different parts of the same buffer.

David
