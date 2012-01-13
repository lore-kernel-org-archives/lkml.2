Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab2AMUO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 15:14:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932694Ab2AMUO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:14:56 -0500
Message-ID: <1326485605.4342.19.camel@localhost>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, luto@mit.edu, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net
Date: Fri, 13 Jan 2012 15:13:25 -0500
In-Reply-To: <CA+55aFyZTp2-3Pb+NvVbq2jddJjhNO3RcKsBJiu1k8HayNy-oA@mail.gmail.com>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
	 <20120113164547.GA22061@redhat.com>
	 <20120113182422.28e648fb@pyramind.ukuu.org.uk>
	 <CALCETrX_nA4MtjDCKdfwJBOO6QEyzk_6nbr5Ou6QqkXcq2rTPQ@mail.gmail.com>
	 <CA+55aFyCKAY97zK=4u-AHvQyh2U1ryYybQEmgaRR+kc-d2fLhA@mail.gmail.com>
	 <CALCETrWOdEnTLhjdgjSc0d=8j4q3JeRz1g_wYR9_uwJP=iimcw@mail.gmail.com>
	 <CA+55aFyZTp2-3Pb+NvVbq2jddJjhNO3RcKsBJiu1k8HayNy-oA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-13 at 11:45 -0800, Linus Torvalds wrote:
> On Fri, Jan 13, 2012 at 11:39 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > Is the current exec_no_trans check enough for you?  With my patch,
> > selinux can already block the execve if it wants.
> 
> If this feature has "selinux can do xyz if it wants", it is broken.
> 
> The *whole* point is to get the f*^%ing crazy "security managers can
> do xyz" things away from it.
> 
> The flag - when set - should give a 100% guarantee that security
> context doesn't change, and an operation that would change it would
> error out.

That's what you would get today following the MNT_NOSUID example.
SELinux just has the additional property that the policy can either
error (and fail the exec) or allow no selinux transition to happen.  

> Not a "selinux can block it if it wants". None of that "wants" crap.
> None of the "you can configure security rules to do xyz" crap.
> 
> One simple rule: no security changes from the context that set the flag.
> 
> Any other rule will inevitably cause random gray areas where some
> random security manager does something stupid. We have enough of those
> already. No more.

So you can't drop capabilities(7)?  If you come in with permission you
can't get rid of it?  Ouch.

My thought on expanding the SELinux support beyond 'no
transition' (which I suggest we do today) would be that we might allow
SELinux transitions if we can show the the 'child' domain is a subset of
the 'parent' domain. Much the same as I imagine you can still drop
capabilities after setting this flag you might be able to drop SELinux
permissions, but that's something that would need a lot of thought and
that we don't have a good way to do today...

