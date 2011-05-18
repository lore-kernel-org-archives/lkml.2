Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1ERINI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 04:13:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37868 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab1ERINF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 04:13:05 -0400
Date: Wed, 18 May 2011 10:12:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brian Gerst <brgerst@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86, x86_64: Fix checks for userspace address limit
Message-ID: <20110518081254.GC14805@elte.hu>
References: <1305210630-7136-1-git-send-email-jolsa@redhat.com>
 <20110516114254.GI19837@elte.hu>
 <BANLkTik44F2sWkGvN+6oJBszZ0SPfLjbrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik44F2sWkGvN+6oJBszZ0SPfLjbrg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Brian Gerst <brgerst@gmail.com> wrote:

> On Mon, May 16, 2011 at 7:42 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Jiri Olsa <jolsa@redhat.com> wrote:
> >
> >> hi,
> >> there seems to be bug in the _copy_to_user and _copy_from_user
> >> functions, not allowing access to the last user page.
> >>
> >> Also I tried to decipher the inline assembly in __range_not_ok,
> >> and it seems to work properly, but the macro comment seems to
> >> be misleading.
> >>
> >> wbr,
> >> jirka
> >>
> >> ---
> >> As shown in BZ 30352 (https://bugzilla.kernel.org/show_bug.cgi?id=30352)
> >> there's an issue with reading last allowed page on x86_64.
> >>
> >> The _copy_to_user and _copy_from_user functions use following
> >> check for address limit:
> >>
> >> if (buf + size >= limit)
> >>       fail
> >>
> >> while it should be:
> >>
> >> if (buf + size > limit)
> >>       fail
> >>
> >> That's because the size represents the number of bytes being
> >> read/write from/to buf address AND including the buf address.
> >> So the copy function will actually never touch the limit
> >> address even if "buf + size == limit".
> >>
> >> Following program fails to use the last page as buffer
> >> due to the wrong limit check.
> >>
> >> ---
> >> #include <sys/mman.h>
> >> #include <sys/socket.h>
> >> #include <assert.h>
> >>
> >> #define PAGE_SIZE       (4096)
> >> #define LAST_PAGE       ((void*)(0x7fffffffe000))
> >>
> >> int main()
> >> {
> >>         int fds[2], err;
> >>         void * ptr = mmap(LAST_PAGE, PAGE_SIZE, PROT_READ | PROT_WRITE,
> >>                           MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> >>         assert(ptr == LAST_PAGE);
> >>         err = socketpair(AF_LOCAL, SOCK_STREAM, 0, fds);
> >>         assert(err == 0);
> >>         err = send(fds[0], ptr, PAGE_SIZE, 0);
> >>         perror("send");
> >>         assert(err == PAGE_SIZE);
> >>         err = recv(fds[1], ptr, PAGE_SIZE, MSG_WAITALL);
> >>         perror("recv");
> >>         assert(err == PAGE_SIZE);
> >>         return 0;
> >> }
> >> ---
> >>
> >> Other place checking the addr limit is access_ok function,
> >> which is working properly. There's just misleading comment
> >> for the __range_not_ok macro.
> >>
> >>
> >> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> >> ---
> >>  arch/x86/include/asm/uaccess.h |    2 +-
> >>  arch/x86/lib/copy_user_64.S    |    4 ++--
> >>  2 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
> >> index abd3e0e..99f0ad7 100644
> >> --- a/arch/x86/include/asm/uaccess.h
> >> +++ b/arch/x86/include/asm/uaccess.h
> >> @@ -42,7 +42,7 @@
> >>   * Returns 0 if the range is valid, nonzero otherwise.
> >>   *
> >>   * This is equivalent to the following test:
> >> - * (u33)addr + (u33)size >= (u33)current->addr_limit.seg (u65 for x86_64)
> >> + * (u33)addr + (u33)size > (u33)current->addr_limit.seg (u65 for x86_64)
> >>   *
> >>   * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
> >>   */
> >> diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
> >> index 99e4826..a73397f 100644
> >> --- a/arch/x86/lib/copy_user_64.S
> >> +++ b/arch/x86/lib/copy_user_64.S
> >> @@ -72,7 +72,7 @@ ENTRY(_copy_to_user)
> >>       addq %rdx,%rcx
> >>       jc bad_to_user
> >>       cmpq TI_addr_limit(%rax),%rcx
> >> -     jae bad_to_user
> >> +     ja bad_to_user
> >>       ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
> >>       CFI_ENDPROC
> >>  ENDPROC(_copy_to_user)
> >> @@ -85,7 +85,7 @@ ENTRY(_copy_from_user)
> >>       addq %rdx,%rcx
> >>       jc bad_from_user
> >>       cmpq TI_addr_limit(%rax),%rcx
> >> -     jae bad_from_user
> >> +     ja bad_from_user
> >>       ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
> >>       CFI_ENDPROC
> >>  ENDPROC(_copy_from_user)
> >
> > Hm, something tickles me about this area that we would reintroduce a security
> > hole, that we really wanted to treat the last page of user-space as some sort
> > of guard page but i cannot quite remember it why ...
> >
> > IIRC Linus wrote bits of this so i'm Cc:-ing him just in case he remembers.
> >
> > Thanks,
> >
> >        Ingo
> 
> The guard page is apparently due to an erratum on K8 cpus (#121
> Sequential Execution Across Non-Canonical Boundary
> Causes Processor Hang).  However, his test code is using the last
> valid page before the guard page.  The bug is that the last byte
> before the guard page can't be read because of the off-by-one error.

Ok, so if you otherwise agree with the change then Jiri please update the 
changelog with this information and Brian's Acked-by.

Thanks,

	Ingo
