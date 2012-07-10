Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2GJCLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:11:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:53152 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2GJCL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:11:28 -0400
Message-ID: <4FFB8F39.9030209@huawei.com>
Date: Tue, 10 Jul 2012 10:11:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: shyju pv <shyju.pv@huawei.com>, Sanil kumar <sanil.kumar@huawei.com>,
        Masanari Iida <standby24x7@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <levinsasha928@gmail.com>
Subject: Re: [PATCH] cgroup: fix dentry still in use bug when dropping css
 refs after umount
References: <4FEEA5CB.8070809@huawei.com> <20120703170317.GB555@google.com> <20120703225218.GF555@google.com> <4FF3E063.5010604@huawei.com> <20120708063536.GB19021@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120708063536.GB19021@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.88.115]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/7/8 14:35, Tejun Heo wrote:

> Hello, Li.
> 
> On Wed, Jul 04, 2012 at 02:19:15PM +0800, Li Zefan wrote:
>>> I think we're horridly broken for
>>> root cgroup tho - and it has been broken for very long time.  I think
>>> it's mostly hidden because most (all?) controllers short-circuit root
>>> cgroup.  Eh, well....
>>>
>>
>> Could you elaborate a bit on what's broken for root cgroup?
> 
> If someone holds css ref of a root cgroup, AFAICS nothing is
> preventing the cgroup hierarchy from being unmounted and root cgroup
> destroyed.
> 


Right, but that should be safe. The css objects of the root cgroup are
allocated at boot, and won't be destroyed at umount.

Furthermore when a cgroup hierarchy is going to be unmounted, those css's
will be made to point to a cgroup named dummytop in rebind_subsystems(),
and there's a syncronize_rcu() in the end of the function, so accessing
css->cgroup is always safe.

In this case, dummytop->dentry is NULL, and that's safe too, because
cgroup_path() is aware of this case.

