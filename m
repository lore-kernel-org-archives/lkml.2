Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1ANXay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:30:54 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47552 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab1ANXaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:30:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=IWd7A5EVmhzW1vzhtnVXn0iKOOjbeaKgvEsWd1veJ2/Mtn1w+WxWuyOu9F6QdNJpBS
         LQHEtezZiajGdvUqCBUshHngMklAjX2zAwrF9GI6A9ysNn5A1eg8tBUPDG+PtZm7/nbG
         q1B9b3TSHnhKmTXA58km+4ULDs3ztc7xs7lJw=
MIME-Version: 1.0
Date: Fri, 14 Jan 2011 16:30:51 -0700
Message-ID: <AANLkTin9dGAQ1fZM_8MsFr3dGwc17vGEGszY_hPMdozp@mail.gmail.com>
Subject: BUG: unable to handle kernel paging request at ffff8800cf669000
From: xing lin <linxingnku@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote a kernel module to calculate the hash for each page frame, in
order to see how many pages are duplicated. It works well in 32-bit
Linux with 2GB physical memory. But when I tried to run this module in
64-bit Linux(2.6.32-24-generic with NUMA enabled) with 12GB physical
memory, it can calculates hashes for the first 63553 in-use pages but
then reports a bug when the page frame number reaches 849513. This
page frame should be in use since the count for the page instance is
1. I do not know why sha_transform results in a page_fault(the data to
be digested is the page which should be in memory). Would anyone give
me some hints? Thanks.

 oops.txt from dmesg:
