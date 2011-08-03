Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1HCX2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:28:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab1HCX2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:47 2011
Message-Id: <20110803221247.021608637@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [030/102] firewire: cdev: return -ENOTTY for unimplemented ioctls, not -EINVAL
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit d873d794235efa590ab3c94d5ee22bb1fab19ac4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/core-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


