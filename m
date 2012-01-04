Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab2ADPbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:31:07 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:45783 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751111Ab2ADPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:31:04 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: RD3cq8kVM1m.gHeLp0XIXstyTUQ9Db8xOAO5UByOdyraO6a
 HkXf1t_ebxDTqMV5Ofi_x2txHm_cempL2Zl7KR79jqSoog_5blKaTlzXhrfk
 u_aS6uZ2dFGZ3rbyAGjF9DLHY3azrJjHFQltkHGPAbnKdxwiIOM.8peGAESf
 XeqYFYFmeOgzA.pjHWWmdvGHDw3h7boKG8Bp.fB.wk7bVZUFu6TGaFD6eA67
 1HtY6CjWyQZQBqS75M4SiSdSrMSCm1tVCmQJ0GYXGDXEa.G47_8W63QumWsC
 .ekpFPxyCv9BinbpP7dj1ghFsq3YF7kLfZRVkaX_m.PZ0Zh2cKZljTsgmDvX
 jvwqO8fhrJfWEXbSoEKbLkDtu_xyTlBFByNN9UcYbnJJ.Fg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 4 Jan 2012 09:30:59 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
In-Reply-To: <CA+55aFzCY7TyEgkWFn6wxUMjBBaKGcx0hdV6gTdta5u8eK=Ymg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1201040906090.27157@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain> <CA+55aFz23nN4EALZKf1uptn3a+LKU8wehEnxXO7WA8J5WAyPAQ@mail.gmail.com> <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com> <20111220162315.GC10752@google.com>
 <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com> <20111220202854.GH10752@google.com> <alpine.DEB.2.00.1112210851230.9601@router.home> <20111221170535.GB9213@google.com> <alpine.DEB.2.00.1112220854440.31315@router.home>
 <20111222160822.GE17084@google.com> <alpine.DEB.2.00.1112221154380.11787@router.home> <CA+55aFzY_6QYVyjAmP+w8D0Xy1Pq++XEUaBJRcCN9SbDE-pOhw@mail.gmail.com> <alpine.DEB.2.00.1112231031001.3482@router.home>
 <CA+55aFzCY7TyEgkWFn6wxUMjBBaKGcx0hdV6gTdta5u8eK=Ymg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011, Linus Torvalds wrote:

> You have two cases:
>
> Case 1: you actually know what CPU you are on, and the number may have
> some meaning. But in that case you are also *pinned* to that CPU, and
> there is no difference between
>
>    x = percpu_value;
>    x += y;
>    percpu_value = x;
>    .. look at 'x' .. to see what you did
>
> and
>
>     percpu_value += x;
>    ..look at percpu_value to see what you did ..
>
> and
>
>     x = xadd percpu_value,y
>
> so there are no "atomicity advantages" - xadd is the same as
> open-coding it. You are pinned to the CPU, all three ways are 100%
> equivalent.

As mentioned before the main point of the use of these operations (in the
form of __this_cpu_op_return) when the cpu is pinned is to reduce the
number of instructions. __this_cpu_add_return allows replacing ~ 5
instructions with one.

These operations are used in f.e. in vm statististics that have to scale
well and have the lightest possible impact on the rest of the vm code.

"atomicity advantages" were never claimed to exist for the __this_cpu_xx
operations.

>> The other case is:
>
> Case 2: you're not pinned to the CPU, and you just do statistics and
> add some value to memory. BUT NOW THE RESULT HAS ABSOLUTELY NO
> MEANING!
>
> Now "xadd" would possibly give different results from "add and read
> the result", since you migth be moving around between cpu's, but there
> is absolutely no way you could ever care, sine the value you read back
> is meaningless regardless of whether it's the return value of xadd, or
> the value from some other CPU. There are other cpu's with the same
> percpu variable, and they are all equivalent as far as you are
> concerned, because you're not pinned to one of them.

You would care if you had special actions that have to be triggered on all
processors if for example a threshold was breached on a single processors
counters (and one would fold all differentials into a global counter) or a
per cpu counter reaches zero (and one would need to replenish lists of
objects or some such thing). In that case it matters that the operational
result be checked later regardless of the cpu we are on right now.

There are no use cases of the this_cpu_xx_return operations as far as I
can see so we could remove those.

