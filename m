Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2CICp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:45:27 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:48600 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2CICpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:45:25 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: fernando@oss.ntt.co.jp, dzickus@redhat.com,
        linux-tip-commits@vger.kernel.org, torvalds@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, mingo@elte.hu,
        yinghai@kernel.org, akpm@linux-foundation.org, vgoyal@redhat.com
References: <20120221135934.GF26998@redhat.com>
	<m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp>
	<20120309.095902.310070570.d.hatayama@jp.fujitsu.com>
Date: Thu, 08 Mar 2012 18:48:33 -0800
In-Reply-To: <20120309.095902.310070570.d.hatayama@jp.fujitsu.com> (HATAYAMA
	Daisuke's message of "Fri, 09 Mar 2012 09:59:02 +0900 ( )")
Message-ID: <m1r4x2trpa.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18P51rXJqm7mYDSY/sX8SkXNZnnVo7VtQQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: **
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in crash path
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> From: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
> Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in crash path
> Date: Wed, 07 Mar 2012 19:53:16 +0900
>
>> On 03/01/2012 08:19 AM, Eric W. Biederman wrote:
>> 
>>> Don Zickus<dzickus@redhat.com>  writes:
>>>> It probably is, except I never hacked on idt code before and my
>>>> assembly
>>>> isn't that good.  I have been trying to find examples to copy from to
>>>> give
>>>> it a try.  So far I was using early_idt_handlers with early_printk to
>>>> see
>>>> if I could capture some printk messages while jumping from the first
>>>> kernel to the second kernel (when the other early_idt_handlers would
>>>> kick
>>>> in for the second kernel).
>>>>
>>>> Tips?  Better examples?
>>> That is a particularly good example.  When I took a quick look earlier
>>> that is the first place we reload the idt in the kernel boot so that
>>> is
>>> one of two places that needs to be modified.
>> 
>> Hi Eric, Don
>> 
>> Sorry for chiming in so late.
>> 
>> We run into the same NMI problems and wrote some patches that tackle
>> the kernel boot side of things. They have been extensively tested
>> using
>> qemu-kvm and things seem to be working as expected (after receiving an
>> early NMI the kernel continues without problem; after the iret there
>> is no
>> stack corruption or register corruption).
>> 
>> I will be replying to this email with the patches.
>> 
>
> Should the following also be fixed?

Most definitely.  I think Fernando said he was going to tackle that
next.


Eric


> /*
>  * Do not allocate memory (or fail in any way) in machine_kexec().
>  * We are past the point of no return, committed to rebooting now.
>  */
> void machine_kexec(struct kimage *image)
> {
>         unsigned long page_list[PAGES_NR];
>         void *control_page;
>         int save_ftrace_enabled;
> <cut>
>         /*
>          * The gdt & idt are now invalid.
>          * If you want to load them you must set up your own idt & gdt.
>          */
>         set_gdt(phys_to_virt(0), 0);
>         set_idt(phys_to_virt(0), 0);    <--- This
>
> Thanks.
> HATAYAMA, Daisuke
