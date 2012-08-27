Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2H0IGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 04:06:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:51343 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2H0IG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 04:06:28 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-0e-503b2a814fde
From: Namhyung Kim <namhyung@kernel.org>
To: Feng Tang <feng.tang@intel.com>
Cc: acme@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] perf tools: Fix a misuse of for_each_set_bit() in session.c
References: <1346053107-11946-1-git-send-email-feng.tang@intel.com>
	<1346053107-11946-4-git-send-email-feng.tang@intel.com>
Date: Mon, 27 Aug 2012 16:59:07 +0900
In-Reply-To: <1346053107-11946-4-git-send-email-feng.tang@intel.com> (Feng
	Tang's message of "Mon, 27 Aug 2012 15:38:27 +0800")
Message-ID: <871uisepf8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 27 Aug 2012 15:38:27 +0800, Feng Tang wrote:
> In regs_dump__printf() it use for_each_set_bit() for bit ops by
> casting a (u64 *) to a (unsigned long *), this works for 64 bits
> machine, but will fail on 32 bits ones.
>
> Fix it by using the raw bit comparing method.

Did it really cause a build failure or a program error?  If not, it
looks better to keep using for_each_set_bit() interface.  How about
casting the @mask to (void *) ?

Thanks,
Namhyung


>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  tools/perf/util/session.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index f7bb7ae..afcea6c 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -904,11 +904,10 @@ static void regs_dump__printf(u64 mask, u64 *regs)
>  {
>  	unsigned rid, i = 0;
>  
> -	for_each_set_bit(rid, (unsigned long *) &mask, sizeof(mask) * 8) {
> -		u64 val = regs[i++];
> -
> -		printf(".... %-5s 0x%" PRIx64 "\n",
> -		       perf_reg_name(rid), val);
> +	for (rid = 0; rid < 64; rid++) {
> +		if (mask & (1 << rid))
> +			printf(".... %-5s 0x%" PRIx64 "\n",
> +				perf_reg_name(rid), regs[i++]);
>  	}
>  }
