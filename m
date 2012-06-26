Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2FZMpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 08:45:41 -0400
Received: from mx2.parallels.com ([64.131.90.16]:56742 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab2FZMpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 08:45:39 -0400
Message-ID: <4FE9AE57.4090007@parallels.com>
Date: Tue, 26 Jun 2012 16:43:03 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: "Regression" with cd3d09527537
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've recently started seeing a lockdep warning at the end of *every* 
"init 0" issued in my machine. Actually, reboots are fine, and that's 
probably why I've never seen it earlier. The log is quite extensively, 
but shows the following dependency chain:

[   83.982111] -> #4 (cpu_hotplug.lock){+.+.+.}:
[...]
[   83.982111] -> #3 (jump_label_mutex){+.+...}:
[...]
[   83.982111] -> #2 (sk_lock-AF_INET){+.+.+.}:
[...]
[   83.982111] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
[...]
[   83.982111] -> #0 (cgroup_mutex){+.+.+.}:

I've recently fixed bugs with the lock ordering imposed by cpusets
on cpu_hotplug.lock through jump_label_mutex, and initially thought it 
to be the same kind of issue. But that was not the case.

I've omitted the full backtrace for readability, but I run this with all 
cgroups disabled but the cpuset, so it can't be sock memcg (after my 
initial reaction of "oh, fuck, not again"). That jump_label is there for 
years, and it comes from the code that disables socket timestamps.
(net_enable_timestamp)

After a couple of days of extensive debugging, with git bisect failing 
to pinpoint a culprit, I've got to that patch
"cgroup: always lock threadgroup during migration" as the one that would
trigger the bug.

The problem is, what this patch does is start calling threadgroup_lock
everytime, instead of conditionally. In that sense, it of course did not 
create the bug, only made it (fortunately) always visible.

Thing is, I honestly don't know what would be a fix for this bug.
We could hold the threadgroup_lock before the cgroup_lock, but that 
would hold it for way too long.

This is just another incarnation of the cgroup_lock creating nasty 
dependencies with virtually everything else, because we hold it for 
everything we do. I fear we'll fix this, and another one will just wake 
up any time.

What do you think, Tejun?
