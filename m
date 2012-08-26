Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab2HZCrE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 22:47:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60800 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab2HZCrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 22:47:02 -0400
Date: Sun, 26 Aug 2012 03:46:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 2/9] procfs: Convert /proc/pid/fdinfo/ handling routines
 to seq-file v2
Message-ID: <20120826024653.GY23464@ZenIV.linux.org.uk>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.686586462@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823104725.686586462@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 02:43:25PM +0400, Cyrill Gorcunov wrote:
> This patch converts /proc/pid/fdinfo/ handling routines to seq-file which
> is needed to extend seq operations and plug in auxiliary fdinfo provides
> from subsystems like eventfd/eventpoll/fsnotify.
> 
> Note the proc_fd_link no longer call for proc_fd_info, simply because
> proc_fd_info is converted to seq_fdinfo_open (which is seq-file open()
> prototype).

Actually, now that I've looked at it a bit more...  You've just introduced
an ABI change here.  Look:

echo foo > /tmp/a
exec 8</tmp/a			# fd 8 reads from /tmp/a
read i <&8			# read line from it
exec 9</proc/self/fdinfo/8	# fd 9 is /proc/self/fdinfo/8
exec 8</tmp/a			# close fd 8 and reopen it to the same /tmp/a
cat <&9				# now read from fd 9

With the mainline it will print
pos:  0
flags:  0100000

With that commit you will get
pos:    4
flags:  0100000

since the file you've opened refers to what used to be at fd 8 at the
moment of open(2), not read(2).  It may or may not be harmless, but it
definitely is a userland ABI change.  And that way it's actually an
extra PITA for yourself - think what /proc/self/fdinfo/9 should contain
now!  That's right, you've got hidden state there and would need to
print it to be able to reconstruct the state on restart.  Only it doesn't
end just there - what if you've taken that one step further and got the
struct file stashed in there at open(2) time also of the same kind?

IMO doing that at open() time is just a headache for no good reason -
resolving descriptor to struct file * at read() time as we do now
is much saner.  Better do that in your ->show(), since you are using
a single-shot iterator anyway...
