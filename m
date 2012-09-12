Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2ILIhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 04:37:37 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53206 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab2ILIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 04:37:34 -0400
X-AuditID: 9c93016f-b7bffae000003557-e1-505049caa7f3
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf, tools: Stop perf stat -p when profiled process exits
References: <1347430144-26758-1-git-send-email-andi@firstfloor.org>
Date: Wed, 12 Sep 2012 17:30:39 +0900
In-Reply-To: <1347430144-26758-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Tue, 11 Sep 2012 23:09:04 -0700")
Message-ID: <87bohbabio.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Tue, 11 Sep 2012 23:09:04 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> When counting a process with perf stat -p check if the process died
> and exit collection if yes.

I guess we need something similar for perf record as well.

>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  tools/perf/builtin-stat.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 861f0ae..1313bb5 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -536,7 +536,14 @@ static int run_perf_stat(int argc __used, const char **argv)
>  		if (WIFSIGNALED(status))
>  			psignal(WTERMSIG(status), argv[0]);
>  	} else {
> -		while(!done) sleep(1);
> +		char piddir[40];
> +		snprintf(piddir, sizeof piddir, "/proc/%d", atoi(target.pid));
> +
> +		while(!done) {
> +			sleep(1);
> +			if (target.pid && access(piddir, X_OK) < 0 && errno == ENOENT)
> +				break;

The target.pid might have multiple pid's - e.g. perf stat -p 1234,5678

Thanks,
Namhyung
