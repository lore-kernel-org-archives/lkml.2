Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0GANTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 09:19:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60101 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab0GANTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 09:19:52 -0400
X-Authority-Analysis: v=1.1 cv=aMplT6I4JJ0P4CS7sRSHqoj9En8aKfIxSsimYOJhsMQ= c=1 sm=0 a=ZH2kpZb4ggcA:10 a=GQCbJdZ--msA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=DfNHnWVPAAAA:8 a=7T1Zc9FHvKiEkcRkNV8A:9 a=0JRPv_vQUmFYd4UURNQA:7 a=inmR9fn_tLmkHrmkBcokzLGuOW0A:4 a=CjuIK1q_8ugA:10 a=lBRciGGoxdUA:10 wl=env:18 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Thu, 1 Jul 2010 08:20:39 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Yama: add PTRACE exception tracking
Message-ID: <20100701132038.GA24394@hallyn.com>
References: <20100630003844.GE4837@outflux.net>
 <20100630073158.GA4453@infradead.org>
 <alpine.LRH.2.00.1007011057520.24202@tundra.namei.org>
 <20100701044401.GY4837@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701044401.GY4837@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (kees.cook@canonical.com):
> > This is getting more complicated, with fine-grained security policy now 
> > being introduced, also with the need to modify applications.
> 
> Well, I'm trying to solve what I think is a core problem with PTRACE -- it
> is too permissive.  I'm happy to look at it from other angles if it doesn't
> make sense for this kind of thing to live in Yama.  I'm already very happy
> with the existing restrictions available in Yama.

I've been jumping from one conviction to another to yet another and back
again on this.

First off, if you consider PTRACE_PTRACEME, and just consider this a more
finegrained targeted version of that, it doesn't seem all that gross.  So
maybe that's my fault for suggesting prctl as an easier-to-use in LSMs
api, bc using a PTRACE_PTRACEDBY might just look cleaner.

Still, you say 'ptrace is too permissive', but a rebuttal to that is that,
in a DAC system, ptrace uses what credentials it knows of to authorize.
*You* can make it more finegrained by not insisting on running everything
as a single user.

What you now are trying to do is find a new, natural relationship between
tasks on a plain DAC system to provide finer-grained control.  The one you
picked - process ancestry - doesn't perfectly fit, so you add changes and
make it less clean.  The criticism of that is valid and needs to be
discusssed.

Adding new relationships between tasks is what LSMs do - based on the
policy-defined relationships between the security tasks of the respective
domains.  And it feeld natural there - so it's natural for SELinux and
apparmor to confine firefox to a domain that can't ptrace anything else
(and maybe not itself).

One q then is whether YAMA wants to provide task tracking of its own, or
stack with apparmor.

> > There are several existing LSMs with the ability to control ptrace, but as 
> > part of a system-wide, coherent, analyzable policy -- often in support of 
> > specific security models for which there is concrete user demand and 
> > benefit.
> 
> Sure.  I am curious, though, is there a way for SELinux (or maybe Smack,
> since it has more dynamic labels) to declare this kind of on-runtime PTRACE
> relationship?  Maybe I overlooked some options for this.  I didn't see any

In SELinux, you could give a debugger or crash handler an unprivileged, but
allowed-to-ptrace-the-main-app domain.

> I still think simple chaining is the way to go.  I want to review the
> earlier discussions first (I think Serge said it was in 2004ish?) before I
> write up anything.  There is, I think, one sticking point, which is
> /proc/self/attr/current, but beyond that, I think some simple
> reorganization of LSM initialization routines and a list that security_*
> walks would be sufficient.

In the past, output results for each LSM were simply split by \n or a :
or something, and input was prepended by the LSM name.

-serge
