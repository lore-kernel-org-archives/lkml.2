Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2DNVQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 17:16:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52256 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab2DNVQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 17:16:07 -0400
MIME-Version: 1.0
In-Reply-To: <1334441685-4438-3-git-send-email-levinsasha928@gmail.com>
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com> <1334441685-4438-3-git-send-email-levinsasha928@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Apr 2012 14:15:46 -0700
X-Google-Sender-Auth: c_YYKE8zsQuT2R8w168XVJkIZVs
Message-ID: <CA+55aFxwqGBhZpfHC6eDr17OjrG_DSWcN_48jttjwUpAsFK6tg@mail.gmail.com>
Subject: Re: [RFC 2/3] sched: add type checks to for_each_cpu_mask()
To: Sasha Levin <levinsasha928@gmail.com>
Cc: akpm@linux-foundation.org, peterz@infradead.org, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 3:14 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> -#define for_each_cpu_mask(cpu, mask)   \
> +#define for_each_cpu_mask(cpu, mask)           \
> +       typecheck(struct cpumask *, (mask));    \
>        for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)

Stuff like this is *WRONG*.

You now totally broke

  if (xyzzy)
    for_each_cpu_mask() {
    }

because you turned the loop into two separate statements.

If this is needed, it needs to be done right. You could have done it by doing

  #define for_each_cpu_mask(cpu, mask)           \
      for (typecheck(struct cpumask *, (mask)), (cpu) = 0; (cpu) < 1; (cpu)++)

or similar (I think you can drop the (void)(mask) because the variable
is now used by the typecheck macro).

                 Linus
