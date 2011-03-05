Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1CEPfu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 10:35:50 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:29254 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab1CEPft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 10:35:49 -0500
Message-ID: <4D72580D.4000208@gmail.com>
Date: Sat, 05 Mar 2011 18:34:37 +0300
From: Andrew Vagin <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: check zone->all_unreclaimable in all_unreclaimable()
References: <1299325456-2687-1-git-send-email-avagin@openvz.org> <20110305152056.GA1918@barrios-desktop>
In-Reply-To: <20110305152056.GA1918@barrios-desktop>
Content-Type: multipart/mixed;
 boundary="------------060901050701040301010807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060901050701040301010807
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit

On 03/05/2011 06:20 PM, Minchan Kim wrote:
> On Sat, Mar 05, 2011 at 02:44:16PM +0300, Andrey Vagin wrote:
>> Check zone->all_unreclaimable in all_unreclaimable(), otherwise the
>> kernel may hang up, because shrink_zones() will do nothing, but
>> all_unreclaimable() will say, that zone has reclaimable pages.
>>
>> do_try_to_free_pages()
>> 	shrink_zones()
>> 		 for_each_zone
>> 			if (zone->all_unreclaimable)
>> 				continue
>> 	if !all_unreclaimable(zonelist, sc)
>> 		return 1
>>
>> __alloc_pages_slowpath()
>> retry:
>> 	did_some_progress = do_try_to_free_pages(page)
>> 	...
>> 	if (!page&&  did_some_progress)
>> 		retry;
>>
>> Signed-off-by: Andrey Vagin<avagin@openvz.org>
>> ---
>>   mm/vmscan.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 6771ea7..1c056f7 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -2002,6 +2002,8 @@ static bool all_unreclaimable(struct zonelist *zonelist,
>>
>>   	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>>   			gfp_zone(sc->gfp_mask), sc->nodemask) {
>> +		if (zone->all_unreclaimable)
>> +			continue;
>>   		if (!populated_zone(zone))
>>   			continue;
>>   		if (!cpuset_zone_allowed_hardwall(zone, GFP_KERNEL))
>
> zone_reclaimable checks it. Isn't it enough?
I sent one more patch [PATCH] mm: skip zombie in OOM-killer.
This two patches are enough.
> Does the hang up really happen or see it by code review?
Yes. You can reproduce it for help the attached python program. It's not 
very clever:)
It make the following actions in loop:
1. fork
2. mmap
3. touch memory
4. read memory
5. munmmap

>> -- 
>> 1.7.1
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
>> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>


--------------060901050701040301010807
Content-Type: text/plain;
 name="memeater.py"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="memeater.py"

import sys, time, mmap, os
from subprocess import Popen, PIPE
import random

global mem_size

def info(msg):
	pid = os.getpid()
	print >> sys.stderr, "%s: %s" % (pid, msg)
	sys.stderr.flush()



def memory_loop(cmd = "a"):
	"""
	cmd may be:
		c: check memory
		else: touch memory
	"""
	c = 0
	for j in xrange(0, mem_size):
		if cmd == "c":
			if f[j<<12] != chr(j % 255):
				info("Data corruption")
				sys.exit(1)
		else:
			f[j<<12] = chr(j % 255)

while True:
	pid = os.fork()
	if (pid != 0):
		mem_size = random.randint(0, 56 * 4096)
		f = mmap.mmap(-1, mem_size << 12, mmap.MAP_ANONYMOUS|mmap.MAP_PRIVATE)
		memory_loop()
		memory_loop("c")
		f.close()

--------------060901050701040301010807--
