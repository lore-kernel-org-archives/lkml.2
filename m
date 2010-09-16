Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0IPXNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 19:13:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52475 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0IPXNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 19:13:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>,
        "paulmck\@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "simon.kagstrom\@netinsight.net" <simon.kagstrom@netinsight.net>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop\@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C0979C90E@USINDEVS01.corp.hds.com>
Date: Thu, 16 Sep 2010 16:13:38 -0700
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C0979C90E@USINDEVS01.corp.hds.com>
	(Seiji Aguchi's message of "Thu, 16 Sep 2010 16:16:14 -0400")
Message-ID: <m1wrql2sf1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Seiji Aguchi <seiji.aguchi@hds.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Fix kexec abort due to IPI from panic().
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seiji Aguchi <seiji.aguchi@hds.com> writes:

> Hi,
>
> I'm Seiji Aguchi.
> I work for Hitachi Data Systems.
> It's a first time to send a patch to lkml.
> Nice to meet you.
>  
> I found an issue in kexec.
> Please give me your comments and suggestions.
>  
> Kexec abort when two cpus panic at the same time.
> An example scenario:
> 1. Two cpus panic at the same time .
> 2. One cpu ,cpu0, get kexec_mutex in crash_kexec().
> 3. The other cpu ,cpu1, can't get kexec_mutex and return from crash_kexec().
> 4. Cpu0 runs kmsg_dump(KMSG_DUMP_KEXEC).
> 5. Cpu1 can't get dump_list_lock and return from kmsg_dump(KMSG_DUMP_PANIC).
> 6. Cpu1 runs smp_send_stop() in panic() and sends IPI to other cpus.
> 7. Cpu0 may receive IPI from cpu1 while running kmsg_dump(KMSG_DUMP_KEXEC),
>    crash_setup_regs(), or crash_save_vmcore().
>  
> We can solve this issue by disabling external interrupt while getting kexec_mutex 
> in crash_kexec().

Disabling interrupts is fine, I thought we did that already at some
point.  However that call to kmsg_dump(KMSG_DUMP_KEXEC) is a bug as it
introduces locks into a path that should not be taking locks.  Please
remove that broken kmsg_dump call as well.

Nothing in the crash_kexec path should even have the option of blocking.

Eric
