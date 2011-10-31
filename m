Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1JaXxn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:53:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58629 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab1JaXxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:53:41 -0400
Date: Mon, 31 Oct 2011 16:53:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@samba.org>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, linux-pm@vger.kernel.org,
        linux-cifs@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Neil Brown <neilb@suse.de>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Message-ID: <20111031235335.GL18855@google.com>
References: <20111031221743.GA18855@google.com>
 <201111010024.16659.rjw@sisk.pl>
 <CAH2r5msMiG8MjhYuVv8ehqkBLKc1Av3hi+2q6zwrrXdTTa_+YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5msMiG8MjhYuVv8ehqkBLKc1Av3hi+2q6zwrrXdTTa_+YQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 31, 2011 at 06:45:48PM -0500, Steve French wrote:
> >> Signed-off-by: Tejun Heo <tj@kernel.org>
> >> Cc: Jeff Layton <jlayton@redhat.com>
> >> ---
> >> Neil, Steve, do the network filesystems need a way to indicate "I can
> >> either be killed or enter freezer"?
> 
> Probably, yes, but I will defer to Jeff as he has looked
> more recently at these issues.
> 
> I can explain cifs state, and disconnect/reconnection of sessions
> (and smb2 is a little more feature rich in this regard), but will
> let Jeff explain the more subtle points you are getting at.

Hmmm... I'm getting confused.

For nfs, this really is a non-issue.  Either the user wants nointr or
intr behavior.  NFS nointr is rather crazy - it's basically "nothing
can do anything to tasks which is doing NFS IO until it's complete"
and really meant to be used for servers sharing filesystems for /usr,
/home and stuff.  It doesn't make whole lot of sense on systems which
may go suspend and that's why there's intr option.

I suppose the problem is that cifs doesn't know how to do 'intr' yet,
right?  If that really is the problem, the correct long term solution
would be implementing proper intr behavior and it doesn't make any
sense to push this type of change to PM core to for short term
workaround.  Just use prepare_to_wait() / schedule() / finish_wait()
directly w/ INTERRUPTIBLE sleep and don't break out of wait loop on
signal_pending().  If this should be used in multiple places, write up
a wait_event_XXX() wrapper.  There is absolutely no reason to change
wakeup condition.

Thank you.

-- 
tejun
