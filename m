Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0LQT06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:26:58 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40829 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab0LQT05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:26:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <20101217152246.GA8221@mail.hallyn.com>
	<20101217152458.GA11162@mail.hallyn.com>
	<20101217173125.GA29982@kroah.com>
Date: Fri, 17 Dec 2010 11:26:50 -0800
In-Reply-To: <20101217173125.GA29982@kroah.com> (Greg KH's message of "Fri, 17
	Dec 2010 09:31:25 -0800")
Message-ID: <m18vzoryit.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+C+nPb6pVdn+hzF1qF2/qH63OCFkkgeZ8=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC 1/5] user namespaces: Add a user_namespace as creator/owner of uts_namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:

> On Fri, Dec 17, 2010 at 03:24:58PM +0000, Serge E. Hallyn wrote:
>> copy_process() handles CLONE_NEWUSER before the rest of the
>> namespaces.  So in the case of clone(CLONE_NEWUSER|CLONE_NEWUTS)
>> the new uts namespace will have the new user namespace as its
>> owner.  That is what we want, since we want root in that new
>> userns to be able to have privilege over it.
>> 
>> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
>> ---
>>  include/linux/utsname.h |    3 +++
>>  init/version.c          |    2 ++
>>  kernel/nsproxy.c        |    3 +++
>>  kernel/user.c           |    8 ++++++--
>>  kernel/utsname.c        |    4 ++++
>>  5 files changed, 18 insertions(+), 2 deletions(-)
>> 
>> diff --git a/include/linux/utsname.h b/include/linux/utsname.h
>> index 69f3997..85171be 100644
>> --- a/include/linux/utsname.h
>> +++ b/include/linux/utsname.h
>> @@ -37,9 +37,12 @@ struct new_utsname {
>>  #include <linux/nsproxy.h>
>>  #include <linux/err.h>
>>  
>> +struct user_namespace;
>> +
>>  struct uts_namespace {
>>  	struct kref kref;
>>  	struct new_utsname name;
>> +	struct user_namespace *user_ns;
>>  };
>>  extern struct uts_namespace init_uts_ns;
>>  
>> diff --git a/init/version.c b/init/version.c
>> index 79fb8c2..9eb19fb 100644
>> --- a/init/version.c
>> +++ b/init/version.c
>> @@ -21,6 +21,7 @@ extern int version_string(LINUX_VERSION_CODE);
>>  int version_string(LINUX_VERSION_CODE);
>>  #endif
>>  
>> +extern struct user_namespace init_user_ns;
>>  struct uts_namespace init_uts_ns = {
>>  	.kref = {
>>  		.refcount	= ATOMIC_INIT(2),
>
> Wait, WTF?
>
> You have a static kref and you try to automatically instanciate it here?
> As it's static, why are you even having a kref at all, what good does it
> do you, you can't delete the thing, it's always around, so just remove
> it entirely please.
>
> Or, dynamically create it properly.  In other words, this is majorly
> broken.

There is a very weird case for the data structures the initial task has
references to.  The initial task never goes away and so those data
structure never go away.  Furthermore we need many of those data
structures before we have a memory allocator ready.  So we statically
allocate a single data structure and up it's reference count to ensure
that the count never goes to zero.

There are also major benefits to have the version of something that is
never freed never going away, because it means you can just reference it
in code.  So while I would be happy to say this is special don't use a
kref and roll the reference counting logic by hand, we aren't
dynamically allocating init_uts_ns any time soon.

Eric
