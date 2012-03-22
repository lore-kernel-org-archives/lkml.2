Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192Ab2CVV1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:27:49 -0400
Received: from out08.mta.xmission.com ([166.70.13.238]:33094 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964911Ab2CVV1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:27:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20120313005855.GA24639@redhat.com>
	<CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
	<20120318192755.GB6589@ZenIV.linux.org.uk>
	<CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
Date: Thu, 22 Mar 2012 14:31:15 -0700
In-Reply-To: <CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
	(Lucas De Marchi's message of "Tue, 20 Mar 2012 03:08:08 -0300")
Message-ID: <m1vclw1fx8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+5YskuBfkDMfE76qhg2rk+qlGZftB8c24=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3231]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lucas De Marchi <lucas.demarchi@profusion.mobi>
X-Spam-Relay-Country: **
Subject: Re: [3.3-rc7] sys_poll use after free (hibernate)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:

> On Sun, Mar 18, 2012 at 4:27 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Sun, Mar 18, 2012 at 12:02:04PM -0700, Linus Torvalds wrote:
>>> and that load is from
>>>
>>>     poll_wait(filp, &table->poll->wait, wait);
>>>
>>> where the testing of %rsi and %rcx are the "if (p && wait_address)"
>>> check in poll_wait(), and %rsi is "table->poll" if I read it all
>>> correctly.
>>>
>>> And the 6b6b6b6b6b6b6b6b pattern is obviously POISON_FREE, so
>>> apparently 'table' has already been freed.
>>>
>>> I suspect the whole sysctl 'poll' code is seriously broken, since it
>>> seems to depend on those ctl_table pointers being stable over the
>>> whole open/close sequence, but if somebody unregisters the sysctl,
>>> it's all gone. The ctl_table doesn't have any refcounting etc, and I
>>> suspect that your hibernate sequence ends up unregistering some sysctl
>>> (perhaps as part of a module unload?)
>
> How could that happen if the only files that support poll  right now
> on sysctl are kernel/hostname and kernel/domainname?
>
>>
>> Ewww...  The way it was supposed to work (prio to ->poll() madness) was
>> that actual IO gets wrapped into grab_header()/sysctl_head_finish()
>> pair.  proc_sys_poll() doesn't do it, so yes, that post-mortem is
>> very likely to be correct.
>
> Yes, it  seems like I forgot to call grab_header() there, sorry for
> that. I'll prepare a patch and send you later today. I just wonder
> what is happening to reach that code... :-/

It looks like it was a combination of the fuzzer doing silly things
and a removed ctl_table entry being poisoned and having .poll set
to 6b6b6b6b6b6b6b6b so the guard against calling poll when it is
nonsense did not trigger.  So your patch should be sufficient
for now.

Long term we still need a version of poll that is safe to use
with modules.

Eric
