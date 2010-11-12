Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab0KLUlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:41:40 -0500
Received: from smtp-out.google.com ([74.125.121.35]:51606 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885Ab0KLUlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:41:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:message-id:user-agent:
	mime-version:content-type;
	b=wwAzjA8pjXy5ma1AmNQ07VK11ww2UujM8iT05moH9NioWTXk5fQnd6f1V03EjqwKv
	25iXP/kuQqK+chOUmKyhg==
From: Greg Thelen <gthelen@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] memcg: make mem_cgroup_page_stat() return value unsigned
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-7-git-send-email-gthelen@google.com>
	<20101112082921.GH9131@cmpxchg.org>
Date: Fri, 12 Nov 2010 12:41:15 -0800
Message-ID: <xr937hgixok4.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DeJohannes Weiner <hannes@cmpxchg.org> writes:

> On Tue, Nov 09, 2010 at 01:24:31AM -0800, Greg Thelen wrote:
>> mem_cgroup_page_stat() used to return a negative page count
>> value to indicate value.
>
> Whoops :)
>
>> mem_cgroup_page_stat() has changed so it never returns
>> error so convert the return value to the traditional page
>> count type (unsigned long).
>
> This changelog feels a bit beside the point.
>
> What's really interesting is that we now don't consider negative sums
> to be invalid anymore, but just assume zero!  There is a real
> semantical change here.

Prior to this patch series mem_cgroup_page_stat() returned a negative
value (specifically -EINVAL) to indicate that the current task was in
the root_cgroup and thus the per-cgroup usage and limit counter were
invalid.  Callers treated all negative values as an indication of
root-cgroup message.

Unfortunately there was another way that mem_cgroup_page_stat() could
return a negative value even when current was not in the root cgroup.
Negative sums were a possibility due to summing of unsynchronized
per-cpu counters.  These occasional negative sums would fool callers
into thinking that the current task was in the root cgroup.

Would adding this description to the commit message address your
concerns?

> That the return type can then be changed to unsigned long is a nice
> follow-up cleanup that happens to be folded into this patch.

Good point.  I can separate the change into two sub-patches:
1. use zero for a min-value (as described above)
2. change return value to unsigned
