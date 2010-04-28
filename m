Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab0D1Ry4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:54:56 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34034 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab0D1Ryy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:54:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KGVB+MHgsOALnlGOw0r5AQ5f99NMlgb72t6h5Z22XH3cMDYvQh/3tbY5bjJYWi2E+i
         Ch0gNhSL2P7xZ9UW8x9VSe840xD7Nny/XG8TDBu6GrYjxcEoA+OW1K2+dG+b2/FPX0aF
         fcclF7O4XRZoGChZWs++WWD4T4WHeFd7ZNl24=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004281833230.2951@localhost.localdomain>
References: <l2ye6bf505b1004271144ta6817962vec8167d813658648@mail.gmail.com>
	 <alpine.LFD.2.00.1004272053130.2951@localhost.localdomain>
	 <1272399798.2255.2.camel@localhost>
	 <1272400246.2255.5.camel@localhost>
	 <s2me6bf505b1004271354v128e0e89q6b506ce99af6d7fd@mail.gmail.com>
	 <1272434481.1974.101.camel@work-vm>
	 <w2ge6bf505b1004280821g70610cb7lc3821ee890345273@mail.gmail.com>
	 <alpine.LFD.2.00.1004281833230.2951@localhost.localdomain>
Date: Wed, 28 Apr 2010 12:54:49 -0500
Message-ID: <y2ge6bf505b1004281054kfc44529fkf87dc5e9d564f9b3@mail.gmail.com>
Subject: Re: 2.6.33.3-rt16 Oops caused by umount
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 11:34 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 28 Apr 2010, Xianghua Xiao wrote:
>> Just tried the patch, still got umount hang, please see below.
>
> Can you please apply the patch below and provide the debug output ?
>
> Thanks,
>
>        tglx
> ---
>  fs/file_table.c |   22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
>
> Index: linux-2.6-tip/fs/file_table.c
> ===================================================================
> --- linux-2.6-tip.orig/fs/file_table.c
> +++ linux-2.6-tip/fs/file_table.c
> @@ -410,7 +410,27 @@ int fs_may_remount_ro(struct super_block
>                list = &sb->s_files;
>  #endif
>                list_for_each_entry(file, list, f_u.fu_list) {
> -                       struct inode *inode = file->f_path.dentry->d_inode;
> +                       struct inode *inode;
> +
> +                       if (!file->f_path) {
> +                               printk(KERN_ERR "file %p fpath == NULL\n",
> +                                      file);
> +                               continue;
> +                       }
> +
> +                       if (!file->f_path.dentry) {
> +                               printk(KERN_ERR "file %p dentry == NULL\n",
> +                                      file);
> +                               continue;
> +                       }
> +
> +                       if (!file->f_path.dentry->d_inode) {
> +                               printk(KERN_ERR "file %p d_inode == NULL\n",
> +                                      file);
> +                               continue;
> +                       }
> +
> +                       inode = file->f_path.dentry->d_inode;
>
>                        /* File with pending delete? */
>                        if (inode->i_nlink == 0)
>
Thomas,
I patched it and re-run it however did not find any condition from
your patch had a hit.
In your patch I changed :

if (!file->f_path) {
to
if(!(&(file->f_path))){
Otherwise it won't compile as f_path is a not a pointer.

Thanks,
Xianghua

# reboot
# Oops: Kernel access of bad area, sig: 11 [#1]
PREEMPT 834x SYS
Modules linked in:
NIP: c009d5e0 LR: c009d69c CTR: 00000001
REGS: cde87dd0 TRAP: 0300   Not tainted  (2.6.33.3-rt16)
MSR: 00009032 <EE,ME,IR,DR>  CR: 24000424  XER: 20000000
DAR: 2e657490, DSISR: 20000000
TASK = ce99e9f0[1404] 'umount' THREAD: cde86000
GPR00: 00007000 cde87e80 ce99e9f0 00000024 00003da7 ffffffff c0542548 00020000
GPR08: c054292c 2e657468 0001ffff cde12b58 24000422 100bbc1c 0fffd000 ffffffff
GPR16: 00000001 00000000 007fff00 00000000 00000000 0fffa1a0 00000000 cde87ec8
GPR24: 00000021 00000060 c045b5a8 c045b5c4 c050cd6c ce953488 00008000 cde12940
NIP [c009d5e0] fs_may_remount_ro+0x88/0x150
LR [c009d69c] fs_may_remount_ro+0x144/0x150
Call Trace:
[cde87e80] [c009d69c] fs_may_remount_ro+0x144/0x150 (unreliable)
[cde87ea0] [c009e5dc] do_remount_sb+0x138/0x178
[cde87ec0] [c00bd25c] do_mount+0x54c/0x840
[cde87f10] [c00bd620] sys_mount+0xd0/0xfc
[cde87f40] [c0014208] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b88
Instruction dump:
817f0000 2f8b0000 419e0008 7c005a2c 7f9fe800 419e0080 813f000c 2f890000
419e00a8 81290024 2f890000 419e00b4 <80090028> 2f800000 419e0028 a009006e
---[ end trace 3fba518eec56e584 ]---
------------[ cut here ]------------
Kernel BUG at c03ad89c [verbose debug info unavailable]
Oops: Exception in kernel mode, sig: 5 [#2]
PREEMPT 834x SYS
Modules linked in:
NIP: c03ad89c LR: c03ad874 CTR: c0121220
REGS: cde87b00 TRAP: 0700   Tainted: G      D     (2.6.33.3-rt16)
MSR: 00021032 <ME,CE,IR,DR>  CR: 84004428  XER: 00000000
TASK = ce99e9f0[1404] 'umount' THREAD: cde86000
GPR00: 00000001 cde87bb0 ce99e9f0 00000001 000002ac 000002ac 00008000 00000000
GPR08: 00000000 00000000 ce99e9f0 cde86000 24004422 100bbc1c 0fffd000 ffffffff
GPR16: 00000001 00000000 007fff00 00000000 00000000 0fffa1a0 00000000 c050cd74
GPR24: 00000021 cf0231a0 cec19b34 c050cd6c cec1a9a8 00009032 cdf877a0 cdf877a0
NIP [c03ad89c] rt_spin_lock_slowlock+0x84/0x318
LR [c03ad874] rt_spin_lock_slowlock+0x5c/0x318
Call Trace:
[cde87bb0] [c03ad874] rt_spin_lock_slowlock+0x5c/0x318 (unreliable)
[cde87c30] [c009d3a8] file_sb_list_del+0x34/0x6c
[cde87c50] [c009db38] __fput+0x154/0x254
[cde87c80] [c0084bfc] remove_vma+0x64/0xd0
[cde87c90] [c0084dd0] exit_mmap+0x168/0x1c4
[cde87cf0] [c0022fd8] mmput+0x70/0x138
[cde87d10] [c0027c8c] exit_mm+0x148/0x170
[cde87d40] [c0029e88] do_exit+0x508/0x614
[cde87d90] [c0011ce0] die+0x19c/0x1a4
[cde87db0] [c001822c] bad_page_fault+0x98/0xd0
[cde87dc0] [c00146a8] handle_page_fault+0x7c/0x80
--- Exception: 300 at fs_may_remount_ro+0x88/0x150
    LR = fs_may_remount_ro+0x144/0x150
[cde87ea0] [c009e5dc] do_remount_sb+0x138/0x178
[cde87ec0] [c00bd25c] do_mount+0x54c/0x840
[cde87f10] [c00bd620] sys_mount+0xd0/0xfc
[cde87f40] [c0014208] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b88
Instruction dump:
38600001 4bc71179 801b0004 3afb0008 2f800000 419e0270 801b0010 7c4a1378
5400003a 7c400278 7c000034 5400d97e <0f000000> 83c20000 39200002 2f9e0002
---[ end trace 3fba518eec56e585 ]---
Fixing recursive fault but reboot is needed!
BUG: scheduling while atomic: umount/0x00000001/1404, CPU#0
Modules linked in:
Call Trace:
[cde87900] [c0009d14] show_stack+0x70/0x1b8 (unreliable)
[cde87940] [c001e8cc] __schedule_bug+0x90/0x94
[cde87960] [c03ac0f8] __schedule+0x2ac/0x390
[cde87980] [c03ac380] schedule+0x28/0x54
[cde87990] [c0029e00] do_exit+0x480/0x614
[cde879e0] [c0011ce0] die+0x19c/0x1a4
[cde87a00] [c0011f64] _exception+0x138/0x16c
[cde87af0] [c0014854] ret_from_except_full+0x0/0x4c
--- Exception: 700 at rt_spin_lock_slowlock+0x84/0x318
    LR = rt_spin_lock_slowlock+0x5c/0x318
[cde87c30] [c009d3a8] file_sb_list_del+0x34/0x6c
[cde87c50] [c009db38] __fput+0x154/0x254
[cde87c80] [c0084bfc] remove_vma+0x64/0xd0
[cde87c90] [c0084dd0] exit_mmap+0x168/0x1c4
[cde87cf0] [c0022fd8] mmput+0x70/0x138
[cde87d10] [c0027c8c] exit_mm+0x148/0x170
[cde87d40] [c0029e88] do_exit+0x508/0x614
[cde87d90] [c0011ce0] die+0x19c/0x1a4
[cde87db0] [c001822c] bad_page_fault+0x98/0xd0
[cde87dc0] [c00146a8] handle_page_fault+0x7c/0x80
--- Exception: 300 at fs_may_remount_ro+0x88/0x150
    LR = fs_may_remount_ro+0x144/0x150
[cde87ea0] [c009e5dc] do_remount_sb+0x138/0x178
[cde87ec0] [c00bd25c] do_mount+0x54c/0x840
[cde87f10] [c00bd620] sys_mount+0xd0/0xfc
[cde87f40] [c0014208] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe5f8c4
    LR = 0x10051b88
