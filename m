Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1BCVNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:13:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44890 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1BCVNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:13:17 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
References: <20110131225939.GH11974@redhat.com>
	<20110203094715.939C.A69D9226@jp.fujitsu.com>
	<20110203020528.GA21603@redhat.com>
	<5C4C569E8A4B9B42A84A977CF070A35B2C147F4346@USINDEVS01.corp.hds.com>
Date: Thu, 03 Feb 2011 13:13:07 -0800
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C147F4346@USINDEVS01.corp.hds.com>
	(Seiji Aguchi's message of "Thu, 3 Feb 2011 13:38:13 -0500")
Message-ID: <m14o8klt3w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18dJro+5TBDHwgOYrmptnVomlnUwaK4FTU=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Seiji Aguchi <seiji.aguchi@hds.com>
X-Spam-Relay-Country: 
Subject: Re: Query about kdump_msg hook into crash_kexec()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seiji Aguchi <seiji.aguchi@hds.com> writes:

> Hi,
>
>>PS: FWIW, Hitach folks have usage idea for their enterprise purpose, but 
>>    unfortunately I don't know its detail. I hope anyone tell us it.
>
> I explain the usage of kmsg_dump(KMSG_DUMP_KEXEC) in enterprise area.
>
> [Background]
> In our support service experience, we always need to detect root cause 
> of OS panic.
> So, customers in enterprise area never forgive us if kdump fails and 
> we can't detect the root cause of panic due to lack of materials for 
> investigation.
>
>>- Why do you need a notification from inside crash_kexec(). IOW, what
>>  is the usage of KMSG_DUMP_KEXEC.
>
>
> The usage of kdump(KMSG_DUMP_KEXEC) in enterprise area is getting 
> useful information for investigating kernel crash in case kdump
> kernel doesn't boot.
>
> Kdump kernel may not start booting because there is a sha256 checksum
> verified over the kdump kernel before it starts booting.
> This means kdump kernel may fail even if there is no bug in kdump and
> we can't get any information for detecting root cause of kernel crash

Sure it is theoretically possible that the sha256 checksum gets
corrupted (I have never seen it happen or heard reports of it
happening).  It is a feature that if someone has corrupted your code the
code doesn't try and run anyway and corrupt anything else.

That you are arguing against have such a feature in the code you use to
write to persistent storage is scary.

> As I mentioned in [Background], We must avoid lack of materials for 
> investigation.
> So, kdump(KMSG_DUMP_KEXEC) is very important feature in enterprise
> area.

That sounds wonderful, but it doesn't jive with the
code. kmsg_dump(KMSG_DUMP_KEXEC) when I read through it was simply not
written to be robust when most of the kernel is suspect.  Making it in
appropriate for use on the crash_kexec path.  I do not believe kmsg_dump
has seen any testing in kernel failure scenarios.

There is this huge assumption that kmsg_dump is more reliable than
crash_kexec, from my review of the code kmsg_dump is simply not safe in
the context of a broken kernel.  The kmsg_dump code last I looked code
won't work if called with interrupts disabled.

Furthermore kmsg_dump(KMSG_DUMP_KEXEC) is only useful for debugging
crash_kexec.  Which has it backwards as it is kmsg_dump that needs the
debugging.

You just argued that it is better to corrupt the target of your
kmsg_dump in the event of a kernel failure instead of to fail silently.

I don't want that unreliable code that wants to corrupt my jffs
partition anywhere near my machines.

Eric
