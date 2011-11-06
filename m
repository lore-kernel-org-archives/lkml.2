Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1KFSXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 13:23:40 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:54495 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753792Ab1KFSXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 13:23:39 -0500
X-IronPort-AV: E=Sophos;i="4.69,465,1315173600"; 
   d="scan'208";a="128733724"
Date: Sun, 6 Nov 2011 19:20:26 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
cc: julia@diku.dk, Gilles.Muller@lip6.fr, npalix.work@gmail.com,
        mmarek@suse.cz, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk
Subject: Re: [RESEND 3/3] coccicheck: add parallel execution
In-Reply-To: <1320545653-28249-4-git-send-email-Gregory.Dietsche@cuw.edu>
Message-ID: <alpine.DEB.2.02.1111061920060.1873@hadrien>
References: <1320545653-28249-1-git-send-email-Gregory.Dietsche@cuw.edu> <1320545653-28249-4-git-send-email-Gregory.Dietsche@cuw.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Nov 2011, Gregory.Dietsche@cuw.edu wrote:

> From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
>
> For example to process 6 SmPL patches at the same time:
> 	make coccicheck PARALLEL=6
>
> Results are held in /tmp until the scripts finish. By doing this the
> script is able to collate the results from each SmPL patch instead of
> interleaving them in the output.
>
> Version 2: change pkill -P $$ to pkill -s 0
>
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> Acked-by: Nicolas Palix <npalix.work@gmail.com>

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

> ---
> scripts/coccicheck |   27 ++++++++++++++++++++++++++-
> 1 files changed, 26 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> index 1bb1a1b..c2a04c2 100755
> --- a/scripts/coccicheck
> +++ b/scripts/coccicheck
> @@ -97,10 +97,35 @@ coccinelle () {
>
> }
>
> +parallel_cleanup () {
> +	pkill -s 0 > /dev/null
> +	rm /tmp/cocci_parallel_$$_* 2>/dev/null
> +	exit
> +}
> +
> +trap parallel_cleanup SIGINT
> +PARALLEL_ID=0
> +
> if [ "$COCCI" = "" ] ; then
>     for f in `find $srctree/scripts/coccinelle/ -name '*.cocci' -type f | sort`; do
> -	coccinelle $f
> +	if [ "$PARALLEL" -eq "$PARALLEL" 2>/dev/null ] ; then
> +		if [ "$ONLINE" = "0" ] ; then
> +			echo Processing: `basename $f`
> +		fi
> +		coccinelle $f>/tmp/cocci_parallel_$$_$PARALLEL_ID 2>&1 &
> +		PARALLEL_ID=$(($PARALLEL_ID + 1))
> +		while [ "`jobs -p | wc -l`" -ge "$PARALLEL" ] ; do
> +			sleep 3
> +		done
> +	else
> +		coccinelle $f
> +	fi
>     done
> +    wait
> +    if [ "$PARALLEL_ID" -ge "0" ] ; then
> +	cat /tmp/cocci_parallel_$$_*
> +	parallel_cleanup
> +    fi
> else
>     coccinelle $COCCI
> fi
> -- 
> 1.7.6.4
>
>
