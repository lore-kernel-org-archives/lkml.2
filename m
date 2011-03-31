Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab1CaVfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:35:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668Ab1CaVfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:35:18 -0400
Date: Thu, 31 Mar 2011 14:35:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Dan Kegel <dank@kegel.com>
Subject: Re: [PATCH] Raise default hard ulimit on number of files to 4096
Message-Id: <20110331143512.2bd5703b.akpm@linux-foundation.org>
In-Reply-To: <1301606810-11001-1-git-send-email-tim.gardner@canonical.com>
References: <1301606810-11001-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 15:26:50 -0600
Tim Gardner <tim.gardner@canonical.com> wrote:

> Apps are increasingly using more than 1024 file descriptors.
> See discussion in several distro bug trackers, e.g.
> https://bugs.launchpad.net/bugs/663090
> https://issues.rpath.com/browse/RPL-2054
> 

^^ how not to write a changelog.

Here's the useful part, from Dan's bugzilla report:

: You don't want to raise the default soft limit, since that might break
: apps that use select(), but it's safe to raise the default hard limit;
: that way, apps that know they need lots of file descriptors can raise their
: soft limit without needing root, and without user intervention.
: 
: Ubuntu is doing this for 11.04 by changing include/asm-generic/resource.h:
: 
: -    [RLIMIT_NOFILE]        = {       INR_OPEN,       INR_OPEN },    \
: +    [RLIMIT_NOFILE]        = {       INR_OPEN,     INR_OPEN*4 },    \
: 
: They chose to do this with a kernel change because they have a policy
: of not changing kernel defaults in userland.
: 
: While 4096 might not be enough for *all* apps, it seems to be plenty
: for the apps I've seen lately that are unhappy with 1024.


> ---
>  include/asm-generic/resource.h |    2 +-
>  include/linux/fs.h             |    3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
> index 587566f..61fa862 100644
> --- a/include/asm-generic/resource.h
> +++ b/include/asm-generic/resource.h
> @@ -78,7 +78,7 @@
>  	[RLIMIT_CORE]		= {              0,  RLIM_INFINITY },	\
>  	[RLIMIT_RSS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
>  	[RLIMIT_NPROC]		= {              0,              0 },	\
> -	[RLIMIT_NOFILE]		= {       INR_OPEN,       INR_OPEN },	\
> +	[RLIMIT_NOFILE]		= {   INR_OPEN_CUR,   INR_OPEN_MAX },	\
>  	[RLIMIT_MEMLOCK]	= {    MLOCK_LIMIT,    MLOCK_LIMIT },	\
>  	[RLIMIT_AS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
>  	[RLIMIT_LOCKS]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 52f283c..6e1e4e6 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -23,7 +23,8 @@
>  
>  /* Fixed constants first: */
>  #undef NR_OPEN
> -#define INR_OPEN 1024		/* Initial setting for nfile rlimits */
> +#define INR_OPEN_CUR 1024	/* Initial setting for nfile rlimits */
> +#define INR_OPEN_MAX 4096	/* Hard limit for nfile rlimits */
>  
>  #define BLOCK_SIZE_BITS 10
>  #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
> -- 
> 1.7.0.4
