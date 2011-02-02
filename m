Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab1BBWEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:04:48 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38250 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab1BBWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:04:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=klPDBUpovA7JPYGYd4SJt2cGyoSgBvhH9LVotg1As2G6UOTkWg325MxrmVKIblj3sT
         dI2fPYxlP7mV49wwFnKrgba4zN7dtagtyEH8s17UAzsnPknaW2yifhIK2uu0w9MgpMVc
         GlPMI67x29eMSDjdyjgHUkvGIoIdaLtyHdYLc=
Date: Wed, 2 Feb 2011 14:04:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, kraxel@redhat.com
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110202220434.GA20033@core.coreip.homeip.net>
References: <4D3C5F73.2050408@teksavvy.com>
 <4D496AAC.1010106@canonical.com>
 <20110202165800.GB3178@core.coreip.homeip.net>
 <4D49B7D7.9020003@canonical.com>
 <4D49D2AA.20201@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D49D2AA.20201@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 04:54:50PM -0500, Mark Lord wrote:
> On 11-02-02 03:00 PM, Chase Douglas wrote:
> > On 02/02/2011 11:58 AM, Dmitry Torokhov wrote:
> >> On Wed, Feb 02, 2011 at 09:31:08AM -0500, Chase Douglas wrote:
> >>> On 01/23/2011 12:03 PM, Mark Lord wrote:
> >>>> As of the 2.6.36 kernel, the userspace commands lsinput and input-kbd
> >>>> no longer work.  And if I grab newer/patched versions of those from the latest
> >>>> Ubuntu 10.10, then those newer/patched versions do not work with kernels
> >>>> *before* 2.6.36.
> >>>
> >>> I planned on taking another look at this before we release Ubuntu 11.04
> >>> at the end of April. That doesn't prevent someone else from helping out
> >>> :), but I'll make sure the utility is working again if not.
> >>>
> >>
> >> Here you go:
> 
> That patch was not enough for me to get input-kbd working here on Ubuntu-10.10.
> It would still only let me map 10 keys of my 56(?) button remote.
> 
> I also had to hack it to ignore the read-in map->size value when writing-out
> the new keymap.

I assumed that the fix to make RCs compatible with the pre-v2 getkeycode
will trickle into Ubuntu through staging (I will be sending a patch to
the stable team today now that it is in mainline). But if Chase wants to
also add V2 keycode hdling then here's another patch.

Thanks.

-- 
Dmitry


>From cf5954a4db2d0e411bd6f717fb50bcdf37e80c9b Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Mon, 24 Jan 2011 22:49:59 -0800
Subject: [PATCH 2/2] input-kbd - switch to using EVIOCGKEYCODE2 when available

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
1.7.3.5