-----------------------------------
[  590.424038] BUG: unable to handle kernel paging request at ffff8800cf669000
[  590.438705] IP: [<ffffffff8152edc8>] sha_transform+0x18/0x1e0
[  590.452164] PGD 1002063 PUD a067 PMD b067 PTE 0
[  590.464888] Oops: 0000 [#1] SMP
[  590.476077] last sysfs file:
/sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[  590.499137] CPU 7
[  590.508929] Modules linked in: sha1_generic pageinfo_NUMA nfs lockd
nfs_acl auth_rpcgss sunrpc joydev fbcon tileblit dell_wmi dcdbas font
bitblit softcursor power_meter vga16fb vgastate psmouse serio_raw bnx2
lp parport usbhid hid mptsas mptscsih mptbase scsi_transport_sas
[  590.570965] Pid: 1887, comm: cat Not tainted 2.6.32-24-generic
#38+emulab1 PowerEdge R710
[  590.597398] RIP: 0010:[<ffffffff8152edc8>]  [<ffffffff8152edc8>]
sha_transform+0x18/0x1e0
[  590.625098] RSP: 0018:ffff88031eeaba58  EFLAGS: 00010292
[  590.640580] RAX: 0000000000000000 RBX: 0000000000000040 RCX: 0000000000001000
[  590.658272] RDX: ffff88031eeabaa8 RSI: ffff8800cf669000 RDI: ffff88031f45e418
[  590.676439] RBP: ffff88031eeaba88 R08: 0000000000001000 R09: ffff88031eeabd98
[  590.694972] R10: 0000000000000080 R11: 0000000000000000 R12: 0000000000001000
[  590.713897] R13: ffff88031eeabaa8 R14: ffff88031f45e410 R15: ffff8800cf669000
[  590.733149] FS:  00007f2407450700(0000) GS:ffff8800330e0000(0000)
knlGS:0000000000000000
[  590.765186] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  590.783268] CR2: ffff8800cf669000 CR3: 000000031b790000 CR4: 00000000000006e0
[  590.802954] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  590.823136] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  590.843410] Process cat (pid: 1887, threadinfo ffff88031eeaa000,
task ffff88031b5bdbc0)
[  590.878043] Stack:
[  590.893066]  0d4c51d000000018 0000000000000040 0000000000001000
ffff88031eeabaa8
[  590.914054] <0> ffff88031f45e410 ffff8800cf669000 ffff88031eeabc18
ffffffffa00ca19a
[  590.948862] <0> ffff88031eeabc28 ffff88031f45e418 0000000000000000
ffff88031f45e418
[  590.997951] Call Trace:
[  591.013756]  [<ffffffffa00ca19a>] sha1_update+0x7a/0xe0 [sha1_generic]
[  591.033840]  [<ffffffff812ba88c>] ? put_dec+0x10c/0x110
[  591.052640]  [<ffffffff812bab7e>] ? number+0x2ee/0x320
[  591.070975]  [<ffffffff8113783f>] ? __kmalloc+0x1bf/0x1d0
[  591.089383]  [<ffffffff812887fc>] ? crypto_create_tfm+0x3c/0xe0
[  591.107931]  [<ffffffff8128f71f>] ? crypto_init_shash_ops_compat+0x5f/0xe0
[  591.127289]  [<ffffffff8128f188>] crypto_shash_update+0x18/0x30
[  591.145595]  [<ffffffff8128f1de>] shash_compat_update+0x3e/0x60
[  591.163827]  [<ffffffff8128f420>] shash_compat_digest+0x100/0x130
[  591.181974]  [<ffffffffa00a624d>] de_seq_show+0x14d/0x340 [pageinfo_NUMA]
[  591.200520]  [<ffffffff81013b0e>] ? common_interrupt+0xe/0x13
[  591.217877]  [<ffffffffa00a604f>] ? de_seq_next+0x3f/0xd0 [pageinfo_NUMA]
[  591.236138]  [<ffffffff81162eb7>] seq_read+0x267/0x3f0
[  591.252486]  [<ffffffff81162c50>] ? seq_read+0x0/0x3f0
[  591.268687]  [<ffffffff8119b751>] proc_reg_read+0x81/0xc0
[  591.285048]  [<ffffffff81144385>] vfs_read+0xb5/0x1a0
[  591.300730]  [<ffffffff81144541>] sys_read+0x51/0x80
[  591.316125]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b
[  591.332247] Code: 32 10 c7 47 10 f0 e1 d2 c3 c9 c3 0f 1f 84 00 00
00 00 00 55 31 c0 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 0f
1f 44 00 00 <8b> 0c 06 0f c9 89 0c 02 48 83 c0 04 48 83 f8 40 75 ee 31
c9 0f
[  591.392058] RIP  [<ffffffff8152edc8>] sha_transform+0x18/0x1e0
[  591.409156]  RSP <ffff88031eeaba58>
[  591.423662] CR2: ffff8800cf669000
[  591.437952] ---[ end trace c858b9629815433b ]---
[  591.453399] note: cat[1887] exited with preempt_count 1
[  591.469249] BUG: scheduling while atomic: cat/1887/0x10000001
[  591.485508] Modules linked in: sha1_generic pageinfo_NUMA nfs lockd
nfs_acl auth_rpcgss sunrpc joydev fbcon tileblit dell_wmi dcdbas font
bitblit softcursor power_meter vga16fb vgastate psmouse serio_raw bnx2
lp parport usbhid hid mptsas mptscsih mptbase scsi_transport_sas
[  591.556226] Pid: 1887, comm: cat Tainted: G      D
2.6.32-24-generic #38+emulab1
[  591.585964] Call Trace:
[  591.599686]  [<ffffffff8105860d>] __schedule_bug+0x7d/0x90
[  591.616501]  [<ffffffff81541f5f>] thread_return+0x1f7/0x418
[  591.633331]  [<ffffffff8106326a>] __cond_resched+0x2a/0x40
[  591.650081]  [<ffffffff81542280>] _cond_resched+0x30/0x40
[  591.666767]  [<ffffffff815434b6>] down_read+0x16/0x30
[  591.683048]  [<ffffffff8106b0fb>] exit_mm+0x3b/0x150
[  591.699185]  [<ffffffff81544325>] ? _spin_lock_irq+0x15/0x20
[  591.715919]  [<ffffffff8106b445>] do_exit+0x125/0x380
[  591.731998]  [<ffffffff81545530>] oops_end+0xb0/0xf0
[  591.748125]  [<ffffffff810408e3>] no_context+0xf3/0x190
[  591.764474]  [<ffffffff81040aa5>] __bad_area_nosemaphore+0x125/0x1e0
[  591.781962]  [<ffffffff81040b73>] bad_area_nosemaphore+0x13/0x20
[  591.799111]  [<ffffffff81547114>] do_page_fault+0x2e4/0x3b0
[  591.815948]  [<ffffffff815448a5>] page_fault+0x25/0x30
[  591.832094]  [<ffffffff8152edc8>] ? sha_transform+0x18/0x1e0
[  591.848585]  [<ffffffffa00ca19a>] sha1_update+0x7a/0xe0 [sha1_generic]
[  591.864986]  [<ffffffff812ba88c>] ? put_dec+0x10c/0x110
[  591.880099]  [<ffffffff812bab7e>] ? number+0x2ee/0x320
[  591.894975]  [<ffffffff8113783f>] ? __kmalloc+0x1bf/0x1d0
[  591.909966]  [<ffffffff812887fc>] ? crypto_create_tfm+0x3c/0xe0
[  591.925493]  [<ffffffff8128f71f>] ? crypto_init_shash_ops_compat+0x5f/0xe0
[  591.942021]  [<ffffffff8128f188>] crypto_shash_update+0x18/0x30
[  591.957478]  [<ffffffff8128f1de>] shash_compat_update+0x3e/0x60
[  591.972784]  [<ffffffff8128f420>] shash_compat_digest+0x100/0x130
[  591.988182]  [<ffffffffa00a624d>] de_seq_show+0x14d/0x340 [pageinfo_NUMA]
[  592.004313]  [<ffffffff81013b0e>] ? common_interrupt+0xe/0x13
[  592.019110]  [<ffffffffa00a604f>] ? de_seq_next+0x3f/0xd0 [pageinfo_NUMA]
[  592.035007]  [<ffffffff81162eb7>] seq_read+0x267/0x3f0
[  592.048918]  [<ffffffff81162c50>] ? seq_read+0x0/0x3f0
[  592.062783]  [<ffffffff8119b751>] proc_reg_read+0x81/0xc0
[  592.076957]  [<ffffffff81144385>] vfs_read+0xb5/0x1a0
[  592.090769]  [<ffffffff81144541>] sys_read+0x51/0x80
[  592.104463]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b

