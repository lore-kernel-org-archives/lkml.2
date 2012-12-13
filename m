Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab2LMOjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:39:01 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45841 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932136Ab2LMOi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:38:58 -0500
Date: Thu, 13 Dec 2012 19:38:07 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] uprobes: Kill the pointless inode/uc checks in
 register/unregister
Message-ID: <20121213140807.GF29086@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121123202741.GA18858@redhat.com>
 <20121123202806.GA18887@redhat.com>
 <20121210061901.GF22164@linux.vnet.ibm.com>
 <20121210191232.GA32462@redhat.com>
 <20121213103548.GC29086@linux.vnet.ibm.com>
 <20121213131540.GA11862@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121213131540.GA11862@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121314-5806-0000-0000-00001CEF0D34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >
> > > I agree, sometimes it makes sense to protect against the stupid mistakes,
> > > but if we want to check against NULL we should do
> > >
> > > 	if (WARN_ON(!inode))
> > > 		return;
> > >
> >
> > agree, that warn_on is better than a simple check
> 
> and this one
> 
> 	if (WARN_ON(inode < PAGE_OFFSET))
> 
> is even better ;)

Okay.

> 
> > > Especially in uprobe_unregister(). The current code is really "hide
> > > the possible problem" and nothing more. It is better to crash imho
> > > than silently return.
> > >
> > > > > register() also checks uc->next == NULL, probably to prevent the
> > > > > double-register but the caller can do other stupid/wrong things.
> > > >
> > > > Users can surely do more stupid things. But this is again something that
> > > > kernel can identify. By allowing a double-register of a consumer, thats
> > > > already registered, we might end up allowing circular loop of consumers.
> > >
> > > I understand. But in this case we should document that uc->next must
> > > be cleared before uprobe_register(). Or add init_consumer().
> > >
> > > And we should change uprobe_unregister() to clear uc->next as well.
> > > I think that the code like this
> > >
> > > 	uprobe_register(uc);
> > > 	uprobe_unregister(uc);
> > >
> > > 	uprobe_register(uc);
> > >
> > > should work. Currently it doesn't because of this check.
> > >
> >
> > yes, these should work and makes a case to nullify ->next on unregister.
> >
> > However, what if someone tries
> >
> > 	uprobe_register(uc1);
> > 	uprobe_register(uc2);
> > 	uprobe_register(uc1);
> >
> > i.e somebody tries to re-register uc1, while its active and has a valid
> > next. After the re-registration of uc1, the uprobe->consumers will no more reference uc2.
> 
> Yes. And even without uprobe_register(uc2) the result won't be good.
> This is like list_add(node).
> 
> > Should we leave this case as a fool shooting himself?
> 
> IMHO yes, or we should create init_consumer() or at least document that
> the private ->next member should be nullified.
> 

Okay, Since we agree that its a user mistake. So lets document this and
continue with what you propose.

