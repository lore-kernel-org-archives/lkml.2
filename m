Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab3ABWog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:44:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59768 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab3ABWoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:44:34 -0500
Message-ID: <50E4B849.108@linux.vnet.ibm.com>
Date: Wed, 02 Jan 2013 16:44:25 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 7/8] zswap: add to mm/
References: <<1355262966-15281-1-git-send-email-sjenning@linux.vnet.ibm.com>> <<1355262966-15281-8-git-send-email-sjenning@linux.vnet.ibm.com>> <0e91c1e5-7a62-4b89-9473-09fff384a334@default> <50E32255.60901@linux.vnet.ibm.com> <50E4588E.6080001@linux.vnet.ibm.com>
In-Reply-To: <50E4588E.6080001@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010222-9360-0000-0000-00000EAD643A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 09:55 AM, Dave Hansen wrote:
> On 01/01/2013 09:52 AM, Seth Jennings wrote:
>> On 12/31/2012 05:06 PM, Dan Magenheimer wrote:
>> Also, I've done some lockstat checks and the zswap tree lock is way
>> down on the list contributing <1% of the lock contention wait time on
>> a 4-core system.  The anon_vma lock is the primary bottleneck.
>
> It's curious that you chose the anon_vma lock, though.  It can only
> possibly show _contention_ when you've got a bunch of CPUs beating on
> the related VMAs.  That contention disappears in workloads that aren't
> threaded, so it seems at least a bit imprecise to say anon_vma lock is
> the primary bottleneck.

Sorry, should have qualified.  According to lockstat, the locks with
the most contention during a -j16 kernel build on a memory restricted
4-core machine were:

1  sb_lock:				252400
2  swap_lock:				191499
3  &(&mm->page_table_lock)->rlock:	69725
4  &anon_vma->mutex:			51369
5  swapper_space.tree_lock:		42261
6  &(&zone->lru_lock)->rlock:		38909
7  &rq->lock:				19586
8  rcu_node_0:				18467
9  &(&tree->lock)->rlock:		12776 <-- zswap tree lock
10 &rsp->gp_wq:				11909

The zswap tree lock accounts for <2% of contentions within the top 10
contended locks.

During the same build, the locks with the most wait time were:

1  &type->i_mutex_dir_key#4:		137134027.28
2  &anon_vma->mutex:			43569273.66
3  &mapping->i_mmap_mutex:		12041326.01
4  &sb->s_type->i_mutex_key#3/1:	3574244.56
5  &(&mm->page_table_lock)->rlock:	701280.1
6  sysfs_mutex:				628204.76
7  &sb->s_type->i_mutex_key#3:		598007.84
8  swap_lock:				333334.8
9  &rsp->gp_wq:				177479.84
10 &tty->atomic_write_lock:		142573.89
...
18 &(&tree->lock)->rlock:		13451.57

The zswap tree lock wait numbers are noise here.

During a single-threaded test with memknobs, a single threaded
application that simply allocates/touches a large anonymous memory
section and then randomly reads from it, there were no contentions.

I also did a tmpfs test, where I copied the kernel source tree into a
tmpfs mount that overflowed into swap by around 300MB.  Zswap captured
all the pages that compressed well enough according to policy and
there were no contentions on the zswap tree lock.

So I'm not seeing any cases where the zswap locking is causing a
measurable issue.  In the cases where there contention occurs, the
vast majority of the contention and wait time happens in other layers.

Seth

