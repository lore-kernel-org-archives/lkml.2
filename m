Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419Ab1LFLyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:54:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:56342 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933232Ab1LFLyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:54:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,304,1320652800"; 
   d="scan'208";a="82716445"
Date: Tue, 6 Dec 2011 19:44:38 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "greg@kroah.com" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/3] DEBUGFS: Add per cpu counters
Message-ID: <20111206114438.GA17186@localhost>
References: <1322851407-17182-1-git-send-email-andi@firstfloor.org>
 <1322851407-17182-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322851407-17182-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 03, 2011 at 02:43:26AM +0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Add a simple way to export per cpu counters in debugfs.
> 
> This is done using a section, so that they can be declared using
> a simple macro with minimal typing.
> 
> OPEN: modules are not supported yet.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  fs/debugfs/Makefile               |    2 +-
>  fs/debugfs/counter.c              |   73 +++++++++++++++++++++++++++++++++++++
>  include/asm-generic/vmlinux.lds.h |    6 +++
>  include/linux/debugfs.h           |   27 ++++++++++++++
>  4 files changed, 107 insertions(+), 1 deletions(-)
>  create mode 100644 fs/debugfs/counter.c
> 
> diff --git a/fs/debugfs/Makefile b/fs/debugfs/Makefile
> index 840c456..21be8d3 100644
> --- a/fs/debugfs/Makefile
> +++ b/fs/debugfs/Makefile
> @@ -1,4 +1,4 @@
> -debugfs-objs	:= inode.o file.o
> +debugfs-objs	:= inode.o file.o counter.o
>  
>  obj-$(CONFIG_DEBUG_FS)	+= debugfs.o
>  
> diff --git a/fs/debugfs/counter.c b/fs/debugfs/counter.c
> new file mode 100644
> index 0000000..2372faf
> --- /dev/null
> +++ b/fs/debugfs/counter.c
> @@ -0,0 +1,73 @@
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <linux/percpu.h>
> +#include <linux/kernel.h>
> +
> +/* OPEN: implement module support */

Yeah, I think the module support would benefit my case as well.

To support module users, init_counters() will be exported with the
__start___debugfs/__stop___debugfs hard coding removed. Then I'll be
call it from the readahead initilization code:

DEFINE_PER_CPU(unsigned long[RA_PATTERN_MAX][RA_ACCOUNT_MAX], ra_counter);
struct debugfs_counter ra_pcpu_counter[RA_PATTERN_MAX][RA_ACCOUNT_MAX];

// init ra_pcpu_counter in a loop
for each pattern
        init_counters(ra_pcpu_counter[pattern], ra_pcpu_counter[pattern+1]);

Does this usage sound reasonable?

> +extern struct debugfs_counter __start___debugfs[], __stop___debugfs[];
> +
> +static unsigned sum_counter(unsigned __percpu *counter)
> +{
> +	int cpu;
> +	unsigned sum = 0;
> +
> +	for_each_online_cpu (cpu)
> +		sum += per_cpu(*counter, cpu);
> +	return sum;
> +}
> +
> +static int
> +dump_counters(struct seq_file *m,
> +	      struct debugfs_counter *cnt, struct debugfs_counter *stop,
> +	      char *fn)
> +{
> +	int n = 0;
> +	for (; cnt < stop; cnt++)
> +		if (fn[0] == cnt->fn[0] && !strcmp(cnt->fn, fn))
> +			n += seq_printf(m, "%s: %u\n",
> +					cnt->name, sum_counter(cnt->ptr));
> +	return n;
> +}
> +
> +static int show_debugfs_counter(struct seq_file *m, void *arg)
> +{
> +	int n;
> +	n = dump_counters(m, __start___debugfs, __stop___debugfs, m->private);

That hard coded __start___debugfs/__stop___debugfs is OK for POC, and
will need to be improved to work with multiple users in kernel.

Thanks,
Fengguang
