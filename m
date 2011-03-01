Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab1CAU4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:56:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393Ab1CAU4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:56:41 -0500
Date: Tue, 1 Mar 2011 21:47:39 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Subject: [PATCH v2 0/5] exec: unify native/compat code
Message-ID: <20110301204739.GA30406@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com> <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com> <20110225175314.GD19059@redhat.com> <AANLkTik8epq5cx8n=k6ocMUfbg9kkUAZ8KL7ZiG4UuoU@mail.gmail.com> <20110226123731.GC4416@redhat.com> <AANLkTinFVCR_znYtyVuJcjFQq_fgMp+ozbSz54UKzvQ_@mail.gmail.com> <20110226174408.GA17442@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110226174408.GA17442@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Oleg Nesterov wrote:
>
> On 02/26, Linus Torvalds wrote:
> >
> > See? The advantage of the union is that the types are correct, which
> > means that the casts are unnecessary.
>
> My point was, apart from the trivial get_arg_ptr() helper, nobody else
> uses this argv/envp, so I thought it is OK to drop the type info and
> use "void *".
>
> But as I said, I won't insist. I'll redo/resend.

Well, yes... But it turns out I didn't actually read what you proposed.

	typedef union {
		compat_uptr_t compat;
		const char __user *native;
	} conditional_user_ptr_t;

	...

	where that 'do_execve_common()' takes it's arguments as

		union conditional_user_ptr_t __user *argv,
		union conditional_user_ptr_t __user *envp

I hope you didn't really mean this...

OK, we have two kinds of pointers, the union makes sense. But I think
we do not want the 3rd kind, pointer to the union. This can't help to
avoid the casts. Yes, get_arg_ptr() can do

	&argv->native

but this still means the cast even if looks differently (and tricky).

And. How can we pass "argv" from do_execve() to do_execve_common() ?
We need another cast.

So. If you insist you prefer the pointer to the union - no need to
convince me. Just say this and I'll redo again.

This patch does:

	typedef union {
		const char __user *const __user *native;
		compat_uptr_t __user *compat;
	} conditional_user_ptr_t;

	static int do_execve_common(const char *filename,
			conditional_user_ptr_t argv,
			conditional_user_ptr_t envp,
			struct pt_regs *regs, bool compat)

get_arg_ptr() does argv.native/compat, this looks more understandable.

Do you agree?

copy_strings_kernel() still needs the cast, but this is only because
we want to add "__user" for annotation.

Oleg.

