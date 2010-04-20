Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0DTOlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:41:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754912Ab0DTOk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:40:59 -0400
Message-ID: <4BCDBCC4.60401@redhat.com>
Date: Tue, 20 Apr 2010 10:40:04 -0400
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
References: <20100322235053.GD9590@csn.ul.ie> <4BA940E7.2030308@redhat.com> <20100324145028.GD2024@csn.ul.ie> <4BCC4B0C.8000602@linux.vnet.ibm.com> <20100419214412.GB5336@cmpxchg.org>
In-Reply-To: <20100419214412.GB5336@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 05:44 PM, Johannes Weiner wrote:

> What do people think?

It has potential advantages and disadvantages.

On smaller desktop systems, it is entirely possible that
the working set is close to half of the page cache.  Your
patch reduces the amount of memory that is protected on
the active file list, so it may cause part of the working
set to get evicted.

On the other hand, having a smaller active list frees up
more memory for sequential (streaming, use-once) disk IO.
This can be useful on systems with large IO subsystems
and small memory (like Christian's s390 virtual machine,
with 256MB RAM and 4 disks!).

I wonder if we could not find some automatic way to
balance between these two situations, for example by
excluding currently-in-flight pages from the calculations.

In Christian's case, he could have 160MB of cache (buffer
+ page cache), of which 70MB is in flight to disk at a
time.  It may be worthwhile to exclude that 70MB from the
total and aim for 45MB active file and 45MB inactive file
pages on his system.  That way IO does not get starved.

On a desktop system, which needs the working set protected
and does less IO, we will automatically protect more of
the working set - since there is no IO to starve.
