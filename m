Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2F3GOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 02:14:00 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:1787 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab2F3GN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 02:13:59 -0400
Message-ID: <4FEE98EE.1050409@huawei.com>
Date: Sat, 30 Jun 2012 14:13:02 +0800
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
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com> <20120627182903.GP15811@google.com> <4FEBF4B7.2070105@huawei.com> <20120628180712.GC22641@google.com> <4FED10DB.7040500@huawei.com> <20120629165809.GB21048@google.com>
In-Reply-To: <20120629165809.GB21048@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.115]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/6/30 0:58, tj@kernel.org wrote:

> Hey,
> 
> On Fri, Jun 29, 2012 at 10:20:11AM +0800, Li Zefan wrote:
>>> Can you please elaborate a bit?  I'm not really following?  Where does
>>> the last root->d_count-- come from?
>>
>>
>> From my limited knowledge about vfs internal, seems the parent's refcnt won't go down
>> to 0 before its children. When mkdir, the parent's refcnt will be incremented, and
>> after rmdir, dput(subdir) will drop subdir's refcnt and then drop parent's.
>>
>> So when dropping the subdir's refcnt and leading the superblock to be killed, the root's
>> dentry is still > 0.
> 
> Heh, yeah, I thought you found who was holding out on the refcnt. :)
> 


dput will drop both the subdir and the root's dentry refcnt, but kill_sb will be called
inbetween.

So it's bad to have dentry refcnts dangling after umount. I've made a patch so css will
pin cgroup instead of cgroup dentry.

