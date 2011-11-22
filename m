Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab1KVPj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 10:39:58 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46524 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab1KVPj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 10:39:56 -0500
Date: Tue, 22 Nov 2011 07:39:48 -0800
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        Tomasz Buchert <tomasz.buchert@inria.fr>,
        Paul Menage <paul@paulmenage.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
Message-ID: <20111122153948.GE322@google.com>
References: <1321480234-29241-1-git-send-email-mhocko@suse.cz>
 <20111121230709.GR25776@google.com>
 <4ECB06D2.6060106@cn.fujitsu.com>
 <20111122022118.GT25776@google.com>
 <20111122090522.GA26768@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122090522.GA26768@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Tue, Nov 22, 2011 at 10:05:22AM +0100, Michal Hocko wrote:
> I am not sure which BUG_ON you have in mind.
> update_if_frozen:
> 	BUG_ON(nfrozen != ntotal);

Heh, try to put a kthread into the cgroup and freeze it. :)

> From aba1042a96b6e79e0b14e3c397389389c9e2f522 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Wed, 16 Nov 2011 22:38:42 +0100
> Subject: [PATCH] cgroup_freezer: fix freezing groups with stopped tasks
> 
> 2d3cbf8b (cgroup_freezer: update_freezer_state() does incorrect state
> transitions) removed is_task_frozen_enough and replaced it with a simple
> frozen call. This, however, breaks freezing for a group with stopped tasks
> because those cannot be frozen and so the group remains in CGROUP_FREEZING
> state (update_if_frozen doesn't count stopped tasks) and never reaches
> CGROUP_FROZEN.
> 
> Let's add is_task_frozen_enough back and use it at the original locations
> (update_if_frozen and try_to_freeze_cgroup). Semantically we consider
> stopped tasks as frozen enough so we should consider both cases when
> testing frozen tasks.
> 
> Testcase:
> mkdir /dev/freezer
> mount -t cgroup -o freezer none /dev/freezer
> mkdir /dev/freezer/foo
> sleep 1h &
> pid=$!
> kill -STOP $pid
> echo $pid > /dev/freezer/foo/tasks
> echo FROZEN > /dev/freezer/foo/freezer.state
> while true
> do
>         cat /dev/freezer/foo/freezer.state
>         [ "`cat /dev/freezer/foo/freezer.state`" = "FROZEN" ] && break
>         sleep 1
> done
> echo OK
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
> Cc: Paul Menage <paul@paulmenage.org>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Tejun Heo <htejun@gmail.com>

Applying to cgroup/for-3.2-fixes.

Thank you.

-- 
tejun
