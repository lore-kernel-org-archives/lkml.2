Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab2BIMCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:02:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62729 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab2BIMCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:02:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120209113606.GA8054@sig21.net>
References: <201202041109.53003.toralf.foerster@gmx.de>
	<201202051107.26634.toralf.foerster@gmx.de>
	<CAJd=RBCvvVgWqfSkoEaWVG=2mwKhyXarDOthHt9uwOb2fuDE9g@mail.gmail.com>
	<201202080956.18727.toralf.foerster@gmx.de>
	<20120208115244.GA24959@sig21.net>
	<CAJd=RBDbYA4xZRikGtHJvKESdiSE-B4OucZ6vQ+tHCi+hG2+aw@mail.gmail.com>
	<20120209113606.GA8054@sig21.net>
Date: Thu, 9 Feb 2012 20:02:20 +0800
Message-ID: <CAJd=RBDzUpUgZLVU+WSfb8grzMAbi3fcyyZkpX8qpaxu6zYe1g@mail.gmail.com>
Subject: Re: swap storm since kernel 3.2.x
From: Hillf Danton <dhillf@gmail.com>
To: Johannes Stezenbach <js@sig21.net>
Cc: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 7:36 PM, Johannes Stezenbach <js@sig21.net> wrote:
> On Wed, Feb 08, 2012 at 08:34:14PM +0800, Hillf Danton wrote:
>> And I want to ask kswapd to do less work, the attached diff is
>> based on 3.2.5, mind to test it with CONFIG_DEBUG_OBJECTS enabled?
>
> Sorry, for slow reply.  The patch does not apply to 3.2.4
> (3.2.5 only has the ASPM change which I don't want to
> try atm).  Is the patch below correct?
>

It is fine;)

Thanks
Hillf

> I'll let this run for a while and will report back.
>
> Thanks
> Johannes
>
>
> --- mm/vmscan.c.orig    2012-02-03 21:39:51.000000000 +0100
> +++ mm/vmscan.c 2012-02-09 12:30:42.000000000 +0100
> @@ -2067,8 +2067,11 @@ restart:
>                 * with multiple processes reclaiming pages, the total
>                 * freeing target can get unreasonably large.
>                 */
> -               if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
> +               if (nr_reclaimed >= nr_to_reclaim) {
> +                       nr_to_reclaim = 0;
>                        break;
> +               }
> +               nr_to_reclaim -= nr_reclaimed;
>        }
>        blk_finish_plug(&plug);
>        sc->nr_reclaimed += nr_reclaimed;
> @@ -2535,12 +2538,12 @@ static unsigned long balance_pgdat(pg_da
>                 * we want to put equal scanning pressure on each zone.
>                 */
>                .nr_to_reclaim = ULONG_MAX,
> -               .order = order,
>                .mem_cgroup = NULL,
>        };
>        struct shrink_control shrink = {
>                .gfp_mask = sc.gfp_mask,
>        };
> +       sc.order = order = 0;
>  loop_again:
>        total_scanned = 0;
>        sc.nr_reclaimed = 0;
