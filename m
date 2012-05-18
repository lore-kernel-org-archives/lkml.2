Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966268Ab2ERS3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 14:29:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33542 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030Ab2ERS3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 14:29:18 -0400
MIME-Version: 1.0
In-Reply-To: <20120518175548.GM19388@google.com>
References: <20120330223423.GJ28934@google.com> <20120330223606.GK28934@google.com>
 <4F77B6BA.4070207@huawei.com> <20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com> <20120518175548.GM19388@google.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Fri, 18 May 2012 20:28:56 +0200
Message-ID: <CA+1xoqfr5aaGbxoX3YKrJHXTjU9fWSbX_xbuEOU=4K7kMay6XQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup removal optional
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rni@google.com, ctalbott@google.com,
        Vivek Goyal <vgoyal@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 7:55 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, May 17, 2012 at 12:33:05AM +0200, Sasha Levin wrote:
>> Hi Tejun,
>>
>> On Sun, Apr 1, 2012 at 8:54 PM, Tejun Heo <tj@kernel.org> wrote:
>> > Hello, Li.
>> >
>> > On Sun, Apr 01, 2012 at 10:00:26AM +0800, Li Zefan wrote:
>> >> > Signed-off-by: Tejun Heo <tj@kernel.org>
>> >>
>> >> Both patches look good.
>> >>
>> >> Acked-by: Li Zefan <lizefan@huawei.com>
>> >
>> > Alright, adding the patches to cgroup/for-3.5.
>>
>> This patch allows for race when removing a cgroup since one of the
>> css's may still have a dentry ref when the cgroup is removed, no? Is
>> there a plan to deal with that before this patch gets pushed into 3.5?
>
> Can you please elaborate?

>From what I gathered, that patch means that you'll have refs to
dentries while you're trying to complete the unmount of the cgroup,
which would make something really angry.

I tested it by running two scripts to race with eachother:

First:

while [ true ];
do
mount -t cgroup dummy cgroup/
mkdir cgroup/0
rmdir cgroup/0
umount cgroup/
done

Second:

while [ true ];
do
mount -t cgroup dummy cgroup/
umount cgroup/
done

Now, if you give it a go, you'll see a BUG() and a system hang pretty fast.
