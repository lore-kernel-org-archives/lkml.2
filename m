Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab2FYNXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:23:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37635 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab2FYNX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:23:29 -0400
Date: Tue, 26 Jun 2012 05:23:12 +0800
From: Luming Yu <luming.yu@gmail.com>
To: arnd@arndb.de
Cc: jcm@jonmasters.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [patch update-v1] a simple hardware detector for latency as well as
 throughput ver. 0.1.0
Message-ID: <20120625212312.GA2345@p4.domain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is the fist step to test some basic hardware functions like
TSC to help people understand if there is any hardware latency as well
as throughput problem exposed on bare metal or left behind by BIOS or
interfered by SMI. Currently the patch tests TSC, CPU Frequency, and
RDRAND, which is a new CPU instruction to get random number introudced
in new CPU like Intel Ivy Bridge, in stop_machine context.

The tsc samples (ns) below are from a P4 system. You can change from 0 
to 1000 in /sys/kernel/debug/hw_atency_test/threshold to TSC sample at ms.

[root@p4 linux]# rmmod hw_latency_test
[root@p4 linux]# insmod drivers/misc/hw_latency_test.ko
[root@p4 linux]# echo tsc > /sys/kernel/debug/hw_latency_test/current
[root@p4 linux]# echo 1 > /sys/kernel/debug/hw_latency_test/enable
[root@p4 linux]# cat /sys/kernel/debug/hw_latency_test/sample
1340657264.0434121340   388
1340657264.0935125912   379
1340657265.0436123548   404
1340657265.0937122432   441
....
^C
[root@p4 linux]# echo 0 > /sys/kernel/debug/hw_latency_test/enable

Signed-off-by: Luming  Yu <luming.yu@intel.com>
---
I will add more tests after the first patch gets merged for those guys
who want to directly play with new hardware functions, and latency and
bandwidth is concern, or simply out of curiosity. The patch is based on 
hardware latency dector written by Jcm in RT-tree. I assume I can add 
Jcm's signed off here.


 drivers/misc/Kconfig           |    7 +
 drivers/misc/Makefile          |    2 +
 drivers/misc/hw_latency_test.c |  833 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 842 insertions(+), 0 deletions(-)


diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c779509..a5216b5 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -123,6 +123,13 @@ config IBM_ASM
 	  for information on the specific driver level and support statement
 	  for your IBM server.
 
+config HW_LATENCY_TEST
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
index 3e1d801..f95c849 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -48,4 +48,6 @@ obj-y				+= lis3lv02d/
 obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
+obj-$(CONFIG_HW_LATENCY_TEST)	+= hw_latency_test.o
+
 obj-$(CONFIG_MAX8997_MUIC)	+= max8997-muic.o
