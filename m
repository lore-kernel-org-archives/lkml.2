Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1K1Od3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:33:29 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:56538 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1K1Od2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:33:28 -0500
Message-ID: <1322490804.2292.34.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: NULL pointer dereference in mainline and next
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: mmaruseac@ixiacom.com, davem@davemloft.net, linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 15:33:24 +0100
In-Reply-To: <20111128141846.GA2911@mudshark.cambridge.arm.com>
References: <20111128141846.GA2911@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 28 novembre 2011 à 14:18 +0000, Will Deacon a écrit :
> Hello,
> 
> Commit f04565dd ("dev: use name hash for dev_seq_ops") requires a struct
> dev_iter_state to be allocated for the seq_file->private member, as that is
> used to implement the name hash.
> 
> Unfortunately, the dev_mcast code wasn't updated and so only allocates space
> for a seq_net_private, leading to the following NULL dereference (removed
> static inline annotations to get sane backtrace):
> 
> 
> root@dancing-fool:~# cat /proc/self/net/dev_mcast
> [   40.012390] Unable to handle kernel NULL pointer dereference at virtual address 00000013
> [   40.036763] pgd = eed08000
> [   40.044888] [00000013] *pgd=9f8a6831
> [   40.055109] Internal error: Oops: 17 [#1] PREEMPT SMP
> [   40.055122] Modules linked in:
> [   40.055143] CPU: 0    Tainted: G        W     (3.2.0-rc3+ #9)
> [   40.055177] PC is at dev_from_new_bucket+0xc/0x38
> [   40.055205] LR is at seq_read+0x44c/0x4a0
> [   40.055224] pc : [<c0255f4c>]    lr : [<c00d9d80>]    psr: 600f0013
> [   40.055233] sp : eecc5ed8  ip : 00000f01  fp : 00008000
> [   40.055248] r10: eecc5f08  r9 : eecc5f80  r8 : 00000000
> [   40.055263] r7 : ef1cc780  r6 : 00000010  r5 : ef0c9000  r4 : 00000000
> [   40.055280] r3 : c0255f78  r2 : eecc5f08  r1 : 00000001  r0 : ef0c9000
> [   40.055299] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> [   40.055317] Control: 10c5387d  Table: 8ed0804a  DAC: 00000015
> [   40.055334] Process cat (pid: 3101, stack limit = 0xeecc42f8)
> [   40.055349] Stack: (0xeecc5ed8 to 0xeecc6000)
> [   40.055366] 5ec0:                                                       00000000 00000001
> [   40.055393] 5ee0: ef0c9000 c00d9d80 00001ed3 01ed1000 ef0c9028 00000000 00000007 c04022bc
> [   40.055418] 5f00: 00002260 01ed0da8 00000001 00000000 01efa000 ef8be800 ef1cc780 c00d9934
> [   40.055443] 5f20: eecc5f80 00008000 eecc4000 01ed1000 00000000 c00ffaa0 eecc5f80 ef1cc780
> [   40.055468] 5f40: 00008000 01ed1000 eecc5f80 eecc4000 00000000 c00bc674 01efa000 c01b4f8c
> [   40.055493] 5f60: ef1753c0 00000000 00000000 ef1cc780 01ed1000 00008000 00000000 c00bc784
> [   40.055517] 5f80: 00000000 00000000 00009008 00000000 00008000 01ed1000 00000003 00000003
> [   40.055543] 5fa0: c000e2c4 c000e140 00008000 01ed1000 00000003 01ed1000 00008000 01ed1000
> [   40.055567] 5fc0: 00008000 01ed1000 00000003 00000003 00008000 01ed1000 40099000 00000000
> [   40.055592] 5fe0: 00000000 beb4a65c 0000bc35 40182e1c 400f0010 00000003 6918652a e59c71ee
> [   40.055633] [<c0255f4c>] (dev_from_new_bucket+0xc/0x38) from [<c00d9d80>] (seq_read+0x44c/0x4a0)
> [   40.055670] [<c00d9d80>] (seq_read+0x44c/0x4a0) from [<c00ffaa0>] (proc_reg_read+0x70/0x94)
> [   40.055703] [<c00ffaa0>] (proc_reg_read+0x70/0x94) from [<c00bc674>] (vfs_read+0xb0/0x180)
> [   40.055731] [<c00bc674>] (vfs_read+0xb0/0x180) from [<c00bc784>] (sys_read+0x40/0x70)
> [   40.055771] [<c00bc784>] (sys_read+0x40/0x70) from [<c000e140>] (ret_fast_syscall+0x0/0x30)
> [   40.055799] Code: eafffff8 e92d4070 e1a05000 e5906048 (e5d64003)
> [   40.055818] ---[ end trace 1b75b31a2719ed1e ]---
> 
> 
> The following fixes the problem, but it requires moving the guarded declaration
> of dev_iter_state into a header file so you may want to move it or tweak the
> name.
> 
> Cheers,
> 
> Will
> 
> 
> diff --git a/include/linux/seq_file_net.h b/include/linux/seq_file_net.h
> index 32c89bb..3b801cc 100644
> --- a/include/linux/seq_file_net.h
> +++ b/include/linux/seq_file_net.h
> @@ -12,6 +12,13 @@ struct seq_net_private {
>  #endif
>  };
>  
> +#ifdef CONFIG_PROC_FS
> +struct dev_iter_state {
> +       struct seq_net_private p;
> +       unsigned int pos; /* bucket << BUCKET_SPACE + offset */
> +};
> +#endif
> +
>  int seq_open_net(struct inode *, struct file *,
>                  const struct seq_operations *, int);
>  int single_open_net(struct inode *, struct file *file,
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 6ba50a1..183f18e 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4096,11 +4096,6 @@ static int dev_ifconf(struct net *net, char __user *arg)
>  
>  #define BUCKET_SPACE (32 - NETDEV_HASHBITS)
>  
> -struct dev_iter_state {
> -       struct seq_net_private p;
> -       unsigned int pos; /* bucket << BUCKET_SPACE + offset */
> -};
> -
>  #define get_bucket(x) ((x) >> BUCKET_SPACE)
>  #define get_offset(x) ((x) & ((1 << BUCKET_SPACE) - 1))
>  #define set_bucket_offset(b, o) ((b) << BUCKET_SPACE | (o))
> diff --git a/net/core/dev_addr_lists.c b/net/core/dev_addr_lists.c
> index 277faef..48bf655 100644
> --- a/net/core/dev_addr_lists.c
> +++ b/net/core/dev_addr_lists.c
> @@ -697,7 +697,7 @@ static const struct seq_operations dev_mc_seq_ops = {
>  static int dev_mc_seq_open(struct inode *inode, struct file *file)
>  {
>         return seq_open_net(inode, file, &dev_mc_seq_ops,
> -                           sizeof(struct seq_net_private));
> +                           sizeof(struct dev_iter_state));
>  }
>  
>  static const struct file_operations dev_mc_seq_fops = {
> 


Hello

Anton Blanchard already provided a fix for this problem.

http://patchwork.ozlabs.org/patch/127931/



