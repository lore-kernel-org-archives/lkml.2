Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2E1ASZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 20:18:25 -0400
Received: from szxga04-in.huawei.com ([58.251.152.67]:51214 "EHLO
	szxga04-in.huawei.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751797Ab2E1ASU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 20:18:20 -0400
Date: Mon, 28 May 2012 08:18:08 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] cgroup: superblock can't be released with active dentries
In-reply-to: <20120524154139.GA27983@google.com>
X-Originating-IP: [10.166.88.128]
To: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com, Vivek Goyal <vgoyal@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Message-id: <4FC2C440.8090104@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120312
 Thunderbird/11.0
X-CFilter-Loop: Reflected
References: <20120330223423.GJ28934@google.com>
 <20120330223606.GK28934@google.com> <4F77B6BA.4070207@huawei.com>
 <20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com>
 <20120518175548.GM19388@google.com>
 <CA+1xoqfr5aaGbxoX3YKrJHXTjU9fWSbX_xbuEOU=4K7kMay6XQ@mail.gmail.com>
 <20120523222242.GD3933@htj.dyndns.org>
 <CA+1xoqdbtkC5Ue3s1qZHHJBLcj9a=djFDGny6AJJSV-pdn7mcA@mail.gmail.com>
 <20120524154139.GA27983@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/24 23:41, Tejun Heo wrote:

>>From 88787c483106c5830a46d18deaffdc1e70929af7 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Thu, 24 May 2012 08:24:39 -0700
> 
> 48ddbe1946 "cgroup: make css->refcnt clearing on cgroup removal
> optional" allowed a css to linger after the associated cgroup is
> removed.  As a css holds a reference on the cgroup's dentry, it means
> that cgroup dentries may linger for a while.
> 
> cgroup_create() does grab an active reference on the superblock to
> prevent it from going away while there are !root cgroups; however, the
> reference is put from cgroup_diput() which is invoked on cgroup
> removal, so cgroup dentries which are removed but persisting due to
> lingering csses already have released their superblock active refs
> allowing superblock to be killed while those dentries are around.
> 
> Given the right condition, this makes cgroup_kill_sb() call
> kill_litter_super() with dentries with non-zero d_count leading to
> BUG() in shrink_dcache_for_umount_subtree().
> 
> Fix it by adding cgroup_dops->d_release() operation and moving
> deactivate_super() to it.  cgroup_diput() now marks dentry->d_fsdata
> with itself if superblock should be deactivated and cgroup_d_release()
> deactivates the superblock on dentry release.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Tested-by: Sasha Levin <levinsasha928@gmail.com>
> LKML-Reference: <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com>


Acked-by: Li Zefan <lizefan@huawei.com>
