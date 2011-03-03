Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab1CCDU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:20:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48334 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756830Ab1CCDUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:20:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dprC1fePzFcajSFFJ9VzVEGAoZYAX8Pa/SOKEsR9f8gjZBAQwGM7tN3yFqPJ9+drGV
         gy1/cTg0PY5N6uaOBQGUQAflJVDS7tXZsulqBQ6nXQXjmFyTgbOdTOqAhSk8pZkvEEhS
         E+nhg+ATuZU1XpqozWZsFEVXH8JR6UDwYub+Y=
MIME-Version: 1.0
In-Reply-To: <1298082321-8519-1-git-send-email-asharma@fb.com>
References: <1298082321-8519-1-git-send-email-asharma@fb.com>
Date: Thu, 3 Mar 2011 11:20:54 +0800
Message-ID: <AANLkTimB4bO0d+Kumg_AYuxQUZuECfWN6MCP=_-6oWjc@mail.gmail.com>
Subject: Re: [PATCH] Add libpfm4 support (v2).
From: Lin Ming <minggr@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: acme@infradead.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        perfmon2-devel@lists.sourceforge.net, ming.m.lin@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add lkml and perfmon2-devel list)

On Sat, Feb 19, 2011 at 10:25 AM, Arun Sharma <asharma@fb.com> wrote:
> libpfm4 is a library that takes a CPU vendor documentation
> compatible string and fills out perf_event_attr. Typical
> use case: user wants to look at events other than the
> ones supported by perf using symbolic names.
>
> This version prints umasks as well and is compatible with the most recent
> version of libpfm4.

Interesting usage, I have a quick try with it.
See below for a small fix.

And the "perf list" output on my Westmere box.

Detected PMU:  ix86arch -- Intel X86 architectural PMU Total events: 6
  UNHALTED_CORE_CYCLES                       [Hardware event]
  INSTRUCTION_RETIRED                        [Hardware event]
  LLC_REFERENCES                             [Hardware event]
  LLC_MISSES                                 [Hardware event]
  BRANCH_INSTRUCTIONS_RETIRED                [Hardware event]
  MISPREDICTED_BRANCH_RETIRED                [Hardware event]

Detected PMU:  wsm -- Intel Westmere (single-socket) Total events: 91
  UNHALTED_CORE_CYCLES                       [Hardware event]
  INSTRUCTION_RETIRED                        [Hardware event]
  INSTRUCTIONS_RETIRED                       [Hardware event]
  UNHALTED_REFERENCE_CYCLES                  [Hardware event]
  LLC_REFERENCES                             [Hardware event]
  LAST_LEVEL_CACHE_REFERENCES                [Hardware event]
  LLC_MISSES                                 [Hardware event]
  LAST_LEVEL_CACHE_MISSES                    [Hardware event]
  BRANCH_INSTRUCTIONS_RETIRED                [Hardware event]

......

Detected PMU:  wsm_unc -- Intel Westmere uncore Total events: 52
  UNC_CLK_UNHALTED                           [Hardware event]
  UNC_DRAM_OPEN                              [Hardware event]
        :CH0
        :CH1
        :CH2
  UNC_GC_OCCUPANCY                           [Hardware event]
        :READ_TRACKER
  UNC_DRAM_PAGE_CLOSE                        [Hardware event]
        :CH0
        :CH1
        :CH2
  UNC_DRAM_PAGE_MISS                         [Hardware event]
        :CH0
        :CH1
        :CH2
  UNC_DRAM_PRE_ALL                           [Hardware event]
        :CH0
        :CH1
        :CH2
  UNC_DRAM_THERMAL_THROTTLED                 [Hardware event]
  UNC_DRAM_READ_CAS                          [Hardware event]

....


