Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1FBD03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 23:26:29 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55211 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1FBD01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 23:26:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
	<20110203020703.GB21603@redhat.com>
	<20110203135324.93BC.A69D9226@jp.fujitsu.com>
	<20110526131028.7052a893.akpm@linux-foundation.org>
	<5C4C569E8A4B9B42A84A977CF070A35B2C17324B79@USINDEVS01.corp.hds.com>
	<20110531213704.GV16382@redhat.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2C17324BB9@USINDEVS01.corp.hds.com>
Date: Wed, 01 Jun 2011 20:26:20 -0700
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C17324BB9@USINDEVS01.corp.hds.com>
	(Seiji Aguchi's message of "Tue, 31 May 2011 18:24:14 -0400")
Message-ID: <m1ei3cq5gj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+lnZ4J4VDyWwLY0RPfNO4Obfr/bpvmO68=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: lkml.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Seiji Aguchi <seiji.aguchi@hds.com>
X-Spam-Relay-Country: 
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about kdump_msg hook into crash_kexec())
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seiji Aguchi <seiji.aguchi@hds.com> writes:

> Hi,
>
>>What are you using kmsg_dump() for? Using mtdoops, ramoops or something
>>else?  Is it working reliably for you?
>
> I plan to use kmsg_dump() for set_variable service of UEFI.
> I proposed a prototype patch this month and will improve it.
> (kmsg_dump is used inside pstore.)
>
> https://lkml.org/lkml/2011/5/10/340

Shudder.  Firmware calls in the crash path.

If that is the use, we need to remove the kmsg_dump(KMSG_DUMP_KEXEC)
hook from crash_kexec yesterday.  It is leading to some really ludicrous
suggestions that are on the way from making kexec on panic unreliable
and useless.

There will always be EFI implementations where that will not work and
there will be no way we can fix those.

There is a long history of people trying to do things in a crashing
kernel, things that simply do not work when the system is in a bad
state.  kmsg_dump() when I reviewed the code had significant
implementation problems for being called from interrupt handlers
and the like.

To introduce a different solution for capturing information when a
kernel crashes we need to see numbers that in a large number of
situations that the mechanism you are proposing is more reliable and/or
more maintainable than the current kexec on panic implementation.

The best work I know of on the reliability of the current situation
is "Evaluating Linux Kernel Crash Dumping Mechanisms", by Fernando Luis Vazquez Cao.
http://www.linuxsymposium.org/archives/OLS/Reprints-2006/cao-reprint.pdf


Now it does happen to be a fact that our efi support in linux is
so buggy kexec does not work let alone kexec on panic (if the target
kernel has any efi support).   But our efi support being buggy is not
a reason to add more ways to fail when we have a kernel with efi
support.  It is an argument to remove our excessive use of EFI
calls.

So let's just remove the ridiculous kmsg_dump(KMSG_DUMP_KEXEC) hook from
crash_kexec and remove any temptation for abuses like wanting to use
kmsg_dump() on anything but a deeply embedded system where there simply
is not enough memory for 2 kernels.

Eric
