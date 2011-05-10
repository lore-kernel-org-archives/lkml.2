Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1EJWhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:37:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49003 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1EJWhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:37:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=OGX1a2rml4fOZu6cbX7+IBpCdmZxYOYb8yPRt768/ssvzJuDk5Vzct+4qGYyH9MxKr
         kQO6FeyexoaXkffEGw5aPsRDOsID9GUKyU7pgWkwojAch/YJijAbIhk81lCXRVcR8+/b
         GyhFgsM2aj77PoQETRnp+Q0PyAcDHRY5YFKZ0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/11] ptrace: implement group stop notification for ptracer
Date: Wed, 11 May 2011 00:37:34 +0200
User-Agent: KMail/1.8.2
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-12-git-send-email-tj@kernel.org>
In-Reply-To: <1304869745-1073-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201105110037.34051.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 May 2011 17:49, Tejun Heo wrote:
> Currently there's no way for ptracer to find out whether group stop
> that tracee was in finished other than polling with PTRACE_GETSIGINFO.
> Also, tracer can't detect new group stop started by an untraced thread
> if tracee is already trapped.  This patch implements group stop
> notification for ptracer using INTERRUPT traps.

Group stop notification already is performed by current kernels.
What we don't have is "group cont notification".

> When group stop state of a seized tracee changes, JOBCTL_TRAP_NOTIFY
> is set, which triggers INTERRUPT trap but is sticky until the next
> PTRACE_GETSIGINFO.

Why INTERRUPT trap? For group stops, we already have perfectly working
way to detect such a stop.

Can we just add a "group cont" notification which looks like
a waitpid result with WIFCONTINUED(waitpid_status) == 1 to the tracer?


> -EINVAL return from GETSIGINFO also clears the sticky trap.  This is
> because -EINVAL clearly indicates that tracee is in group stop.  To
> avoid unnecessarily taking INTERRUPT trap on the way to group stop, if
> JOBCTL_STOP_PENDING is set, INTERRUPT trap is not taken.

Exactly.


> Re-trapping is used only for group stop and INTERRUPT traps.  If
> tracer wants to get notified about group stop, it either leaves tracee
> in the initial group stop trap or puts it into INTERRUPT trap.  When
> INTERRUPT trap is scheduled while tracee is already in a trap,

Sane tracer has no need to do PTRACE_INTERRUPT on a tracee
which is already stopped (for whatever reason): it already knows
it's stopped, and why. PTRACE_INTERRUPT is useful to cleanly stop
_running_ tracees.


-- 
vda
