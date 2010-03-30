Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0C3KRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:17:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50697 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0C3KRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:17:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vubHK3Jvgxffwn1YkUQLBd11DgLBNTpMp1lsWrVWm5720xmlxx0kfvOGl5ilPqOKq9
         WlCy/xDbSJKsxjT8xUrXcxRbeWPb8U1SonKtMgtuinCUGwLyUd1yKPmgfLafsqdh1ETr
         qHRRHUPY+qzc7WpVJ1FJ2pMqNkBd+8bdevtuU=
MIME-Version: 1.0
In-Reply-To: <20100330055304.GA2983@sli10-desk.sh.intel.com>
References: <20100330055304.GA2983@sli10-desk.sh.intel.com>
Date: Tue, 30 Mar 2010 19:17:17 +0900
Message-ID: <28c262361003300317g6df68fc6m4385cfbe3e8a1b04@mail.gmail.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
From: Minchan Kim <minchan.kim@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, fengguang.wu@intel.com,
       kosaki.motohiro@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 2:53 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> Commit 84b18490d1f1bc7ed5095c929f78bc002eb70f26 introduces a regression.
> With it, our tmpfs test always oom. The test has a lot of rotated anon
> pages and cause percent[0] zero. Actually the percent[0] is a very small
> value, but our calculation round it to zero. The commit makes vmscan
> completely skip anon pages and cause oops.
> An option is if percent[x] is zero in get_scan_ratio(), forces it
> to 1. See below patch.
> But the offending commit still changes behavior. Without the commit, we scan
> all pages if priority is zero, below patch doesn't fix this. Don't know if
> It's required to fix this too.
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 79c8098..d5cc34e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1604,6 +1604,18 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
>        /* Normalize to percentages */
>        percent[0] = 100 * ap / (ap + fp + 1);
>        percent[1] = 100 - percent[0];
> +       /*
> +        * if percent[x] is small and rounded to 0, this case doesn't mean we
> +        * should skip scan. Give it at least 1% share.
> +        */
> +       if (percent[0] == 0) {
> +               percent[0] = 1;
> +               percent[1] = 99;
> +       }
> +       if (percent[1] == 0) {
> +               percent[0] = 99;
> +               percent[1] = 1;
> +       }
>  }
>
>  /*
>

Yes. It made subtle change.
But we should not depend that change.
Current logic seems to be good and clear than old.
I think you were lucky at that time by not-good and not-clear logic.

BTW, How about this?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 79c8098..f0df563 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1646,11 +1646,6 @@ static void shrink_zone(int priority, struct zone *zone,
                int file = is_file_lru(l);
                unsigned long scan;

-               if (percent[file] == 0) {
-                       nr[l] = 0;
-                       continue;
-               }
-
                scan = zone_nr_lru_pages(zone, sc, l);
                if (priority) {
                        scan >>= priority;




-- 
Kind regards,
Minchan Kim
