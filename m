Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab2CIA70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:59:26 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41907 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab2CIA7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:59:24 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 09 Mar 2012 09:59:02 +0900 (   )
Message-Id: <20120309.095902.310070570.d.hatayama@jp.fujitsu.com>
To: fernando@oss.ntt.co.jp
Cc: ebiederm@xmission.com, dzickus@redhat.com,
        linux-tip-commits@vger.kernel.org, torvalds@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, mingo@elte.hu,
        yinghai@kernel.org, akpm@linux-foundation.org, vgoyal@redhat.com
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <4F573E1C.2060909@oss.ntt.co.jp>
References: <20120221135934.GF26998@redhat.com>
	<m1ipip6xe8.fsf@fess.ebiederm.org>
	<4F573E1C.2060909@oss.ntt.co.jp>
X-Mailer: Mew version 6.3 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in crash path
Date: Wed, 07 Mar 2012 19:53:16 +0900

> On 03/01/2012 08:19 AM, Eric W. Biederman wrote:
> 
>> Don Zickus<dzickus@redhat.com>  writes:
>>> It probably is, except I never hacked on idt code before and my
>>> assembly
>>> isn't that good.  I have been trying to find examples to copy from to
>>> give
>>> it a try.  So far I was using early_idt_handlers with early_printk to
>>> see
>>> if I could capture some printk messages while jumping from the first
>>> kernel to the second kernel (when the other early_idt_handlers would
>>> kick
>>> in for the second kernel).
>>>
>>> Tips?  Better examples?
>> That is a particularly good example.  When I took a quick look earlier
>> that is the first place we reload the idt in the kernel boot so that
>> is
>> one of two places that needs to be modified.
> 
> Hi Eric, Don
> 
> Sorry for chiming in so late.
> 
> We run into the same NMI problems and wrote some patches that tackle
> the kernel boot side of things. They have been extensively tested
> using
> qemu-kvm and things seem to be working as expected (after receiving an
> early NMI the kernel continues without problem; after the iret there
> is no
> stack corruption or register corruption).
> 
> I will be replying to this email with the patches.
> 

Should the following also be fixed?

/*
 * Do not allocate memory (or fail in any way) in machine_kexec().
 * We are past the point of no return, committed to rebooting now.
 */
void machine_kexec(struct kimage *image)
{
        unsigned long page_list[PAGES_NR];
        void *control_page;
        int save_ftrace_enabled;
<cut>
        /*
         * The gdt & idt are now invalid.
         * If you want to load them you must set up your own idt & gdt.
         */
        set_gdt(phys_to_virt(0), 0);
        set_idt(phys_to_virt(0), 0);    <--- This

Thanks.
HATAYAMA, Daisuke

