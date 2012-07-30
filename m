Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2G3OJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:09:37 -0400
Received: from mx2.parallels.com ([64.131.90.16]:42859 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab2G3OJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:09:35 -0400
Message-ID: <50169593.5020506@parallels.com>
Date: Mon, 30 Jul 2012 18:09:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, <devel@openvz.org>,
        <cgroups@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 04/10] memcg: skip memcg kmem allocations in specified
 code regions
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-5-git-send-email-glommer@parallels.com> <20120730125004.GA27293@shutemov.name>
In-Reply-To: <20120730125004.GA27293@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2012 04:50 PM, Kirill A. Shutemov wrote:
> On Wed, Jul 25, 2012 at 06:38:15PM +0400, Glauber Costa wrote:
>> This patch creates a mechanism that skip memcg allocations during
>> certain pieces of our core code. It basically works in the same way
>> as preempt_disable()/preempt_enable(): By marking a region under
>> which all allocations will be accounted to the root memcg.
>>
>> We need this to prevent races in early cache creation, when we
>> allocate data using caches that are not necessarily created already.
> 
> Why not a GFP_* flag?
> 

The main reason for this is to prevent nested calls of
kmem_cache_create(), since they could create (and in my tests, do
create) funny circular dependencies with each other. So the cache
creation itself would proceed without involving memcg.

At first, it is a bit weird to have cache creation itself depending on a
allocation flag test.
