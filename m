Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1CAVka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:40:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754185Ab1CAVk3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <20110301204739.GA30406@redhat.com>
References: <20101130200129.GG11905@redhat.com> <compat-not-unlikely@mdm.bga.com>
 <20101201182747.GB6143@redhat.com> <20110225175202.GA19059@redhat.com>
 <20110225175314.GD19059@redhat.com> <AANLkTik8epq5cx8n=k6ocMUfbg9kkUAZ8KL7ZiG4UuoU@mail.gmail.com>
 <20110226123731.GC4416@redhat.com> <AANLkTinFVCR_znYtyVuJcjFQq_fgMp+ozbSz54UKzvQ_@mail.gmail.com>
 <20110226174408.GA17442@redhat.com> <20110301204739.GA30406@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 Mar 2011 13:39:35 -0800
Message-ID: <AANLkTikVecxcGoZ9a4hmkoi4wynrNfH9_AU7Vb+hOvbH@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] exec: unify native/compat code
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>, Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 12:47 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>        where that 'do_execve_common()' takes it's arguments as
>
>                union conditional_user_ptr_t __user *argv,
>                union conditional_user_ptr_t __user *envp
>
> I hope you didn't really mean this...

I really did mean that (although not the double "union" + "_t" thing
for the typedef).

But I'm not going to claim that it has to be done exactly that way,
the union can certainly be encapsulated differently too.

So I'm ok with your alternative

>        typedef union {
>                const char __user *const __user *native;
>                compat_uptr_t __user *compat;
>        } conditional_user_ptr_t;

model instead, which moves the pointer into the union.

However, if you do this, then I have one more suggestion: just move
the "compat" flag in there too!

Every time you pass the union, you're going to pass the compat flag to
distinguish the cases. So do it like this:

  struct conditional_ptr {
    int is_compat;
    union {
      const char __user *const __user *native;
      compat_uptr_t __user *compat;
    };
  };

and it will all look much cleaner, I bet.

                        Linus
