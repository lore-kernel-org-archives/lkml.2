Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab1KWCB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 21:01:56 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63604 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1KWCBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 21:01:55 -0500
MIME-Version: 1.0
In-Reply-To: <1321945011.22361.335.camel@sli10-conroe>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
	<1321900608-27687-8-git-send-email-mgorman@suse.de>
	<1321945011.22361.335.camel@sli10-conroe>
Date: Wed, 23 Nov 2011 10:01:53 +0800
Message-ID: <CAPQyPG4DQCxDah5VYMU6PNgeuD_3WJ-zm8XpL7V7BK8hAF8OJg@mail.gmail.com>
Subject: Re: [PATCH 7/7] mm: compaction: Introduce sync-light migration for
 use by compaction
From: Nai Xia <nai.xia@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 2:56 PM, Shaohua Li <shaohua.li@intel.com> wrote:
> On Tue, 2011-11-22 at 02:36 +0800, Mel Gorman wrote:
>> This patch adds a lightweight sync migrate operation MIGRATE_SYNC_LIGHT
>> mode that avoids writing back pages to backing storage. Async
>> compaction maps to MIGRATE_ASYNC while sync compaction maps to
>> MIGRATE_SYNC_LIGHT. For other migrate_pages users such as memory
>> hotplug, MIGRATE_SYNC is used.
>>
>> This avoids sync compaction stalling for an excessive length of time,
>> particularly when copying files to a USB stick where there might be
>> a large number of dirty pages backed by a filesystem that does not
>> support ->writepages.
> Hi,
> from my understanding, with this, even writes
> to /proc/sys/vm/compact_memory doesn't wait for pageout, is this
> intended?
> on the other hand, MIGRATE_SYNC_LIGHT now waits for pagelock and buffer
> lock, so could wait on page read. page read and page out have the same
> latency, why takes them different?

So for the problem you raised, I think my suggestion to Mel is to adopt the
following logic:

           if (!trylock_page(page) && !PageUptodate(page))
                      we are quite likely to block on read, so we
                      depend on yet another MIGRATE_SYNC_MODE to decide
                      if we really want to lock_page() and wait for this IO.

How do you think ?


Thanks,

Nai
>
> Thanks,
> Shaohua
>
>
