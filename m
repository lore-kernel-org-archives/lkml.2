Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab1ERAlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:41:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55752 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab1ERAlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=rz5g/sr68haM5mkWnB8UVJKMSyUFfVzjYXozebWCD71RMlTGSOfIY6dlXIF2lUR7IJ
         1zc4NX+WCC6i4nvGBpaWaSFjL0tjbtwoePMRaGcT8KpljfXE8B1ySMYSF2Au2+pepbSA
         ZYSDo8eK2YxdOqTH0j7oC33cnwaiB8UEIE2lw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Date: Wed, 18 May 2011 02:40:56 +0200
User-Agent: KMail/1.8.2
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
References: <1305569849-10448-1-git-send-email-tj@kernel.org> <1305569849-10448-4-git-send-email-tj@kernel.org>
In-Reply-To: <1305569849-10448-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201105180240.56754.vda.linux@googlemail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 May 2011 20:17, Tejun Heo wrote:
> PTRACE_ATTACH implicitly issues SIGSTOP on attach which has side
> effects on tracee signal and job control states.  This patch
> implements a new ptrace request PTRACE_SEIZE which attaches and traps
> tracee without affecting its signal and job control states.
> 
> The usage is the same with PTRACE_ATTACH but it takes PTRACE_SEIZE_*
> flags in @data.  Currently, the only defined flag is
> PTRACE_SEIZE_DEVEL which is a temporary flag to enable PTRACE_SEIZE.
> PTRACE_SEIZE will change ptrace behaviors outside of attach itself.
> The changes will be implemented gradually and the DEVEL flag is to
> prevent programs which expect full SEIZE behavior from using it before
> all the behavior modifications are complete while allowing unit
> testing.  The flag will be removed once SEIZE behaviors are completely
> implemented.
> 
> After PTRACE_SEIZE, tracee will trap.  Which trap will happen isn't
> fixed.  If other trap conditions exist (e.g. signal delivery), they
> might be taken; otherwise, a trap with exit_code == (SIGTRAP |
> PTRACE_EVENT_STOP << 8) is taken.  If seized, this trap is also used
> for group stop traps instead of exit_code == 0 with NULL GETSIGINFO.
> 
> * PTRACE_SEIZE doesn't affect signal or group stop state.
> 
> * After PTRACE_SEIZE, one trap will happen which might be a
>   PTRACE_EVENT_STOP trap.
> 
> * If PTRACE_SEIZE'd, group stop also uses PTRACE_EVENT_STOP trap which
>   uses exit_code of (SIGTRAP | PTRACE_EVENT_STOP << 8) instead of the
>   stopping signal number and returns usual trap siginfo on
>   PTRACE_GETSIGINFO instead of NULL.
> 
> Note that there currently is no way to find out the stopping signal
> number while seized.  This will be improved by future patches.
> 
> Seizing sets PT_SEIZED in ->ptrace of the tracee.  This flag will be
> used to determine whether new SEIZE behaviors should be enabled.

This makes PTRACE_EVENT_STOP similar to other PTRACE_EVENTs.
The only difference is that it can't be set by PTRACE_SETOPTIONS
as other events do, but activated implicitly by PTRACE_SEIZE.

This made me thinking.

How about making API even more similar to existing one?

Create PTRACE_O_TRACESTOP, make it settable by PTRACE_SETOPTIONS too.

Make PTRACE_SEIZE take the mask of PTRACE_O_xyz flags
as data argument.
If PTRACE_O_TRACESTOP is set, it works as you described above.
If PTRACE_O_TRACESTOP is not set, then it works as good old PTRACE_ATTACH.
In both cases, immediately at attach it sets opts a-la PTRACE_SETOPTIONS.

We can even avoid introducing PTRACE_SEIZE at all, because
currently PTRACE_ATTACH ignores its data argument.

I know, I know, "this changes API", but did we ever promise
that PTRACE_ATTACH with nonzero data arg is a valid usage?
Also, I perused first 10 pages of google code search results
and I see that everybody passes 0 or NULL.

-- 
vda
