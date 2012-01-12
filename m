Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2ALV6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:58:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2ALV6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:58:04 -0500
Date: Thu, 12 Jan 2012 13:58:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <kirkland@canonical.com>, ecryptfs@vger.kernel.org
Subject: Re: [PATCH] mm: Don't warn if memdup_user fails
Message-Id: <20120112135803.1fb98fd6.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1201121309340.17287@chino.kir.corp.google.com>
References: <1326300636-29233-1-git-send-email-levinsasha928@gmail.com>
	<20120111141219.271d3a97.akpm@linux-foundation.org>
	<1326355594.1999.7.camel@lappy>
	<CAOJsxLEYY=ZO8QrxiWL6qAxPzsPpZj3RsF9cXY0Q2L44+sn7JQ@mail.gmail.com>
	<alpine.DEB.2.00.1201121309340.17287@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012 13:19:54 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Thu, 12 Jan 2012, Pekka Enberg wrote:
> 
> > I think you missed Andrew's point. We absolutely want to issue a
> > kernel warning here because ecryptfs is misusing the memdup_user()
> > API. We must not let userspace processes allocate large amounts of
> > memory arbitrarily.
> > 
> 
> I think it's good to fix ecryptfs like Tyler is doing and, at the same 
> time, ensure that the len passed to memdup_user() makes sense prior to 
> kmallocing memory with GFP_KERNEL.  Perhaps something like
> 
> 	if (WARN_ON(len > PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER))
> 		return ERR_PTR(-ENOMEM);
> 
> in which case __GFP_NOWARN is irrelevant.

If someone is passing huge size_t's into kmalloc() and getting failures
then that's probably a bug.  So perhaps we should add a warning to
kmalloc itself if the size_t is out of bounds, and !__GFP_NOWARN.

That might cause problems with those callers who like to call kmalloc()
in a probing loop with decreasing size_t.


But none of this will be very effective.  If someone is passing an
unchecked size_t into kmalloc then normal testing will not reveal the
problem because the testers won't pass stupid numbers into their
syscalls.

