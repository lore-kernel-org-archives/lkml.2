Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab1L0VZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 16:25:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab1L0VZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 16:25:07 -0500
Date: Tue, 27 Dec 2011 13:25:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111227132501.ad7f895f.akpm@linux-foundation.org>
In-Reply-To: <20111223145856.GB16818@redhat.com>
References: <20111222224117.GL17084@google.com>
	<20111222145426.5844df96.akpm@linux-foundation.org>
	<20111222230047.GN17084@google.com>
	<20111222151649.de57746f.akpm@linux-foundation.org>
	<20111222232433.GQ17084@google.com>
	<20111222154138.d6c583e3.akpm@linux-foundation.org>
	<20111223012112.GB12738@redhat.com>
	<20111222173820.3461be5d.akpm@linux-foundation.org>
	<20111223025411.GD12738@redhat.com>
	<20111222191144.78aec23a.akpm@linux-foundation.org>
	<20111223145856.GB16818@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Dec 2011 09:58:56 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> > Why do the allocation during I/O?  Can't it be done in the hotplug handler?
> > 
> 
> Even if we can do it in hotplug handler it will be very wasteful of
> memory. So if there are 100 IO cgroups in the system, upon every block
> device hotplug, we will allocate per cpu memory for all the 100 cgroups,
> irrespective of the fact whether they are doing IO to the device or not.
> 
> Now expand this to a system with 100 cgroups and 100 Luns. 10000
> allocations for no reason. (Even if we do it for cgroups needing stats,
> does not help much). Current scheme allocates memory for the group
> only if a sepcific cgroup is doing IO to a specific block device. 

umm, we've already declared that it is OK to completely waste this
memory for the users (probably a majority) who will not be using
these stats.

Also, has this stuff been tested at that scale?  I fear to think what
10000 allocations will do to fragmetnation of the vmalloc() arena.

