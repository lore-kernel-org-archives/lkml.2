Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1DBOKJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 10:10:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:48282 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab1DBOKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 10:10:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andreas Huber <hobrom@gmx.at>
Subject: Re: [RFC/PATCH 0/3] locking fixes for cx88
Date: Sat, 2 Apr 2011 14:05:30 +0000 (UTC)
Message-ID: <loom.20110402T155704-858@post.gmane.org>
References: <20110327150610.4029.95961.reportbug@xen.corax.at> <20110327152810.GA32106@elie> <20110402093856.GA17015@elie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 84.114.185.220 (Mozilla/5.0 (Windows NT 6.1; WOW64; rv:2.0) Gecko/20100101 Firefox/4.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder <jrnieder <at> gmail.com> writes:

> 
> Hi,
> 
> Huber Andreas wrote[1]:
> 
> > Processes that try to open a cx88-blackbird driven MPEG device will hang up.
> 
> Here's a possible fix based on a patch by Ben Hutchings and
> corrections from Andi Huber.  Warning: probably full of mistakes (my
> fault) since I'm not familiar with any of this stuff.  Untested.
> Review and testing would be welcome.
> 
> Ben Hutchings (2):
>   [media] cx88: fix locking of sub-driver operations
>   [media] cx88: use a mutex to protect cx8802_devlist
> 
> Jonathan Nieder (1):
>   [media] cx88: protect per-device driver list with device lock
> 
>  drivers/media/video/cx88/cx88-blackbird.c |    3 +-
>  drivers/media/video/cx88/cx88-dvb.c       |    2 +
>  drivers/media/video/cx88/cx88-mpeg.c      |   35 +++++++++++++++++++---------
>  drivers/media/video/cx88/cx88.h           |   10 +++++++-
>  4 files changed, 37 insertions(+), 13 deletions(-)
> 

There is an unrelated issue!!!

The driver's active_ref count may become negative which leads to unpredictable
behavior. (MPEG video device inaccessible, etc ...)

Here's a possible fix ...


diff -Nur a/drivers/media/video/cx88/cx88-mpeg.c
b/drivers/media/video/cx88/cx88-mpeg.c
--- a/drivers/media/video/cx88/cx88-mpeg.c	2011-04-02 14:34:21.456569849 +0200
+++ b/drivers/media/video/cx88/cx88-mpeg.c	2011-04-02 14:32:55.467038000 +0200
@@ -642,12 +642,16 @@
 {
 	struct cx88_core *core = drv->core;
 
+	mpeg_dbg(1,"%s active driver references before release attempt:
%d\n",core->name,core->active_ref);
+	
 	if (drv->advise_release && --core->active_ref == 0)
 	{
 		drv->advise_release(drv);
 		core->active_type_id = CX88_BOARD_NONE;
 		mpeg_dbg(1,"%s() Post release GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
 	}
+	
+	if(core->active_ref<0) core->active_ref=0; // prevent us from getting negative
ref counts!
 
 	return 0;
 }


I can confirm that Johnathan's patchset plus applying this fix works!
Tests done on amd64 hardware with 2 Hauppauge HVR1300 TV cards: 
Both were independently able to tune channels and stream encoded video through
their MPEG encoder devices.

Andi.

