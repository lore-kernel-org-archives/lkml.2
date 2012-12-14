Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab2LNELq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 23:11:46 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:49281 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2LNELp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 23:11:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
	<87mwxhtxve.fsf@xmission.com>
	<CALCETrWxXZ1OzZeH_SGeg1E16rssxBwg+hjG09N5dkqweVKeRA@mail.gmail.com>
Date: Thu, 13 Dec 2012 20:11:37 -0800
In-Reply-To: <CALCETrWxXZ1OzZeH_SGeg1E16rssxBwg+hjG09N5dkqweVKeRA@mail.gmail.com>
	(Andy Lutomirski's message of "Thu, 13 Dec 2012 15:02:58 -0800")
Message-ID: <87mwxhff2e.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19aGC1Lo0BCCSwcffWiPFa4hpA/Y9Bnv3I=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0187]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] user namespace and namespace infrastructure changes for 3.8
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Thu, Dec 13, 2012 at 2:01 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>
>>> On 12/11/2012 01:17 PM, Eric W. Biederman wrote:
>
>> But please also note the difference between capable and ns_capable.  Any
>> security check that is capable() still requires priviliges in the
>> initial user namespace.
>
> Huh?
>
> I'm talking about:
>
> clone with CLONE_NEWUSER
>  - child does unshare(CLONE_NEWPID)
>  - parent does setfd(child's pid namespace)
>
> Now the parent is running in the init userns with a different pid ns.
> Setuid binaries will work but will see the unexpected pid ns.  With
> mount namespaces, this would be Really Bad (tm).  With pid or ipc or
> net, it's less obviously dangerous, but I'm not convinced it's safe.

That isn't safe.  That is a sneaky bug in my tree that I overlooked. :(

> I sort of think that setns on a *non*-userns should require
> CAP_SYS_ADMIN in the current userns, at least if no_new_privs isn't
> set.

Yes.  CAP_SYS_ADMIN in your current user namespace should make
setns as safe as it currently is before my patches.

That is just a matter of adding a couple nsown_capable(CAP_SYS_ADMIN)
permission checks.

Right now I test for nsown_capable(CAP_SYS_CHROOT) for the mount
namespace, which is probably sufficient to prevent those kinds of
shenanigans but I am going to add a nsown_capable(CAP_SYS_ADMIN) for
good measure.

> A non-threaded process can have mm_users == 2 with CLONE_VM.  I'm not
> sure this is a problem, though.

No it isn't.  I said threads because they are the easy concept not
because that covers all possible corner cases.

>>> In any case, why are threads special here?
>>
>> You know I don't think I stopped to think about it.   The combination
>> of CLONE_NEWUSER and CLONE_THREAD have been denined since the first user
>> namespace support was merged in 2008.
>>
>> I do know that things can get really strange when you mix multiple
>> namespaces in a process.  tkill of your own threads will stop working.
>> Which access permissions should apply to files you mmap, file handles
>> you have open, the core dumper etc.
>>
>> We do allow setresuid per thread so we might be able to cope
>> with a process that mixes with user namespaces in different threads,
>> but I would want a close review of things before we allow that kind of
>> sharing.
>>
>
> Fair enough.
>
> I'd personally be more concerned about shared signal handlers than
> shared tgid, though.  The signal handler set has all kinds of weird
> things like session id.

CLONE_THREAD implies CLONE_VM and CLONE_SIGNAL,
and in practice mm_users > 1 protects against all of those cases.

So I was really thinking all of those cases.


>> (See the end.  A significant bug in cap_capable slipped in about
>>  3.5. cap_capable is only supposed to grant permissions to the owner
>>  of a user namespace if it is a child user namespace).
>
> [snipping lots of stuff]
>
> If the intended semantics of cap_capable are, indeed:
>
> If targ_ns is equals or is a descendent of cred->user_ns and the cap
> is effective, return true.  If targ_ns is owned by cred->euid and
> targ_ns is a descendent of cred->user_ns (but is not equal to
> cred->user_ns), then return true.  Else return false
>
> then I agree with you on almost everything you said.  I assumed that
> the actual semantics were intended.

Good.

>>> unshare has a bug.  This code:
>>
>> Interesting...
>>
>> Looking at it this is a very small misfeature.
>>
>> What is happening is that commit_creds is setting is making the task
>> undumpable because we changed the set of capabilities in struct cred.
>>
>> This in turn results in pid_revalidate setting the owner of
>> of /proc/self/uid_map to GLOBAL_ROOT_UID.
>>
>> From the outside the permissions on /proc/self/uid_map look like:
>> -rw-r--r-- 1 root root 0 2012-12-13 12:43 /proc/30530/uid_map
>>
>> Then since /proc/self/uid_map uses the default permission function
>> and the test program below is not run as root the read-write open
>> of uid_map fails.
>
> It's probably either worth fixing this or disabling unshare of userns.
>  This makes it hard to use.  IMO non-dumpable tasks should still be
> able to access the contents of /proc/self -- i.e. I'd call this a more
> general bug.
>
> But I'd also argue that unsharing userns shouldn't set non-dumpable --
> cap_permitted increased, but the new capabilities are still logically
> a subset of the old ones.

Agreed.  Setting dumpable is the bug.

I am going to sleep on it but the code in commit_creds should probably
read:

	/* dumpability changes */
	if (!uid_eq(old->euid, new->euid) ||
	    !gid_eq(old->egid, new->egid) ||
	    !uid_eq(old->fsuid, new->fsuid) ||
	    !gid_eq(old->fsgid, new->fsgid) ||
	    ((old->user_ns == new->user_ns) &&
	     !cap_issubset(new->cap_permitted, old->cap_permitted))) {
		if (task->mm)
			set_dumpable(task->mm, suid_dumpable);
		task->pdeath_signal = 0;
		smp_wmb();
	}

Which is correct assuming a user_ns change is always to a more nested
user namespace.

> One more issue: the requirement that both upper and lower uids (etc.)
> in the maps are in order is rather limiting.  I have no objection if
> you only require upper ids to be monotonic, but currently there's no
> way to may root outside to uid n (for n > 0) and some nonroot user
> outside to uid 0.

There is.  You may set up to 5 (extents).  You just have to use a second
extent for the non-contiguous bits.  My reader is lazy and you have to
set all of the extents with a single write, so you may have missed the
ability to set more than one extent.

> Also, the fact that you can remap onto the unmapped id is a little
> strange.  I haven't found any reason it would be a security bug, but
> it's still odd.

Yes the unmapped id is odd.  Including the fact it can be set with a
sysctl.

The world has such lovely round edges.

Eric

