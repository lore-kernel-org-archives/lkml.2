Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2CKJ53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 05:57:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34921 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab2CKJ51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 05:57:27 -0400
Date: Sun, 11 Mar 2012 10:56:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Solar Designer <solar@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        Stephen Wilson <wilsons@start.ca>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH 1/9] exec: add a global execve counter
Message-ID: <20120311095658.GA15121@elte.hu>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
 <CA+55aFzTXuvpqjDUtjN48cc3RWADryddVXxc2RQhj6sCK=V9ag@mail.gmail.com>
 <CA+55aFy-ktC3NG5Wc+vhWB+18aqj9a0VLUSKQg+KR=FsVqfoJQ@mail.gmail.com>
 <CA+55aFz6Ben=b_jKXTneUm7-ULP_Z8J5uua+=CA+kXjVpSSVjg@mail.gmail.com>
 <20120311082431.GA26640@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120311082431.GA26640@openwall.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Solar Designer <solar@openwall.com> wrote:

> > Actually, using a pure counter is horrible, because even if 
> > it takes four days to wrap, it *will* wrap, and the attacker 
> > can just count his own execve's.
> 
> Four days (for a 32-bit counter) is just not enough, so the 
> counter needs to be e.g. 64-bit as proposed.  A 64-bit counter 
> won't wrap during lifetime of a system.

A 64-bit counter is OK on 32-bit platforms as well as long as 
it's not *atomic*.

Linus's scheme of using the CPU ID for the high bits would solve 
that particular problem IMO. Each CPU would have its own count 
set apart in a percpu area, accessible via __this_cpu_inc() or 
so.

16 bits for the CPU ID and 48 bits for the actual count should 
be enough for everyone! ;-) It wraps in about 700 years, with 
current CPU speeds and assuming that exec() will be relatively 
slow in the future as well.

Some other kernel code might make use of such a fast, global 
generation count as well, so if this is reasonably abstracted 
out and named properly it would not just be a single-purpose 
security facility. DEFINE_GENCOUNT() or so? [the count itself 
would not be reused, of course.]

> The CPUs' timestamp counters were not designed for security.  
> I would not be too surprised if some implementation of a CPU 
> architecture (maybe emulated, maybe under a hypervisor) has 
> such timestamp counter granularity that we may see the same 
> value across a second execve().

Not using the TSC would certainly make this logic simpler and 
faster - which is a big plus for any security measure.

Thanks,

	Ingo
