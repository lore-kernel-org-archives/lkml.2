Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2GVTWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 15:22:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50987 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2GVTWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 15:22:47 -0400
From: Anthony Liguori <anthony@codemonkey.ws>
To: Sasha Levin <levinsasha928@gmail.com>, Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH v7] kvm: notify host when the guest is panicked
In-Reply-To: <500A8969.1040300@gmail.com>
References: <500A565A.8080403@cn.fujitsu.com> <500A8969.1040300@gmail.com>
User-Agent: Notmuch/0.13.2+60~g7ecf77d (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 22 Jul 2012 14:22:42 -0500
Message-ID: <87txwzwqgt.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> On 07/21/2012 09:12 AM, Wen Congyang wrote:
>> +#define KVM_PV_PORT	(0x505UL)
>> +
>>  #ifdef __KERNEL__
>>  #include <asm/processor.h>
>>  
>> @@ -221,6 +223,11 @@ static inline void kvm_disable_steal_time(void)
>>  }
>>  #endif
>>  
>> +static inline unsigned int kvm_arch_pv_features(void)
>> +{
>> +	return inl(KVM_PV_PORT);
>> +}
>> +
>
> Why is this safe?
>
> I'm not sure you can just pick any ioport you'd like and use it.

There are three ways I/O ports get used on a PC:

1) Platform devices
 - This is well defined since the vast majority of platform devices are
   implemented within a single chip.  If you're emulating an i440fx
   chipset, the PIIX4 spec has an exhaustive list.

2) PCI devices
 - Typically, PCI only allocates ports starting at 0x0d00 to avoid
   conflicts with ISA devices.

3) ISA devices
 - ISA uses subtractive decoding so any ISA device can access.  In
   theory, an ISA device could attempt to use port 0x0505 but it's
   unlikely.  In a modern guest, there aren't really any ISA devices being
   added either.

So yes, picking port 0x0505 is safe for something like this (as long as
you check to make sure that you really are under KVM).

Regards,

Anthony Liguori

> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
