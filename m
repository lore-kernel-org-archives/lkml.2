Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2LUQjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:39:36 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:60461 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2LUQjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:39:32 -0500
X-Greylist: delayed 1444 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 11:39:32 EST
Date: Fri, 21 Dec 2012 11:51:07 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 3/6] perf ui/gtk: Implement basic GTK2 annotation browser
Message-ID: <20121221145107.GA10213@ghostprotocols.net>
References: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
 <1356078018-31905-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1356078018-31905-4-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 21, 2012 at 05:20:15PM +0900, Namhyung Kim escreveu:
> Basic implementation of perf annotate on GTK2.  Currently only
> shows first symbol.

I merged the first two patches in this series, but this one needs to be
merged with the sixth patch, so that we can try it at this point, then
you can add more features (patches 4 and 5) that can be tested as we
merge them.

Just pushed my perf/core branch with the 2 first patches.

- Arnaldo
 
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/Makefile           |   1 +
>  tools/perf/builtin-annotate.c |   5 +-
>  tools/perf/ui/gtk/annotate.c  | 185 ++++++++++++++++++++++++++++++++++++++++++
>  tools/perf/util/annotate.h    |  20 +++++
>  4 files changed, 210 insertions(+), 1 deletion(-)
>  create mode 100644 tools/perf/ui/gtk/annotate.c
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 103ed956ca80..4be79a469229 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -693,6 +693,7 @@ ifndef NO_GTK2
>  		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
>  		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
>  		LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
> +		LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
>  	endif
>  endif
>  
> diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
> index dc870cf31b79..9f84bc45672c 100644
> --- a/tools/perf/builtin-annotate.c
> +++ b/tools/perf/builtin-annotate.c
> @@ -138,7 +138,10 @@ find_next:
>  			continue;
>  		}
>  
> -		if (use_browser > 0) {
> +		if (use_browser == 2) {
> +			hist_entry__gtk_annotate(he, evidx, NULL);
> +			return;
> +		} else if (use_browser == 1) {
>  			key = hist_entry__tui_annotate(he, evidx, NULL);
>  			switch (key) {
>  			case K_RIGHT:
> diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
> new file mode 100644
> index 000000000000..19d84fa327af
> --- /dev/null
> +++ b/tools/perf/ui/gtk/annotate.c
> @@ -0,0 +1,185 @@
> +#include "gtk.h"
> +#include "util/debug.h"
> +#include "util/annotate.h"
> +#include "ui/helpline.h"
> +
> +
> +enum {
> +	ANN_COL__PERCENT,
> +	ANN_COL__OFFSET,
> +	ANN_COL__LINE,
> +
> +	MAX_ANN_COLS
> +};
> +
> +static const char *const col_names[] = {
> +	"Overhead",
> +	"Offset",
> +	"Line"
> +};
> +
> +static int perf_gtk__get_percent(char *buf, size_t size, struct symbol *sym,
> +				 struct disasm_line *dl, int evidx)
> +{
> +	struct sym_hist *symhist;
> +	double percent = 0.0;
> +	const char *markup;
> +	int ret = 0;
> +
> +	strcpy(buf, "");
> +
> +	if (dl->offset == (s64) -1)
> +		return 0;
> +
> +	symhist = annotation__histogram(symbol__annotation(sym), evidx);
> +	if (!symhist->addr[dl->offset])
> +		return 0;
> +
> +	percent = 100.0 * symhist->addr[dl->offset] / symhist->sum;
> +
> +	markup = perf_gtk__get_percent_color(percent);
> +	if (markup)
> +		ret += scnprintf(buf, size, "%s", markup);
> +	ret += scnprintf(buf + ret, size - ret, "%6.2f%%", percent);
> +	if (markup)
> +		ret += scnprintf(buf + ret, size - ret, "</span>");
> +
> +	return ret;
> +}
> +
> +static int perf_gtk__get_offset(char *buf, size_t size, struct symbol *sym,
> +				struct map *map, struct disasm_line *dl)
> +{
> +	u64 start = map__rip_2objdump(map, sym->start);
> +
> +	strcpy(buf, "");
> +
> +	if (dl->offset == (s64) -1)
> +		return 0;
> +
> +	return scnprintf(buf, size, "%"PRIx64, start + dl->offset);
> +}
> +
> +static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
> +				struct map *map, int evidx,
> +				struct hist_browser_timer *hbt __maybe_unused)
> +{
> +	struct disasm_line *pos, *n;
> +	struct annotation *notes;
> +	GType col_types[MAX_ANN_COLS];
> +	GtkCellRenderer *renderer;
> +	GtkListStore *store;
> +	GtkWidget *view;
> +	int i;
> +	char s[512];
> +
> +	if (map->dso->annotate_warned)
> +		return -1;
> +
> +	if (symbol__annotate(sym, map, 0) < 0) {
> +		ui__error("%s", ui_helpline__current);
> +		return -1;
> +	}
> +
> +	notes = symbol__annotation(sym);
> +
> +	for (i = 0; i < MAX_ANN_COLS; i++) {
> +		col_types[i] = G_TYPE_STRING;
> +	}
> +	store = gtk_list_store_newv(MAX_ANN_COLS, col_types);
> +
> +	view = gtk_tree_view_new();
> +	renderer = gtk_cell_renderer_text_new();
> +
> +	for (i = 0; i < MAX_ANN_COLS; i++) {
> +		gtk_tree_view_insert_column_with_attributes(GTK_TREE_VIEW(view),
> +					-1, col_names[i], renderer,
> +					i == ANN_COL__PERCENT ? "markup" : "text",
> +					i, NULL);
> +	}
> +
> +	gtk_tree_view_set_model(GTK_TREE_VIEW(view), GTK_TREE_MODEL(store));
> +	g_object_unref(GTK_TREE_MODEL(store));
> +
> +	list_for_each_entry(pos, &notes->src->source, node) {
> +		GtkTreeIter iter;
> +
> +		gtk_list_store_append(store, &iter);
> +
> +		if (perf_gtk__get_percent(s, sizeof(s), sym, pos, evidx))
> +			gtk_list_store_set(store, &iter, ANN_COL__PERCENT, s, -1);
> +		if (perf_gtk__get_offset(s, sizeof(s), sym, map, pos))
> +			gtk_list_store_set(store, &iter, ANN_COL__OFFSET, s, -1);
> +		gtk_list_store_set(store, &iter, ANN_COL__LINE, pos->line, -1);
> +	}
> +
> +	gtk_container_add(GTK_CONTAINER(window), view);
> +
> +	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
> +		list_del(&pos->node);
> +		disasm_line__free(pos);
> +	}
> +
> +	return 0;
> +}
> +
> +int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
> +			 struct hist_browser_timer *hbt)
> +{
> +	GtkWidget *vbox;
> +	GtkWidget *notebook;
> +	GtkWidget *infobar;
> +	GtkWidget *statbar;
> +	GtkWidget *window;
> +	GtkWidget *scrolled_window;
> +	GtkWidget *tab_label;
> +
> +	signal(SIGSEGV, perf_gtk__signal);
> +	signal(SIGFPE,  perf_gtk__signal);
> +	signal(SIGINT,  perf_gtk__signal);
> +	signal(SIGQUIT, perf_gtk__signal);
> +	signal(SIGTERM, perf_gtk__signal);
> +
> +	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
> +	gtk_window_set_title(GTK_WINDOW(window), "perf annotate");
> +
> +	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
> +
> +	pgctx = perf_gtk__activate_context(window);
> +	if (!pgctx)
> +		return -1;
> +
> +	vbox = gtk_vbox_new(FALSE, 0);
> +	notebook = gtk_notebook_new();
> +	scrolled_window = gtk_scrolled_window_new(NULL, NULL);
> +	tab_label = gtk_label_new(sym->name);
> +
> +	gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
> +				       GTK_POLICY_AUTOMATIC,
> +				       GTK_POLICY_AUTOMATIC);
> +
> +	gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window,
> +				 tab_label);
> +	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
> +
> +	infobar = perf_gtk__setup_info_bar();
> +	if (infobar)
> +		gtk_box_pack_start(GTK_BOX(vbox), infobar, FALSE, FALSE, 0);
> +
> +	statbar = perf_gtk__setup_statusbar();
> +	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
> +
> +	gtk_container_add(GTK_CONTAINER(window), vbox);
> +
> +	perf_gtk__annotate_symbol(scrolled_window, sym, map, evidx, hbt);
> +
> +	gtk_widget_show_all(window);
> +
> +	perf_gtk__resize_window(window);
> +	gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
> +
> +	gtk_main();
> +
> +	perf_gtk__deactivate_context(&pgctx);
> +	return 0;
> +}
> diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
> index 8eec94358a4a..a8ccbda4aeb7 100644
> --- a/tools/perf/util/annotate.h
> +++ b/tools/perf/util/annotate.h
> @@ -6,6 +6,7 @@
>  #include "types.h"
>  #include "symbol.h"
>  #include "hist.h"
> +#include "sort.h"
>  #include <linux/list.h>
>  #include <linux/rbtree.h>
>  #include <pthread.h>
> @@ -154,6 +155,25 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
>  }
>  #endif
>  
> +#ifdef GTK2_SUPPORT
> +int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
> +			 struct hist_browser_timer *hbt);
> +
> +static inline int hist_entry__gtk_annotate(struct hist_entry *he, int evidx,
> +					   struct hist_browser_timer *hbt)
> +{
> +	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evidx, hbt);
> +}
> +#else
> +static inline int hist_entry__gtk_annotate(struct hist_entry *he __maybe_unused,
> +					   int evidx __maybe_unused,
> +					   struct hist_browser_timer *hbt
> +					   __maybe_unused)
> +{
> +	return 0;
> +}
> +#endif
> +
>  extern const char	*disassembler_style;
>  
>  #endif	/* __PERF_ANNOTATE_H */
> -- 
> 1.7.11.7
