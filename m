Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1LQWga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 17:36:30 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:52934 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab1LQWg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 17:36:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
References: <1323917052-480-1-git-send-email-walken@google.com>
	<20111215141945.add405d5.akpm@linux-foundation.org>
	<CANN689EViJYxDRr48wK1=_Lpb62wB5tj4-fnN1-MY8y-1L33fw@mail.gmail.com>
	<20111215144411.930dd860.akpm@linux-foundation.org>
Date: Sat, 17 Dec 2011 14:14:00 -0800
In-Reply-To: <20111215144411.930dd860.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 15 Dec 2011 14:44:11 -0800")
Message-ID: <m1iplerglz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19q6qLUX8KMKFjI7OzqxWhUJHocepXK2kk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH] Fix for binary_sysctl() memory leak
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 15 Dec 2011 14:38:58 -0800
> Michel Lespinasse <walken@google.com> wrote:
>
>> On Thu, Dec 15, 2011 at 2:19 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > I think the patch is correct but the description is misleading?
>> >
>> > I see no memory leak here. __Calling __putname() directly simply
>> > bypasses some audit-related stuff.
>> 
>> Hmmm, maybe I wasn't explicit enough about it. We are definitely
>> seeing a memory leak without the patch.
>> 
>> When auditing is enabled, putname() calls audit_putname *instead* (not
>> in addition) to __putname(). Then, if a syscall is in progress,
>> audit_putname does not release the name - instead, it expects the name
>> to get released when the syscall completes, but that will happen only
>> if audit_getname() was called previously, i.e. if the name was
>> allocated with getname() rather than the naked __getname(). So,
>> __getname() followed by putname() ends up leaking memory.
>> 
>
> OK.  Please resend with a new changelog?

This seems like a reasonable change to me.  I guess I misunderstood
the __getname/putname interaction.  I expect I was focusing on the
fact you can only call getname if you have your data in userspace.

> The bug surprises me - it seems that it makes it trivial for userspace
> to cause leaking of mad amounts of kernel memory, which would cause the
> bug to be found and fixed quickly.
>
> Is it a recent regression, or does the bug trigger only in weird
> circumstances, or what?

Calling sysctl(2) is very rare.  I don't know if it actually happens
anywhere with a modern userspace except in regression tests.
Effectively we retain sysctl(2) because it doesn't take too much to
maintain.

Michel what caused you to discover this bug?  If you are using
sysctl(2) in production code I am a bit worried.

Eric
