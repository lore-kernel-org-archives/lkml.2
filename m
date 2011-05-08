Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab1EHWnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 18:43:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35811 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab1EHWm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 18:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=H9dKX19Ymh08pVSLRxoIjYOQwYiVyxtOx8VlBHT8bLJgVWbg0djFUg7SFRNryFAivK
         2D3f7XX549KD2SZ0bWROjJWzDIg6nsnOJH/Ax7GAMkXGpdFc7B9o7VLsgvjoH3dZIgIS
         CvOZfvg/MCX1R7IluqAyPF7AwZyBjCHm3YHpk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/11] ptrace: implement group stop notification for ptracer
Date: Mon, 9 May 2011 00:42:55 +0200
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
Message-Id: <201105090042.55599.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 May 2011 17:49, Tejun Heo wrote:
> Currently there's no way for ptracer to find out whether group stop
> that tracee was in finished other than polling with PTRACE_GETSIGINFO.
> Also, tracer can't detect new group stop started by an untraced thread
> if tracee is already trapped.  This patch implements group stop
> notification for ptracer using INTERRUPT traps.
> 
> When group stop state of a seized tracee changes, JOBCTL_TRAP_NOTIFY
> is set, which triggers INTERRUPT trap but is sticky until the next
> PTRACE_GETSIGINFO.  As GETSIGINFO exports the current group stop
> state, this guarantees that tracer checks the current group stop state
> at least once after group stop state change.  Stickiness is necessary
> because notification trap may race with PTRACE_CONT for other traps
> and get lost.

To clarify on "sticky":

Does this mean that if tracer userspace won't query PTRACE_GETSIGINFO,
but will simply do:

                  waitid(P_PID, tracee, NULL, WSTOPPED);
                  ptrace(PTRACE_CONT, tracee, NULL, NULL);

then kernel will generate INTERRUPT trap again and again
(without letting tracee run) if job stop state of the tracee has changed?


-- 
vda
