Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab2JPPS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:18:28 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:58735 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab2JPPS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:18:26 -0400
Date: Tue, 16 Oct 2012 08:18:17 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v4 1/6] perf tools: configure tmp path at build time
Message-ID: <20121016151817.GB6807@ghostprotocols.net>
References: <1350344020-8071-1-git-send-email-irina.tirdea@gmail.com>
 <1350344020-8071-2-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350344020-8071-2-git-send-email-irina.tirdea@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 16, 2012 at 02:33:35AM +0300, Irina Tirdea escreveu:
> From: Irina Tirdea <irina.tirdea@intel.com>
> 
> Temporary perf files are hardcoded to point to /tmp. Android does not have
> a /tmp directory so it needs to set this path at compile time.
> 
> Add a compile-time definition (PERF_TMP_DIR) in the Makefile that sets the path
> to temp directory. By default it points to /tmp.
>  
>  $(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
> -$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
> +$(OUTPUT)util/pmu.o: util/pmu.c $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
>  
>  LIB_FILE=$(OUTPUT)libperf.a
>  
> @@ -889,6 +892,21 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
>  $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<

Humm, so we need to add an specific rule for each source file that needs
PERF_TMP_DIR? Why not make it available to all source files?
  
> +$(OUTPUT)util/dso-test-data.o: util/dso-test-data.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
> +
> +$(OUTPUT)util/map.o: util/map.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
> +
> +$(OUTPUT)util/symbol.o: util/symbol.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
> +
> +$(OUTPUT)util/trace-event-info.o: util/trace-event-info.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
> +
> +$(OUTPUT)util/vdso.o: util/vdso.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_TMP_DIR='"$(PERF_TMP_DIR)"' $<
> +
>  $(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
>  	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DENABLE_SLFUTURE_CONST $<
>  
> diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
> index e919306..058c3b7 100644
> --- a/tools/perf/perf-archive.sh
> +++ b/tools/perf/perf-archive.sh
> @@ -18,7 +18,16 @@ else
>          PERF_BUILDID_DIR=$PERF_BUILDID_DIR/
>  fi
>  
> -BUILDIDS=$(mktemp /tmp/perf-archive-buildids.XXXXXX)
> +#
> +# PERF_TMP_DIR environment variable set by perf
> +# path to temp directory, default to /tmp
> +#
> +if [ -z $PERF_TMP_DIR ]; then
> +	PERF_TMP_DIR=/tmp
> +fi
> +
> +
> +BUILDIDS=$(mktemp $PERF_TMP_DIR/perf-archive-buildids.XXXXXX)
>  NOBUILDID=0000000000000000000000000000000000000000
>  
>  perf buildid-list -i $PERF_DATA --with-hits | grep -v "^$NOBUILDID " > $BUILDIDS
> @@ -28,7 +37,7 @@ if [ ! -s $BUILDIDS ] ; then
>  	exit 1
>  fi
>  
> -MANIFEST=$(mktemp /tmp/perf-archive-manifest.XXXXXX)
> +MANIFEST=$(mktemp $PERF_TMP_DIR/perf-archive-manifest.XXXXXX)
>  PERF_BUILDID_LINKDIR=$(readlink -f $PERF_BUILDID_DIR)/
>  
>  cut -d ' ' -f 1 $BUILDIDS | \
> diff --git a/tools/perf/util/dso-test-data.c b/tools/perf/util/dso-test-data.c
> index c6caede..ca81e65 100644
> --- a/tools/perf/util/dso-test-data.c
> +++ b/tools/perf/util/dso-test-data.c
> @@ -18,7 +18,7 @@ do { \
>  
>  static char *test_file(int size)
>  {
> -	static char buf_templ[] = "/tmp/test-XXXXXX";
> +	static char buf_templ[] = PERF_TMP_DIR "/test-XXXXXX";
>  	char *templ = buf_templ;
>  	int fd, i;
>  	unsigned char *buf;
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index 6109fa4..4e69b57 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -59,7 +59,8 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
>  		no_dso = is_no_dso_memory(filename);
>  
>  		if (anon) {
> -			snprintf(newfilename, sizeof(newfilename), "/tmp/perf-%d.map", pid);
> +			snprintf(newfilename, sizeof(newfilename),
> +				 PERF_TMP_DIR "/perf-%d.map", pid);
>  			filename = newfilename;
>  		}
>  
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 8a2229d..5ebde18 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -637,7 +637,7 @@ static char *test_format_dir_get(void)
>  	static char dir[PATH_MAX];
>  	unsigned int i;
>  
> -	snprintf(dir, PATH_MAX, "/tmp/perf-pmu-test-format-XXXXXX");
> +	snprintf(dir, PATH_MAX, PERF_TMP_DIR "/perf-pmu-test-format-XXXXXX");
>  	if (!mkdtemp(dir))
>  		return NULL;
>  
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index e2e8c69..d8aca82 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1051,7 +1051,9 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
>  
>  	dso->adjust_symbols = 0;
>  
> -	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
> +	if (strncmp
> +	    (dso->name, PERF_TMP_DIR "/perf-",
> +	     strlen(PERF_TMP_DIR "/perf-")) == 0) {
>  		struct stat st;
>  
>  		if (lstat(dso->name, &st) < 0)
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index a8d81c3..e50ea61 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -481,7 +481,7 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
>  		int temp_fd;
>  
>  		snprintf(tdata->temp_file, sizeof(tdata->temp_file),
> -			 "/tmp/perf-XXXXXX");
> +			 PERF_TMP_DIR "/perf-XXXXXX");
>  		if (!mkstemp(tdata->temp_file))
>  			die("Can't make temp file");
>  
> diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
> index e60951f..8b9613b 100644
> --- a/tools/perf/util/vdso.c
> +++ b/tools/perf/util/vdso.c
> @@ -14,7 +14,7 @@
>  #include "linux/string.h"
>  
>  static bool vdso_found;
> -static char vdso_file[] = "/tmp/perf-vdso.so-XXXXXX";
> +static char vdso_file[] = PERF_TMP_DIR "/perf-vdso.so-XXXXXX";
>  
>  static int find_vdso_map(void **start, void **end)
>  {
> -- 
> 1.7.9.5
