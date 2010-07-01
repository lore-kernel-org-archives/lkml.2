Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0GAPWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:22:21 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:35614 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab0GAPWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:22:19 -0400
Subject: Re: [PATCH 0/2] Yama: add PTRACE exception tracking
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Kees Cook <kees.cook@canonical.com>, James Morris <jmorris@namei.org>,
       Christoph Hellwig <hch@infradead.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20100701132038.GA24394@hallyn.com>
References: <20100630003844.GE4837@outflux.net>
	 <20100630073158.GA4453@infradead.org>
	 <alpine.LRH.2.00.1007011057520.24202@tundra.namei.org>
	 <20100701044401.GY4837@outflux.net>  <20100701132038.GA24394@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Thu, 01 Jul 2010 11:22:11 -0400
Message-ID: <1277997731.15753.119.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 08:20 -0500, Serge E. Hallyn wrote:
> First off, if you consider PTRACE_PTRACEME, and just consider this a more
> finegrained targeted version of that, it doesn't seem all that gross.  So
> maybe that's my fault for suggesting prctl as an easier-to-use in LSMs
> api, bc using a PTRACE_PTRACEDBY might just look cleaner.

TRACEME is an alternative mechanism (to ATTACH) for establishing a
tracing relationship, not a mechanism for expressing policy over ATTACH
requests.  The prctl was solely for configuring (Yama-specific) policy.

> Still, you say 'ptrace is too permissive', but a rebuttal to that is that,
> in a DAC system, ptrace uses what credentials it knows of to authorize.
> *You* can make it more finegrained by not insisting on running everything
> as a single user.
> 
> What you now are trying to do is find a new, natural relationship between
> tasks on a plain DAC system to provide finer-grained control.  The one you
> picked - process ancestry - doesn't perfectly fit, so you add changes and
> make it less clean.  The criticism of that is valid and needs to be
> discusssed.
> 
> Adding new relationships between tasks is what LSMs do - based on the
> policy-defined relationships between the security tasks of the respective
> domains.  And it feeld natural there - so it's natural for SELinux and
> apparmor to confine firefox to a domain that can't ptrace anything else
> (and maybe not itself).

Or to express whatever ptrace relationships you want to allow,
regardless of process ancestry.

> One q then is whether YAMA wants to provide task tracking of its own, or
> stack with apparmor.

Last I looked, apparmor did not support any kind of fine-grained ptrace
constraints, just a simple unconfined || same-profile || CAP_SYS_PTRACE
check.  Whereas SELinux lets you control it based on the particular
domain pairing.

> > > There are several existing LSMs with the ability to control ptrace, but as 
> > > part of a system-wide, coherent, analyzable policy -- often in support of 
> > > specific security models for which there is concrete user demand and 
> > > benefit.
> > 
> > Sure.  I am curious, though, is there a way for SELinux (or maybe Smack,
> > since it has more dynamic labels) to declare this kind of on-runtime PTRACE
> > relationship?  Maybe I overlooked some options for this.  I didn't see any
> 
> In SELinux, you could give a debugger or crash handler an unprivileged, but
> allowed-to-ptrace-the-main-app domain.

Exactly.  What we do not want to do is to have the applications
configuring policy on the fly.

> > I still think simple chaining is the way to go.  I want to review the
> > earlier discussions first (I think Serge said it was in 2004ish?) before I
> > write up anything.  There is, I think, one sticking point, which is
> > /proc/self/attr/current, but beyond that, I think some simple
> > reorganization of LSM initialization routines and a list that security_*
> > walks would be sufficient.
> 
> In the past, output results for each LSM were simply split by \n or a :
> or something, and input was prepended by the LSM name.

I think the final form of the stacker patches put each value on its own
line with the module name in parentheses after it.  But it required a
compatibility hack for SELinux and ultimately I think a libselinux patch
to support SELinux stacked with anything else that wanted to
use /proc/self/attr.

-- 
Stephen Smalley
National Security Agency

