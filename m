Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2HMMSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:18:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49910 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2HMMSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:18:32 -0400
Date: Mon, 13 Aug 2012 13:18:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: John Fastabend <john.r.fastabend@intel.com>
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [flame^Wreview] net: netprio_cgroup: rework update socket logic
Message-ID: <20120813121827.GB23464@ZenIV.linux.org.uk>
References: <20120813015348.GZ23464@ZenIV.linux.org.uk>
 <502896C5.7080303@intel.com>
 <50289D7F.3070402@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50289D7F.3070402@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 11:23:59PM -0700, John Fastabend wrote:
> >OK clearly I screwed it up thanks for reviewing Al. How about this.
> >
> >                 fdt = files_fdtable(files);
> >                 for (fd = 0; fd < fdt->max_fds; fd++) {
> >                         struct socket *sock;
> >                         int err = 0;
> >
> >                         sock = sockfd_lookup(fd, &err);
> >                         if (!sock) {
> typo                           ^^^^^^
> 			   if (sock) {
> 
> to be honest I can't see why I didn't use sockfd_lookup in the first
> place...

Look at sockfd_lookup() arguments and ask yourself - "how could it possibly
guess which descriptor table I want it to look into?"  If you want to
kinda-sorta deal with the close() races here, the original loop would
be salvagable by replacing rcu_read_lock() with spin_lock(&files->file_lock);

HOWEVER, it still doesn't address more fundamental problem - somebody
creating a socket and passing it to you in SCM_RIGHTS datagram will
leave you with a socket you can do IO on, still tagged according to who
had created it.

AFAICS, the whole point of that exercise was to allow third-party changing
the priorities of traffic on sockets already created by a process we now
move to a different cgroup.  Consider e.g. this:
	process A spawns a dozen of children.  All children are reading
from the same AF_UNIX socket.  Parent listens for requests of some kind
(e.g. it's an httpd, etc.).  Once request arrives, it hands it off to
a child, by stuffing some information *and* established connection to
client into SCM_RIGHTS datagram, sends it to shared AF_UNIX socket, closes
the descriptor it got from accept(2) (one it has passed to worker in
SCM_RIGHTS) and moves on.  The next child to become free will recvmsg()
on that socket.  That will get the thing passed by parent installed into
its descriptor table; resulting descriptor will be found in ancillary
data (see unix(7) and cmsg(3)) and the child goes on to handle request,
using that descriptor to talk to client.
	I'm not saying that it's a particulary smart way to implement
worker pools, but it's legitimate and your whole point was to avoid
the need to modify userland code, wasn't it?  Now think what'll happen
to that model if you take the whole busily working bunch and move it
to a different cgroup.  Nevermind the races, assume that everyone gets
moved very quickly.  Both the parent and all children got moved and
their descriptor tables had been walked through by your code.  All sockets
present got relabeled...  Which does nothing to opened sockets sitting
in the datagrams currently in AF_UNIX socket's queue.  They are already
not present in descriptor table of the parent.  And they are yet to be
picked by the children...
