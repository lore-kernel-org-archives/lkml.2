Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab2F2CUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 22:20:52 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:18732 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab2F2CUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 22:20:50 -0400
Message-ID: <4FED10DB.7040500@huawei.com>
Date: Fri, 29 Jun 2012 10:20:11 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "tj@kernel.org" <tj@kernel.org>
CC: shyju pv <shyju.pv@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>
Subject: Re: 3.5-rc3: BUG: Dentry still in use (1) [unmount of cgroup cgroup]
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com> <20120627182903.GP15811@google.com> <4FEBF4B7.2070105@huawei.com> <20120628180712.GC22641@google.com>
In-Reply-To: <20120628180712.GC22641@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.115]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/6/29 2:07, tj@kernel.org wrote:

> Hello, Li.
> 
> On Thu, Jun 28, 2012 at 02:07:51PM +0800, Li Zefan wrote:
>>> Hmm... fa980ca87d "cgroup: superblock can't be released with active
>>> dentries" is supposed to have fixed that.  Looking into it.
>>>
>>
>>
>> I think I know what happened here:
>>
>> umount
>>   deativate_super(sb)
>>                        dput(subdir)
>>                          subdir->d_count--
>>                          d_release(subdir)
>>                            deactivate_super(sb)
>>                              shrink_dcache_for_umount(sb)
>>                                BUG(root->d_count)!!
>>                          root->d_count--
> 
> Can you please elaborate a bit?  I'm not really following?  Where does
> the last root->d_count-- come from?
> 


>From my limited knowledge about vfs internal, seems the parent's refcnt won't go down
to 0 before its children. When mkdir, the parent's refcnt will be incremented, and
after rmdir, dput(subdir) will drop subdir's refcnt and then drop parent's.

So when dropping the subdir's refcnt and leading the superblock to be killed, the root's
dentry is still > 0.

>> I use this script to reproduce the bug:
>>
>> mount -t cgroup -o cpu xxx /mnt
>> mkdir /mnt/sub
>> sleep 100 < /mnt/sub &
>> kill $!
>> wait $!
>> rmdir /mnt/sub
>> umount /mnt
> 
> Unfortunately, this doesn't reproduce the bug here either. :(
> 


I can reproduce the bug reliably.. Try s/cpu/perf or s/cpu/net_cls, which have fewer
cgroup files?
