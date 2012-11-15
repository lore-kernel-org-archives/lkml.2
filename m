Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2KOHr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:47:27 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41492 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2KOHr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:47:26 -0500
Date: Thu, 15 Nov 2012 09:47:23 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Namhyung Kim <namhyung@kernel.org>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 3/6] perf ui/gtk: Implement ui_progress functions
In-Reply-To: <1352813436-14173-3-git-send-email-namhyung@kernel.org>
Message-ID: <alpine.LFD.2.02.1211150945340.2386@tux.localdomain>
References: <1352813436-14173-1-git-send-email-namhyung@kernel.org> <1352813436-14173-3-git-send-email-namhyung@kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Implement progress update function for GTK2 front end.
> 
> Note that since it will be called before gtk main loop so that
> we should call gtk event loop handler directly.
> 
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

> diff --git a/tools/perf/ui/gtk/progress.c b/tools/perf/ui/gtk/progress.c
> new file mode 100644
> index 000000000000..903426fe27cf
> --- /dev/null
> +++ b/tools/perf/ui/gtk/progress.c
> @@ -0,0 +1,50 @@
> +#include <inttypes.h>
> +
> +#include "gtk.h"
> +#include "../progress.h"
> +#include "util.h"
> +
> +static GtkWidget *dialog;
> +static GtkWidget *progress;
> +
> +static void gtk_progress_update(u64 curr, u64 total, const char *title)
> +{
> +	double fraction = total ? 1.0 * curr / total : 0.0;
> +	char buf[1024];
> +
> +	if (dialog == NULL) {
> +		GtkWidget *vbox = gtk_vbox_new(TRUE, 5);
> +		GtkWidget *label = gtk_label_new(title);
> +
> +		dialog = gtk_window_new(GTK_WINDOW_TOPLEVEL);
> +		progress = gtk_progress_bar_new();
> +
> +		gtk_box_pack_start(GTK_BOX(vbox), label, TRUE, FALSE, 3);
> +		gtk_box_pack_start(GTK_BOX(vbox), progress, TRUE, TRUE, 3);
> +
> +		gtk_container_add(GTK_CONTAINER(dialog), vbox);
> +
> +		gtk_window_set_title(GTK_WINDOW(dialog), "perf");
> +		gtk_window_resize(GTK_WINDOW(dialog), 300, 80);
> +		gtk_window_set_position(GTK_WINDOW(dialog), GTK_WIN_POS_CENTER);
> +
> +		gtk_widget_show_all(dialog);
> +	}
> +
> +	gtk_progress_bar_set_fraction(GTK_PROGRESS_BAR(progress), fraction);
> +	snprintf(buf, sizeof(buf), "%"PRIu64" / %"PRIu64, curr, total);
> +	gtk_progress_bar_set_text(GTK_PROGRESS_BAR(progress), buf);
> +
> +	/* we didn't call gtk_main yet, so do it manually */
> +	while (gtk_events_pending())
> +		gtk_main_iteration();
> +}

When is the progress bar shown? Why does it need to be a separate dialog? 
Can't we embed it in the current perf window (and make the other 
UI components disabled if necessary)?

			Pekka
