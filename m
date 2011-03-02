Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1CBQgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:36:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab1CBQgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:36:22 -0500
Date: Wed, 2 Mar 2011 17:26:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Subject: [PATCH v3 0/4] exec: unify native/compat code
Message-ID: <20110302162650.GA26810@redhat.com>
References: <compat-not-unlikely@mdm.bga.com> <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com> <20110225175314.GD19059@redhat.com> <AANLkTik8epq5cx8n=k6ocMUfbg9kkUAZ8KL7ZiG4UuoU@mail.gmail.com> <20110226123731.GC4416@redhat.com> <AANLkTinFVCR_znYtyVuJcjFQq_fgMp+ozbSz54UKzvQ_@mail.gmail.com> <20110226174408.GA17442@redhat.com> <20110301204739.GA30406@redhat.com> <AANLkTikVecxcGoZ9a4hmkoi4wynrNfH9_AU7Vb+hOvbH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikVecxcGoZ9a4hmkoi4wynrNfH9_AU7Vb+hOvbH@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01, Linus Torvalds wrote:
>
> So I'm ok with your alternative
>
> >        typedef union {
> >                const char __user *const __user *native;
> >                compat_uptr_t __user *compat;
> >        } conditional_user_ptr_t;
>
> model instead, which moves the pointer into the union.
>
> However, if you do this, then I have one more suggestion: just move
> the "compat" flag in there too!
>
> Every time you pass the union, you're going to pass the compat flag to
> distinguish the cases. So do it like this:
>
>   struct conditional_ptr {
>     int is_compat;
>     union {
>       const char __user *const __user *native;
>       compat_uptr_t __user *compat;
>     };
>   };
>
> and it will all look much cleaner, I bet.

Heh. I knew. I swear, I knew you would suggest this ;)

OK, please find v3. I had to deanonymize the union though, otherwise
the initializer in do_execve() becomes nontrivial.



But I don't think this is right. Not only this adds 200 bytes to exec.o.
To me, is_compat is not the private property of argv/envp. Yes, currently
nobody except get_arg_ptr() needs to know the difference. But who knows,
it is possible that we will need more "if (compat)" code in future. IOW,
I think that the explicit argument is a win.

Never mind. I agree with everything as long as we can remove this c-a-p
compat_do_execve().

Oleg.

