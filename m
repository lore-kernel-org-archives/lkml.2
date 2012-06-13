Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2FMPH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:07:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2FMPHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:07:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Luming Yu <luming.yu@gmail.com>
Subject: Re: [patch] a simple hardware detector for latency as well as throughput ver. 0.1.0
Date: Wed, 13 Jun 2012 15:07:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: jcm@jonmasters.org, linux-kernel@vger.kernel.org
References: <20120528203757.GA1713@p4.domain>
In-Reply-To: <20120528203757.GA1713@p4.domain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206131507.40470.arnd@arndb.de>
X-Provags-ID: V02:K0:5y1jksGBqxOFRSw2nF5I5ymAeeCJSMqUEsGlEtM2FWG
 rL6/7xEFLHASvyjko7ecDRR7sT7AwJEcB30xhcdWKhn8jsJ++e
 +2IpJGLigJPIluJGApQ8lFKJrIq8KJYV3Uc8OeqjJWHLPvAhr6
 WlsBxzdbrtoNRXKd6lLfUm3tUqp6r+bQUsOeJIVaYkyd4caYoD
 hDoeME1UbTU1hw3XWAd8reYxlFHIoYoB6R57asR7I72mkrqoMv
 A8HskLN1WOrWttUnhn3Gj0Yu6J29DwLfzVvr37j/emMSFn3bPP
 SnJvIbS69Q6umMh5nqFZyr/oKUkRcwP6xiPQbsonQfx3GeCH6i
 ju9d4/R/SxTKhA9HRhZk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luming,

On Monday 28 May 2012, Luming Yu wrote:
> The patch is the fist step to test some basic hardware functions like
> TSC to help people understand if there is any hardware latency as well as
> throughput problem exposed on bare metal or left behind by BIOS or
> interfered by SM. Currently the patch tests hardware features
> (tsc,freq, and rdrandom whiich is new instruction to get random
> number) in stop_machine context. I will add more after the first step
> get merged for those guys who want to directly play with new hardware
> functions.
> 
> I suppose I can add your signed-off-by as the code is derived from your
> hwlat_dector.
> 
> I'm also reuqesting if you are going to queue it up somewhere that can
> be pulled into 3.5.
> 
> Of cause, I will update the patch based upon any comments that you
> think must be fixed for 3.5 merge.
> 
> Signed-off-by Luming Yu <luming.yu@intel.com>
> 
> 
>  Kconfig   |    7 
>  Makefile  |    2 
>  hw_test.c |  954 
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 963 insertions(+)

Please write the text in the email so that it can be used as a permanent
changelog entry for the kernel git history. Everything that you do not
want to have in that history can go under the "---" line that separates
the Signed-off-by from the diffstat.

> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index c779509..f66ad56 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -123,6 +123,13 @@ config IBM_ASM
>  	  for information on the specific driver level and support statement
>  	  for your IBM server.
>  
> +config HW_TEST
> +	tristate "Testing module to detect hardware lattency and throughput"
> +	depends on DEBUG_FS
> +	depends on RING_BUFFER
> +	depends on X86
> +	default m
> +
>  config PHANTOM
>  	tristate "Sensable PHANToM (PCI)"
>  	depends on PCI

Any reason why this depends on X86?

I think the name "HW_TEST" is too generic. Maybe "HW_LATENCY_TEST"?

> +static struct ring_buffer *ring_buffer;
> +static DEFINE_MUTEX(ring_buffer_mutex);
> +static unsigned long buf_size = 262144UL;
> +static struct task_struct *kthread;
> +
> +struct sample;
> +struct data;
> +
> +struct sample_function {
> +	const char *name;
> +	struct list_head list;
> +	int (*get_sample)(void *unused);
> +};

why the "unused" argument?

