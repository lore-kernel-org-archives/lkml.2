Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963Ab0CPRUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:20:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759953Ab0CPRUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:20:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B9FABB7.6030906@kernel.org>
References: <4B9FABB7.6030906@kernel.org> <4B9AC657.1090607@kernel.org> <4B99CB0F.1090505@kernel.org> <1267187000-18791-1-git-send-email-tj@kernel.org> <29029.1268232771@redhat.com> <3491.1268393035@redhat.com> <11791.1268750298@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#4
Date: Tue, 16 Mar 2010 17:18:31 +0000
Message-ID: <18911.1268759911@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> Sure, there could be a bug in the non-reentrance implementation but
> I'm leaning more towards a bug in work flushing before freeing thing
> which also seems to show up in the debugfs path.  I'll try to
> reproduce the problem here and debug it.

I haven't managed to reproduce it since I reported it:-/

> That said, the numbers look generally favorable to CMWQ although the
> sample size is too small to draw conclusions.  I'll try to get things
> fixed up so that testing can be smoother.

You have to take the numbers with a large pinch of salt, I think, in both
cases.  Pulling over the otherwise unladen GigE network from the server with
the data in RAM is somewhat faster than sucking from disk.  Furthermore, since
the test is massively parallel, with each thread reading separate data, the
result is going to be very much dependent on what order the reads happen to be
issued this time compared to the order they were issued when the cache was
filled.

I need to fix my slow-test server that's dangling at the end of an ethernet
over mains connection.  That gives much more consistent results as the disk
speed is greater than the network connection speed.


Looking at the numbers, I think CMWQ may appear to give better results in the
cold-cache case by starting off confining many accesses to the cache to a
single CPU, given that cache object creation and data storage is done
asynchronously in the background.  This is due to object creation getting
deferred until index creation is achieved (several loopups, mkdirs and
setxattrs), and then all dumped at once onto the CPU that handled the index
creation, as we discussed elsewhere.

The program I'm using to read the data doesn't give any real penalty when its
threads can't actually run in parallel, so it probably doesn't mind being
largely confined to the other CPU.  But that's benchmarking for you...

You should probably also disregard the coldish-server numbers.  I'm not sure
my desktop machine (which was acting as the server) was purged of the dataset.
I'd need to reboot the server to be sure, but that's inconvenient of my
desktop.

But, at a glance, the numbers don't appear to be too different.  There are
cases where CMWQ definitely appears better, and some where it definitely
appears worse, but the spread is so huge, that could just be noise.

David
