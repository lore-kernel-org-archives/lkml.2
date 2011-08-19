Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab1HSWxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 18:53:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662Ab1HSWxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 18:53:01 -0400
Date: Fri, 19 Aug 2011 15:52:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH v2] avoid null pointer access in vm_struct
Message-Id: <20110819155238.b11d19fb.akpm@linux-foundation.org>
In-Reply-To: <20110819105133.7504.62129.stgit@ltc219.sdl.hitachi.co.jp>
References: <20110819105133.7504.62129.stgit@ltc219.sdl.hitachi.co.jp>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011 19:51:33 +0900
Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:

> The /proc/vmallocinfo shows information about vmalloc allocations in vmlist
> that is a linklist of vm_struct. It, however, may access pages field of
> vm_struct where a page was not allocated, which results in a null pointer
> access and leads to a kernel panic.
> 
> Why this happen:
> In __vmalloc_area_node(), the nr_pages field of vm_struct are set to the
> expected number of pages to be allocated, before the actual pages
> allocations. At the same time, when the /proc/vmallocinfo is read, it
> accesses the pages field of vm_struct according to the nr_pages field at
> show_numa_info(). Thus, a null pointer access happens.
> 
> Patch:
> This patch sets nr_pages field of vm_struct AFTER the pages allocations
> finished in __vmalloc_area_node(). So, it can avoid accessing the pages
> field with unallocated page when show_numa_info() is called.

I think this is still just a workaround to fix up the real bug, and
that the real bug is that the vm_struct is installed into the vmlist
*before* it is fully initialised.  It's just wrong to insert an object
into a globally-visible list and to then start populating it!  If we
were instead to fully initialise the vm_struct and *then* insert it
into vmlist, the bug is fixed.

Also I'd agree with Paul's concern regarding cross-CPU memory ordering.

