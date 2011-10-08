Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1JHQcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 12:32:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45322 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab1JHQct convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 12:32:49 -0400
MIME-Version: 1.0
In-Reply-To: <8905.1317984176@redhat.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
	<CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
	<6324.1317308270@redhat.com>
	<CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com>
	<12748.1317313818@redhat.com>
	<CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com>
	<CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com>
	<18003.1317336244@redhat.com>
	<CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com>
	<6261.1317385734@redhat.com>
	<CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com>
	<8905.1317984176@redhat.com>
Date: Sat, 8 Oct 2011 09:32:48 -0700
Message-ID: <CAOH1cHmpFF8vT8HVU3RL95p_s9ec2RJ1+o4K2TOrWX2QJrvwog@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 3:42 AM, David Howells <dhowells@redhat.com> wrote:
> Mark Moseley <moseleymark@gmail.com> wrote:
>
>> [ 7719.996883] FS-Cache: Assertion failed
>> [ 7719.996886] 3 == 5 is false
>> [ 7719.996906] ------------[ cut here ]------------
>> [ 7720.006139] kernel BUG at fs/fscache/operation.c:408!
>
> Can you add the attached patch?  It will display which operation was being run
> just before displaying the above assertion.
>
> David
> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] FS-Cache: Give operations names for debugging
>
> Give operations names for debugging and print it if we're going to assert.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  fs/fscache/object.c           |    1 +
>  fs/fscache/operation.c        |   18 ++++++++++++++++++
>  fs/fscache/page.c             |    5 +++++
>  include/linux/fscache-cache.h |   14 +++++++++++++-
>  4 files changed, 37 insertions(+), 1 deletions(-)
>
>
> diff --git a/fs/fscache/object.c b/fs/fscache/object.c
> index 80b5491..91d998b 100644
> --- a/fs/fscache/object.c
> +++ b/fs/fscache/object.c
> @@ -940,6 +940,7 @@ static void fscache_invalidate_object(struct fscache_object *object)
>        }
>
>        fscache_operation_init(op, object->cache->ops->invalidate_object, NULL);
> +       op->name = FSCACHE_OP_INVALIDATE;
>        op->flags = FSCACHE_OP_ASYNC | (1 << FSCACHE_OP_EXCLUSIVE);
>
>        spin_lock(&cookie->lock);
> diff --git a/fs/fscache/operation.c b/fs/fscache/operation.c
> index 2037f03..6bfefee 100644
> --- a/fs/fscache/operation.c
> +++ b/fs/fscache/operation.c
> @@ -20,6 +20,16 @@
>  atomic_t fscache_op_debug_id;
>  EXPORT_SYMBOL(fscache_op_debug_id);
>
> +static const char *const fscache_op_names[FSCACHE_OP__NR] = {
> +       [FSCACHE_OP_UNNAMED]            = "Unnamed",
> +       [FSCACHE_OP_INVALIDATE]         = "Invalidate",
> +       [FSCACHE_OP_ATTR_CHANGED]       = "AttrChanged",
> +       [FSCACHE_OP_ALLOC_PAGE]         = "AllocPage",
> +       [FSCACHE_OP_READ_OR_ALLOC_PAGE] = "ReadOrAllocPage",
> +       [FSCACHE_OP_READ_OR_ALLOC_PAGES] = "ReadOrAllocPages",
> +       [FSCACHE_OP_WRITE]              = "Write",
> +};
> +
>  /**
>  * fscache_enqueue_operation - Enqueue an operation for processing
>  * @op: The operation to enqueue
> @@ -86,6 +96,7 @@ int fscache_submit_exclusive_op(struct fscache_object *object,
>  {
>        _enter("{OBJ%x OP%x},", object->debug_id, op->debug_id);
>
> +       ASSERTCMP(op->name, >, FSCACHE_OP_UNNAMED);
>        ASSERTCMP(op->state, ==, FSCACHE_OP_ST_INITIALISED);
>        ASSERTCMP(atomic_read(&op->usage), >, 0);
>
> @@ -189,6 +200,7 @@ int fscache_submit_op(struct fscache_object *object,
>        _enter("{OBJ%x OP%x},{%u}",
>               object->debug_id, op->debug_id, atomic_read(&op->usage));
>
> +       ASSERTCMP(op->name, >, FSCACHE_OP_UNNAMED);
>        ASSERTCMP(op->state, ==, FSCACHE_OP_ST_INITIALISED);
>        ASSERTCMP(atomic_read(&op->usage), >, 0);
>
> @@ -404,6 +416,12 @@ void fscache_put_operation(struct fscache_operation *op)
>                return;
>
>        _debug("PUT OP");
> +
> +       if (op->state != FSCACHE_OP_ST_COMPLETE &&
> +           op->state != FSCACHE_OP_ST_CANCELLED)
> +               printk("FS-Cache: Asserting on %s operation\n",
> +                      fscache_op_names[op->name]);
> +
>        ASSERTIFCMP(op->state != FSCACHE_OP_ST_COMPLETE,
>                    op->state, ==, FSCACHE_OP_ST_CANCELLED);
>        op->state = FSCACHE_OP_ST_DEAD;
> diff --git a/fs/fscache/page.c b/fs/fscache/page.c
> index 00a5ed9..cf6dd34 100644
> --- a/fs/fscache/page.c
> +++ b/fs/fscache/page.c
> @@ -188,6 +188,7 @@ int __fscache_attr_changed(struct fscache_cookie *cookie)
>        }
>
>        fscache_operation_init(op, fscache_attr_changed_op, NULL);
> +       op->name = FSCACHE_OP_ATTR_CHANGED;
>        op->flags = FSCACHE_OP_ASYNC | (1 << FSCACHE_OP_EXCLUSIVE);
>
>        spin_lock(&cookie->lock);
> @@ -379,6 +380,7 @@ int __fscache_read_or_alloc_page(struct fscache_cookie *cookie,
>                _leave(" = -ENOMEM");
>                return -ENOMEM;
>        }
> +       op->op.name = FSCACHE_OP_READ_OR_ALLOC_PAGE;
>        op->n_pages = 1;
>
>        spin_lock(&cookie->lock);
> @@ -505,6 +507,7 @@ int __fscache_read_or_alloc_pages(struct fscache_cookie *cookie,
>        op = fscache_alloc_retrieval(mapping, end_io_func, context);
>        if (!op)
>                return -ENOMEM;
> +       op->op.name = FSCACHE_OP_READ_OR_ALLOC_PAGES;
>        op->n_pages = *nr_pages;
>
>        spin_lock(&cookie->lock);
> @@ -635,6 +638,7 @@ int __fscache_alloc_page(struct fscache_cookie *cookie,
>        op = fscache_alloc_retrieval(page->mapping, NULL, NULL);
>        if (!op)
>                return -ENOMEM;
> +       op->op.name = FSCACHE_OP_ALLOC_PAGE;
>        op->n_pages = 1;
>
>        spin_lock(&cookie->lock);
> @@ -856,6 +860,7 @@ int __fscache_write_page(struct fscache_cookie *cookie,
>
>        fscache_operation_init(&op->op, fscache_write_op,
>                               fscache_release_write_op);
> +       op->op.name = FSCACHE_OP_WRITE;
>        op->op.flags = FSCACHE_OP_ASYNC | (1 << FSCACHE_OP_WAITING);
>
>        ret = radix_tree_preload(gfp & ~__GFP_HIGHMEM);
> diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
> index 29f552d..fa61436 100644
> --- a/include/linux/fscache-cache.h
> +++ b/include/linux/fscache-cache.h
> @@ -85,6 +85,17 @@ enum fscache_operation_state {
>        FSCACHE_OP_ST_DEAD              /* Op is now dead */
>  };
>
> +enum fscache_operation_name {
> +       FSCACHE_OP_UNNAMED,
> +       FSCACHE_OP_INVALIDATE,
> +       FSCACHE_OP_ATTR_CHANGED,
> +       FSCACHE_OP_ALLOC_PAGE,
> +       FSCACHE_OP_READ_OR_ALLOC_PAGE,
> +       FSCACHE_OP_READ_OR_ALLOC_PAGES,
> +       FSCACHE_OP_WRITE,
> +       FSCACHE_OP__NR
> +};
> +
>  struct fscache_operation {
>        struct work_struct      work;           /* record for async ops */
>        struct list_head        pend_link;      /* link in object->pending_ops */
> @@ -99,7 +110,8 @@ struct fscache_operation {
>  #define FSCACHE_OP_DEC_READ_CNT        6       /* decrement object->n_reads on destruction */
>  #define FSCACHE_OP_KEEP_FLAGS  0x0070  /* flags to keep when repurposing an op */
>
> -       enum fscache_operation_state state;
> +       enum fscache_operation_state state : 8;
> +       enum fscache_operation_name name : 8;
>        atomic_t                usage;
>        unsigned                debug_id;       /* debugging ID */
>
> --


Here's the latest. I'd emptied out the cache first, so it stayed up
for quite a while.

Console:

[37818.485559] kernel BUG at fs/fscache/object-list.c:64!
[37818.486239] invalid opcode: 0000 [#1] SMP
[37818.486239] CPU 4
[37818.486239] Modules linked in: xfs ioatdma dca loop joydev evdev
psmouse dcdbas pcspkr i5000_edac serio_raw edac_core shpchp i5k_amb
pci_hotplug sg sr_mod cdrom ehci_hcd uhci_hcd sd_mod crc_t10dif [last
unloaded: scsi_wait_scan]
[37818.486239]
[37818.486239] Pid: 29993, comm: httpd Not tainted 3.1.0-rc8 #1 Dell
Inc. PowerEdge 1950/0DT097
[37818.486239] RIP: 0010:[<ffffffff8119c548>]  [<ffffffff8119c548>]
fscache_objlist_add+0xa8/0xb0
[37818.486239] RSP: 0018:ffff88002233bb28  EFLAGS: 00010246
[37818.486239] RAX: ffff880040861380 RBX: ffff880040861380 RCX: ffff880040860fd0
[37818.486239] RDX: ffff880040861450 RSI: ffff880223eae000 RDI: ffffffff81c94b90
[37818.486239] RBP: ffff88002233bb38 R08: ffff880010e74680 R09: 0000000000000069
[37818.486239] R10: ffff880010e746e2 R11: ffff880010e746e1 R12: ffff8800408613c8
[37818.486239] R13: ffff88021ded9000 R14: ffff88021a8682d0 R15: ffff880040861380
[37818.486239] FS:  00007fbabf4e36e0(0000) GS:ffff88022fd00000(0000)
knlGS:0000000000000000
[37818.486239] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[37818.486239] CR2: ffffffffff600400 CR3: 000000012e062000 CR4: 00000000000006e0
[37818.486239] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[37818.486239] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[37818.486239] Process httpd (pid: 29993, threadinfo ffff88002233a000,
task ffff8800c70944a0)
[37818.486239] Stack:
[37818.486239]  ffff88021a8682d0 0000000000000000 ffff88002233bb88
ffffffff81194bbe
[37818.486239]  ffff88002233bbc8 ffff88021a8682d8 ffff88021ded9000
ffff88021ded9000
[37818.486239]  ffff880105ad18c0 ffff88021ded9000 ffff880105ad18c0
ffff880040861200
[37818.486239] Call Trace:
[37818.486239]  [<ffffffff81194bbe>] fscache_alloc_object+0x20e/0x460
[37818.486239]  [<ffffffff81194ac4>] fscache_alloc_object+0x114/0x460
[37818.486239]  [<ffffffff81194f6c>] __fscache_acquire_cookie+0x15c/0x610
[37818.486239]  [<ffffffff81224800>] ? nfs_file_release+0x80/0x80
[37818.486239]  [<ffffffff812510dc>] nfs_fscache_set_inode_cookie+0x10c/0x170
[37818.486239]  [<ffffffff812277a5>] nfs_open+0x95/0xa0
[37818.486239]  [<ffffffff81224857>] nfs_file_open+0x57/0x90
[37818.486239]  [<ffffffff8112040a>] __dentry_open+0x17a/0x310
[37818.486239]  [<ffffffff8112069b>] nameidata_to_filp+0x7b/0x80
[37818.486239]  [<ffffffff81130895>] do_last+0x305/0x8f0
[37818.486239]  [<ffffffff81130f54>] path_openat+0xd4/0x3f0
[37818.486239]  [<ffffffff81131398>] do_filp_open+0x48/0xa0
[37818.486239]  [<ffffffff8113d912>] ? alloc_fd+0x52/0x150
[37818.486239]  [<ffffffff81120052>] do_sys_open+0x152/0x1e0
[37818.486239]  [<ffffffff81120120>] sys_open+0x20/0x30
[37818.486239]  [<ffffffff8162b46b>] system_call_fastpath+0x16/0x1b
[37818.486239] Code: 00 00 00 00 00 00 00 48 c7 c6 78 7e e3 81 48 89
38 e8 8d a4 13 00 f0 81 05 52 86 af 00 00 00 10 00 48 83 c4 08 5b c9
c3 0f 1f 00 <0f> 0b eb fe 90 90 90 90 55 48 89 e5 66 66 66 66 90 48 8b
87 b0
[37818.486239] RIP  [<ffffffff8119c548>] fscache_objlist_add+0xa8/0xb0
[37818.486239]  RSP <ffff88002233bb28>
[37819.051624] ---[ end trace 6a206d80f756f517 ]---

(Gets a bit garbled here)

[37819.062840] Kernel panic - not syncing: Fatal exception
[37819.073661] Pid: 29993, comm: httpd Tainted: G      D     3.1.0-rc8 #1
[37819.087096] Call Trace:
[37819.092154]  [<ffffffff816274eb>] panic+0xbf/0x1eb
2011 Oct  7 23:4[37819.103855]  [<ffffffff8104b98f>] ? kmsg_dump+0x4f/0x100
3:13 boscust2102[37819.115413]  [<ffffffff81005c08>] oops_end+0xa8/0xf0
 [37818.476323] [37819.128645]  [<ffffffff81005d4b>] die+0x5b/0x90
------------[ cu[37819.140099]  [<ffffffff81003386>] do_trap+0x156/0x180
t here ]--------[37819.152708]  [<ffffffff81072cea>] ?
atomic_notifier_call_chain+0x1a/0x20
----
    2011 Oct  7[37819.169172]  [<ffffffff81003805>] do_invalid_op+0x95/0xb0
 23:43:13 boscus[37819.182466]  [<ffffffff8119c548>] ?
fscache_objlist_add+0xa8/0xb0
t2102 [37818.486[37819.197295]  [<ffffffff812dc64a>] ?
trace_hardirqs_off_thunk+0x3a/0x6c
239] invalid opc[37819.213052]  [<ffffffff8162ac7a>] ? restore_args+0x30/0x30
ode: 0000 [#1] S[37819.226799]  [<ffffffff8162d435>] invalid_op+0x15/0x20
MP
   [37819.239844]  [<ffffffff8119c548>][37819.458030]


>From logs:


kernel: [10612.850523] [httpd ] <== __fscache_read_or_alloc_pages() =
-ENOBUFS [invalidating]
kernel: [11884.736750] [httpd ] <== __fscache_read_or_alloc_pages() =
-ENOBUFS [invalidating]
kernel: [18237.236009] [httpd ] <== __fscache_read_or_alloc_pages() =
-ENOBUFS [invalidating]
kernel: [33519.922973] [httpd ] <== __fscache_read_or_alloc_pages() =
-ENOBUFS [invalidating]
kernel: [36447.036182] [httpd ] <== __fscache_read_or_alloc_pages() =
-ENOBUFS [invalidating]
kernel: [37818.476323] ------------[ cut here ]------------
kernel: [37818.485559] kernel BUG at fs/fscache/object-list.c:64!
kernel: [37818.486239] invalid opcode: 0000 [#1] SMP
kernel: [37818.486239] CPU 4
kernel: [37818.486239] Modules linked in: xfs ioatdma dca loop joydev
evdev psmouse dcdbas pcspkr i5000_edac serio_raw edac_core
g sr_mod cdrom ehci_hcd uhci_hcd sd_mod crc_t10dif [last unloaded:
scsi_wait_scan]
kernel: [37818.486239]
kernel: [37818.486239] Pid: 29993, comm: httpd Not tainted 3.1.0-rc8
#1 Dell Inc. PowerEdge 1950/0DT097
kernel: [37818.486239] RIP: 0010:[<ffffffff8119c548>]
[<ffffffff8119c548>] fscache_objlist_add+0xa8/0xb0
kernel: [37818.486239] RSP: 0018:ffff88002233bb28  EFLAGS: 00010246
kernel: [37818.486239] RAX: ffff880040861380 RBX: ffff880040861380
RCX: ffff880040860fd0
kernel: [37818.486239] RDX: ffff880040861450 RSI: ffff880223eae000
RDI: ffffffff81c94b90
kernel: [37818.486239] RBP: ffff88002233bb38 R08: ffff880010e74680
R09: 0000000000000069
kernel: [37818.486239] R10: ffff880010e746e2 R11: ffff880010e746e1
R12: ffff8800408613c8
kernel: [37818.486239] R13: ffff88021ded9000 R14: ffff88021a8682d0
R15: ffff880040861380
