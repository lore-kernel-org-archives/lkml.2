Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab2BCJww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:52:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755486Ab2BCJwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:52:49 -0500
Date: Fri, 3 Feb 2012 10:52:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120203095227.GA13162@elte.hu>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu>
 <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu>
 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 3 Feb 2012 10:09:29 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> > > > > +			get_random_bytes(&cookies[i][j],
> > > > > +					 sizeof(cookies[i][j]));
> > > > 
> > > > ugly line break.
> > > > 
> > > 
> > > Why? Looks pretty good to me. But sure I'll change it.
> > 
> > It's ugly because it serves no purpose other than pacifying 
> > checkpatch and makes the code *uglier*.
> 
> No it doesn't.  For 80-col displays the code is *already 
> wrapped*.  And that wrapping to column 0 is vastly worse than 
> the above.

Have you actually checked how this actual line would look like 
in an 80 cols terminal, if not broken up? I have, it's exactly 
80 cols so it looks just fine.

( It was probably broken up when it was longer and then left 
  this way - making things permanently worse not just by the 
  linebreak but also by the unnecessary curly braces around the 
  inner loop. )

But more importantly, even if the line was genuinely longer, how 
many people are looking at things in an 80-col display? By my 
experience, from looking at what kinds of terminals kernel 
people use, it's below 1%. (I was one of the last ones holding 
out because text consoles are so much faster than just about any 
usable xterm app - but I switched to a larger terminal some two 
years ago.)

Shouldnt't we concentrate on the 99% case which gets uglified by 
the systematic linebreaks?

Also, there are clearly cases where breaking the line 
intelligently improves things. Such as:

+               /* An example of output and arguments */
+               printf("pid1: %6d pid2: %6d FD: %2d FILES: %2d VM: %2d FS: %2d "
+                      "SIGHAND: %2d IO: %2d SYSVSEM: %2d INV: %2d\n",
+                      pid1, pid2,
+                      sys_kcmp(pid1, pid2, KCMP_FILE,          fd1, fd2),
+                      sys_kcmp(pid1, pid2, KCMP_FILES,         0, 0),
+                      sys_kcmp(pid1, pid2, KCMP_VM,            0, 0),
+                      sys_kcmp(pid1, pid2, KCMP_FS,            0, 0),
+                      sys_kcmp(pid1, pid2, KCMP_SIGHAND,	0, 0),
+                      sys_kcmp(pid1, pid2, KCMP_IO,            0, 0),
+                      sys_kcmp(pid1, pid2, KCMP_SYSVSEM,	0, 0),
+
+                       /* This one should fail */
+                      sys_kcmp(pid1, pid2, KCMP_TYPES + 1,     0, 0));

this is vastly more readable because the arguments are lined up 
vertically not just at the beginning but nicely tabulated along 
the way.

Oh, and note that 

Breaking lines is a tool that should be used on a case by case 
basis, not a hard limit.

> If we want to increase the standard to (say) 96 cols then 
> fine, I'd be happy with that.  But until we do that we should 
> not create such a gruesome mess for those who use 80 cols.

The kernel has *already* become a gruesome mess for 80 col users 
long ago. That was the main reason why I stopped using 80 col 
terminals two years ago ...

So lets stop the pretense.

> > It's a disease. When checkpatch tells you "this line is too 
> > long" then consider it a code cleanliness warning!
> 
> Well yes, if it can be fixed by other means then great.

Yes it can.

Thanks,

	Ingo
