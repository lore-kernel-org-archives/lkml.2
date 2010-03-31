Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab0CaRJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 13:09:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59631 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757769Ab0CaRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 13:09:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=lnTfuncnVCXIqAinG0mJIKOwbFv4iknemM4YPv474PqYKN45x/vDNiPxr4DCyxNh8B
         H3M7LqvZAFlrUj2yOqPUZLxW/cr71l/ugtvDDnDyBX4Uj/gvHFoRFOSO0sO4HXoIgJkz
         0JA0L5NCNaOwEcZIDTXn/VMkpZ6zc0gXDGOo0=
Date: Wed, 31 Mar 2010 20:09:17 +0300
From: Dan Carpenter <error27@gmail.com>
To: Zhang Rui <rui.zhang@intel.com>, casteyde.christian@free.fr
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] thermal: make lockdep happy
Message-ID: <20100331170916.GA13784@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Zhang Rui <rui.zhang@intel.com>, casteyde.christian@free.fr,
	Andrew Morton <akpm@linux-foundation.org>,
	Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>,
	Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

Can you test this patch?

I wrote this to address bugzilla bug:
	https://bugzilla.kernel.org/show_bug.cgi?id=15504
	BUG: key ffff88004c3811e0 not in .data! occured in lockdep.c

We now have to call sysfs_attr_init() for dynamically allocated sysfs 
attributes or lockdep complains.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5066de5..d4fec47 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -725,6 +725,7 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 		goto release_idr;
 
 	sprintf(dev->attr_name, "cdev%d_trip_point", dev->id);
+	sysfs_attr_init(&dev->attr.attr);
 	dev->attr.attr.name = dev->attr_name;
 	dev->attr.attr.mode = 0444;
 	dev->attr.show = thermal_cooling_device_trip_point_show;
