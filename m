Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab1AYGw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:52:26 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34040 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1AYGwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:52:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hr/EZXrUj+4zVNx9n6kbfxG+dP6ciN1WVTbxhcD7d0wgbMTnGQsLfJjPYRz3V19LvN
         /I5iwhwiwBH2KJwB2WoMgdxCudRuHPas2MEGiJ8myrXeJm8RQd+Jb4WeDq9t6bFIoQ58
         S8dFjxR2c6cHxqaKEarr6ZTN8f2/XKmQmazHY=
Date: Mon, 24 Jan 2011 22:52:17 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110125065217.GE7850@core.coreip.homeip.net>
References: <20110124175456.GA17855@core.coreip.homeip.net>
 <4D3E1A08.5060303@teksavvy.com>
 <20110125005555.GA18338@core.coreip.homeip.net>
 <4D3E4DD1.60705@teksavvy.com>
 <20110125042016.GA7850@core.coreip.homeip.net>
 <4D3E5372.9010305@teksavvy.com>
 <20110125045559.GB7850@core.coreip.homeip.net>
 <4D3E59CA.6070107@teksavvy.com>
 <4D3E5A91.30207@teksavvy.com>
 <20110125053117.GD7850@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125053117.GD7850@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 09:31:17PM -0800, Dmitry Torokhov wrote:
> On Tue, Jan 25, 2011 at 12:07:29AM -0500, Mark Lord wrote:
> > On 11-01-25 12:04 AM, Mark Lord wrote:
> > > On 11-01-24 11:55 PM, Dmitry Torokhov wrote:
> > >> On Mon, Jan 24, 2011 at 11:37:06PM -0500, Mark Lord wrote:
> > > ..
> > >>> This results in (map->size==10) for 2.6.36+ (wrong),
> > >>> and a much larger map->size for 2.6.35 and earlier.
> > >>>
> > >>> So perhaps EVIOCGKEYCODE has changed?
> > >>>
> > >>
> > >> So the utility expects that all devices have flat scancode space and
> > >> driver might have changed so it does not recognize scancode 10 as valid
> > >> scancode anymore.
> > >>
> > >> The options are:
> > >>
> > >> 1. Convert to EVIOCGKEYCODE2
> > >> 2. Ignore errors from EVIOCGKEYCODE and go through all 65536 iterations.
> > > 
> > > or 3. Revert/fix the in-kernel regression.
> > > 
> > > The EVIOCGKEYCODE ioctl is supposed to return KEY_RESERVED for unmapped
> > > (but value) keycodes, and only return -EINVAL when the keycode itself
> > > is out of range.
> > > 
> > > That's how it worked in all kernels prior to 2.6.36,
> > > and now it is broken.  It now returns -EINVAL for any unmapped keycode,
> > > even though keycodes higher than that still have mappings.
> > > 
> > > This is a bug, a regression, and breaks userspace.
> > > I haven't identified *where* in the kernel the breakage happened,
> > > though.. that code confuses me.  :)
> > 
> > Note that this device DOES have "flat scancode space",
> > and the kernel is now incorrectly signalling an error (-EINVAL)
> > in response to a perfectly valid query of a VALID (and mappable)
> > keycode on the remote control
> > 
> > The code really is a valid button, it just doesn't have a default mapping
> > set by the kernel (I can set a mapping for that code from userspace and it works).
> > 
> 
> OK, in this case let's ping Mauro - I think he done the adjustments to
> IR keymap hanlding.
> 
> Thanks.
> 

BTW, could you please try the following patch (it assumes that
EVIOCGVERSION in input.c is alreday relaxed).

Thanks!

-- 
Dmitry

>From c22c85c0b675422a23e3d853ed06fedc36805774 Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 24 Jan 2011 22:49:59 -0800
Subject: [PATCH] input-kbd - switch to using EVIOCGKEYCODE2 when available

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 input-kbd.c |  118 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 files changed, 80 insertions(+), 38 deletions(-)

diff --git a/input-kbd.c b/input-kbd.c
index e94529d..5d93d54 100644
--- a/input-kbd.c
+++ b/input-kbd.c
@@ -9,9 +9,27 @@
 
 #include "input.h"
 
