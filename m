Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1IWGT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 02:19:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27733 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab1IWGTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 02:19:55 -0400
Date: Fri, 23 Sep 2011 09:19:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] agp: potential info leak in compat_agpioc_info_wrap()
Message-ID: <20110923061945.GC4387@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E7C2509.005B:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch has a new check for Rosenberg type information leaks where
structs are copied to the user with uninitialized stack data in them.

The agp_info32 struct has a 4 byte hole in it so we need to clear
that before copying it to userspace.

struct agp_info32 {
        struct agp_version         version;              /*     0     0 */

        /* XXX 4 bytes hole, try to pack */

        u32                        bridge_id;            /*     4     4 */

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/char/agp/compat_ioctl.c b/drivers/char/agp/compat_ioctl.c
index a48e05b..0509497 100644
--- a/drivers/char/agp/compat_ioctl.c
+++ b/drivers/char/agp/compat_ioctl.c
@@ -42,6 +42,8 @@ static int compat_agpioc_info_wrap(struct agp_file_private *priv, void __user *a
 
 	agp_copy_info(agp_bridge, &kerninfo);
 
+	memset(&userinfo, 0, sizeof(userinfo));
+
 	userinfo.version.major = kerninfo.version.major;
 	userinfo.version.minor = kerninfo.version.minor;
 	userinfo.bridge_id = kerninfo.device->vendor |
