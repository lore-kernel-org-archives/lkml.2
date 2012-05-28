Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2E1MiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 08:38:11 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62370 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab2E1MiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 08:38:08 -0400
Date: Tue, 29 May 2012 04:37:57 +0800
From: Luming Yu <luming.yu@gmail.com>
To: jcm@jonmasters.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch] a simple hardware detector for latency as well as throughput
 ver. 0.1.0
Message-ID: <20120528203757.GA1713@p4.domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

The patch is the fist step to test some basic hardware functions like
TSC to help people understand if there is any hardware latency as well as
throughput problem exposed on bare metal or left behind by BIOS or
interfered by SM. Currently the patch tests hardware features
(tsc,freq, and rdrandom whiich is new instruction to get random
number) in stop_machine context. I will add more after the first step
get merged for those guys who want to directly play with new hardware
functions.

I suppose I can add your signed-off-by as the code is derived from your
hwlat_dector.

I'm also reuqesting if you are going to queue it up somewhere that can
be pulled into 3.5.

Of cause, I will update the patch based upon any comments that you
think must be fixed for 3.5 merge.

Thanks,
Luming


Signed-off-by Luming Yu <luming.yu@intel.com>


 Kconfig   |    7 
 Makefile  |    2 
 hw_test.c |  954 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 963 insertions(+)


diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c779509..f66ad56 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -123,6 +123,13 @@ config IBM_ASM
 	  for information on the specific driver level and support statement
 	  for your IBM server.
 
+config HW_TEST
+	tristate "Testing module to detect hardware lattency and throughput"
+	depends on DEBUG_FS
+	depends on RING_BUFFER
+	depends on X86
+	default m
+
 config PHANTOM
 	tristate "Sensable PHANToM (PCI)"
 	depends on PCI
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 3e1d801..ec1de86 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -48,4 +48,6 @@ obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
+obj-$(CONFIG_HW_TEST)		+= hw_test.o
+
 obj-$(CONFIG_MAX8997_MUIC)	+= max8997-muic.o
