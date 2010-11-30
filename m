Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab0K3AGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:06:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55730 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab0K3AGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:06:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [resend][PATCH 4/4] oom: don't ignore rss in nascent mm
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        pageexec@freemail.hu, Solar Designer <solar@openwall.com>,
        Eugene Teo <eteo@redhat.com>, Brad Spengler <spender@grsecurity.net>,
        Roland McGrath <roland@redhat.com>
In-Reply-To: <20101129113357.GA30657@redhat.com>
References: <20101129093803.829F.A69D9226@jp.fujitsu.com> <20101129113357.GA30657@redhat.com>
Message-Id: <20101130085254.82CF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 30 Nov 2010 09:06:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 11/29, KOSAKI Motohiro wrote:
> >
> > > The patch is not complete, compat_copy_strings() needs changes.
> > > But, shouldn't it use get_arg_page() too? Otherwise, where do
> > > we check RLIMIT_STACK?
> >
> > Because NOMMU doesn't have variable length argv. Instead it is still
> > using MAX_ARG_STRLEN as old MMU code.
> >
> > 32 pages hard coded argv limitation naturally prevent this nascent mm
> > issue.
> 
> Ah, I didn't mean NOMMU. I meant compat_execve()->compat_copy_strings().
> If a 32bit process execs we seem to miss the RLIMIT_STACK check, no?

Ah, yes. that's bug. You have found more serious issue ;)



> > > The patch asks for the cleanups. In particular, I think exec_mmap()
> > > should accept bprm, not mm. But I'd prefer to do this later.
> > >
> > > Oleg.
> >
> > General request. Please consider to keep Brad's reported-by tag.
> 
> Yes, yes, sure.
> 
> > > +static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
> 
> OK.
> 
> > Please move this function into #ifdef CONFIG_MMU. nommu code doesn't use it.
> 
> Well it does, to revert the MM_ANONPAGES counter. I'll add the empty
> function for NOMMU.
> 
> > > +{
> > > +	struct mm_struct *mm = current->mm;
> > > +	long diff = pages - bprm->vma_pages;
> >
> > I prefer to cast signed before assignment. It's safer more.
> 
> OK.
> 
> > > @@ -1003,6 +1024,7 @@ int flush_old_exec(struct linux_binprm *
> > >  	/*
> > >  	 * Release all of the old mmap stuff
> > >  	 */
> > > +	acct_arg_size(bprm, 0);
> >
> > Why do we need this unacct here? I mean 1) if exec_mmap() is success,
> > we don't need unaccount at all
> 
> Yes, we already killed all sub-threads. But this doesn't mean nobody
> else can use current->mm, think about CLONE_VM. The simplest example
> is vfork().

Right you are.


> > 2) if exec_mmap() is failure, an epilogue of
> > do_execve() does unaccount thing.
> 
> Yes.
> 
> Thanks Kosaki!
> 
> I'll resend v2 today. I am still not sure about compat_copy_strings()...
> 
> Oleg.
> 



