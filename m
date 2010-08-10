Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab0HJQFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 12:05:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54286 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab0HJQFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 12:05:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-url:user-agent;
        b=PG8/4ZwGc3tZnABFCDJjGFOh7Rj1c/y2Ms9lPkWGaUzVHZq6AnSXC0WdzzM9meMdSR
         HE8vj+Q3o6718uDCs2e0d/s5lnDMrSUz6DxQppJm/2LQOye52kXKL7thymXr7nbS6zOl
         Qzvn8kGQ0NZEp2dqvsJ08bAQGdNqlLC2SjtPw=
Date: Tue, 10 Aug 2010 13:05:07 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>, David Miller <davem@davemloft.net>,
        willy@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: perf build broke by list_head changes...
Message-ID: <20100810160506.GA21829@ghostprotocols.net>
References: <20100809.235746.115919762.davem@davemloft.net>
 <4C6147DE.9050608@tilera.com>
 <20100810124445.GA14843@merkur.ravnborg.org>
 <20100810134600.GF18824@ghostprotocols.net>
 <20100810143241.GB15073@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100810143241.GB15073@merkur.ravnborg.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 10, 2010 at 04:32:41PM +0200, Sam Ravnborg escreveu:
> On Tue, Aug 10, 2010 at 10:46:00AM -0300, Arnaldo Carvalho de Melo wrote:
> > Idea is to try to have the perf tools, since they are hosted in the
> > kernel and developed mostly by people with kernel background, to use
> > code and practices used in the kernel proper.

> > It started just keeping private copies, I guess it should get back to
> > that since the reaction to this kind of same source repo code sharing
> > was, well, not good :-)

> > Alternatives?
 
> I have not analyzed deeper in what parts perf uses so the following
> may not fly at all.

> One solution could be to let perf rely on a set of exported userspace
> headers from the kernel.

Yeah, finding things that could be shared was part of this exercise, as some
people mentioned that lots of userspace programs out there already have
list.h copies.

Petrifying list.h (and other headers) for the sake of out of the kernel use
probably won't get many supporters, for things that ship and are developed in
the same source repo tho, perhaps can be made possible.

> And on top of this copy a small set of kernel internal headers for use
> by perf only.  The copying will be a good way to document what is
> actually used of the kernel internal stuff.

Yeah, that to me is the easier, non controversial path to take, like done with
hweight.c et all, I'll do that.
 
> But I also realize that just copying over list.h does not suffice. It
> pulls in lots of other stuff.  So this is most likely hard to do.
> 
> I guess first step is to identify what is really used beside the
> exported stuff and start to conclude from there.

This is what I did for hweight.c in:

[acme@doppio linux-2.6-tip]$ git log tools/perf/util/hweight.c 
commit fb72014d98afd51e85aab9c061344ef32d615606
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Fri Apr 30 19:31:12 2010 -0300

    perf tools: Don't use code surrounded by __KERNEL__
    
    We need to refactor code to be explicitely shared by the kernel and at
    least the tools/ userspace programs, so, till we do that, copy the bare
    minimum bitmap/bitops code needed by tools/perf.
    
    Reported-by: "H. Peter Anvin" <hpa@zytor.com>
    Cc: Frédéric Weisbecker <fweisbec@gmail.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    LKML-Reference: <new-submission>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[acme@doppio linux-2.6-tip]$

I will continue that exercise and leave explicitely sharing stuff with
the kernel for later, if ever.

Then we will just have to track changes to the initially shared stuff so
that we don't miss fixes like described in the cset where some of this
sharing was started:

commit 43cbcd8acb4c992cbd22d1ec8a08c0591be5d719
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Wed Jul 1 12:28:37 2009 -0300

    perf_counter tools: Share rbtree.with the kernel
    
    The tools/perf/util/rbtree.c copy already drifted by three
    csets:
    
     4b324126e0c6c3a5080ca3ec0981e8766ed6f1ee
     4c60117811171d867d4f27f17ea07d7419d45dae
     16c047add3ceaf0ab882e3e094d1ec904d02312d

    So remove the copy and use the lib/rbtree.c directly, sharing
    the source code while still generating a separate object file,
    since tools/perf uses a far more agressive -O6 switch.
    
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    LKML-Reference: <20090701152837.GG15682@ghostprotocols.net>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

- Arnaldo
