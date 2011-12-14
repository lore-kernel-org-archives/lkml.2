Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1LNHJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:09:53 -0500
Received: from mx2.parallels.com ([64.131.90.16]:45145 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab1LNHJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:09:51 -0500
Message-ID: <4EE84B9A.90901@parallels.com>
Date: Wed, 14 Dec 2011 11:09:14 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
        <jbottomley@parallels.com>, <cgroups@vger.kernel.org>,
        <bsingharora@gmail.com>, <devel@openvz.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/3] make clone_children a flag
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-4-git-send-email-glommer@parallels.com> <20111213153921.GE25802@google.com> <4EE80A0D.7090808@cn.fujitsu.com>
In-Reply-To: <4EE80A0D.7090808@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 06:29 AM, Li Zefan wrote:
> Tejun Heo wrote:
>> On Sun, Dec 11, 2011 at 03:45:37PM +0100, Glauber Costa wrote:
>>> There is no reason to have a flags field, and then a separate
>>> bool field just to indicate if the clone_children flag is set.
>>> Make it a flag
>>>
>>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>>
>> Doesn't this change how remount conditions are checked?
>>

Well, I was thinking it wouldn't, because I patched all callers. But I 
forget life is not always that simple: After you mentioned, I checked 
and we do test for changes in the flag field explicitly on remount. So I 
missed that, indeed.

> Right. Currently we can do this:
>
> 	# mount -t cgroup xxx /mnt
> 	# mount -o remount,clone_children /mnt
>
> with this patch, the above remount will fail.
>
> But..the current bevaiour of remount is a bit confusing in that remount
> with/without "clone_children" has no effect on anything:
>
> 	# mount -t cgroup -o clone_children xxx /mnt
> 	# cat /mnt/cgroup.clone_children
> 	1
> 	# mount -o remount xxx /mnt
> 	# mount | grep cgroup
> 	xxx on /mnt type cgroup (rw,clone_children)
> 	# cat /mnt/cgroup.clone_children
> 	1

That's indeed confusing, and it comes from the fact that we always 
inherit clone_children from the parent - which is sane, IMHO. So this 
flag only has any value in establishing the initial behaviour of the top 
root cgroup. I wonder then if it wouldn't better to just be explicit and 
fail in this case ?

