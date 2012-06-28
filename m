Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab2F1GJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:09:25 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62867 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab2F1GIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:08:48 -0400
Message-ID: <4FEBF4A0.3040303@huawei.com>
Date: Thu, 28 Jun 2012 14:07:28 +0800
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
References: <E061084CB90FCE4F89232A6CF839683B32B52291@SZXEML507-MBS.china.huawei.com> <20120627182903.GP15811@google.com>
In-Reply-To: <20120627182903.GP15811@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.115]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tj@kernel.org wrote:

> On Sun, Jun 24, 2012 at 07:08:07PM +0000, shyju pv wrote:
>> Hi,
>> Observed a crash on 3.5-rc3 with cgroup tests from LTP(Stable April,2012 release)on Dell Inspiron 1526[Intel(R) Core2Duo T7250, MEM 4GB] and also on another x86 quad core target(4GB RAM).
>> LTP test case: cgroup_regression_test.sh(test 4,7 and 9 crashes randomly when the test cases are executed in order)


I wrote thoese test scripts. ;)

>> Shyju
>>
>> [  532.805905] BUG: Dentry ffff8801164db490{i=491b,n=/} still in use (1) [unmount of cgroup cgrou
> 
> Hmm... fa980ca87d "cgroup: superblock can't be released with active
> dentries" is supposed to have fixed that.  Looking into it.
> 


I think I know what happened here:

umount
  deativate_super(sb)
                       dput(subdir)
                         subdir->d_count--
                         d_release(subdir)
                           deactivate_super(sb)
                             shrink_dcache_for_umount(sb)
                               BUG(root->d_count)!!
                         root->d_count--

I use this script to reproduce the bug:

mount -t cgroup -o cpu xxx /mnt
mkdir /mnt/sub
sleep 100 < /mnt/sub &
kill $!
wait $!
umount /mnt

