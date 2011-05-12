Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab1ELKXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:23:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34424 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab1ELKXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pGXFjoa0UyV/kqcEzszACVuNuTVYSRDBn6Hc28jnE94qN+UrQFcxJwjEehdFrj2gZ0
         o2UhKnkSzXLP/BAwmPDNmlfdGlI0SOC9jcHEMLOrAewetrbiy8n9hJRLmHf4BCKo46TJ
         LsCa59vsbXPICXu4x8HWmTOhM3wMdUfj35nis=
Date: Thu, 12 May 2011 12:23:34 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and
 ptrace_check_attach()
Message-ID: <20110512102325.GF1030@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-11-git-send-email-tj@kernel.org>
 <20110511164947.GA26383@redhat.com>
 <20110511195333.GE24245@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511195333.GE24245@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, May 11, 2011 at 09:53:33PM +0200, Tejun Heo wrote:
> > As for ptrace_check_attach(), it can simply do wait_event(), we
> > only need to verify the caller is the tracer. No need to play with
> > lock/unlock/retry.
> > 
> > What do you think?
> 
> Hmmm... interesting.  Yeah, the state is visible only through wait(2)
> and ptrace(2) and for wait(2) TRAPPING is as good as STOPPED/TRACED
> and we can wait all we want in ptrace_check_attach().  I'll think more
> about it but seems like a nice idea.

Eh, problem.  Please consider the following scenario.

* A task is in TASK_STOPPED.  current->exit_code contains zero.

* Tracer seizes the task which triggers TRAPPING.

* Tracer wait(2)s which sees TRAPPING but tracee->exit_code is still
  zero.

I think retrying and ensuring that tracee is in the expected state
after going through the regular trapping procedure is better way to
handle this.  Bypassing wait(2) seems smart and simple but it entails
much more subtleties than simple stupid waiting/retrying.

Thanks.

-- 
tejun
