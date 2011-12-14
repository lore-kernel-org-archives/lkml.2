Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1LNGxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 01:53:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60181 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1LNGw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 01:52:59 -0500
Date: Wed, 14 Dec 2011 06:52:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: David Miller <davem@davemloft.net>, Nick Piggin <npiggin@kernel.dk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/ncpfs: fix error paths and goto statements in
 ncp_fill_super()
Message-ID: <20111214065245.GL2203@ZenIV.linux.org.uk>
References: <20111213014729.GA7693@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213014729.GA7693@dztty>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[davem Cc'd, since there's an ugly socket-related problem in that area]

On Tue, Dec 13, 2011 at 02:47:29AM +0100, Djalal Harouni wrote:
> The label 'out_bdi' should be followed by bdi_destroy() instead of
> fput() which should be after the 'out_fput' label.
> 
> If bdi_setup_and_register() fails then jump to the 'out_fput' label
> instead of the 'out_bdi' one.
> 
> If fget(data.info_fd) fails then jump to the previously fixed 'out_bdi'
> label to call bdi_destroy() otherwise the bdi object will not be
> destroyed.
> 
> Compile tested only.

Applied, but now that I've looked at that code...  It, along with several
other places, overwrites a bunch of fields in sock->sk.  What happens if
some joker feeds that descriptor to, say, svc_addsock()?  It does the
same kind of thing, and both assume that no bonehead programmer would
ever do something that dumb.  Moreover, what if somebody feeds the same fd
to ncpfs mount or svc_addsock twice?

I'd done a quick grep and AFAICS, most of the places doing that kind of thing
is acting on internally created socket, so no such problem for them.  Or
they take care to check that somebody has already done that to socket in
question.  Potentially unpleasant ones:
	drivers/scsi/iscsi_tcp.c:iscsi_sw_tcp_conn_bind()
	fs/dlm/lowcomms.c:process_sctp_notification()
	fs/ncpfs/inode.c:ncp_fill_super()
	net/sunrpc/svcsock.c:svc_addsock()

I'm not familiar with that area at all; not even enough to tell if locking
is wrong in svc_addsock() - I suspect that it is, but...

Dave, am I right assuming that all those places ought to check if somebody
is already parasiting on the socket in question and fail with -EBUSY or
something like that?
