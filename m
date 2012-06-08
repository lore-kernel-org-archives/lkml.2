Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761868Ab2FHQKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:10:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60287 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761081Ab2FHQKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:10:32 -0400
Message-ID: <4FD223E1.1090707@zytor.com>
Date: Fri, 08 Jun 2012 09:10:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
References: <20120608135200.371649691@goodmis.org> <20120608135603.699156773@goodmis.org>
In-Reply-To: <20120608135603.699156773@goodmis.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2012 06:52 AM, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> I've been informed by someone on LWN called 'slashdot' that
> some i386 machines do not support a true cmpxchg. The cmpxchg
> used by the i386 NMI nesting code must be a true cmpxchg as
> disabling interrupts will not work for NMIs (which is the work
> around for i386s that do not have a true cmpxchg).
> 
> This 'slashdot' character also suggested a fix to the issue.
> As the state of the nesting NMIs goes as follows:
> 
>   NOT_RUNNING -> EXECUTING
>   EXECUTING   -> NOT_RUNNING
>   EXECUTING   -> LATCHED
>   LATCHED     -> EXECUTING
> 
> Having these states as enum values of:
> 
>   NOT_RUNNING = 0
>   EXECUTING   = 1
>   LATCHED     = 2
> 
> Instead of a cmpxchg to make EXECUTING -> NOT_RUNNING a
> dec_and_test() would work as well. If the dec_and_test brings
> the state to NOT_RUNNING, that is the same as a cmpxchg
> succeeding to change EXECUTING to NOT_RUNNING. If a nested NMI
> were to come in and change it to LATCHED, the dec_and_test() would
> convert the state to EXECUTING (what we want it to be in such a
> case anyway).
> 
> I asked 'slashdot' to post this as a patch, but it never came to
> be. I decided to do the work instead.
> 
> Link: http://lwn.net/Articles/484932/

Okay, slight interrupt here.

The cost of this on real hardware better be zero (which I cannot
immediately judge.)

Why?  Because cmpxchg has been in every CPU since the i486, the i386 is
royally crippled on Linux anyway (due to minor architectural defects,
the main one being the write protect issue) and NMI is almost never used
on i386 as anything other than a fatal error indication.

Most "real" NMI users generate the NMI from the local APIC, but the i386
has no local APIC, and unlike the i486 cannot even have an external
local APIC to the best of my knowledge.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
