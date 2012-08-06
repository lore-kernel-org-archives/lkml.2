Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab2HFR7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:59:45 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4026 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab2HFR7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:59:44 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <502005FD.10102@broadcom.com>
Date: Mon, 6 Aug 2012 19:59:25 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-Version: 1.0
To: "Christopher Sacchi" <chris.sacchi@gmail.com>
cc: linux-wireless@vger.kernel.org,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: Mac80211 driver and I checked the patch
References: <CAGh4K3Lym9yETNbMutfjNuANrgwtvfrGes6emr3Mvhx47D3B2g@mail.gmail.com>
In-Reply-To: <CAGh4K3Lym9yETNbMutfjNuANrgwtvfrGes6emr3Mvhx47D3B2g@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
X-WSS-ID: 7C3EDA343NK12574419-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very generic subject line. I would expect something like:

[PATCH] mac80211: include rfkill header implicitly

On 08/06/2012 01:49 PM, Christopher Sacchi wrote:
> The source file needed a change  that was told in the description to
> know that the #include needed to be fixed, and the function changed
> another value to 0 (yes) in the description (that said FIXME.) The
> patch fixes a typo-like error and has been checked with checkpatch.pl
> in the scripts directory.


> Here's the patch:

Do need a heads-up stating the obvious.
> --
> --- main.c	2012-07-21 20:58:29.000000000 +0000
> +++ mainnew.c	2012-08-05 20:00:37.000000000 +0000

How did you create this patch? diff -U? When I try to apply your patch:

$ git am patches/mac80211-crappy-patch-test.eml
Applying: Mac80211 driver and I checked the patch
error: mainnew.c: does not exist in index
Patch failed at 0001 Mac80211 driver and I checked the patch
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

You really should do your changes in a git repository.

I changed it to:

--- a/net/mac80211/main.c	2012-07-21 20:58:29.000000000 +0000
+++ b/net/mac80211/main.c	2012-08-05 20:00:37.000000000 +0000

and applied it. That applied, but it does not build.

> @@ -32,7 +32,7 @@
>  #include "led.h"
>  #include "cfg.h"
>  #include "debugfs.h"
> -
> +#include "net/rfkill/rfkill.h"

add empty line between #include and function prototype.

>  static struct lock_class_key ieee80211_rx_skb_queue_class;
> 
>  void ieee80211_configure_filter(struct ieee80211_local *local)
> @@ -183,6 +183,7 @@ int ieee80211_hw_config(struct ieee80211
>  		 *
>  		 */
>  		/* WARN_ON(ret); */
> +		WARN_ON(1)

Still no ';' here.

>  	}
> 
>  	return ret;
> Signed-off-by: Christopher P. Sacchi <chris.sacchi@gmail.com>

Now this line will be added in the code. You really do not want that! (I
hope).

> --
> 

More general: What are you trying to change? I did take a look in
net/mac80211/main.c and found the FIXME you refer to:

int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
{
	:
	:
        if (changed && local->open_count) {
                ret = drv_config(local, changed);
                /*
                 * Goal:
                 * HW reconfiguration should never fail, the driver has told
                 * us what it can support so it should live up to that
promise.
                 *
                 * Current status:
                 * rfkill is not integrated with mac80211 and a
                 * configuration command can thus fail if hardware rfkill
                 * is enabled
                 *
                 * FIXME: integrate rfkill with mac80211 and then add this
                 * WARN_ON() back
                 *
                 */
                /* WARN_ON(ret); */
        }

        return ret;
}

Back to your change:
1) You are a WARN_ON(1). So on every drv_config() call you get a kernel
warning. Unlikely we want that.
2) For the warning to be put back, the comment says "integrate rfkill
with mac80211". Adding an include of the rfkill header file does not
really cover that statement.

All in all you seem to forget a number of steps in
Documentation/SubmittingPatches. Apart from passing checkpatch.pl it
should first of all at least compile :-(

Gr. AvS

