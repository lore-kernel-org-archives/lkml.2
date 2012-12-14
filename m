Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab2LNPrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:47:15 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57419 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2LNPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:47:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-security-module@vger.kernel.org
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
	<87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
	<20121214032820.GA5115@mail.hallyn.com> <87bodxi9zw.fsf@xmission.com>
	<20121214152607.GA9266@mail.hallyn.com>
Date: Fri, 14 Dec 2012 07:47:03 -0800
In-Reply-To: <20121214152607.GA9266@mail.hallyn.com> (Serge E. Hallyn's
	message of "Fri, 14 Dec 2012 15:26:07 +0000")
Message-ID: <87bodwd4aw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+ycHDm+b1GGlHLurFdwVu1VLHqT/j1Qxg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3881]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the parent user namespace to have caps.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>> 
>> > Quoting Eric W. Biederman (ebiederm@xmission.com):
>> >> 
>> >> Andy Lutomirski pointed out that the current behavior of allowing the
>> >> owner of a user namespace to have all caps when that owner is not in a
>> >> parent user namespace is wrong.
>> >
>> > To make sure I understand right, the issue is when a uid is mapped
>> > into multiple namespaces.
>> 
>> Yes.
>> 
>> i.e. uid 1000 in ns1 may own ns2, but uid 1000 in ns3 does not?
>> 
>> I am not certain of your example.
>> 
>> The simple case is:
>> 
>> init_user_ns:
>>      child_user_ns1 (owned by uid == 0 [in all user namespaces])
>>            child_user_ns2 (owned by uid == 0 [ in all user namespaces])
>> 
>> 
>> root (uid == 0) in child_user_ns2 has all rights over anything in
>> child_user_ns1.
>
> Well that is only if there was no mapping.  (since we're comparing
> kuids, not uid_ts).  right?  If you didn't map uid 0 in child_user_ns2
> to another id in the parent ns, you weren't all *that* serious about
> isolating the ns.
>
> The case I was thinking is
>
>   init_user_ns:  [0-uidmax]
>       child_user_ns1  [100000-199999]
>       child_user_ns2  [100000-199999]
>         child_user_ns3  [200000-299999]
>
> with unfortunate mappings  - ns1 and ns2 should have had nonoverlapping
> ranges, but in any case now uid 1000 in ns1 can exert privilege over
> ns3.  Again, uids comparisons will succeed for file access anyway, so
> ns1 can 0wn ns2 and ns3 other ways.

Yes yours is the more realistic scenario.  Mine was simplified to be clear.

> Heck I'm starting to think the bug is a feature - surely given the
> mappings above I meant for ns1 and ns2 to bleed privilege to each
> other?

The serious problem is that privileges can bleed up. A user in 
ns3 can wind up owning ns2 or ns1.  Which totally defeats the permission
model.  You have CAP_DAC_OVERRIDE so you don't even need access to files
you own, etc, etc.

Or the more fun version as root:
	/* Drop all privs */
	pid = clone(CLONE_NEWUSER);
	if (pid == 0) {
		/* Have all privs! Bahaha */
	}

Which makes dropping capabilies a joke.

And since up to through 3.7 the only user that can create a user namespace
is root that is a very realistic scenario.  It doesn't work against the
initial user namespace thankfully, but in v3.7 it works against every
other user namespace.

To keep user namespaces safe we need to maintain the invariant that a
child user namespace can not get capapabilities in it's parent user
namespace.

Eric
