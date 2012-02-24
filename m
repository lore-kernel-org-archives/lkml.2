Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab2BXKj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 05:39:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2BXKjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:39:25 -0500
Date: Fri, 24 Feb 2012 11:39:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Linux 3.3-rc4
In-Reply-To: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1202241112350.22368@twin.jikos.cz>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Feb 2012, Linus Torvalds wrote:

> So it's almost getting to be a habit: yet another -rc release that is
> delayed by a couple of days.

I just got the BUG below (with g45196ce being the topmost commit). 

It happened when trying to start 'gwenview', but I am not able to 
reproduce it again. Adding a few people to CC just in case someone 
immediately sees what might be the problem.

The IP resolves to

#ifdef CONFIG_MMU
static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
{
[ ... snip ... ]
                if (file) {
===> this line          struct inode *inode = file->f_path.dentry->d_inode;
                        struct address_space *mapping = file->f_mapping;

                        get_file(file);
                        if (tmp->vm_flags & VM_DENYWRITE)
                                atomic_dec(&inode->i_writecount);
                        mutex_lock(&mapping->i_mmap_mutex);
                        if (tmp->vm_flags & VM_SHARED)
                                mapping->i_mmap_writable++;
                        flush_dcache_mmap_lock(mapping);
                        /* insert tmp into the share list, just after mpnt */
                        vma_prio_tree_add(tmp, mpnt);
                        flush_dcache_mmap_unlock(mapping);
                        mutex_unlock(&mapping->i_mmap_mutex);
                }


more precisely:

		   [ ... snip ... ]
		   0xffffffff8103a4f9 <+409>:   andq   $0xffffffffffffdfff,0x30(%rbx)
		   0xffffffff8103a501 <+417>:   movq   $0x0,0x20(%rbx)
		   0xffffffff8103a509 <+425>:   movq   $0x0,0x18(%rbx)
		   0xffffffff8103a511 <+433>:   test   %rdx,%rdx
		   0xffffffff8103a514 <+436>:   je     0xffffffff8103a565 <dup_mmap+517>
		   0xffffffff8103a516 <+438>:   mov    0x18(%rdx),%rax
		   0xffffffff8103a51a <+442>:   mov    0x130(%rdx),%r12
===> this line	   0xffffffff8103a521 <+449>:   mov    0x30(%rax),%rax
		   0xffffffff8103a525 <+453>:   lock incq 0x68(%rdx)
		   0xffffffff8103a52a <+458>:   testb  $0x8,0x31(%rbx)
		   [ ... snip ... ]

The machine has gone through several suspend-resume cycles before this 
happened, so it might well also be some memory corruption caused by a 
random driver.



BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
IP: [<ffffffff8103a521>] dup_mmap+0x1c1/0x3b0
PGD 3774f067 PUD 36cf7067 PMD 0 
Oops: 0000 [#1] SMP 
CPU 0 
Modules linked in: af_packet iwlwifi tun iptable_mangle xt_DSCP xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tab
conntrack cpufreq_conservative iptable_filter cpufreq_userspace cpufreq_powersave acpi_cpufreq ip_tables mperf x_tables microcode 
ooth snd_hda_codec_conexant pcspkr iTCO_wdt iTCO_vendor_support i2c_i801 cfg80211 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm sn
l ac snd tpm_tis soundcore tpm tpm_bios battery wmi autofs4 uhci_hcd i915 drm_kms_helper drm i2c_algo_bit ehci_hcd button video us
ermal thermal_sys [last unloaded: iwlwifi]

Pid: 1993, comm: Xorg Not tainted 3.3.0-rc4-00074-g45196ce #1 LENOVO 7470BN2/7470BN2
RIP: 0010:[<ffffffff8103a521>]  [<ffffffff8103a521>] dup_mmap+0x1c1/0x3b0
RSP: 0018:ffff8800780bdd50  EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff880077f25d98 RCX: 0000000000000000
RDX: ffff88003767ed00 RSI: ffff880037b36298 RDI: ffff880077f25d98
RBP: ffff8800780bddb0 R08: ffff880067ded4e0 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800767a5d50
R13: ffff880037b36298 R14: ffff880056d520c0 R15: 0000000000000000
FS:  00007f96b2bd6880(0000) GS:ffff88007c200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000030 CR3: 00000000372a3000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process Xorg (pid: 1993, threadinfo ffff8800780bc000, task ffff880078044040)
Stack:
 ffff880037b7ba80 ffff880037b7bb18 ffff880056d52158 ffff880077f25e48
 ffff880077f25e60 ffff880077f25e88 ffff880077f25e80 ffff880056d520c0
 ffff880037b7ba80 ffff880041afe040 0000000000000000 00007f96b2bd6b50
Call Trace:
 [<ffffffff8103ab5f>] dup_mm+0xbf/0x150
 [<ffffffff8103bb72>] copy_process+0xf82/0xfa0
 [<ffffffff8103bf78>] do_fork+0xb8/0x300
 [<ffffffff8104f94c>] ? do_sigaction+0x13c/0x1e0
 [<ffffffff81164040>] ? fd_install+0x30/0x60
 [<ffffffff812eb3c9>] ? lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff8100af83>] sys_clone+0x23/0x30
 [<ffffffff8157b553>] stub_clone+0x13/0x20
 [<ffffffff8157b1f9>] ? system_call_fastpath+0x16/0x1b
Code: 00 00 00 48 81 63 30 ff df ff ff 48 c7 43 20 00 00 00 00 48 c7 43 18 00 00 00 00 48 85 d2 74 4f 48 8b 42 18 4c 8b a2 30 01 00 00 <48> 8b 40 30 f0 48 ff 42 68 f6 43 31 08 74 07 f0 ff 88 cc 01 00 
RIP  [<ffffffff8103a521>] dup_mmap+0x1c1/0x3b0
 RSP <ffff8800780bdd50>
CR2: 0000000000000030

-- 
Jiri Kosina
SUSE Labs

