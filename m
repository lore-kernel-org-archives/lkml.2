Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab0I0Q7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:59:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59187 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759434Ab0I0Q7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:59:42 -0400
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
	<dle-develop@lists.sourceforge.net>,
        "David.Woodhouse\@intel.com" <David.Woodhouse@intel.com>,
        "anton\@samba.org" <anton@samba.org>,
        "ben\@decadent.org.uk" <ben@decadent.org.uk>,
        "randy.dunlap\@oracle.com" <randy.dunlap@oracle.com>,
        "jason.wessel\@windriver.com" <jason.wessel@windriver.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C0979C90E@USINDEVS01.corp.hds.com>
	<m1wrql2sf1.fsf@fess.ebiederm.org>
	<5C4C569E8A4B9B42A84A977CF070A35B2C0DCFFB3E@USINDEVS01.corp.hds.com>
Date: Mon, 27 Sep 2010 09:59:28 -0700
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C0DCFFB3E@USINDEVS01.corp.hds.com>
	(Seiji Aguchi's message of "Fri, 24 Sep 2010 09:08:14 -0400")
Message-ID: <m1eicfp1fz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Seiji Aguchi <seiji.aguchi@hds.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] Fix kexec abort due to IPI from panic().
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seiji Aguchi <seiji.aguchi@hds.com> writes:

> Hi Eric,
>
> This is a patch which makes kmsg_dump() non-blocking.
> Please give me your comments and suggestions.
>
> I improved it as follows.
>
> (1) Improvement of dump_list_lock
>     (1-1) I changed dump_list to RCU for deleting dump_list_lock in kmsg_dump().
>     (1-2) I moved kmsg_dump(KMSG_DUMP_KEXEC) behind machine_crash_shutdown() 
>           for avoiding concurrent execution of dump_list functions.
>     (1-3) I also moved kmsg_dump(KMSG_DUMP_PANIC) behind smp_send_stop() for the 
>           same reason.
>  
> (2) Improvement of logbuf_lock
>     I added spinlock_init(&logbuf_lock) when executing kmsg_dump() in kexec or panic path
>     for preventing dead lock.
>
> We can delete blocking kmsg_dump call in crash_kexec and panic path.

This looks better, but it still gives me the willies.

I tried tracing through the ramoops code to see if there were anything
else that could block, but I couldn't make it through do_gettimeofday.

I couldn't even make it that far with the mtd oops tracer.

The fact that the code is exported and modular doesn't make me feel
safe because there have been people in the past who have asked for an
notifier on crash so they could do stupid things when the kernel is
broken.

The fact that this wasn't noticed until we actually had a hang, doesn't
give me an especially great feeling about long term stability.

Most of all I don't see the use case of calling kmsg_dump when you have
kexec on panic setup to do the same thing.  Having kmsg_dump not on
the kexec on panic code path would let me sleep much easier at night.

Then there is the historical side of this.  Through many failed attempts
it has been show that dumpers in the kernel are fragile beasts that work
up until you actually have a real world failure and then they let you
down.  Kexec on panic is better as it works 65% or so of the time,
and definitely won't corrupt your bits if it fails.  I don't see what
makes kmsg_dump better than all of the past failed and useless kernel
dumpers.

Eric