> +static struct sample_function *current_sample_func = NULL;
> +static LIST_HEAD(sample_function_list);
> +static DEFINE_MUTEX(sample_function_mutex);
> +static int sample_function_register(struct sample_function *sf);
> +
> +static struct dentry *debug_dir;
> +static struct dentry *debug_available;
> +static struct dentry *debug_current;
> +static struct dentry *debug_max;
> +static struct dentry *debug_count;
> +static struct dentry *debug_sample_width;
> +static struct dentry *debug_sample_window;
> +static struct dentry *debug_sample;
> +static struct dentry *debug_threshold;
> +static struct dentry *debug_enable;

I think it would help here to put the local variables into a data structure
that gets allocated at module load time.

> +static int __buffer_add_sample(struct sample *sample);
> +static struct sample *buffer_get_sample(struct sample *sample);
> +
...
> +static ssize_t debug_enable_fwrite(struct file *filp, 
> +				const char __user *user_buffer,
> +				size_t user_size, loff_t *offset);
> +
> +static int init_debugfs(void);
> +static void free_debugfs(void);
> +static int hw_test_init(void);
> +static void hw_test_exit(void);

Please reorder all the functions so that you no longer need forward
declarations.

> +static int get_random_bytes_sample(void *unused)
> +{
> +	u32 *buffer;
> +	ktime_t	start, t1, t2;
> +	s64	diff, total = 0;
> +	u64	sample = 0;
> +	int	ret = 1;
> +
> +	buffer = kzalloc(1024, GFP_KERNEL);
> +
> +	start = ktime_get();
> +	do {
> +
> +		t1 = ktime_get();
> +		get_random_bytes(buffer, 1024);
> +		t2 = ktime_get();
> +		total = ktime_to_us(ktime_sub(t2, start));
> +		diff = ktime_to_us(ktime_sub(t2, t1));

You need more comments to explain why you are doing things. For instance
here: why is it a useful thing to test how long get_random_bytes()
takes?

> +static int get_freq_sample(void *unused)
> +{
> +	ktime_t	start, t1, t2;
> +	s64	diff, total = 0;
> +	u32	sample = 0;
> +	int	ret = 1;
> +	unsigned int cpu_tsc_freq;
> +	static DEFINE_MUTEX(freq_pit_mutex);
> +
> +	start = ktime_get();
> +	do {
> +		t1 = ktime_get();
> +		mutex_lock(&freq_pit_mutex);
> +		cpu_tsc_freq = x86_platform.calibrate_tsc();
> +		mutex_unlock(&freq_pit_mutex);

Or the calibrate_tsc() function.

It's also not clear what function the freq_pit_mutex has. I don't
see how the code could ever get run twice at the same time.

> +static int kthread_fn(void *unused)
> +{
> +	int err = 0;
> +	u64 interval = 0;
> +	int (*get_sample)(void *unused);
> +	
> +	mutex_lock(&sample_function_mutex);
> +	if (current_sample_func)
> +static int hw_test_init(void)
> +{
> +	int ret = -ENOMEM;
> +	
> +	printk(KERN_INFO BANNER "version %s\n", VERSION);
> +
> +	sample_function_register(&tsc_sample);
> +	sample_function_register(&tsc_freq_sample);
> +	sample_function_register(&random_bytes_sample);
> +
> +	ret = init_stats();
> +	if (0 != ret)
> +		goto out;
> +	ret = init_debugfs();
> +	if (0 != ret)
> +		goto err_stats;
> +	if (enabled)
> +		ret = start_kthread();
> +	goto out;
> +
> +err_stats:
> +	ring_buffer_free(ring_buffer);
> +out:
> +	return ret;
> +}
> +
> +static void hw_test_exit(void)
> +{
> +	int err;
> +	
> +	if (enabled) {
> +		enabled = 0;
> +		err = stop_kthread();
> +		if (err)
> +			printk(KERN_ERR BANNER "cannot stop kthread\n");
> +	}
> +	
> +	free_debugfs();
> +	ring_buffer_free(ring_buffer);
> +}
> +
> +module_init(hw_test_init);
> +module_exit(hw_test_exit);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

> +		get_sample = current_sample_func->get_sample;
> +	else
> +		goto out;
> +
> +	while (!kthread_should_stop()) {
> +		mutex_lock(&data.lock);
> +	
> +		err = stop_machine(get_sample, unused, cpu_online_mask);
> +		if (err) {
> +			mutex_unlock(&data.lock);
> +			goto err_out;
> +		}
> +
> +		wake_up(&data.wq);

Using stop_machine() sounds like a very expensive thing to do here.
Is it necessary?

> +		interval = data.sample_window - data.sample_width;
> +		do_div(interval, USEC_PER_MSEC);

Have you tried avoiding the need for do_div? You could use an "unsigned long"
to count the microseconds here, or you could do everything using miliseconds.

> +static int start_kthread(void)
> +{
> +	kthread = kthread_run(kthread_fn, NULL, DRVNAME);
> +	if (IS_ERR(kthread)) {
> +		printk(KERN_ERR BANNER "could not start sampling thread\n");
> +		enabled = 0;
> +		return -ENOMEM;
> +	}
> +	return 0;
> +}
> +
> +static int stop_kthread(void)
> +{
> +	int ret;
> +	ret = kthread_stop(kthread);
> +	return ret;
> +}

These helper functions do not appear to help. Just remove them.

> +static ssize_t simple_data_read(struct file *filp, char __user *ubuf,
> +				size_t cnt, loff_t *ppos, const u64 *entry)
> +{
> +	char buf[U64STR_SIZE];
> +	u64 val = 0;
> +	int len = 0;
> +
> +	memset(buf, 0, sizeof(buf));
> +	if (!entry)
> +		return -EFAULT;
> +	mutex_lock(&data.lock);
> +	val = *entry;
> +	mutex_unlock(&data.lock);
> +	len = snprintf(buf, sizeof(buf), "%llu\n", (unsigned long long)val);
> +	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
> +}
> +
> +static ssize_t simple_data_write(struct file *filp, const char __user *ubuf,
> +				size_t cnt, loff_t *ppos, u64 *entry)
> +{
> +	char buf[U64STR_SIZE];
> +	int csize = min(cnt, sizeof(buf));
> +	u64 val = 0;
> +	int err = 0;
> +
> +	memset(buf, '\0', sizeof(buf));
> +	if (copy_from_user(buf, ubuf, csize))
> +		return -EFAULT;
> +	buf[U64STR_SIZE-1] = '\0';
> +	err = strict_strtoull(buf, 10, &val);
> +	if (err)
> +		return -EINVAL;
> +	mutex_lock(&data.lock);
> +	*entry = val;
> +	mutex_unlock(&data.lock);
> +	return csize;
> +}

These look like you can use DEFINE_SIMPLE_ATTRIBUTE() or debugfs_create_u64()
to simplify your code.

> +static int debug_available_fopen(struct inode *inode, struct file *filp)
> +{
> +	return 0;
> +}

Just use simple_open() or no open function in the file_operations, there is
no need to provide an empty function.

> +static ssize_t debug_available_fwrite(struct file *filp, const char __user *ubuf,
> +					size_t	cnt, loff_t *ppos)
> +{
> +	return (ssize_t) 0;
> +}

Same for empty write functions.

> +static int init_debugfs(void)
> +{
> +	int ret = -ENOMEM;
> +
> +	debug_dir = debugfs_create_dir(DRVNAME, NULL);
> +	if (!debug_dir)
> +		goto err_debug_dir;
> +
> +	debug_available = debugfs_create_file("available", 0444,
> +						debug_dir, NULL,
> +						&available_fops);
> +	if (!debug_available)
> +		goto err_available;
> +
> +	debug_current = debugfs_create_file("current", 0444,
> +						debug_dir, NULL,
> +						&current_fops);
> +	if (!debug_current)
> +		goto err_current;
> +
> +	debug_sample = debugfs_create_file("sample", 0444,
> +						debug_dir, NULL,
> +						&sample_fops);
> +	if (!debug_sample)
> +		goto err_sample;
> +	
> +	debug_count = debugfs_create_file("count", 0444,
> +						debug_dir, NULL,
> +						&count_fops);

Just use an array of file_operations and create the files using a loop.


	Arnd
