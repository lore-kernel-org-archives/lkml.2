Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab2LGOhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 09:37:53 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39497 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2LGOhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 09:37:50 -0500
Date: Fri, 7 Dec 2012 14:42:34 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
Message-ID: <20121207144233.GA6681@mail.hallyn.com>
References: <CALQRfL5EeqRFykLGVLJx3pfKdP4iF8r-8Ys7pVadOaCc3j1=iQ@mail.gmail.com>
 <CALCETrXYPjow3geVBnYK_ZOhnuU_wZkdebumJ=Hv3-T=fHaPNA@mail.gmail.com>
 <CALQRfL7e160D+vzVhT-fUS-_Yp55wqnWkRFJdDTOOVjjStd9Jw@mail.gmail.com>
 <CALCETrXUSz9EN-tGMfJkw9+1kO0hfmQk4E5XPF0cg9nmpPXepg@mail.gmail.com>
 <20121204135445.GA7420@mail.hallyn.com>
 <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap>
 <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap>
 <50C13F0E.5010401@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C13F0E.5010401@schaufler-ca.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> On 12/5/2012 2:20 PM, Serge Hallyn wrote:
> > Quoting Andy Lutomirski (luto@amacapital.net):
> >> On Wed, Dec 5, 2012 at 1:05 PM, Serge Hallyn <serge.hallyn@canonical.com> wrote:
> >>> Quoting Andy Lutomirski (luto@amacapital.net):
> >>>> On Tue, Dec 4, 2012 at 5:54 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> >>>>> Quoting Andy Lutomirski (luto@amacapital.net):
> >>>>>>>> d) If I really wanted, I could emulate execve without actually doing
> >>>>>>>> execve, and capabilities would be inherited.
> >>>>>>> If you could modify the executable properties of the binary that has
> >>>>>>> the privilege to wield a privilege then you are either exploiting an
> >>>>>>> app bug, or doing something the privileged binary has been trusted to
> >>>>>>> do.
> >>>>>> That's not what I mean.  I would:
> >>>>>>
> >>>>>> fork()
> >>>>>> munmap everything
> >>>>>> mmap ld.so
> >>>>>> set up a fake initial stack and the right fd or mapping or whatever
> >>>>>> just to ld-linux.so
> >>>>>>
> >>>>>> That's almost execve, and privilege inheritance works.
> >>>>> But of course that is why you only want to fill fI on programs you trust
> >>>>> not to do that.  What you are arguing is that you want to give fI on
> >>>>> programs you don't trust anyway, and so heck why not just give it on
> >>>>> everything.
> >>>>>
> >>>> Huh?  I'd set fP on a program I expect to do *exactly* that (or use
> >>>> actual in-kernel capability inheritance, which I would find vastly
> >>>> more pleasant).  If I give a program a capability (via fP or fI & pI),
> >>>> then I had better trust it not to abuse that capability.  Having it
> >>>> pass that capability on to a child helper process would be just fine
> >>>> with me *because it already has that capability*.
> >>>>
> >>>> The problem with the current inheritance mechanism is that it's very
> >>>> difficult to understand what it means for an fI bit or a pI bit to be
> >>>> set.  Saying "set a pI bit using pam if you want to grant permission
> >>>> to that user to run a particular program with fI set" is crap -- it
> >>>> only works if there is exactly one binary on the system with that bit
> >>>> set.  In any case, a different administrator or package might use it
> >>>> for something different.
> >>>>
> >>>> Suppose I use the (apparently) current suggested approach: I install a
> >>>> fI=cap_net_raw copy of tcpdump somewhere.  Then I write a helper that
> >>>> has fP=cap_new_raw and invokes that copy of tcpdump after appropriate
> >>>> validation of parameters.  All is well.
> >>> Since you're writing a special helper, you can surely have it validate
> >>> the userid and make it so the calling user doesn't have to have
> >>> cap_net_raw in pI?
> >> I can and did.
> > Oh, oops, I mis-understood what you meant was the problem.
> >
> > Yup, that is a real limitation.
> >
> > Yes, with the posix file caps you will be disappointed unless you see
> > pI=X as "this user may run any program which is Inh-trusted with X" and
> > fI=X as "this program may be run with X by any user Inh-trusted with X".
> >
> > It almost makes me want to say that there should be an execve-analogue
> > to prctl(PR_SET_KEEPCAPS), which says caps will remain unchanged for one
> > execve.  Or perhaps an intermediate securebits state between
> > !SECBIT_NOROOT and SECBIT_NOROOT, which automatically transitions after
> > the first execve to SECBIT_NOROOT.
> >
> >> The mere presence of a cap_net_raw+i tcpdump binary is more or less
> >> equivalent to saying that users with cap_net_raw in pI can capture
> >> packets.  I've just prevented pI=cap_net_raw from meaning anything
> >> less than "can capture packets".  So I think we should bite the bullet
> >> and just let programs opt in (via some appropriately careful
> >> mechanism) to real capability inheritance.
> > By real you mean more precise.  I think it'd be very interesting to get
> > together with Markku and learn more from the N9 experiment!
> >
> > Markku, are there any post-mortem analysis papers we can read for
> > starters?  Andy would not be trying to restrict root in general, so
> > the ramification you cited may not necessarily be relevant.
> >
> > -serge
> 
> http://wt.tuxomania.net/publications/posix.1e/download.html
> 
> Everyone should read the capabilities rationale. It answers most
> of the questions on this thread, and a bunch more. The capabilities
> mechanism has to support what are currently setuid-root programs
> without change and allow for new programs that use the mechanism
> wisely and fully.

How to put this delicately...   that is not enjoyable reading :)

As I understood it, the draft supports setuid-root programs, but
does not support a !SECBIT_NOROOT environment.  If that is not the
case, can you point to where in the draft that is described?

Regardless,

1. Andy describes a problem which AFAICT can't be solved with the
current capabilities support.  An intermediate state between
!SECBIT_NOROOT and SECBIT_NOROOT (which itself is IIUC already an
extension beyond the above draft) seems an interesting feature to
consider which would support the wrapper case - but not something
to run into blindly without considering all the ramifications.

2. The N9 folks have experimented with other inheritence properties,
and the details their experience would be educational.

There are two other ways the wrappered privileged tcpdump could be
achieved:

1. Have the privileged wrapper create a new user and network
namespace and pass the network device into the new network
namespace and run tcpdump there with privilege.  This doesn't
work if the specific device also needs to be used in the original
network namespace (but passing a device bridged with the one of
interest might suffice?).

2. Have the privileged wrapper create a small tmpfs mount in a
(non-ms-shared) new mounts namespace, copy tcpdump into that mount
and give it fI=CAP_NET_RAW, then execute the child with
pI=CAP_NET_RAW.  A bit hacky, but prevents the issue of other
users with pI=CAP_NET_RAW from executing that tcpdump.  Since
the child will have pP=CAP_NET_RAW, the other users should be
prevented from getting to the modified tcpdump binary through
the child's /proc/pid/fd/N.

Not saying these are ideal, just trying to think of ways of
solving the problem...

-serge
