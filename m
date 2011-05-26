Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1EZJOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:14:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59448 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1EZJOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pMjePpKpPgyBA/c6kaR4te2wcyyrMkbPRz2xEXbVidFybdxjb4FLf5ZI05dOn7zMIo
         2AYwcudx5QxjY3i7VpIsY7ceSIjqGcvNv40gyUqa/yK9R7bxhH1TaFbeSHmL2tPbTxox
         xii8ZTwTX/2sK6zUPydrJ8sTUuDzTSyJrY3K8=
Date: Thu, 26 May 2011 11:14:01 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110526091401.GD9715@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-4-git-send-email-tj@kernel.org>
 <201105180240.56754.vda.linux@googlemail.com>
 <20110518095539.GU20624@htj.dyndns.org>
 <20110523124314.GA7232@redhat.com>
 <20110524102834.GC10334@htj.dyndns.org>
 <20110525182919.GB16575@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525182919.GB16575@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 25, 2011 at 08:29:19PM +0200, Oleg Nesterov wrote:
> > > And. Currently there is no way to detach a zombie leader. Perhaps we
> > > should change do_wait(), but it is not clear what should we do if the
> > > tracer is the real parent (we already discussed this a bit).
> >
> > Hmmm... maybe just allow detaching zombie leader?
> 
> Yes, I think we should do this.
> 
> If we change PTRACE_DETACH (or add the new request) to allow this, then
> I think it it should detach any zombie, leader or not.

I think we can just make PTRACE_DETACH to succeed for zombies.  No
reason to add a new request for this.

> Or we can change do_wait() to detach a zombie leader. In this case it
> is not clear what should we do if the debugger is the real parent.
> Perhaps do_wait() should do the same: detach a leader (but not reap).
> When the last thread does, the real parent will be notified again.
> IOW, wait(tgid) can succeed twice.

Just letting PTRACE_DETACH work for zombies sounds much simpler to me.

> > As it's guaranteed to be not running, we don't have problem with
> > ptrace_disable.
> 
> Agreed. In fact it can be running, but it can't return to the user-space,
> and I think this is enough.
> 
> ptrace_detach()->ptrace_disable() can race with SIGKILL anyway, this means
> it should safe to call it if the tracee is exiting/exited.

Yeap, unless userland gets to run again, I don't think there's any
problem.

Thanks.

-- 
tejun
