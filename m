Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1G0GSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 02:18:47 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42014 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1G0GSp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 02:18:45 -0400
MIME-Version: 1.0
In-Reply-To: <1311719817-11336-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <CAAxaTiNJNXnn3PAcKWBSZ2wbMKBDD9yL6pyediEEBHnjNH-uaA@mail.gmail.com>
	<1311719817-11336-1-git-send-email-Gregory.Dietsche@cuw.edu>
Date: Wed, 27 Jul 2011 08:18:42 +0200
X-Google-Sender-Auth: ya30MqdnD4N7Q_i-WhPoa12sFEg
Message-ID: <CAAxaTiPVhXxZczhovbsB8osaP2T3v297z1OOO2YCJsaeVdryXw@mail.gmail.com>
Subject: Re: [PATCH v2] coccicheck: add parallel execution
From: Nicolas Palix <Nicolas.Palix@inria.fr>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: joe@perches.com, julia@diku.dk, Gilles.Muller@lip6.fr,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk, mmarek@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 12:36 AM, Greg Dietsche
<Gregory.Dietsche@cuw.edu> wrote:
> For example to process 6 SmPL patches at the same time:
>        make coccicheck PARALLEL=6
>
> Results are held in /tmp until the scripts finish. By doing this the
> script is able to collate the results from each SmPL patch instead of
> interleaving them in the output.
>
> Version 2: change pkill -P $$ to pkill -s 0
>
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Acked-by: Nicolas Palix <npalix.work@gmail.com>
> ---
>  scripts/coccicheck |   27 ++++++++++++++++++++++++++-
>  1 files changed, 26 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> index 1bb1a1b..c2a04c2 100755
> --- a/scripts/coccicheck
> +++ b/scripts/coccicheck
> @@ -97,10 +97,35 @@ coccinelle () {
>
>  }
>
> +parallel_cleanup () {
> +       pkill -s 0 > /dev/null
> +       rm /tmp/cocci_parallel_$$_* 2>/dev/null
> +       exit
> +}
> +
> +trap parallel_cleanup SIGINT
> +PARALLEL_ID=0
> +
>  if [ "$COCCI" = "" ] ; then
>     for f in `find $srctree/scripts/coccinelle/ -name '*.cocci' -type f | sort`; do
> -       coccinelle $f
> +       if [ "$PARALLEL" -eq "$PARALLEL" 2>/dev/null ] ; then
> +               if [ "$ONLINE" = "0" ] ; then
> +                       echo Processing: `basename $f`
> +               fi
> +               coccinelle $f>/tmp/cocci_parallel_$$_$PARALLEL_ID 2>&1 &
> +               PARALLEL_ID=$(($PARALLEL_ID + 1))
> +               while [ "`jobs -p | wc -l`" -ge "$PARALLEL" ] ; do
> +                       sleep 3
> +               done
> +       else
> +               coccinelle $f
> +       fi
>     done
> +    wait
> +    if [ "$PARALLEL_ID" -ge "0" ] ; then
> +       cat /tmp/cocci_parallel_$$_*
> +       parallel_cleanup
> +    fi
>  else
>     coccinelle $COCCI
>  fi
> --
> 1.7.2.5
>
>



-- 
Nicolas Palix
http://sardes.inrialpes.fr/~npalix/
