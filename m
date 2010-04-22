Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab0DVALI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 20:11:08 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33958 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0DVALH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 20:11:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fER5R6bAmujLsUpT/6wF42bYe8NPzmT8ey29MyaDhmCh4Rnow1uYI852zc9OspH81h
         A/hc8+uhe3GsBbBWTCBvrOE8mYI9dZbauCMiCZY1ytvyHabB+/T0kY7/e4fmvj8YVj/O
         aYpk3qXDqbIXTrNg8g6XaM/v/kF0x7gp6cCsQ=
MIME-Version: 1.0
In-Reply-To: <20100422085943.3d908a4b.kamezawa.hiroyu@jp.fujitsu.com>
References: <1271797276-31358-1-git-send-email-mel@csn.ul.ie>
	 <1271797276-31358-5-git-send-email-mel@csn.ul.ie>
	 <alpine.DEB.2.00.1004210927550.4959@router.home>
	 <20100422085943.3d908a4b.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 22 Apr 2010 09:11:04 +0900
Message-ID: <t2l28c262361004211711v728b50e5h91e0b3bb94dcef4b@mail.gmail.com>
Subject: Re: [PATCH 04/14] mm,migration: Allow the migration of PageSwapCache 
	pages
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 8:59 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 21 Apr 2010 09:30:20 -0500 (CDT)
> Christoph Lameter <cl@linux-foundation.org> wrote:
>
>> On Tue, 20 Apr 2010, Mel Gorman wrote:
>>
>> > @@ -520,10 +521,12 @@ static int move_to_new_page(struct page *newpage, struct page *page)
>> >     else
>> >             rc = fallback_migrate_page(mapping, newpage, page);
>> >
>> > -   if (!rc)
>> > -           remove_migration_ptes(page, newpage);
>> > -   else
>> > +   if (rc) {
>> >             newpage->mapping = NULL;
>> > +   } else {
>> > +           if (remap_swapcache)
>> > +                   remove_migration_ptes(page, newpage);
>> > +   }
>>
>> You are going to keep the migration ptes after the page has been unlocked?
>> Or is remap_swapcache true if its not a swapcache page?
>>
>> Maybe you meant
>>
>> if (!remap_swapcache)
>>
>
> Ah....Can I confirm my understanding ?
>
> remap_swapcache == true only when
>  The old page was ANON && it is not mapped. && it is SwapCache.
>
> We do above check under lock_page(). So, this SwapCache is never mapped until
> we release lock_page() on the old page. So, we don't use migration_pte in
> this case because try_to_unmap() do nothing and don't need to call
> remove_migration_pte().

Yes. so I thought what kinds of race happened.
Firstly I doubt fork and migration. but It isn't.
I can't understand how this bug happens.
Apparently, We have been missed something.
I will look into this further.


-- 
Kind regards,
Minchan Kim
