Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069Ab2LGSju (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:39:50 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51341 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944Ab2LGSjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:39:47 -0500
MIME-Version: 1.0
In-Reply-To: <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
References: <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
 <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com>
 <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com>
 <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com>
 <20121204135445.GA7420@mail.hallyn.com> <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap> <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com> <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 7 Dec 2012 10:39:26 -0800
Message-ID: <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 9:07 AM, Andrew G. Morgan <morgan@kernel.org> wrote:
> I'm still missing something with the problem definition.
>
> So far if I follow the discussion we have determined that inheritance
> as implemented is OK except for the fact that giving user an
> inheritable pI bit which gives them default permission to use all
> binaries endowed with the corresponding file fI bit.

This is IMO part of the problem but not the entire problem.

>
> Is this the problem a different inheritance model is supposed to
> address? Serge suggested that the binary could authenticate the
> user... This seems like its putting the protection in the best
> place... Each app can control its sub functions with the richest
> semantics.
>
> That being said...
>
> To me this looks like it's an access control problem... Namely use
> acls to limit which users (groups) can execute each privileged binary.
> Serge's option 2 seems like a similar approach.
>

The issue is (as I see it) with non-privileged binaries.  If a given
program (correctly) has a permitted capability and is not root, then
the only way that it can pass that capability on to children (e.g.
helper programs) is to set it into pI.  This only works if the child
has the same bit set in fI.

This is doable but annoying -- every program that a privileged program
runs needs to be authorized by the administrator.

It breaks down because, currently, users with nonzero pI have no
direct ability to wield the capabilities.  That means that every
single binary with fI bits set needs to be as careful as a setuid-root
binary to avoid leaking privilege to the caller.  (Obviously, binaries
with fP set need to be careful.  IMO binaries with only fI set should
not need to exercise any particular care to defend themselves from
their callers.)


I'm obviously missing some fundamental (and probably historical) issue
here, so let me ask the following straw-man question.  Suppose
capabilities worked like this on exec:

pP' = pI | (fP & pB)  (i.e. the current way, except that fI always has
all bits set for every binary on the system)
pI' = pI (unless !SECURE_NOROOT and uid == 0 or euid == 0, in which
case pI' = pP')

with the added restriction that pI is always a subset of pP (i.e.
dropping a bit from pP (on exec or otherwise) drops that bit from pI).

What would be wrong with this model?  (Let's pretend for now that
capabilities had always worked this way, so there's no change of
behavior to worry about.)

 - The sendmail capability bug wouldn't happen: pI has no effect on
setuid-root binaries.

 - There would be no difference between a user being trusted with a
capability and being inh-trusted with that capability, since the
latter concept wouldn't really exist.

 - Totally unprivileged users couldn't engage in any funny business.
Their pI masks would be zero, and they would have no way of changing
that.

 - Partially privileged users would work just fine.  They could wield
their capabilities (subject to some possible fiddling with pE) from
bash or from anything else.  They could also freely drop those
capabilities.

 - Privileged programs would require less thought: to grant a program,
you set its privilege in fP.  There is no fI, so there's nothing
special to think about.



NB:  This is not a real proposal because there *are* capability-aware
programs out there.  I want to understand why the current system is so
different.

--Andy
