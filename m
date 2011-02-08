Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1BHRfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:35:23 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57313 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab1BHRfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:35:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
References: <20110131225939.GH11974@redhat.com>
	<20110203094715.939C.A69D9226@jp.fujitsu.com>
	<20110203020528.GA21603@redhat.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2C147F4346@USINDEVS01.corp.hds.com>
	<m14o8klt3w.fsf@fess.ebiederm.org>
	<5C4C569E8A4B9B42A84A977CF070A35B2C147F43B7@USINDEVS01.corp.hds.com>
	<20110208164656.GA29081@redhat.com>
Date: Tue, 08 Feb 2011 09:35:15 -0800
In-Reply-To: <20110208164656.GA29081@redhat.com> (Vivek Goyal's message of
	"Tue, 8 Feb 2011 11:46:56 -0500")
Message-ID: <m1ei7i8m5o.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18OkfNGZlWyZkjg4Cw/bvfL4MH2L8k5BBs=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Query about kdump_msg hook into crash_kexec()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Feb 03, 2011 at 05:08:01PM -0500, Seiji Aguchi wrote:
>> Hi Eric,
>> 
>> Thank you for your prompt reply.
>> 
>> I would like to consider "Needs in enterprise area" and "Implementation of kmsg_dump()" separately.
>> 
>> (1) Needs in enterprise area
>>   In case of kdump failure, we would like to store kernel buffer to NVRAM/flush memory
>>   for detecting root cause of kernel crash.
>> 
>> (2) Implementation of kmsg_dump 
>>   You suggest to review/test cording of kmsg_dump() more.
>> 
>> What do you think about (1)?
>> Is it acceptable for you?
>
> Ok, I am just trying to think loud about this problem and see if something
> fruitful comes out which paves the way forward.
>
> - So ideally we would like kdump_msg() to be called after crash_kexec() so
>   that any unaudited (third party modules), unreliable calls do not 
>   compromise the realiability of kdump operation.
>
>   But hitachi folks seems to be wanting to save atleast kernel buffers
>   somwhere in the NVRAM etc because they think that kdump can be
>   unreliable and we might not capture any information after the crash. So
>   they kind of want two mechanisms in place. One is light weight which
>   tries to save kernel buffers in NVRAM and then one heavy weight one
>   which tries to save the entire/filtered kernel core.
>
>   Personally I am not too excited about the idea but I guess I can live
>   with it. We can try to audit atleast in kernel module and for external
>   modules we don't have much control and live with the fact that if
>   modules screw up, we don't capture the dump.
>
>  Those who don't want this behavior can do three things.
>
> 	- Disable kdump_msg() at compile time.
> 	- Do not load any module which registers for kdump_msg()
> 	- Implement a /proc tunable which allows controlling this
> 	  behavior.
>
> - Ok, having said why do we want it, comes the question of how to  
>   do it so that it works reasonably well.
>
>   - There seems to be on common requirement of kmsg_dump() and kdump()
>     and that is stop other cpus reliably (use nmi if possible). Can
>     we try to share this code between kmsg_dump and crash_kexec(). So
>     something like as follows.
>
> 	- panic happens
> 	- Do all the activities related to printing panic string and
> 	  stack dump.
> 	- Stop other cpus.
> 		- This can be probably be done with the equivalent of
> 		  machine_crash_shutdown() function. In fact this function
> 		  can probably be broken down in two parts. First part
> 	  	  does shutdown_prepare() where all other cpus are shot
> 		  down and second part can do the actual disabling of
> 		  LAPIC/IOAPIC and saving cpu registers etc.
>
> 		if (mutex_trylock(some_shutdown_mutex)) {
> 			/* setp regs, fix vmcoreinfo etc */
> 			crash_kexec_prepare();
> 			machine_shutdown_prepare();
> 			kdump_msg();	
> 			crash_kexec_execute()
> 			/* Also call panic_notifier_list here ? */
> 		}
>
> crash_kexec_prepare () {
> 		crash_setup_regs(&fixed_regs, regs);
> 		crash_save_vmcoreinfo();
> }
>
> crash_kexec_execute() {
> 			/* Shutdown lapic/ioapic, save this cpu register etc */
> 			machine_shutdown();
> 			machine_kexec()
> }
>
> So basically we break down machine_shutdown() function in two parts
> and start sharing common part between kdump_msg(), crash_kexec and
> possibly panic_notifiers. 
>
> If kdump is not configured, then after executing kdump_msg() and panic
> notifiers, we should either be sitting in tight loop with interrupt
> enabled for somebody to press Ctrl-boot or reboot system upon lapse
> of panic_timeout().
>
> Eric, does it make sense to you?

kexec on panic doesn't strictly require that we stop other cpus.

What makes sense to me at this point is for someone on the kmsg_dump
side to make a strong case that the code actually works in a crash dump
scenario.  We have lots of experience over the years that says a design
like kmsg_dump is attractive but turns out to be a unreliable piece of
junk that fails just when you need it.  Because developers only test
the case when the kernel is happy and because people share code with
the regular path drivers, and that code assumes things are happy.

I forget exactly why but last I looked.
local_irq_disable()
kmsg_dump()
local_irq_enalbe()

Was a recipe for disaster, and you have be at least that good to even
have a chance of working in a crash dump scenario.

In part I am puzzled why the kmsg dump doesn't just use the printk
interface.  Strangely enough printk works in the event of a crash and
has been shown to be reliable over the years.

Eric
