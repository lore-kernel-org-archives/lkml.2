Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1HENkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 09:40:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab1HENkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 09:40:49 -0400
Date: Fri, 5 Aug 2011 09:40:42 -0400
From: Don Zickus <dzickus@redhat.com>
To: Alex Neronskiy <zakmagnus@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v4 2/2] Output stall traces in /proc
Message-ID: <20110805134042.GJ1972@redhat.com>
References: <1312495991-28377-1-git-send-email-zakmagnus@chromium.org>
 <1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312495991-28377-2-git-send-email-zakmagnus@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 03:13:11PM -0700, Alex Neronskiy wrote:
> Instead of using the log, use files in /proc for trace output.
> Printing to the log can result in watchdog touches, distorting the
> very events being measured. Additionally, the information will not
> distract from lockups when users view the log.

Interesting.  I didn't realize how easy it was to save those traces.  I
think this is a better approach because it hides this stuff in a proc
file.

I'll have to play with a little bit, but I was wondering what happens when
you have multiple stack traces coming in.  Before when it was printing to
the console, it was probably a bit of professional courtesy to keep the
warnings to a minimum.  But if you are going to use the proc fs, we can
probably be a little noisier.  So I had two questions

If you don't get to the proc fs fast enough, are you overwriting the
shorter stall stack trace with a slightly longer stall stack trace.  It
seems the 

> +			hardstall_trace.nr_entries = 0;

would reset things and you would lose the original worst_stall.

Do we want to increment the worst stall time now?  Shouldn't we just stay
at the current threshold and continue to print the same stack trace?  To
me that is the definition of 'worst stall'.  This might contradict
something I said earlier, I don't know (if it does I apologize).  Instead
if someone wants to 'skip' that 'worst stall' they can possibly just
increment the threshold?

Or another idea I just had (it adds work to this), perhaps create a sample
frequency for the lockup timers.  What I mean by that is, currently the
timer fires 5 times (or 2.5 for hardlockups) before the NMI triggers.  We
could create a knob that allows us to sample at 10 or 20 or whatever.
Then next time the hrtimer goes off it would just reload the new
frequency.

This would allow better resolution on the worst stall I believe, but it
invovles more knobs now. So the knobs would look like

watchdog_thresh - length of time before NMI fires (currently 10)
watchdog_sample_freq - number of times hrtimer fires before NMI fires
			(currently 5, well 2.5)
watchdog_worst_stall_hard - number of sample_freq before printing warning
				(currently 2 I think)


Because you converted to ms resolution, it is easier to divide the
frequency up.  Of course if you increase the sample frequency, you would
probably have to increase the worst stall number too.

The downside is the power management folks would whine that it drains
laptop batteries.  But Matthew Garret sits a few cubes down from me, so I
can probably have him help me hook into the idle thread to quiesce the
timers.

Thoughts?

