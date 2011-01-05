Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1AEXuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:50:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24151 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1AEXud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:50:33 -0500
Date: Wed, 5 Jan 2011 15:48:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "J.H." <warthog9@kernel.org>, David Brown <davidb@codeaurora.org>,
        sedat.dilek@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, ftpadmin@kernel.org, webmaster@kernel.org
Subject: Re: patchwork.kernel.org down
Message-Id: <20110105154818.56b9976c.randy.dunlap@oracle.com>
In-Reply-To: <ada62u3dkv2.fsf@cisco.com>
References: <AANLkTik4ktaeyDG3ihh-YRB+WVLxA46wSLOgWy6iY_68@mail.gmail.com>
	<20101220204936.GA21290@huya.qualcomm.com>
	<4D0FFC4B.9050301@kernel.org>
	<ada62u3dkv2.fsf@cisco.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Jan 2011 14:52:17 -0800 Roland Dreier wrote:

>  > More excitement from https://bugzilla.kernel.org/show_bug.cgi?id=20702
>  > 
>  > Anyone want to take a stab at it?  I know I'd be appreciative.  I am
>  > running a debug kernel with everything I could find and enable I even
>  > remotely thought might prove helpful.  Nothing has jumped out yet though.
> 
> A little late, but perhaps running with the patch below might help us
> make a bit of progress.  The idea is to dump the last /proc/net file
> opened and closed, so we can at least have a clue as to where the crash
> is coming from.  This should add lines like 
> 
>     last procfs open:  /proc/2443/net/arp
>     last procfs close: /proc/2443/net/arp
> 
> to the oops output, so maybe we can zero in on things after you get a
> crash with this applied.
> 
>  - R.
> 
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index 6e8752c..c67b8d6 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -18,6 +18,7 @@
>  
>  #include <asm/stacktrace.h>
>  
> +void procfs_printk_last_file(void);
>  
>  int panic_on_unrecovered_nmi;
>  int panic_on_io_nmi;
> @@ -283,6 +284,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
>  #endif
>  	printk("\n");
>  	sysfs_printk_last_file();
> +	procfs_printk_last_file();
>  	if (notify_die(DIE_OOPS, str, regs, err,
>  			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
>  		return 1;
> diff --git a/fs/proc/proc_net.c b/fs/proc/proc_net.c
> index 9020ac1..1801cc1 100644
> --- a/fs/proc/proc_net.c
> +++ b/fs/proc/proc_net.c
> @@ -26,6 +26,14 @@
>  
>  #include "internal.h"
>  
> +/* used in crash dumps to help with debugging */
> +static char last_procfs_open[PATH_MAX];
> +static char last_procfs_close[PATH_MAX];
> +void procfs_printk_last_file(void)
> +{
> +	printk(KERN_EMERG "last procfs open:  %s\n", last_procfs_open);
> +	printk(KERN_EMERG "last procfs close: %s\n", last_procfs_close);

Let's not mislead the reader of a crash dump, please.  How about:

+	printk(KERN_EMERG "last /proc..net open:  %s\n", last_procfs_open);
+	printk(KERN_EMERG "last /proc..net close: %s\n", last_procfs_close);


> +}
>  
>  static struct net *get_proc_net(const struct inode *inode)
>  {
> @@ -37,9 +45,14 @@ int seq_open_net(struct inode *ino, struct file *f,
>  {
>  	struct net *net;
>  	struct seq_net_private *p;
> +	char *n;
>  
>  	BUG_ON(size < sizeof(*p));
>  
> +	n = d_path(&f->f_path, last_procfs_open, sizeof(last_procfs_open));
> +	if (!IS_ERR(n))
> +		memmove(last_procfs_open, n, strlen(n) + 1);
> +
>  	net = get_proc_net(ino);
>  	if (net == NULL)
>  		return -ENXIO;
> @@ -83,6 +96,11 @@ EXPORT_SYMBOL_GPL(single_open_net);
>  int seq_release_net(struct inode *ino, struct file *f)
>  {
>  	struct seq_file *seq;
> +	char *n;
> +
> +	n = d_path(&f->f_path, last_procfs_close, sizeof(last_procfs_close));
> +	if (!IS_ERR(n))
> +		memmove(last_procfs_close, n, strlen(n) + 1);
>  
>  	seq = f->private_data;
>  
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
