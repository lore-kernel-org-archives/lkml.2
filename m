Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab0LRMIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 07:08:30 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:54131 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755591Ab0LRMI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 07:08:28 -0500
Date: Sat, 18 Dec 2010 12:58:50 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Duncan Sands <duncan.sands@free.fr>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: speedtch: don't abuse struct delayed_work
Message-ID: <20101218125850.24d4e604@absol.kitzblitz>
In-Reply-To: <20101217145117.75a28ae0@absol.kitzblitz>
References: <20101216213005.GA5781@kroah.com>
	<1292172499-21633-6-git-send-email-tj@kernel.org>
	<1292172499-21633-1-git-send-email-tj@kernel.org>
	<20101217145117.75a28ae0@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nicolas Kaiser <nikai@nikai.net>:
> > On Sun, Dec 12, 2010 at 05:48:18PM +0100, Tejun Heo wrote:
> >> speedtch directly uses the internal timer and work members of a struct
> >> delayed_work.  Use a separate work item and timer instead.
> 
> >> This is part of a series to remove flush_scheduled_work() usage to
> >> prepare for deprecation of flush_scheduled_work().  Patches in this
> >> series are self contained and mostly straight-forward
> 
> I tested this patch with 2.6.37-rc6. Not sure whether 
> I'm doing something wrong, but I failed to start the
> PPP daemon with my speedtouch usb:

I narrowed down my problem, and noticed that speedtch_atm_start
never returns, but gets stuck trying to start status polling.

Now when I delete this mod_timer, everything appears to work
nicely at my place. With additional debug output:


Dec 18 12:24:40 absol kernel: ATM dev 0: speedtch_atm_start entered
Dec 18 12:24:40 absol kernel: ATM dev 0: speedtch_start_synchro entered
Dec 18 12:24:40 absol kernel: ATM dev 0: speedtch_start_synchro: modem prodded. 2 bytes returned: 00 00
 Dec 18 12:24:40 absol kernel: return from speedtch_start_synchro
 Dec 18 12:24:40 absol kernel: return from speedtch_atm_start

Dec 18 12:24:49 absol pppd[4844]: Plugin pppoatm.so loaded.
Dec 18 12:24:49 absol pppd[4844]: PPPoATM plugin_init
Dec 18 12:24:49 absol pppd[4844]: PPPoATM setdevname_pppoatm - SUCCESS:8.48
Dec 18 12:24:49 absol pppd[4845]: pppd 2.4.4 started by root, uid 0
Dec 18 12:24:49 absol pppd[4845]: using channel 1
Dec 18 12:24:49 absol pppd[4845]: Using interface ppp0
Dec 18 12:24:49 absol pppd[4845]: Connect: ppp0 <--> 8.48

Dec 18 12:24:54 absol kernel: ATM dev 0: speedtch_handle_int entered
Dec 18 12:24:54 absol kernel: ATM dev 0: DSL line goes up
 Dec 18 12:24:54 absol kernel: return from speedtch_handle_int
 Dec 18 12:24:54 absol kernel: entered speedtch_check_status
 Dec 18 12:24:54 absol kernel: entered speedtch_read_status
 Dec 18 12:24:54 absol kernel: return from speedtch_read_status
Dec 18 12:24:54 absol kernel: ATM dev 0: speedtch_check_status: line state 0x20
Dec 18 12:24:54 absol kernel: ATM dev 0: ADSL line is up (6176 kb/s down | 512 kb/s up)
 Dec 18 12:24:54 absol kernel: return from speedtch_check_status


Best regards,
Nicolas Kaiser

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/usb/atm/speedtch.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/atm/speedtch.c b/drivers/usb/atm/speedtch.c
index b591906..e6d8847 100644
--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -686,9 +686,6 @@ static int speedtch_atm_start(struct usbatm_data *usbatm, struct atm_dev *atm_de
 		}
 	}
 
-	/* Start status polling */
-	mod_timer(&instance->status_check_timer, jiffies + msecs_to_jiffies(1000));
-
 	return 0;
 }
 
-- 
1.7.2.2
