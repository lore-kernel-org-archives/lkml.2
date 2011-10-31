Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934823Ab1JaXRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:17:37 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50890 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934704Ab1JaXRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:17:35 -0400
Date: Mon, 31 Oct 2011 16:17:30 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Message-ID: <20111031231730.GH18855@google.com>
References: <20111031221743.GA18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031221743.GA18855@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 03:17:43PM -0700, Tejun Heo wrote:
> Commit 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
> TASK_KILLABLE tasks too" made freezer wake up tasks in TASK_KILLABLE
> sleep too citing non-interruptible but killable sleeps in cifs and
> nfs.
> 
> I don't think we can do this.  We should not send spurious unsolicited
> non-interruptible wakeups.  Most synchornization constructs are built
> to cope with spurious wakeups and any INTERRUPTIBLE sleep must be able
> to handle spurious wakeups but that's not true for KILLABLE sleeps -
> KILLABLE condition cannot be cancelled.
> 
> This is probably okay for most cases but circumventing fundamental
> wakeup condition like this is asking for trouble.  Furthermore, I'm
> not sure the behavior change brought on by this change - breaking
> nfs/cifs uninterruptible operation guarantee - is correct.  If such
> behavior is desirable, the right thing to do is using intr mount
> option, not circumventing it from PM layer.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jeff Layton <jlayton@redhat.com>
> ---
> Neil, Steve, do the network filesystems need a way to indicate "I can
> either be killed or enter freezer"?

Hmm... okay, so commit f06ac72e929 "cifs, freezer: add
wait_event_freezekillable and have cifs use it" added freezable &
killable sleep.  If this is necessary, the right thing to do is adding
another waking state, not modifying existing one's behavior.

But, before going there, is this *really* necessary?  Do we really
have to choose among different combinations of interruptible, killable
and freezable?  If something doesn't want to be bothered than being
killed, assuming it doesn't want to go hibernating is kinda natural.

IOW, can we please update cifs, if it wants to allow hibernation, to
use interruptible sleep in wait_for_response() than trying to modify
basic sleep mechanism?

Thank you.

-- 
tejun
