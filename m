Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab2KENmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:42:35 -0500
Received: from mx2.parallels.com ([64.131.90.16]:53263 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab2KENmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:42:32 -0500
Message-ID: <5097C23B.3040808@parallels.com>
Date: Mon, 5 Nov 2012 14:42:19 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizefan@huawei.com>, <mhocko@suse.cz>, <rjw@sisk.pl>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <fweisbec@gmail.com>
Subject: Re: [PATCH 1/9] cgroup: add cgroup_subsys->post_create()
References: <1351931915-1701-1-git-send-email-tj@kernel.org> <1351931915-1701-2-git-send-email-tj@kernel.org>
In-Reply-To: <1351931915-1701-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.2.49.79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2012 09:38 AM, Tejun Heo wrote:
> Currently, there's no way for a controller to find out whether a new
> cgroup finished all ->create() allocatinos successfully and is
> considered "live" by cgroup.
> 
> This becomes a problem later when we add generic descendants walking
> to cgroup which can be used by controllers as controllers don't have a
> synchronization point where it can synchronize against new cgroups
> appearing in such walks.
> 
> This patch adds ->post_create().  It's called after all ->create()
> succeeded and the cgroup is linked into the generic cgroup hierarchy.
> This plays the counterpart of ->pre_destroy().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Glauber Costa <glommer@parallels.com>

Tejun, If we do it this way, we end up with two callbacks that are
called after create: post_clone and post_create. I myself prefer the
approach I took, that convert post_clone into post_create, and would
prefer if you would pick that up.

For me, post_clone is totally a glitch that should not exist. Merging
this with post_create gives the following semantics:

* A while after cgroup creation, you will get a callback. In that
callback, you do whatever initialization you may need that you could not
in create. Why is reacting to a flag being set any different?

