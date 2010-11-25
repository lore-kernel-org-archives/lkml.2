Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0KYAgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 19:36:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36785 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab0KYAgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 19:36:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=d6i/qE/Jt2g2YBpLUY9x+hDTVNd+BF7cg3v2PtmdE1hTtG5YVNSGBxF0JRFduJ9WaW
         iHjxu/40MeS8anMC5bedET+GMxUpVM3YyXizqfOEj8Plwy3JlwKv2ahQDgRY0wZ2hBLc
         dtsM/G4sYhCF+5aRz2daq/B0J0pDF/jg0qF0U=
MIME-Version: 1.0
In-Reply-To: <1290544913-489129-3-git-send-email-hans.rosenfeld@amd.com>
References: <AANLkTinBsut0Csubh1N85jkydH7wCp3YniASE-vyf7MP@mail.gmail.com>
	<1290544913-489129-3-git-send-email-hans.rosenfeld@amd.com>
Date: Wed, 24 Nov 2010 19:36:34 -0500
Message-ID: <AANLkTikwo+tdyiT=L9TOyN3Pk8nqpibdokN1X5mZx-pZ@mail.gmail.com>
Subject: Re: [RFC 2/2] x86, xsave: rework xsave support
From: Brian Gerst <brgerst@gmail.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, robert.richter@amd.com,
        andreas.herrmann3@amd.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 3:41 PM, Hans Rosenfeld <hans.rosenfeld@amd.com> wrote:
> This is an attempt to rework the code that handles FPU and related
> extended states. Since FPU, XMM and YMM states are just variants of what
> xsave handles, all of the old FPU-specific state handling code will be
> hidden behind a set of functions that resemble xsave and xrstor. For
> hardware that does not support xsave, the code falls back to
> fxsave/fxrstor or even fsave/frstor.
>
> A xstate_mask member will be added to the thread_info structure that
> will control which states are to be saved by xsave. It is set to include
> all "lazy" states (that is, all states currently supported) by the #NM
> handler when a lazy restore is triggered or by switch_to() when the
> tasks FPU context is preloaded. Xstate_mask is intended to completely
> replace TS_USEDFPU in a later cleanup patch.
>
> When "non-lazy" states such as for LWP will be added later, the
> corresponding bits in xstate_mask are supposed to be set for all threads
> all the time. There will be no performance penalty for threads not using
> these states, as xsave and xrstor will ignore unused states.
>
> This patch is not complete and not final at all. Support for 32bit is
> lacking, and the context handling for signals will probably change
> again. I haven't benchmarked it yet, but I have tested it for both the
> fxsave and xsave cases.

Looks good, but I would suggest adding wrappers for save_states() and
restore_xstates() that handle preemption, like how unlazy_fpu() was.

--
Brian Gerst
