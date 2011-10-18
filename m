Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab1JRXN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 19:13:56 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52830 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1JRXNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 19:13:54 -0400
Message-ID: <4E9E082D.8040403@gmail.com>
Date: Tue, 18 Oct 2011 17:13:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/7] perf ui browser: Make the colors configurable and
 change the defaults
References: <1318974247-6683-1-git-send-email-acme@infradead.org> <1318974247-6683-7-git-send-email-acme@infradead.org>
In-Reply-To: <1318974247-6683-7-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/18/2011 03:44 PM, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Just use as a starting point the "[colors]" section of
> tools/perf/Documentation/perfconfig.example.
> 
> Changed the colors to be the ones in the old perf tool if used in a green on
> black xterm.
> 
> The next patches should allow using the colors configured for the xterm.
> 
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-3vqmyerkaqltqolmnlehonew@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/Documentation/perfconfig.example |   20 ++++++
>  tools/perf/util/ui/browser.c                |   99 ++++++++++++++++++++++-----
>  2 files changed, 101 insertions(+), 18 deletions(-)
>  create mode 100644 tools/perf/Documentation/perfconfig.example
> 
> diff --git a/tools/perf/Documentation/perfconfig.example b/tools/perf/Documentation/perfconfig.example
> new file mode 100644
> index 0000000..d144866
> --- /dev/null
> +++ b/tools/perf/Documentation/perfconfig.example
> @@ -0,0 +1,20 @@
> +[colors]
> +
> +	# These were the old defaults
> +	top = red, lightgray
> +	medium = green, lightgray
> +	normal = black, lightgray
> +	selected = lightgray, magenta
> +	code = blue, lightgray
> +
> +[tui]
> +
> +	# Defaults if linked with libslang
> +	report = on
> +	annotate = on
> +	top = on
> +
> +[buildid]
> +
> +	# Default, disable using /dev/null
> +	dir = /root/.debug
> diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
> index dce16ee..976b957 100644
> --- a/tools/perf/util/ui/browser.c
> +++ b/tools/perf/util/ui/browser.c
> @@ -1,4 +1,5 @@
>  #include "../util.h"
> +#include "../cache.h"
>  #include "../../perf.h"
>  #include "libslang.h"
>  #include <newt.h>
> @@ -430,27 +431,89 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
>  	return row;
>  }
>  
> -static struct ui_browser__colors {
> -	const char *topColorFg, *topColorBg;
> -	const char *mediumColorFg, *mediumColorBg;
> -	const char *normalColorFg, *normalColorBg;
> -	const char *selColorFg, *selColorBg;
> -	const char *codeColorFg, *codeColorBg;
> -} ui_browser__default_colors = {
> -	"red",       "lightgray",
> -	"green",     "lightgray",
> -	"black",     "lightgray",
> -	"lightgray", "magenta",
> -	"blue",	     "lightgray",
> +static struct ui_browser__colorset {
> +	const char *name, *fg, *bg;
> +	int colorset;
> +} ui_browser__colorsets[] = {
> +	{
> +		.colorset = HE_COLORSET_TOP,
> +		.name	  = "top",
> +		.fg	  = "red",
> +		.bg	  = "black",
> +	},
> +	{
> +		.colorset = HE_COLORSET_MEDIUM,
> +		.name	  = "medium",
> +		.fg	  = "green",
> +		.bg	  = "black",
> +	},
> +	{
> +		.colorset = HE_COLORSET_NORMAL,
> +		.name	  = "normal",
> +		.fg	  = "brightgreen",
> +		.bg	  = "black",
> +	},

Using gnome3 with Fedora 15 these last 2 color sets don't look so good.
The 'black' background is not really black - more of a gray'ish look and
the green font does not show up well. Yes, I get that they are
configurable, but the defaults should be readable too.

David


> +	{
> +		.colorset = HE_COLORSET_SELECTED,
> +		.name	  = "selected",
> +		.fg	  = "black",
> +		.bg	  = "lightgray",
> +	},
> +	{
> +		.colorset = HE_COLORSET_CODE,
> +		.name	  = "code",
> +		.fg	  = "blue",
> +		.bg	  = "black",
> +	},
> +	{
> +		.name = NULL,
> +	}
>  };
>  
> +
> +static int ui_browser__color_config(const char *var, const char *value,
> +				    void *data __used)
> +{
> +	char *fg = NULL, *bg;
> +	int i;
> +
> +	/* same dir for all commands */
> +	if (prefixcmp(var, "colors.") != 0)
> +		return 0;
> +
> +	for (i = 0; ui_browser__colorsets[i].name != NULL; ++i) {
> +		const char *name = var + 7;
> +
> +		if (strcmp(ui_browser__colorsets[i].name, name) != 0)
> +			continue;
> +
> +		fg = strdup(value);
> +		if (fg == NULL)
> +			break;
> +
> +		bg = strchr(fg, ',');
> +		if (bg == NULL)
> +			break;
> +
> +		*bg = '\0';
> +		while (isspace(*++bg));
> +		ui_browser__colorsets[i].bg = bg;
> +		ui_browser__colorsets[i].fg = fg;
> +		return 0;
> +	}
> +
> +	free(fg);
> +	return -1;
> +}
> +
>  void ui_browser__init(void)
>  {
> -	struct ui_browser__colors *c = &ui_browser__default_colors;
> +	int i = 0;
>  
> -	sltt_set_color(HE_COLORSET_TOP, NULL, c->topColorFg, c->topColorBg);
> -	sltt_set_color(HE_COLORSET_MEDIUM, NULL, c->mediumColorFg, c->mediumColorBg);
> -	sltt_set_color(HE_COLORSET_NORMAL, NULL, c->normalColorFg, c->normalColorBg);
> -	sltt_set_color(HE_COLORSET_SELECTED, NULL, c->selColorFg, c->selColorBg);
> -	sltt_set_color(HE_COLORSET_CODE, NULL, c->codeColorFg, c->codeColorBg);
> +	perf_config(ui_browser__color_config, NULL);
> +
> +	while (ui_browser__colorsets[i].name) {
> +		struct ui_browser__colorset *c = &ui_browser__colorsets[i++];
> +		sltt_set_color(c->colorset, c->name, c->fg, c->bg);
> +	}
>  }
