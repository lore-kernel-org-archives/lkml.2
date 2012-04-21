Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab2DUACA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 20:02:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60725 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2DUAB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 20:01:57 -0400
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
	<20120418190213.GD5186@mail.hallyn.com>
Date: Fri, 20 Apr 2012 17:05:56 -0700
In-Reply-To: <20120418190213.GD5186@mail.hallyn.com> (Serge E. Hallyn's
	message of "Wed, 18 Apr 2012 19:02:13 +0000")
Message-ID: <m1y5pq3q57.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18mtZvXN9IeqzgHg0EVdJW0U2UVvc9Fnuk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
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
>> diff --git a/fs/attr.c b/fs/attr.c
>> index 73f69a6..2f094c6 100644
>> --- a/fs/attr.c
>> +++ b/fs/attr.c
>> @@ -47,14 +47,14 @@ int inode_change_ok(const struct inode *inode, struct iattr *attr)
>>  
>>  	/* Make sure a caller can chown. */
>>  	if ((ia_valid & ATTR_UID) &&
>> -	    (current_fsuid() != inode->i_uid ||
>> -	     attr->ia_uid != inode->i_uid) && !capable(CAP_CHOWN))
>> +	    (!uid_eq(current_fsuid(), inode->i_uid) ||
>> +	     !uid_eq(attr->ia_uid, inode->i_uid)) && !capable(CAP_CHOWN))
>>  		return -EPERM;
>>  
>>  	/* Make sure caller can chgrp. */
>>  	if ((ia_valid & ATTR_GID) &&
>> -	    (current_fsuid() != inode->i_uid ||
>> -	    (!in_group_p(attr->ia_gid) && attr->ia_gid != inode->i_gid)) &&
>> +	    (!uid_eq(current_fsuid(), inode->i_uid) ||
>> +	    (!in_group_p(attr->ia_gid) && gid_eq(attr->ia_gid, inode->i_gid))) &&
>
> This should be !gid_eq() ?

Yes.  Thank you, it is now fixed in my tree.

Eric
