Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1IZOzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:55:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41644 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1IZOzJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:55:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110926142540.GE14333@redhat.com>
References: <1316948380-1879-1-git-send-email-consul.kautuk@gmail.com>
	<20110926112944.GC14333@redhat.com>
	<CAFPAmTQPiHU8AKnQvzMM5KiQr1GnUY+Yf8PwVC6++QK8u149Ew@mail.gmail.com>
	<CAFPAmTQbHhj8wodFEutpstXdQ6Kc2_qRV6Pe69ngHwz1erF29Q@mail.gmail.com>
	<20110926142540.GE14333@redhat.com>
Date: Mon, 26 Sep 2011 20:25:06 +0530
Message-ID: <CAFPAmTTHHk7PWeYRfTHe+g0UwDC4JGYWc8M7_RZ9_poVQGJg6w@mail.gmail.com>
Subject: Re: [patch] mm: remove sysctl to manually rescue unevictable pages
From: "kautuk.c @samsung.com" <consul.kautuk@gmail.com>
To: Johannes Weiner <jweiner@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 7:55 PM, Johannes Weiner <jweiner@redhat.com> wrote:
> On Mon, Sep 26, 2011 at 05:59:39PM +0530, kautuk.c @samsung.com wrote:
>> On Mon, Sep 26, 2011 at 5:40 PM, kautuk.c @samsung.com
>> <consul.kautuk@gmail.com> wrote:
>> > On Mon, Sep 26, 2011 at 4:59 PM, Johannes Weiner <jweiner@redhat.com> wrote:
>> >> On Sun, Sep 25, 2011 at 04:29:40PM +0530, Kautuk Consul wrote:
>> >>> write_scan_unavictable_node checks the value req returned by
>> >>> strict_strtoul and returns 1 if req is 0.
>> >>>
>> >>> However, when strict_strtoul returns 0, it means successful conversion
>> >>> of buf to unsigned long.
>> >>>
>> >>> Due to this, the function was not proceeding to scan the zones for
>> >>> unevictable pages even though we write a valid value to the
>> >>> scan_unevictable_pages sys file.
>> >>
>> >> Given that there is not a real reason for this knob (anymore) and that
>> >> it apparently never really worked since the day it was introduced, how
>> >> about we just drop all that code instead?
>> >>
>> >>        Hannes
>> >>
>> >> ---
>> >> From: Johannes Weiner <jweiner@redhat.com>
>> >> Subject: mm: remove sysctl to manually rescue unevictable pages
>> >>
>> >> At one point, anonymous pages were supposed to go on the unevictable
>> >> list when no swap space was configured, and the idea was to manually
>> >> rescue those pages after adding swap and making them evictable again.
>> >> But nowadays, swap-backed pages on the anon LRU list are not scanned
>> >> without available swap space anyway, so there is no point in moving
>> >> them to a separate list anymore.
>> >
>> > Is this code only for anonymous pages ?
>> > It seems to look at all pages in the zone both file as well as anon.
>> >
>> >>
>> >> The manual rescue could also be used in case pages were stranded on
>> >> the unevictable list due to race conditions.  But the code has been
>> >> around for a while now and newly discovered bugs should be properly
>> >> reported and dealt with instead of relying on such a manual fixup.
>> >
>> > What you say seems to be all right for anon pages, but what about file
>> > pages ?
>> > I'm not sure about how this could happen, but what if some file-system caused
>> > a file cache page to be set to evictable or reclaimable without
>> > actually removing
>> > that page from the unevictable list ?
>>
>> What I would like to also add is that while the transition of an anon
>> page from and
>> to the unevictable lists is straight-forward, should we make the same assumption
>> about file cache pages ?
>
> We should make no assumptions if our code base is open source :-)
>
>> I am not sure about this, but could a file-system cause this kind of a problem
>> independent of the mlocking behaviour of a user-mode app ?
>
> Currently, I only see shmem and ramfs meddling with unevictability
> outside of mlock and they both look correct to me.
>
> I'd say that if a filesystem required this knob and user-intervention
> for the VM to behave correctly, it needs fixing.

Yes I agree. Otherwise that kind of defeats the overall purpose of
open-source. :)

Thanks for review and the info.
