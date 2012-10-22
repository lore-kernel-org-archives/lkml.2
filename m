Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2JVUbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:31:37 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38770 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142Ab2JVUbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:31:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, x86@kernel.org, mingo@elte.hu,
        tglx@linutronix.de, len.brown@intel.com, fenghua.yu@intel.com,
        vgoyal@redhat.com, grant.likely@secretlab.ca, rob.herring@calxeda.com
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
	<20121016043528.20003.601.stgit@localhost6.localdomain6>
	<873916i88t.fsf@xmission.com> <5085A9A8.5020004@zytor.com>
Date: Mon, 22 Oct 2012 13:31:27 -0700
In-Reply-To: <5085A9A8.5020004@zytor.com> (H. Peter Anvin's message of "Mon,
	22 Oct 2012 13:16:40 -0700")
Message-ID: <87fw56fduo.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX196Wnmfq8PIaQc8AVMdC7kVoyrKn95jZ6Q=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 10/22/2012 01:04 PM, Eric W. Biederman wrote:
>> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
>> 
>>> We disable BSP if boot cpu is AP.
>>>
>>> INIT-INIT-SIPI sequence, a protocal to initiate AP, cannot be used for
>>> BSP since it causes BSP jump to BIOS init code; typical visible
>>> behaviour is hang or immediate reset, depending on the BIOS init code.
>>>
>>> INIT can be used to reset AP in a fatal system error state as
>>> described in MP spec 3.7.3 Processor-specific INIT. In contrast, there
>>> is no processor-specific INIT for BSP to initilize from a fatal system
>>> error. It might be possible to do so by NMI plus any hand-crafted
>>> reset code that is carefully designed, but at least I have no idea in
>>> this direction now.
>> 
>> Has anyone looked at clearing bit 8 of the IA32_APIC_BASE_MSR (0x1B) on
>> the bootstrap processor?  Bit 8 being the bit that indicates we are a
>> bootstrap processor.
>> 
>> If we can clear that bit INIT will always place the processor in
>> wait-for-startup-ipi mode and we won't have this problem.
>> 
>> That would also solve the hotunplug the bootstrap processor without
>> using an NMI as well.
>> 
>
> IIRC Fenghua experimented with that and it didn't work.  Not all BIOSes
> use that bit to determine BSP-ness.

What does a BIOS have to do with anything?

The practical issue here is does an INIT IPI cause the cpu to go into
startup-ipi-wait or to start booting at 4G-16 bytes.

For dealing with BIOSen we may still need to use the bootstrap processor
for firmware calls, cpu suspend, and other firmware weirdness, but that
should all be completely orthogonal to the behavior to what happens
when an INIT IPI is sent to the cpu.

The only firmware problem I can imagine having is cpu virtualization
bug.

Eric
