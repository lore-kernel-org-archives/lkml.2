Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab2AXVqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:46:38 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52082 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2AXVqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:46:36 -0500
Date: Wed, 25 Jan 2012 01:46:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
Message-ID: <20120124214630.GF2546@moon>
References: <20120124071716.GC29735@moon>
 <20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124073842.GE29735@moon>
 <20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124084823.GF29735@moon>
 <CAHGf_=r=zwj4=yjCekYZVRsTwjohJ8F8cP4rnZx6UL9kKNTc+g@mail.gmail.com>
 <20120124202606.GC2546@moon>
 <m18vkwj0dw.fsf@fess.ebiederm.org>
 <20120124205039.GB2278@moon>
 <20120124132222.d78bc0d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124132222.d78bc0d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 01:22:22PM -0800, Andrew Morton wrote:
> 
> PIDs are not unique.  One wonders what happens in this syscall if the
> same pid appears in two namespaces.
> 
> <reads the code>
> 
> Seems that it performs lookups only in the caller's PID namespace. 
> Maybe this is appropriate but it should be described and justified in
> the changelog and in code comments, please.  And in the forthcoming
> manpage ;)
> 

Yes, caller's namespace was used intentionally, will add comments (manpage
makes me shiver).

> > At moment only x86 is supported.
> 
> Presumably you have a test app.  Please let's include that app in
> tools/testing/selftests/ for arch maintainers and others to use and
> maintain.

ok

> > +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
> 
> This reader of this code doesn't understand why all this cookie stuff
> is in here.  Please include code comments which explain the reason for
> the existence of this code.
> 

ok

> > +static long kptr_obfuscate(long v, int type)
> > +{
> > +	return (v ^ cookies[type][0]) * cookies[type][1];
> > +}
> > +
> > +/*
> > + * 0 - equal
> > + * 1 - less than
> > + * 2 - greater than
> > + * 3 - not equal but ordering unavailable
> 
> what the heck does case 3 mean?  Why is it here?
> 

I'll add a comment. It's reserved for case where we might
need to disable gt/lt comparision result. Probably in future.

> > +
> > +#define KCMP_PTR(ptr1, ptr2, type)			\
> > +	kcmp_ptr((long)ptr1, (long)ptr2, type)
> 
> ugh.  This:
> 
> static long kptr_obfuscate(void *p, enum you_forgot_to_name_the_enum type)
> {
> 	return ((long)p ^ cookies[type][0]) * cookies[type][1];
> }
> 
> static int kcmp_task_pointers(void *task1, void *task2, size_t field_offset,
> 				enum you_forgot_to_name_the_enum type)
> {
> 	void **field1 = t1 + field_offset;	/* points to a pointer in the task_struct */
> 	void **field2 = t1 + field_offset;
> 	long diff;
> 
> 	diff = kptr_obfuscate(*field1, type) - kptr_obfuscate(*field2, type);
> 	return (diff < 0) | ((diff > 0) << 1);
> }
> 
> 	...
> 	ret = kcmp_task_pointers(task1, task2, offsetof(task_struct, mm),
> 				KCMP_VM);
> 	...
> 
> see?  No nasty macros, it's type-correct and it uses only a single
> explicit typecast.
> 

ok, i'll change it of course, but I personally like macros version more.

> > +/* A caller must be sure the task is presented in memory */
> "The caller must have pinned the task"
> 
> > +	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
> > +	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
> 
> Add a comment explaining this decision.
> 

OK.

> 
> ENOENT seems inappropriate here.
>

Which one should be better?

> > +static __init int kcmp_cookie_init(void)
> > +{
> > +	int i, j;
> > +
> > +	for (i = 0; i < KCMP_TYPES; i++) {
> > +		for (j = 0; j < 2; j++) {
> > +			get_random_bytes(&cookies[i][j],
> > +					 sizeof(cookies[i][j]));
> > +		}
> > +		cookies[i][1] |= (~(~0UL >>  1) | 1);
> 
> hm, what's the point in writing a random number to cookies[i][1] and
> then immediately overwriting that with a constant?

It's '|=' , not '='.

	Cyrill
