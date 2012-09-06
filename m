Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab2IFPQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:16:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab2IFPQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:16:20 -0400
Date: Thu, 6 Sep 2012 11:16:16 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Subject: Re: 3.6-rc4 audit_log_d_path oops.
Message-ID: <20120906151616.GB23345@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Kees Cook <keescook@chromium.org>
References: <20120906134628.GA8962@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120906134628.GA8962@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 09:46:28AM -0400, Dave Jones wrote:
 > Hit this in overnight fuzz testing..
 > 
 > BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
 > IP: [<ffffffff81103365>] audit_log_d_path+0x35/0xf0
 > PGD 12fded067 PUD 142c06067 PMD 0 
 > Oops: 0000 [#1] SMP 
 > Modules linked in: tun fuse ipt_ULOG binfmt_misc nfnetlink nfc caif_socket caif phonet can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key decnet rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 lockd sunrpc bluetooth rfkill ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr i2c_i801 e1000e uinput i915 video i2c_algo_bit drm_kms_helper drm i2c_core
 > CPU 5 
 > Pid: 7007, comm: trinity-child5 Not tainted 3.6.0-rc4+ #36
 > RIP: 0010:[<ffffffff81103365>]  [<ffffffff81103365>] audit_log_d_path+0x35/0xf0
 > RSP: 0018:ffff880116b33ec8  EFLAGS: 00010246
 > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000035
 > RDX: ffffffff819dbf5d RSI: ffffffff819da5bb RDI: 0000000000000000
 > RBP: ffff880116b33ee8 R08: ffff88001942533e R09: 0000000000000000
 > R10: 0000000000000001 R11: 0000000000000000 R12: ffff880116b33f38
 > R13: ffff880116b33f38 R14: ffffffff819fa1eb R15: 0000000000000005
 > FS:  00007f5742581740(0000) GS:ffff880148600000(0000) knlGS:0000000000000000
 > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 > CR2: 0000000000000020 CR3: 00000001046d3000 CR4: 00000000001407e0
 > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 > Process trinity-child5 (pid: 7007, threadinfo ffff880116b32000, task ffff880019424d00)
 > Stack:
 >  ffff880116b33ee8 0000000000000000 ffff880116b33f38 ffff880019424d00
 >  ffff880116b33f18 ffffffff81103522 00000000000001d0 ffff880119ed6500
 >  00000000000001d0 0000000000000109 ffff880116b33f78 ffffffff811ebb95
 > Call Trace:
 >  [<ffffffff81103522>] audit_log_link_denied+0x92/0x100
 >  [<ffffffff811ebb95>] sys_linkat+0x195/0x1e0
 >  [<ffffffff813573de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 >  [<ffffffff816a50ed>] system_call_fastpath+0x1a/0x1f
 > Code: 5d e8 4c 89 65 f0 4c 89 6d f8 0f 1f 44 00 00 48 85 f6 48 89 fb 49 89 d5 74 11 48 89 f2 31 c0 48 c7 c6 bb a5 9d 81 e8 8b e1 ff ff <8b> 73 20 40 f6 c6 01 75 62 48 8b 3d 33 33 93 01 48 85 ff 74 4e 
 > RIP  [<ffffffff81103365>] audit_log_d_path+0x35/0xf0
 >  RSP <ffff880116b33ec8>
 > CR2: 0000000000000020
 > ---[ end trace 85b88c850143bb1c ]---
 > 
 > That's here in kernel/audit.c
 > 
 > 1433 
 > 1434         /* We will allow 11 spaces for ' (deleted)' to be appended */
 > 1435         pathname = kmalloc(PATH_MAX+11, ab->gfp_mask);
 > 
 > 'ab' is NULL.
 > 
 > Looks like audit_log_link_denied needs to handle potential failure from
 > audit_log_start and abort early. (oddly, it looks like every other
 > function called there checks for !ab.)
 > 
 > Maybe additional code should be added here to printk the audit message
 > to dmesg so that we don't lose it entirely, but for now, minimal fix.
 > 
 > Signed-off-by: Dave Jones <davej@redhat.com>
 > 
 > diff --git a/kernel/audit.c b/kernel/audit.c
 > index ea3b7b6..c3e85bb 100644
 > --- a/kernel/audit.c
 > +++ b/kernel/audit.c
 > @@ -1466,6 +1466,9 @@ void audit_log_link_denied(const char *operation, struct path *link)
 >  
 >  	ab = audit_log_start(current->audit_context, GFP_KERNEL,
 >  			     AUDIT_ANOM_LINK);
 > +	if (!ab)
 > +		return;
 > +
 >  	audit_log_format(ab, "op=%s action=denied", operation);
 >  	audit_log_format(ab, " pid=%d comm=", current->pid);
 >  	audit_log_untrustedstring(ab, current->comm);

Added Kees, as this was introduced in a51d9eaa41866ab6b4b6ecad7b621f8b66ece0dc

I just realised, the funny thing about this is that the machine running that test
had selinux/audit disabled. And yet here we are, screwing around with audit buffers.

Should there be a test on audit_enable=0 in audit_log_link_denied() ?

I'm now curious how much more of the audit code is getting run through similar lack of tests

	Dave

