Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1FBFDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:03:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43899 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1FBFDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e8ZOnzXbujJ+u84adiemBEQF0DsXr0b8vemTXLImOm+JVi5ZWfhrBOZ6Kmaz9gTfzc
         yXAbN2f/j3PLoN+5cSVEtYv0J+9tlImLYvTGCMMIOwtxS15ACzuuv9xXqXLWVEKu3A16
         bl7UkEQYTp4gi2NUC5PCoDwARhYh+y5Xo36Jo=
Date: Thu, 2 Jun 2011 14:03:40 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu, bdonlan@gmail.com,
        pedro@codesourcery.com
Subject: Re: [PATCH 01/17] ptrace: remove silly wait_trap variable from
 ptrace_attach()
Message-ID: <20110602050340.GB17434@mtj.dyndns.org>
References: <1306710760-16440-1-git-send-email-tj@kernel.org>
 <1306710760-16440-2-git-send-email-tj@kernel.org>
 <20110601184743.GA6504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110601184743.GA6504@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 01, 2011 at 08:47:43PM +0200, Oleg Nesterov wrote:
> On 05/30, Tejun Heo wrote:
> > -	if (wait_trap)
> > -		wait_event(current->signal->wait_chldexit,
> > -			   !(task->group_stop & GROUP_STOP_TRAPPING));
> > +	wait_event(current->signal->wait_chldexit,
> > +		   !(task->group_stop & GROUP_STOP_TRAPPING));
> >  	return retval;
> 
> Well, it doesn't change anything, but only if ptrace_attach() succeeds.
> The caller should not wait if STOP_TRAPPING was already set by another
> tracer and we are going to fail. Afaics, nothing really bad can happen
> but still this doesn't look very clean.
> 
> And. Please note that this patch is buggy until 8/17 "use bit_waitqueue
> for TRAPPING", wait_event(current->signal->wait_chldexit) can hang forever
> in this case since we are not ->parent.

Ah, darn it.  It was part of later patch which got dropped and I just
salavaged this part and put it at the front forgetting about the
chldexit conversion.

> I agree, wait_trap should go away. We can hit STOP_TRAPPING after attach
> if we change detach to set this bit. But perhaps it would be more clean
> to not call wait_event/wait_bit unconditionally anyway, we can check
> retval == 0.

Yeap, that sounds about right.  Will post updated patch.

Thanks.

-- 
tejun
