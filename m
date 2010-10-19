Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0JSQBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:01:11 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33214 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab0JSQBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:01:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@linux.intel.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        linux-doc@vger.kernel.org
References: <1287476560-5874-1-git-send-email-amwang@redhat.com>
	<1287476560-5874-2-git-send-email-amwang@redhat.com>
	<4CBD9B7F.6040307@linux.intel.com> <m1vd4yi977.fsf@fess.ebiederm.org>
	<4CBDB385.6080100@linux.intel.com>
Date: Tue, 19 Oct 2010 09:00:55 -0700
In-Reply-To: <4CBDB385.6080100@linux.intel.com> (Andi Kleen's message of "Tue,
	19 Oct 2010 17:04:37 +0200")
Message-ID: <m1eibmdvew.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <ak@linux.intel.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] sysctl: remove sysctl syscall
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:

>> At the time the deprecation was written we nearly we were in the late
>> rc's before anything that cared in practice. glibc has stopped even
>> providing a sys_sysctl wrapper now.
>
> What matters are old glibc installations, not new ones.

No.  It matters a lot that glibc has stopped providing the wrapper, as
that makes it doubly difficult for new users to start using the binary
sysctl interface.

>>> I think it's ok to remove the full tables, but keeping
>>> a wrapper just for the functionality glibc use(s/d) is still a good
>>> idea.
>> I think the only problem should be the arm glibc.  I don't know if
>> it's iopl implementation ever got weened off of this.  I tried
>> but I didn't have good test machine and submitting patches to
>> glibc is much more of a pain than kernel patches.
>
>
> Eric, I think you have the wrong approach here: it doesn't matter what new glibc
> does,
> but what any old glibcs do. If any old one uses it we cannot simply
> remove it.

????  If there are any current users we can not remove it.

If current glibc on arm still uses this (which I expect it does) we can
not possibly remove the code.  With a current user it doesn't matter
what historical versions of glibc do.

>> To my knowledge there has never been a version of x86 glibc that
>> had problems if sys_sysctl returns -ENOSYS, and glibc proper removed
>> even that dependency almost as soon as sys_sysctl was deprecated.
>>
>
> AFAIK older glibc didn't use some functionality in the kernel if they couldn't
> figure out the right kernel version. And they were using sysctl for
> this.

Sigh.  We have had the conversation a dozen times.

I have looked and reasearched until I am bored.  It was the pthreads
code attempting to detect if we are smp.  At worst the code would not
optimize for the uniprocessor case.

But again that was long ago, and last time we had this conversation it
was impossible for me to find glibc binaries on x86 that were still even
trying to do this. 

We have been warning on even the historical glibc pthreads usage for
over a year now.

>> Last time we discussed this (when I added the compatibility wrapper)
>> I couldn't even find a version of glibc that used sysctl, and I could
>> not find a distribution old enough that still had a version of glibc
>> that used sysctl on x86.
>
> When I did my really old work for sysctl_binary() I ran into this problem.
> All glibc binaries on my distribution back then used sysctl.

Yep.  Which was what 4+ years ago?

Perhaps the question should be in practice does any enterprise distro
have a glibc that uses sys_sysctl.  Not that I think even that case
is particularly interesting.

>> We warn on every sys_sysctl value now even the glibc uses and perhaps I
>> am blind but I haven't seen any bug reports.  So we should be safe
>> turning this off.
>>
>
> I don't so. I don't think we can that easily break compatibility, sorry.
> Binary compatibility is something very important for Linux.

Duh!  Which is why we have the code.

Of course the safe course is to keep the code and disable the feature,
if no one is using it.

> Anyways I'm fine with removing the bulk of the tables, but not the compat
> table for the one glibc uses.

Removing the bulk of the tables is another name for breaking binary
compatibility.  Which you said is a no no.  We have the code and it
works at this point, there is no point to neutering it.  Especially when
distros whose glibc pthread code used this are for the most part lost in
the course of history.

To the best of my knowledge the last and user of sys_sysctl is the glibc
ioperm (my apologies I mispoke when I said iopl) implementation on arm.
Not that people run around calling ioperm very often in any distro.

All of that said I think disabling sys_sysctl by default now is totally
reasonable.  If there is a percentage in removing the code we can worry
about that later.  Perhaps we should add a CONFIG_CRUFT and move
sys_sysctl under there.  Binary compatibility that nothing needs but
that we actually have code for just in case.

Eric
