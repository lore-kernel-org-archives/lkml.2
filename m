Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab1EZNcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:32:05 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:40862 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab1EZNcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:32:04 -0400
Date: Thu, 26 May 2011 09:31:55 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "D. Jansen" <d.g.jansen@googlemail.com>
Cc: Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
Message-ID: <20110526133155.GH9520@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"D. Jansen" <d.g.jansen@googlemail.com>,
	Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de>
 <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de>
 <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
 <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu>
 <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 01:16:45PM +0200, D. Jansen wrote:
> 
> exactly. so what now?

This needs to be solved at the application level.  So what we need is
a coordinating daemon which sends a message to all applications
saying, "ok, here's an opportunity to flush data to the disk; if you
have dirty files, or databases that has data that needs to be flushed,
send it now", and then a little while later, it sends a message to all
applications, "ok, we're going to let the disk spin down now, hold
your horses and don't send any data to the disk".

If an application has too much data buffered in memory, and either
because (a) it's getting nervous that it doesn't want to lose a huge
amount of critical user data, or (b) it's about to exit, so it really
needs to save its state to disk, or (c) the buffered data is taking up
too much space, so it needs to flush its in-memory buffers, then the
application sends a message to the coordinating daemon, saying,
"please give me permission to write", and then waits for the "ok, you
can write to the disk" message.

That way, if you have multiple database-using applications active on
the system at the same time, they can coordinate their access to the
disk, and in a way such that when they stop writing, the data left in
the application-level database is in a coherent state.

The kernel can't do this by arbitrarily stopping writes from going to
the disk because the kernel doesn't know --- and can't possibly know
--- when it is a safe time to cut off write access to the disk.  It
can try and guess, by stopping write access after an fsync(), but it
has to honor the fsync().  Consider what happens when an SMTP server
sends back a 200 OK message --- that gives permission for its opposite
number at the other end of the connection to delete the e-mail
message, since the local SMTP server has promised that the e-mail has
been saved to stable storage.  It can't make that promise if fsync()
has been rigged to lie.  

That's why at the end of the day, in order for application level data
coherency, the application has to be in control.  If you want to save
power by coordinating access to the disk, that coordination has to
happen at the application level.

						- Ted
