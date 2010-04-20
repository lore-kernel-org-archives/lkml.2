Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0DTRXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:23:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab0DTRXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:23:44 -0400
Message-ID: <4BCDE2F0.3010009@redhat.com>
Date: Tue, 20 Apr 2010 13:22:56 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       gregkh@novell.com, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [RFC PATCH 0/3] Avoid the use of congestion_wait under zone pressure
References: <20100322235053.GD9590@csn.ul.ie> <4BA940E7.2030308@redhat.com> <20100324145028.GD2024@csn.ul.ie> <4BCC4B0C.8000602@linux.vnet.ibm.com> <20100419214412.GB5336@cmpxchg.org> <4BCD55DA.2020000@linux.vnet.ibm.com> <20100420153202.GC5336@cmpxchg.org>
In-Reply-To: <20100420153202.GC5336@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 11:32 AM, Johannes Weiner wrote:

> The idea is that it pans out on its own.  If the workload changes, new
> pages get activated and when that set grows too large, we start shrinking
> it again.
>
> Of course, right now this unscanned set is way too large and we can end
> up wasting up to 50% of usable page cache on false active pages.

Thing is, changing workloads often change back.

Specifically, think of a desktop system that is doing
work for the user during the day and gets backed up
at night.

You do not want the backup to kick the working set
out of memory, because when the user returns in the
morning the desktop should come back quickly after
the screensaver is unlocked.

The big question is, what workload suffers from
having the inactive list at 50% of the page cache?

So far the only big problem we have seen is on a
very unbalanced virtual machine, with 256MB RAM
and 4 fast disks.  The disks simply have more IO
in flight at once than what fits in the inactive
list.

This is a very untypical situation, and we can
probably solve it by excluding the in-flight pages
from the active/inactive file calculation.
