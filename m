Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab2EVCOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 22:14:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698Ab2EVCOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 22:14:36 -0400
Message-ID: <4FBAF680.90007@redhat.com>
Date: Tue, 22 May 2012 10:14:24 +0800
From: Amos Kong <akong@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Li Zefan <lizefan@huawei.com>, Serge Hallyn <serge.hallyn@canonical.com>,
        containers@lists.linux-foundation.org, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, tj@kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix device deny of DEV_ALL
References: <CAFeW=pZ8Y7ycxjxro7zBMqdtaCOYs4RmoxtDrsN8+mqLhOL--g@mail.gmail.com> <20120518081912.16779.21065.stgit@t> <20120521140324.GA5091@sergelap> <4FBADF1A.6040303@huawei.com> <20120522015426.GA10344@mail.hallyn.com>
In-Reply-To: <20120522015426.GA10344@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/12 09:54, Serge E. Hallyn wrote:
> Quoting Li Zefan (lizefan@huawei.com):
>> Serge Hallyn wrote:
>>
>>> Quoting Amos Kong (akong@redhat.com):
>>>> @ mount -t cgroup -o devices none /cgroup
>>>> @ mkdir /cgroups/devices
>>>> @ ls -l /dev/dm-3
>>>>   brw-rw----. 1 root disk 253, 3 Oct 14 19:03 /dev/dm-3
>>>> @ echo 'b 253:3 rw'>  devices.deny
>>>> but I can still write it by 'dd if=/dev/zero of=/dev/dm-3'
>>>>
>>>> In devcgroup_create(), we create a new whitelist, and add first
>>>> entry which type is 'DEV_ALL'. Execute "# echo 'b 253:3 rw'>
>>>> devices.deny", dev_whitelist_rm() will update access of first
>>>> entry to 1(m), but type of first entry is still 'DEV_ALL'.
>>>
>>> Hi,
>>>
>>> thanks.  You raise a good point, but I think it needs some discussion.
>>>
>>> What happens right now is that if you have the 'a *:* rwm' entry and do
>>> echo 'b 253:3 rw'>  devices.deny, then when you next cat devices.list you
>>> will still see the 'a *:* rwm' entry.  So there should be no confusion
>>> over why the dd succeeds.

>>>   You didn't remove the entry, because there
>>> was no match echoed into devices.deny.

Hi serge,

My patch updated type,major,minor, it _equals to_ remove 'a *:* rwm' and 
add 'b *:* m'
It's a clear logic, why need to manually remove 'a *:* rwm'?


>> No, you'll see the entry has been changed to 'a *:* m', so I think we
>> should at least fix this.
>
> Yikes.  Agreed.  That's a bug.

which bug? should not update walk->access if wh->access is not 'rwm'?

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index c43a332..e619a34 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -145,7 +145,8 @@ static void dev_whitelist_rm(struct dev_cgroup 
*dev_cgroup,
                         continue;

  remove:
-               walk->access &= ~wh->access;
+               if (walk->type != DEV_ALL || wh->access == ACC_MASK)
+                       walk->access &= ~wh->access;
                 if (!walk->access) {
                         list_del_rcu(&walk->list);
                         kfree_rcu(walk, rcu);


-- 
			Amos.
