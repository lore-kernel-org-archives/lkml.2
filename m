Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab1EEAJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 20:09:46 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32455 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab1EEAJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 20:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bE7+MT0FVEB00EpBMAH2ANBUugF/rs95tpdDsiEU+hqSlJpT9KCYsVBl+puWNVL2bS
         FuxvIeeIbooW7n4mqNjQ==
MIME-Version: 1.0
In-Reply-To: <BANLkTingV3eiHEco+36YyM4YTDHFHc9_jA@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
	<AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
	<AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
	<alpine.LSU.2.00.1103182158200.18771@sister.anvils>
	<BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
	<AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
	<BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com>
	<BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com>
	<BANLkTi=KTdLRC_hRvxfpFoMSbz=vOjpObw@mail.gmail.com>
	<BANLkTindeX9-ECPjgd_V62ZbXCd7iEG9_w@mail.gmail.com>
	<BANLkTikcZK+AQvwe2ED=b0dLZ0hqg0B95w@mail.gmail.com>
	<BANLkTimV1f1YDTWZUU9uvAtCO_fp6EKH9Q@mail.gmail.com>
	<BANLkTi=tavhpytcSV+nKaXJzw19Bo3W9XQ@mail.gmail.com>
	<alpine.LSU.2.00.1104060837590.4909@sister.anvils>
	<BANLkTi=-Zb+vrQuY6J+dAMsmz+cQDD-KUw@mail.gmail.com>
	<BANLkTim0MZfa8vFgHB3W6NsoPHp2jfirrA@mail.gmail.com>
	<BANLkTim-hyXpLj537asC__8exMo3o-WCLA@mail.gmail.com>
	<alpine.LSU.2.00.1104070718120.28555@sister.anvils>
	<BANLkTik_9YW5+64FHrzNy7kPz1FUWrw-rw@mail.gmail.com>
	<BANLkTiniyAN40p0q+2wxWsRZ5PJFn9zE0Q@mail.gmail.com>
	<BANLkTik6U21r91DYiUsz9A0P--=5QcsBrA@mail.gmail.com>
	<BANLkTim6ATGxTiMcfK5-03azgcWuT4wtJA@mail.gmail.com>
	<BANLkTiktvcBWsLKEk5iBYVEbPJS3i+U+hA@mail.gmail.com>
	<BANLkTikdM2kF=qOy4d4bZ_wfb5ykEdkZPQ@mail.gmail.com>
	<BANLkTikZ1szdH5HZdjKEEzG2+1VPusWEeg@mail.gmail.com>
	<BANLkTingV3eiHEco+36YyM4YTDHFHc9_jA@mail.gmail.com>
Date: Wed, 4 May 2011 17:09:40 -0700
Message-ID: <BANLkTi=D+oe_zyxA1Oj5S36F6Tk0J+26iQ@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, the attached code causes an infinite loop in kernels that have
the 95042f9eb7 commit:

#include <stdio.h>
#include <string.h>

#include <unistd.h>
#include <sys/syscall.h>
#include <linux/futex.h>

int *get_stack_guard(void)
{
  FILE *map;
  char buf[1000];

  map = fopen("/proc/self/maps", "r");
  if (!map)
    return NULL;
  while(fgets(buf, 1000, map)) {
    long a, b;
    char c[1000], d[1000], e[1000], f[1000], g[1000];
    if (sscanf(buf, "%lx-%lx %s %s %s %s %s", &a, &b, c, d, e, f, g) == 7 &&
        !strcmp(g, "[stack]")) {
      fclose(map);
      return (int *)(a - 4096);
    }
  }
  fclose(map);
  return NULL;
}

int main(void)
{
  int *uaddr = get_stack_guard();
  syscall(SYS_futex, uaddr, FUTEX_LOCK_PI_PRIVATE, 0, NULL, NULL, 0);
  return 0;
}

Linus, I am not sure as to what would be the preferred way to fix
this. One option could be to modify fault_in_user_writeable so that it
passes a non-NULL page pointer, and just does a put_page on it
afterwards. While this would work, this is kinda ugly and would slow
down futex operations somewhat. A more conservative alternative could
be to enable the guard page special case under an new GUP flag, but
this loses much of the elegance of your original proposal...

On Mon, Apr 18, 2011 at 2:15 PM, Michel Lespinasse <walken@google.com> wrote:
> This second patch looks more attractive than the first, but is also
> harder to prove correct. Hugh looked at all gup call sites and
> convinced himself that the change was safe, except for the
> fault_in_user_writeable() site in futex.c which he asked me to look
> at. I am worried that we would have an issue there, as places like
> futex_wake_op() or fixup_pi_state_owner() operate on user memory with
> page faults disabled, and expect fault_in_user_writeable() to set up
> the user page so that they can retry if the initial access failed.
> With this proposal, fault_in_user_writeable() would become inoperative
> when the  address is within the guard page; this could cause some
> malicious futex operation to create an infinite loop.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
