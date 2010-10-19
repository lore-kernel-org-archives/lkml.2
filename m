Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab0JSNuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:50:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57674 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab0JSNto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:49:44 -0400
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
	<4CBD9B7F.6040307@linux.intel.com>
Date: Tue, 19 Oct 2010 06:49:32 -0700
In-Reply-To: <4CBD9B7F.6040307@linux.intel.com> (Andi Kleen's message of "Tue,
	19 Oct 2010 15:22:07 +0200")
Message-ID: <m1vd4yi977.fsf@fess.ebiederm.org>
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
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
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

>  On 10/19/2010 10:22 AM, Amerigo Wang wrote:
>> Remove the obsolete sysctl syscall. It was scheduled
>> to be removed in Sept.
>
>
> I thought at least older glibc was still using it? Did anyone check
> what happens if it sees no sysctl(2)?

At the time the deprecation was written we nearly we were in the late
rc's before anything that cared in practice. glibc has stopped even
providing a sys_sysctl wrapper now.

> I think it's ok to remove the full tables, but keeping
> a wrapper just for the functionality glibc use(s/d) is still a good
> idea.

I think the only problem should be the arm glibc.  I don't know if
it's iopl implementation ever got weened off of this.  I tried
but I didn't have good test machine and submitting patches to
glibc is much more of a pain than kernel patches.

To my knowledge there has never been a version of x86 glibc that
had problems if sys_sysctl returns -ENOSYS, and glibc proper removed
even that dependency almost as soon as sys_sysctl was deprecated.

Last time we discussed this (when I added the compatibility wrapper)
I couldn't even find a version of glibc that used sysctl, and I could
not find a distribution old enough that still had a version of glibc
that used sysctl on x86.

We warn on every sys_sysctl value now even the glibc uses and perhaps I
am blind but I haven't seen any bug reports.  So we should be safe
turning this off.

As far as this goes I would just change the default to off for now.
Keeping the code doesn't have any impact on the core of the kernel any
more, or even any binary impact.  As the int -> long conversion has
shown.  If we can get through a release with the code disabled killing
it the next release makes a lot of sense.

Eric
