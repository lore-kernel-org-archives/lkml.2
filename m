Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2GRJ0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:26:34 -0400
Received: from thoth.sbs.de ([192.35.17.2]:23962 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab2GRJ0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:26:25 -0400
Message-ID: <5006811B.3080908@siemens.com>
Date: Wed, 18 Jul 2012 11:25:47 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 5/7 v6] introduce a new qom device to deal with panicked
 event
References: <4FF6B188.2060607@cn.fujitsu.com> <4FF6B2AC.9010204@cn.fujitsu.com> <4FF6C67E.9060409@siemens.com> <5006175A.8040005@cn.fujitsu.com> <50067FA3.3060107@siemens.com>
In-Reply-To: <50067FA3.3060107@siemens.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-18 11:19, Jan Kiszka wrote:
> On 2012-07-18 03:54, Wen Congyang wrote:
>> At 07/06/2012 07:05 PM, Jan Kiszka Wrote:
>>> On 2012-07-06 11:41, Wen Congyang wrote:
>>>> If the target is x86/x86_64, the guest's kernel will write 0x01 to the
>>>> port KVM_PV_PORT when it is panciked. This patch introduces a new qom
>>>> device kvm_pv_ioport to listen this I/O port, and deal with panicked
>>>> event according to panicked_action's value. The possible actions are:
>>>> 1. emit QEVENT_GUEST_PANICKED only
>>>> 2. emit QEVENT_GUEST_PANICKED and pause the guest
>>>> 3. emit QEVENT_GUEST_PANICKED and poweroff the guest
>>>> 4. emit QEVENT_GUEST_PANICKED and reset the guest
>>>>
>>>> I/O ports does not work for some targets(for example: s390). And you
>>>> can implement another qom device, and include it's code into pv_event.c
>>>> for such target.
>>>>
>>>> Note: if we emit QEVENT_GUEST_PANICKED only, and the management
>>>> application does not receive this event(the management may not
>>>> run when the event is emitted), the management won't know the
>>>> guest is panicked.
>>>>
>>>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>>>> ---
>>>>  hw/kvm/Makefile.objs |    2 +-
>>>>  hw/kvm/pv_event.c    |   73 +++++++++++++++++++++++++++
>>>>  hw/kvm/pv_ioport.c   |  133 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  kvm-stub.c           |    9 +++
>>>>  kvm.h                |    3 +
>>>>  vl.c                 |    4 ++
>>>>  6 files changed, 223 insertions(+), 1 deletions(-)
>>>>  create mode 100644 hw/kvm/pv_event.c
>>>>  create mode 100644 hw/kvm/pv_ioport.c
>>>>
>>>> diff --git a/hw/kvm/Makefile.objs b/hw/kvm/Makefile.objs
>>>> index 226497a..23e3b30 100644
>>>> --- a/hw/kvm/Makefile.objs
>>>> +++ b/hw/kvm/Makefile.objs
>>>> @@ -1 +1 @@
>>>> -obj-$(CONFIG_KVM) += clock.o apic.o i8259.o ioapic.o i8254.o
>>>> +obj-$(CONFIG_KVM) += clock.o apic.o i8259.o ioapic.o i8254.o pv_event.o
>>>> diff --git a/hw/kvm/pv_event.c b/hw/kvm/pv_event.c
>>>> new file mode 100644
>>>> index 0000000..d7ded37
>>>> --- /dev/null
>>>> +++ b/hw/kvm/pv_event.c
>>>> @@ -0,0 +1,73 @@
>>>> +/*
>>>> + * QEMU KVM support, paravirtual event device
>>>> + *
>>>> + * Copyright Fujitsu, Corp. 2012
>>>> + *
>>>> + * Authors:
>>>> + *     Wen Congyang <wency@cn.fujitsu.com>
>>>> + *
>>>> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
>>>> + * See the COPYING file in the top-level directory.
>>>> + *
>>>> + */
>>>> +
>>>> +#include <linux/kvm_para.h>
>>>> +#include <asm/kvm_para.h>
>>>> +#include <qobject.h>
>>>> +#include <qjson.h>
>>>> +#include <monitor.h>
>>>> +#include <sysemu.h>
>>>> +#include <kvm.h>
>>>> +
>>>> +/* Possible values for action parameter. */
>>>> +#define PANICKED_REPORT     1   /* emit QEVENT_GUEST_PANICKED only */
>>>> +#define PANICKED_PAUSE      2   /* emit QEVENT_GUEST_PANICKED and pause VM */
>>>> +#define PANICKED_POWEROFF   3   /* emit QEVENT_GUEST_PANICKED and quit VM */
>>>> +#define PANICKED_RESET      4   /* emit QEVENT_GUEST_PANICKED and reset VM */
>>>> +
>>>> +static int panicked_action = PANICKED_REPORT;
>>>
>>> Avoid global variables please when there are device states. This one is
>>> unneeded anyway (and will generate warnings when build without KVM_PV_PORT).
>>
>> Hmm, do you mean introduce another qom device to store event action?
> 
> I think you should be fine with one device per bus binding, but those
> will consist of a common event layer and just different I/O layers (for
> bus registration and access).

To make this clearer: the I/O layer should embed a common state
structure of the event layer in its device state so that the event layer
can keep things like the action mode there.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux


