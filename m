Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab2BXA6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:58:10 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54854 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab2BXA6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:58:08 -0500
X-AuditID: 9c930197-b7cdbae000001518-6c-4f46e09e72ef
Message-ID: <4F46E09C.2060403@lge.com>
Date: Fri, 24 Feb 2012 09:58:04 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Pekka Enberg <penberg@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] perf report: Add a simple GTK2-based 'perf report' browser
References: <1330013922-3332-1-git-send-email-penberg@kernel.org> <20120223162850.GC25177@infradead.org> <CAOJsxLG2c=Mc-Rn56jmB290LtHpRY8pkfyqPrizgwE8_8+uxFQ@mail.gmail.com> <20120223163938.GD25177@infradead.org> <1330015504.13624.84.camel@jaguar> <20120223164739.GF25177@infradead.org> <20120223165302.GG25177@infradead.org> <CAOJsxLGP97smBEshzMY1vKMbSiK-mP1+dK8czuFM3girq-KS+A@mail.gmail.com> <20120223173743.GH25177@infradead.org> <alpine.LFD.2.02.1202231952410.6689@tux.localdomain>
In-Reply-To: <alpine.LFD.2.02.1202231952410.6689@tux.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-02-24 2:52 AM, Pekka Enberg wrote:
> From 3dc75243a43212fe907fad4139087f4033c2bf53 Mon Sep 17 00:00:00 2001
> From: Pekka Enberg<penberg@kernel.org>
> Date: Thu, 23 Feb 2012 17:49:18 +0200
> Subject: [PATCH] perf report: Add a simple GTK2-based 'perf report' browser
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> This patch adds a simple GTK2-based browser to 'perf report' that's based on
> the TTY-based browser in builtin-report.c.
>
> Please not that you need to use
>
>    make WERROR=0
>
> to build perf on Fedora 15 (and possibly other distributions) because GTK
> headers do not compile cleanly:
>
>        CC util/gtk/browser.o
>    In file included from /usr/include/gtk-2.0/gtk/gtk.h:234:0,
>                     from util/gtk/browser.c:7:
>    /usr/include/gtk-2.0/gtk/gtkitemfactory.h:47:1: warning: function declaration isn’t a prototype [-Wstrict-prototypes]
>
> To launch "perf report" using the new GTK interface just type:
>
>    ./perf report --gtk
>
> The interface is somewhat limited in features at the moment:
>
>    - No callgraph support
>
>    - No KVM guest profiling support
>
>    - No color coding for percentages
>
>    - No sorting from the UI
>
>    - ..and many, many more!
>
> That said, I think this patch a reasonable start to build future features on.
>

Looks like a nice patch! Few minor nits below.


> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras<paulus@samba.org>
> Cc: Ingo Molnar<mingo@elte.hu>
> Cc: Arnaldo Carvalho de Melo<acme@ghostprotocols.net>
> Signed-off-by: Pekka Enberg<penberg@kernel.org>
> ---
>   tools/perf/Documentation/perf-report.txt |    2 +
>   tools/perf/Makefile                      |   14 +++
>   tools/perf/builtin-report.c              |   23 +++-
>   tools/perf/config/feature-tests.mak      |   13 ++
>   tools/perf/util/cache.h                  |   12 ++
>   tools/perf/util/gtk/browser.c            |  189 ++++++++++++++++++++++++++++++
>   tools/perf/util/hist.h                   |   17 +++
>   7 files changed, 264 insertions(+), 6 deletions(-)
>   create mode 100644 tools/perf/util/gtk/browser.c
>
> diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
> index 9b430e9..9654f27 100644
> --- a/tools/perf/Documentation/perf-report.txt
> +++ b/tools/perf/Documentation/perf-report.txt
> @@ -110,6 +110,8 @@ OPTIONS
>   	requires a tty, if one is not present, as when piping to other
>   	commands, the stdio interface is used.
>
> +--gtk:: Use the GTK2 interface.
> +
>   -k::
>   --vmlinux=<file>::
>           vmlinux pathname
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index e011b50..371f114 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -485,6 +485,20 @@ else
>   	endif
>   endif
>
> +ifdef NO_GTK2
> +	BASIC_CFLAGS += -DNO_GTK2

s/-DNO_GTK2/-DNO_GTK2_SUPPORT/ ?


