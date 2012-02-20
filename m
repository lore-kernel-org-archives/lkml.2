Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2BTR2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:28:48 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53895 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2BTR2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:28:46 -0500
Message-ID: <4F4282CA.5010502@twiddle.net>
Date: Mon, 20 Feb 2012 09:28:42 -0800
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>
CC: Michel Lespinasse <walken@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>
Subject: Re: alpha: futex regression bisected
References: <4F420256.2090600@orcon.net.nz>
In-Reply-To: <4F420256.2090600@orcon.net.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/12 00:20, Michael Cree wrote:
> I have noticed some user space problems (pulseaudio crashes in pthread
> code, glibc/nptl test suite failures, java compiler freezes on SMP alpha
> systems) that arise when using a 2.6.39 or later kernel on Alpha.
> Bisecting between 2.6.38 and 2.6.39 (using glibc/nptl test suite as
> criterion for good/bad kernel) eventually leads to:
> 
> 8d7718aa082aaf30a0b4989e1f04858952f941bc is the first bad commit
> commit 8d7718aa082aaf30a0b4989e1f04858952f941bc
> Author: Michel Lespinasse <walken@google.com>
> Date:   Thu Mar 10 18:50:58 2011 -0800
> 
>     futex: Sanitize futex ops argument types
> 
>     Change futex_atomic_op_inuser and futex_atomic_cmpxchg_inatomic
>     prototypes to use u32 types for the futex as this is the data type the
>     futex core code uses all over the place.


futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
                              u32 oldval, u32 newval)
...
        :       "r"(uaddr), "r"((long)oldval), "r"(newval)


There is no 32-bit compare instruction.  These are implemented by
consistently extending the values to a 64-bit type.  Since the
load instruction sign-extends, we want to sign-extend the other
quantity as well (despite the fact it's logically unsigned).

So:

-        :       "r"(uaddr), "r"((long)oldval), "r"(newval)
+        :       "r"(uaddr), "r"((long)(int)oldval), "r"(newval)

should do the trick.


r~
