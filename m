Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2EKHc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 03:32:26 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:55325 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425Ab2EKHcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 03:32:25 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        Bryan Wu <bryan.wu@canonical.com>
Subject: Re: [PATCH] leds-pca955x: Fix race condition while setting brightness on several LEDs
Date: Fri, 11 May 2012 09:32:21 +0200
Message-ID: <1505623.sWns9kv83I@ws-stein>
User-Agent: KMail/4.8.0 (Linux/3.2.12-gentoo; KDE/4.8.1; x86_64; ; )
In-Reply-To: <20120510144016.3a1b006c.akpm@linux-foundation.org>
References: <1328705048-21073-1-git-send-email-alexander.stein@systec-electronic.com> <20120510144016.3a1b006c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 10. Mai 2012, 14:40:16 schrieb Andrew Morton:
> On Wed,  8 Feb 2012 13:44:08 +0100
> 
> Alexander Stein <alexander.stein@systec-electronic.com> wrote:
> > When issuing the following command:
> > for I in 0 1 2 3 4 5 6 7; do
> > 
> >   echo 0 > /sys/class/leds/pca955x\:${I}/brightness;
> > 
> > done
> > It is possible that all the pca955x_read_ls calls are done sequentially
> > before any pca955x_write_ls call is done. This updates the LS only to the
> > last LED update in its set.
> > Fix this by using a global lock for the pca995x device during
> > pca955x_led_work.
> 
> There's the bugfix.
> 
> > Also used a struct for shared data bewteen all LEDs.
> 
> And there's an apparently unrelated change whcih created a *lot* of
> noise in the patch.  It would be good to separate these things, with
> the bugfix being the first change.

This doesn't work. A problem was that each LED had it's own lock used upon 
scheduling it's own workqueue. No synchronization betwen all LEDs on this 
chip.

> > ...
> > 
> > -static inline u8 pca955x_ledsel(u8 oldval, int led_num, int state)
> > +static inline u8 pca955x_ledel(u8 oldval, int led_num, int state)
> 
> Why was this function renamed, and what does "ledel" mean?

Whoops, my mistake. This wasn't intended. I will gladly send a new patch with 
the last function name change reverted. Unless someone objects against the 
synchronizaton.

Regards,
Alexander
-- 
Dipl.-Inf. Alexander Stein

SYS TEC electronic GmbH
August-Bebel-Str. 29
D-07973 Greiz

Tel: +49-3661-6279-0, Fax: +49-3661-6279-99
eMail:    Alexander.Stein@systec-electronic.com
Internet: http://www.systec-electronic.com

Managing Director: Dipl.-Phys. Siegmar Schmidt
Commercial registry: Amtsgericht Jena, HRB 205563
