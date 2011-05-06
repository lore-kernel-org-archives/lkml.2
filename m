Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1EFAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:16:57 -0400
Received: from kroah.org ([198.145.64.141]:32893 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785Ab1EFANa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:13:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:12:09 2011
Message-Id: <20110506001209.591865559@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:10:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 23/38] [media] v4l: make sure drivers supply a zeroed struct v4l2_subdev
In-Reply-To: <20110506001225.GA10547@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

commit 80845a33165278f3236812009e9c568ba8c29938 upstream.

Some v4l drivers currently don't initialize their struct v4l2_subdev
with zeros, and this is a problem since some of the v4l2 code expects
this. One example is the addition of internal_ops in commit 45f6f84,
after that we are at risk of random oopses with these drivers when code
in v4l2_device_register_subdev tries to dereference sd->internal_ops->*,
as can be shown by the report at http://bugs.launchpad.net/bugs/745213
and analysis of its crash at https://lkml.org/lkml/2011/4/1/168

Use kzalloc within problematic drivers to ensure we have a zeroed struct
v4l2_subdev.

BugLink: http://bugs.launchpad.net/bugs/745213
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/radio/saa7706h.c  |    2 +-
 drivers/media/radio/tef6862.c   |    2 +-
 drivers/media/video/m52790.c    |    2 +-
 drivers/media/video/tda9840.c   |    2 +-
 drivers/media/video/tea6415c.c  |    2 +-
 drivers/media/video/tea6420.c   |    2 +-
 drivers/media/video/upd64031a.c |    2 +-
 drivers/media/video/upd64083.c  |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -376,7 +376,7 @@ static int __devinit saa7706h_probe(stru
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kmalloc(sizeof(struct saa7706h_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct saa7706h_state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -176,7 +176,7 @@ static int __devinit tef6862_probe(struc
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kmalloc(sizeof(struct tef6862_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct tef6862_state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	state->freq = TEF6862_LO_FREQ;
--- a/drivers/media/video/m52790.c
+++ b/drivers/media/video/m52790.c
@@ -174,7 +174,7 @@ static int m52790_probe(struct i2c_clien
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kmalloc(sizeof(struct m52790_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct m52790_state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 
--- a/drivers/media/video/tda9840.c
+++ b/drivers/media/video/tda9840.c
@@ -171,7 +171,7 @@ static int tda9840_probe(struct i2c_clie
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	sd = kmalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
 	if (sd == NULL)
 		return -ENOMEM;
 	v4l2_i2c_subdev_init(sd, client, &tda9840_ops);
--- a/drivers/media/video/tea6415c.c
+++ b/drivers/media/video/tea6415c.c
@@ -152,7 +152,7 @@ static int tea6415c_probe(struct i2c_cli
 
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
-	sd = kmalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
 	if (sd == NULL)
 		return -ENOMEM;
 	v4l2_i2c_subdev_init(sd, client, &tea6415c_ops);
--- a/drivers/media/video/tea6420.c
+++ b/drivers/media/video/tea6420.c
@@ -125,7 +125,7 @@ static int tea6420_probe(struct i2c_clie
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	sd = kmalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
 	if (sd == NULL)
 		return -ENOMEM;
 	v4l2_i2c_subdev_init(sd, client, &tea6420_ops);
--- a/drivers/media/video/upd64031a.c
+++ b/drivers/media/video/upd64031a.c
@@ -230,7 +230,7 @@ static int upd64031a_probe(struct i2c_cl
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kmalloc(sizeof(struct upd64031a_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct upd64031a_state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;
--- a/drivers/media/video/upd64083.c
+++ b/drivers/media/video/upd64083.c
@@ -202,7 +202,7 @@ static int upd64083_probe(struct i2c_cli
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
-	state = kmalloc(sizeof(struct upd64083_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct upd64083_state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
 	sd = &state->sd;


