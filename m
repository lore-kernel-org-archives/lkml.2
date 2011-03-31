Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab1CaIIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 04:08:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38402 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab1CaIHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 04:07:43 -0400
Subject: Re: [PATCH 2/2] perf: Mmap 512 kiB by default
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
In-Reply-To: <1301535324-9735-1-git-send-email-fweisbec@gmail.com>
References: <1301496028.4859.183.camel@twins>
	 <1301535324-9735-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 10:09:52 +0200
Message-ID: <1301558992.2250.489.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 03:35 +0200, Frederic Weisbecker wrote:
> The default setting of perf record is to mmap 128 pages if the user
> did not override with -m.
> However the page size may vary accross different architecture
> settings, giving different default size between each.
> 
> Moreover the kernel side still has a default max number of mlocked
> pages of 512 kiB + 1 page for unprivileged users. 128 + 1 pages
> with page size > 4096 overlaps this threshold.
> 
> Thus, better adapt to this limitation and set the default number of
> pages to fit those 512 kiB + 1 page.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/builtin-record.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 6febcc1..a7e14bd 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -41,7 +41,7 @@ static u64			user_interval			= ULLONG_MAX;
>  static u64			default_interval		=      0;
>  
>  static unsigned int		page_size;
> -static unsigned int		mmap_pages			=    128;
> +static unsigned int		mmap_pages			= UINT_MAX;
>  static unsigned int		user_freq 			= UINT_MAX;
>  static int			freq				=   1000;
>  static int			output;
> @@ -506,6 +506,10 @@ static int __cmd_record(int argc, const char **argv)
>  	if (have_tracepoints(&evsel_list->entries))
>  		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
>  
> +	/* 512 kiB: default amount of unprivileged mlocked memory */
> +	if (mmap_pages == UINT_MAX)
> +		mmap_pages = (512 * 1024) / page_size;
> +
>  	if (forks) {
>  		child_pid = fork();
>  		if (child_pid < 0) {

Ok, these two patches look good, I'll queue them. However a follow up
might be to change the perf-record parameter from nr_pages to kb, which
is a much more user friendly interface anyway ;-)



