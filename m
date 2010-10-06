Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab0JFLMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 07:12:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39029 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab0JFLMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 07:12:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RAyPMwARNtgLT1ki/KYSoo02YQ1LjWVgcjoGWkWEzrqA5+rxefH1X1mK+6wEbcited
         sjOWroDoX+D1pesdiHZxVR74F54gLbANu32MOYNLtxdhjcfHWEP0mwKZKan78ifOPW9I
         4hx41sKTPliXqb5vns9gCP7B6NZ5B/PINqwGk=
MIME-Version: 1.0
In-Reply-To: <1286303429-415145-4-git-send-email-hans.rosenfeld@amd.com>
References: <20101005182739.GE173@escobedo.osrc.amd.com>
	<1286303429-415145-4-git-send-email-hans.rosenfeld@amd.com>
Date: Wed, 6 Oct 2010 07:12:11 -0400
Message-ID: <AANLkTinBsut0Csubh1N85jkydH7wCp3YniASE-vyf7MP@mail.gmail.com>
Subject: Re: [RFC 3/3] Save/restore LWP state in context switches.
From: Brian Gerst <brgerst@gmail.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 2:30 PM, Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> LWP (Light-Weight Profiling) is a new per-thread profiling mechanism
> that can be enabled by any thread at any time if the OS claims to
> support it (by setting a bit in XCR0). A threads LWP state
> (configuration & unsaved collected data) is supposed to be saved and
> restored with xsave and xrstor by the OS.
>
> Unfortunately, LWP does not support any kind of lazy switching, nor does
> it use the TS bit in CR0. Since any thread can enable LWP at any time
> without the kernel knowing, the context switch code is supposed to
> save/restore LWP context unconditionally. This would require a valid
> xsave state area for all threads, whether or not they use any FPU or LWP
> functionality. It would also make the already complex lazy switching
> code more complicated.
>
> To avoid this memory overhead, especially for systems not supporting
> LWP, and also to avoid more intrusive changes to the code that handles
> FPU state, this patch handles LWP separately from the FPU. Only if a
> system supports LWP, the context switch code checks whether LWP has been
> used by the thread that is being taken off the CPU by reading the
> LWP_CBADDR MSR, which is nonzero if LWP has been used by the thread.
> Only in that case the LWP state is saved to the common xsave area in the
> threads FPU context. This means, of course, that an FPU context has to
> be allocated and initialized when a thread first uses LWP before using
> the FPU.
>
> Similarly, restoring the LWP state is only done when an FPU context
> exists and the LWP bit in the xstate header is set.
>
> To make things a little more complicated, xsave and xrstor _do_ use the
> TS bit and trap when it is set. To avoid unwanted traps, the TS bit has
> to be cleared before and restored after doing xsave or xrstor for LWP.
>
> Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>

I would prefer to see the xsave code refactored so that you would only
need one xsave/xrstor call per context switch.  We are currently
treating xsave as an extension to the FPU state.  But it would be
better to treat FPU as a subset of the extended state.  That way more
state can be added without touching the FPU code..

--
Brian Gerst
