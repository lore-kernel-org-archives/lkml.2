Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab2IED33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 23:29:29 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:43645 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab2IED32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 23:29:28 -0400
Date: Wed, 5 Sep 2012 03:30:02 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/6] device_cgroup: replace internally whitelist
 with exception list
Message-ID: <20120905033002.GG13310@mail.hallyn.com>
References: <20120904143419.892872876@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904143419.892872876@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> The original model of device_cgroup is having a whitelist where all the
> allowed devices are listed. The problem with this approach is that is
> impossible to have the case of allowing everything but few devices.
> 
> The reason for that lies in the way the whitelist is handled internally:
> since there's only a whitelist, the "all devices" entry would have to be
> removed and replaced by the entire list of possible devices but the ones
> that are being denied.  Since dev_t is 32 bits long, representing the allowed
> devices as a bitfield is not memory efficient.
> 
> This patch replaces the "whitelist" by a "exceptions" list and the default
> policy is kept as "deny_all" variable in dev_cgroup structure.
> 
> The current interface determines that whenever "a" is written to devices.allow
> or devices.deny, the entry masking all devices will be added or removed,
> respectively. This behavior is kept and it's what will determine the default
> policy:
> 
> 	# cat devices.list 
> 	a *:* rwm
> 	# echo a >devices.deny
> 	# cat devices.list 
> 	# echo a >devices.allow
> 	# cat devices.list 
> 	a *:* rwm
> 
> The interface is also preserved. For example, if one wants to block only access
> to /dev/null:
> 	# ls -l /dev/null
> 	crw-rw-rw- 1 root root 1, 3 Jul 24 16:17 /dev/null
> 	# echo a >devices.allow
> 	# echo "c 1:3 rwm" >devices.deny
> 	# cat /dev/null
> 	cat: /dev/null: Operation not permitted
> 	# echo >/dev/null
> 	bash: /dev/null: Operation not permitted
> 	# mknod /tmp/null c 1 3
> 	mknod: /tmp/null: Operation not permitted
> 	# echo "c 1:3 r" >devices.allow
> 	# cat /dev/null
> 	# echo >/dev/null
> 	bash: /dev/null: Operation not permitted
> 	# mknod /tmp/null c 1 3
> 	mknod: /tmp/null: Operation not permitted
> 	# echo "c 1:3 rw" >devices.allow
> 	# echo >/dev/null
> 	# cat /dev/null
> 	# mknod /tmp/null c 1 3
> 	mknod: /tmp/null: Operation not permitted
> 	# echo "c 1:3 rwm" >devices.allow
> 	# echo >/dev/null
> 	# cat /dev/null
> 	# mknod /tmp/null c 1 3
> 	#
> 
> v2:
> - stop using simple_strtoul()
> - fix checkpatch warnings
> - rename deny_all to behavior
> - updated documentation
> - added new files to cgroupfs to better reflect the internal state
> 
>  Documentation/cgroups/devices.txt |   73 ++++--
>  security/device_cgroup.c          |  443 +++++++++++++++++++++++---------------
>  2 files changed, 333 insertions(+), 183 deletions(-)
> 
> -- 
> Aristeu

Thanks, Aristeu, very nice.

-serge
