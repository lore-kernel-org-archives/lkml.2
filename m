Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab2F0XIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 19:08:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38828 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab2F0XI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 19:08:28 -0400
Date: Wed, 27 Jun 2012 16:08:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Cgroups <cgroups@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: "Regression" with cd3d09527537
Message-ID: <20120627230823.GU15811@google.com>
References: <4FE9AE57.4090007@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE9AE57.4090007@parallels.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 04:43:03PM +0400, Glauber Costa wrote:
> Hi,
> 
> I've recently started seeing a lockdep warning at the end of *every*
> "init 0" issued in my machine. Actually, reboots are fine, and
> that's probably why I've never seen it earlier. The log is quite
> extensively, but shows the following dependency chain:
> 
> [   83.982111] -> #4 (cpu_hotplug.lock){+.+.+.}:
> [...]
> [   83.982111] -> #3 (jump_label_mutex){+.+...}:
> [...]
> [   83.982111] -> #2 (sk_lock-AF_INET){+.+.+.}:
> [...]
> [   83.982111] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
> [...]
> [   83.982111] -> #0 (cgroup_mutex){+.+.+.}:
> 
> I've recently fixed bugs with the lock ordering imposed by cpusets
> on cpu_hotplug.lock through jump_label_mutex, and initially thought
> it to be the same kind of issue. But that was not the case.
> 
> I've omitted the full backtrace for readability, but I run this with
> all cgroups disabled but the cpuset, so it can't be sock memcg
> (after my initial reaction of "oh, fuck, not again"). That
> jump_label is there for years, and it comes from the code that
> disables socket timestamps.
> (net_enable_timestamp)

Yeah, there are multiple really large locks at play here - jump label,
threadgroup and cgroup_mutex.  It isn't pretty.  Can you please post
the full lockdep dump?  The above only shows single locking chain.
I'd like to see the other.

Thanks.

-- 
tejun
