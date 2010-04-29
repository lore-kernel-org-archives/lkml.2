Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab0D3Su7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:50:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab0D3RNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:13:06 -0400
Message-ID: <4BD9F1FE.8010708@zytor.com>
Date: Thu, 29 Apr 2010 13:54:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: linux-kernel@vger.kernel.org, Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: 2.6.34-rc5-git10: oops on Atom N270/ i945GSE upon shutdown with
 X86_MRST && APB_TIMER enabled
References: <201004292143.29507.s.L-H@gmx.de>
In-Reply-To: <201004292143.29507.s.L-H@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you apply this patch and verify that it solves your problem:

http://git.kernel.org/tip/ae7c9b70dcb4313ea3dbcc9a2f240dae6c2b50c0

	-hpa

On 04/29/2010 12:43 PM, Stefan Lippers-Hollmann wrote:
> Hi
> 
> While testing kernel 2.6.34-rc5-git10 on an Acer Aspire One 110L netbook 
> (Atom N270, i945GSE chipset, hyperthreading enabled and not configurable, 
> BIOS 3309), I reproducably encounter the following oops while shutting down
> (manual transcription below):
> 
> Pid: 2253, comm: halt Not Tainted 2.6.34-rc5-sidux-686 #1        /AOA110
> EIP: 0060:[<c0121232>] EFLAGS: 00010202 CPU: 0
> EIP is at apbt_cpuhp_notify+0x32/0x60
> EAX: c0562e80 EBX: 01ca0000 ECX: 0000001c EDX: 0000001c
> ESI: 00000000 EDI: 00000000 EBP: ffffffdd ESP: f64cfe0c
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process halt (pid: 2253, ti=f64ce000 task=f69d9140 task.ti=f64ce000)
> Stack:
>  c0501740 c01515d4 00000017 00000001 00000010 00000001 00000000 c0502584
>  <0> c0151687 ffffffff 00000000 c03e0dc9 ffffffff f64cfe60 f6802880 00000003
>  <0> 00000002 c0149055 00000010 00000001 00000003 00000023 00000000 c0502584
> Call Trace:
>  [<c01515d4>] ? notifier_call_chain+0x44/0x60
>  [<c0151687>] ? raw_notifier_call_chain+0x17/0x20
>  [<c03e0dc9>] ? _cpu_down+0x109/0x290
>  [<c0149055>] ? __create_workqueue_key+0x175/0x190
>  [<c0138f2f>] ? disable_nonboot_cpus+0x8f/0x100
>  [<c01513eb>] ? up+0xb/0x40
>  [<c014791d>] ? kernel_power_off+0x1d/0x40
>  [<c0147bcc>] ? sys_reboot+0xfc/0x1f0
>  [<c01442d6>] ? send_signal+0x36/0x70
>  [<c03efd3f>] ? preempt_schedule+0x2f/0x50
>  [<c0144370>] ? do_send_sig_info+0x60/0x80
>  [<c0144666>] ? group_send_sig_info+0x46/0x60
>  [<c0182e16>] ? __rcu_read_unlock+0x1c6/0x1d0
>  [<c0144901>] ? sys_kill+0x91/0x180
>  [<c01d7e44>] ? dput+0x84/0x120
>  [<c01de1f5>] ? mntput_no_expire+0x15/0xd0
>  [<c01c55c7>] ? filp_close+0x47/0x80
>  [<c01c566c>] ? sys_close+0x6d/0xc0
>  [<c0103758>] ? sysenter_do_call+0x12/0x28
> Code: c0 83 fa 07 53 8b 1c 8d 00 24 50 c0 74 0b b8 01 00 00 00 5b c3 8d 74 26 00 8d 14 89 8b 0d ec 86 57 c0 8d 14 95 08 00 00 00 01 d1 <8b> 09 83 c9 04 03 15 ec 86 57 c0 89 0a 83 3d 84 1f 50 c0 01 74
> EIP: [<c0121232>] apbt_cpuhp_notify+0x32/0x60 SS:ESP 0068:f64cfe0c
> CR2: 000000000000001c
> ---[ end trace 7b640dfe756fbef1 ]---
> 
> I don't encounter this problem on 2.6.26-2.6.33(-stable), which didn't 
> have Moorestown/ ABP_Timer support of course, and disabling X86_MRST (and 
> subsequently APB_TIMER) avoids the problem as well; it does not happen
> while rebooting, but only during a full system halt. With X86_MRST && 
> APB_TIMER disabled, everything seems to work fine.
> 
> Tested on an up to date Debian unstable system:
> ii  gcc-4.4   4.4.3-9   The GNU C compiler
> ii  binutils  2.20.1-7  The GNU assembler, linker and binary utilities
> 
> While I can test any potential patches, debugging is a little limited 
> without serial access to the netbook and because a netconsole doesn't work 
> at that shutdown stage anymore.
> 
> Regards
> 	Stefan Lippers-Hollmann


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