my c file:
-----------------------------------------
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>

#include <linux/mm.h>
#include <linux/mmzone.h>
#include <linux/highmem.h>

#include <linux/crypto.h>
#include <linux/scatterlist.h>
#include <linux/err.h>

#define DRIVER_AUTHOR "utos"
#define DRIVER_DESC   "A driver for memory de-duplication"
#define proc_fn       "pageinfo-NUMA"

//extern struct page *mem_map;
extern unsigned long num_physpages;
//extern unsigned long max_pfn;
static unsigned long pfn = 0;
char debug = 0;

/* This function is called at the beginning of a sequence.
 * ie, when:
 *	- the /proc file is read (first time)
 *	- after the function stop (end of sequence)
 *  pos is the position in /proc/filename.
 */
static void *
de_seq_start(struct seq_file *s, loff_t * pos)
{
	if (debug == 1) {
		printk(KERN_INFO "start: seq_start, pos: %8lu\n",
	    	   *(unsigned long *) pos);
	}

	while( !pfn_valid(*pos) && *pos < num_physpages){
		*pos ++;
	}
	pfn = *(unsigned long *) pos;

	if (pfn < num_physpages) {
		/* begin the sequence. */
		return pfn_to_page(pfn);
	} else {
		printk(KERN_INFO "seq_start: index > num_physpages\n");
		*pos = 0;
		return NULL;
	}
};


/*
 * This function is called after the beginning of a sequence.
 * It's called until the return is NULL (this ends the sequence).
 */
static void *
de_seq_next(struct seq_file *s, void *v, loff_t * pos)
{
	*pos += 1;
	while( !pfn_valid(*pos) && *pos < num_physpages){
		*pos ++;
	}
	pfn = *(unsigned long *) pos;

	if (debug == 1)
		printk(KERN_INFO "seq_next, pfn:%8lu\n", pfn);

	if (pfn >= num_physpages) {
		printk(KERN_INFO "seq_next: pfn >= num_physpages!\n");
		return NULL;
	}
	return pfn_to_page(pfn);
}

/*
 * This function is called for each "step" of a sequence
 */
