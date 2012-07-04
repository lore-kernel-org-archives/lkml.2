Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030217Ab2GDIXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 04:23:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60230 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab2GDIXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 04:23:00 -0400
X-IronPort-AV: E=Sophos;i="4.77,521,1336320000"; 
   d="scan'208";a="5327098"
Message-ID: <4FF3FD7F.5020706@cn.fujitsu.com>
Date: Wed, 04 Jul 2012 16:23:27 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Mel Gorman <mel@csn.ul.ie>, Chris Metcalf -- <cmetcalf@tilera.com>,
        Len Brown -- <lenb@kernel.org>,
        Greg Kroah-Hartman -- <gregkh@linuxfoundation.org>,
        Andi Kleen -- <andi@firstfloor.org>, Julia Lawall -- <julia@diku.dk>,
        David Howells -- <dhowells@redhat.com>,
        Benjamin Herrenschmidt -- <benh@kernel.crashing.org>,
        Kay Sievers -- <kay.sievers@vrfy.org>, Ingo Molnar -- <mingo@elte.hu>,
        Paul Gortmaker -- <paul.gortmaker@windriver.com>,
        Daniel Kiper -- <dkiper@net-space.pl>,
        Andrew Morton -- <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk -- <konrad.wilk@oracle.com>,
        Michal Hocko -- <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki -- <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Nazarewicz -- <mina86@mina86.com>,
        Marek Szyprowski -- <m.szyprowski@samsung.com>,
        Rik van Riel -- <riel@redhat.com>,
        Bjorn Helgaas -- <bhelgaas@google.com>,
        Christoph Lameter -- <cl@linux.com>,
        David Rientjes -- <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/3 V1] mm: add new migrate type and online_movable
 for hotplug
References: <1341386778-8002-1-git-send-email-laijs@cn.fujitsu.com> <CAEwNFnAHVHKtS2o=gEBSMGq8X18T_xFsK6CwxdfYtz1ne6KCQw@mail.gmail.com>
In-Reply-To: <CAEwNFnAHVHKtS2o=gEBSMGq8X18T_xFsK6CwxdfYtz1ne6KCQw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 16:22:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/04 16:23:01,
	Serialize complete at 2012/07/04 16:23:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2012 03:35 PM, Minchan Kim wrote:
> Hello,
> 
> I am not sure when I can review this series by urgent other works.
> At a glance, it seems to attract me.
> But unfortunately, when I read description in cover-letter, I can't
> find "What's the problem?".
> If you provide that, it could help too many your Ccing people who can
> judge  "whether I dive into code or not"

This patchset adds a stable-movable-migrate-type for memory-management,
It is used for anti-fragmentation(hugepage, big-order alloction...) and
hot-removal-of-memory(virtualization, power-conserve, move memory between systems).
it likes ZONE_MOVABLE, but it is more elastic.

Beside it, it fixes some code of CMA.

Thanks,
Lai


> 
> Thanks!
> 
> Side-Note: What's the "--" of email addresses?

Wrong script, I will resent it.

> 
> On Wed, Jul 4, 2012 at 4:26 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>> The 1st patch fixes the allocation of CMA and prepares for movable-like types.
>>
>> The 2nd patch add a new migrate type which stands for the movable types which
>> pages will not be changed to the other type.
>>
>> I chose the name MIGRATE_HOTREMOVE from MIGRATE_HOTREMOVE
>> and MIGRATE_MOVABLE_STABLE, it just because the first usecase of this new type
>> is for hotremove.
>>
>> The 3th path introduces online_movable. When a memoryblock is onlined
>> by "online_movable", the kernel will not have directly reference to the page
>> of the memoryblock, thus we can remove that memory any time when needed.
>>
>> Different from ZONE_MOVABLE: it can be used for any given memroyblock.
>>
>> Lai Jiangshan (3):
>>   use __rmqueue_smallest when borrow memory from MIGRATE_CMA
>>   add MIGRATE_HOTREMOVE type
>>   add online_movable
>>
>>  arch/tile/mm/init.c            |    2 +-
>>  drivers/acpi/acpi_memhotplug.c |    3 +-
>>  drivers/base/memory.c          |   24 +++++++----
>>  include/linux/memory.h         |    1 +
>>  include/linux/memory_hotplug.h |    4 +-
>>  include/linux/mmzone.h         |   37 +++++++++++++++++
>>  include/linux/page-isolation.h |    2 +-
>>  mm/compaction.c                |    6 +-
>>  mm/memory-failure.c            |    8 +++-
>>  mm/memory_hotplug.c            |   36 +++++++++++++---
>>  mm/page_alloc.c                |   86 ++++++++++++++++-----------------------
>>  mm/vmstat.c                    |    3 +
>>  12 files changed, 136 insertions(+), 76 deletions(-)
>>
>> --
>> 1.7.4.4
>>
> 
> 
> 

