Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab0HMV1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:27:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48522 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab0HMV04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:26:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
References: <20100813193441.GD18691@ovro.caltech.edu>
Importance: high
Date: Fri, 13 Aug 2010 14:26:49 -0700
In-Reply-To: <20100813193441.GD18691@ovro.caltech.edu> (Ira W. Snyder's
	message of "Fri, 13 Aug 2010 12:34:42 -0700")
Message-ID: <m1y6cap5k6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Ira W. Snyder" <iws@ovro.caltech.edu>
X-Spam-Relay-Country: 
Subject: Re: BISECTED: 2.6.35 (and -git) fail to boot: APIC problems
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ira W. Snyder" <iws@ovro.caltech.edu> writes:

> Hello Eric,
>
> I've recently tried to boot 2.6.35 (and -git) on one of my machines, and it
> fails to boot. No messages are printed to the serial console. I have run git
> bisect, and found that your commit cf7500c0ea133d is the cause.

This problem took a while to track down, but it should be fixed in the
commit below.  Which linus merged today from the x86-urgent branch.

Thank you for the excellent bug report, and my apologies for missing
this the first time around.

Can you please verify the commit below fixes your problem?

Thanks,
Eric


commit 5989cd6a1cbf86587edcc856791f960978087311
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Wed Aug 4 13:30:27 2010 -0700

    x86, apic: Map the local apic when parsing the MP table.
    
    This fixes a regression in 2.6.35 from 2.6.34, that is
    present for select models of Intel cpus when people are
    using an MP table.
    
    The commit cf7500c0ea133d66f8449d86392d83f840102632
    "x86, ioapic: In mpparse use mp_register_ioapic" started
    calling mp_register_ioapic from MP_ioapic_info.  An extremely
    simple change that was obviously correct.  Unfortunately
    mp_register_ioapic did just a little more than the previous
    hand crafted code and so we gained this call path.
    
    The problem call path is:
    MP_ioapic_info()
      mp_register_ioapic()
       io_apic_unique_id()
         io_apic_get_unique_id()
           get_physical_broadcast()
             modern_apic()
               lapic_get_version()
                 apic_read(APIC_LVR)
    
    Which turned out to be a problem because the local apic
    was not mapped, at that point, unlike the similar point
    in the ACPI parsing code.
    
    This problem is fixed by mapping the local apic when
    parsing the mptable as soon as we reasonably can.
    
    Looking at the number of places we setup the fixmap for
    the local apic, I see some serious simplification opportunities.
    For the moment except for not duplicating the setting up of the
    fixmap in init_apic_mappings, I have not acted on them.
    
    The regression from 2.6.34 is tracked in bug
    https://bugzilla.kernel.org/show_bug.cgi?id=16173
    
    Cc: <stable@kernel.org> 2.6.35
    Reported-by: David Hill <hilld@binarystorm.net>
    Reported-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
    Tested-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
    LKML-Reference: <m1eiee86jg.fsf_-_@fess.ebiederm.org>
    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>


