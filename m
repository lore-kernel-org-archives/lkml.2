Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834Ab2FUTGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:06:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759696Ab2FUTGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:06:52 -0400
Message-ID: <4FE35F4E.3080002@redhat.com>
Date: Thu, 21 Jun 2012 13:52:14 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, aarcange@redhat.com, peterz@infradead.org,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 4/7] mm: make page colouring code generic
References: <1340057126-31143-1-git-send-email-riel@redhat.com> <1340057126-31143-5-git-send-email-riel@redhat.com> <20120619162747.fa31c86a.akpm@linux-foundation.org>
In-Reply-To: <20120619162747.fa31c86a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 07:27 PM, Andrew Morton wrote:
> On Mon, 18 Jun 2012 18:05:23 -0400
> Rik van Riel<riel@redhat.com>  wrote:
>
>> From: Rik van Riel<riel@surriel.com>
>>
>> Fix the x86-64 page colouring code to take pgoff into account.
>
> Could we please have a full description of what's wrong with the
> current code?

Here is a copy of the text I added to the changelog:


The old x86 code will always align the mmap
to aliasing boundaries, even if the program mmaps
the file with a non-zero pgoff.

If program A mmaps the file with pgoff 0, and
program B mmaps the file with pgoff 1. The old
code would align the mmaps, resulting in misaligned
pages:

A:  0123
B:  123

After this patch, they are aligned so the pages
line up:

A: 0123
B:  123

>> Use the x86 and MIPS page colouring code as the basis for a generic
>> page colouring function.

Renamed to "cache alignment", by Andi's request.

>> Teach the generic arch_get_unmapped_area(_topdown) code to call the
>> page colouring code.
>>
>> Make sure that ALIGN_DOWN always aligns down, and ends up at the
>> right page colour.
>
> Some performance tests on the result would be interesting.  iirc, we've
> often had trouble demonstrating much or any benefit from coloring.

On AMD Bulldozer, I do not know what the benefits are.

On ARM, MIPS, SPARC and SH, the main benefit is avoiding
data corruption :)

These architectures have VIPT caches on some CPU models,
and MAP_SHARED read-write mappings have to be properly
aligned to guarantee data consistency.