+struct input_keymap_entry_v1 {
+	uint32_t scancode;
+	uint32_t keycode;
+};
+
+struct input_keymap_entry_v2 {
+#define KEYMAP_BY_INDEX	(1 << 0)
+	uint8_t  flags;
+	uint8_t  len;
+	uint16_t index;
+	uint32_t keycode;
+	uint8_t  scancode[32];
+};
+
+#ifndef EVIOCGKEYCODE2
+#define EVIOCGKEYCODE2 _IOR('E', 0x04, struct input_keymap_entry_v2)
+#endif
+
 struct kbd_entry {
-	int scancode;
-	int keycode;
+	unsigned int scancode;
+	unsigned int keycode;
 };
 
 struct kbd_map {
@@ -23,7 +41,7 @@ struct kbd_map {
 
 /* ------------------------------------------------------------------ */
 
-static struct kbd_map* kbd_map_read(int fd)
+static struct kbd_map* kbd_map_read(int fd, unsigned int version)
 {
 	struct kbd_entry entry;
 	struct kbd_map *map;
@@ -32,16 +50,37 @@ static struct kbd_map* kbd_map_read(int fd)
 	map = malloc(sizeof(*map));
 	memset(map,0,sizeof(*map));
 	for (map->size = 0; map->size < 65536; map->size++) {
-		entry.scancode = map->size;
-		entry.keycode  = KEY_RESERVED;
-		rc = ioctl(fd, EVIOCGKEYCODE, &entry);
-		if (rc < 0) {
-			break;
+		if (version < 0x10001) {
+			struct input_keymap_entry_v1 ke = {
+				.scancode = map->size,
+				.keycode = KEY_RESERVED,
+			};
+
+			rc = ioctl(fd, EVIOCGKEYCODE, &ke);
+			if (rc < 0)
+				break;
+		} else {
+			struct input_keymap_entry_v2 ke = {
+				.index = map->size,
+				.flags = KEYMAP_BY_INDEX,
+				.len = sizeof(uint32_t),
+				.keycode = KEY_RESERVED,
+			};
+
+			rc = ioctl(fd, EVIOCGKEYCODE2, &ke);
+			if (rc < 0)
+				break;
+
+			memcpy(&entry.scancode, ke.scancode,
+				sizeof(entry.scancode));
+			entry.keycode = ke.keycode;
 		}
+
 		if (map->size >= map->alloc) {
 			map->alloc += 64;
 			map->map = realloc(map->map, map->alloc * sizeof(entry));
 		}
+
 		map->map[map->size] = entry;
 
 		if (KEY_RESERVED != entry.keycode)
@@ -155,40 +194,27 @@ static void kbd_print_bits(int fd)
 	}
 }
 
-static void show_kbd(int nr)
+static void show_kbd(int fd, unsigned int protocol_version)
 {
 	struct kbd_map *map;
-	int fd;
 
-	fd = device_open(nr,1);
-	if (-1 == fd)
-		return;
 	device_info(fd);
 
-	map = kbd_map_read(fd);
-	if (NULL != map) {
-		kbd_map_print(stdout,map,0);
-	} else {
+	map = kbd_map_read(fd, protocol_version);
+	if (map)
+		kbd_map_print(stdout, map, 0);
+	else
 		kbd_print_bits(fd);
-	}
-
-	close(fd);
 }
 
-static int set_kbd(int nr, char *mapfile)
+static int set_kbd(int fd, unsigned int protocol_version, char *mapfile)
 {
 	struct kbd_map *map;
 	FILE *fp;
-	int fd;
-
-	fd = device_open(nr,1);
-	if (-1 == fd)
-		return -1;
 
-	map = kbd_map_read(fd);
+	map = kbd_map_read(fd, protocol_version);
 	if (NULL == map) {
 		printf("device has no map\n");
-		close(fd);
 		return -1;
 	}
 
@@ -198,18 +224,15 @@ static int set_kbd(int nr, char *mapfile)
 		fp = fopen(mapfile,"r");
 		if (NULL == fp) {
 			printf("open %s: %s\n",mapfile,strerror(errno));
-			close(fd);
 			return -1;
 		}
 	}
-	
+
 	if (0 != kbd_map_parse(fp,map) ||
 	    0 != kbd_map_write(fd,map)) {
-		close(fd);
 		return -1;
 	}
 
-	close(fd);
 	return 0;
 }
 
@@ -223,8 +246,10 @@ static int usage(char *prog, int error)
 
 int main(int argc, char *argv[])
 {
-	int c,devnr;
+	int c, devnr, fd;
 	char *mapfile = NULL;
+	unsigned int protocol_version;
+	int rc = EXIT_FAILURE;
 
 	for (;;) {
 		if (-1 == (c = getopt(argc, argv, "hf:")))
@@ -244,12 +269,29 @@ int main(int argc, char *argv[])
 		usage(argv[0],1);
 
 	devnr = atoi(argv[optind]);
-	if (mapfile) {
-		set_kbd(devnr,mapfile);
-	} else {
-		show_kbd(devnr);
+
+	fd = device_open(devnr, 1);
+	if (fd < 0)
+		goto out;
+
+	if (ioctl(fd, EVIOCGVERSION, &protocol_version) < 0) {
+		fprintf(stderr,
+			"Unable to query evdev protocol version: %s\n",
+			strerror(errno));
+		goto out_close;
 	}
-	return 0;
+
+	if (mapfile)
+		set_kbd(fd, protocol_version, mapfile);
+	else
+		show_kbd(fd, protocol_version);
+
+	rc = EXIT_SUCCESS;
+
+out_close:
+	close(fd);
+out:
+	return rc;
 }
 
 /* ---------------------------------------------------------------------
-- 
1.7.3.4

