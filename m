Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0JSChc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 22:37:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38780 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab0JSCh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 22:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=L+5ufpKQLuB2j9sRBJjqTPjsFbjXf75SgUI6sJqZM8nFoDwOf9Ckm0/7j0/pQ4cDGG
         i9TAjJB3QuuHYti3bTrnVg6g9Qz87obbafl/Y59WHpriW5OdCJ3E76cdW4dA5NJLW9mp
         WnAG3faH/APSX2sDVceQynQa6CEWbyKHb/FyQ=
MIME-Version: 1.0
In-Reply-To: <20101019022451.GA8310@localhost>
References: <20100915091118.3dbdc961@notabene>
	<4C90139A.1080809@redhat.com>
	<20100915122334.3fa7b35f@notabene>
	<20100915082843.GA17252@localhost>
	<20100915184434.18e2d933@notabene>
	<20101018151459.2b443221@notabene>
	<20101018161504.GB29500@localhost>
	<20101018145859.eee1ae33.akpm@linux-foundation.org>
	<20101019093142.509d6947@notabene>
	<20101018154137.90f5325f.akpm@linux-foundation.org>
	<20101019022451.GA8310@localhost>
Date: Tue, 19 Oct 2010 11:37:29 +0900
Message-ID: <AANLkTimEjJu6Eo6VmaCyuDNpen66SeZGyV84GOcc9TV1@mail.gmail.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 11:24 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Tue, Oct 19, 2010 at 06:41:37AM +0800, Andrew Morton wrote:
>> On Tue, 19 Oct 2010 09:31:42 +1100
>> Neil Brown <neilb@suse.de> wrote:
>>
>> > On Mon, 18 Oct 2010 14:58:59 -0700
>> > Andrew Morton <akpm@linux-foundation.org> wrote:
>> >
>> > > On Tue, 19 Oct 2010 00:15:04 +0800
>> > > Wu Fengguang <fengguang.wu@intel.com> wrote:
>> > >
>> > > > Neil find that if too_many_isolated() returns true while performing
>> > > > direct reclaim we can end up waiting for other threads to complete their
>> > > > direct reclaim.  If those threads are allowed to enter the FS or IO to
>> > > > free memory, but this thread is not, then it is possible that those
>> > > > threads will be waiting on this thread and so we get a circular
>> > > > deadlock.
>> > > >
>> > > > some task enters direct reclaim with GFP_KERNEL
>> > > >   => too_many_isolated() false
>> > > >     => vmscan and run into dirty pages
>> > > >       => pageout()
>> > > >         => take some FS lock
>> > > >           => fs/block code does GFP_NOIO allocation
>> > > >             => enter direct reclaim again
>> > > >               => too_many_isolated() true
>> > > >                 => waiting for others to progress, however the other
>> > > >                    tasks may be circular waiting for the FS lock..
>>
>> I'm assuming that the last four "=>"'s here should have been indented
>> another stop.
>
> Yup. I'll fix it in next post.
>
>> > > > The fix is to let !__GFP_IO and !__GFP_FS direct reclaims enjoy higher
>> > > > priority than normal ones, by honouring them higher throttle threshold.
>> > > >
>> > > > Now !GFP_IOFS reclaims won't be waiting for GFP_IOFS reclaims to
>> > > > progress. They will be blocked only when there are too many concurrent
>> > > > !GFP_IOFS reclaims, however that's very unlikely because the IO-less
>> > > > direct reclaims is able to progress much more faster, and they won't
>> > > > deadlock each other. The threshold is raised high enough for them, so
>> > > > that there can be sufficient parallel progress of !GFP_IOFS reclaims.
>> > >
>> > > I'm not sure that this is really a full fix.  Torsten's analysis does
>> > > appear to point at the real bug: raid1 has code paths which allocate
>> > > more than a single element from a mempool without starting IO against
>> > > previous elements.
>> >
>> > ... point at "a" real bug.
>> >
>> > I think there are two bugs here.
>> > The raid1 bug that Torsten mentions is certainly real (and has been around
>> > for an embarrassingly long time).
>> > The bug that I identified in too_many_isolated is also a real bug and can be
>> > triggered without md/raid1 in the mix.
>> > So this is not a 'full fix' for every bug in the kernel :-),
>
>> > but it could well be a full fix for this particular bug.
>
> Yeah it aims to be a full fix for one bug.
>
>> Can we just delete the too_many_isolated() logic?  (Crappy comment
>
> If the two cond_resched() calls can be removed from
> shrink_page_list(), the major cause of too many pages being
> isolated will be gone. However the writeback-waiting logic after
> should_reclaim_stall() will also block the direct reclaimer for long
> time with pages isolated, which may bite under pathological conditions.
>
>> describes what the code does but not why it does it).
>
> Good point. The comment could be improved as follows.
>
> Thanks,
> Fengguang
>
> ---
> Subject: vmscan: comment too_many_isolated()
> From: Wu Fengguang <fengguang.wu@intel.com>
> Date: Tue Oct 19 09:53:23 CST 2010
>
> Comment "Why it's doing so" rather than "What it does"
> as proposed by Andrew Morton.
>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>



-- 
Kind regards,
Minchan Kim
