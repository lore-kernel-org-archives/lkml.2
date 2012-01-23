Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2AWKex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 05:34:53 -0500
Received: from mx2.parallels.com ([64.131.90.16]:44381 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab2AWKew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 05:34:52 -0500
Message-ID: <4F1D3792.4090800@parallels.com>
Date: Mon, 23 Jan 2012 14:33:54 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH] proc:  speedup /proc/stat handling
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20120123191643.21ffba0c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120123191643.21ffba0c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 02:16 PM, KAMEZAWA Hiroyuki wrote:
> On Fri, 20 Jan 2012 16:59:24 +0100
> Eric Dumazet<eric.dumazet@gmail.com>  wrote:
>
>> On a typical 16 cpus machine, "cat /proc/stat" gives more than 4096
>> bytes, and is slow :
>>
>> # strace -T -o /tmp/STRACE cat /proc/stat | wc -c
>> 5826
>> # grep "cpu " /tmp/STRACE
>> read(0, "cpu  1949310 19 2144714 12117253"..., 32768) = 5826<0.001504>
>>
>>
>> Thats partly because show_stat() must be called twice since initial
>> buffer size is too small (4096 bytes for less than 32 possible cpus)
>>
>> Fix this by :
>>
>> 1) Taking into account nr_irqs in the initial buffer sizing.
>>
>> 2) Using ksize() to allow better filling of initial buffer.
>>
>> 3) Reduce the bloat on "intr ..." line :
>>     Dont output trailing " 0" values at the end of irq range.
>>
>> An alternative to 1) would be to remember the largest m->count reached
>> in show_stat()
>>
>
> nice catch. But how about using usual seq_file rather than single_open() ?
> I just don't like multi-page buffer for this small file...very much.
>
> A rough patch here, maybe optimization will not be enough. (IOW, this may be slow.)
>

I myself don't like it very much, at least at first sight.
Even with optimizations applied, I doubt we can make this approach 
faster than what we currently do for /proc/stat.

Also, the code gets a lot harder to read and grasp. Problem is, unlike 
most of the stuff using seq_file, /proc/stat shows a lot of different 
kinds of information, not a single kind of easily indexable information.