>
> Signed-off-by: Arun Sharma <asharma@fb.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> ---
>  tools/perf/Makefile            |   13 +++++
>  tools/perf/feature-tests.mak   |   11 ++++
>  tools/perf/perf.c              |    6 ++
>  tools/perf/util/parse-events.c |  108 ++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/parse-events.h |    3 +
>  5 files changed, 141 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 9b84218..617db4a 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -451,6 +451,19 @@ else
>        endif
>  endif
>
> +ifdef NO_LIBPFM4
> +       BASIC_CFLAGS += -DNO_LIBPFM4_SUPPORT
> +else
> +       FLAGS_LIBPFM4=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -lpfm
> +       ifneq ($(call try-cc,$(SOURCE_LIBPFM4),$(FLAGS_LIBPFM4)),y)
> +               msg := $(warning libpfm4 not found, events restricted to generic ones. Please install libpfm4-devel or libpfm4-dev);
> +               BASIC_CFLAGS += -DNO_LIBPFM4_SUPPORT
> +       else
> +               BASIC_CFLAGS += -DLIBPFM4
> +               EXTLIBS += -lpfm
> +       endif
> +endif
> +
>  ifdef NO_LIBPERL
>        BASIC_CFLAGS += -DNO_LIBPERL
>  else
> diff --git a/tools/perf/feature-tests.mak b/tools/perf/feature-tests.mak
> index b041ca6..ec6b27b 100644
> --- a/tools/perf/feature-tests.mak
> +++ b/tools/perf/feature-tests.mak
> @@ -121,6 +121,17 @@ int main(void)
>  }
>  endef
>
> +ifndef NO_LIBPFM4
> +define SOURCE_LIBPFM4
> +#include <perfmon/pfmlib_perf_event.h>
> +
> +int main(void)
> +{
> +       return pfm_initialize();
> +}
> +endef
> +endif
> +
>  # try-cc
>  # Usage: option = $(call try-cc, source-to-build, cc-options)
>  try-cc = $(shell sh -c                                           \
> diff --git a/tools/perf/perf.c b/tools/perf/perf.c
> index 595d0f4..a847afb 100644
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -472,6 +472,12 @@ int main(int argc, const char **argv)
>        }
>        cmd = argv[0];
>
> +#ifdef LIBPFM4
> +       if (pfm_initialize() != PFM_SUCCESS) {
> +               fprintf(stderr, "pfm_initialize failed\n");
> +               return 1;
> +       }
> +#endif
>        /*
>         * We use PATH to find perf commands, but we prepend some higher
>         * precedence paths: the "--exec-path" option, the PERF_EXEC_PATH
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index 54a7e26..a7e5765 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -696,6 +696,47 @@ parse_numeric_event(const char **strp, struct perf_event_attr *attr)
>        return EVT_FAILED;
>  }
>
> +#ifdef LIBPFM4
> +static enum event_result
> +parse_libpfm4_event(const char **strp, struct perf_event_attr *attr)
> +{
> +       int ret;
> +       const char *str = *strp;
> +       const char *comma_loc = NULL;
> +       char *evt_name = NULL;
> +       size_t len = 0;
> +
> +       comma_loc = strchr(str, ',');
> +       if (comma_loc) {
> +               /* take the event name up to the comma */
> +               len = comma_loc - str;
> +               evt_name = strndup(str, len+1);
> +               if (evt_name == NULL) {
> +                       pr_err("strndup returned NULL. Out of memory?");
> +                       return EVT_FAILED;
> +               }
> +               evt_name[len] = '\0';
> +       } else {
> +               evt_name = (char *) *strp;
> +       }
> +
> +       ret = pfm_get_perf_event_encoding(evt_name, PFM_PLM0|PFM_PLM3, attr,
> +                                         NULL, NULL);
> +       if (ret != PFM_SUCCESS) {
> +               return EVT_FAILED;
> +       }
> +
> +       if (comma_loc) {
> +               *strp += len;
> +               free(evt_name);
> +       } else {
> +               *strp += strlen(evt_name);
> +       }
> +
> +       return EVT_HANDLED;
> +}
> +#endif
> +
>  static enum event_result
>  parse_event_modifier(const char **strp, struct perf_event_attr *attr)
>  {
> @@ -762,6 +803,17 @@ parse_event_symbols(const struct option *opt, const char **str,
>        if (ret != EVT_FAILED)
>                goto modifier;
>
> +#ifdef LIBPFM4
> +       /*
> +        * Handle libpfm4 before generic_hw events.
> +        * Some events (eg: LLC_MISSES) fail otherwise.
> +        */
> +       ret = parse_libpfm4_event(str, attr);
> +       if (ret != EVT_FAILED)
> +               /* libpfm4 has its own modifier parsing code */
> +               goto modifier;
> +#endif
> +
>        ret = parse_generic_hw_event(str, attr);
>        if (ret != EVT_FAILED)
>                goto modifier;
> @@ -987,6 +1039,22 @@ int print_hwcache_events(const char *event_glob)
>        return printed;
>  }
>
> +#ifdef LIBPFM4
> +static void print_umasks(pfm_event_info_t *info)
> +{
> +       int i, ret;
> +       pfm_event_attr_info_t ainfo;
> +
> +       pfm_for_each_event_attr(i, info) {
> +               ret = pfm_get_event_attr_info(info->idx, i,
> +                                             PFM_OS_PERF_EVENT_EXT, &ainfo);
> +               if ((ret != PFM_SUCCESS) || (ainfo.type != PFM_ATTR_UMASK))
> +                       continue;
> +               printf("  \t:%-42s\n", ainfo.name);
> +       }
> +}
> +#endif
> +
>  /*
>  * Print the help text for the event symbols:
>  */
> @@ -1033,6 +1101,46 @@ void print_events(const char *event_glob)
>        if (event_glob != NULL)
>                return;
>
> +#ifdef LIBPFM4
> +       printf("\n");
> +       pfm_for_all_pmus(i) {
> +               int ret;
> +               pfm_pmu_info_t pinfo;
> +               int count;
> +               int k;
> +

Need to initialize pinfo before passing it to pfm_get_pmu_info
+               memset(&pinfo, 0, sizeof(pinfo));

> +               ret = pfm_get_pmu_info(i, &pinfo);
> +               if (ret != PFM_SUCCESS)
> +                       continue;
> +               if (!pinfo.is_present)
> +                       continue;
> +               if (pinfo.pmu == PFM_PMU_PERF_EVENT)
> +                       continue;
> +
> +               printf("\nDetected PMU:  %s -- %s Total events: %d\n",
> +                       pinfo.name,
> +                       pinfo.desc,
> +                       pinfo.nevents);
> +
> +               count = 0;
> +               for (k = pinfo.first_event; k != -1; k = pfm_get_event_next(k)) {
> +                       pfm_event_info_t info;
> +
> +                       ret = pfm_get_event_info(k, PFM_OS_PERF_EVENT_EXT, &info);
> +                       if (info.pmu != pinfo.pmu)
> +                               continue;
> +
> +                       count++;
> +                       if (count > pinfo.nevents)
> +                               break;
> +                       printf("  %-42s [%s]\n",
> +                               info.name,
> +                               event_type_descriptors[PERF_TYPE_HARDWARE]);
> +                       print_umasks(&info);
> +               }
> +       }
> +#endif
> +
>        printf("\n");
>        printf("  %-42s [%s]\n",
>                "rNNN (see 'perf list --help' on how to encode it)",
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
> index 212f88e..89c153c 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -5,6 +5,9 @@
>  */
>
>  #include "../../../include/linux/perf_event.h"
> +#ifdef LIBPFM4
> +#include <perfmon/pfmlib_perf_event.h>
> +#endif
>
>  struct list_head;
>  struct perf_evsel;
> --
> 1.7.4
>
>
