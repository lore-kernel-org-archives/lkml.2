Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab2DXThS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 15:37:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41556 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab2DXThP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 15:37:15 -0400
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
	<1333862139-31737-16-git-send-email-ebiederm@xmission.com>
	<20120418184847.GA4984@mail.hallyn.com>
	<m1aa266meh.fsf@fess.ebiederm.org>
	<20120424173347.GA14017@mail.hallyn.com>
Date: Tue, 24 Apr 2012 12:41:15 -0700
In-Reply-To: <20120424173347.GA14017@mail.hallyn.com> (Serge E. Hallyn's
	message of "Tue, 24 Apr 2012 17:33:47 +0000")
Message-ID: <m14ns8lxyc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/zbM0VuP6jhnEqnoUCMH46fbyN/Vi/nsI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0636]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: **
Subject: Re: [PATCH 16/43] userns: Simplify the user_namespace by making userns->creator a kuid.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> "Serge E. Hallyn" <serge@hallyn.com> writes:
>> 
>> > Quoting Eric W. Beiderman (ebiederm@xmission.com):
>> >> From: Eric W. Biederman <ebiederm@xmission.com>
>> >> 
>> >> - Transform userns->creator from a user_struct reference to a simple
>> >>   kuid_t, kgid_t pair.
>> >> 
>> >>   In cap_capable this allows the check to see if we are the creator of
>> >>   a namespace to become the classic suser style euid permission check.
>> >> 
>> >>   This allows us to remove the need for a struct cred in the mapping
>> >>   functions and still be able to dispaly the user namespace creators
>> >>   uid and gid as 0.
>> >> 
>> >> - Remove the now unnecessary delayed_work in free_user_ns.
>> >> 
>> >>   All that is left for free_user_ns to do is to call kmem_cache_free
>> >>   and put_user_ns.  Those functions can be called in any context
>> >>   so call them directly from free_user_ns removing the need for delayed work.
>> >> 
>> >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> >> ---
>> >>  include/linux/user_namespace.h |    4 ++--
>> >>  kernel/user.c                  |    7 ++++---
>> >>  kernel/user_namespace.c        |   39 ++++++++++++++++++---------------------
>> >>  security/commoncap.c           |    5 +++--
>> >>  4 files changed, 27 insertions(+), 28 deletions(-)
>> >> 
>> >> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
>> >> index d767508..8a391bd 100644
>> >> --- a/include/linux/user_namespace.h
>> >> +++ b/include/linux/user_namespace.h
>> >> @@ -9,8 +9,8 @@
>> >>  struct user_namespace {
>> >>  	struct kref		kref;
>> >>  	struct user_namespace	*parent;
>> >> -	struct user_struct	*creator;
>> >> -	struct work_struct	destroyer;
>> >> +	kuid_t			owner;
>> >> +	kgid_t			group;
>> >>  };
>> >>  
>> >>  extern struct user_namespace init_user_ns;
>> >> diff --git a/kernel/user.c b/kernel/user.c
>> >> index 025077e..cff3856 100644
>> >> --- a/kernel/user.c
>> >> +++ b/kernel/user.c
>> >> @@ -25,7 +25,8 @@ struct user_namespace init_user_ns = {
>> >>  	.kref = {
>> >>  		.refcount	= ATOMIC_INIT(3),
>> >>  	},
>> >> -	.creator = &root_user,
>> >> +	.owner = GLOBAL_ROOT_UID,
>> >> +	.group = GLOBAL_ROOT_GID,
>> >>  };
>> >>  EXPORT_SYMBOL_GPL(init_user_ns);
>> >>  
>> >> @@ -54,9 +55,9 @@ struct hlist_head uidhash_table[UIDHASH_SZ];
>> >>   */
>> >>  static DEFINE_SPINLOCK(uidhash_lock);
>> >>  
>> >> -/* root_user.__count is 2, 1 for init task cred, 1 for init_user_ns->user_ns */
>> >> +/* root_user.__count is 1, for init task cred */
>> >>  struct user_struct root_user = {
>> >> -	.__count	= ATOMIC_INIT(2),
>> >> +	.__count	= ATOMIC_INIT(1),
>> >>  	.processes	= ATOMIC_INIT(1),
>> >>  	.files		= ATOMIC_INIT(0),
>> >>  	.sigpending	= ATOMIC_INIT(0),
>> >> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
>> >> index 898e973..f69741a 100644
>> >> --- a/kernel/user_namespace.c
>> >> +++ b/kernel/user_namespace.c
>> >> @@ -27,6 +27,16 @@ int create_user_ns(struct cred *new)
>> >>  {
>> >>  	struct user_namespace *ns, *parent_ns = new->user_ns;
>> >>  	struct user_struct *root_user;
>> >> +	kuid_t owner = make_kuid(new->user_ns, new->euid);
>> >> +	kgid_t group = make_kgid(new->user_ns, new->egid);
>> >> +
>> >> +	/* The creator needs a mapping in the parent user namespace
>> >> +	 * or else we won't be able to reasonably tell userspace who
>> >> +	 * created a user_namespace.
>> >> +	 */
>> >> +	if (!kuid_has_mapping(parent_ns, owner) ||
>> >> +	    !kgid_has_mapping(parent_ns, group))
>> >> +		return -EPERM;
>> >>  
>> >>  	ns = kmem_cache_alloc(user_ns_cachep, GFP_KERNEL);
>> >>  	if (!ns)
>> >> @@ -43,7 +53,9 @@ int create_user_ns(struct cred *new)
>> >>  
>> >>  	/* set the new root user in the credentials under preparation */
>> >>  	ns->parent = parent_ns;
>> >
>> > I think in the past the creator cred pinned the ns->parent.  Do you now
>> > need to explicitly pin ns->parent (and release it in free_user_ns())?
>> 
>> Yes we do have to explicitly reference count the parent namespace.
>> But that happened in the patch 7:
>> "userns: Add an explicit reference to the parent user namespace"

Make that patch 8 not patch 7: 
"userns: Add an explicit reference to the parent user namespace"
Perhaps the patch number reference pointed you to look at the wrong code.

> Perhaps that suffices, but I'm not convinced.  The struct cred is
> pinning it's own ns, but if t1 does clone(CLONE_NEWUSER) to produce
> t2, which does the same to procduce t3, and then t2 exits, I'm not
> seeing what will pin t2's userns.

t3's userns hold's a reference to the departed t2's userns.
t2's userns hold's a reference to t1's userns.

free_user_ns does put that userns reference.

It is all there and explict.  Usernamespaces refer directly to each
other.  That was all needed to get struct user out of the usernamespace
game.

Eric
