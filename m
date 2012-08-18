Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2HRHwO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 03:52:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62946 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2HRHwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 03:52:05 -0400
MIME-Version: 1.0
In-Reply-To: <1345222583-3964-1-git-send-email-namhyung@kernel.org>
References: <1345222583-3964-1-git-send-email-namhyung@kernel.org>
Date: Sat, 18 Aug 2012 10:52:03 +0300
X-Google-Sender-Auth: dxaiShKUnpsfLzLHsnbaOOQmX-o
Message-ID: <CAOJsxLEZjxa1ySfVJeD-GJ5_Gi=nJTn40rCSu+PHhXjwn633oQ@mail.gmail.com>
Subject: Re: [PATCH] perf ui/gtk: Ensure not to call gtk_main_quit() twice
From: Pekka Enberg <penberg@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 7:56 PM, Namhyung Kim <namhyung@kernel.org> wrote:
> Currently the gtk_main_quit() is called twice when perf exits so the
> following warning is emitted:
>
>   [penberg@tux perf]$ ./perf report --gtk
>   ^Cperf: Interrupt
>
>   (perf:4048): Gtk-CRITICAL **: IA__gtk_main_quit: assertion `main_loops != NULL' failed
>
> Fix it by not to call it unnecessarily.
>
> Reported-by: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/ui/gtk/setup.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
> index ad40b3626fdb..ec1ee26b485a 100644
> --- a/tools/perf/ui/gtk/setup.c
> +++ b/tools/perf/ui/gtk/setup.c
> @@ -13,6 +13,8 @@ int perf_gtk__init(void)
>
>  void perf_gtk__exit(bool wait_for_ok __used)
>  {
> +       if (!perf_gtk__is_active_context(pgctx))
> +               return;
>         perf_error__unregister(&perf_gtk_eops);
>         gtk_main_quit();
>  }

Wouldn't it be nicer to rearrange the callers so that perf_gtk__exit()
is not called twice?
