Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1JHSSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 14:18:11 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:42143 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752978Ab1JHSSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 14:18:09 -0400
Date: Sat, 8 Oct 2011 18:18:13 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: =?utf-8?B?5ZCr6bub?= <handai.szj@taobao.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com
Subject: Re: cgroup umount bug
Message-ID: <20111008181813.GA27610@hallyn.com>
References: <1318075344.2168.4.camel@handai-OptiPlex-780>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1318075344.2168.4.camel@handai-OptiPlex-780>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting 含黛 (handai.szj@taobao.com):
> Hi,
> 
>     I found a mount/umount problem while using cgroup: I mount a cpu
> cgroup (or other subsystems) and create some subgroups under it, but
> later I try to umount it without rmdir those subgroups. I find that I
> can umount it without any errors but actually the super block still
> exist. This is because the sb->s_active count is greater than 1 which
> was added by cgroup_create. But later if I want to mount both cpu and
> memory subsystems, it will be unsuccessful indicating that the
> device(cpu subsystem) is busy. This situation will not happen if I rmdir
> the subgroups manually before umount it. So my question is:
>     Should the umount return success when there are still some subgroups

Yes.  The fs was unmounted from that directory.

> exist ? If this is okay, then it may lead to some *strange* errors using
> cgroup later. If it can not be umount, then it should inform that the
> mount point is still busy.

> Following is an example of this problem:
> 
> mount -t cgroup -o cpu cgroup /mnt
> mkdir /mnt/test
> 
> …..// do some tests
> 
> umount /mnt      /* return successfully */
> 
> /* do other subsystems test */
> mount -cgroup -o cpu,cpuset cgroup /mnt
> mount: cgroup already mounted or /mnt busy  /*??? which is strange */

I'm not sure from what you write whether you're aware of this, but
to work around this, you can then

 mount -t cgroup -o cpu /mnt
 for i in `cat /mnt/test/tasks`; do
  echo $i > /mnt/tasks
 done
 rmdir /mnt/test
 umount /mnt

and now you can 

 mount -cgroup -o cpu,cpuset cgroup /mnt

Being unable to umount /mnt while child cgroups exist or having all
child cgroups cleared and removed automatically would both be less
useful behaviors.

thanks,
-serge