code comments below
> 
> Signed-off-by: Alex Neronskiy <zakmagnus@chromium.org>
> ---
>  kernel/watchdog.c |  107 ++++++++++++++++++++++++++++++++++++++++++----------
>  1 files changed, 86 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 8dd9ed4..9cdc6bb 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -23,13 +23,24 @@
>  #include <linux/notifier.h>
>  #include <linux/module.h>
>  #include <linux/sysctl.h>
> +#include <linux/stacktrace.h>
> +#include <linux/seq_file.h>
> +#include <linux/proc_fs.h>
>  
>  #include <asm/irq_regs.h>
>  #include <linux/perf_event.h>
>  
> +#define STALL_MAX_TRACE_DEPTH 50
>  int watchdog_enabled = 1;
>  int __read_mostly watchdog_thresh = 10;
>  unsigned long worst_softstall;
> +static unsigned long softstall_trace_entries[STALL_MAX_TRACE_DEPTH];
> +static struct stack_trace softstall_trace = {
> +	.nr_entries = 0,
> +	.max_entries = STALL_MAX_TRACE_DEPTH,
> +	.entries = softstall_trace_entries,
> +	.skip = 0
> +};
>  static DEFINE_SPINLOCK(softstall_lock);
>  
>  static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
> @@ -46,6 +57,13 @@ static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_missed);
>  static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
>  
>  unsigned long worst_hardstall;
> +static unsigned long hardstall_trace_entries[STALL_MAX_TRACE_DEPTH];
> +static struct stack_trace hardstall_trace = {
> +	.nr_entries = 0,
> +	.max_entries = STALL_MAX_TRACE_DEPTH,
> +	.entries = hardstall_trace_entries,
> +	.skip = 0
> +};
>  static DEFINE_SPINLOCK(hardstall_lock);
>  
>  /* The number of consecutive hard check failures before it's a lockup */
> @@ -210,23 +228,16 @@ void touch_softlockup_watchdog_sync(void)
>  /* watchdog detector functions */
>  static void update_hardstall(unsigned long stall, int this_cpu)
>  {
> -	int update_stall = 0;
> -
>  	if (stall > hardstall_thresh && stall > worst_hardstall) {
>  		unsigned long flags;
>  		spin_lock_irqsave(&hardstall_lock, flags);
> -		update_stall = stall > worst_hardstall;
> -		if (update_stall)
> +		if (stall > worst_hardstall) {
>  			worst_hardstall = stall;
> +			hardstall_trace.nr_entries = 0;
> +			save_stack_trace(&hardstall_trace);
> +		}
>  		spin_unlock_irqrestore(&hardstall_lock, flags);
>  	}
> -
> -	if (update_stall) {
> -		printk(KERN_WARNING "LOCKUP may be in progress!"
> -			"Worst hard stall seen on CPU#%d: %lu interrupts missed\n",
> -			this_cpu, stall);
> -		dump_stack();
> -	}
>  }
>  
>  static int is_hardlockup(int this_cpu)
> @@ -252,23 +263,17 @@ static int is_hardlockup(int this_cpu)
>  
>  static void update_softstall(unsigned long stall, int this_cpu)
>  {
> -	int update_stall = 0;
>  	if (stall > get_softstall_thresh() &&
>  			stall > worst_softstall + softstall_diff_thresh) {
>  		unsigned long flags;
>  		spin_lock_irqsave(&softstall_lock, flags);
> -		update_stall = stall > worst_softstall + softstall_diff_thresh;
> -		if (update_stall)
> +		if (stall > worst_softstall + softstall_diff_thresh) {
>  			worst_softstall = stall;
> +			softstall_trace.nr_entries = 0;
> +			save_stack_trace(&softstall_trace);
> +		}
>  		spin_unlock_irqrestore(&softstall_lock, flags);
>  	}
> -
> -	if (update_stall) {
> -		printk(KERN_WARNING "LOCKUP may be in progress!"
> -				"Worst soft stall seen on CPU#%d: %lums\n",
> -				this_cpu, stall);
> -		dump_stack();
> -	}
>  }
>  
>  static int is_softlockup(unsigned long touch_ts, int this_cpu)
> @@ -667,10 +672,63 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
>  	.notifier_call = cpu_callback
>  };
>  
> +static int show_stall_trace(struct seq_file *f, void *v)
> +{
> +	int i, end;
> +	struct stack_trace *trace = f->private;
> +	spinlock_t *lock;

This lock is defined locally, I don't think that is what you want.  Locks
need to be a shared variable.  You might want to use a mutex here so it
can sleep in case the stack trace is long.  It is only called from the
user context I believe so it should be fine.

> +	unsigned long flags;
> +
> +	if (trace == &softstall_trace)
> +		lock = &softstall_lock;
> +	else
> +		lock = &hardstall_lock;
> +
> +	end = trace->nr_entries;
> +	/* don't bother printing the trailing value */
> +	if (end < trace->max_entries)
> +		end--;
> +
> +	spin_lock_irqsave(lock, flags);
> +	for (i = 0; i < end; i++) {
> +		seq_printf(f, "[<%pK>] %pS\n", (void *)trace->entries[i],
> +				(void *)trace->entries[i]);
> +	}
> +	spin_unlock_irqrestore(lock, flags);
> +
> +	return 0;
> +}
> +
> +static int softstall_trace_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, show_stall_trace, &softstall_trace);
> +}
> +
> +static int hardstall_trace_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, show_stall_trace, &hardstall_trace);
> +}
> +
> +static struct file_operations softstall_trace_ops = {
> +	.open = softstall_trace_open,
> +	.read = seq_read,
> +	.write = seq_write,
> +	.llseek = seq_lseek,
> +	.release = seq_release
> +};
> +static struct file_operations hardstall_trace_ops = {
> +	.open = hardstall_trace_open,
> +	.read = seq_read,
> +	.write = seq_write,
> +	.llseek = seq_lseek,
> +	.release = seq_release
> +};
> +
>  void __init lockup_detector_init(void)
>  {
>  	void *cpu = (void *)(long)smp_processor_id();
>  	int err;
> +	struct proc_dir_entry *entry;
>  
>  	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
>  	WARN_ON(notifier_to_errno(err));
> @@ -678,5 +736,12 @@ void __init lockup_detector_init(void)
>  	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
>  	register_cpu_notifier(&cpu_nfb);
>  
> +	entry = create_proc_entry("softstall_trace", 0444, NULL);
> +	if (entry)
> +		entry->proc_fops = &softstall_trace_ops;
> +	entry = create_proc_entry("hardstall_trace", 0444, NULL);
> +	if (entry)
> +		entry->proc_fops = &hardstall_trace_ops;

Where do these get created?  Under /proc?  I don't think that will be
allowed.  I would think this is a debug feature and we should create
something under /sys/kernel/debug like lockup_detector and stick these files in
there.

Cheers,
Don
