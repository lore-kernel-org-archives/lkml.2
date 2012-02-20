Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab2BTFSF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 00:18:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33095 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2BTFSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 00:18:03 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 20 Feb 2012 14:17:33 +0900 (   )
Message-Id: <20120220.141733.294710222.d.hatayama@jp.fujitsu.com>
To: dzickus@redhat.com
Cc: ebiederm@xmission.com, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org,
        kexec@lists.infradead.org, vgoyal@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20120217201842.GP9751@redhat.com>
References: <m1fwe9bpk2.fsf@fess.ebiederm.org>
	<CABOkKT21zhyMwMmbR9WTipk5e=y_qMZ8ByG=njatjKbFLZW+xQ@mail.gmail.com>
	<20120217201842.GP9751@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in crash path
Date: Fri, 17 Feb 2012 15:18:42 -0500

> On Sat, Feb 18, 2012 at 12:49:16AM +0900, HATAYAMA Daisuke wrote:
>> A few days ago I investigted the case where system is reseted due to
>> triple fault caused by the NMI after idt is disabled in
>> machine_kexec. I didn't see the reset when trigering the kdump with
>> NMI since the NMI is masked until next iret instruction executed as
>> described in 6.7.2. Handling Multiple NMIs of Intel Manual Vol.3A.
>> The NMI mask remains untill the first iret execution on the 2nd
>> kernel: just the return path of the first kernel_thread invocation for
>> init process. The exact path is:
> 
> hmm.  So even though the local apic was disabled you still got an NMI?
> That could have been from an external NMI.  I forget how that is wired up,
> if it goes through the IOAPIC to the Local APIC or directly to the NMI pin
> on the cpu.
> 

Please don't confused. I used RHEL kernels based on 2.6.18 and
2.6.32. I didn't use the patch disabling local apic.

>> 
>>   switch_to
>>   -> ret_from_fork
>>      -> int_ret_from_sys_call
>>         -> retint_restore_args
>>            -> irq_return
>> 
>> At that phase idt is already set up and kdump works.
>> 
>> From the discussion I interpret kdump doesn't assume this behaviour,
>> right?
> 
> probably not.
> 

Thanks.

>> 
>> BTW, does anyone know the detail of the NMI mask? I couldn't figure
>> out about it from the Intel spec more than ``certain hardware
>> conditions''... I expect those who look at here are x86 NMI experts.
> 
> I don't understand the question.
> 
> Cheers,
> Don
> 

Fig 10-4 explaining Local APIC Structure says INIT/NMI/SMI are
directly sent to CPU Core, but the later part of this route is not
explained formally anyware. Only the explanation is the sentence in
6.7 Nonmaskable Interrupt (NMI):

  The processor also invokes certain hardware conditions to insure
  that no other interrupts, including NMI interrupts, are received
  until the NMI handler has completed executing.

I'm just wondering if this is explained more formally anyware.

Thanks.
HATAYAMA, Daisuke

