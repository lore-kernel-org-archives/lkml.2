Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2JANQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:16:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39004 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab2JANQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:16:42 -0400
Subject: Re: [PATCH] tools lib traceevent: Fix missed freeing of subargs in
 free_arg() in filter
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
In-Reply-To: <1348874483.22822.100.camel@gandalf.local.home>
References: <1348874483.22822.100.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Oct 2012 22:16:35 +0900
Message-ID: <1349097395.1613.4.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

2012-09-28 (금), 19:21 -0400, Steven Rostedt:
> Some of args were missed in free_args(), as well as subargs.
> That is args like FILTER_ARG_NUM have left and right pointers to
> other args that also need to be freed.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  tools/lib/traceevent/parse-filter.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index ad17855..2d907cb 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -209,7 +209,12 @@ static void free_arg(struct filter_arg *arg)
>  	switch (arg->type) {
>  	case FILTER_ARG_NONE:
>  	case FILTER_ARG_BOOLEAN:
> +		break;
> +
>  	case FILTER_ARG_NUM:
> +	case FILTER_ARG_EXP:
> +		free_arg(arg->op.left);
> +		free_arg(arg->op.right);

Although they have same layout, wouldn't it be better using their own
fields?

	case FILTER_ARG_NUM:
		free_arg(arg->num.left);
		free_arg(arg->num.right);
		break;

	case FILTER_ARG_EXP:
		free_arg(arg->exp.left);
		free_arg(arg->exp.right);
		break;

Thanks,
Namhyung


