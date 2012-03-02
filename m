Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab2CBB3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:29:31 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33421 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab2CBB33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:29:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of vda.linux@googlemail.com designates 10.213.105.140 as permitted sender) smtp.mail=vda.linux@googlemail.com; dkim=pass header.i=vda.linux@googlemail.com
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: Questions about ptrace on a dying process
Date: Fri, 2 Mar 2012 02:29:25 +0100
User-Agent: KMail/1.8.2
Cc: Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        linux kernel <linux-kernel@vger.kernel.org>
References: <4F4E6915.1010209@am.sony.com> <201203010812.54769.vda.linux@googlemail.com> <4F4FBD65.7020006@am.sony.com>
In-Reply-To: <4F4FBD65.7020006@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201203020229.25267.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012 19:18, Tim Bird wrote:
> On 02/29/2012 11:12 PM, Denys Vlasenko wrote:
> > On Wednesday 29 February 2012 21:45, Tim Bird wrote:
> >> This is on embedded systems, where the dump is not saved.  The dump
> >> is available via stdin to the core pipe handler, but it would be
> >> kind of a pain to wrapper that for random access, which is needed
> >> for stuff like stack unwinding.
> > 
> > Stack unwinding only requires the stack data and knowledge
> > of the mapped binary and library files. You can parse coredump's ELF header,
> > and skip all sizable data segments which you won't need anyway.
> > 
> > I estimate that usually you will need to save only ~150k of data
> > in order to produce a stacktrace, and even then,
> > only because Linux pre-allocates ridiculously large
> > stack for every new process - 132k. It can easily be reduced
> > to something saner with one-line patch.
> 
> My budget for each crash report is about 8k.  I have to do
> the unwind at the time of the crash (on target) (and without
> symbols - these are added later on a host).  Given the other
> stuff I want to save, saving the whole stack is usually not
> an option, and saving a coredump is out of the question.

How about this algorithm?

Read coredump sequentially. First come ELF header and program headers.
Read headers and remember their virtual address ranges, sizes, and flags.
The rest you don't need.

Then comes NOTE segment. Parse it and fetch the value of stack pointer
register. Don't save anything else.

Then read LOAD segments and discard their data until you reach a
stack segment (one which stack pointer points to).

Read all words from stack starting from stack pointer up to the top
of the stack. If a word, when interpreted as a pointer, points into
an executable segment, then add it to stack trace. Else, ignore the word.

After you finished reading the stack, read and discard the rest (there
usually is nothing after stack).

Then you can sanitize stack trace: if some addresses there point
to a *beginning* of a function, not in the middle of it,
then it's likely a false positive (someone was passing function
pointer parameter, or had it in on-stack auto variable).
To do this sanitization, you don't need (and can't use, even if you'd have it)
coredump - you need to examine binary and libraries instead.

But I suspect even without sanitizing it, resulting stack trace
will often be rather good: it will contain all real return addresses,
and often will have no false positives at all.

-- 
vda
