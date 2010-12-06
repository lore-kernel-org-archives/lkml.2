Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab0LFDKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 22:10:45 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51956 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0LFDKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 22:10:44 -0500
X-AuditID: b753bd60-a44fbba000000f8d-05-4cfc54318cc1
Message-ID: <4CFC542C.1000603@hitachi.com>
Date: Mon, 06 Dec 2010 12:10:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip 3/7] perf bts: Introduce new sub command 'perf bts
 trace'
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6> <20101203035913.7827.85214.stgit@localhost6.localdomain6>
In-Reply-To: <20101203035913.7827.85214.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/03 12:59), Akihiro Nagai wrote:
> Introduce new sub command 'perf bts trace'.
> This command can parse and print bts log recorded by
> 'perf bts record'.
> 
> Usage:
>  - First, record the bts log 'perf bts record <command>'
>  - Second, parse and print bts log 'perf bts trace'
> 
> Output:
> 0xffffffff8146fe0e => 0x0000003806200b20
> 0x0000003806200b23 => 0x0000003806204910
> 0xffffffff8146fe0e => 0x0000003806204910
> 0xffffffff8146fe0e => 0x0000003806204936
> 0xffffffff8146fe0e => 0x000000380620493d
> 0x0000003806204981 => 0x00000038062049a3
> 0x00000038062049a7 => 0x0000003806204988
> ...
> 
> Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>

It looks a good step.

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  tools/perf/Documentation/perf-bts.txt |   14 ++++++--
>  tools/perf/builtin-bts.c              |   59 +++++++++++++++++++++++++++++++--
>  2 files changed, 67 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/Documentation/perf-bts.txt b/tools/perf/Documentation/perf-bts.txt
> index 55a2fe6..5920dcc 100644
> --- a/tools/perf/Documentation/perf-bts.txt
> +++ b/tools/perf/Documentation/perf-bts.txt
> @@ -3,22 +3,30 @@ perf-bts(1)
>  
>  NAME
>  ----
> -perf-bts - Record branch-trace-store log
> +perf-bts - Record and print branch-trace-store log
>  
>  SYNOPSIS
>  --------
>  [verse]
> -'perf bts' record <command>
> +'perf bts' [<options>] {record|trace}
>  
>  DESCRIPTION
>  -----------
> -This command can record branch-trace-store log.
> +This command can record and print branch-trace-store log.
>  Branch-trace-store is a facility of processors. It can record
>  address of branch to/from on every branch instruction and interrupt.
>  
>  'perf bts record <command>' records branch-trace-store log while specified
>  command is executing. And, save to the file "perf.data".
>  
> +'perf bts trace' parses recorded branch-trace-store log and prints it.
> +
> +OPTIONS
> +-------
> +-i::
> +--input=::
> +        Specify input file name to analyze.
> +
>  SEE ALSO
>  --------
>  linkperf:perf-record[1]
> diff --git a/tools/perf/builtin-bts.c b/tools/perf/builtin-bts.c
> index 587cfad..54e83af 100644
> --- a/tools/perf/builtin-bts.c
> +++ b/tools/perf/builtin-bts.c
> @@ -1,10 +1,25 @@
>  #include "builtin.h"
>  #include "perf.h"
>  #include "util/parse-options.h"
> +#include "util/session.h"
> +#include "util/cache.h"
> +#include <inttypes.h>
> +
> +/* format string of specifying min width to print address */
> +#if __WORDSIZE == 32
> +#define FMT_ADDR_WIDTH	"10"		/* length of "0x" + 32bit address */
> +#else
> +#define FMT_ADDR_WIDTH	"18"		/* length of "0x" + 64bit address */
> +#endif
> +/* format string to print address */
> +#define FMT_ADDR	"%#0" FMT_ADDR_WIDTH "llx"
> +
> +/* default input file name to analyze */
> +static const char *input_name = "perf.data";
>  
>  static const char * const bts_usage[] = {
> -	"perf bts record <command>",
> -	NULL,
> +	"perf bts [<options>] {record|trace}",
> +	NULL
>  };
>  
>  /* arguments to call 'perf record' */
> @@ -16,11 +31,45 @@ static const char * const record_args[] = {
>  	"-d",
>  };
>  
> -/* dummy struct option to call parse_options() */
>  static const struct option bts_options[] = {
> +	OPT_STRING('i', "input", &input_name, "file", "input file name"),
>  	OPT_END()
>  };
>  
> +static int process_sample_event(event_t *event, struct perf_session *session)
> +{
> +	struct sample_data data;
> +
> +	memset(&data, 0, sizeof(data));
> +	event__parse_sample(event, session->sample_type, &data);
> +
> +	/* data.ip is 'from address', data.addr is 'to address' */
> +	printf(FMT_ADDR " => " FMT_ADDR "\n", data.ip, data.addr);
> +
> +	return 0;
> +}
> +
> +static struct perf_event_ops event_ops = {
> +	.sample			= process_sample_event,
> +	.ordered_samples	= false,
> +};
> +
> +static int __cmd_trace(void)
> +{
> +	struct perf_session *session;
> +
> +	session = perf_session__new(input_name, O_RDONLY, 0, false);
> +	if (!session) {
> +		fprintf(stderr, "failed to create perf_session.\n");
> +		return -ENOMEM;
> +	}
> +
> +	perf_session__process_events(session, &event_ops);
> +	perf_session__delete(session);
> +
> +	return 0;
> +}
> +
>  static int __cmd_record(int argc, const char **argv)
>  {
>  	unsigned int rec_argc, i, j;
> @@ -55,6 +104,10 @@ int cmd_bts(int argc, const char **argv, const char *prefix __used)
>  
>  	if (!strncmp(argv[0], "record", 6))
>  		return __cmd_record(argc, argv);
> +	else if (!strncmp(argv[0], "trace", 5)) {
> +		setup_pager();
> +		return __cmd_trace();
> +	}
>  	else
>  		usage_with_options(bts_usage, bts_options);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
