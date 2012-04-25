Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab2DYObR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:31:17 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58867 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab2DYObQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:31:16 -0400
Message-ID: <4F980A42.6040308@parallels.com>
Date: Wed, 25 Apr 2012 11:29:22 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <fweisbec@gmail.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 16/23] slab: provide kmalloc_no_account
References: <1334959051-18203-1-git-send-email-glommer@parallels.com> <1335138820-26590-5-git-send-email-glommer@parallels.com> <4F975703.3080005@jp.fujitsu.com>
In-Reply-To: <4F975703.3080005@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.19.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 10:44 PM, KAMEZAWA Hiroyuki wrote:
> (2012/04/23 8:53), Glauber Costa wrote:
> 
>> Some allocations need to be accounted to the root memcg regardless
>> of their context. One trivial example, is the allocations we do
>> during the memcg slab cache creation themselves. Strictly speaking,
>> they could go to the parent, but it is way easier to bill them to
>> the root cgroup.
>>
>> Only generic kmalloc allocations are allowed to be bypassed.
>>
>> The function is not exported, because drivers code should always
>> be accounted.
>>
>> This code is mosly written by Suleiman Souhlal.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: Christoph Lameter<cl@linux.com>
>> CC: Pekka Enberg<penberg@cs.helsinki.fi>
>> CC: Michal Hocko<mhocko@suse.cz>
>> CC: Kamezawa Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Johannes Weiner<hannes@cmpxchg.org>
>> CC: Suleiman Souhlal<suleiman@google.com>
> 
> 
> Seems reasonable.
> Reviewed-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> 
> Hmm...but can't we find the 'context' in automatic way ?
> 

Not that I can think of. Well, actually, not without adding some tests
to the allocation path I'd rather not (like testing for the return
address and then doing a table lookup, etc)

An option would be to store it in the task_struct. So we would allocate
as following:

memcg_skip_account_start(p);
do_a_bunch_of_allocations();
memcg_skip_account_stop(p);

The problem with that, is that it is quite easy to abuse.
but if we don't export that to modules, it would be acceptable.

Question is, given the fact that the number of kmalloc_no_account() is
expected to be really small, is it worth it?



