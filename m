Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab2EBTjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:39:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58477 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab2EBTjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:39:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Don Zickus <dzickus@redhat.com>, "x86\@kernel.org" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kexec-list <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>
References: <1330546129-4812-1-git-send-email-dzickus@redhat.com>
	<20120315202652.GA13930@redhat.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2E31C6F859@USINDEVS01.corp.hds.com>
	<20120430205354.GA32472@redhat.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2E4D461583@USINDEVS01.corp.hds.com>
Date: Wed, 02 May 2012 12:39:06 -0700
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2E4D461583@USINDEVS01.corp.hds.com>
	(Seiji Aguchi's message of "Wed, 2 May 2012 15:10:34 -0400")
Message-ID: <87vckemkyt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18fsGV5wBWCusCQ9eTYaYlg+MhmTS1Xq8c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Seiji Aguchi <seiji.aguchi@hds.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] x86, kdump: No need to disable ioapic in crash path
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seiji Aguchi <seiji.aguchi@hds.com> writes:

>> Perhaps calling setup_IO_APIC before setup_local_APIC would be a better fix?
>
> I checked Intel develper's manual and there is no restriction about the order of enabling IO_APIC/local_APIC.
> So, it may work.
>
> But, I don't understand why we have to change the stable boot-up code.

Because the boot-up code is buggy.  We need to get a better handle on
how it is buggy but apparently an interrupt coming in at the wrong
moment while booting with interrupts on the interrupt flag on the cpus
disalbed puts us in a state where we fail to boot.

We should be able to boot with apics enabled, and we almost can
emperically there are a few bugs.

The kdump path is particularly good at finding bugs.

> If kdump disables both local_apic and IO_APIC in proper way in 1st kernel,  2nd kernel works without any change.

We can not guarnatee disabling the local apics in the first kernel.

Ultimately the less we do in the first kernel the more reliable kdump is
going to be.  Disabling the apics has been a long standing bug work
around.

At worst we may have been a smidge premature in using assuming the
kernel can boot with the apics enabled but it I would hope we can
track down and fix the boot up code.

Probably what we want to do is not to disable the I/O apics but
to program the I/O apics before we enable the local apic so that
we have control of the in-comming interrupts.  But I haven't
looked at this in nearly enough detail to even guess what needs
to happen.

Eric


