Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2A2P2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 10:28:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46236 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2A2P2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 10:28:11 -0500
Message-ID: <4F256587.3090504@gmail.com>
Date: Sun, 29 Jan 2012 08:28:07 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] perf record: Add error message for EMFILE
References: <1327827356-8786-1-git-send-email-namhyung@gmail.com> <1327827356-8786-2-git-send-email-namhyung@gmail.com>
In-Reply-To: <1327827356-8786-2-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/29/2012 01:55 AM, Namhyung Kim wrote:
> When a user tries to open so many events, perf_event_oen syscall
> may fail with EMFILE. Provide an advice for that case.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  tools/perf/builtin-record.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 32870eef952f..5d3b6794d93b 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -249,6 +249,10 @@ try_again:
>  				ui__warning("The %s event is not supported.\n",
>  					    event_name(pos));
>  				exit(EXIT_FAILURE);
> +			} else if (err == EMFILE) {
> +				ui__warning("Too many events are opened.\n"
> +					    "Try again after reducing the number of events.\n");
> +				exit(EXIT_FAILURE);
>  			}
>  
>  			printf("\n");

It's not just the number of events: an fd is opened for each specified
event on each specified cpu and for each specified task. See
__perf_evsel__open(). e.g., the new --uid option on a 16 cpu server can
hit the limit pretty fast.

David
