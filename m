Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab2EESVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:21:47 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60660 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757463Ab2EESVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:21:46 -0400
Date: Sat, 5 May 2012 22:20:51 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, khlebnikov@openvz.org,
        xemul@parallels.com, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: c/r: broken locking when executing map_files
Message-ID: <20120505182051.GA16029@albatros>
References: <1335979380.10666.6.camel@lappy>
 <20120502172756.GD2301@moon>
 <20120503173125.GF19347@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503173125.GF19347@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

On Thu, May 03, 2012 at 21:31 +0400, Cyrill Gorcunov wrote:
> On Wed, May 02, 2012 at 09:27:56PM +0400, Cyrill Gorcunov wrote:
> > > 
> > > My theory is that files under map_files shouldn't be executable,
> > > but since I'm not sure what the usermode code for c/r does exactly,
> > > I should probably confirm that first. If it's indeed the case, you
> > > can probably skip the rest of this mail.
> > 
> > Thanks Sasha, I'll take a look!
> 
> Sasha, the patch below should fix the lock problem (still I would
> prefer to obtain confirm on patch from Vasiliy, CC'ed).
...
> ---
>  fs/proc/base.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6.git/fs/proc/base.c
> ===================================================================
> --- linux-2.6.git.orig/fs/proc/base.c
> +++ linux-2.6.git/fs/proc/base.c
> @@ -2226,16 +2226,16 @@ static struct dentry *proc_map_files_loo
>  		goto out;
>  
>  	result = ERR_PTR(-EACCES);
> -	if (lock_trace(task))
> +	if (!ptrace_may_access(task, PTRACE_MODE_READ))

Probably it will be better to change mutex_lock_killable() to
mutex_lock_killable_nested() inside of lock_trace() instead of this change?
It would keep the race-free check.

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
