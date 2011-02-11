Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab1BKSys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:54:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab1BKSyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:54:46 -0500
Date: Fri, 11 Feb 2011 13:54:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, ctalbott@google.com, mrubin@google.com,
        jmoyer@redhat.com, guijanfeng@cn.fujitsu.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Don't update group weights when on service tree.
Message-ID: <20110211185440.GI8773@redhat.com>
References: <1297372086-16138-1-git-send-email-teravest@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297372086-16138-1-git-send-email-teravest@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 01:08:05PM -0800, Justin TerAvest wrote:
> With some instrumentation, we can observe that the total_weight for a 
> service tree can be badly adjusted; particularly when the weight for a 
> group is adjusted without taking it off of the tree. This can be 
> reproduced on the HEAD of the linux-2.6-block tree.
> 
> We have seen this problem in workloads when total_weight becomes 0 and 
> we divide by 0 in cfq_group_slice(), crashing the kernel, but it's
> easier to illustrate by adding a BUG_ON and making it signed, like this:
> 
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -85,7 +85,7 @@ struct cfq_rb_root {
>         struct rb_root rb;
>         struct rb_node *left;
>         unsigned count;
> -       unsigned total_weight;
> +       int total_weight;
>         u64 min_vdisktime;
>  };
>  #define CFQ_RB_ROOT    (struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
> @@ -903,6 +903,7 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq
> 
>         cfq_log_cfqg(cfqd, cfqg, "del_from_rr group");
>         st->total_weight -= cfqg->weight;
> +       BUG_ON(st->total_weight < 0);
>         if (!RB_EMPTY_NODE(&cfqg->rb_node))
>                 cfq_rb_erase(&cfqg->rb_node, st);
>         cfqg->saved_workload_slice = 0;
> 

Thanks for catching this issue Justin. So basically we added a group to
service tree with weight X and then later I update the weight to X+10
and then if it is deleted from service tree, it can very well lead to
negative weights and all sort of problems.

There is a one comment in the patch inline.

Thanks
Vivek
 
> The "fuzzcon" tool adjusts the weight for a task in a manner that 
> triggers this bug:
> http://google3-2.osuosl.org/?p=tests/blkcgroup.git;a=blob;f=scripts/fuzzcon;h=38cfb9e0c847eb92ceccbac67de2a59b43f241ba;hb=eae5e71ad1116b46a9fd84f5d1b1e4c45aa6bd58
> 
> 
> Here's the BUG_ON output when the case is encountered:
>  [ 1711.376954] ------------[ cut here ]------------
>  [ 1711.377789] kernel BUG at block/cfq-iosched.c:906!
>  [ 1711.377789] invalid opcode: 0000 [#1] SMP·
>  [ 1711.377789] last sysfs file: /sys/devices/system/node/node0/distance
>  [ 1711.377789] CPU 0·
>  [ 1711.377789] Modules linked in: tg3 msr cpuid ipv6 genrtc
>  [ 1711.377789]·
>  [ 1711.377789] Pid: 13702, comm: dd Tainted: G        W 2.6.38-smp-detect
>  [ 1711.377789] RIP: 0010:[<ffffffff81210387>]  [<ffffffff81210387>] cfq_group_service_tree_del+0x5b/0x99
>  [ 1711.377789] RSP: 0018:ffff8800189c1b68  EFLAGS: 00010086
>  [ 1711.377789] RAX: 00000000ffffff9c RBX: ffff880011a6d400 RCX: 000000000000b690
>  [ 1711.377789] RDX: 0000000000000000 RSI: ffff880011a6d400 RDI: 0000000000000000
>  [ 1711.377789] RBP: ffff8800189c1b78 R08: 0000000000000000 R09: 0000000000000001
>  [ 1711.377789] R10: 0000000000000000 R11: 000000000000001b R12: ffff8800065e8000
>  [ 1711.377789] R13: ffff880011a6d528 R14: 000000000000001b R15: 000000000000001b
>  [ 1711.377789] FS:  0000000000000000(0000) GS:ffff880009c00000(0000) knlGS:0000000000000000
>  [ 1711.377789] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
>  [ 1711.377789] CR2: 00000000f74db000 CR3: 0000000001803000 CR4: 00000000000006f0
>  [ 1711.377789] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  [ 1711.377789] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  [ 1711.377789] Process dd (pid: 13702, threadinfo ffff8800189c0000, task ffff8800067dafa0)
>  [ 1711.377789] Stack:
>  [ 1711.377789]  ffff880006596b40 ffff8800065e8000 ffff8800189c1be8 ffffffff81210d2d
>  [ 1711.377789]  ffff8800067dafa0 ffff8800060c0418 ffff8800189c1bc8 ffff8800060c0410
>  [ 1711.377789]  0000000000000082 ffff8800065e8008 ffff8800189c1bc8 ffff880006596b40
>  [ 1711.377789] Call Trace:
>  [ 1711.377789]  [<ffffffff81210d2d>] __cfq_slice_expired+0x3e0/0x45d
>  [ 1711.377789]  [<ffffffff812111c3>] cfq_exit_cfqq+0x22/0x3f
>  [ 1711.377789]  [<ffffffff81211257>] __cfq_exit_single_io_context+0x77/0x84
>  [ 1711.377789]  [<ffffffff812112ab>] cfq_exit_single_io_context+0x47/0x62
>  [ 1711.377789]  [<ffffffff81211264>] ?  cfq_exit_single_io_context+0x0/0x62
>  [ 1711.377789]  [<ffffffff8120fcc1>] call_for_each_cic+0x31/0x3e
>  [ 1711.377789]  [<ffffffff8120fce3>] cfq_exit_io_context+0x15/0x17
>  [ 1711.377789]  [<ffffffff81207211>] exit_io_context+0x5a/0x6d
>  [ 1711.377789]  [<ffffffff810723a2>] do_exit+0x72a/0x756
>  [ 1711.377789]  [<ffffffff81072444>] do_group_exit+0x76/0x9e
>  [ 1711.377789]  [<ffffffff8107fa9f>] get_signal_to_deliver+0x33c/0x35d
>  [ 1711.377789]  [<ffffffff81035f45>] do_signal+0x72/0x699
>  [ 1711.377789]  [<ffffffff8111ad8f>] ? fsnotify_modify+0x62/0x6a
>  [ 1711.377789]  [<ffffffff81036598>] do_notify_resume+0x2c/0x72
>  [ 1711.377789]  [<ffffffff81036d88>] int_signal+0x12/0x17
>  [ 1711.377789] Code: 48 85 ff 74 15 48 8d 96 42 01 00 00 31 c0 48 c7 c6 0d 13 72 81 e8 d2 cd eb ff 41 8b 44 24 1c 2b 43 20 85 c0 41 89 44 24 1c 79 04 <0f> 0b eb fe 48 8b 03 48 83 e0 fc 48 39 c3 74 0d 49 8d 74 24 08·
>  [ 1711.377789] RIP  [<ffffffff81210387>] cfq_group_service_tree_del+0x5b/0x99
>  [ 1711.377789]  RSP <ffff8800189c1b68>
>  [ 1711.377789] ---[ end trace 5e95326ab7063969 ]---
> 
> 
> Justin TerAvest (1):
>   Don't update group weights when on service tree.
> 
>  block/cfq-iosched.c |   57 ++++++++++++++++++++++++++++++++++++++------------
>  1 files changed, 43 insertions(+), 14 deletions(-)
> 
> -- 
> 1.7.3.1
