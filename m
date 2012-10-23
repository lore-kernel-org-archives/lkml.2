Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934121Ab2JWW7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:59:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab2JWW7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:59:22 -0400
Date: Tue, 23 Oct 2012 15:59:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/10] thp: implement refcounting for huge zero page
Message-Id: <20121023155915.7d5ef9d1.akpm@linux-foundation.org>
In-Reply-To: <20121023070018.GA18381@otc-wbsnb-06>
References: <1350280859-18801-1-git-send-email-kirill.shutemov@linux.intel.com>
	<1350280859-18801-11-git-send-email-kirill.shutemov@linux.intel.com>
	<20121018164502.b32791e7.akpm@linux-foundation.org>
	<20121018235941.GA32397@shutemov.name>
	<20121023063532.GA15870@shutemov.name>
	<20121022234349.27f33f62.akpm@linux-foundation.org>
	<20121023070018.GA18381@otc-wbsnb-06>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012 10:00:18 +0300
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> > Well, how hard is it to trigger the bad behavior?  One can easily
> > create a situation in which that page's refcount frequently switches
> > from 0 to 1 and back again.  And one can easily create a situation in
> > which the shrinkers are being called frequently.  Run both at the same
> > time and what happens?
> 
> If the goal is to trigger bad behavior then:
> 
> 1. read from an area where a huge page can be mapped to get huge zero page
>    mapped. hzp is allocated here. refcounter == 2.
> 2. write to the same page. refcounter == 1.
> 3. echo 3 > /proc/sys/vm/drop_caches. refcounter == 0 -> free the hzp.
> 4. goto 1.
> 
> But it's unrealistic. /proc/sys/vm/drop_caches is only root-accessible.

Yes, drop_caches is uninteresting.

> We can trigger shrinker only under memory pressure. But in this, most
> likely we will get -ENOMEM on hzp allocation and will go to fallback path
> (4k zero page).

I disagree.  If, for example, there is a large amount of clean
pagecache being generated then the shrinkers will be called frequently
and memory reclaim will be running at a 100% success rate.  The
hugepage allocation will be successful in such a situation?

