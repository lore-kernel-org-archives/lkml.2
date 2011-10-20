Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1JTNfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:35:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57691 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1JTNfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:35:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, oleg@redhat.com,
        richard@nod.at, mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        dhowells@redhat.com, eparis@redhat.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>, netdev@vger.kernel.org
References: <1318974898-21431-1-git-send-email-serge@hallyn.com>
	<1318974898-21431-10-git-send-email-serge@hallyn.com>
	<m1sjmpytpf.fsf@fess.ebiederm.org> <20111020125801.GA1315@hallyn.com>
Date: Thu, 20 Oct 2011 06:35:45 -0700
In-Reply-To: <20111020125801.GA1315@hallyn.com> (Serge E. Hallyn's message of
	"Thu, 20 Oct 2011 12:58:01 +0000")
Message-ID: <m1fwinvl8u.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/VSvJzxFr5lNDFF5Upcbp7Pqg38QE7I4Q=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 9/9] make net/core/scm.c uid comparisons user namespace aware
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> Serge Hallyn <serge@hallyn.com> writes:
>> 
>> > From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
>> >
>> > Currently uids are compared without regard for the user namespace.
>> > Fix that to prevent tasks in a different user namespace from
>> > wrongly matching on SCM_CREDENTIALS.
>> >
>> > In the past, either your uids had to match, or you had to have
>> > CAP_SETXID.  In a namespaced world, you must either (both be in the
>> > same user namespace and have your uids match), or you must have
>> > CAP_SETXID targeted at the other user namespace.  The latter can
>> > happen for instance if uid 500 created a new user namespace and
>> > now interacts with uid 0 in it.
>> 
>> Serge this approach is wrong.
>
> Thanks for looking, Eric.
>
>> Because we pass the cred and the pid through the socket socket itself
>> is just a conduit and should be ignored in this context.
>
> Ok, that makes sense, but
>
>> The only interesting test should be are you allowed to impersonate other
>> users in your current userk namespace.
>
> Why in your current user namespace?  Shouldn't it be in the
> target user ns?  I understand it could be wrong to tie the
> user ns owning the socket to the target userns (though I still
> kind of like it), but just because I have CAP_SETUID in my
> own user_ns doesn't mean I should be able to pose as another
> uid in your user_ns.

First and foremost it is important that you be able if you have the
capability to impersonate other users in your current user namespace.
That is what the capability actually controls.

None of this allows you to impersonate any user in any other user
namespace.  The translation between users prevents that.

> (Now I also see that cred_to_ucred() translates to the current
> user_ns, so that should have been a hint to me before about
> your intent, but I'm not convinced I agree with your intent).
>
> And you do the same with the pid.  Why is that a valid assumption?

Yes.  Basically all the code is allow you to impersonate people you
would have been able to impersonate before.  If your target is in
another namespace you can not fool them.

With pids the logic should be a lot clearer.  Pretend to be a pid you can
see in your current pid namespace.  Lookup and convert to struct pid aka
the namespace agnostic object.  On output return the pid value that
the target process will know you as.

Ultimately I think we need a ns_capable for the current user namespace
instead of a global one.  But I don't see any rush to introduce
ns_capable here.

Eric

