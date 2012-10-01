Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab2JAA07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 20:26:59 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37671 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JAA05 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 20:26:57 -0400
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.46.74
Date: Sun, 30 Sep 2012 17:26:49 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 8/10] bug.h: Make BUILD_BUG_ON generate compile-time error
Message-ID: <20121001002649.GB16784@leaf>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1348874411-28288-9-git-send-email-daniel.santos@pobox.com>
 <20120929003239.GA14293@jtriplet-mobl1>
 <50664E30.7050809@att.net>
 <20120929025506.GA3183@leaf>
 <5068D5BD.1000802@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5068D5BD.1000802@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 06:29:01PM -0500, Daniel Santos wrote:
> On 09/28/2012 09:55 PM, Josh Triplett wrote:
> > Assuming you don't call BUILD_BUG_ON_MSG more than once per line:
> >
> > /tmp$ cat test.c
> > #define BUILD_BUG_ON_MSG_INTERNAL2(cond, msg, line) \
> >     do { \
> >         extern void __build_bug_on_failed_ ## line (void) __attribute__((error(msg))); \
> >         if (cond) \
> >             __build_bug_on_failed_ ## line(); \
> >     } while (0)
> >
> > #define BUILD_BUG_ON_MSG_INTERNAL(cond, msg, line) BUILD_BUG_ON_MSG_INTERNAL2(cond, msg, line)
> > #define BUILD_BUG_ON_MSG(cond, msg) BUILD_BUG_ON_MSG_INTERNAL(cond, msg, __LINE__)
> >
> > void f(void)
> > {
> >     BUILD_BUG_ON_MSG(0, "test 1");
> >     BUILD_BUG_ON_MSG(1, "test 2");
> >     BUILD_BUG_ON_MSG(0, "test 3");
> >     BUILD_BUG_ON_MSG(1, "test 4");
> > }
> > /tmp$ gcc -c test.c
> > test.c: In function ‘f’:
> > test.c:14:119: error: call to ‘__build_bug_on_failed_14’ declared with attribute error: test 2
> > test.c:16:119: error: call to ‘__build_bug_on_failed_16’ declared with attribute error: test 4
> Thanks! This is very nice!  I've done a little more research and
> discovered that there's also a __COUNTER__ macro that is available
> in gcc 4.3+.  Before I realized that it was only available in gcc
> 4.3, I wrote this little macro:
> 
> #define _CONCAT1(a, b) a##b
> #define CONCAT(a, b) _CONCAT1(a, b)
> 
> #ifdef __COUNTER__
> # define UNIQUIFY(prefix) CONCAT(prefix, __COUNTER__)
> #else
> # define UNIQUIFY(prefix) CONCAT(prefix, __LINE__)
> #endif
> 
> However, this could lead to code might compile on gcc 4.3+, but
> not compile prior, so this is bad, right?

Yes, as long as Linux continues to support prior GCC versions (currently
anything 3.2 or newer), I'd suggest sticking with __LINE__ so that it
consistently breaks if you use more than one BUILD_BUG_ON_MSG per line.

Good to know that __COUNTER__ exists, though.

Also, the name BUILD_BUG_ON_MSG seems wrong to me somehow; I keep
parsing it as though something about the message causes the build bug.

- Josh Triplett
