Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030644Ab2I2Czo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 22:55:44 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50546 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030612Ab2I2CzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 22:55:16 -0400
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.46.74
Date: Fri, 28 Sep 2012 19:55:07 -0700
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
Message-ID: <20120929025506.GA3183@leaf>
References: <1348874411-28288-1-git-send-email-daniel.santos@pobox.com>
 <1348874411-28288-9-git-send-email-daniel.santos@pobox.com>
 <20120929003239.GA14293@jtriplet-mobl1>
 <50664E30.7050809@att.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50664E30.7050809@att.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 08:26:08PM -0500, Daniel Santos wrote:
> On 09/28/2012 07:32 PM, Josh Triplett wrote:
> > On Fri, Sep 28, 2012 at 06:20:09PM -0500, Daniel Santos wrote:
> >> Negative sized arrays wont create a compile-time error in some cases
> >> starting with gcc 4.4 (e.g., inlined functions), but gcc 4.3 introduced
> >> the error function attribute that will.  This patch modifies
> >> BUILD_BUG_ON to behave like BUILD_BUG already does, using the error
> >> function attribute so that you don't have to build the entire kernel to
> >> discover that you have a problem, and then enjoy trying to track it down
> >> from a link-time error.
> >
> > Rather than doing both, and potentially producing two errors for the
> > same issue, how about using __compiletime_error only, and only using the
> > negative-sized array when __compiletime_error has no useful definition?
> >
> > For instance, in compiler.h, when defining __compiletime_error as an
> > empty macro in the fallback case, you could define a
> > __compiletime_error_fallback() macro that declares a negative-sized
> > array; you could then define __compiletime_error_fallback() as an empty
> > macro when it doesn't exist.
> It may also make sense to define
> #define BUILD_BUG() BUILD_BUG_ON(1)
> 
> I haven't examined this really closely yet and my eyes are getting a
> little bleary :)
> 
> 
> Really, I would have liked to be able to set the error message as
> well, but we would have to have the macro generate a unique function
> name for each time its expanded to make that work.  Example:
> 
> #define BUILD_BUG_ON(cond) BUILD_BUG_ON_MSG(cond, #cond)
> #define BUILD_BUG_ON_MSG(cond, msg)                                \
>     do {                                                           \
>         extern void __build_bug_on_failed ## something_unique(void)\
>             __compiletime_error("BUILD_BUG_ON failed: " msg);      \
>         __compiletime_error_fallback(cond);                        \
>         if (cond)                                                  \
>             __build_bug_on_failed();                               \
>     } while(0)
> 
> I just don't know any tricks to generate unique pre-processor
> value automatically.

Assuming you don't call BUILD_BUG_ON_MSG more than once per line:

/tmp$ cat test.c
#define BUILD_BUG_ON_MSG_INTERNAL2(cond, msg, line) \
    do { \
        extern void __build_bug_on_failed_ ## line (void) __attribute__((error(msg))); \
        if (cond) \
            __build_bug_on_failed_ ## line(); \
    } while (0)

#define BUILD_BUG_ON_MSG_INTERNAL(cond, msg, line) BUILD_BUG_ON_MSG_INTERNAL2(cond, msg, line)
#define BUILD_BUG_ON_MSG(cond, msg) BUILD_BUG_ON_MSG_INTERNAL(cond, msg, __LINE__)

void f(void)
{
    BUILD_BUG_ON_MSG(0, "test 1");
    BUILD_BUG_ON_MSG(1, "test 2");
    BUILD_BUG_ON_MSG(0, "test 3");
    BUILD_BUG_ON_MSG(1, "test 4");
}
/tmp$ gcc -c test.c
test.c: In function ‘f’:
test.c:14:119: error: call to ‘__build_bug_on_failed_14’ declared with attribute error: test 2
test.c:16:119: error: call to ‘__build_bug_on_failed_16’ declared with attribute error: test 4

- Josh Triplett
