Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1AOXED (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 18:04:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39805 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab1AOXEB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 18:04:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=k1uSzr/9Cw698LZz9NCQWdMNcVyC9oMF/HEniL7P2lVOFtO4TreQ9UnALTmzyC1oNh
         pZm4ZPQmVHMp9Xv3JaV0OBvJWcGeYjOTAEF78j7T/qcCZhaIa+UjQnztygjvg4X8n2yR
         8YVW/XMSQnCFCR7EOVaD5PZLOq9IZNAUfbKoA=
MIME-Version: 1.0
In-Reply-To: <AANLkTin9dGAQ1fZM_8MsFr3dGwc17vGEGszY_hPMdozp@mail.gmail.com>
References: <AANLkTin9dGAQ1fZM_8MsFr3dGwc17vGEGszY_hPMdozp@mail.gmail.com>
Date: Sat, 15 Jan 2011 16:03:59 -0700
Message-ID: <AANLkTimgYxjJwF+kORC6Z9vJMLwGvQVv85PkGPRCzyvK@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request at ffff8800cf669000
From: xing lin <linxingnku@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out I can not read that page in a kernel module at all. A
simple read of that page will result in an oops as well. I have
checked the flags of this page with others. They are almost the same.
Any suggestions about why this happens or how to know whether a page
can be read or not are really welcome. Thanks.

my module to print the content of a single page to dmesg:
#include <linux/module.h>       /* We're building a module */
#include <linux/kernel.h>       /* We're doing kernel work */
#include <linux/proc_fs.h>      /* because we use proc fs */
#include <asm/uaccess.h>        /* for copy_from_user */
#include <linux/mm.h>           /* for page_address and kmap */
#include <linux/highmem.h>

#define DRIVER_AUTHOR "utos"
#define DRIVER_DESC   "A driver for memory de-duplication"
#define proc_fn       "singlepage"

//extern struct page *mem_map;
extern unsigned long num_physpages;
//extern unsigned long max_mapnr;

struct proc_dir_entry *proc_file = NULL;
static unsigned long pageid = 0;
char debug = 0;

int
procfile_read(char *buffer, char **start,
              off_t offset, int count, int *peof, void *dat)
{
        struct page *page = pfn_to_page(pageid);
        void *virt = page_address(page);
        char mapped = 0;
        int i = 0;
        if (debug == 1)
                printk(KERN_DEBUG "offset: %lu, count: %d\n", offset, count);

        if (offset >= PAGE_SIZE) {
                printk(KERN_INFO "reach file end!\n");
                *peof = 1;
                return 0;
        }

        if (virt == NULL) {
                virt = kmap(page);
                if (virt == NULL) {
                        printk(KERN_ALERT "Fail to map highmem!");
                        return 0;
                }
                mapped = 1;
        }

        if (count > PAGE_SIZE - offset) {
                count = PAGE_SIZE - offset;
                *peof = 1;
        }

        if (debug == 1)
                printk(KERN_DEBUG "offset: %lu, count: %d\n", offset, count);

        i = 0;
        while (i < count) {
                //*(unsigned char *) (buffer + i) =
                  //  *((unsigned char *) virt + offset + i);
                //printk("%02X", *((unsigned char *) buffer + i));
                printk("%02X", *((unsigned char *) virt + offset + i));
                i++;
        }
       if (mapped == 1) {
                kunmap(page);
        }

        *(int *) start = count;
        return count;
}

void show_flags(struct page * page){
        if( PageLocked(page) ){
                printk(KERN_INFO "locked\t");
        }
        if( PageMlocked(page) ){
                printk(KERN_INFO "mlocked\t");
        }
        if( PageUnevictable(page) ){
                printk(KERN_INFO "unevictable\t");
        }
        if( PageHWPoison(page) ){
                printk(KERN_INFO "hwpoison\t");
        }
        if( PageError(page) ){
                printk(KERN_INFO "error\t");
        }
        if( PageActive(page) ){
                printk(KERN_INFO "active\t");
        }
        if( PageDirty(page) ){
                printk(KERN_INFO "dirty\t");
        }
        if( PagePrivate(page) ){
                printk(KERN_INFO "private\t");
        }
        if( PageReferenced(page) ){
                printk(KERN_INFO "referenced\t");
        }
        if( PageUptodate(page) ){
                printk(KERN_INFO "uptodate\t");
        }
        if( PageWriteback(page) ){
                printk(KERN_INFO "writeback\t");
        }
        if( PageSwapCache(page) ){
                printk(KERN_INFO "swapcache\t");
        }
        if( PageLRU(page) ){
                printk(KERN_INFO "lru\t");
        }
        if( PageSlab(page) ){
                printk(KERN_INFO "slab\t");
        }
        if( PageBuddy(page) ){
                printk(KERN_INFO "buddy\t");
        }
        if( PageChecked(page) ){
                printk(KERN_INFO "checked\t");
        }
        if( PageSwapBacked(page) ){
                printk(KERN_INFO "swapbacked\t");
        }
        if( PageSlobFree(page) ){
                printk(KERN_INFO "swapbacked\t");
        }
        if( PageSlubFrozen(page) ){
                printk(KERN_INFO "slubfrozen\t");
        }
        if( PageSlubDebug(page) ){
                printk(KERN_INFO "slubdebug\t");
        }
        if( PagePrivate2(page) ){
                printk(KERN_INFO "private2\t");
        }
       if( PageOwnerPriv1(page) ){
                printk(KERN_INFO "ownerpriv1\t");
        }
        if( PageMappedToDisk(page) ){
                printk(KERN_INFO "mappedtodisk\t");
        }
        if( PageReadahead(page) ){
                printk(KERN_INFO "readahead\t");
        }
        if( PageReclaim(page) ){
                printk(KERN_INFO "reclaim\t");
        }
        printk(KERN_INFO "show flags done\n");
}

int
procfile_write(struct file *file, const char *buffer, unsigned long count,
               void *data)
{
        unsigned long bytes_not_copied = 0;
        // page id is copied into kernel as a string.
        char page_id[20] = { 0 };

        bytes_not_copied = copy_from_user(page_id, buffer, count);
        if (bytes_not_copied != 0) {
                printk(KERN_ALERT "%lu bytes not copied!", bytes_not_copied);
                return -EFAULT;
        }
        pageid = simple_strtoul(page_id, NULL, 10);
        if (pageid >= num_physpages) {
                printk(KERN_ALERT "pageid >= max pageid %lu!\n", num_physpages);
                return -EFAULT;
        }
        if( !pfn_valid(pageid) ){
                printk(KERN_ALERT "pageid %lu not valid\n", pageid);
                pageid = 0;
                return -EFAULT;
        }

        printk(KERN_INFO "page id is %lu!\n", pageid);
        show_flags( pfn_to_page(pageid) );
        return count;
static int __init
lkp_init(void)
{
        printk(KERN_INFO "Hello from memory de-duplication module\n");
        printk("num_physpages: %lu\n", num_physpages);
        proc_file = create_proc_entry(proc_fn, 0666, NULL);
        if (proc_file == NULL) {
                printk(KERN_ALERT "Error: Could not initialize /proc/%s\n",
                       proc_fn);
                return -ENOMEM;
        }

        proc_file->read_proc = procfile_read;
        proc_file->write_proc = procfile_write;
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


kernel oops text:
[  372.859454] Hello from memory de-duplication module
[  372.859457] num_physpages: 3342336
[  372.859462] /proc/singlepage created
[  394.392650] page id is 1!
[  394.392653] show flags done
[  417.293931] 00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000!
 0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
[  417.295525] reach file end!
[  453.987176] page id is 849513!
[  453.987178] show flags done
[  465.667568] BUG: unable to handle kernel paging request at ffff8800cf669000
[  465.682373] IP: [<ffffffffa00da5cc>] procfile_read+0x14c/0x178 [singlepage]
[  465.697178] PGD 1002063 PUD a067 PMD b067 PTE 0
[  465.710129] Oops: 0000 [#1] SMP
[  465.721590] last sysfs file:
/sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
[  465.745166] CPU 5
[  465.755224] Modules linked in: singlepage nfs lockd nfs_acl
auth_rpcgss sunrpc fbcon tileblit font bitblit power_meter psmouse
softcursor joydev dell_wmi serio_raw dcdbas vga16fb vgastate bnx2 lp
parport usbhid hid mptsas mptscsih mptbase scsi_transport_sas [last
unloaded: singlepage]
[  465.820069] Pid: 2349, comm: cat Not tainted 2.6.32-24-generic
#38+emulab1 PowerEdge R710
[  465.847062] RIP: 0010:[<ffffffffa00da5cc>]  [<ffffffffa00da5cc>]
procfile_read+0x14c/0x178 [singlepage]
[  465.847067] RSP: 0018:ffff8803209abda8  EFLAGS: 00010246
[  465.847069] RAX: ffff880000000000 RBX: 0000000000000000 RCX: 0000000000000c00
[  465.847071] RDX: 0000000000000c00 RSI: ffff8803209abe08 RDI: ffff88031ea6e000
[  465.847074] RBP: ffff8803209abdd8 R08: ffff8803209abe14 R09: 0000000000000000
[  465.847076] R10: ffffffffa00da480 R11: 0000000000000c00 R12: ffff8803209abe08
[  465.847078] R13: ffff8800cf669000 R14: ffff88031ea6e000 R15: 0000000000008000
[  465.847081] FS:  00007fd434162700(0000) GS:ffff8800330a0000(0000)
knlGS:0000000000000000
[  465.847083] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  465.847085] CR2: ffff8800cf669000 CR3: 000000031b575000 CR4: 00000000000006e0
[  465.847088] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  465.847090] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  465.847093] Process cat (pid: 2349, threadinfo ffff8803209aa000,
task ffff88032179c4d0)
[  465.847094] Stack:
[  465.847096]  ffff8803209abf48 fffffffffffffff4 0000000000c01000
ffff8803209abf48
[  465.847098] <0> 0000000000000c00 0000000000c01000 ffff8803209abe48
ffffffff811a10d7
[  465.847101] <0> 0000000000008000 0000000000000000 0000000000000000
ffff88032171e900
[  465.847105] Call Trace:
[  465.847112]  [<ffffffff811a10d7>] __proc_file_read+0x197/0x2e0
[  465.847118]  [<ffffffff811a128d>] proc_file_read+0x6d/0xb0
[  465.847121]  [<ffffffff811a1220>] ? proc_file_read+0x0/0xb0
[  465.847125]  [<ffffffff8119b751>] proc_reg_read+0x81/0xc0
[  465.847130]  [<ffffffff81144385>] vfs_read+0xb5/0x1a0
[  465.847134]  [<ffffffff81546f88>] ? do_page_fault+0x158/0x3b0
[  465.847137]  [<ffffffff81144541>] sys_read+0x51/0x80
[  465.847143]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b
[  465.847145] Code: 89 4d d8 4c 89 45 d0 e8 57 71 46 e1 4c 8b 45 d0
8b 4d d8 e9 fa fe ff ff 48 b8 00 00 00 00 00 88 ff ff 48 01 c3 4e 8d
2c 2b 31 db <41> 0f b6 75 00 31 c0 48 c7 c7 68 a8 0d a0 89 4d d8 83 c3
01 49
[  465.847165] RIP  [<ffffffffa00da5cc>] procfile_read+0x14c/0x178 [singlepage]
[  465.847169]  RSP <ffff8803209abda8>
[  465.847171] CR2: ffff8800cf669000
[  465.847173] ---[ end trace a6d7a7d3359f2672 ]---
