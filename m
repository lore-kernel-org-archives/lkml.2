Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2LXSp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 13:45:29 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50810 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2LXSp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 13:45:26 -0500
Date: Mon, 24 Dec 2012 10:45:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Message-ID: <20121224184520.GC11817@htj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-26-git-send-email-tj@kernel.org>
 <20121221181523.0e0998e4.akpm@linux-foundation.org>
 <20121222022210.GA30177@htj.dyndns.org>
 <20121222110929.GA3567@liondog.tnic>
 <20121224183334.GB11817@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121224183334.GB11817@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Mon, Dec 24, 2012 at 10:33:34AM -0800, Tejun Heo wrote:
> I don't think we have cases where this actually matters but it could
> be that we can add work_pending() tests to queue_work_on().  I *think*
> that shouldn't break work scheduling semantics.  Not completely sure
> tho.  Need to think about it more.

I was confused a bit there.  We can't.  Nothing guarantees that the
queuer sees the cleared PENDING before the work item starts execution,
and I think ipc memory hotplug could also be broken from that.  It's
highly unlikely to actually happen and there may be external locking
which prevents the race from actually happening, but there's nothing
synchronizing queueing and the execution of the work item.  Looking at
that part of code only, it's possible that it fails to queue the work
item after a memory hotplug event even though the previous queueing
already started execution and processed a couple notifiers.

And you can see why you don't want this type of tricky micro
optimizations unless it's absolutely necessary and carefully
considered.  Cold paths get much less attention and testing.  Adding
micro optimizations to them is just a bad idea.

Thanks.

-- 
tejun
