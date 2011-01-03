Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1ACJbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 04:31:20 -0500
Received: from canuck.infradead.org ([134.117.69.58]:46100 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab1ACJbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 04:31:20 -0500
Subject: Re: [PATCH] workqueue: relax lockdep annotation on flush_work()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101229125711.GL488@htj.dyndns.org>
References: <20101229125711.GL488@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 10:31:31 +0100
Message-ID: <1294047091.2016.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-29 at 13:57 +0100, Tejun Heo wrote:
> Currently, the lockdep annotation in flush_work() requires exclusive
> access on the workqueue the target work is queued on and triggers
> warning if a work is trying to flush another work on the same
> workqueue; however, this is no longer true as workqueues can now
> execute multiple works concurrently.
> 
> This patch adds lock_map_acquire_read() and make process_one_work()
> hold read access to the workqueue while executing a work and
> start_flush_work() check for write access if concurrnecy level is one
> and read access if higher.
> 
> This better represents what's going on and removes spurious lockdep
> warnings which are triggered by fake dependency chain created through
> flush_work().

Is this still true in the low memory situation where we're running the
emergency thread? I can imagine the emergency thread trying to flush
itself isn't really a good thing.
