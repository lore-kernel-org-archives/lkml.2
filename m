Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab2HITRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:17:03 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:51849 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071Ab2HITRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:17:00 -0400
Message-Id: <20120809190414.773462171@muttley.lan.cathedral>
User-Agent: quilt/0.60-1
Date: Thu, 09 Aug 2012 15:04:14 -0400
From: aris@ruivo.org
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 0/4] device_cgroup: replace internally whitelist with exception list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original model of device_cgroup is having a whitelist where all the
allowed devices are listed. The problem with this approach is that is
impossible to have the case of allowing everything but few devices.

The reason for that lies in the way the whitelist is handled internally:
since there's only a whitelist, the "all devices" entry would have to be
removed and replaced by the entire list of possible devices but the ones
that are being denied.  Since dev_t is 32 bits long, representing the allowed
devices as a bitfield is not memory efficient.

This patch replaces the "whitelist" by a "exceptions" list and the default
policy is kept as "deny_all" variable in dev_cgroup structure.

The current interface determines that whenever "a" is written to devices.allow
or devices.deny, the entry masking all devices will be added or removed,
respectively. This behavior is kept and it's what will determine the default
policy:

	# cat devices.list 
	a *:* rwm
	# echo a >devices.deny
	# cat devices.list 
	# echo a >devices.allow
	# cat devices.list 
	a *:* rwm

The interface is also preserved. For example, if one wants to block only access
to /dev/null:
	# ls -l /dev/null
	crw-rw-rw- 1 root root 1, 3 Jul 24 16:17 /dev/null
	# echo a >devices.allow
	# echo "c 1:3 rwm" >devices.deny
	# cat /dev/null
	cat: /dev/null: Operation not permitted
	# echo >/dev/null
	bash: /dev/null: Operation not permitted
	mknod /tmp/null c 1 3
	mknod: ‘/tmp/null’: Operation not permitted
	# echo "c 1:3 r" >devices.allow
	# cat /dev/null
	# echo >/dev/null
	bash: /dev/null: Operation not permitted
	mknod /tmp/null c 1 3
	mknod: ‘/tmp/null’: Operation not permitted
	# echo "c 1:3 rw" >devices.allow
	# echo >/dev/null
	# cat /dev/null
	# mknod /tmp/null c 1 3
	mknod: ‘/tmp/null’: Operation not permitted
	# echo "c 1:3 rwm" >devices.allow
	# echo >/dev/null
	# cat /dev/null
	# mknod /tmp/null c 1 3
	#

 device_cgroup.c |  371 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 212 insertions(+), 159 deletions(-)

