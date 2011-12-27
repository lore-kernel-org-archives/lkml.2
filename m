Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1L0V6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 16:58:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab1L0V6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 16:58:37 -0500
Date: Tue, 27 Dec 2011 13:58:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111227135836.7102f41b.akpm@linux-foundation.org>
In-Reply-To: <20111227214421.GG17712@google.com>
References: <20111222224117.GL17084@google.com>
	<20111222145426.5844df96.akpm@linux-foundation.org>
	<20111222230047.GN17084@google.com>
	<20111222151649.de57746f.akpm@linux-foundation.org>
	<20111222232433.GQ17084@google.com>
	<20111222154138.d6c583e3.akpm@linux-foundation.org>
	<20111222235455.GT17084@google.com>
	<20111222171432.e429c041.akpm@linux-foundation.org>
	<20111227183402.GF17712@google.com>
	<20111227132056.44ee9281.akpm@linux-foundation.org>
	<20111227214421.GG17712@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Dec 2011 13:44:21 -0800
Tejun Heo <tj@kernel.org> wrote:

> I'm not convinced trying to put this into GFP_KERNEL context would
> work.  Short of that, the next best thing would be making percpu
> allocator useable from memory reclaim path, right?

Well..  All allocations which are weaker than GFP_KERNEL are to be
discouraged.  That being said...

>  But that would
> involved a lot more churn and complexity without much added benefit,
> given that this type of use cases aren't expected to be common - and
> I'm fairly sure it isn't given track record of past few years.

I don't think it would be too hard to add an alloc_percpu_gfp().  Add
the gfp_t to a small number of functions (two or three?) then change
pcpu_mem_zalloc() to always use kzalloc() if (flags & GFP_KERNEL !=
GFP_KERNEL).  And that's it?

But the question is: is this a *good* thing to do?  It would be nice if
kernel developers understood that GFP_KERNEL is strongly preferred and
that they should put in effort to use it.  But there's a strong
tendency for people to get themselves into a sticky corner then take
the easy way out, resulting in less robust code.  Maybe calling the
function alloc_percpu_i_really_suck() would convey the hint.


