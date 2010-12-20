Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab0LTNHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:07:05 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:33441 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757448Ab0LTNGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:06:34 -0500
Message-Id: <20101220130629.517553112@linux.vnet.ibm.com>
User-Agent: quilt/0.47-1
Date: Mon, 20 Dec 2010 14:05:42 +0100
From: graalfs@linux.vnet.ibm.com
To: robert.richter@amd.com
Cc: mingo@elte.hu, oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
Subject: [patch 1/4] This patch adds support for hardware based sampling on System z processors (models z10 and up)
References: <20101220130541.446049933@linux.vnet.ibm.com>
Content-Disposition: inline; filename=hwsampler-base.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: graalfs@linux.vnet.ibm.com

The CPU Measurement Facility CPUMF is described in the z/Architecture Principles of Operation.

The patch introduces 
 - a new configuration option OPROFILE_HWSAMPLING_MODE
 - a new kernel module hwsampler that controls all hardware sampling related operations as
  - checking if hardware sampling feature is available
    - ie: on System z models z10 and up, in LPAR mode only, and authorised during LPAR activation
  - allocating memory for the hardware sampling feature
  - starting/stopping hardware sampling
The hwsampler module will also depend on CONFIG_OPROFILE and CONFIG_64BIT.

All functions required to start and stop hardware sampling have to be
invoked by the oprofile kernel module as provided by the other patches of this patch set.

In case hardware based sampling cannot be setup standard timer based sampling is used by OProfile.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
---
 arch/s390/Kconfig                       |   22 
 arch/s390/include/asm/hwsampler.h       |  130 +++
 arch/s390/oprofile/Makefile             |    6 
 drivers/s390/hwsampler/hwsampler-main.c | 1155 ++++++++++++++++++++++++++++++++
 drivers/s390/hwsampler/smpctl.c         |  170 ++++
 5 files changed, 1483 insertions(+)

