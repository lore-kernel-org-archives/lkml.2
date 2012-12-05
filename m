Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab2LEVFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:05:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab2LEVFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:05:39 -0500
Date: Wed, 5 Dec 2012 15:05:28 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
Message-ID: <20121205210528.GA9047@sergelap>
References: <CALCETrVQxPDfU83-LUWrf330wOBbSsMvKdFXMR3CL4LmDvyfMw@mail.gmail.com>
 <CALQRfL67LX5owxo=SMuRNAm1Jds53zY-moLpXE=wCTF4Epu4_w@mail.gmail.com>
 <CALCETrXyX2aYjbLRCpzp-h_CXBb=K7OWkO1b+tVTRz9LQQOzdQ@mail.gmail.com>
 <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
 <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com>
 <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com>
 <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com>
 <20121204135445.GA7420@mail.hallyn.com>
 <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On Tue, Dec 4, 2012 at 5:54 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Quoting Andy Lutomirski (luto@amacapital.net):
> >> >> d) If I really wanted, I could emulate execve without actually doing
> >> >> execve, and capabilities would be inherited.
> >> >
> >> > If you could modify the executable properties of the binary that has
> >> > the privilege to wield a privilege then you are either exploiting an
> >> > app bug, or doing something the privileged binary has been trusted to
> >> > do.
> >>
> >> That's not what I mean.  I would:
> >>
> >> fork()
> >> munmap everything
> >> mmap ld.so
> >> set up a fake initial stack and the right fd or mapping or whatever
> >> just to ld-linux.so
> >>
> >> That's almost execve, and privilege inheritance works.
> >
> > But of course that is why you only want to fill fI on programs you trust
> > not to do that.  What you are arguing is that you want to give fI on
> > programs you don't trust anyway, and so heck why not just give it on
> > everything.
> >
> 
> Huh?  I'd set fP on a program I expect to do *exactly* that (or use
> actual in-kernel capability inheritance, which I would find vastly
> more pleasant).  If I give a program a capability (via fP or fI & pI),
> then I had better trust it not to abuse that capability.  Having it
> pass that capability on to a child helper process would be just fine
> with me *because it already has that capability*.
> 
> The problem with the current inheritance mechanism is that it's very
> difficult to understand what it means for an fI bit or a pI bit to be
> set.  Saying "set a pI bit using pam if you want to grant permission
> to that user to run a particular program with fI set" is crap -- it
> only works if there is exactly one binary on the system with that bit
> set.  In any case, a different administrator or package might use it
> for something different.
> 
> Suppose I use the (apparently) current suggested approach: I install a
> fI=cap_net_raw copy of tcpdump somewhere.  Then I write a helper that
> has fP=cap_new_raw and invokes that copy of tcpdump after appropriate
> validation of parameters.  All is well.

Since you're writing a special helper, you can surely have it validate
the userid and make it so the calling user doesn't have to have
cap_net_raw in pI?

> Now I want to grant only a subset of users permission to run ping.  So
> I modify ping so it's cap_net_raw=i (not p) and grant those users
> pI=cap_net_raw.
> 
> The end result: I introduced a security hole: the users with
> cap_net_raw=i can run tcpdump *without validation via the helper*.
> Oops.

-serge
