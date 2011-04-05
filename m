Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1DEDU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 23:20:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43337 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab1DEDUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 23:20:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=txZEQGoQWjI2kCNS0Sixm6ebBasEpDEjneTQHdVJ2UXbFKpwYR2Yk9tdXY4m7nhTKp
         xWUGi15DzXkgfO6MIm7ize9K1sKEQybRx1vnl0vvp2gqngZJ8SpIUmepOnaX5ol9KGWK
         sLEsSCOKeEJA9n8+fCcWmIeww1M6c20H5Wnvc=
Date: Mon, 4 Apr 2011 22:20:14 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Steven Toth <stoth@kernellabs.com>
Subject: [RFC/PATCH v2 0/7] locking fixes for cx88
Message-ID: <20110405032014.GA4498@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
 <20110327152810.GA32106@elie>
 <20110402093856.GA17015@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110402093856.GA17015@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Jonathan Nieder wrote:
> Huber Andreas wrote[1]:

>> Processes that try to open a cx88-blackbird driven MPEG device will hang up.
>
> Here's a possible fix based on a patch by Ben Hutchings and
> corrections from Andi Huber.  Warning: probably full of mistakes (my
> fault) since I'm not familiar with any of this stuff.  Untested.
> Review and testing would be welcome.

A reroll.  As before, the goals are: (1) eliminate deadlock, (2)
eliminate races, (3) introduce some clarity.  The same caveats as
last time apply --- this is only compile-tested.  Thanks again to Andi
for testing the previous series and for other useful feedback.

Patch 1 is meant to protect dev->drvlist against data races.
Since v1, I removed some clutter in the patch itself and clarified the
change description to match.

Patch 2 addresses the original deadlock.  The only changes are the
description and declared authorship of the patch (at Ben's request).

Patch 3 is new.  It fixes the reference count breakage Andi noticed
(another race previously protected against by the BKL).

Patch 4 fixes a data race noticed by Ben (also from his patch).  It's
unchanged.

Patches 5, 6, and 7 are cleanups.

Bugs?  Thoughts?
Jonathan Nieder (7):
  [media] cx88: protect per-device driver list with device lock
  [media] cx88: fix locking of sub-driver operations
  [media] cx88: hold device lock during sub-driver initialization
  [media] cx88: use a mutex to protect cx8802_devlist
  [media] cx88: handle attempts to use unregistered cx88-blackbird
    driver
  [media] cx88: don't use atomic_t for core->mpeg_users
  [media] cx88: don't use atomic_t for core->users

 drivers/media/video/cx88/cx88-blackbird.c |   41 +++++++++++++++-------------
 drivers/media/video/cx88/cx88-dvb.c       |    2 +
 drivers/media/video/cx88/cx88-mpeg.c      |   40 ++++++++++++++++++----------
 drivers/media/video/cx88/cx88-video.c     |    5 ++-
 drivers/media/video/cx88/cx88.h           |   11 +++++--
 5 files changed, 61 insertions(+), 38 deletions(-)
