Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab2JVUEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:04:36 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:60847 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2JVUEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:04:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, x86@kernel.org,
        mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, vgoyal@redhat.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
References: <20121016043357.20003.5885.stgit@localhost6.localdomain6>
	<20121016043528.20003.601.stgit@localhost6.localdomain6>
Date: Mon, 22 Oct 2012 13:04:18 -0700
In-Reply-To: <20121016043528.20003.601.stgit@localhost6.localdomain6>
	(HATAYAMA Daisuke's message of "Tue, 16 Oct 2012 13:35:28 +0900")
Message-ID: <873916i88t.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+ED+oeyL4fNtfiHuunUlRffugjDnnnkWY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0060]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v1 2/2] x86, apic: Disable BSP if boot cpu is AP
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:

> We disable BSP if boot cpu is AP.
>
> INIT-INIT-SIPI sequence, a protocal to initiate AP, cannot be used for
> BSP since it causes BSP jump to BIOS init code; typical visible
> behaviour is hang or immediate reset, depending on the BIOS init code.
>
> INIT can be used to reset AP in a fatal system error state as
> described in MP spec 3.7.3 Processor-specific INIT. In contrast, there
> is no processor-specific INIT for BSP to initilize from a fatal system
> error. It might be possible to do so by NMI plus any hand-crafted
> reset code that is carefully designed, but at least I have no idea in
> this direction now.

Has anyone looked at clearing bit 8 of the IA32_APIC_BASE_MSR (0x1B) on
the bootstrap processor?  Bit 8 being the bit that indicates we are a
bootstrap processor.

If we can clear that bit INIT will always place the processor in
wait-for-startup-ipi mode and we won't have this problem.

That would also solve the hotunplug the bootstrap processor without
using an NMI as well.



If clearing bit 8 doesn't work and we have to go with a variant of
magically detecting the bootstrap processor.  I would make the logic.

1. Test bit 8 to see if we are on the bootstrap processor.
2. If we are not on the bootstrap processor and we don't have a table
   that will tell us guess that the bootstrap processor has apic id 0.

   It is so overwhelmingly common that the bootstrap processor has apic
   id 0 that any other assumption is silly.

More important is testing to see if we are on the bootstrap processor
and if we are not disabling any cpus in that case.  As that will
guarantee that introducing code to not start the bootstrap processor
won't cause a regression outside of the kexec on panic case.

Eric
