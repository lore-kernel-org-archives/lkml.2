Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab0JETsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:48:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab0JETsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:48:21 -0400
Date: Tue, 5 Oct 2010 12:48:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Cc: menage@google.com, lizf@cn.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com,
        bblum@andrew.cmu.edu, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, ext-eugeny.kuznetsov@nokia.com
Subject: Re: [PATCH 1/1] cgroups: strcpy destination string overflow
Message-Id: <20101005124802.989f6214.akpm@linux-foundation.org>
In-Reply-To: <2acb25707f916de866aa520b1a9f04f0f48c949c.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
References: <cover.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
	<2acb25707f916de866aa520b1a9f04f0f48c949c.1286193571.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Oct 2010 12:38:05 +0400
Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com> wrote:

> From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>
> 
> Function "strcpy" is used without check for maximum allowed source
> string length and could cause destination string overflow.
> Check for string length is added before using "strcpy".
> Function now is return error if source string length is more than
> a maximum.
> 
> Signed-off-by: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
> ---
>  kernel/cgroup.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c9483d8..82bbede 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1883,6 +1883,8 @@ static int cgroup_release_agent_write(struct cgroup *cgrp, struct cftype *cft,
>  				      const char *buffer)
>  {
>  	BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
> +	if (strlen(buffer) >= PATH_MAX)
> +		return -EINVAL;
>  	if (!cgroup_lock_live_group(cgrp))
>  		return -ENODEV;
>  	strcpy(cgrp->root->release_agent_path, buffer);

I don't think this can happen, because cftype.max_write_len is
PATH_MAX.

But it's pretty unobvious if this is actually true, and the code is
fragile against future changes.

