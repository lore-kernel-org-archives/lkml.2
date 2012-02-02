Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab2BBKfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:35:03 -0500
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2139 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab2BBKfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:35:01 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Feb 2012 05:35:01 EST
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Enke Chen <enkechen@cisco.com>
Subject: [RFCv7 PATCH 0/4] Add poll_requested_events() function.
Date: Thu,  2 Feb 2012 11:26:53 +0100
Message-Id: <1328178417-3876-1-git-send-email-hverkuil@xs4all.nl>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is the seventh version of this patch series (the fifth and sixth where
never posted and where internal iterations only).

Al Viro had concerns about silent API changes. I have made an extensive
analysis of that in my comments in patch 2/4.

This patch series is rebased to v3.3-rc2. The changes compared to the
previously posted version are:

- I have renamed the qproc field to pq_proc to prevent any driver that tries
  to access that directly to fail. No kernel driver does this, BTW.

- I added a new poll_does_not_wait() inline that returns true if it is known
  that poll() will not wait on return. This removes the last reason for
  looking inside the poll_table struct. include/net/sock.h has been adapted
  to use this new inline (and it is the only place inside the kernel that
  need this).

I hope that the analysis I made answers any remaining concerns about possible
silent API changes.

This patch series is also available here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/pollv7

It was suggested to me that creating a new poll system call might be an option
as well. I've attempted that as well and code implementing that can be found
here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/pollwithkey

However, I think this turned out to be very messy. And because some drivers
call the poll fop directly or through some framework I could not be certain I
was not introducing any errors.

If it is really required to change the API in some way, then I would suggest
changing this:

typedef struct poll_table_struct {
        poll_queue_proc pq_proc;
        unsigned long key;
} poll_table;

to this:

struct poll_table {
        poll_queue_proc pq_proc;
        unsigned long key;
};

and adapting all users.

However, I honestly do not think this is necessary at all. But if it is the
only way to get this in, then I'll do the work. The media/video subsystem really
needs this functionality. Also note that previous versions of this patch have
been in linux-next for months now.

The first version of this patch was posted July 1st, 2011. I really hope that
it won't take another six months to get a review from a fs developer. As this
LWN article (http://lwn.net/Articles/450658/) said: 'There has been little
discussion of the patch; it doesn't seem like there is any real reason for it
not to go in for 3.1.'

The earliest this can go in now is 3.4. The only reason it takes so long is
that it has been almost impossible to get a Ack or comments or even just a
simple reply from the fs developers. That is really frustrating, I'm sorry
to say.

Anyway, comments, reviews, etc. are very welcome.

Regards,

	Hans

