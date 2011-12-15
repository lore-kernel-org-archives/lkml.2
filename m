Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab1LOBE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 20:04:29 -0500
Received: from mail-pz0-f56.google.com ([209.85.210.56]:64624 "EHLO
	mail-pz0-f56.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758428Ab1LOBE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 20:04:27 -0500
X-Greylist: delayed 697 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Dec 2011 20:04:27 EST
MIME-Version: 1.0
Authentication-Results: ls.google.com; spf=pass (google.com: domain of
 csnook@google.com designates internal as permitted sender)
 smtp.mail=csnook@google.com; dkim=pass
 header.i=@google.com
Date: Wed, 14 Dec 2011 16:52:50 -0800 (PST)
In-Reply-To: <CAEas1LKNMSxhp-7DpsOOCu0fx6kx5ya-zqsZQgnf6JwzX0E0gw@mail.gmail.com>
References: <CAEas1LKNMSxhp-7DpsOOCu0fx6kx5ya-zqsZQgnf6JwzX0E0gw@mail.gmail.com>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-Header-Order: ASELCHRU
X-HTTP-UserAgent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.7 (KHTML,
 like Gecko) Chrome/16.0.912.63 Safari/535.7,gzip(gfe)
X-Google-IP: 127.6.6.6
Message-ID: <daec6a41-d318-4142-a3e1-14b8af64af66@b14g2000prn.googlegroups.com>
Subject: Re: question: why use vzalloc() and vzfree() in mem_cgroup_alloc()
 and mem_cgroup_free()
From: Chris Snook <csnook@google.com>
To: Kernel-team <kernel-team@google.com>
Cc: Laurent Chavey <chavey@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, glommer@parallels.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 14, 12:12 pm, Laurent Chavey <chavey@google.com> wrote:
> context:
>
> While testing patches from Glauber Costa, "adding support
> for tcp memory allocation in kmem cgroup", we hit a
> BUG_ON(in_interrupt()) in vfree(). The code path in question
> is taken because the izeof(struct mem_cgroup) is
>
> >= PAGE_SIZE in the call to mem_cgroup_free(),

Still, or again? A cursory search turns up this patch:

https://lkml.org/lkml/2010/9/27/147

but I don't have handy any further information about how it fared.

> Since socket may get free in an interrupt context,
> the combination of vzalloc(), vfree() should not be used
> when accounting for socket mem (unless the code is modified).

Agreed, but why does socket freeing cause struct mem_cgroup to be
freed? I think I'm missing something about the kmem cgroup
implementation.

> question:
>
> Is there reasons why vzalloc() is used in mem_cgroup_alloc() ?
>     . are we seeing mem fragmentations to level that fail
>       kzalloc() or kmalloc().
>     . do we have empirical data that shows the allocation failure
>       rate for kmalloc(), kzalloc() per alloc size (num pages)

Laziness? Last I checked, OpenAFS still called vmalloc() in the
pageout path, which is a no-no of similar magnitude, because handling
the failure properly is difficult to code and even more difficult to
test, and nobody is seeing machines deadlock often enough to justify
the development effort.

If we're having significant failures in allocating two consecutive
pages, we'll probably have other problems too, but there are
conditions where being able to vzalloc that could save you. I suspect
they're less common than conditions where vzalloc in interrupt context
would burn you, but I have no empirical data to support that.

-- Chris
