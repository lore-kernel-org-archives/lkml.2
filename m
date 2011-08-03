Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1HCGK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:10:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49795 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab1HCGKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:10:21 -0400
Date: Wed, 3 Aug 2011 08:10:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] oom: change warning for deprecated oom_adj to avoid
 WARN_ONCE()
Message-ID: <20110803061016.GC16170@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	David Rientjes <rientjes@google.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20110802005206.GA3832@tassilo.jf.intel.com>
 <alpine.DEB.2.00.1108011928530.15596@chino.kir.corp.google.com>
 <m2pqko1h38.fsf@firstfloor.org>
 <alpine.DEB.2.00.1108020236140.18935@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108020236140.18935@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 02:54:01AM -0700, David Rientjes wrote:
> On Mon, 1 Aug 2011, Andi Kleen wrote:
> 
> > Simply backtraces are not supposed to happen unless something 
> > is really broken. That's not the case here. The old distribution
> > works perfectly fine and will continue to do so.
> > 
> 
> It won't work perfectly fine in a year when the tunable is removed 
> completely and the code that was writing OOM_DISABLE to /proc/pid/oom_adj 
> just fails and the task that was supposed to be prevented from being 
> killed at all costs may now be killed.  The printk_once() over the past 
> year didn't get that fixed up like the other applications I mentioned did, 
> so we need to attract more attention.
> 
> > I still think reverting this patch is the right thing to do.
> > 
> 
> Reverting the patch is ludicrous, otherwise there is little possibility 
> that the remaining users of the deprecated interface will change if they 
> haven't done so already.  I'm perfectly happy with changing it to a 
> different style of warning other than using WARN_ONCE() like I've already 
> said.  That doesn't require a revert.
> 
> I'm fine with this patch if Linus would like to apply it.
> 
> 
> oom: change warning for deprecated oom_adj to avoid WARN_ONCE()
> 
> WARN_ONCE() emits a stack trace to the kernel log which leads userspace 
> parsers to interpret it as being a serious error or malfunction within the 
> kernel.  Change the warning to appear more like a lockdep warning while 
> still trying to preserve the intention of be8f684d73d8 (oom: make 
> deprecated use of oom_adj more verbose) to attract more attention to the 
> use of a deprecated interface.
> 
> Reported-by: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  fs/proc/base.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1066,6 +1066,7 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
>  	char buffer[PROC_NUMBUF];
>  	int oom_adjust;
>  	unsigned long flags;
> +	static bool warning_printed;
>  	int err;
>  
>  	memset(buffer, 0, sizeof(buffer));
> @@ -1118,9 +1119,15 @@ static ssize_t oom_adjust_write(struct file *file, const char __user *buf,
>  	 * Warn that /proc/pid/oom_adj is deprecated, see
>  	 * Documentation/feature-removal-schedule.txt.
>  	 */
> -	WARN_ONCE(1, "%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
> -		  current->comm, task_pid_nr(current), task_pid_nr(task),
> -		  task_pid_nr(task));
> +	if (!warning_printed) {
> +		warning_printed = true;
> +		printk("\n===============================================================================\n");
> +		printk("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
> +			current->comm, task_pid_nr(current), task_pid_nr(task),
> +			task_pid_nr(task));
> +		printk("===============================================================================\n\n");

You're missing the KERN_WARNING level. Why don't you use pr_warn_once +
pr_cont_once? No need for the warning_printed too, it gets defined in
another scope by the pr_warn_once macro automatically.

-- 
Regards/Gruss,
    Boris.
