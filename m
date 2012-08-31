Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab2HaWtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 18:49:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55238 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab2HaWtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 18:49:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120831223908.4aa5574d@pyramind.ukuu.org.uk>
References: <20120831213126.GA19688@www.outflux.net>
	<20120831223908.4aa5574d@pyramind.ukuu.org.uk>
Date: Fri, 31 Aug 2012 15:49:00 -0700
Message-ID: <CACLa4pv75-HaPEas=aOMySbMm-YdSJZdc6qtNUnTM+Ev2Rp7rg@mail.gmail.com>
Subject: Re: [PATCH] security: unconditionally call Yama
From: Eric Paris <eparis@parisplace.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 2:39 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 31 Aug 2012 14:31:26 -0700
> Kees Cook <keescook@chromium.org> wrote:
>
>> Unconditionally call Yama, no matter what LSM module is selected.

> Not a good plan. What happens when everyone decides to stack every module
> by ifdeffing in the kernel - mayhem. I'm all for it being possible but
> done right - espeicall as I believe a proper proposal now for stacking
> modules, and it should be done as part of that.

I think a lot of us agree it's a 'difficult' plan going forward.  Kees
wrote this patch after we (James, SELinux, AppArmor people) talked at
the Security Summit earlier today.  From my PoV we have a couple of
'classes' of LSMs.

Big with Labels: SELinux and SMACK
Big without Labels: AppArmor and TOMOYO
Small and stateless: Capabilities and Yama (and maybe integrity)

Those small and stateless LSMs can easily stack.  We don't have object
lifetime issues.  We don't have difficult technical details.  We all
here seem to want to stack 'small and stateless' with 'big boy'.
Outside one little capabilities and selinux setxattr issue I can't
think of anything even quirky.  So the fast path forward, in my mind,
is to start here with Yama.  Our choice *today* is adding these static
hooks inside the 'big boy' LSMs (which I think all of us are willing
to do) vs adding it one time in the LSM and not having to worry about
it all over the place.  Getting the big guys and the little guys to
play together is not going to lead to a mess of crazy.

Stacking the big boys is a future goal most of us are happy with
seeing done, if it turns out to be reasonable.  We know it's close to
possible.  Dave Howell's gave us an implementation about 2 years ago.
Casey Schaufler demo'd another stacking interface today.  No code from
the latter, but the only limitation he really mentioned today was that
two big guys with labels can't stack together.  I don't know how/if
Dave's implementation wanted to handle that case.

I really think this patch is good.

Acked-by: Eric Paris <eparis@redhat.com>

I think I even want to do the same thing with capabilities so I don't
have to make sure I'm getting those right in SELinux.  And everyone
else probably doesn't want to keep those hooks themselves either.  I
should send that patch to Linus.  I bet I can give him a large
negative diff.  He did just say two days ago that he'll take any -1000
line diff after -rc6   :)

I think Casey and Dave need to both get their larger stacking
solutions posted and we should go with the best one.  It'll let us
pull out the static code, but for now, I like the static coding
between the big boys and the little guys.  Lets fix today what's easy
and fix tomorrow what we can't fix today.

-Eric
