Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2LIQ1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 11:27:50 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:37592 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034Ab2LIQ1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 11:27:49 -0500
Date: Sun, 9 Dec 2012 11:27:46 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Tristan Wibberley <tristan.wibberley@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New system call wanted: fdreopen
Message-ID: <20121209162746.GA23890@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Tristan Wibberley <tristan.wibberley@gmail.com>,
	linux-kernel@vger.kernel.org
References: <ka2982$ra3$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ka2982$ra3$1@ger.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2012 at 03:03:30PM +0000, Tristan Wibberley wrote:
> 
> - /proc/self/fd/* does not solve this problem because the file might no
>   longer be available at the same place in the filesystem. In some
>   otherwise simple message passing or ReSTful IPC a different file will
>   be available at that path.

Actually, /proc/self/fd/* _will_ work.  When you do a ls -l, it looks
like a symlink, but the files in /proc/self/fd (and /proc/<pid>/fd
more generally) are magic.  If you open files in /proc/<pid>/fd/*, it
will do what you want.

See for yourself:

% cat > /tmp/foo.test
foo
bar
^Z
% jobs -l			# (and note the pid, hereafter <pid>)
% ls -l /proc/<pid>/fd 
% mv /tmp/foo.test /tmp/foo2.test
% ls -l /proc/<pid>/fd	# note that the symlink now points at /tmp/foo2.test
% cat /proc/<pid>/fd/1	# note that it works!
% rm /tmp/foo2.test
% ls -l /proc/<pid>/fd	# note that the symlink now has "(deleted)" at the end
% cat /proc/<pid>/fd/1	# note that it works!

This is of course horribly Linux-specific, but so would be a new
system call like your proposed fdrepon.  Better yet, using
/proc/self/fd/* will work *now*.  You don't have to wait for a new
system call in a future verison of the kernel to start shipping in new
distributions.

Regards,

					- Ted
