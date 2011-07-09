Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1GIOmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 10:42:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39370 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab1GIOmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 10:42:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 9 Jul 2011 16:42:26 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: cdev: return -ENOTTY for unimplemented ioctls,
 not -EINVAL
Message-ID: <20110709164226.519a81fe@stein>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 27 Linus Torvalds wrote:
> The correct error code for "I don't understand this ioctl" is ENOTTY.
> The naming may be odd, but you should think of that error value as a
> "unrecognized ioctl number, you're feeding me random numbers that I
> don't understand and I assume for historical reasons that you tried to
> do some tty operation on me".
[...]
> The EINVAL thing goes way back, and is a disaster. It predates Linux
> itself, as far as I can tell. You'll find lots of man-pages that have
> this line in it:
> 
>   EINVAL Request or argp is not valid.
> 
> and it shows up in POSIX etc. And sadly, it generally shows up
> _before_ the line that says
> 
>   ENOTTY The specified request does not apply to the kind of object
> that the descriptor d references.
> 
> so a lot of people get to the EINVAL, and never even notice the ENOTTY.
[...]
> At least glibc (and hopefully other C libraries) use a _string_ that
> makes much more sense: strerror(ENOTTY) is "Inappropriate ioctl for
> device"

So let's correct this in the <linux/firewire-cdev.h> ABI while it is
still young, relative to distributor adoption.

Side note:  We return -ENOTTY not only on _IOC_TYPE or _IOC_NR mismatch,
but also on _IOC_SIZE mismatch.  An ioctl with an unsupported size of
argument structure can be seen as an unsupported version of that ioctl.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@kernel.org>
---
 drivers/firewire/core-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/firewire/core-cdev.c
===================================================================
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1583,7 +1583,7 @@ static int dispatch_ioctl(struct client
 	if (_IOC_TYPE(cmd) != '#' ||
 	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers) ||
 	    _IOC_SIZE(cmd) > sizeof(buffer))
-		return -EINVAL;
+		return -ENOTTY;
 
 	if (_IOC_DIR(cmd) == _IOC_READ)
 		memset(&buffer, 0, _IOC_SIZE(cmd));


-- 
Stefan Richter
-=====-==-== -=== -=--=
http://arcgraph.de/sr/