static int
de_seq_show(struct seq_file *s, void *v)
{
	struct page *page = (struct page *) v;
	void *virt = kmap(page);
	struct scatterlist sg;
	struct crypto_hash *tfm;
	struct hash_desc desc;
	unsigned char result[20];
	if (debug == 1)
		printk(KERN_INFO "seq_show: %8lu\n", pfn);

#ifdef SKIP_UNUSED_PAGES
	if (page_count(page) == 0) {
		if (debug == 1)
			printk(KERN_INFO "skipping page: %8lu\n", pfn);
		return 1;
	}
#endif
	if (virt == NULL) {
		printk(KERN_ALERT "This should not happen in 64-bit machine\n");
		return 1;
	}

	/* get hash of this page */
	tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
	if (IS_ERR(tfm)) {
		printk(KERN_ALERT "Fail to allocate transformer object!");
		return -EFAULT;
	}
	sg_init_table(&sg, 1);
	sg_set_page(&sg, page, PAGE_SIZE, 0);
	desc.tfm = tfm;
	desc.flags = 0;
	if (crypto_hash_digestsize(tfm) > sizeof (result)) {
		printk("digest size(%u) > outputbuffer(%zu)\n",
		       crypto_hash_digestsize(tfm), sizeof (result));
		return -EFAULT;
	}

	if (crypto_hash_digest(&desc, &sg, PAGE_SIZE, (u8 *) result)) {
		printk(KERN_ALERT "Fail to call digest function!");
		return -EFAULT;
	}
	crypto_free_hash(tfm);
	seq_printf(s, "%8lu: 0x%lx, "
		   "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"
		   "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x,"
		   " %d, %d, %d, %d\n",
		   pfn, (unsigned long) virt,
		   result[0], result[1], result[2], result[3], result[4],
		   result[5], result[6], result[7], result[8], result[9],
		   result[10], result[11], result[12], result[13], result[14],
		   result[15], result[16], result[17], result[18], result[19],
		   page_count(page), PageActive(page),
		   PageReserved(page), PageReclaim(page));

	kunmap(page);

	return 0;
}

/*
 * This function is called at the end of a sequence
 */
static void
de_seq_stop(struct seq_file *s, void *v)
{
	//printk(KERN_INFO "seq_read finished \n");
}

static struct seq_operations de_seq_ops = {
	.start = de_seq_start,
	.next = de_seq_next,
	.stop = de_seq_stop,
	.show = de_seq_show
};

static int
proc_open(struct inode *inode, struct file *file)
{
	return seq_open(file, &de_seq_ops);
};

static struct file_operations file_ops = {
	.owner = THIS_MODULE,
	.open = proc_open,
	.read = seq_read,
	.llseek = seq_lseek,
	.release = seq_release
};

static int __init
lkp_init(void)
{
	struct proc_dir_entry *proc_file = NULL;
	printk(KERN_INFO "Hello from memory de-duplication module for NUMA\n");
	printk("num_physpages: %lu\n", num_physpages);
	proc_file = create_proc_entry(proc_fn, 0644, NULL);
	if (proc_file == NULL) {
		printk(KERN_ALERT "Error: Could not initialize /proc/%s\n",
		       proc_fn);
		return -ENOMEM;
	}
	proc_file->proc_fops = &file_ops;
	printk(KERN_INFO "/proc/%s created\n", proc_fn);
	
	return 0;
}
static void __exit
lkp_cleanup(void)
{
	remove_proc_entry(proc_fn, NULL);
	printk(KERN_INFO "Exit from memory de-duplication module\n");
}

MODULE_LICENSE("GPL");
MODULE_AUTHOR(DRIVER_AUTHOR);
MODULE_DESCRIPTION(DRIVER_DESC);

module_init(lkp_init);
module_exit(lkp_cleanup);

Makefile:
--------------------------------
#
# Modules and the files they are made from
#
PAGEINFO = pageinfo-NUMA
MODULES = $(PAGEINFO)
CFILES = $(MODULES:=.c)
OBJFILES = $(CFILES:.c=.o)
KOFILES = $(OBJFILES:.o=.ko)

obj-m += $(OBJFILES)

# If set, don't report pages that have no users.
EXTRA_CFLAGS=-DSKIP_UNUSED_PAGES

# Make sure to set up dependencies between source and object files
%.o: %.c
%.ko: %.o

KVERSION = $(shell uname -r)
all: $(CFILES)
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(KVERSION)/build M=$(PWD) clean

#
# Convience targets
#

# insmod can't be used to install multiple modules at once. So create
# this to install all modules at once.
install: pageinfo_install

pageinfo_install: $(PAGEINFO).ko
	insmod $(PAGEINFO).ko

#singlepage_install: $(SINGLEPAGE).ko
#	insmod $(SINGLEPAGE).ko

deinstall:
	rmmod $(KOFILES)

reinstall: deinstall install

.PHONY: install deinstall reinstall clean



-- 
Regards,
Xing
School of Computing, University of Utah
http://www.cs.utah.edu/~xinglin/
