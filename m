Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab1CQJSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 05:18:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43605 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1CQJSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 05:18:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GIBv3kd8Eb6NP4AkPwuq0GNo2cJSuvDwsnRkgZAyTrCKIrdG8B+68Av4jz7GE8yEld
         OkqLS+ygpYEJq4oXy65DxPkqoYNS17oDvEYrnNOXiPzOo+kgMJ/ui/McQMeEbiVp8t1L
         mFBSQnViQZx1ar4NmwiL1FWj6g+jmlR1YhAV4=
MIME-Version: 1.0
In-Reply-To: <1300169637-1628-1-git-send-email-ratbert.chuang@gmail.com>
References: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com> <1300169637-1628-1-git-send-email-ratbert.chuang@gmail.com>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu, 17 Mar 2011 17:18:00 +0800
Message-ID: <AANLkTimOakgzK9LB6g8ibEZ_rr9=ZJw+4aS5Xz3F=J7Z@mail.gmail.com>
Subject: Re: [PATCH v2] arm: cmpxchg syscall should data abort if page not write
To: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, tony@atomide.com, nicolas.pitre@linaro.org,
        joe@perches.com, Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell King,

On Tue, Mar 15, 2011 at 2:13 PM, Po-Yu Chuang <ratbert.chuang@gmail.com> wrote:
>
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>
> If the page to cmpxchg is user mode read only (not write),
> we should simulate a data abort first.
>
> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
> ---
> v2:
> remove !pte_young() check
>
>  arch/arm/kernel/traps.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
> index 446aee9..eac7c05 100644
> --- a/arch/arm/kernel/traps.c
> +++ b/arch/arm/kernel/traps.c
> @@ -563,7 +563,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
>                if (!pmd_present(*pmd))
>                        goto bad_access;
>                pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> -               if (!pte_present(*pte) || !pte_dirty(*pte)) {
> +               if (!pte_present(*pte) || !pte_write(*pte) || !pte_dirty(*pte)) {
>                        pte_unmap_unlock(pte, ptl);
>                        goto bad_access;
>                }
> --
> 1.6.3.3
>

I think maybe I should describe more details of the problem.
Here is the story.

There is a lock with value 0. After fork(), the page containing the lock
becomes user mode read only for COW later. Process 0 writes 1 to
the lock with cmpxchg syscall. This write should cause COW.
The value of lock of Process 0 should become 1 and the value of lock
of Porcess 1 should still be 0 in the COWed page.

(CORRECT)

P0:lock=0
P0:fork
P0:cmpxchg -> COW
P0:lock=1	P1:lock=0

However, because cmpxchg syscall did not check user mode read only,
it wrote 1 to the lock value directly. After returning to user mode,
Process 0 wrote another variable, say foo, on the same page and
caused COW. The value of lock of Process 1 became 1 which is
incorrect.

(INCORRECT)

P0:lock=0
P0:fork
P0:cmpxchg
P0:lock=1
P0:foo=123 -> COW
P0:lock=1	P1:lock=1

best regards,
Po-Yu Chuang
