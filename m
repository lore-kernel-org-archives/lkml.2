Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2DRSVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:21:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40942 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab2DRSVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:21:20 -0400
Message-ID: <4F8F0614.9010604@zytor.com>
Date: Wed, 18 Apr 2012 11:21:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org> <CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com> <4F8EFE4D.2040201@zytor.com> <CAMe9rOpfPQghra1PQTUwsFOvjgNpzFDEGS5=BbFBjn=HZGL93g@mail.gmail.com> <4F8F0385.5090901@zytor.com> <CAMe9rOq7LduF4aLPe9qatedxps4WPCgOHTD=E_Lje4_tu6tyZw@mail.gmail.com>
In-Reply-To: <CAMe9rOq7LduF4aLPe9qatedxps4WPCgOHTD=E_Lje4_tu6tyZw@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2012 11:15 AM, H.J. Lu wrote:
> 
> In x32 glibc, I have
> 
> # if compile for X32
> /* si_utime and si_stime must be 4 byte aligned for x32 to match the
>    kernel.  We align siginfo_t to 8 bytes so that si_utime and si_stime
>    are actually aligned to 8 bytes since their offsets are multiple of
>    8 bytes.  */
> typedef __clock_t __attribute__ ((__aligned__ (4))) __sigchld_clock_t;
> #  define __SI_ALIGNMENT __attribute__ ((__aligned__ (8)))
> # else
> typedef __clock_t __sigchld_clock_t;
> #  define __SI_ALIGNMENT
> # endif
> 
> typedef struct siginfo
>   {
> ...
> 	/* SIGCHLD.  */
> 	struct
> 	  {
> 	    __pid_t si_pid;	/* Which child.  */
> 	    __uid_t si_uid;	/* Real user ID of sending process.  */
> 	    int si_status;	/* Exit value or signal.  */
> 	    __sigchld_clock_t si_utime;
> 	    __sigchld_clock_t si_stime;
> 	  } _sigchld;
> ...
>   } siginfo_t __SI_ALIGNMENT;
> 

So in other words, a separate type just for this.  However, the question
still holds: could we simply change __kernel_clock_t for x32 and be done
with it?  It would affect the alignment of struct tms, I guess; it
wouldn't really affect the kernel directly since the kernel gets a
pointer straight from userspace for times(2), but it would kind of mess
up a userspace which uses __kernel_clock_t directly.

Urk, okay...

	-hpa