Index: linux-2.6/arch/s390/include/asm/hwsampler.h
===================================================================
--- /dev/null
+++ linux-2.6/arch/s390/include/asm/hwsampler.h
@@ -0,0 +1,130 @@
+/*
+ * CPUMF HW sampler structures and prototypes
+ *
+ *    Copyright IBM Corp. 2010
+ *    Author(s): Heinz Graalfs <graalfs@de.ibm.com>
+ */
+
+#ifndef HWSAMPLER_H_
+#define HWSAMPLER_H_
+
+#include <linux/workqueue.h>
+
+struct qsi_info_block          /* QUERY SAMPLING information block  */
+{ /* Bit(s) */
+	unsigned int b0_13:14;      /* 0-13: zeros                       */
+	unsigned int as:1;          /* 14: sampling authorisation control*/
+	unsigned int b15_21:7;      /* 15-21: zeros                      */
+	unsigned int es:1;          /* 22: sampling enable control       */
+	unsigned int b23_29:7;      /* 23-29: zeros                      */
+	unsigned int cs:1;          /* 30: sampling activation control   */
+	unsigned int:1;             /* 31: reserved                      */
+	unsigned int bsdes:16;      /* 4-5: size of sampling entry       */
+	unsigned int:16;            /* 6-7: reserved                     */
+	unsigned long min_sampl_rate; /* 8-15: minimum sampling interval */
+	unsigned long max_sampl_rate; /* 16-23: maximum sampling interval*/
+	unsigned long tear;         /* 24-31: TEAR contents              */
+	unsigned long dear;         /* 32-39: DEAR contents              */
+	unsigned int rsvrd0;        /* 40-43: reserved                   */
+	unsigned int cpu_speed;     /* 44-47: CPU speed                  */
+	unsigned long long rsvrd1;  /* 48-55: reserved                   */
+	unsigned long long rsvrd2;  /* 56-63: reserved                   */
+};
+
+struct ssctl_request_block     /* SET SAMPLING CONTROLS req block   */
+{ /* bytes 0 - 7  Bit(s) */
+	unsigned int s:1;           /* 0: maximum buffer indicator       */
+	unsigned int h:1;           /* 1: part. level reserved for VM use*/
+	unsigned long b2_53:52;     /* 2-53: zeros                       */
+	unsigned int es:1;          /* 54: sampling enable control       */
+	unsigned int b55_61:7;      /* 55-61: - zeros                    */
+	unsigned int cs:1;          /* 62: sampling activation control   */
+	unsigned int b63:1;         /* 63: zero                          */
+	unsigned long interval;     /* 8-15: sampling interval           */
+	unsigned long tear;         /* 16-23: TEAR contents              */
+	unsigned long dear;         /* 24-31: DEAR contents              */
+	/* 32-63:                                                        */
+	unsigned long rsvrd1;       /* reserved                          */
+	unsigned long rsvrd2;       /* reserved                          */
+	unsigned long rsvrd3;       /* reserved                          */
+	unsigned long rsvrd4;       /* reserved                          */
+};
+
+typedef void oprf_add_sample_func(unsigned long pc,
+	struct pt_regs * const regs,
+	unsigned long event, int is_kernel,
+	struct task_struct *task);
+
+struct cpu_buffer {
+	unsigned long first_sdbt;       /* @ of 1st SDB-Table for this CP*/
+	unsigned long worker_entry;
+	unsigned long sample_overflow;  /* taken from SDB ...            */
+	struct qsi_info_block qsi;
+	struct ssctl_request_block ssctl;
+	struct work_struct worker;
+	oprf_add_sample_func *add_sample_f;
+	atomic_t ext_params;
+	unsigned long req_alert;
+	unsigned long loss_of_sample_data;
+	unsigned long invalid_entry_address;
+	unsigned long incorrect_sdbt_entry;
+	unsigned long sample_auth_change_alert;
+	unsigned int finish:1;
+	unsigned int oom:1;
+	unsigned int stop_mode:1;
+};
+
+struct data_entry {
+	unsigned int def:16;        /* 0-15  Data Entry Format           */
+	unsigned int R:4;           /* 16-19 reserved                    */
+	unsigned int U:4;           /* 20-23 Number of unique instruct.  */
+	unsigned int z:2;           /* zeros                             */
+	unsigned int T:1;           /* 26 PSW DAT mode                   */
+	unsigned int W:1;           /* 27 PSW wait state                 */
+	unsigned int P:1;           /* 28 PSW Problem state              */
+	unsigned int AS:2;          /* 29-30 PSW address-space control   */
+	unsigned int I:1;           /* 31 entry valid or invalid         */
+	unsigned int:16;
+	unsigned int prim_asn:16;   /* primary ASN                       */
+	unsigned long long ia;      /* Instruction Address               */
+	unsigned long long lpp;     /* Logical-Partition Program Param.  */
+	unsigned long long vpp;     /* Virtual-Machine Program Param.    */
+};
+
+struct trailer_entry {
+	unsigned int f:1;           /* 0 - Block Full Indicator          */
+	unsigned int a:1;           /* 1 - Alert request control         */
+	unsigned long:62;           /* 2 - 63: Reserved                  */
+	unsigned long overflow;     /* 64 - sample Overflow count        */
+	unsigned long timestamp;    /* 16 - time-stamp                   */
+	unsigned long timestamp1;   /*                                   */
+	unsigned long reserved1;    /* 32 -Reserved                      */
+	unsigned long reserved2;    /*                                   */
+	unsigned long progusage1;   /* 48 - reserved for programming use */
+	unsigned long progusage2;   /*                                   */
+};
+
+int hwsampler_setup(void);
+int hwsampler_shutdown(void);
+int hwsampler_allocate(unsigned long sdbt, unsigned long sdb);
+int hwsampler_deallocate(void);
+long hwsampler_query_min_interval(void);
+long hwsampler_query_max_interval(void);
+int hwsampler_start_all(unsigned long interval);
+int hwsampler_stop_all(void);
+int hwsampler_deactivate(unsigned int cpu);
+int hwsampler_activate(unsigned int cpu);
+unsigned long hwsampler_get_sample_overflow_count(unsigned int cpu);
+
+int smp_ctl_qsi(int);
+int smp_ctl_ssctl_deactivate(int);
+int smp_ctl_ssctl_stop(int);
+int smp_ctl_ssctl_enable_activate(int, unsigned long);
+
+int qsi(void *);
+
+void execute_qsi(void *);
+void execute_ssctl(void *);
+
+#endif /*HWSAMPLER_H_*/
+
Index: linux-2.6/drivers/s390/hwsampler/hwsampler-main.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/s390/hwsampler/hwsampler-main.c
@@ -0,0 +1,1155 @@
+/**
+ * drivers/s390/hwsampler/hwsampler-main.c
+ *
+ * Copyright IBM Corp. 2010
+ * Author: Heinz Graalfs <graalfs@de.ibm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/smp.h>
+#include <linux/errno.h>
+#include <linux/workqueue.h>
+#include <linux/interrupt.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/semaphore.h>
+#include <linux/oom.h>
+
+#include <asm/lowcore.h>
+#include <asm/s390_ext.h>
+
+#include "asm/hwsampler.h"
+
+#define MAX_NUM_SDB 511
+#define MIN_NUM_SDB 1
+
+#define ALERT_REQ_MASK   0x4000000000000000ul
+#define BUFFER_FULL_MASK 0x8000000000000000ul
+
+#define EI_IEA      (1 << 31)	/* invalid entry address              */
+#define EI_ISE      (1 << 30)	/* incorrect SDBT entry               */
+#define EI_PRA      (1 << 29)	/* program request alert              */
+#define EI_SACA     (1 << 23)	/* sampler authorization change alert */
+#define EI_LSDA     (1 << 22)	/* loss of sample data alert          */
+
+static inline unsigned long *trailer_entry_ptr(unsigned long v)
+{
+	void *ret;
+
+	ret = (void *)v;
+	ret += PAGE_SIZE;
+	ret -= sizeof(struct trailer_entry);
+
+	return (unsigned long *) ret;
+}
+
+DEFINE_PER_CPU(struct cpu_buffer, hws_cpu_buffer);
+EXPORT_PER_CPU_SYMBOL(hws_cpu_buffer);
+
+static struct workqueue_struct *hws_wq;
+
+static DEFINE_MUTEX(hws_sem);
+static DEFINE_MUTEX(hws_sem_oom);
+
+static unsigned char hws_flush_all;
+
+static unsigned int hws_oom;
+
+static unsigned int hws_state;
+enum {
+	HWS_INIT = 1,
+	HWS_DEALLOCATED,
+	HWS_STOPPED,
+	HWS_STARTED,
+	HWS_STOPPING };
+
+/* set to 1 if called by kernel during memory allocation */
+static unsigned char oom_killer_was_active;
+/* size of SDBT and SDB as of allocate API */
+static unsigned long num_sdbt = 100;
+static unsigned long num_sdb = 511;
+/* sampling interval (machine cycles) */
+static unsigned long interval;
+
+static unsigned long min_sampler_rate;
+static unsigned long max_sampler_rate;
+
+/* prototypes for external interrupt handler and worker */
+static void hws_ext_handler(unsigned int ext_int_code,
+			    unsigned int param32, unsigned long param64);
+
+static void worker(struct work_struct *work);
+
+static void add_samples_to_oprofile(unsigned cpu, unsigned long *,
+				    oprf_add_sample_func *,
+				    unsigned long *dear);
+
+static void init_all_cpu_buffers(void)
+{
+	int cpu;
+	struct cpu_buffer *cb;
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(hws_cpu_buffer, cpu);
+		memset(cb, 0, sizeof(struct cpu_buffer));
+	}
+}
+
+static int is_link_entry(unsigned long *s)
+{
+	return *s & 0x1ul ? 1 : 0;
+}
+
+static unsigned long *get_next_sdbt(unsigned long *s)
+{
+	return (unsigned long *) (*s & ~0x1ul);
+}
+
+static int prepare_cpu_buffers(void)
+{
+	int cpu;
+	int rc;
+	struct cpu_buffer *cb;
+
+	rc = 0;
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(hws_cpu_buffer, cpu);
+		atomic_set(&cb->ext_params, 0);
+		cb->worker_entry = 0;
+		cb->sample_overflow = 0;
+		cb->req_alert = 0;
+		cb->incorrect_sdbt_entry = 0;
+		cb->invalid_entry_address = 0;
+		cb->loss_of_sample_data = 0;
+		cb->sample_auth_change_alert = 0;
+		cb->finish = 0;
+		cb->oom = 0;
+		cb->stop_mode = 0;
+		cb->add_sample_f =
+				__symbol_get("oprofile_add_ext_hw_sample");
+		if (!cb->add_sample_f) {
+			printk(KERN_ERR
+					"hwsampler: failed to get oprofile_add_ext_hw_sample"
+					" function symbol");
+			rc = -EINVAL;
+		}
+	}
+
+	return rc;
+}
+
+/*
+ * allocate_sdbt() - allocate sampler memory
+ * @cpu: the cpu for which sampler memory is allocated
+ *
+ * A 4K page is allocated for each requested SDBT.
+ * A maximum of 511 4K pages are allocated for the SDBs in each of the SDBTs.
+ * Set ALERT_REQ mask in each SDBs trailer.
+ * Returns zero if successful, <0 otherwise.
+ */
+static int allocate_sdbt(int cpu)
+{
+	int j, k, rc;
+	unsigned long *sdbt;
+	unsigned long  sdb;
+	unsigned long *tail;
+	unsigned long *trailer;
+	struct cpu_buffer *cb;
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+
+	if (cb->first_sdbt)
+		return -EINVAL;
+
+	sdbt = NULL;
+	tail = sdbt;
+
+	for (j = 0; j < num_sdbt; j++) {
+		sdbt = (unsigned long *)get_zeroed_page(GFP_KERNEL);
+
+		mutex_lock(&hws_sem_oom);
+		/* OOM killer might have been activated */
+		barrier();
+		if (oom_killer_was_active || !sdbt) {
+			if (sdbt)
+				free_page((unsigned long)sdbt);
+
+			goto allocate_sdbt_error;
+		}
+		if (cb->first_sdbt == 0)
+			cb->first_sdbt = (unsigned long)sdbt;
+
+		/* link current page to tail of chain */
+		if (tail)
+			*tail = (unsigned long)(void *)sdbt + 1;
+
+		mutex_unlock(&hws_sem_oom);
+
+		for (k = 0; k < num_sdb; k++) {
+			/* get and set SDB page */
+			sdb = get_zeroed_page(GFP_KERNEL);
+
+			mutex_lock(&hws_sem_oom);
+			/* OOM killer might have been activated */
+			barrier();
+			if (oom_killer_was_active || !sdb) {
+				if (sdb)
+					free_page(sdb);
+
+				goto allocate_sdbt_error;
+			}
+			*sdbt = sdb;
+			trailer = trailer_entry_ptr(*sdbt);
+			*trailer = ALERT_REQ_MASK;
+			sdbt++;
+			mutex_unlock(&hws_sem_oom);
+		}
+		tail = sdbt;
+	}
+	mutex_lock(&hws_sem_oom);
+	if (oom_killer_was_active)
+		goto allocate_sdbt_error;
+
+	rc = 0;
+	if (tail)
+		*tail = (unsigned long)
+			((void *)cb->first_sdbt) + 1;
+
+allocate_sdbt_exit:
+	mutex_unlock(&hws_sem_oom);
+	return rc;
+
+allocate_sdbt_error:
+	rc = -ENOMEM;
+	goto allocate_sdbt_exit;
+}
+
+/*
+ * deallocate_sdbt() - deallocate all sampler memory
+ *
+ * For each online CPU all SDBT trees are deallocated.
+ * Returns the number of freed pages.
+ */
+static int deallocate_sdbt(void)
+{
+	int cpu;
+	int counter;
+
+	counter = 0;
+
+	for_each_online_cpu(cpu) {
+		unsigned long start;
+		unsigned long sdbt;
+		unsigned long *curr;
+		struct cpu_buffer *cb;
+
+		cb = &per_cpu(hws_cpu_buffer, cpu);
+
+		if (!cb->first_sdbt)
+			continue;
+
+		sdbt = cb->first_sdbt;
+		curr = (unsigned long *) sdbt;
+		start = sdbt;
+
+		/* we'll free the SDBT after all SDBs are processed... */
+		while (1) {
+			if (!*curr || !sdbt)
+				break;
+
+			/* watch for link entry reset if found */
+			if (is_link_entry(curr)) {
+				curr = get_next_sdbt(curr);
+				if (sdbt)
+					free_page(sdbt);
+
+				/* we are done if we reach the start */
+				if ((unsigned long) curr == start)
+					break;
+				else
+					sdbt = (unsigned long) curr;
+			} else {
+				/* process SDB pointer */
+				if (*curr) {
+					free_page(*curr);
+					curr++;
+				}
+			}
+			counter++;
+		}
+		cb->first_sdbt = 0;
+	}
+	return counter;
+}
+
+static int start_sampling(int cpu)
+{
+	int rc;
+	struct cpu_buffer *cb;
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+	rc = smp_ctl_ssctl_enable_activate(cpu, interval);
+	if (rc) {
+		printk(KERN_INFO "hwsampler: CPU %d ssctl failed.\n", cpu);
+		goto start_exit;
+	}
+
+	rc = -EINVAL;
+	if (!cb->qsi.es) {
+		printk(KERN_INFO "hwsampler: CPU %d ssctl not enabled.\n", cpu);
+		goto start_exit;
+	}
+
+	if (!cb->qsi.cs) {
+		printk(KERN_INFO "hwsampler: CPU %d ssctl not active.\n", cpu);
+		goto start_exit;
+	}
+
+	printk(KERN_INFO
+		"hwsampler: CPU %d, CPUMF Sampling started, interval %lu.\n",
+		cpu, interval);
+
+	rc = 0;
+
+start_exit:
+	return rc;
+}
+
+static int stop_sampling(int cpu)
+{
+	unsigned long v;
+	int rc;
+	struct cpu_buffer *cb;
+
+	rc = smp_ctl_qsi(cpu);
+	WARN_ON(rc);
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+	if (!rc && !cb->qsi.es)
+		printk(KERN_INFO "hwsampler: CPU %d, already stopped.\n", cpu);
+
+	rc = smp_ctl_ssctl_stop(cpu);
+	if (rc) {
+		printk(KERN_INFO "hwsampler: CPU %d, ssctl stop error %d.\n",
+				cpu, rc);
+		goto stop_exit;
+	}
+
+	printk(KERN_INFO "hwsampler: CPU %d, CPUMF Sampling stopped.\n", cpu);
+
+stop_exit:
+	v = cb->req_alert;
+	if (v)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF Request alert,"
+				" count=%lu.\n", cpu, v);
+
+	v = cb->loss_of_sample_data;
+	if (v)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF Loss of sample data,"
+				" count=%lu.\n", cpu, v);
+
+	v = cb->invalid_entry_address;
+	if (v)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF Invalid entry address,"
+				" count=%lu.\n", cpu, v);
+
+	v = cb->incorrect_sdbt_entry;
+	if (v)
+		printk(KERN_ERR
+				"hwsampler: CPU %d CPUMF Incorrect SDBT address,"
+				" count=%lu.\n", cpu, v);
+
+	v = cb->sample_auth_change_alert;
+	if (v)
+		printk(KERN_ERR
+				"hwsampler: CPU %d CPUMF Sample authorization change,"
+				" count=%lu.\n", cpu, v);
+
+	return rc;
+}
+
+static int check_hardware_prerequisites(void)
+{
+	unsigned long long facility_bits[2];
+
+	memcpy(facility_bits, S390_lowcore.stfle_fac_list, 32);
+	if (!(facility_bits[1] & (1ULL << 59)))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+/*
+ * hws_oom_callback() - the OOM callback function
+ *
+ * In case the callback is invoked during memory allocation for the
+ *  hw sampler, all obtained memory is deallocated and a flag is set
+ *  so main sampler memory allocation can exit with a failure code.
+ * In case the callback is invoked during sampling the hw sampler
+ *  is deactivated for all CPUs.
+ */
+static int hws_oom_callback(struct notifier_block *nfb,
+	unsigned long dummy, void *parm)
+{
+	unsigned long *freed;
+	int cpu;
+	struct cpu_buffer *cb;
+
+	freed = parm;
+
+	mutex_lock(&hws_sem_oom);
+
+	if (hws_state == HWS_DEALLOCATED) {
+		/* during memory allocation */
+		if (oom_killer_was_active == 0) {
+			oom_killer_was_active = 1;
+			*freed += deallocate_sdbt();
+		}
+	} else {
+		int i;
+		cpu = get_cpu();
+		cb = &per_cpu(hws_cpu_buffer, cpu);
+
+		if (!cb->oom) {
+			for_each_online_cpu(i) {
+				smp_ctl_ssctl_deactivate(i);
+				cb->oom = 1;
+			}
+			cb->finish = 1;
+
+			printk(KERN_INFO
+				"hwsampler: CPU %d, OOM notify during CPUMF Sampling.\n",
+				cpu);
+		}
+	}
+
+	mutex_unlock(&hws_sem_oom);
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block hws_oom_notifier = {
+	.notifier_call = hws_oom_callback
+};
+
+static int __cpuinit hws_cpu_callback(struct notifier_block *nfb,
+	unsigned long action, void *hcpu)
+{
+	/* We do not have sampler space available for all possible CPUs.
+	   All CPUs should be online when hw sampling is activated. */
+	return NOTIFY_BAD;
+}
+
+static struct notifier_block hws_cpu_notifier = {
+	.notifier_call = hws_cpu_callback
+};
+
+/**
+ * hwsampler_deactivate() - set hardware sampling temporarily inactive
+ * @cpu:  specifies the CPU to be set inactive.
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_deactivate(unsigned int cpu)
+{
+	/*
+	 * Deactivate hw sampling temporarily and flush the buffer
+	 * by pushing all the pending samples to oprofile buffer.
+	 *
+	 * This function can be called under one of the following conditions:
+	 *     Memory unmap, task is exiting.
+	 */
+	int rc;
+	struct cpu_buffer *cb;
+
+	rc = 0;
+	mutex_lock(&hws_sem);
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+	if (hws_state == HWS_STARTED) {
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+		if (cb->qsi.cs) {
+			rc = smp_ctl_ssctl_deactivate(cpu);
+			if (rc) {
+				printk(KERN_INFO
+				"hwsampler: CPU %d, CPUMF Deactivation failed.\n", cpu);
+				cb->finish = 1;
+				hws_state = HWS_STOPPING;
+			} else  {
+				hws_flush_all = 1;
+				/* Add work to queue to read pending samples.*/
+				queue_work_on(cpu, hws_wq, &cb->worker);
+			}
+		}
+	}
+	mutex_unlock(&hws_sem);
+
+	if (hws_wq)
+		flush_workqueue(hws_wq);
+
+	return rc;
+}
+EXPORT_SYMBOL(hwsampler_deactivate);
+
+/**
+ * hwsampler_activate() - activate/resume hardware sampling which was deactivated
+ * @cpu:  specifies the CPU to be set active.
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_activate(unsigned int cpu)
+{
+	/*
+	 * Re-activate hw sampling. This should be called in pair with
+	 * hwsampler_deactivate().
+	 */
+	int rc;
+	struct cpu_buffer *cb;
+
+	rc = 0;
+	mutex_lock(&hws_sem);
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+	if (hws_state == HWS_STARTED) {
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+		if (!cb->qsi.cs) {
+			hws_flush_all = 0;
+			rc = smp_ctl_ssctl_enable_activate(cpu, interval);
+			if (rc) {
+				printk(KERN_ERR
+				"CPU %d, CPUMF activate sampling failed.\n",
+					 cpu);
+			}
+		}
+	}
+
+	mutex_unlock(&hws_sem);
+
+	return rc;
+}
+EXPORT_SYMBOL(hwsampler_activate);
+
+static void hws_ext_handler(unsigned int ext_int_code,
+			    unsigned int param32, unsigned long param64)
+{
+	int cpu;
+	struct cpu_buffer *cb;
+
+	cpu = smp_processor_id();
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+
+	atomic_xchg(
+			&cb->ext_params,
+			atomic_read(&cb->ext_params)
+				| S390_lowcore.ext_params);
+
+	if (hws_wq)
+		queue_work(hws_wq, &cb->worker);
+}
+
+static int check_qsi_on_setup(void)
+{
+	int rc;
+	unsigned int cpu;
+	struct cpu_buffer *cb;
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(hws_cpu_buffer, cpu);
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+		if (rc)
+			return -EOPNOTSUPP;
+
+		if (!cb->qsi.as) {
+			printk(KERN_INFO "hwsampler: CPUMF sampling is not authorized.\n");
+			return -EINVAL;
+		}
+
+		if (cb->qsi.es) {
+			printk(KERN_WARNING "hwsampler: CPUMF is still enabled.\n");
+			rc = smp_ctl_ssctl_stop(cpu);
+			if (rc)
+				return -EINVAL;
+
+			printk(KERN_INFO
+				"CPU %d, CPUMF Sampling stopped now.\n", cpu);
+		}
+	}
+	return 0;
+}
+
+static int check_qsi_on_start(void)
+{
+	unsigned int cpu;
+	int rc;
+	struct cpu_buffer *cb;
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(hws_cpu_buffer, cpu);
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+
+		if (!cb->qsi.as)
+			return -EINVAL;
+
+		if (cb->qsi.es)
+			return -EINVAL;
+
+		if (cb->qsi.cs)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static void worker_on_start(unsigned int cpu)
+{
+	struct cpu_buffer *cb;
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+	cb->worker_entry = cb->first_sdbt;
+}
+
+static int worker_check_error(unsigned int cpu, int ext_params)
+{
+	int rc;
+	unsigned long *sdbt;
+	struct cpu_buffer *cb;
+
+	rc = 0;
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+	sdbt = (unsigned long *) cb->worker_entry;
+
+	if (!sdbt || !*sdbt)
+		return -EINVAL;
+
+	if (ext_params & EI_IEA)
+		cb->req_alert++;
+
+	if (ext_params & EI_LSDA)
+		cb->loss_of_sample_data++;
+
+	if (ext_params & EI_IEA) {
+		cb->invalid_entry_address++;
+		rc = -EINVAL;
+	}
+
+	if (ext_params & EI_ISE) {
+		cb->incorrect_sdbt_entry++;
+		rc = -EINVAL;
+	}
+
+	if (ext_params & EI_SACA) {
+		cb->sample_auth_change_alert++;
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+static void worker_on_finish(unsigned int cpu)
+{
+	int rc, i;
+	struct cpu_buffer *cb;
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+
+	if (cb->finish) {
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+		if (cb->qsi.es) {
+			printk(KERN_INFO
+				"hwsampler: CPU %d, CPUMF Stop/Deactivate sampling.\n",
+				cpu);
+			rc = smp_ctl_ssctl_stop(cpu);
+			if (rc)
+				printk(KERN_INFO
+					"hwsampler: CPU %d, CPUMF Deactivation failed.\n",
+					cpu);
+
+			for_each_online_cpu(i) {
+				if (i == cpu)
+					continue;
+				if (!cb->finish) {
+					cb->finish = 1;
+					queue_work_on(i, hws_wq,
+						&cb->worker);
+				}
+			}
+		}
+	}
+}
+
+static void worker_on_interrupt(unsigned int cpu)
+{
+	unsigned long *sdbt;
+	unsigned char done;
+	struct cpu_buffer *cb;
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+
+	sdbt = (unsigned long *) cb->worker_entry;
+
+	done = 0;
+	/* do not proceed if stop was entered,
+	 * forget the buffers not yet processed */
+	while (!done && !cb->stop_mode) {
+		unsigned long *trailer;
+		struct trailer_entry *te;
+		unsigned long *dear = 0;
+
+		trailer = trailer_entry_ptr(*sdbt);
+		/* leave loop if no more work to do */
+		if (!(*trailer & BUFFER_FULL_MASK)) {
+			done = 1;
+			if (!hws_flush_all)
+				continue;
+		}
+
+		te = (struct trailer_entry *)trailer;
+		cb->sample_overflow += te->overflow;
+
+		add_samples_to_oprofile(cpu, sdbt,
+			cb->add_sample_f, dear);
+
+		/* reset trailer */
+		xchg((unsigned char *) te, 0x40);
+
+		/* advance to next sdb slot in current sdbt */
+		sdbt++;
+		/* in case link bit is set use address w/o link bit */
+		if (is_link_entry(sdbt))
+			sdbt = get_next_sdbt(sdbt);
+
+		cb->worker_entry = (unsigned long)sdbt;
+	}
+}
+
+static void add_samples_to_oprofile(unsigned int cpu, unsigned long *sdbt,
+		oprf_add_sample_func *add_sample_f,
+		unsigned long *dear)
+{
+	struct data_entry *sample_data_ptr;
+	unsigned long *trailer;
+
+	trailer = trailer_entry_ptr(*sdbt);
+	if (dear) {
+		if (dear > trailer)
+			return;
+		trailer = dear;
+	}
+
+	sample_data_ptr = (struct data_entry *)(*sdbt);
+
+	while ((unsigned long *)sample_data_ptr < trailer) {
+		struct pt_regs *regs = NULL;
+		struct task_struct *tsk = NULL;
+
+		/*
+		 * Check sampling mode, 1 indicates basic (=customer) sampling
+		 * mode.
+		 */
+		if (sample_data_ptr->def != 1) {
+			/* sample slot is not yet written */
+			break;
+		} else {
+			/* make sure we don't use it twice,
+			 * the next time the sampler will set it again */
+			sample_data_ptr->def = 0;
+		}
+
+		/* Get pt_regs. */
+		if (sample_data_ptr->P == 1) {
+			/* userspace sample */
+			unsigned int pid = sample_data_ptr->prim_asn;
+			rcu_read_lock();
+			tsk = pid_task(find_vpid(pid), PIDTYPE_PID);
+			if (tsk)
+				regs = task_pt_regs(tsk);
+			rcu_read_unlock();
+		} else {
+			/* kernelspace sample */
+			regs = task_pt_regs(current);
+		}
+
+		mutex_lock(&hws_sem);
+		(*add_sample_f)(sample_data_ptr->ia, regs, 0,
+				!sample_data_ptr->P, tsk);
+		mutex_unlock(&hws_sem);
+
+		sample_data_ptr++;
+	}
+}
+
+static void worker(struct work_struct *work)
+{
+	unsigned int cpu;
+	int ext_params;
+	struct cpu_buffer *cb;
+
+	cb = container_of(work, struct cpu_buffer, worker);
+	cpu = smp_processor_id();
+	ext_params = atomic_xchg(&cb->ext_params, 0);
+
+	if (!cb->worker_entry)
+		worker_on_start(cpu);
+
+	if (worker_check_error(cpu, ext_params))
+		return;
+
+	if (!cb->finish)
+		worker_on_interrupt(cpu);
+
+	if (cb->finish)
+		worker_on_finish(cpu);
+}
+
+/**
+ * hwsampler_allocate() - allocate memory for the hardware sampler
+ * @sdbt:  number of SDBTs per online CPU (must be > 0)
+ * @sdb:   number of SDBs per SDBT (minimum 1, maximum 511)
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_allocate(unsigned long sdbt, unsigned long sdb)
+{
+	int cpu, rc;
+	mutex_lock(&hws_sem);
+
+	rc = -EINVAL;
+	if (hws_state != HWS_DEALLOCATED)
+		goto allocate_exit;
+
+	if (sdbt < 1)
+		goto allocate_exit;
+
+	if (sdb > MAX_NUM_SDB || sdb < MIN_NUM_SDB)
+		goto allocate_exit;
+
+	num_sdbt = sdbt;
+	num_sdb = sdb;
+
+	oom_killer_was_active = 0;
+	register_oom_notifier(&hws_oom_notifier);
+
+	for_each_online_cpu(cpu) {
+		if (allocate_sdbt(cpu)) {
+			unregister_oom_notifier(&hws_oom_notifier);
+			goto allocate_error;
+		}
+	}
+	unregister_oom_notifier(&hws_oom_notifier);
+	if (oom_killer_was_active)
+		goto allocate_error;
+
+	hws_state = HWS_STOPPED;
+	rc = 0;
+
+allocate_exit:
+	mutex_unlock(&hws_sem);
+	return rc;
+
+allocate_error:
+	rc = -ENOMEM;
+	printk(KERN_ERR "hwsampler: CPUMF Memory allocation failed.\n");
+	goto allocate_exit;
+}
+EXPORT_SYMBOL(hwsampler_allocate);
+
+/**
+ * hwsampler_deallocate() - deallocate hardware sampler memory
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_deallocate()
+{
+	int rc;
+
+	mutex_lock(&hws_sem);
+
+	rc = -EINVAL;
+	if (hws_state != HWS_STOPPED)
+		goto deallocate_exit;
+
+	smp_ctl_clear_bit(0, 5); /* set bit 58 CR0 off */
+	deallocate_sdbt();
+
+	hws_state = HWS_DEALLOCATED;
+	rc = 0;
+
+deallocate_exit:
+	mutex_unlock(&hws_sem);
+
+	return rc;
+}
+EXPORT_SYMBOL(hwsampler_deallocate);
+
+long hwsampler_query_min_interval(void)
+{
+	if (min_sampler_rate)
+		return min_sampler_rate;
+	else
+		return -EINVAL;
+}
+EXPORT_SYMBOL(hwsampler_query_min_interval);
+
+long hwsampler_query_max_interval(void)
+{
+	if (max_sampler_rate)
+		return max_sampler_rate;
+	else
+		return -EINVAL;
+}
+EXPORT_SYMBOL(hwsampler_query_max_interval);
+
+unsigned long hwsampler_get_sample_overflow_count(unsigned int cpu)
+{
+	struct cpu_buffer *cb;
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+
+	return cb->sample_overflow;
+}
+EXPORT_SYMBOL(hwsampler_get_sample_overflow_count);
+
+int hwsampler_setup()
+{
+	int rc;
+	int cpu;
+	struct cpu_buffer *cb;
+
+	mutex_lock(&hws_sem);
+
+	rc = -EINVAL;
+	if (hws_state != HWS_INIT)
+		goto setup_exit;
+
+	init_all_cpu_buffers();
+
+	rc = check_hardware_prerequisites();
+	if (rc)
+		goto setup_exit;
+
+	rc = check_qsi_on_setup();
+	if (rc)
+		goto setup_exit;
+
+	rc = -EINVAL;
+	hws_wq = create_workqueue("hwsampler");
+	if (!hws_wq)
+		goto setup_exit;
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(hws_cpu_buffer, cpu);
+		INIT_WORK(&cb->worker, worker);
+		rc = smp_ctl_qsi(cpu);
+		WARN_ON(rc);
+		if (min_sampler_rate != cb->qsi.min_sampl_rate) {
+			if (min_sampler_rate) {
+				printk(KERN_WARNING
+					"hwsampler: different min sampler rate values.\n");
+				if (min_sampler_rate < cb->qsi.min_sampl_rate)
+					min_sampler_rate =
+						cb->qsi.min_sampl_rate;
+			} else
+				min_sampler_rate = cb->qsi.min_sampl_rate;
+		}
+		if (max_sampler_rate != cb->qsi.max_sampl_rate) {
+			if (max_sampler_rate) {
+				printk(KERN_WARNING
+					"hwsampler: different max sampler rate values.\n");
+				if (max_sampler_rate > cb->qsi.max_sampl_rate)
+					max_sampler_rate =
+						cb->qsi.max_sampl_rate;
+			} else
+				max_sampler_rate = cb->qsi.max_sampl_rate;
+		}
+	}
+	register_external_interrupt(0x1407, hws_ext_handler);
+
+	if (!try_module_get(THIS_MODULE))
+		goto setup_error;
+
+	hws_state = HWS_DEALLOCATED;
+	rc = 0;
+
+setup_exit:
+	mutex_unlock(&hws_sem);
+	return rc;
+
+setup_error:
+	destroy_workqueue(hws_wq);
+	hws_wq = NULL;
+	goto setup_exit;
+}
+EXPORT_SYMBOL(hwsampler_setup);
+
+int hwsampler_shutdown()
+{
+	int rc;
+
+	mutex_lock(&hws_sem);
+
+	rc = -EINVAL;
+	if (hws_state == HWS_DEALLOCATED || hws_state == HWS_STOPPED) {
+		mutex_unlock(&hws_sem);
+
+		if (hws_wq)
+			flush_workqueue(hws_wq);
+
+		mutex_lock(&hws_sem);
+
+		if (hws_state == HWS_STOPPED) {
+			smp_ctl_clear_bit(0, 5); /* set bit 58 CR0 off */
+			deallocate_sdbt();
+		}
+		if (hws_wq) {
+			destroy_workqueue(hws_wq);
+			hws_wq = NULL;
+		}
+
+		unregister_external_interrupt(0x1407, hws_ext_handler);
+		module_put(THIS_MODULE);
+		hws_state = HWS_INIT;
+		rc = 0;
+	}
+	mutex_unlock(&hws_sem);
+
+	return rc;
+}
+EXPORT_SYMBOL(hwsampler_shutdown);
+
+/**
+ * hwsampler_start_all() - start hardware sampling on all online CPUs
+ * @rate:  specifies the used interval when samples are taken
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_start_all(unsigned long rate)
+{
+	int rc, cpu;
+
+	mutex_lock(&hws_sem);
+
+	hws_oom = 0;
+
+	rc = -EINVAL;
+	if (hws_state != HWS_STOPPED)
+		goto start_all_exit;
+
+	interval = rate;
+
+	/* fail if rate is not valid */
+	if (interval < min_sampler_rate || interval > max_sampler_rate)
+		goto start_all_exit;
+
+	rc = check_qsi_on_start();
+	if (rc)
+		goto start_all_exit;
+
+	rc = prepare_cpu_buffers();
+	if (rc)
+		goto start_all_exit;
+
+	for_each_online_cpu(cpu) {
+		rc = start_sampling(cpu);
+		if (rc)
+			break;
+	}
+	if (rc) {
+		for_each_online_cpu(cpu) {
+			stop_sampling(cpu);
+		}
+		goto start_all_exit;
+	}
+	hws_state = HWS_STARTED;
+	rc = 0;
+
+start_all_exit:
+	mutex_unlock(&hws_sem);
+
+	if (rc)
+		return rc;
+
+	register_oom_notifier(&hws_oom_notifier);
+	hws_oom = 1;
+	hws_flush_all = 0;
+	/* now let them in, 1407 CPUMF external interrupts */
+	smp_ctl_set_bit(0, 5); /* set CR0 bit 58 */
+
+	return 0;
+}
+EXPORT_SYMBOL(hwsampler_start_all);
+
+/**
+ * hwsampler_stop_all() - stop hardware sampling on all online CPUs
+ *
+ * Returns 0 on success, !0 on failure.
+ */
+int hwsampler_stop_all()
+{
+	int tmp_rc, rc, cpu;
+	struct cpu_buffer *cb;
+
+	mutex_lock(&hws_sem);
+
+	rc = 0;
+	if (hws_state == HWS_INIT) {
+		mutex_unlock(&hws_sem);
+		return rc;
+	}
+	hws_state = HWS_STOPPING;
+	mutex_unlock(&hws_sem);
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(hws_cpu_buffer, cpu);
+		cb->stop_mode = 1;
+		tmp_rc = stop_sampling(cpu);
+		if (tmp_rc)
+			rc = tmp_rc;
+	}
+
+	if (hws_wq)
+		flush_workqueue(hws_wq);
+
+	for_each_online_cpu(cpu) {
+		cb = &per_cpu(hws_cpu_buffer, cpu);
+		mutex_lock(&hws_sem);
+		if (cb->add_sample_f) {
+			symbol_put_addr(cb->add_sample_f);
+			cb->add_sample_f = NULL;
+		}
+		mutex_unlock(&hws_sem);
+	}
+
+	mutex_lock(&hws_sem);
+	if (hws_oom) {
+		unregister_oom_notifier(&hws_oom_notifier);
+		hws_oom = 0;
+	}
+	hws_state = HWS_STOPPED;
+	mutex_unlock(&hws_sem);
+
+	return rc;
+}
+EXPORT_SYMBOL(hwsampler_stop_all);
+
+static int __init hwsampler_init(void)
+{
+	hws_state = HWS_INIT;
+	register_cpu_notifier(&hws_cpu_notifier);
+	return 0;
+}
+
+static void __exit hwsampler_exit(void)
+{
+	unregister_cpu_notifier(&hws_cpu_notifier);
+}
+
+module_init(hwsampler_init);
+module_exit(hwsampler_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Heinz Graalfs <graalfs@de.ibm.com>");
+MODULE_DESCRIPTION("IBM CPUMF Customer Mode Sampling Kernel Module");
Index: linux-2.6/drivers/s390/hwsampler/smpctl.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/s390/hwsampler/smpctl.c
@@ -0,0 +1,170 @@
+/**
+ * drivers/s390/hwsampler/smpctl.c
+ *
+ * Copyright IBM Corp. 2010
+ * Author: Heinz Graalfs <graalfs@de.ibm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/smp.h>
+#include <linux/errno.h>
+
+#include "asm/hwsampler.h"
+
+DECLARE_PER_CPU(struct cpu_buffer, hws_cpu_buffer);
+
+struct hws_execute_parms {
+	void *buffer;
+	signed int rc;
+};
+
+int ssctl(void *buffer)
+{
+	int cc;
+
+	/* set in order to detect a program check */
+	cc = 1;
+
+	asm volatile(
+		"0: .insn s,0xB2870000,0(%1)\n"
+		"1: ipm %0\n"
+		"   srl %0,28\n"
+		"2:\n"
+		EX_TABLE(0b, 2b) EX_TABLE(1b, 2b)
+		: "+d" (cc), "+a" (buffer)
+		: "m" (*((struct ssctl_request_block *)buffer))
+		: "cc", "memory");
+
+	return cc ? -EINVAL : 0 ;
+}
+
+int qsi(void *buffer)
+{
+	int cc;
+	cc = 1;
+
+	asm volatile(
+		"0: .insn s,0xB2860000,0(%1)\n"
+		"1: lhi %0,0\n"
+		"2:\n"
+		EX_TABLE(0b, 2b) EX_TABLE(1b, 2b)
+		: "=d" (cc), "+a" (buffer)
+		: "m" (*((struct qsi_info_block *)buffer))
+		: "cc", "memory");
+
+	return cc ? -EINVAL : 0;
+}
+
+void execute_qsi(void *parms)
+{
+	struct hws_execute_parms *ep = parms;
+
+	ep->rc = qsi(ep->buffer);
+}
+
+void execute_ssctl(void *parms)
+{
+	struct hws_execute_parms *ep = parms;
+
+	ep->rc = ssctl(ep->buffer);
+}
+
+int smp_ctl_ssctl_stop(int cpu)
+{
+	int rc;
+	struct hws_execute_parms ep;
+	struct cpu_buffer *cb;
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+
+	cb->ssctl.es = 0;
+	cb->ssctl.cs = 0;
+
+	ep.buffer = &cb->ssctl;
+	smp_call_function_single(cpu, execute_ssctl, &ep, 1);
+	rc = ep.rc;
+	if (rc) {
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF SSCTL failed.\n", cpu);
+		dump_stack();
+	}
+
+	ep.buffer = &cb->qsi;
+	smp_call_function_single(cpu, execute_qsi, &ep, 1);
+
+	if (cb->qsi.es || cb->qsi.cs) {
+		printk(KERN_EMERG "CPUMF sampling did not stop properly.\n");
+		dump_stack();
+	}
+
+	return rc;
+}
+
+int smp_ctl_ssctl_deactivate(int cpu)
+{
+	int rc;
+	struct hws_execute_parms ep;
+	struct cpu_buffer *cb;
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+
+	cb->ssctl.es = 1;
+	cb->ssctl.cs = 0;
+
+	ep.buffer = &cb->ssctl;
+	smp_call_function_single(cpu, execute_ssctl, &ep, 1);
+	rc = ep.rc;
+	if (rc)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF SSCTL failed.\n", cpu);
+
+	ep.buffer = &cb->qsi;
+	smp_call_function_single(cpu, execute_qsi, &ep, 1);
+
+	if (cb->qsi.cs)
+		printk(KERN_EMERG "CPUMF sampling was not set inactive.\n");
+
+	return rc;
+}
+
+int smp_ctl_ssctl_enable_activate(int cpu, unsigned long interval)
+{
+	int rc;
+	struct hws_execute_parms ep;
+	struct cpu_buffer *cb;
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+
+	cb->ssctl.h = 1;
+	cb->ssctl.tear = cb->first_sdbt;
+	cb->ssctl.dear = *(unsigned long *) cb->first_sdbt;
+	cb->ssctl.interval = interval;
+	cb->ssctl.es = 1;
+	cb->ssctl.cs = 1;
+
+	ep.buffer = &cb->ssctl;
+	smp_call_function_single(cpu, execute_ssctl, &ep, 1);
+	rc = ep.rc;
+	if (rc)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF SSCTL failed.\n", cpu);
+
+	ep.buffer = &cb->qsi;
+	smp_call_function_single(cpu, execute_qsi, &ep, 1);
+	if (ep.rc)
+		printk(KERN_ERR "hwsampler: CPU %d CPUMF QSI failed.\n", cpu);
+
+	return rc;
+}
+
+int smp_ctl_qsi(int cpu)
+{
+	struct hws_execute_parms ep;
+	struct cpu_buffer *cb;
+
+	cb = &per_cpu(hws_cpu_buffer, cpu);
+
+	ep.buffer = &cb->qsi;
+	smp_call_function_single(cpu, execute_qsi, &ep, 1);
+
+	return ep.rc;
+}
Index: linux-2.6/arch/s390/Kconfig
===================================================================
--- linux-2.6.orig/arch/s390/Kconfig
+++ linux-2.6/arch/s390/Kconfig
@@ -127,6 +127,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select HAVE_HWSAMPLER
 
 config SCHED_OMIT_FRAME_POINTER
 	bool
