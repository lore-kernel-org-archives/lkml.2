Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0LUSbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:31:41 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:64701 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0LUSbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:31:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vS4JjzOJt4/4NLpsiDkVg+QPEvfuJ6x7XMua7Zc7b19QEfXgSwxZaN+6/w4yStIbgq
         Ds4Hy9vWX96UWtraY6cTny3dcek4ej4r7az8ukj0XO7m7BKwKC+I7n//e+fj4rX+o1dI
         8vxrjbmFXhzgQo/mme+xmMVazmHcvSNpteBEc=
Date: Tue, 21 Dec 2010 19:31:34 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH -tip v2 2/6] perf bts: Introduce new sub command 'perf
 bts trace'
Message-ID: <20101221183131.GO1750@nowhere>
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
 <20101221090549.8552.26257.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101221090549.8552.26257.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eOn Tue, Dec 21, 2010 at 06:05:49PM +0900, Akihiro Nagai wrote:
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
> Changes in V2:
>  - Update to the latest -tip tree
> 
> Signed-off-by: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
> ---
> 
>  tools/perf/Documentation/perf-bts.txt |   14 ++++++--
>  tools/perf/builtin-bts.c              |   56 +++++++++++++++++++++++++++++++--
>  2 files changed, 64 insertions(+), 6 deletions(-)
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
> index 587cfad..0d546d8 100644
> --- a/tools/perf/builtin-bts.c
> +++ b/tools/perf/builtin-bts.c
> @@ -1,10 +1,26 @@
>  #include "builtin.h"
>  #include "perf.h"
>  #include "util/parse-options.h"
> +#include "util/session.h"
> +#include "util/cache.h"
> +#include "util/trace-event.h"
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
> @@ -16,11 +32,41 @@ static const char * const record_args[] = {
>  	"-d",
>  };
>  
> -/* dummy struct option to call parse_options() */
>  static const struct option bts_options[] = {
> +	OPT_STRING('i', "input", &input_name, "file", "input file name"),
>  	OPT_END()
>  };
>  
> +static int process_sample_event(event_t *event __unused,
> +	struct sample_data *sample, struct perf_session *session __unused)
> +{
> +	/* sample->ip is 'from address', sample->addr is 'to address' */
> +	printf(FMT_ADDR " => " FMT_ADDR "\n", sample->ip, sample->addr);

It seems this unconditionally prints out the event, but a sample
event can be about anything. If you recorded only branches it's fine,
but if there were other events this will mess up.

Well, when you launch the tool you can iterate into the session->header.attr
and check if there is something else than a branch perf event. And then emit
a warning if so.

That doesn't solve the problem but the user will know there is one.

Actually the best would be to select PERF_SAMPLE_ID in the sample_type
on record and also PERF_FORMAT_ID in the read_format.

Then you can find the PERF_SAMPLE_ID that matches your event. If we
record that in the perf headers we can retrieve which events id are the
branch ones.

But well, that's a secondary problem for now.
