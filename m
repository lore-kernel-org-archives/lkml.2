Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0FADzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:55:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119Ab0FADze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:55:34 -0400
Date: Mon, 31 May 2010 20:51:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Brandon Philips <brandon@ifup.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Tejun Heo <htejun@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/2] Make the module 'usage' lists be two-way
In-Reply-To: <20100601024439.GA5134@cr0.nay.redhat.com>
Message-ID: <alpine.LFD.2.00.1005312041070.3637@i5.linux-foundation.org>
References: <201005252300.07739.rjw@sisk.pl> <201005312130.17038.rusty@rustcorp.com.au> <201005312131.43238.rusty@rustcorp.com.au> <201005312132.28631.rusty@rustcorp.com.au> <20100531094834.c1a684d1.akpm@linux-foundation.org> <alpine.LFD.2.00.1005311100220.3986@i5.linux-foundation.org>
 <alpine.LFD.2.00.1005311311490.3637@i5.linux-foundation.org> <alpine.LFD.2.00.1005311315460.3637@i5.linux-foundation.org> <20100601024439.GA5134@cr0.nay.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jun 2010, Américo Wang wrote:
> >+	list_for_each_entry_safe(use, tmp, &mod->target_list, target_list) {
> >+		struct module *i = use->target;
> >+		DEBUGP("%s unusing %s\n", mod->name, i->name);
> >+		module_put(i);
> >+		list_del(&use->source_list);
> >+		list_del(&use->target_list);
> >+		kfree(use);
> >+		sysfs_remove_link(i->holders_dir, mod->name);
> 
> I think it's nice to have a remove_module_usage() here, since we already
> have add_module_usage().

I agree that those five lines could easily be a function of their own. It 
would make sense and be symmetric. That said, I didn't do it because there 
was just a single use place, and it was so simple.

Also, if you do turn it into a function, it's a bit dubious what the 
proper calling convention would be. The clean interface would be to just 
pass in "use", since you can figure out both the source and target from 
there. At the same time, it's a bit sad to re-load "mod" from 
"use->source", when we had it explicitly and started from it.  But maybe 
that doesn't really matter.

One thing I react to now that I look at it again - I think we should also 
move the "module_put(i)" to the end. In fact I thought I did it when I 
moved the code around, but clearly I hadn't.

It won't really matter as-is (we hold the module_mutex, so "i" isn't going 
away), and it's what the old code used to do, but we should probably aim 
for more of a ref-counted worldview where you don't put the module until 
after it's not used again. And we clearly still use "i" after the 
module_put() above in the sysfs_remove_link thing. So that's a bit ugly 
too.

I suspect the module code could do with quite a bit of a cleanup. The 
primary target of that patch was a different issue, though.

		Linus
