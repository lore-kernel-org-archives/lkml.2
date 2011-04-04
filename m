Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab1DDNPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:15:14 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40542 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1DDNPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=HPlOJf3BaoeHHYqCjXCatMNIA0huHAG5tqlfCDfImPr+oFySanxOcRpFpVatd/EHCR
         vMgONNe3kWw6XD0Ckk5M3jJOz0TV+0Ys5e0MECIp4kDQXkxUu+CykaThwzpHWh6ynYV3
         Ft6XuuD+msgUwX4LQWmLhbjabWQklFaNLffpA=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Johan MOSSBERG" <johan.xx.mossberg@stericsson.com>,
        "Mel Gorman" <mel@csn.ul.ie>, "Pawel Osciak" <pawel@osciak.com>
Subject: Re: [PATCH 04/12] mm: alloc_contig_freed_pages() added
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
 <1301577368-16095-5-git-send-email-m.szyprowski@samsung.com>
 <1301587083.31087.1032.camel@nimitz> <op.vs77qfx03l0zgt@mnazarewicz-glaptop>
 <1301606078.31087.1275.camel@nimitz> <op.vs8awkrx3l0zgt@mnazarewicz-glaptop>
 <1301610411.30870.29.camel@nimitz> <op.vs8cf5xd3l0zgt@mnazarewicz-glaptop>
 <1301666596.30870.176.camel@nimitz>
Date: Mon, 04 Apr 2011 15:15:07 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vte0fgez3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1301666596.30870.176.camel@nimitz>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2011-04-01 at 00:51 +0200, Michal Nazarewicz wrote:
>> The function is called from alloc_contig_range() (see patch 05/12) which
>> makes sure that the PFN is valid.  Situation where there is not enough
>> space is caught earlier in alloc_contig_range().
>>
>> alloc_contig_freed_pages() must be given a valid PFN range such that all
>> the pages in that range are free (as in are within the region tracked by
>> page allocator) and of MIGRATE_ISOLATE so that page allocator won't
>> touch them.

On Fri, 01 Apr 2011 16:03:16 +0200, Dave Hansen wrote:
> OK, so it really is a low-level function only.  How about a comment that
> explicitly says this?  "Only called from $FOO with the area already
> isolated."  It probably also deserves an __ prefix.

Yes, it's not really for general use.  Comment may indeed be useful here.

>> That's why invalid PFN is a bug in the caller and not an exception that
>> has to be handled.
>>
>> Also, the function is not called during boot time.  It is called while
>> system is already running.

> What kind of success have you had running this in practice?  I'd be
> worried that some silly task or a sticky dentry would end up in the
> range that you want to allocate in.

I'm not sure what you are asking.

The function requires the range to be marked as MIGRATE_ISOLATE and all
pages being free, so nothing can be allocated there while the function
is running.

If you are asking about CMA in general, the range that CMA uses is marked
as MIGRATE_CMA (a new migrate type) which means that only MIGRATE_MOVABLE
pages can be allocated there.  This means, that in theory, if there is
enough memory the pages can always be moved out of the region.  At leasts
that's my understanding of the type.  If this is correct, the allocation
should always succeed provided enough memory for the pages within the
region to be moved to is available.

As of practice, I have run some simple test to see if the code works and
they succeeded.  Also, Marek has run some test with actual hardware and
those worked well as well (but I'll let Marek talk about any details).

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
