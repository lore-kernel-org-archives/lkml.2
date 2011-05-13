Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1EME1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 00:27:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab1EME1U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 00:27:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110513040214.GA25270@mail.hallyn.com>
References: <BANLkTi=nc3WGaASQm1Pc9byshLOmLf2bXQ@mail.gmail.com>
 <20110513025013.GA13209@mail.hallyn.com> <20110513040214.GA25270@mail.hallyn.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 May 2011 21:26:28 -0700
Message-ID: <BANLkTim3cy8Jf3URYTW+cbr3nrdWVbsmGw@mail.gmail.com>
Subject: Re: acl_permission_check: disgusting performance
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 9:02 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
>
> I wonder how much this would help:  (only compile-tested)

So it should help a lot, but it breaks when CONFIG_USER_NS isn't even
set (the case that Eric fixed.

So instead, do this:

 (a) get rid of the "_current_user_ns()" thing. There is no reason to
have it, if it's directly off "current->cred", then it's cheaper to
inline it than have a function just for two pointer indirections.

 (b) do

  #ifdef CONFIG_USER_NS
    #define current_user_ns() (&init_user_ns)
  #else
    #define current_user_ns() (current_cred_xxx(user_ns))
  #endif

 (c) and then the rest of your patch (to actually initialize and set
"cred->user_ns") should be fine. But don't touch
acl_permission_check() at all - once you've fixed current_user_ns() to
DTRT, acl_permission_check will be ok.

Ok?

Then the compiler will do the right thing: in acl_permission_check()
it will see that current_user_ns() and "current_fsuid()" share 90% of
the code, and will CSE the "current_cred()" part (or, if
CONFIG_USER_NS isn't set, it will see a constant comparison of
&init_user_ns with itself, and generate no code for hat case). There's
no reason for you to do it for it, and when  you do it by hand you get
the !CONFIG_USER_NS case wrong.

Hmm? That should fix all the horrible code generation issues in
acl_permission_check. When CONFIG_USER_NS isn't set, it will generate
no code at all, and when it _is_ set, it will just generate two loads
from current->cred (one for user_ns, one for fsuid), which is about as
good as it gets.

                              Linus
