Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab1ESADs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 20:03:48 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43428 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1ESADp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 20:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HPJ7FDQBaoPIos8QlkJb94sjVKLL+U4a9q1EkNKUAaDrOynz9HuiyzveEehCC4r9Qg
         qubb7uQZRypD6pa3MsPbGticiTuy/Bs+qOuUKWPOc9HYMS7FyDXlmwTKtgGR7BaPpdVP
         0UUAoeNVbjph0ZpPxV6NSZDVgIbO2+Uw8Gs+4=
MIME-Version: 1.0
In-Reply-To: <20110517161508.GN5279@suse.de>
References: <1305295404-12129-5-git-send-email-mgorman@suse.de>
	<4DCFAA80.7040109@jp.fujitsu.com>
	<1305519711.4806.7.camel@mulgrave.site>
	<BANLkTi=oe4Ties6awwhHFPf42EXCn2U4MQ@mail.gmail.com>
	<20110516084558.GE5279@suse.de>
	<BANLkTinW4s6aT2bZ79sHNgdh5j8VYyJz2w@mail.gmail.com>
	<20110516102753.GF5279@suse.de>
	<BANLkTi=5ON_ttuwFFhFObfoP8EBKPdFgAA@mail.gmail.com>
	<20110517103840.GL5279@suse.de>
	<1305640239.2046.27.camel@lenovo>
	<20110517161508.GN5279@suse.de>
Date: Thu, 19 May 2011 09:03:44 +0900
Message-ID: <BANLkTimfKwJWgiDp7m8WqeUK00N5sV=mWQ@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: Correctly check if reclaimer should schedule
 during shrink_slab
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: akpm@linux-foundation.org, Colin Ian King <colin.king@canonical.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        raghu.prabhu13@gmail.com, jack@suse.cz, chris.mason@oracle.com,
        cl@linux.com, penberg@kernel.org, riel@redhat.com, hannes@cmpxchg.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 1:15 AM, Mel Gorman <mgorman@suse.de> wrote:
> It has been reported on some laptops that kswapd is consuming large
> amounts of CPU and not being scheduled when SLUB is enabled during
> large amounts of file copying. It is expected that this is due to
> kswapd missing every cond_resched() point because;
>
> shrink_page_list() calls cond_resched() if inactive pages were isolated
>        which in turn may not happen if all_unreclaimable is set in
>        shrink_zones(). If for whatver reason, all_unreclaimable is
>        set on all zones, we can miss calling cond_resched().
>
> balance_pgdat() only calls cond_resched if the zones are not
>        balanced. For a high-order allocation that is balanced, it
>        checks order-0 again. During that window, order-0 might have
>        become unbalanced so it loops again for order-0 and returns
>        that it was reclaiming for order-0 to kswapd(). It can then
>        find that a caller has rewoken kswapd for a high-order and
>        re-enters balance_pgdat() without ever calling cond_resched().
>
> shrink_slab only calls cond_resched() if we are reclaiming slab
>        pages. If there are a large number of direct reclaimers, the
>        shrinker_rwsem can be contended and prevent kswapd calling
>        cond_resched().
>
> This patch modifies the shrink_slab() case. If the semaphore is
> contended, the caller will still check cond_resched(). After each
> successful call into a shrinker, the check for cond_resched() is
> still necessary in case one shrinker call is particularly slow.
>
> This patch replaces
> mm-vmscan-if-kswapd-has-been-running-too-long-allow-it-to-sleep.patch
> in -mm.
>
> [mgorman@suse.de: Preserve call to cond_resched after each call into shrinker]
> From: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

-- 
Kind regards,
Minchan Kim