> +else
> +	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
> +	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
> +		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
> +		BASIC_CFLAGS += -DNO_GTK2_SUPPORT
> +	else
> +		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0)
> +		EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
> +		LIB_OBJS += $(OUTPUT)util/gtk/browser.o
> +	endif
> +endif
> +
>   ifdef NO_LIBPERL
>   	BASIC_CFLAGS += -DNO_LIBPERL
>   else
> diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> index 25d34d4..d6bf6ec 100644
> --- a/tools/perf/builtin-report.c
> +++ b/tools/perf/builtin-report.c
> @@ -40,7 +40,7 @@ struct perf_report {
>   	struct perf_tool	tool;
>   	struct perf_session	*session;
>   	char const		*input_name;
> -	bool			force, use_tui, use_stdio;
> +	bool			force, use_tui, use_gtk, use_stdio;
>   	bool			hide_unresolved;
>   	bool			dont_use_callchains;
>   	bool			show_full_info;
> @@ -326,8 +326,13 @@ static int __cmd_report(struct perf_report *rep)
>   	}
>
>   	if (use_browser>  0) {
> -		perf_evlist__tui_browse_hists(session->evlist, help,
> -					      NULL, NULL, 0);
> +		if (use_browser == 1) {
> +			perf_evlist__tui_browse_hists(session->evlist, help,
> +						      NULL, NULL, 0);
> +		} else if (use_browser == 2) {
> +			perf_evlist__gtk_browse_hists(session->evlist, help,
> +						      NULL, NULL, 0);
> +		}
>   	} else
>   		perf_evlist__tty_browse_hists(session->evlist, rep, help);
>
> @@ -474,6 +479,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>   	OPT_STRING(0, "pretty",&report.pretty_printing_style, "key",
>   		   "pretty printing style key: normal raw"),
>   	OPT_BOOLEAN(0, "tui",&report.use_tui, "Use the TUI interface"),
> +	OPT_BOOLEAN(0, "gtk",&report.use_gtk, "Use the GTK2 interface"),
>   	OPT_BOOLEAN(0, "stdio",&report.use_stdio,
>   		    "Use the stdio interface"),
>   	OPT_STRING('s', "sort",&sort_order, "key[,key2...]",
> @@ -526,6 +532,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>   		use_browser = 0;
>   	else if (report.use_tui)
>   		use_browser = 1;
> +	else if (report.use_gtk)
> +		use_browser = 2;
>
>   	if (report.inverted_callchain)
>   		callchain_param.order = ORDER_CALLER;
> @@ -537,9 +545,12 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
>   			report.input_name = "perf.data";
>   	}
>
> -	if (strcmp(report.input_name, "-") != 0)
> -		setup_browser(true);
> -	else
> +	if (strcmp(report.input_name, "-") != 0) {
> +		if (report.use_gtk)
> +			perf_gtk_setup_browser(argc, argv, true);
> +		else
> +			setup_browser(true);
> +	} else

Wouldn't it be better if setup_browser() handled this internally based on the 
value of use_browser?


>   		use_browser = 0;
>
>   	/*
> diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
> index 6170fd2..f5b551c 100644
> --- a/tools/perf/config/feature-tests.mak
> +++ b/tools/perf/config/feature-tests.mak
> @@ -65,6 +65,19 @@ int main(void)
>   endef
>   endif
>
> +ifndef NO_GTK2
> +define SOURCE_GTK2
> +#include<gtk/gtk.h>
> +
> +int main(int argc, char *argv[])
> +{
> +        gtk_init(&argc,&argv);
> +
> +        return 0;
> +}
> +endef
> +endif
> +
>   ifndef NO_LIBPERL
>   define SOURCE_PERL_EMBED
>   #include<EXTERN.h>
> diff --git a/tools/perf/util/cache.h b/tools/perf/util/cache.h
> index fc5e5a0..8dd224d 100644
> --- a/tools/perf/util/cache.h
> +++ b/tools/perf/util/cache.h
> @@ -45,6 +45,18 @@ void setup_browser(bool fallback_to_pager);
>   void exit_browser(bool wait_for_ok);
>   #endif
>
> +#ifdef NO_GTK2_SUPPORT
> +static inline void perf_gtk_setup_browser(int argc __used, const char *argv[] __used, bool fallback_to_pager)
> +{
> +	if (fallback_to_pager)
> +		setup_pager();
> +}
> +static inline void perf_gtk_exit_browser(bool wait_for_ok __used) {}
> +#else
> +void perf_gtk_setup_browser(int argc, const char *argv[], bool fallback_to_pager);
> +void perf_gtk_exit_browser(bool wait_for_ok);
> +#endif
> +
>   char *alias_lookup(const char *alias);
>   int split_cmdline(char *cmdline, const char ***argv);
>
> diff --git a/tools/perf/util/gtk/browser.c b/tools/perf/util/gtk/browser.c
> new file mode 100644
> index 0000000..4878279
> --- /dev/null
> +++ b/tools/perf/util/gtk/browser.c

I think it needs to be moved under util/ui. There will be some share point 
between tui and gui IMHO. Otherwise, if it is too much depends on TUI, how 
about rename util/ui to util/tui?

Thanks,
Namhyung
