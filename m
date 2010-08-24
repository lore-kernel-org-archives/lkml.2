Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0HXMZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 08:25:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab0HXMZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 08:25:37 -0400
Date: Tue, 24 Aug 2010 09:25:25 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: jovi zhang <bookjovi@gmail.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: fix core dump
Message-ID: <20100824122525.GM2973@ghostprotocols.net>
References: <AANLkTi=9Cn=R8SPMCRp5z+gEjXbaBHeb-AaOtRbuwwcn@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=9Cn=R8SPMCRp5z+gEjXbaBHeb-AaOtRbuwwcn@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 24, 2010 at 03:07:33PM +0800, jovi zhang escreveu:
> Perf invoke symbol__init function twice when we input command "perf
> kmem/sched record ls", then it will core dump when symbol__exit
> invoked.
> So give a flag to make symbol__init can be invoked once.

Yeah, this fixes the problem, and I'll apply this patch, but I think
that the elegant solution is to adopt one more kernel construct, i.e.
__init markings :)

Thanks!

- Arnaldo
 
> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
> tools/perf/util/symbol.c |    9 +++++++++
> 1 files changed, 9 insertions(+), 0 deletions(-)
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 1a36773..aded121 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -43,6 +43,8 @@ struct symbol_conf symbol_conf = {
>        .try_vmlinux_path = true,
> };
> 
> +static bool symbol_initizated;
> +
> int dso__name_len(const struct dso *self)
> {
>        if (verbose)
> @@ -2268,6 +2270,11 @@ static int setup_list(struct strlist **list,
> const char *list_str,
> 
> int symbol__init(void)
> {
> +       if (symbol_initizated == true)
> +               return 0;
> +       else
> +               symbol_initizated = true;
> +
>        elf_version(EV_CURRENT);
>        if (symbol_conf.sort_by_name)
>                symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
> @@ -2304,6 +2311,8 @@ out_free_comm_list:
> 
> void symbol__exit(void)
> {
> +       if (symbol_initizated == false)
> +               return;
>        strlist__delete(symbol_conf.sym_list);
>        strlist__delete(symbol_conf.dso_list);
>        strlist__delete(symbol_conf.comm_list);
