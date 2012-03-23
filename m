Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759779Ab2CWTkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:40:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60061 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab2CWTkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:40:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120323192143.GY2450@linux.vnet.ibm.com>
References: <20120319152317.GA3932@gmail.com> <CA+55aFyezw6yW2g6hOAOeZ5vRm0xUNPQyD4eo0wRHMHiN3Z+kQ@mail.gmail.com>
 <20120320033300.GH2393@linux.vnet.ibm.com> <CA+55aFzXAdNRqNHm3-wx02au4b_Ze_WM-gCtOk+gJdGMsn3Zbg@mail.gmail.com>
 <20120323192143.GY2450@linux.vnet.ibm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 23 Mar 2012 12:39:59 -0700
X-Google-Sender-Auth: 6gWwwRpUvOTJwG5gVAiTFzUJ0Hk
Message-ID: <CA+55aFzgno-7AcHxKMWGYrr2QAwEzXOieSghnsEfPQJ5aed-yQ@mail.gmail.com>
Subject: Re: [GIT PULL] RCU changes for v3.4
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 12:21 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>>
>> Please? Every time I look at some profiles, that silly rcu_read_lock
>> is there in the profile. It's annoying. I'd rather see it in the
>> function that invokes it.
>
> Let me see what I can do...

Thanks. To some degree, rcu_read_lock() is the more critical one,
because it is often in the much more critical path in the caller. In
particular, it's often at the beginning of a function, where a number
of arguments are "live", and calling it out-of-line also forces the
compiler to then save/restore those arguments (because they are
clobbered by the function call).

rcu_read_unlock() is *usually* not as critical, and is obviously much
harder to inline anyway due to the whole complexity with needing to
check if an RCU sequence has ended. It often is at the end of the
function call in the caller, when the only thing like is often just
the single return value (if that). So it seldom looks nearly as bad in
any profiles, because it doesn't tend to have the same kind of bad
impact on the call site.

                       Linus
