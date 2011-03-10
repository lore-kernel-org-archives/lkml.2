Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab1CJODB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:03:01 -0500
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:53479 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1CJODA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:03:00 -0500
Message-ID: <4D78DA0F.4000001@linux.vnet.ibm.com>
Date: Thu, 10 Mar 2011 15:02:55 +0100
From: Mustafa Mesanovic <mume@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
CC: Neil Brown <neilb@suse.de>, akpm@linux-foundation.org, cotte@de.ibm.com,
        heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
        ehrhardt@linux.vnet.ibm.com, "Alasdair G. Kergon" <agk@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3] dm stripe: implement merge method
References: <201012271219.56476.mume@linux.vnet.ibm.com> <20101227225459.5a5150ab@notabene.brown> <201012271323.13406.mume@linux.vnet.ibm.com> <4D74AEF9.7050108@linux.vnet.ibm.com> <20110308022158.GA663@redhat.com> <4D76051E.5060303@linux.vnet.ibm.com> <20110308164849.GA5692@redhat.com>
In-Reply-To: <20110308164849.GA5692@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 05:48 PM, Mike Snitzer wrote:
> On Tue, Mar 08 2011 at  5:29am -0500,
> Mustafa Mesanovic<mume@linux.vnet.ibm.com>  wrote:
>
>> On 03/08/2011 03:21 AM, Mike Snitzer wrote:
>>
>>> Here is a revised version of your patch that uses the relatively new
>>> stripe_map_sector(), removes an unnecessary cast, and a few other
>>> cleanups.
>>>
>>> This v3 should work as well as your v2 but should be suitable for
>>> upstream inclusion -- authorship of the change is still attributed to
>>> you as I only updated the code slightly.  I'd appreciate it if you could
>>> verify your config still performs as expected.
>> Mike,
>>
>> your changes are working well and performing even a bit better.
> Good to know.
>
>> Are there any further comments from others, or can consider putting it
>> upstream.
> I chatted with Alasdair and one concern he had was: does the existence
> of stripe_merge() ever hurt due to the fact that stripe_map_sector() is
> performed twice (once for .merge and again for .map)?  May be that a
> really small chuck_size proves to be more problematic but using a small
> chunk_size generally isn't productive to begin with.
>
> In any case, it clearly helps your workload.
>
> Could you explain your config in more detail?
> - what is your chunk_size?
> - how many stripes (how many mpath devices)?
> - what is the performance, of your test workload, of a single underlying
>    mpath device?
>
> And, in particular, what is your test workload?
> - What is the nature of your IO (are you using a particular tool)?
> - Are you using AIO?
> - How many threads?
> - Are you driving deep queue depths? Etc.
>
> I have various configs that I'll be testing to help verify the benefit.
> The only other change Alasdair request is that the target version should
> be bumped to 1.4 (rather than 1.3.2).
>
> Given that I can put some time to this now: we should be able to sort
> all this out for upstream inclusion in 2.6.39.
>
> Thanks,
> Mike
Mike,

the setup that I have used to verify and check upon the changes
consisted of:

- Benchmark
iozone (seq write, seq read, random read and write),
filesize 2000m, with 32 processes (no AIO used).

- Disk-Setup
2 disks (queue_depth=192) ->  each disk with 8 paths
->  multipathed (multibus, rr_min_io=1)

And a striped LVM out of these two (chunk_size=64KiB).

The benchmark then runs on this LV.

In detail: I was previosly working on a 2.6.32.x-stable kernel, thats
where I created the stripe_merge function for. There I have seen
improvements up to 3x ->  ~600MiB ->  ~1800MiB

With the git-kernel only 1.25x better when applying the patch, but its still
significantly better!

   ~990MiB ->  ~1300MiB

A single mpath device has ~1300MiB throughput.

Regards,
Mustafa

