Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0LIV0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 16:26:54 -0500
Received: from www.sr71.net ([198.145.64.142]:45668 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab0LIV0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 16:26:53 -0500
Subject: brcm80211 hangs when disabling wireless
From: Dave Hansen <dave@sr71.net>
To: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Mike Rapoport <mike.rapoport@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 09 Dec 2010 13:26:50 -0800
Message-ID: <1291930010.7960.30.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been getting hard hangs when I toggle the wireless on a Lenovo
S10-3.  It happens both with the physical switch and the Fn-F5 key
combo.  It's quite repeatable.  The system is quite stable when I'm not
trying to disable the wireless, though.

I've been able to get some screenshots, but the console messages don't
make it out to the disk:

	http://picasaweb.google.com/hansendc/BrcmOops#

netconsole also isn't working on this hardware.  Any other suggestions
for getting an oops out of a serial-port-challenged netbook?

It isn't completely clear to me where this bug actually is.  The stack
dump looks almost completely confined to net/mac80211/ functions, but
there are a few error printk's from brcm80211.

The first printk's are from this code, but it's apparently trying to
transmit in the mac80211 stack anyway:
        
        static int wl_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
        {
                int status;
                wl_info_t *wl = hw->priv;
                WL_LOCK(wl);
                if (!wl->pub->up) {
                        WL_ERROR(("ops->tx called while down\n"));
                        status = -ENETDOWN;
                        goto done;
                }
                status = wl_start(skb, wl);
         done:
                WL_UNLOCK(wl);
                return status;
        }

I'm not completely sure that this is what is causing the hang that I'm
seeing, but it's certainly the last thing I see on the console.  

With the hardware driver in -staging, I don't expect anybody to jump out
of their seats to fix this, I just figured someone might want to see the
bug report.

-- Dave

