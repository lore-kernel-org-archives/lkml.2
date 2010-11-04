Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab0KDRUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:20:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:42122 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab0KDRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:20:45 -0400
Date: Thu, 4 Nov 2010 10:19:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, kyle@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
Message-Id: <20101104101910.920efbed.randy.dunlap@oracle.com>
In-Reply-To: <4CD29493.5020101@redhat.com>
References: <20101009224041.GA901@sepie.suse.cz>
	<4CD1E232.30406@redhat.com>
	<AANLkTimyh-k8gYwuNi6nZFp3oviQ33+M3fDRzZ+sJN9i@mail.gmail.com>
	<4CD22627.2000607@redhat.com>
	<AANLkTi=Eb8k6gmeGqvC=Zbo2mj51oHcbCncZGt00u9Tx@mail.gmail.com>
	<4CD29493.5020101@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Nov 2010 07:10:11 -0400 Mauro Carvalho Chehab wrote:

> All dependencies required by the selected symbols are satisfied. For example,
> the simplest case is likely cafe_ccic, as, currently, there's just one possible
> driver that can be attached dynamically at runtime to cafe_ccic. We have:
> 
> menu "Encoders/decoders and other helper chips"
> 	depends on !VIDEO_HELPER_CHIPS_AUTO
> 
> ...
> config VIDEO_OV7670
>         tristate "OmniVision OV7670 sensor support"
>         depends on I2C && VIDEO_V4L2
> ...
> endmenu
> 
> config VIDEO_CAFE_CCIC
>         tristate "Marvell 88ALP01 (Cafe) CMOS Camera Controller support"
>         depends on PCI && I2C && VIDEO_V4L2
>         select VIDEO_OV7670
> 
> The dependencies needed by ov7670 (I2C and VIDEO_V4L2) are also dependencies of 
> cafe_ccic. So, it shouldn't have any problem for it to work (and it doesn't have,
> really. This is working as-is during the last 4 years).

This warning line:

warning: (VIDEO_CAFE_CCIC && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && PCI && I2C && VIDEO_V4L2 || VIDEO_VIA_CAMERA && MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && FB_VIA) selects VIDEO_OV7670 which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && I2C && VIDEO_V4L2)

is not caused by CAFE_CCIC -- it's caused by VIDEO_VIA_CAMERA, because
VIDEO_HELPER_CHIPS_AUTO=y, so !VIDEO_HELPER_CHIPS_AUTO is false, so
VIDEO_OV7670 should not be available since it depends on
!VIDEO_HELPER_CHIPS_AUTO.

Below is a simple patch that reduces the kconfig warning count in 2.6.37-rc1
from 240 down to only 88.  :)


> It should be noticed that, even if we replace the menu dependencies by an
> If, won't solve. I tried the enclosed patch, to see if it would produce something
> that the new Kconfig behavior accepts. The same errors apply.

That does not change any kconfig symbol logic/truth values.

> It is fine for me if you want/need to change the way Kconfig works, provided
> that it won't break (or produce those annoying warnings) the existing logic, and
> won't open the manual select menu, if the user selects the auto mode.
> Just send us a patch changing it to some other way of doing it.
> 
> Thanks,
> Mauro
> ---

From: Randy Dunlap <randy.dunlap@oracle.com>

Clean up some video driver dependencies.
Reduces the kconfig warning for unmet dependencies from 240
down to only 88 in 2.6.37-rc1.

This makes the drivers in the VIDEO_HELPER_CHIPS_AUTO menu not
be dependent on that symbol.  Just splash a comment there
instead.  config tools will display the comment when
VIDEO_HELPER_CHIPS_AUTO is false.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.37-rc1-git3.orig/drivers/media/video/Kconfig
+++ linux-2.6.37-rc1-git3/drivers/media/video/Kconfig
@@ -112,6 +112,10 @@ config VIDEO_IR_I2C
 #
 
 menu "Encoders/decoders and other helper chips"
+
+comment "Only change these kconfig Helper/Auto settings if you are sure"
+	depends on !VIDEO_HELPER_CHIPS_AUTO
+comment "that you know what you are doing"
 	depends on !VIDEO_HELPER_CHIPS_AUTO
 
 comment "Audio decoders"
