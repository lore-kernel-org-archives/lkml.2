Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab2JHVDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:03:22 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:49118 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2JHVDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:03:18 -0400
Date: Mon, 8 Oct 2012 14:03:12 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v3 6/8] perf tools: Try to find cross-built objdump path
Message-ID: <20121008210312.GI2631@ghostprotocols.net>
References: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
 <1349678613-7045-7-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349678613-7045-7-git-send-email-irina.tirdea@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 08, 2012 at 09:43:31AM +0300, Irina Tirdea escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> As we have architecture information of saved perf.data file, we can
> try to find cross-built objdump path.
> 
> The triplets include support for Android (arm, x86 and mips architectures).

perf_session is too high an abstraction for this, all the uses in this
function are of the kind:

	session->header.env.MEMBER

So why not rename it to:

   perf_session_env__lookup_binutils_path(struct perf_session_env *env, const char *name)

and then use just:

	env->arch, etc?

More comments below

> +static char *try_binutils_path(struct perf_session *session, const char *name)
> +{
> +	int idx;
> +	char *arch, *env;
> +	struct utsname uts;
> +	const char *const *path_list;
> +	char buf[PATH_MAX];
> +
> +	if (uname(&uts) < 0)
> +		return NULL;
> +
> +	/*
> +	 * We don't need to try to find objdump path for native system.
> +	 * Just use default "objdump".
> +	 */
> +	if (!strcmp(uts.machine, session->header.env.arch))
> +		return NULL;
> +
> +	env = getenv("CROSS_COMPILE");
> +	if (env) {
> +		scnprintf(buf, sizeof(buf), "%s%s", env, name);
> +		if (buf[0] == '/') {
> +			if (access(buf, F_OK) == 0)
> +				return strdup(buf);
> +
> +			return NULL;
> +		}
> +
> +		if (lookup_path(buf))
> +			return strdup(buf);
> +	}
> +
> +	arch = session->header.env.arch;
> +
> +	if (!strcmp(arch, "arm"))
> +		path_list = arm_triplets;
> +	else if (!strcmp(arch, "powerpc"))
> +		path_list = powerpc_triplets;
> +	else if (!strcmp(arch, "sh"))
> +		path_list = sh_triplets;
> +	else if (!strcmp(arch, "s390"))
> +		path_list = s390_triplets;
> +	else if (!strcmp(arch, "sparc"))
> +		path_list = sparc_triplets;
> +	else if (!strcmp(arch, "x86") || !strcmp(arch, "i386") ||
> +		 !strcmp(arch, "i486") || !strcmp(arch, "i586") ||
> +		 !strcmp(arch, "i686"))
> +		path_list = x86_triplets;
> +	else if (!strcmp(arch, "mips"))
> +		path_list = mips_triplets;
> +	else
> +		BUG_ON(1);
> +
> +	idx = lookup_triplets(path_list, name);
> +	if (idx < 0)
> +		return NULL;
> +
> +	scnprintf(buf, sizeof(buf), "%s%s", path_list[idx], name);
> +	return strdup(buf);

Please use instead:

	char *s;

	return asprintf(&s, "%s%s", path_list[idx], name) < 0 ? NULL : s;

Will produce the same result and is more compact.

> +}
> +
> +void try_objdump_path(struct perf_session *session)
> +{
> +	objdump_path = try_binutils_path(session, "objdump");
> +}
> diff --git a/tools/perf/arch/common.h b/tools/perf/arch/common.h
> new file mode 100644
> index 0000000..d88ecc3
> --- /dev/null
> +++ b/tools/perf/arch/common.h
> @@ -0,0 +1,10 @@
> +#ifndef ARCH_PERF_COMMON_H
> +#define ARCH_PERF_COMMON_H
> +
> +#include "session.h"
> +
> +extern const char *objdump_path;
> +
> +void try_objdump_path(struct perf_session *session);
> +
> +#endif /* ARCH_PERF_COMMON_H */
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 9ea3854..8d90ab5 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -28,6 +28,7 @@
>  #include "util/hist.h"
>  #include "util/session.h"
>  #include "util/tool.h"
> +#include "arch/common.h"
>  
>  #include <linux/bitmap.h>
>  
> @@ -186,6 +187,9 @@ static int __cmd_annotate(struct perf_annotate *ann)
>  			goto out_delete;
>  	}
>  
> +	if (!objdump_path)
> +		try_objdump_path(session);

Please do the test on perf_session_env__lookup_objdump() and handle
errors, i.e. what happens if that strdup/asprintf fails?

Ok, that is unlikely, but not impossible, but what happens if we don't
find the right objdump? Shouldn't we use ui__error("please install
required objdump" (or a better, more detailed message)?

> +
>  	ret = perf_session__process_events(session, &ann->tool);
>  	if (ret)
>  		goto out_delete;
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index a61725d..e1549bc 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -33,6 +33,7 @@
>  #include "util/thread.h"
>  #include "util/sort.h"
>  #include "util/hist.h"
> +#include "arch/common.h"
>  
>  #include <linux/bitmap.h>
>  
> diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
> index 39242dc..a4dd25a 100644
> --- a/tools/perf/util/annotate.h
> +++ b/tools/perf/util/annotate.h
> @@ -154,6 +154,5 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
>  #endif
>  
>  extern const char	*disassembler_style;
> -extern const char	*objdump_path;
>  
>  #endif	/* __PERF_ANNOTATE_H */
> -- 
> 1.7.9.5
