Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2DRSP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:15:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41671 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab2DRSP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:15:58 -0400
MIME-Version: 1.0
In-Reply-To: <4F8F0385.5090901@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
	<tip-31796ac4e8f0e88f5c10f1ad6dab8f19bebe44a4@git.kernel.org>
	<CAMe9rOqF6Kh6-NK7oP0Fpzkd4SBAWU+G53hwBbSD4iA2UzyxuA@mail.gmail.com>
	<4F8EFE4D.2040201@zytor.com>
	<CAMe9rOpfPQghra1PQTUwsFOvjgNpzFDEGS5=BbFBjn=HZGL93g@mail.gmail.com>
	<4F8F0385.5090901@zytor.com>
Date: Wed, 18 Apr 2012 11:15:57 -0700
Message-ID: <CAMe9rOq7LduF4aLPe9qatedxps4WPCgOHTD=E_Lje4_tu6tyZw@mail.gmail.com>
Subject: Re: [tip:x86/x32] x32: Fix alignment fail in struct compat_siginfo
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 11:10 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/18/2012 11:01 AM, H.J. Lu wrote:
>> On Wed, Apr 18, 2012 at 10:47 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 04/18/2012 10:38 AM, H.J. Lu wrote:
>>>>
>>>> It doesn't match struct siginfo in include/asm-generic/siginfo.h for
>>>> x32.
>>>>
>>>
>>> What is missing (from either)?
>>>
>>
>> include/asm-generic/siginfo.h has
>>
>>                 /* SIGCHLD */
>>                 struct {
>>                         __kernel_pid_t _pid;    /* which child */
>>                         __ARCH_SI_UID_T _uid;   /* sender's uid */
>>                         int _status;            /* exit code */
>>                         __kernel_clock_t _utime;
>>                         __kernel_clock_t _stime;
>>                 } _sigchld;
>>
>>
>> Although x32 __kernel_clock_t is s64 with 64bit alignment, in
>> _sigchld, it must be compat_s64 with 32bit alignment.
>>
>
> What would you suggest?  Change __kernel_clock_t?  It would somewhat
> stink to have to muck with things here.
>
> The problem here of course is that this is a phony misalignment...
>
>        -hpa
>

In x32 glibc, I have

# if compile for X32
/* si_utime and si_stime must be 4 byte aligned for x32 to match the
   kernel.  We align siginfo_t to 8 bytes so that si_utime and si_stime
   are actually aligned to 8 bytes since their offsets are multiple of
   8 bytes.  */
typedef __clock_t __attribute__ ((__aligned__ (4))) __sigchld_clock_t;
#  define __SI_ALIGNMENT __attribute__ ((__aligned__ (8)))
# else
typedef __clock_t __sigchld_clock_t;
#  define __SI_ALIGNMENT
# endif

typedef struct siginfo
  {
...
	/* SIGCHLD.  */
	struct
	  {
	    __pid_t si_pid;	/* Which child.  */
	    __uid_t si_uid;	/* Real user ID of sending process.  */
	    int si_status;	/* Exit value or signal.  */
	    __sigchld_clock_t si_utime;
	    __sigchld_clock_t si_stime;
	  } _sigchld;
...
  } siginfo_t __SI_ALIGNMENT;


-- 
H.J.
