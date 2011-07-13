Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab1GMIhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 04:37:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48355 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab1GMIhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 04:37:13 -0400
MIME-Version: 1.0
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
Date: Wed, 13 Jul 2011 16:37:12 +0800
Message-ID: <CAM_iQpX3WhSus-8=igB_Bev5BkqnRfxEuAU2yzAQHfqcJPkNvw@mail.gmail.com>
Subject: Re: [RFC][PATCH] Replace a function call chain of kmsg_dump(KMSG_DUMP_KEXEC)
 with static function calls
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matthew Garrett <mjg@redhat.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/11 Seiji Aguchi <seiji.aguchi@hds.com>:
> Hi,
>

Hi,

>
> [Patch Description]
>
>  For meeting Eric/Vivek's requirements and solving issues of pstore/efivars driver,  I propose a following patch.
>
>    - Remove kmsg_dump(KMSG_DUMP_KEXEC) from crash_kexec()

It is already removed in -mm, can you rebase your patch against -mm?

>    - Add kmsg_dump_kexec() to crash_kexec()
>        kmsg_dump_kexec() moved behind machine_crash_shutdown() so that
>        we can output kernel messages without getting any locks.
>
>    - Introduce CONFIG_KMSG_DUMP_KEXEC
>        - CONFIG_KMSG_DUMP_KEXEC depends on CONFIG_PRINTK which is required for kmsg_dumper.
>
>        - CONFIG_KMSG_DUMP_KEXEC=n (default)
>          Kernel message logging feature doesn't work in kdump path.
>
>        - CONFIG_KMSG_DUMP_KEXEC=y
>          following static functions are called in kdump path.
>          - kmsg_dump_kexec(): This is based on kmsg_dump() and just removed spinlock and a function call chain from it.
>          - do_kmsg_dump_kexec(): This is based on pstore_dump() and just removed mutex lock from it.
>
>        Some people who are not familiar with kexec may add function calls getting spin_lock/mutex_lock in kexec path.
>        These function calls causes failure of kexec.
>        So, I suggest replace a call chain with static function calls so that we can keep reliability of kexec.
>
>     - Add efi_kmsg_dump_kexec() which outputs kernel messages into NVRAM with EFI.
>       This is called by do_kmsg_dump_kexec() statically.
>       By applying to Matthew Garret's patch below, its kernel messages in NVRAM are visible through /dev/pstore.

This looks weird, kmsg_dump_kexec() calls do_kmsg_dump_kexec()
which then calls efi_kmsg_dump_kexec(), so, why not just call
efi_kmsg_dump_kexec()?
since there is no other user of kmsg_dump_kexec().

>From the name CONFIG_KMSG_DUMP_KEXEC, you seem to provide a generic method,
but actually only efi_kmsg_dump_kexec() is and can be called.

Thanks.
