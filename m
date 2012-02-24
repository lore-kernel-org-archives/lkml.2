Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab2BXTDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:03:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38889 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2BXTDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:03:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of segooon@gmail.com designates 10.204.10.91 as permitted sender) smtp.mail=segooon@gmail.com; dkim=pass header.i=segooon@gmail.com
Date: Fri, 24 Feb 2012 22:58:25 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Windsor <dwindsor@gmail.com>, Roland Dreier <roland@purestorage.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        linux-kernel@vger.kernel.org, pageexec@freemail.hu,
        spender@grsecurity.net
Subject: Re: [kernel-hardening] Re: Add overflow protection to kref
Message-ID: <20120224185825.GA11818@albatros>
References: <20120216204515.GH20420@outflux.net>
 <20120217002405.GB7746@kroah.com>
 <20120217075945.GA2831@albatros>
 <20120217175445.GC29902@kroah.com>
 <20120217193719.GA4187@albatros>
 <20120217233908.GA24047@dztty>
 <CAL1RGDWM0C26YR+GGbguRQd0R3HoPJ5QVyEFkLGFfPqs6wb5Mg@mail.gmail.com>
 <20120218161849.GA4176@kroah.com>
 <CAEXv5_jYj=cHsePJEf4f08KsBOfU+MVMnV0DucmVKQbg+KbxrQ@mail.gmail.com>
 <20120224183726.GB23284@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224183726.GB23284@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 10:37 -0800, Greg KH wrote:
> On Fri, Feb 24, 2012 at 12:58:35PM -0500, David Windsor wrote:
> >  static inline void kref_get(struct kref *kref)
> >  {
> > +   int rc = 0;
> >     WARN_ON(!atomic_read(&kref->refcount));
> > -   atomic_inc(&kref->refcount);
> > +   smp_mb__before_atomic_inc();
> > +   rc = atomic_add_unless(&kref->refcount, 1, INT_MAX);
> > +   smp_mb__after_atomic_inc();
> > +   BUG_ON(!rc);
> 
> So you are guaranteeing to crash a machine here if this fails?  And you
> were trying to say this is a "security" based fix?
> 
> And people wonder why I no longer have any hair...

If a refcounter overflows there is NO WAY to recover.  The choise is to BUG()
and not allow any security harm to the system (privilege escalation, etc.)
or to try to do some more CPU cycles until actual use after free, privilege
escalation, etc.  The former is a _guarantee_ that nothing bad (in security
sense) doesn't happen.  The latter is an opportunistic approach, which
doesn't work with security.

Do you claim that a refcounter overflow is a recoverable state?  I'd want to
know what you can do with it.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
