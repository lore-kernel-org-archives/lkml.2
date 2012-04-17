Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2DQWRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 18:17:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab2DQWRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 18:17:31 -0400
Date: Tue, 17 Apr 2012 15:17:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [Patch 2/8] ipc/mqueue: switch back to using non-max values on
 create
Message-Id: <20120417151729.e255188c.akpm@linux-foundation.org>
In-Reply-To: <a9cfc656e665735e11606d452a536a9a9e6ebdde.1334676645.git.dledford@redhat.com>
References: <cover.1334676645.git.dledford@redhat.com>
	<a9cfc656e665735e11606d452a536a9a9e6ebdde.1334676645.git.dledford@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Apr 2012 11:46:19 -0400
Doug Ledford <dledford@redhat.com> wrote:

> Commit b231cca4381ee15ec99afbfb244fbc0324869927 changed
> how we create a queue that does not include an attr
> struct passed to open so that it creates the queue
> with whatever the maximum values are.  However, if the
> admin has set the maximums to allow flexibility in
> creating a queue (aka, both a large size and large queue
> are allowed, but combined they create a queue too large
> for the RLIMIT_MSGQUEUE of the user), then attempts to
> create a queue without an attr struct will fail.  Switch
> back to using acceptable defaults regardless of what
> the maximums are.
> 
> Note: so far, we only know of a few applications that rely
> on this behavior (specifically, set the maximums in /proc,
> then run the application which calls mq_open() without
> passing in an attr struct, and the application expects the
> newly created message queue to have the maximum sizes that
> were set in /proc used on the mq_open() call, and all of
> those applications that we know of are actually part of
> regression test suites that were coded to do something
> like this:
> 
> for size in 4096 65536 $((1024 * 1024)) $((16 * 1024 * 1024)); do
> 	echo $size > /proc/sys/fs/mqueue/msgsize_max
> 	mq_open || echo "Error opening mq with size $size"
> done
> 
> These test suites that depend on any behavior like this are
> broken.  The concept that programs should rely upon the
> system wide maximum in order to get their desired results
> instead of simply using a attr struct to specify what they
> want is fundamentally unfriendly programming practice for
> any multi-tasking OS.
> 
> Fixing this will break those few apps that we know of (and
> those app authors recognize the brokenness of their code
> and the need to fix it).  However, a future patch will allow
> a workaround in the form of new knobs for the default
> msg queue creation parameters for any software out there that
> we don't already know about that might rely on this behavior
> at the moment.

Here the "future patch" is "mqueue: separate mqueue default value from
maximum value v2" in this series, yes?

So people who have applications which are broken by this patch will
need to manually set /proc/sys/fs/mqueue/msg_default and/or
/proc/sys/fs/mqueue/msgsize_default to get those apps working again?