diff --git a/drivers/misc/hw_test.c b/drivers/misc/hw_test.c
new file mode 100644
index 0000000..a4e2da0
--- /dev/null
+++ b/drivers/misc/hw_test.c
@@ -0,0 +1,954 @@
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/ring_buffer.h>
+#include <linux/stop_machine.h>
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <linux/kthread.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+#include <linux/version.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/random.h>
+#include <asm/tlbflush.h>
+
+#define BUF_SIZE_DEFAULT	262144UL
+#define BUF_FLAGS	(RB_FL_OVERWRITE)
+#define	U64STR_SIZE	22
+#define DEBUGFS_BUF_SIZE	1024
+#define DEBUGFS_NAME_SIZE	32
+
+#define	VERSION		"0.1.0"
+#define BANNER		"hardware test"
+#define DRVNAME		"hw_test"
+
+#define DEFAULT_SAMPLE_WINDOW	1000000	
+#define	DEFAULT_SAMPLE_WIDTH	500000
+#define	DEFAULT_LAT_THRESHOLD	10
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Luming Yu <luming.yu@gmail.com>");
+MODULE_DESCRIPTION("A simple hardware test");
+MODULE_VERSION(VERSION);
+
+static int debug;
+static int enabled;
+static int threshold;
+
+module_param(debug, int, 0);
+module_param(enabled, int, 0);
+module_param(threshold, int, 0);
+
+static struct ring_buffer *ring_buffer;
+static DEFINE_MUTEX(ring_buffer_mutex);
+static unsigned long buf_size = 262144UL;
+static struct task_struct *kthread;
+
+struct sample;
+struct data;
+
+struct sample_function {
+	const char *name;
+	struct list_head list;
+	int (*get_sample)(void *unused);
+};
+static struct sample_function *current_sample_func = NULL;
+static LIST_HEAD(sample_function_list);
+static DEFINE_MUTEX(sample_function_mutex);
+static int sample_function_register(struct sample_function *sf);
+
+static struct dentry *debug_dir;
+static struct dentry *debug_available;
+static struct dentry *debug_current;
+static struct dentry *debug_max;
+static struct dentry *debug_count;
+static struct dentry *debug_sample_width;
+static struct dentry *debug_sample_window;
+static struct dentry *debug_sample;
+static struct dentry *debug_threshold;
+static struct dentry *debug_enable;
+
+static int __buffer_add_sample(struct sample *sample);
+static struct sample *buffer_get_sample(struct sample *sample);
+
+static int kthread_fn(void *unused);
+static int start_kthread(void);
+static int stop_kthread(void);
+static void __reset_stats(void);
+static int init_stats(void);
+
+static ssize_t simple_data_read(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos, const u64 *entry);
+static ssize_t simple_data_write(struct file *filp, const char __user *ubuf,
+				size_t cnt, loff_t *ppos, u64 *entry);
+static int debug_sample_fopen(struct inode *inode, struct file *filp);
+static ssize_t debug_sample_fread(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos);
+static int debug_sample_release(struct inode *inode, struct file *filp);
+static int debug_enable_fopen(struct inode *inode, struct file *filp);
+static ssize_t debug_enable_fread(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos);
+static ssize_t debug_enable_fwrite(struct file *filp, 
+				const char __user *user_buffer,
+				size_t user_size, loff_t *offset);
+
+static int init_debugfs(void);
+static void free_debugfs(void);
+static int hw_test_init(void);
+static void hw_test_exit(void);
+
+struct sample {
+	u64	seqnum;
+	u64	duration;
+	struct timespec	timestamp;
+	unsigned long	lost;
+};
+
+static struct data {
+	struct mutex lock;
+	u64	count;
+	u64	max_sample;
+	u64	threshold;
+
+	u64	sample_window;
+	u64	sample_width;
+
+	atomic_t sample_open;
+
+	wait_queue_head_t wq;
+} data;
+
+static ktime_t	now;
+
+static int sample_function_register(struct sample_function *sf)
+{
+	struct list_head *entry = &sample_function_list;
+	mutex_lock(&sample_function_mutex);
+	list_add(&sf->list, entry);
+	current_sample_func = sf;
+	mutex_unlock(&sample_function_mutex);
+	return 0;
+}
+
+static int __buffer_add_sample(struct sample *sample)
+{
+	return ring_buffer_write(ring_buffer,
+				sizeof(struct sample), sample);
+}
+
+static struct sample *buffer_get_sample(struct sample *sample)
+{
+	struct ring_buffer_event *e = NULL;
+	struct sample *s = NULL;
+	unsigned int cpu = 0;
+
+	if (!sample)
+		return NULL;
+	
+	mutex_lock(&ring_buffer_mutex);
+	for_each_online_cpu(cpu) {
+		e = ring_buffer_consume(ring_buffer, cpu, NULL, &sample->lost);
+		if (e)
+			break;
+	}
+	if (e) {
+		s = ring_buffer_event_data(e);
+		memcpy(sample, s, sizeof(struct sample));
+	} else
+		sample = NULL;
+	mutex_unlock(&ring_buffer_mutex);
+	return sample;
+}
+
+static int buffer_add_sample(u64 sample)
+{
+	int ret = 0;
+
+	if (sample > data.threshold) {
+		struct sample s;
+
+		data.count++;
+		s.seqnum = data.count;
+		s.duration = sample;
+		s.timestamp = CURRENT_TIME;
+		ret = __buffer_add_sample(&s);
+
+		if (sample > data.max_sample)
+			data.max_sample = sample;
+	}
+	return ret;
+}
+
+static int get_random_bytes_sample(void *unused)
+{
+	u32 *buffer;
+	ktime_t	start, t1, t2;
+	s64	diff, total = 0;
+	u64	sample = 0;
+	int	ret = 1;
+
+	buffer = kzalloc(1024, GFP_KERNEL);
+
+	start = ktime_get();
+	do {
+
+		t1 = ktime_get();
+		get_random_bytes(buffer, 1024);
+		t2 = ktime_get();
+		total = ktime_to_us(ktime_sub(t2, start));
+		diff = ktime_to_us(ktime_sub(t2, t1));
+
+		if (diff < 0) {
+			printk(KERN_ERR BANNER "time running backwards\n");
+			goto out;
+		} 
+
+		if (diff > sample)
+			sample = diff;
+
+	} while (total <= data.sample_width);
+
+	ret = buffer_add_sample(sample);
+out:
+	kfree(buffer);
+	return ret;
+}
+static int get_freq_sample(void *unused)
+{
+	ktime_t	start, t1, t2;
+	s64	diff, total = 0;
+	u32	sample = 0;
+	int	ret = 1;
+	unsigned int cpu_tsc_freq;
+	static DEFINE_MUTEX(freq_pit_mutex);
+
+	start = ktime_get();
+	do {
+		t1 = ktime_get();
+		mutex_lock(&freq_pit_mutex);
+		cpu_tsc_freq = x86_platform.calibrate_tsc();
+		mutex_unlock(&freq_pit_mutex);
+		t2 = ktime_get();
+		total = ktime_to_us(ktime_sub(t2, start));
+		diff = abs(cpu_tsc_freq - tsc_khz);
+
+		if (diff < 0) {
+			printk(KERN_ERR BANNER "time running backwards\n");
+			goto out;
+		} 
+
+		if (diff > sample)
+			sample = diff;
+
+	} while (total <= data.sample_width);
+
+	ret = buffer_add_sample(sample);
+out:
+	return ret;
+}
+
+static int get_tsc_sample(void *unused)
+{
+	ktime_t	start, t1, t2;
+	s64	diff, total = 0;
+	u64	sample = 0;
+	int	ret = 1;
+
+	now = start = ktime_get();
+	do {
+		t1 = now;
+		now = t2 = ktime_get();
+
+		total = ktime_to_ns(ktime_sub(t2, start));
+		diff = ktime_to_ns(ktime_sub(t2, t1));
+
+		if (diff < 0) {
+			printk(KERN_ERR BANNER "time running backwards\n");
+			goto out;
+		} 
+
+		if (diff > sample)
+			sample = diff;
+
+	} while (total <= data.sample_width);
+
+	ret = buffer_add_sample(sample);
+out:
+	return ret;
+}
+
+
+struct sample_function tsc_sample = {
+	.name		= "tsc",
+	.get_sample 	= get_tsc_sample,
+};
+
+struct sample_function tsc_freq_sample = {
+	.name		= "freq",
+	.get_sample 	= get_freq_sample,
+};
+
+struct sample_function random_bytes_sample = {
+	.name		= "random_bytes",
+	.get_sample 	= get_random_bytes_sample,
+};
+
+static int kthread_fn(void *unused)
+{
+	int err = 0;
+	u64 interval = 0;
+	int (*get_sample)(void *unused);
+	
+	mutex_lock(&sample_function_mutex);
+	if (current_sample_func)
+		get_sample = current_sample_func->get_sample;
+	else
+		goto out;
+
+	while (!kthread_should_stop()) {
+		mutex_lock(&data.lock);
+	
+		err = stop_machine(get_sample, unused, cpu_online_mask);
+		if (err) {
+			mutex_unlock(&data.lock);
+			goto err_out;
+		}
+
+		wake_up(&data.wq);
+
+		interval = data.sample_window - data.sample_width;
+		do_div(interval, USEC_PER_MSEC);
+
+		mutex_unlock(&data.lock);
+		if (msleep_interruptible(interval))
+			goto out;
+	}
+	goto out;
+err_out:
+	printk(KERN_ERR BANNER "could not call stop_machine, disabling\n");
+	enabled = 0;
+out:
+	mutex_unlock(&sample_function_mutex);
+	return err;
+}
+
+static int start_kthread(void)
+{
+	kthread = kthread_run(kthread_fn, NULL, DRVNAME);
+	if (IS_ERR(kthread)) {
+		printk(KERN_ERR BANNER "could not start sampling thread\n");
+		enabled = 0;
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static int stop_kthread(void)
+{
+	int ret;
+	ret = kthread_stop(kthread);
+	return ret;
+}
+
+static void __reset_stats(void)
+{
+	data.count = 0;
+	data.max_sample = 0;
+	ring_buffer_reset(ring_buffer);
+}
+
+static int init_stats(void)
+{
+	int ret = -ENOMEM;
+	
+	mutex_init(&data.lock);
+	init_waitqueue_head(&data.wq);
+	atomic_set(&data.sample_open,0);
+
+	ring_buffer = ring_buffer_alloc(buf_size, BUF_FLAGS);
+
+	if (WARN(!ring_buffer, KERN_ERR BANNER
+		"failed to allocate ring buffer!\n"))
+		goto out;
+	__reset_stats();
+	data.threshold = DEFAULT_LAT_THRESHOLD;
+	data.sample_window = DEFAULT_SAMPLE_WINDOW;
+	data.sample_width = DEFAULT_SAMPLE_WIDTH;
+	ret = 0;
+out:
+	return ret;
+}
+
+static ssize_t simple_data_read(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos, const u64 *entry)
+{
+	char buf[U64STR_SIZE];
+	u64 val = 0;
+	int len = 0;
+
+	memset(buf, 0, sizeof(buf));
+	if (!entry)
+		return -EFAULT;
+	mutex_lock(&data.lock);
+	val = *entry;
+	mutex_unlock(&data.lock);
+	len = snprintf(buf, sizeof(buf), "%llu\n", (unsigned long long)val);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
+}
+
+static ssize_t simple_data_write(struct file *filp, const char __user *ubuf,
+				size_t cnt, loff_t *ppos, u64 *entry)
+{
+	char buf[U64STR_SIZE];
+	int csize = min(cnt, sizeof(buf));
+	u64 val = 0;
+	int err = 0;
+
+	memset(buf, '\0', sizeof(buf));
+	if (copy_from_user(buf, ubuf, csize))
+		return -EFAULT;
+	buf[U64STR_SIZE-1] = '\0';
+	err = strict_strtoull(buf, 10, &val);
+	if (err)
+		return -EINVAL;
+	mutex_lock(&data.lock);
+	*entry = val;
+	mutex_unlock(&data.lock);
+	return csize;
+}
+
+static int debug_available_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+static ssize_t debug_available_fread(struct file *filp, char __user *ubuf,
+					size_t	cnt, loff_t *ppos)
+{
+	struct sample_function *sf;
+	ssize_t	count = 0;
+	char *buf;
+
+	buf = kzalloc(DEBUGFS_BUF_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	mutex_lock(&sample_function_mutex);
+	list_for_each_entry(sf, &sample_function_list, list) {
+		count += snprintf(buf + count,
+			max((ssize_t)(DEBUGFS_BUF_SIZE - count), (ssize_t)0),
+			"%s ", sf->name); 
+	}
+	mutex_unlock(&sample_function_mutex);
+	
+	count += snprintf(buf + count,
+				max((ssize_t )DEBUGFS_BUF_SIZE - count, (ssize_t) 0),
+				"\n");
+	count = simple_read_from_buffer(ubuf, cnt, ppos, buf, count); 
+	kfree(buf);
+	return count;
+}
+
+static ssize_t debug_available_fwrite(struct file *filp, const char __user *ubuf,
+					size_t	cnt, loff_t *ppos)
+{
+	return (ssize_t) 0;
+}
+
+static int debug_current_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+static ssize_t debug_current_fread(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	ssize_t	count = 0;
+	char *buf;
+
+	buf = kzalloc(DEBUGFS_NAME_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	count += snprintf(buf + count,
+		max((ssize_t)DEBUGFS_NAME_SIZE - count, (ssize_t)0),
+			"%s ", current_sample_func->name); 
+	count += snprintf(buf + count,
+			max((ssize_t)DEBUGFS_NAME_SIZE - count, (ssize_t)0),
+			"\n");
+	count = simple_read_from_buffer(ubuf, cnt, ppos, buf, count); 
+	kfree(buf);
+
+	return count;
+}
+
+static ssize_t debug_current_fwrite(struct file *filp, const char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	char *buf;
+	ssize_t count;
+	struct sample_function *sf;
+
+	buf = kzalloc(DEBUGFS_NAME_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	count = simple_write_to_buffer(buf, DEBUGFS_NAME_SIZE, ppos, ubuf, cnt);
+	mutex_lock(&sample_function_mutex);
+	list_for_each_entry(sf, &sample_function_list, list) {
+		if (strncmp(sf->name, buf, count-1) !=0)
+			continue;
+		current_sample_func = sf;
+		break;
+	}
+	mutex_unlock(&sample_function_mutex);
+	return (ssize_t) count;
+}
+
+static int debug_count_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+static ssize_t debug_count_fread(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	return simple_data_read(filp, ubuf, cnt, ppos, &data.count);
+}
+static ssize_t debug_count_fwrite(struct file *filp, const char __user *ubuf,
+					size_t cnt,
+					loff_t *ppos)
+{
+	return simple_data_write(filp, ubuf, cnt, ppos, &data.count);
+}
+static int debug_enable_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+static ssize_t debug_enable_fread(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	char buf[4];
+	if ((cnt < sizeof(buf)) || (*ppos))
+		return 0;
+	buf[0] = enabled ? '1' : '0';
+	buf[1] = '\n';
+	buf[2] = '\0';
+	if (copy_to_user(ubuf, buf, strlen(buf)))
+		return -EFAULT;
+	return *ppos = strlen(buf);
+}
+static ssize_t debug_enable_fwrite(struct file *filp,
+					const char __user *ubuf,
+					size_t cnt,
+					loff_t *ppos)
+{
+	char buf[4];
+	int csize = min(cnt, sizeof(buf));
+	long val = 0;
+	int err = 0;
+
+	memset(buf, '\0', sizeof(buf));
+	if (copy_from_user(buf, ubuf, csize))
+		return -EFAULT;
+	buf[sizeof(buf)-1] = '\0';
+	err = strict_strtoul(buf, 10, &val);
+	if (0 != err)
+		return -EINVAL;
+	if (val) {
+		if (enabled)
+			goto unlock;
+		enabled = 1;
+		if (start_kthread())
+			return -EFAULT;
+	} else {
+		if (!enabled)
+			goto unlock;
+		enabled = 0;
+		err = stop_kthread();
+		if (err) {
+			printk(KERN_ERR BANNER "cannot stop kthread\n");
+			return -EFAULT;
+		}
+		wake_up(&data.wq);
+	}
+unlock:
+	return csize;
+}
+static int debug_max_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+static ssize_t debug_max_fread(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	return simple_data_read(filp, ubuf, cnt, ppos, &data.max_sample);
+}
+static ssize_t debug_max_fwrite(struct file *filp,
+				const char __user *ubuf,
+				size_t	cnt,
+				loff_t	*ppos)
+{
+	return simple_data_write(filp, ubuf, cnt, ppos, &data.max_sample);
+}
+static int debug_sample_fopen(struct inode *inode, struct file *filp)
+{
+	if (!atomic_add_unless(&data.sample_open, 1, 1))
+		return -EBUSY;
+	else
+		return 0;
+}
+static ssize_t debug_sample_fread(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	int len = 0;
+	char buf[64];
+	struct sample *sample = NULL;
+
+	if (!enabled)
+		return 0;
+	sample = kzalloc(sizeof(struct sample), GFP_KERNEL);
+	if(!sample)
+		return -ENOMEM;
+
+	while (!buffer_get_sample(sample)) {
+		DEFINE_WAIT(wait);
+		if (filp->f_flags & O_NONBLOCK) {
+			len = -EAGAIN;
+			goto out;
+		}
+		prepare_to_wait(&data.wq, &wait, TASK_INTERRUPTIBLE);
+		schedule();
+		finish_wait(&data.wq, &wait);
+		if (signal_pending(current)) {
+			len = -EINTR;
+			goto out;
+		}
+		if (!enabled) {
+			len = 0;
+			goto out;
+		}
+	}
+	len = snprintf(buf, sizeof(buf), "%010lu.%010lu\t%llu\n",
+			sample->timestamp.tv_sec,
+			sample->timestamp.tv_nsec,
+			sample->duration);
+	if (len > cnt)
+		goto out;
+	if (copy_to_user(ubuf, buf,len))
+		len = -EFAULT;
+out:
+	kfree(sample);
+	return len;
+}
+
+static int debug_sample_release(struct inode *inode, struct file *filp)
+{
+	atomic_dec(&data.sample_open);
+	return 0;
+}
+static int debug_threshold_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+static ssize_t debug_threshold_fread(struct file *filp, char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	return simple_data_read(filp, ubuf, cnt, ppos, &data.threshold);
+}
+static ssize_t debug_threshold_fwrite(struct file *filp,
+					const char __user *ubuf,
+					size_t cnt,
+					loff_t *ppos)
+{
+	int ret;
+	ret = simple_data_write(filp, ubuf, cnt, ppos, &data.threshold);
+	if (enabled)
+		wake_up_process(kthread);
+	return ret;
+}
+static int debug_width_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+static ssize_t debug_width_fread(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	return simple_data_read(filp, ubuf, cnt, ppos, &data.sample_width);
+}
+static ssize_t debug_width_fwrite(struct file *filp,
+					const char __user *ubuf,
+					size_t cnt,
+					loff_t *ppos)
+{
+	char buf[U64STR_SIZE];
+	int csize = min(cnt, sizeof(buf));
+	u64 val = 0;
+	int err = 0;
+
+	memset(buf, '\0', sizeof(buf));
+	if (copy_from_user(buf, ubuf, csize))
+		return -EFAULT;
+	buf[U64STR_SIZE-1] = '\0';
+	err = strict_strtoull(buf, 10, &val);
+	if (0 != err)
+		return -EINVAL;
+	mutex_lock(&data.lock);
+	if (val < data.sample_window)
+		data.sample_width = val;
+	else {
+		mutex_unlock(&data.lock);
+		return -EINVAL;
+	}
+	mutex_unlock(&data.lock);
+	if (enabled)
+		wake_up_process(kthread);
+
+	return csize;
+}
+static int debug_window_fopen(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+static ssize_t debug_window_fread(struct file *filp, char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	return simple_data_read(filp, ubuf, cnt, ppos, &data.sample_window);
+}
+static ssize_t debug_window_fwrite(struct file *filp,
+					const char __user *ubuf,
+					size_t cnt,
+					loff_t *ppos)
+{
+	char buf[U64STR_SIZE];
+	int csize = min(cnt, sizeof(buf));
+	u64 val = 0;
+	int err = 0;
+
+	memset(buf, '\0', sizeof(buf));
+	if (copy_from_user(buf, ubuf, csize))
+		return -EFAULT;
+	buf[U64STR_SIZE-1] = '\0';
+	err = strict_strtoull(buf, 10, &val);
+	if (0 != err)
+		return -EINVAL;
+	mutex_lock(&data.lock);
+	if (data.sample_width < val)
+		data.sample_window = val;
+	else {
+		mutex_unlock(&data.lock);
+		return -EINVAL;
+	}
+	mutex_unlock(&data.lock);
+	return csize;
+}
+
+static const struct file_operations available_fops = {
+	.open	= debug_available_fopen,
+	.read	= debug_available_fread,
+	.write	= debug_available_fwrite,
+	.owner	= THIS_MODULE,
+};
+
+static const struct file_operations current_fops = {
+	.open	= debug_current_fopen,
+	.read	= debug_current_fread,
+	.write	= debug_current_fwrite,
+	.owner	= THIS_MODULE,
+};
+
+static const struct file_operations count_fops = {
+	.open	= debug_count_fopen,
+	.read	= debug_count_fread,
+	.write	= debug_count_fwrite,
+	.owner	= THIS_MODULE,
+};
+
+static const struct file_operations enable_fops = {
+	.open	= debug_enable_fopen,
+	.read	= debug_enable_fread,
+	.write	= debug_enable_fwrite,
+	.owner	= THIS_MODULE,
+};
+
+static const struct file_operations max_fops = {
+	.open	= debug_max_fopen,
+	.read	= debug_max_fread,
+	.write	= debug_max_fwrite,
+	.owner	= THIS_MODULE,
+};
+
+static const struct file_operations sample_fops = {
+	.open	= debug_sample_fopen,
+	.read	= debug_sample_fread,
+	.release = debug_sample_release,
+	.owner	= THIS_MODULE,
+};
+
+static const struct file_operations threshold_fops = {
+	.open 	= debug_threshold_fopen,
+	.read	= debug_threshold_fread,
+	.write	= debug_threshold_fwrite,
+	.owner	= THIS_MODULE,
+};
+
+static const struct file_operations width_fops = {
+	.open 	= debug_width_fopen,
+	.read 	= debug_width_fread,
+	.write	= debug_width_fwrite,
+	.owner	= THIS_MODULE,
+};
+
+static const struct file_operations window_fops = {
+	.open	= debug_window_fopen,
+	.read	= debug_window_fread,
+	.write	= debug_window_fwrite,
+	.owner	= THIS_MODULE,
+};
+static int init_debugfs(void)
+{
+	int ret = -ENOMEM;
+
+	debug_dir = debugfs_create_dir(DRVNAME, NULL);
+	if (!debug_dir)
+		goto err_debug_dir;
+
+	debug_available = debugfs_create_file("available", 0444,
+						debug_dir, NULL,
+						&available_fops);
+	if (!debug_available)
+		goto err_available;
+
+	debug_current = debugfs_create_file("current", 0444,
+						debug_dir, NULL,
+						&current_fops);
+	if (!debug_current)
+		goto err_current;
+
+	debug_sample = debugfs_create_file("sample", 0444,
+						debug_dir, NULL,
+						&sample_fops);
+	if (!debug_sample)
+		goto err_sample;
+	
+	debug_count = debugfs_create_file("count", 0444,
+						debug_dir, NULL,
+						&count_fops);
+	if (!debug_count)
+		goto err_count;
+
+	debug_max = debugfs_create_file("max", 0444,
+						debug_dir, NULL,
+						&max_fops);
+	if (!debug_max)
+		goto err_max;
+
+	debug_sample_window = debugfs_create_file("window", 0644,
+						debug_dir, NULL,
+						&window_fops);
+	if (!debug_sample_window)
+		goto err_window;
+
+	debug_sample_width = debugfs_create_file("width", 0644,
+						debug_dir, NULL,
+						&width_fops);
+	if (!debug_sample_width)
+		goto err_width;
+
+	debug_threshold = debugfs_create_file("threshold", 0644,
+						debug_dir, NULL,
+						&threshold_fops);
+	if (!debug_threshold)
+		goto err_threshold;
+
+	debug_enable = debugfs_create_file("enable", 0644,
+						debug_dir, &enabled,
+						&enable_fops);
+	if (!debug_enable)
+		goto err_enable;
+	else {
+		ret = 0;
+		goto out;
+	}
+	
+err_enable:
+	debugfs_remove(debug_threshold);
+err_threshold:
+	debugfs_remove(debug_sample_width);
+err_width:
+	debugfs_remove(debug_sample_window);
+err_window:
+	debugfs_remove(debug_max);
+err_max:
+	debugfs_remove(debug_count);
+err_count:
+	debugfs_remove(debug_sample);
+err_sample:
+	debugfs_remove(debug_current);
+err_current:
+	debugfs_remove(debug_available);
+err_available:
+	debugfs_remove(debug_dir);
+err_debug_dir:
+out:
+	return ret;
+}
+
+static void free_debugfs(void)
+{
+	debugfs_remove(debug_enable);
+	debugfs_remove(debug_threshold);
+	debugfs_remove(debug_sample_width);
+	debugfs_remove(debug_sample_window);
+	debugfs_remove(debug_max);
+	debugfs_remove(debug_count);
+	debugfs_remove(debug_sample);
+	debugfs_remove(debug_current);
+	debugfs_remove(debug_available);
+	debugfs_remove(debug_dir);
+}
+
+static int hw_test_init(void)
+{
+	int ret = -ENOMEM;
+	
+	printk(KERN_INFO BANNER "version %s\n", VERSION);
+
+	sample_function_register(&tsc_sample);
+	sample_function_register(&tsc_freq_sample);
+	sample_function_register(&random_bytes_sample);
+
+	ret = init_stats();
+	if (0 != ret)
+		goto out;
+	ret = init_debugfs();
+	if (0 != ret)
+		goto err_stats;
+	if (enabled)
+		ret = start_kthread();
+	goto out;
+
+err_stats:
+	ring_buffer_free(ring_buffer);
+out:
+	return ret;
+}
+
+static void hw_test_exit(void)
+{
+	int err;
+	
+	if (enabled) {
+		enabled = 0;
+		err = stop_kthread();
+		if (err)
+			printk(KERN_ERR BANNER "cannot stop kthread\n");
+	}
+	
+	free_debugfs();
+	ring_buffer_free(ring_buffer);
+}
+
+module_init(hw_test_init);
+module_exit(hw_test_exit);

