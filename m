Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1ISQKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:10:20 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45360 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab1ISQKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:10:18 -0400
Message-ID: <4E776937.1070108@parallels.com>
Date: Mon, 19 Sep 2011 13:09:27 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <mingo@elte.hu>, <jbottomley@parallels.com>
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>  <1316030695-19826-2-git-send-email-glommer@parallels.com> <1316448186.1511.19.camel@twins>
In-Reply-To: <1316448186.1511.19.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [187.106.51.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2011 01:03 PM, Peter Zijlstra wrote:
> On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
>> +       for (; ca; ca = parent_ca(ca)) {
>
> It might be good to check that the loop condition and null condition in
> the parent_ca() function get folded. Otherwise there's a double branch
> in that loop.
>
> Note that this function is one of the reasons I dislike cpuacct, it adds
> a second cgroup hierarchy traversal to every context switch.
>
Well, it is not that hard to optimize this.

Those values are always updated, but they don't really need to, unless 
they are read.

So what we can do, is introduce a marker in the cgroup, representing the 
last read value. Parent is untouched. We then update parent when 1) 
reading this value, 2) cgroup destroy, 3) cpu hotplug. (humm, and maybe 
we don't even need to do it in cpu hotplug, since the per-cpu variables 
will still be accessible... )

How about it ?
