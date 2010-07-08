Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab0GHOW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:22:57 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:58329
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753385Ab0GHOWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:22:55 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1418M1432N98dN10d1Izz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L58T3A-01-6QJ-02
X-M-MSG: 
Date: Thu, 8 Jul 2010 16:18:45 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/cpu] x86, cpu: AMD errata checking framework
Message-ID: <20100708141845.GI11824@escobedo.osrc.amd.com>
References: <1276681733-10872-1-git-send-email-hans.rosenfeld@amd.com>
 <tip-48327dd572aaf9924c3dc4f8ad3189d506b11390@git.kernel.org>
 <4C34B5CE.1040407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C34B5CE.1040407@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_b=2E_M=FCnchen=3B_Ges?=
	=?iso-8859-1?Q?ch=E4ftsf=FChrer=3A_Andrew_Bowd=2C_Alberto_Bozzo=3B_Sitz?=
	=?iso-8859-1?Q?=3A_Dornach=2C_Gemeinde_Aschheim=2C_Landkreis_M=FCnchen=3B?=
	=?iso-8859-1?Q?_Registergericht_M=FCnchen=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 07, 2010 at 01:13:50PM -0400, H. Peter Anvin wrote:
> This code has been excluded since it was added, because it doesn't
> compile if CONFIG_CPU_SUP_AMD is not defined.  I took a quick look over
> it to see if it could quickly be fixed (which it can -- just don't
> exclude the macro definitions and define a dummy version of
> cpu_has_amd_erratum() which simply returns false), however, on looking
> closer at the code I have to say it really is pretty broken, and as such
> I would rather you refreshed the patch.

Great that finally someone cared to take a closer look at it, after
only 4 weeks :)

I have looked into the issue and I think the main problem is not in
those patches, although either of the two patches could have fixed it
one way or another. Adding a dummy cpu_has_amd_erratum() would be one
way to do it, but I don't think it would be right.

I think that my patches uncovered a latent bug in the handling of AMD
erratum 400. The obviously correct fix is to completely wrap the
AMD-specific erratum 400 workaround in arch/x86/kernel/process.c in
#ifdef CONFIG_CPU_SUP_AMD. There is no reason why the code for an
AMD-specific workaround should be in the kernel if AMD support is
completely disabled. This makes me believe that while
CONFIG_CPU_SUP_AMD etc. exist, they are probably not used as widely as
they should be.

> First of all, you're passing a boolean flag which only is used to tell
> if there is a single integer immediately following it.  This could just
> as easily, and much more cleanly, be done by passing -1 in the case
> there is no OSVW ID.

You are right in that this would be more concise, but is it really
"cleaner"? The bool makes it pretty obvious whats going on, without
introducing any ambiguity about what OSVW IDs are actually legal or
not. Also, I don't see how passing an extra bool would hurt anyone,
especially since this is not exactly code thats called very often.

> However, a *much* bigger issue is the fact that
> this will manifest a potentially very large memory structure into code
> at every calling point, but it is not at all obvious to the programmer
> that that will happen.

I don't really see a problem here, for basically two reasons.

First, it is very, very, very unlikely that there will ever be a
very large argument list for an erratum. Errata that never get fixed
in a family only have one model-stepping range covering the whole
family, while errata that get fixed eventually apply only to a couple
few model-stepping ranges. While working on this I spent a lot of time
studying the various AMD errata that could possibly make use of this
framework, and except for one all could be handled by three ranges or
less. The exception was a family 0xf erratum, which needed about 8
ranges because of the strange way the family 0xf models/steppings were
assigned.

Second, the cpu_has_amd_erratum() function is supposed to be called
only once for each erratum by initialization code. You should never
ever call it repeatedly in loops or interrupt handlers. If you need to
check for an erratum in such a place, cache the result in a local
variable. That would even be advisable without specifying the erratum
in the argument list.

The way I had implemented it would automatically make sure that the
definition of an erratum is embedded only in the code that checks for
it. An erratum that is never checked for (because the code is
disabled, or the module that contains it is not loaded) will never
need any space in the kernel.

> As such, I'm going to insist that the individual
> errata definitions move out of line into a memory structure -- using
> more or less your existing macros you can simply make it an array of
> type u32 -- and then have in your header file:
> 
> 
> extern const u32 amd_erratum_400[];
> 
> 
> 
> ... and at the point of call ...
> 
> cpu_has_amd_erratum(amd_erratum_400)

Thats exactly the kind of thing I wanted to avoid. This means carrying
around all errata definitions in memory all the time instead of just
when theres actually code thats using them.

It also requires more than one change to more than one file when
you're defining a new erratum. It was one of the design goals to avoid
just that.

Really, I don't see what this change would gain us, but it would
certainly make it harder to maintain.

> Note that I haven't included a pointer to the cpuinfo_x86 structure. The
> reason why is that although you pass a pointer to an arbitrary
> cpuinfo_x86 structure, you also do rdmsrl() on the local processor and
> expect them to work.  This isn't really ideal; it's better, then, to
> make it specific to the currently executing processor and just use
> current_cpu_data.

Yes, that makes sense. I will rework that part.

Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

