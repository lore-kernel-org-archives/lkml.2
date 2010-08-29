Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0H2XtO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 19:49:14 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59653 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab0H2XtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 19:49:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "David Hill" <hilld@binarystorm.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
	<ByD_7B96czP.A.vDE.diueMB@chimera> <m11v9hc8a1.fsf@fess.ebiederm.org>
	<201008300128.34970.rjw@sisk.pl>
Date: Sun, 29 Aug 2010 16:49:06 -0700
In-Reply-To: <201008300128.34970.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Mon, 30 Aug 2010 01:28:34 +0200")
Message-ID: <m1wrr9asjx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Rafael J. Wysocki" <rjw@sisk.pl>
X-Spam-Relay-Country: 
Subject: Re: [Bug #16173] After uncompressing the kernel, at boot time, the server hangs.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Monday, August 30, 2010, Eric W. Biederman wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>> > This message has been generated automatically as a part of a report
>> > of regressions introduced between 2.6.34 and 2.6.35.
>> >
>> > The following bug entry is on the current list of known regressions
>> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
>> > be listed and let the tracking team know (either way).
>> >
>> 
>> Looks like it's fixed.
>
> Good.  What mainlne commit is that?

commit 910081322bf9c4ed392dc8f2ecbc33fdb42a2958
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Wed Aug 4 12:51:11 2010 -0700

    x86/apic: Map the local apic when parsing the MP table.
    
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
    
    Cc: stable@kernel.org
    Reported-by: David Hill <hilld@binarystorm.net>
    Reported-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
    Tested-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
    Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
