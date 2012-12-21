Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab2LUWA5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:00:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19341 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab2LUWAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:00:54 -0500
Message-ID: <50D4DBC8.2020008@oracle.com>
Date: Fri, 21 Dec 2012 16:59:36 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH v2] mm,ksm: use new hashtable implementation
References: <1356112012-24584-1-git-send-email-sasha.levin@oracle.com> <20121221133610.bb516813.akpm@linux-foundation.org>
In-Reply-To: <20121221133610.bb516813.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 04:36 PM, Andrew Morton wrote:
> On Fri, 21 Dec 2012 12:46:50 -0500
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> Switch ksm to use the new hashtable implementation. This reduces the amount of
>> generic unrelated code in the ksm module.
> 
> hm, include/linux/hashtable.h:hash_min() is rather dangerous - it
> returns different values depending on the size of the first argument. 
> So if the calling code mixes up its ints and longs (and boy we do that
> a lot), the result will work on 32-bit and fail on 64-bit.

The reason for doing so is because hashing 32 bits is much faster than
hashing 64 bits.

I'd really prefer to fix the code the mixes up ints and longs instead
of removing optimizations. Not only because of the optimizations themselves
but because these mixups will be rather obvious with the hashtable as
opposed to all the other places that just misbehave silently.

> Also, is there ever likely to be a situation where the first arg to
> hash_min() is *not* a pointer?  Perhaps it would be better to concede
> to reality: rename `key' to `ptr' and remove all those typcasts you
> just added.

There actually are several. This is the reason for hash_min really - several
places that used 32bit keys would have been slowed down by switch to
hash_long(), which is why hash_min() was introduced.

The first places that come to mind are userns, 9p and tracepoints, I guess
there are a few more which I don't remember.


Thanks,
Sasha
