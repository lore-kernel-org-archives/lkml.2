Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab2JPP01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:26:27 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62754 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab2JPP0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:26:25 -0400
Date: Tue, 16 Oct 2012 08:26:19 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v4 4/6] perf tools: Try to find cross-built objdump path
Message-ID: <20121016152619.GE6807@ghostprotocols.net>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
 <1350344020-8071-5-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350344020-8071-5-git-send-email-irina.tirdea@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 16, 2012 at 02:33:38AM +0300, Irina Tirdea escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>

Well, by now it is not anymore from Namhyung, but based on a previous
patch by him, right?

I'm ok with the patch, thanks for addressing my suggestions, but please
resubmit with you as the patch author, giving credit for the original
patch by Namhyung.

Namhyung, are you ok with it? If so could I have a reviewed-by from you
or at least an acked-by? The SOB is to be dropped, as this is not coming
from you, but directly from Irina and as explained above, its a modified
patch.

- Arnaldo
 
> As we have architecture information of saved perf.data file, we can
> try to find cross-built objdump path.
> 
> The triplets include support for Android (arm, x86 and mips architectures).
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>  tools/perf/Makefile           |    2 +
>  tools/perf/arch/common.c      |  178 +++++++++++++++++++++++++++++++++++++++++
>  tools/perf/arch/common.h      |   10 +++
>  tools/perf/builtin-annotate.c |    7 ++
>  tools/perf/builtin-report.c   |    7 ++
>  tools/perf/util/annotate.h    |    1 -
>  6 files changed, 204 insertions(+), 1 deletion(-)
>  create mode 100644 tools/perf/arch/common.c
>  create mode 100644 tools/perf/arch/common.h
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 99bf383..5906adb 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -428,6 +428,8 @@ LIB_OBJS += $(OUTPUT)ui/helpline.o
>  LIB_OBJS += $(OUTPUT)ui/hist.o
>  LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
>  
> +LIB_OBJS += $(OUTPUT)arch/common.o
> +
>  BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
>  # Benchmark modules
> diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
> new file mode 100644
> index 0000000..2367b25
> --- /dev/null
> +++ b/tools/perf/arch/common.c
> @@ -0,0 +1,178 @@
> +#include <stdio.h>
> +#include <sys/utsname.h>
> +#include "common.h"
> +#include "../util/debug.h"
> +
> +const char *const arm_triplets[] = {
> +	"arm-eabi-",
> +	"arm-linux-androideabi-",
> +	"arm-unknown-linux-",
> +	"arm-unknown-linux-gnu-",
> +	"arm-unknown-linux-gnueabi-",
> +	NULL
> +};
> +
> +const char *const powerpc_triplets[] = {
> +	"powerpc-unknown-linux-gnu-",
> +	"powerpc64-unknown-linux-gnu-",
> +	NULL
> +};
> +
> +const char *const s390_triplets[] = {
> +	"s390-ibm-linux-",
> +	NULL
> +};
> +
> +const char *const sh_triplets[] = {
> +	"sh-unknown-linux-gnu-",
> +	"sh64-unknown-linux-gnu-",
> +	NULL
> +};
> +
> +const char *const sparc_triplets[] = {
> +	"sparc-unknown-linux-gnu-",
> +	"sparc64-unknown-linux-gnu-",
> +	NULL
> +};
> +
> +const char *const x86_triplets[] = {
> +	"x86_64-pc-linux-gnu-",
> +	"x86_64-unknown-linux-gnu-",
> +	"i686-pc-linux-gnu-",
> +	"i586-pc-linux-gnu-",
> +	"i486-pc-linux-gnu-",
> +	"i386-pc-linux-gnu-",
> +	"i686-linux-android-",
> +	"i686-android-linux-",
> +	NULL
> +};
> +
> +const char *const mips_triplets[] = {
> +	"mips-unknown-linux-gnu-",
> +	"mipsel-linux-android-",
> +	NULL
> +};
> +
> +static bool lookup_path(char *name)
> +{
> +	bool found = false;
> +	char *path, *tmp;
> +	char buf[PATH_MAX];
> +	char *env = getenv("PATH");
> +
> +	if (!env)
> +		return false;
> +
> +	env = strdup(env);
> +	if (!env)
> +		return false;
> +
> +	path = strtok_r(env, ":", &tmp);
> +	while (path) {
> +		scnprintf(buf, sizeof(buf), "%s/%s", path, name);
> +		if (access(buf, F_OK) == 0) {
> +			found = true;
> +			break;
> +		}
> +		path = strtok_r(NULL, ":", &tmp);
> +	}
> +	free(env);
> +	return found;
> +}
> +
> +static int lookup_triplets(const char *const *triplets, const char *name)
> +{
> +	int i;
> +	char buf[PATH_MAX];
> +
> +	for (i = 0; triplets[i] != NULL; i++) {
> +		scnprintf(buf, sizeof(buf), "%s%s", triplets[i], name);
> +		if (lookup_path(buf))
> +			return i;
> +	}
> +	return -1;
> +}
> +
> +static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
> +						  const char *name,
> +						  const char **path)
> +{
> +	int idx;
> +	char *arch, *cross_env;
> +	struct utsname uts;
> +	const char *const *path_list;
> +	char *buf = NULL;
> +
> +	if (uname(&uts) < 0)
> +		goto out;
> +
> +	/*
> +	 * We don't need to try to find objdump path for native system.
> +	 * Just use default binutils path (e.g.: "objdump").
> +	 */
> +	if (!strcmp(uts.machine, env->arch))
> +		goto out;
> +
> +	cross_env = getenv("CROSS_COMPILE");
> +	if (cross_env) {
> +		if (asprintf(&buf, "%s%s", cross_env, name) < 0)
> +			goto out_error;
> +		if (buf[0] == '/') {
> +			if (access(buf, F_OK) == 0)
> +				goto out;
> +			goto out_error;
> +		}
> +		if (lookup_path(buf))
> +			goto out;
> +		free(buf);
> +	}
> +
> +	arch = env->arch;
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
> +	else {
> +		ui__error("binutils for %s not supported.\n", arch);
> +		goto out_error;
> +	}
> +
> +	idx = lookup_triplets(path_list, name);
> +	if (idx < 0) {
> +		ui__error("Please install %s for %s.\n"
> +			  "You can add it to PATH, set CROSS_COMPILE or "
> +			  "override the default using --%s.\n",
> +			  name, arch, name);
> +		goto out_error;
> +	}
> +
> +	if (asprintf(&buf, "%s%s", path_list[idx], name) < 0)
> +		goto out_error;
> +
> +out:
> +	*path = buf;
> +	return 0;
> +out_error:
> +	free(buf);
> +	*path = NULL;
> +	return -1;
> +}
> +
> +int perf_session_env__lookup_objdump(struct perf_session_env *env)
> +{
> +	return perf_session_env__lookup_binutils_path(env, "objdump",
> +						      &objdump_path);
> +}
> diff --git a/tools/perf/arch/common.h b/tools/perf/arch/common.h
> new file mode 100644
> index 0000000..ede246e
> --- /dev/null
> +++ b/tools/perf/arch/common.h
> @@ -0,0 +1,10 @@
> +#ifndef ARCH_PERF_COMMON_H
> +#define ARCH_PERF_COMMON_H
> +
> +#include "../util/session.h"
> +
> +extern const char *objdump_path;
> +
> +int perf_session_env__lookup_objdump(struct perf_session_env *env);
> +
> +#endif /* ARCH_PERF_COMMON_H */
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index 10d6ca4..e4df5da 100644
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
> @@ -186,6 +187,12 @@ static int __cmd_annotate(struct perf_annotate *ann)
>  			goto out_delete;
>  	}
>  
> +	if (!objdump_path) {
> +		ret = perf_session_env__lookup_objdump(&session->header.env);
> +		if (ret)
> +			goto out_delete;
> +	}
> +
>  	ret = perf_session__process_events(session, &ann->tool);
>  	if (ret)
>  		goto out_delete;
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 3d30a9a..9c0fe68 100644
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
> @@ -675,6 +676,12 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
>  	has_br_stack = perf_header__has_feat(&session->header,
>  					     HEADER_BRANCH_STACK);
>  
> +	if (!objdump_path) {
> +		ret = perf_session_env__lookup_objdump(&session->header.env);
> +		if (ret)
> +			goto error;
> +	}
> +
>  	if (sort__branch_mode == -1 && has_br_stack)
>  		sort__branch_mode = 1;
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