@@ -618,6 +619,27 @@ config SECCOMP
 
 	  If unsure, say Y.
 
+config HWSAMPLER
+	tristate "Exploit CPUMF hardware sampling with OProfile"
+	depends on OPROFILE
+	depends on HAVE_HWSAMPLER
+	depends on 64BIT
+	select OPROFILE_HWSAMPLING_MODE
+	help
+	  Hardware (HW) sampling is a feature provided by z processor.
+	  The sampling process is implemented in hardware and millicode
+	  and thus does not affect the operating system being observed,
+	  apart from the required buffer memory that Linux kernel must
+	  provide.
+
+	  If unsure, say N.
+
+config HAVE_HWSAMPLER
+	bool
+
+config OPROFILE_HWSAMPLING_MODE
+	bool
+
 endmenu
 
 menu "Power Management"
Index: linux-2.6/arch/s390/oprofile/Makefile
===================================================================
--- linux-2.6.orig/arch/s390/oprofile/Makefile
+++ linux-2.6/arch/s390/oprofile/Makefile
@@ -1,3 +1,4 @@
+obj-$(CONFIG_HWSAMPLER)        += hwsampler.o
 obj-$(CONFIG_OPROFILE) += oprofile.o
 
 DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
@@ -7,3 +8,8 @@ DRIVER_OBJS = $(addprefix ../../../drive
 		timer_int.o )
 
 oprofile-y				:= $(DRIVER_OBJS) init.o backtrace.o
+
+HW_SAMPLER_DRIVER_OBJS = $(addprefix ../../../drivers/s390/hwsampler/, \
+		hwsampler-main.o smpctl.o )
+
+hwsampler-y				:= $(HW_SAMPLER_DRIVER_OBJS)

