Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab2CVW7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 18:59:18 -0400
Received: from out06.mta.xmission.com ([166.70.13.236]:43284 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753159Ab2CVW7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 18:59:16 -0400
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
	<m1vclw1fx8.fsf@fess.ebiederm.org>
	<CAMOw1v4gszzV7F3z1m+RWEe9UDgR2Jrp9wX_w9z_1UkXT=FL5Q@mail.gmail.com>
Date: Thu, 22 Mar 2012 16:02:46 -0700
In-Reply-To: <CAMOw1v4gszzV7F3z1m+RWEe9UDgR2Jrp9wX_w9z_1UkXT=FL5Q@mail.gmail.com>
	(Lucas De Marchi's message of "Thu, 22 Mar 2012 19:12:26 -0300")
Message-ID: <m1ehskxmqx.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/yoKnQxCYorSKhGSoO2cdUw19bltDNRKE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4901]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Lucas De Marchi <lucas.demarchi@profusion.mobi>
X-Spam-Relay-Country: **
Subject: Re: [3.3-rc7] sys_poll use after free (hibernate)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:

> On Thu, Mar 22, 2012 at 6:31 PM, Eric W. Biederman

>> It looks like it was a combination of the fuzzer doing silly things
>> and a removed ctl_table entry being poisoned and having .poll set
>> to 6b6b6b6b6b6b6b6b so the guard against calling poll when it is
>> nonsense did not trigger.  So your patch should be sufficient
>> for now.
>
> What I understood afterwards was:
>
> 1. fuzzer calling poll() on files that did support poll
> 2. modules that created that sysctl entries were removed
> 3. 'table' was entirely removed (not ->poll).

I just grepped the kernel for ctl_table_poll and DEFINE_CTL_TABLE_POLL.
There are only the two original users of hostname and domainname.

The problem very much had to be that ctl_table was freed and poisoned
but we still pointed to it, and we were not using the grab_header idiom
to ensure we did not use an expired ctl_table entry.

Which means that it was any ctl_table being add/removed.  Probably in
this case the per cpu scheduler sysctl table entries that get
added/removed whenever we logically add/remove a cpu.

I expect what happened is that the fuzzer opened the sysctl file some
time before it was removed and then sometime after the entry was removed
(but before the memory was reused) called select/poll on that file
descriptor.  Since the ctl_table was poisoned ->poll was
6b6b6b6b6b6b6b6b and so we passed the checks for a non NULL ->poll and
we proceed to do nonsense things that caused the kernel oops in
proc_sys_poll.

>> Long term we still need a version of poll that is safe to use
>> with modules.
>
> I think the way it's now (with my patch taken by Andrew) is safe for
> having poll() with modules.

No it is not.

The problem is that proc_sys_poll is non-blocking.  It is called
primarily to place the system on a wait queue.  But notice that
if you place the caller on a wait_queue in proc_sys_poll and return
then we may call unregister_sysctl_table while and remove the sysctl
while someone still is on the wait queue.  Sleeping on a wait_queue
that has been freed is so bizarre I don't want to think about the
failure modes.

sysfs solves this problem by tracking openers and has it's wait_queue in
the per opener structure.  That same logic needs to be mirrored in
sysctl for poll to be safe on any sysctl table entry that can be
removed.

I believe a correct fix would remove the .poll field in struct ctl_table,
remove struct ctl_table_poll entirely and modify the signature of
proc_sys_poll_notify to be:
void proc_sys_poll_notify(struct ctl_table_header *head, struct ctl_table *table);

Eric
