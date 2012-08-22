Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab2HVTW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:22:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54848 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab2HVTWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:22:23 -0400
Message-ID: <50353169.1080606@gmail.com>
Date: Wed, 22 Aug 2012 13:22:17 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Luigi Semenzato <semenzato@chromium.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] perf: do not flush maps on COMM for perf report
References: <1345585940-6497-1-git-send-email-semenzato@chromium.org>
In-Reply-To: <1345585940-6497-1-git-send-email-semenzato@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/12 3:52 PM, Luigi Semenzato wrote:
> This fixes a long-standing bug caused by the lack of separate
> COMM and EXEC record types, which makes "perf report" lose
> track of symbols when a process renames itself.
>
> With this fix (suggested by Stephane Eranian), a COMM (rename)
> no longer flushes the maps, which is the correct behavior.
> An EXEC also no longer flushes the maps, but this doesn't
> matter because as new mappings are created (for the executable
> and the libraries) the old mappings are automatically removed.
> This is not by accident: the functionality is necessary because
> DLLs can be explicitly loaded at any time with dlopen(),
> possibly on top of existing text, so "perf report" handles
> correctly the clobbering of new mappings on top of old ones.
>
> An alternative patch (which I proposed earlier) would be to
> introduce a separate PERF_RECORD_EXEC type, but it is a much
> larger change (about 300 lines) and is not necessary.
>
> Signed-off-by: Luigi Semenzato <semenzato@chromium.org>
> ---
>   tools/perf/util/thread.c |    1 -
>   1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
> index fb4b7ea..8b3e593 100644
> --- a/tools/perf/util/thread.c
> +++ b/tools/perf/util/thread.c
> @@ -39,7 +39,6 @@ int thread__set_comm(struct thread *self, const char *comm)
>   	err = self->comm == NULL ? -ENOMEM : 0;
>   	if (!err) {
>   		self->comm_set = true;
> -		map_groups__flush(&self->mg);
>   	}
>   	return err;
>   }
>

Acked-by: David Ahern <dsahern@gmail.com>
