Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab1GKWHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 18:07:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab1GKWHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 18:07:32 -0400
Date: Mon, 11 Jul 2011 18:07:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        Matthew Garrett <mjg@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] Replace a function call chain of
 kmsg_dump(KMSG_DUMP_KEXEC) with static function calls
Message-ID: <20110711220709.GG30674@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 11:47:17AM -0400, Seiji Aguchi wrote:
> Hi,
> 
> [Background]
>  - Requirement in enterprise area
>  From our support service experience, we always need to detect root causes of OS panic.
>  Because customers in enterprise area never forgive us if kdump fails and  we can't detect
>  root causes of panic due to lack of materials for investigation.
> 
>  That is why I would like to add kmsg_dump() in kdump path.
> 
> [Upstream status]
>    Discussion about kmsg_dump() in kdump path: 
>     - Vivek and Eric are worried about reliability of existing kmsg_dump().
>     - Especially, Vivek would like to remove a RCU  function call chain in kdump path
> 　　　 which kernel modules can register their function calls freely. 
> 
>    Development of a feature capturing Oops:
>     - Pstore has already incorporated in upstream kernel.
>  
>     - Matthew Garrett is developing efivars driver, a feature capturing Oops via EFI 
>       through pstore interface. 
> 
>       https://lkml.org/lkml/2011/6/7/437
>       https://lkml.org/lkml/2011/6/7/438
>       https://lkml.org/lkml/2011/6/7/439
>       https://lkml.org/lkml/2011/6/7/440
> 
>     - However, these features may not work in kdump path because
>       there are spin_lock/mutex_lock in pstore_dump()/efi_pstore_write().
> 　　　 These locks may cause dead lock and kdump may fail as well.

I think then right solution is to harden pstore() to be able to called
from crashed kernel context where interrupts will not be working, all
other cpus are not running and one can afford to rely on taking any
locks.

Bypassing that just to make sure case of efi work is not going to help.

> 
> [Build Status]
>   Built this patch on 3.0-rc6 in x86_64.
> 
> [Patch Description]
> 
>  For meeting Eric/Vivek's requirements and solving issues of pstore/efivars driver,  I propose a following patch.
> 
>     - Remove kmsg_dump(KMSG_DUMP_KEXEC) from crash_kexec()
>     - Add kmsg_dump_kexec() to crash_kexec()
>         kmsg_dump_kexec() moved behind machine_crash_shutdown() so that
>         we can output kernel messages without getting any locks.

So you are introducing two variants of kmsg dump now? One is kmsg_dump()
and other is kmsg_dump_kexec()? Why not just get rid of kmsg_dump() for
non panic case and simply always call in crashed kernel case?

> 
>     - Introduce CONFIG_KMSG_DUMP_KEXEC
>         - CONFIG_KMSG_DUMP_KEXEC depends on CONFIG_PRINTK which is required for kmsg_dumper.
> 
>         - CONFIG_KMSG_DUMP_KEXEC=n (default)
>           Kernel message logging feature doesn't work in kdump path.
> 
>         - CONFIG_KMSG_DUMP_KEXEC=y 
>           following static functions are called in kdump path.
>           - kmsg_dump_kexec(): This is based on kmsg_dump() and just removed spinlock and a function call chain from it.
>           - do_kmsg_dump_kexec(): This is based on pstore_dump() and just removed mutex lock from it.
>    
>         Some people who are not familiar with kexec may add function calls getting spin_lock/mutex_lock in kexec path.
>         These function calls causes failure of kexec.
>         So, I suggest replace a call chain with static function calls so that we can keep reliability of kexec.
>  
>      - Add efi_kmsg_dump_kexec() which outputs kernel messages into NVRAM with EFI.
>        This is called by do_kmsg_dump_kexec() statically.
>        By applying to Matthew Garret's patch below, its kernel messages in NVRAM are visible through /dev/pstore.
> 
>         https://lkml.org/lkml/2011/6/7/437
>         https://lkml.org/lkml/2011/6/7/438
>         https://lkml.org/lkml/2011/6/7/439
>         https://lkml.org/lkml/2011/6/7/440
> 

- So with this patch you have removed all other subscribers of kmsg_dump()
  and only calling your case of efi storage (ramoops, mtdoops?)
 
Thanks
Vivek
