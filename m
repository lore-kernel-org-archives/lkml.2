Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1IMOHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:07:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab1IMOHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:07:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4E6EBDA8.2040401@vlnb.net>
References: <4E6EBDA8.2040401@vlnb.net> <4E6C1016.8030703@vlnb.net> <20110911023840.GZ2203@ZenIV.linux.org.uk>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Lockdep and rw_semaphores
Date: Tue, 13 Sep 2011 15:07:03 +0100
Message-ID: <25976.1315922823@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al is correct.

The in-kernel R/W semaphore implementation is written to be strictly fair.  If
the semaphore is readlocked and a writer is pending, all further readers and
writers get added to the back of the FIFO queue, thus preventing writers from
being starved.

When it comes time to wake someone up, the waiter at the front of the queue is
woken. If that's a reader, then next on the queue may be woken up too if
that's also a reader - up to the point a writer is encountered.  Any readers
beyond that writer in the queue have to wait for the writer in front of them
to get its share first.

David
