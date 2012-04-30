Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2D3Gbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 02:31:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36402 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2D3Gbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 02:31:36 -0400
Date: Mon, 30 Apr 2012 09:31:28 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Namhyung Kim <namhyung.kim@lge.com>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] perf ui/gtk: Use struct perf_error_ops
In-Reply-To: <1335761711-31403-8-git-send-email-namhyung.kim@lge.com>
Message-ID: <alpine.LFD.2.02.1204300923010.2090@tux.localdomain>
References: <1335761711-31403-1-git-send-email-namhyung.kim@lge.com> <1335761711-31403-8-git-send-email-namhyung.kim@lge.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012, Namhyung Kim wrote:
> Define and use perf_gtk_eops to provide a GTK2 message
> dialog for error reporting. To do that, we need global
> main_window variable for tracking UI state.
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
> index a727fe394e91..0d0ed2ed3937 100644
> --- a/tools/perf/ui/gtk/util.c
> +++ b/tools/perf/ui/gtk/util.c
> @@ -2,6 +2,53 @@
>  #include "../../util/debug.h"
>  #include "gtk.h"
>  
> +#include <stdio.h>
> +#include <string.h>
> +#include <stdlib.h>
> +
> +
> +GtkWidget *main_window;
> +
> +static int message_dialog(const char *title, const char *format, va_list args)
> +{
> +	char *msg;
> +	GtkWidget *dialog;
> +	GtkMessageType message_type = GTK_MESSAGE_WARNING;
> +
> +	if (!main_window || vasprintf(&msg, format, args) < 0) {
> +		fprintf(stderr, "%s:\n", title);
> +		vfprintf(stderr, format, args);
> +		return -1;
> +	}
> +
> +	if (strcmp(title, "Error") == 0)
> +		message_type = GTK_MESSAGE_ERROR;
> +
> +	dialog = gtk_message_dialog_new_with_markup(GTK_WINDOW(main_window),
> +					GTK_DIALOG_DESTROY_WITH_PARENT,
> +					message_type,
> +					GTK_BUTTONS_CLOSE,
> +					"<b>%s</b>\n\n%s", title, msg);
> +	gtk_dialog_run(GTK_DIALOG(dialog));
> +	gtk_widget_destroy(dialog);
> +	free(msg);
> +	return 0;
> +}

I think this is an usability glitch waiting to happen - especially so if 
you use it for warnings. There's no reason to require the user to react to 
warning messages in the GUI because there's absolutely nothing they can do 
about them.

I guess we could do something like the "ui helpline" thing used by the 
newt front-end if we really wanted to.

			Pekka
