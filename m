Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab1CLA3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 19:29:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754339Ab1CLA3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 19:29:45 -0500
Date: Fri, 11 Mar 2011 16:29:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Clark Williams <williams@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH V2] page-types.c: auto debugfs mount for hwpoison
 operation
Message-Id: <20110311162916.34b450d0.akpm@linux-foundation.org>
In-Reply-To: <4D75B815.2080603@linux.intel.com>
References: <1299487900-7792-1-git-send-email-gong.chen@linux.intel.com>
	<20110307184133.8A19.A69D9226@jp.fujitsu.com>
	<20110307113937.GB5080@localhost>
	<4D75B815.2080603@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Mar 2011 13:01:09 +0800
Chen Gong <gong.chen@linux.intel.com> wrote:

> page-types.c doesn't supply a way to specify the debugfs path and
> the original debugfs path is not usual on most machines. This patch
> supplies a way to auto mount debugfs if needed.
> 
> This patch is heavily inspired by tools/perf/utils/debugfs.c
> 
> Signed-off-by: Chen Gong <gong.chen@linux.intel.com>
> ---
>   Documentation/vm/page-types.c |  105 
> +++++++++++++++++++++++++++++++++++++++--
>   1 files changed, 101 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
> index cc96ee2..303b4ed 100644
> --- a/Documentation/vm/page-types.c
> +++ b/Documentation/vm/page-types.c
> @@ -32,8 +32,20 @@
>   #include <sys/types.h>
>   #include <sys/errno.h>
>   #include <sys/fcntl.h>
> +#include <sys/mount.h>
> +#include <sys/statfs.h>
> +#include "../../include/linux/magic.h"

Your email client is space-stuffing the patches.

> 
> +#ifndef MAX_PATH
> +# define MAX_PATH 256
> +#endif
> +
> +#ifndef STR
> +# define _STR(x) #x
> +# define STR(x) _STR(x)
> +#endif
> +
>   /*
>    * pagemap kernel ABI bits
>    */
> @@ -152,6 +164,12 @@ static const char *page_flag_names[] = {
>   };
> 
> 
> +static const char *debugfs_known_mountpoints[] = {
> +	"/sys/kernel/debug",
> +	"/debug",
> +	0,
> +};
> +
>   /*
>    * data structures
>    */
> @@ -184,7 +202,7 @@ static int		kpageflags_fd;
>   static int		opt_hwpoison;
>   static int		opt_unpoison;
> 
> -static const char	hwpoison_debug_fs[] = "/debug/hwpoison";
> +static char		hwpoison_debug_fs[MAX_PATH+1];
>   static int		hwpoison_inject_fd;
>   static int		hwpoison_forget_fd;
> 
> @@ -464,21 +482,100 @@ static uint64_t kpageflags_flags(uint64_t flags)
>   	return flags;
>   }
> 
> +/* verify that a mountpoint is actually a debugfs instance */
> +int debugfs_valid_mountpoint(const char *debugfs)

page-types.c carefully makes its symbols static.  Let's continue to do
that.

--- a/Documentation/vm/page-types.c~documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix
+++ a/Documentation/vm/page-types.c
@@ -483,7 +483,7 @@ static uint64_t kpageflags_flags(uint64_
 }
 
 /* verify that a mountpoint is actually a debugfs instance */
-int debugfs_valid_mountpoint(const char *debugfs)
+static int debugfs_valid_mountpoint(const char *debugfs)
 {
 	struct statfs st_fs;
 
@@ -496,7 +496,7 @@ int debugfs_valid_mountpoint(const char 
 }
 
 /* find the path to the mounted debugfs */
-const char *debugfs_find_mountpoint(void)
+static const char *debugfs_find_mountpoint(void)
 {
 	const char **ptr;
 	char type[100];
@@ -533,7 +533,7 @@ const char *debugfs_find_mountpoint(void
 
 /* mount the debugfs somewhere if it's not mounted */
 
-void debugfs_mount()
+static void debugfs_mount()
 {
 	const char **ptr;
 
_

> +{
> +	struct statfs st_fs;
> +
> +	if (statfs(debugfs, &st_fs) < 0)
> +		return -ENOENT;
> +	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
> +		return -ENOENT;
> +
> +	return 0;
> +}
> +
> +/* find the path to the mounted debugfs */
> +const char *debugfs_find_mountpoint(void)
> +{
> +	const char **ptr;
> +	char type[100];
> +	FILE *fp;
> +
> +	ptr = debugfs_known_mountpoints;
> +	while (*ptr) {
> +		if (debugfs_valid_mountpoint(*ptr) == 0) {
> +			strcpy(hwpoison_debug_fs, *ptr);
> +			return hwpoison_debug_fs;
> +		}
> +		ptr++;
> +	}
> +
> +	/* give up and parse /proc/mounts */
> +	fp = fopen("/proc/mounts", "r");
> +	if (fp == NULL)
> +		perror("Can't open /proc/mounts for read");
> +
> +	while (fscanf(fp, "%*s %"
> +		      STR(MAX_PATH)
> +		      "s %99s %*s %*d %*d\n",
> +		      hwpoison_debug_fs, type) == 2) {
> +		if (strcmp(type, "debugfs") == 0)
> +			break;
> +	}
> +	fclose(fp);
> +
> +	if (strcmp(type, "debugfs") != 0)
> +		return NULL;
> +
> +	return hwpoison_debug_fs;
> +}
> +
> +/* mount the debugfs somewhere if it's not mounted */
> +
> +void debugfs_mount()
> +{
> +	const char **ptr;
> +
> +	/* see if it's already mounted */
> +	if (debugfs_find_mountpoint())
> +		return;
> +
> +	ptr = debugfs_known_mountpoints;
> +	while (*ptr) {
> +		if (mount(NULL, *ptr, "debugfs", 0, NULL) == 0) {
> +			/* save the mountpoint */
> +			strcpy(hwpoison_debug_fs, *ptr);
> +			break;
> +		}
> +		ptr++;
> +	}
> +
> +	if (*ptr == NULL) {
> +		perror("mount debugfs");
> +		exit(EXIT_FAILURE);
> +	}
> +}

The application now silently mounts debugfs.  Perhaps it should inform
the operator when it did this?