diff --git a/drivers/misc/hw_latency_test.c b/drivers/misc/hw_latency_test.c
new file mode 100644
index 0000000..2aa3a74
--- /dev/null
+++ b/drivers/misc/hw_latency_test.c
@@ -0,0 +1,833 @@
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
+#define BANNER		"hardware latency test"
+#define DRVNAME		"hw_latency_test"
+
+#define DEFAULT_SAMPLE_WINDOW	1000000	
+#define	DEFAULT_SAMPLE_WIDTH	500000
+#define	DEFAULT_LAT_THRESHOLD	10
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Luming Yu <luming.yu@gmail.com>");
+MODULE_DESCRIPTION("A simple hardware latency test");
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
+struct sample_function {
+	const char *name;
+	struct list_head list;
+	int (*get_sample)(void *unused);
+};
+static struct sample_function *current_sample_func = NULL;
+static LIST_HEAD(sample_function_list);
+static DEFINE_MUTEX(sample_function_mutex);
+static int sample_function_register(struct sample_function *sf);
+static struct dentry *debug_dir;
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
+/*
+ * For new instruction rdrand since Intel Ivy Bridge processor
+ */
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
+
+/*
+ * For cpu frequency testing
+ */
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
+/*
+ * For TSC latency as well as SMI detecting 
+ */
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
+#define debug_available_fopen	simple_open
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
+#define debug_available_fwrite	simple_attr_write
+
+#define debug_available_release	simple_attr_release
+
+#define debug_current_fopen	simple_open
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
+#define debug_current_release	simple_attr_release
+
+#define debug_count_fopen	simple_open
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
+#define debug_count_release	simple_attr_release
+
+#define debug_enable_fopen	simple_open
+
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
+#define debug_enable_release	simple_attr_release
+
+#define debug_max_fopen	simple_open
+
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
+#define debug_max_release	simple_attr_release
+
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
+#define debug_sample_fwrite	simple_attr_write
+
+static int debug_sample_release(struct inode *inode, struct file *filp)
+{
+	atomic_dec(&data.sample_open);
+	return 0;
+}
+
+#define debug_threshold_fopen	simple_open
+
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
+#define debug_threshold_release	simple_attr_release
+
+#define debug_width_fopen	simple_open
+
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
+#define debug_width_release	simple_attr_release
+
+#define debug_window_fopen	simple_open
+
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
+#define debug_window_release	simple_attr_release
+
+#define DEFINE_DEBUGFS_FILE(name)				\
+	static const struct file_operations name##_fops = {	\
+		.open = debug_##name##_fopen,			\
+		.read = debug_##name##_fread,			\
+		.write = debug_##name##_fwrite,			\
+		.release = debug_##name##_release,		\
+		.owner = THIS_MODULE,				\
+	};
+
+DEFINE_DEBUGFS_FILE(available)
+DEFINE_DEBUGFS_FILE(current)
+DEFINE_DEBUGFS_FILE(count)
+DEFINE_DEBUGFS_FILE(enable)
+DEFINE_DEBUGFS_FILE(max)
+DEFINE_DEBUGFS_FILE(sample)
+DEFINE_DEBUGFS_FILE(threshold)
+DEFINE_DEBUGFS_FILE(width)
+DEFINE_DEBUGFS_FILE(window)
+
+#undef DEFINE_DEBUGFS_FILE
+
+#undef current
+#define DEFINE_ENTRY(name) {__stringify(name), &name##_fops, NULL},
+
+static struct debugfs_file_table
+{
+	const char	*file_name;
+	const struct file_operations	*fops;
+	struct dentry	*dentry;
+} file_table[] = {
+	DEFINE_ENTRY(available)
+	DEFINE_ENTRY(current)
+	DEFINE_ENTRY(sample)
+	DEFINE_ENTRY(count)
+	DEFINE_ENTRY(max)
+	DEFINE_ENTRY(window)
+	DEFINE_ENTRY(threshold)
+	DEFINE_ENTRY(enable)
+	{NULL, NULL,NULL},
+};
+#undef DEFINE_ENTRY
+
+static int init_debugfs(void)
+{
+	int ret = -ENOMEM;
+	int	i=0;
+
+	debug_dir = debugfs_create_dir(DRVNAME, NULL);
+	if (!debug_dir)
+		goto err_debug_dir;
+
+	while (file_table[i].fops) {
+		file_table[i].dentry =
+			 debugfs_create_file(file_table[i].file_name, 0444,
+						debug_dir, NULL,
+						file_table[i].fops);
+		if (!file_table[i].dentry)
+			break;
+		i++;
+	}
+	if (file_table[i].fops) {
+		i--;
+		while (i>=0 && file_table[i].fops && file_table[i].dentry) {
+			debugfs_remove(file_table[i].dentry);
+			i--;
+		}
+		debugfs_remove(debug_dir);
+	}
+	ret = 0;
+err_debug_dir:
+	return ret;
+}
+
+static void free_debugfs(void)
+{
+	int i=0;
+
+	while (file_table[i].fops && file_table[i].dentry) {
+		debugfs_remove(file_table[i].dentry);
+		i++;
+	}
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
