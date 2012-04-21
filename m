Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab2DUAyh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:54:37 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:58146 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2DUAyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:54:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <m11unyn70b.fsf@fess.ebiederm.org>
	<1333862139-31737-27-git-send-email-ebiederm@xmission.com>
	<20120418190337.GE5186@mail.hallyn.com>
Date: Fri, 20 Apr 2012 17:58:35 -0700
In-Reply-To: <20120418190337.GE5186@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 18 Apr 2012 19:03:37 +0000")
Message-ID: <m1sjfx2950.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+xgUxoZhW3MTnxt4GYcNw3X0WngNOwI8o=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 27/43] userns: Use uid_eq gid_eq helpers when comparing kuids and kgids in the vfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Beiderman (ebiederm@xmission.com):
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>>  fs/attr.c                |    8 ++++----
>>  fs/exec.c                |   10 +++++-----
>>  fs/fcntl.c               |    6 +++---
>>  fs/ioprio.c              |    4 ++--
>>  fs/locks.c               |    2 +-
>>  fs/namei.c               |    8 ++++----
>>  include/linux/quotaops.h |    4 ++--
>>  7 files changed, 21 insertions(+), 21 deletions(-)
>> 

>> @@ -2120,7 +2120,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>>  	if (__get_dumpable(cprm.mm_flags) == 2) {
>>  		/* Setuid core dump mode */
>>  		flag = O_EXCL;		/* Stop rewrite attacks */
>> -		cred->fsuid = 0;	/* Dump root private */
>> +		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
>
> Sorry, one more - can this be the per-ns root uid?  The coredumps should
> be ok to belong to privileged users in the namespace right?

I'm not certain it was clear when you were looking at this that
this is about dumping core from suid applications, not normal
applications. 

 Looking at the code in commoncap and commit_creds it looks like it is a
bug that we don't call set_dumpable(new, suid_dumpable) in common cap
when we use file capabilities.  I might be wrong but I think we escape
the test in commit_creds in that case.


Having thought about it we can make this per namespace but not in
this patch.

Things that I see as missing.
- We likely need to make the suid_dumpable sysctl per namespace.
  There is a prctl so it is already per process.
- We would need to capture the user_namespace at mm creation time,
  during exec, so we know which root user we could use.

  By it's nature we know an mm can't escape a user namespace so the
  user namespace an mm is created in will have a root user we can
  dump core as.

I was wondering if we could relax this to a uid captured at mm creation
time (and certainly we can capture the root user), but there are enough
weird cases I don't think it is possible to safely allow anything more
relaxed that the root of the user_namespace that created the mm.

I don't believe we can't use the user_namespace of current because the
application may have been suid and then cloned a new user namespace
keeping the mm or perhaps just the uid/euid split.

So in short it is doable but a little tricky so it doesn't belong in
a patch with a bunch of boring and safe conversions.

Eric
