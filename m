Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab1I1P7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:59:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab1I1P7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:59:15 -0400
Date: Wed, 28 Sep 2011 17:55:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Stephen Wilson <wilsons@start.ca>, linux-kernel@vger.kernel.org
Subject: Re: Q: x86: add context tag to mark mm when running a task in
	32-bit compatibility mode
Message-ID: <20110928155539.GA10550@redhat.com>
References: <20110927170448.GA15977@redhat.com> <20110927183219.GL2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927183219.GL2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27, Al Viro wrote:
>
> On Tue, Sep 27, 2011 at 07:04:48PM +0200, Oleg Nesterov wrote:
> > --- x/arch/x86/kernel/process_64.c
> > +++ x/arch/x86/kernel/process_64.c
> > @@ -502,10 +502,6 @@ void set_personality_64bit(void)
> >  	/* Make sure to be in 64bit mode */
> >  	clear_thread_flag(TIF_IA32);
> >
> > -	/* Ensure the corresponding mm is not marked. */
> > -	if (current->mm)
> > -		current->mm->context.ia32_compat = 0;
>
> What happens when 32bit task does exec on 64bit binary?

Nothing. This bit is always zero after init_mm(), it can't copy
MMF_COMPAT.

But. This is wrong anyway. I forgot about fork(). We do not want to
uglify copy_mm(), MMF_INIT_MASK should include MMF_COMPAT and then
set_personality_64bit() needs to clear this bit.

Thanks!

> > -	if (current->mm)
> > -		current->mm->context.ia32_compat = 1;
> > +	set_bit(MMF_COMPAT, &current->mm->flags);
>
> ... assuming current->mm is never NULL here.

Yes, but it can't be NULL?

SET_PERSONALITY() can only be called during exec, and it must be called
after exec_mmap() has already installed the new mm != NULL, otherwise
the current code is buggy anyway.

Oleg.

