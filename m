Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab1G1Xwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:52:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:27791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756178Ab1G1Xo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552493"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: stefanr@s5r6.in-berlin.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [22/50] firewire: cdev: return -ENOTTY for unimplemented ioctls, not
Message-Id: <20110728234426.AE7192403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

[ upstream commit d873d794235efa590ab3c94d5ee22bb1fab19ac4 ]
 -EINVAL

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/firewire/core-cdev.c
===================================================================
--- linux-2.6.35.y.orig/drivers/firewire/core-cdev.c
+++ linux-2.6.35.y/drivers/firewire/core-cdev.c
@@ -1361,7 +1361,7 @@ static int dispatch_ioctl(struct client 
 	if (_IOC_TYPE(cmd) != '#' ||
 	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers) ||
 	    _IOC_SIZE(cmd) > sizeof(buffer))
-		return -EINVAL;
+		return -ENOTTY;
 
 	if (_IOC_DIR(cmd) == _IOC_READ)
 		memset(&buffer, 0, _IOC_SIZE(cmd));
