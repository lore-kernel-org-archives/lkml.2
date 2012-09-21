Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2IUDft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 23:35:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54842 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab2IUDfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 23:35:47 -0400
Message-ID: <505BDEF5.205@gmail.com>
Date: Thu, 20 Sep 2012 21:28:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH 2/4] perf tools: configure shell path at compile time
References: <1348179215-11160-1-git-send-email-irina.tirdea@gmail.com> <1348179215-11160-3-git-send-email-irina.tirdea@gmail.com>
In-Reply-To: <1348179215-11160-3-git-send-email-irina.tirdea@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/12 4:13 PM, Irina Tirdea wrote:
> From: Irina Tirdea <irina.tirdea@intel.com>
>
> Shell path /bin/sh is hardcoded in various places in perf. Android has a
> different folder structure and does not have /bin/sh.
>
> Set the shell path at compile time in the Makefile by setting PERF_SHELL_PATH.
> By default it is set to /bin/sh.

code change below uses PERF_SHELL_DIR; it's not a directory so 
PERF_SHELL_PATH per the above comment is better.

David


>
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> ---
>   tools/perf/Makefile         |    6 +++++-
>   tools/perf/builtin-help.c   |    2 +-
>   tools/perf/builtin-script.c |   12 ++++++------
>   3 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index eab4a36..9021a1f 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -828,7 +828,11 @@ $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFL
>   	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
>   		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
>   		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
> -		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
> +		'-DPERF_INFO_PATH="$(infodir_SQ)"' \
> +		'-DPERF_SHELL_DIR="/bin/sh"' $<
> +
> +$(OUTPUT)builtin-script.o: builtin-script.c $(OUTPUT)PERF-CFLAGS
> +	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) -DPERF_SHELL_DIR='"/bin/sh"' $<
>
>   $(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
>   	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
> diff --git a/tools/perf/builtin-help.c b/tools/perf/builtin-help.c
> index 25c8b94..a1d9703 100644
> --- a/tools/perf/builtin-help.c
> +++ b/tools/perf/builtin-help.c
> @@ -171,7 +171,7 @@ static void exec_man_cmd(const char *cmd, const char *page)
>   {
>   	struct strbuf shell_cmd = STRBUF_INIT;
>   	strbuf_addf(&shell_cmd, "%s %s", cmd, page);
> -	execl("/bin/sh", "sh", "-c", shell_cmd.buf, NULL);
> +	execl(PERF_SHELL_DIR, "sh", "-c", shell_cmd.buf, NULL);
>   	warning("failed to exec '%s': %s", cmd, strerror(errno));
>   }
>
> diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
> index 1be843a..4cc2c96 100644
> --- a/tools/perf/builtin-script.c
> +++ b/tools/perf/builtin-script.c
> @@ -1326,7 +1326,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>   				goto out;
>   			}
>
> -			__argv[j++] = "/bin/sh";
> +			__argv[j++] = PERF_SHELL_DIR;
>   			__argv[j++] = rec_script_path;
>   			if (system_wide)
>   				__argv[j++] = "-a";
> @@ -1337,7 +1337,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>   				__argv[j++] = argv[i];
>   			__argv[j++] = NULL;
>
> -			execvp("/bin/sh", (char **)__argv);
> +			execvp(PERF_SHELL_DIR, (char **)__argv);
>   			free(__argv);
>   			exit(-1);
>   		}
> @@ -1353,7 +1353,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>   		}
>
>   		j = 0;
> -		__argv[j++] = "/bin/sh";
> +		__argv[j++] = PERF_SHELL_DIR;
>   		__argv[j++] = rep_script_path;
>   		for (i = 1; i < rep_args + 1; i++)
>   			__argv[j++] = argv[i];
> @@ -1361,7 +1361,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>   		__argv[j++] = "-";
>   		__argv[j++] = NULL;
>
> -		execvp("/bin/sh", (char **)__argv);
> +		execvp(PERF_SHELL_DIR, (char **)__argv);
>   		free(__argv);
>   		exit(-1);
>   	}
> @@ -1390,7 +1390,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>   			goto out;
>   		}
>
> -		__argv[j++] = "/bin/sh";
> +		__argv[j++] = PERF_SHELL_DIR;
>   		__argv[j++] = script_path;
>   		if (system_wide)
>   			__argv[j++] = "-a";
> @@ -1398,7 +1398,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
>   			__argv[j++] = argv[i];
>   		__argv[j++] = NULL;
>
> -		execvp("/bin/sh", (char **)__argv);
> +		execvp(PERF_SHELL_DIR, (char **)__argv);
>   		free(__argv);
>   		exit(-1);
>   	}
>

