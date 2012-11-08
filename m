Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2KHEnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:43:11 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58889 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2KHEnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:43:08 -0500
Date: Wed, 7 Nov 2012 20:42:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 6/9] cgroup_freezer: make freezer->state mask of flags
Message-ID: <20121108044255.GG2660@mtj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-7-git-send-email-tj@kernel.org>
 <509B371E.9050005@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <509B371E.9050005@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kame.

On Thu, Nov 08, 2012 at 01:37:50PM +0900, Kamezawa Hiroyuki wrote:
> How about
> enum {
>    __CGROUP_FREEZING,
>    __CGROUP_FROZEN,
> };
> 
> #define CGROUP_FREEZER_STATE_MASK  0x3
> #define CGROUP_FREEZER_STATE(state)	((state) & CGROUP_FREEZER_STATE_MASK)
> #define CGROUP_THAW(state)	(CGROUP_FREEZER_STATE(state) == 0)
> #define CGROUP_FREEZING(state)	(CGROUP_FREEZER_STATE(state) == __CGROUP_FREEZING)
> #define CGROUP_FROZEN(state)\
> 	(CGROUP_FREEZER_STATE(state) == (__CGROUP_FREEZING | __CGROUP_FROZEN))

I think it's a bit overdone and we have cases where we test for
FREEZING regardless of FROZEN and cases where test for FREEZING &&
!FROZEN.  We can have, say, CGROUP_FREZING() and then
CGROUP_FREEZING_BUT_NOT_FROZEN(), but it feels more like obfuscation
than anything else.

> >@@ -290,9 +284,9 @@ static int freezer_write(struct cgroup *cgroup, struct cftype *cft,
> >  {
> >  	bool freeze;
> >
> >-	if (strcmp(buffer, freezer_state_strs[CGROUP_THAWED]) == 0)
> >+	if (strcmp(buffer, freezer_state_strs(0)) == 0)
> 
> Can't we have a name for "0" ?

We can define CGROUP_THAWED to be zero.  I'd rather keep it explicitly
zero tho.  freezer state is mask of freezing and frozen flags and no
flag set means thawed.

Thanks.

-- 
tejun
