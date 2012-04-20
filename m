Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2DTXBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:01:35 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37184 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab2DTXBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:01:33 -0400
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
	<1333862139-31737-18-git-send-email-ebiederm@xmission.com>
	<20120418184936.GC4984@mail.hallyn.com>
Date: Fri, 20 Apr 2012 16:05:34 -0700
In-Reply-To: <20120418184936.GC4984@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 18 Apr 2012 18:49:36 +0000")
Message-ID: <m1vcku57i9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/6DDFrdMAkRGs9m0/JChSa9kTKtX+edLk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 18/43] userns: Convert group_info values from gid_t to kgid_t.
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
>> As a first step to converting struct cred to be all kuid_t and kgid_t
>> values convert the group values stored in group_info to always be
>> kgid_t values.   Unless user namespaces are used this change should
>> have no effect.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>>  arch/s390/kernel/compat_linux.c   |   13 ++++++++-
>>  fs/nfsd/auth.c                    |    5 ++-
>>  fs/proc/array.c                   |    5 +++-
>>  include/linux/cred.h              |    9 ++++---
>>  kernel/groups.c                   |   48 +++++++++++++++++++-----------------
>>  kernel/uid16.c                    |   14 +++++++++-
>>  net/ipv4/ping.c                   |   11 ++++++--
>>  net/sunrpc/auth_generic.c         |    4 +-
>>  net/sunrpc/auth_gss/svcauth_gss.c |    7 ++++-
>>  net/sunrpc/auth_unix.c            |   15 ++++++++---
>>  net/sunrpc/svcauth_unix.c         |   18 ++++++++++---
>>  security/keys/permission.c        |    3 +-
>>  12 files changed, 103 insertions(+), 49 deletions(-)
>> 
>> diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
>> index ab64bdb..5baac18 100644
>> --- a/arch/s390/kernel/compat_linux.c
>> +++ b/arch/s390/kernel/compat_linux.c
>> @@ -173,11 +173,14 @@ asmlinkage long sys32_setfsgid16(u16 gid)
>>  
>>  static int groups16_to_user(u16 __user *grouplist, struct group_info *group_info)
>>  {
>> +	struct user_namespace *user_ns = current_user_ns();
>>  	int i;
>>  	u16 group;
>> +	kgid_t kgid;
>>  
>>  	for (i = 0; i < group_info->ngroups; i++) {
>> -		group = (u16)GROUP_AT(group_info, i);
>> +		kgid = GROUP_AT(group_info, i);
>> +		group = (u16)from_kgid_munged(user_ns, kgid);
>>  		if (put_user(group, grouplist+i))
>>  			return -EFAULT;
>>  	}
>> @@ -187,13 +190,19 @@ static int groups16_to_user(u16 __user *grouplist, struct group_info *group_info
>>  
>>  static int groups16_from_user(struct group_info *group_info, u16 __user *grouplist)
>>  {
>> +	struct user_namespace *user_ns = current_user_ns();
>>  	int i;
>>  	u16 group;
>
> need
>
> 	kgid_t kgid;
>
> here

Doh!  Thank you.

Now I am wondering why s390 has it's own copy of this function instead
of using the version in uid16.c.

>>  	for (i = 0; i < group_info->ngroups; i++) {
>>  		if (get_user(group, grouplist+i))
>>  			return  -EFAULT;
>> -		GROUP_AT(group_info, i) = (gid_t)group;
>> +
>> +		kgid = make_kgid(user_ns, (gid_t)group);
>> +		if (!gid_valid(kgid))
>> +			return -EINVAL;
>> +
>> +		GROUP_AT(group_info, i) = kgid;
>>  	}
>>  
>>  	return 0;

Eric
