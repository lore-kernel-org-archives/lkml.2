Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2LOALt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:11:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55522 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713Ab2LOALq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:11:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>
References: <87txroxpgq.fsf@xmission.com> <87bodwxpcg.fsf@xmission.com>
	<20121215000338.GC13659@mail.hallyn.com>
Date: Fri, 14 Dec 2012 16:11:38 -0800
In-Reply-To: <20121215000338.GC13659@mail.hallyn.com> (Serge E. Hallyn's
	message of "Sat, 15 Dec 2012 00:03:38 +0000")
Message-ID: <87r4msrx6t.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/j1J0aN+YOu787ooFSfCYtTwRtf1a1YJo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0059]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 3/4] userns: Add a more complete capability subset test to commit_creds
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> When unsharing a user namespace we reduce our credentials to just what
>> can be done in that user namespace.  This is a subset of the credentials
>> we previously had.  Teach commit_creds to recognize this is a subset
>> of the credentials we have had before and don't clear the dumpability flag.
>> 
>> This allows an unprivileged  program to do:
>> unshare(CLONE_NEWUSER);
>> fd = open("/proc/self/uid_map", O_RDWR);
>> 
>> Where previously opening the uid_map writable would fail because
>> the the task had been made non-dumpable.
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
>
>> ---
>>  kernel/cred.c |   26 +++++++++++++++++++++++++-
>>  1 files changed, 25 insertions(+), 1 deletions(-)
>> 
>> diff --git a/kernel/cred.c b/kernel/cred.c
>> index 48cea3d..993a7ea41 100644
>> --- a/kernel/cred.c
>> +++ b/kernel/cred.c
>> @@ -455,6 +455,30 @@ error_put:
>>  	return ret;
>>  }
>>  
>
> Do you think we need to warn that this can only be used for
> commit_creds?  (i.e. if someone tried ot use this in some
> other context, the 'creds are subset of target ns is a child
> of current_ns' assumption would be wrong)

This function should be a general test valid at any time.

Except that I forgot the bit of the test that asks is the original cred
the owner of the subset user namespace.

I will respin this patch.

As a small segway this property that unshare(CLONE_NEWUSER) results
in a subset of the capabilities a process already had is a very
important property to make it possible to reason about user namespaces.
Maintaining this property is the reason behind the choices I made
in fixing cap_capable.

>> +static bool cred_cap_issubset(const struct cred *set, const struct cred *subset)
>> +{
>> +	const struct user_namespace *set_ns = set->user_ns;
>> +	const struct user_namespace *subset_ns = subset->user_ns;
>> +
>> +	/* If the two credentials are in the same user namespace see if
>> +	 * the capabilities of subset are a subset of set.
>> +	 */
>> +	if (set_ns == subset_ns)
>> +		return cap_issubset(subset->cap_permitted, set->cap_permitted);
>> +
>> +	/* The credentials are in a different user namespaces
>
> This can only happen during setns and CLONE_NEWUSER right?

Right.  This can only happen during setns, unshare(CLONE_NEWUSER),
and possibly during clone.  Otherwise we are not changing the user
namespace.  However for clarity and robustness I don't want the code
to rely on that.

>> +	 * therefore one is a subset of the other only if a set is an
>> +	 * ancestor of subset.
>> +	 */
>
>> +	while (subset_ns != &init_user_ns) {
>> +		if (set_ns == subset_ns->parent)
>> +			return true;
>> +		subset_ns = subset_ns->parent;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>  /**
>>   * commit_creds - Install new credentials upon the current task
>>   * @new: The credentials to be assigned
>> @@ -493,7 +517,7 @@ int commit_creds(struct cred *new)
>>  	    !gid_eq(old->egid, new->egid) ||
>>  	    !uid_eq(old->fsuid, new->fsuid) ||
>>  	    !gid_eq(old->fsgid, new->fsgid) ||
>> -	    !cap_issubset(new->cap_permitted, old->cap_permitted)) {
>> +	    !cred_cap_issubset(old, new)) {
>>  		if (task->mm)
>>  			set_dumpable(task->mm, suid_dumpable);
>>  		task->pdeath_signal = 0;
>> -- 
>> 1.7.5.4
