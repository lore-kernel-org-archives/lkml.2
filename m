Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813Ab2J2Rg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:36:26 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:61275 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab2J2RgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:36:22 -0400
Message-ID: <508ECC63.3020302@mvista.com>
Date: Mon, 29 Oct 2012 21:35:15 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Julius Werner <jwerner@chromium.org>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH] xhci: fix null-pointer dereference when destroying half-built
 segment rings
References: <1351530030-7080-1-git-send-email-jwerner@chromium.org>
In-Reply-To: <1351530030-7080-1-git-send-email-jwerner@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/29/2012 08:00 PM, Julius Werner wrote:

> xhci_alloc_segments_for_ring() builds a list of xhci_segments and links
> the tail to head at the end (forming a ring). When it bails out for OOM
> reasons half-way through, it tries to destroy its half-built list with
> xhci_free_segments_for_ring(), even though it is not a ring yet. This
> causes a null-pointer dereference upon hitting the last element.

> Furthermore, one of its callers (xhci_ring_alloc()) mistakenly believes
> the output parameters to be valid upon this kind of OOM failure, and
> calls xhci_ring_free() on them. Since the (incomplete) list/ring should
> already be destroyed in that case, this would lead to a use after free.

> This patch fixes those issues by having xhci_alloc_segments_for_ring()
> destroy its half-built, non-circular list manually and destroying the
> invalid struct xhci_ring in xhci_ring_alloc() with a plain kfree().

> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/host/xhci-mem.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)

> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
> index 487bc08..420ba37 100644
> --- a/drivers/usb/host/xhci-mem.c
> +++ b/drivers/usb/host/xhci-mem.c
> @@ -205,7 +205,11 @@ static int xhci_alloc_segments_for_ring(struct xhci_hcd *xhci,
>  
>  		next = xhci_segment_alloc(xhci, cycle_state, flags);
>  		if (!next) {
> -			xhci_free_segments_for_ring(xhci, *first);
> +			prev = *first;
> +			do {
> +				next = prev->next;
> +				xhci_segment_free(xhci, prev);
> +			} while ((prev = next));

   It's preferred that the assignments are done outside the *if* and *while*
statements. In fact, at least for the *if* statements scripts/checkpatch.pl
gives a warning (it was silent in this case).

>  			return -ENOMEM;
>  		}
>  		xhci_link_segments(xhci, prev, next, type);
> @@ -258,7 +262,7 @@ static struct xhci_ring *xhci_ring_alloc(struct xhci_hcd *xhci,
>  	return ring;
>  
>  fail:
> -	xhci_ring_free(xhci, ring);
> +	kfree(ring);
>  	return NULL;
>  }

[headless@wasted linux]$ scripts/checkpatch.pl
patches/xhci-fix-null-pointer-dereference-when-destroying-half-built-segment-rings.patch

ERROR: DOS line endings
#30: FILE: drivers/usb/host/xhci-mem.c:208:
+^I^I^Iprev = *first;^M$

ERROR: DOS line endings
#31: FILE: drivers/usb/host/xhci-mem.c:209:
+^I^I^Ido {^M$

ERROR: DOS line endings
#32: FILE: drivers/usb/host/xhci-mem.c:210:
+^I^I^I^Inext = prev->next;^M$

ERROR: DOS line endings
#33: FILE: drivers/usb/host/xhci-mem.c:211:
+^I^I^I^Ixhci_segment_free(xhci, prev);^M$

ERROR: DOS line endings
#34: FILE: drivers/usb/host/xhci-mem.c:212:
+^I^I^I} while ((prev = next));^M$

ERROR: DOS line endings
#43: FILE: drivers/usb/host/xhci-mem.c:265:
+^Ikfree(ring);^M$

total: 6 errors, 0 warnings, 20 lines checked

patches/xhci-fix-null-pointer-dereference-when-destroying-half-built-segment-rings.patch
has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

   I have noticed that the patch description has DOS line endings as well.

WBR, Sergei

