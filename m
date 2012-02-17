Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab2BQAeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:34:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56608 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2BQAeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:34:16 -0500
Date: Fri, 17 Feb 2012 00:34:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        tyhicks@canonical.com
Subject: Re: hugetlbfs lockdep spew revisited.
Message-ID: <20120217003415.GM23916@ZenIV.linux.org.uk>
References: <20120217000856.GA13112@redhat.com>
 <20120217001634.GH23550@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120217001634.GH23550@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 07:16:34PM -0500, Josh Boyer wrote:
> On Thu, Feb 16, 2012 at 07:08:57PM -0500, Dave Jones wrote:
> > Remember this ? https://lkml.org/lkml/2011/4/15/272
> > Josh took a stab at fixing it in e096d0c7e2e4e5893792db865dd065ac73cf1f00,
> > but it seems to still be there.
> 
> I think Tyler Hicks actually noticed this a while ago, but his patch has
> been waiting on comment from Al and Christoph:
> 
> http://thread.gmane.org/gmane.linux.file-systems/58795/focus=59565
> 
> I've been hesitant to comment because I obviously screwed up once
> already.  We could try this patch in Fedora for a while if Al and
> company don't speak up soon.

That has nothing to do with the deadlock in question; it's *NOT* about
directories at all and no, it's not a false positive.

This is very simple: ->mmap() should never take ->i_mutex.  Directories
have nothing to do with that.  Simple grep for i_mutex in fs/hugetlbfs/*.c
will instantly show its use for non-directories, with pagefaults taken
while holding it.  Pagefault handlers take ->mmap_sem; so does ->mmap()
caller.  QED.
