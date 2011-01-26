Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1AZOTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 09:19:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab1AZOTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 09:19:09 -0500
Message-ID: <4D402D35.4090206@redhat.com>
Date: Wed, 26 Jan 2011 12:18:29 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Lord <kernel@teksavvy.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com> <4D401CC5.4020000@redhat.com>
In-Reply-To: <4D401CC5.4020000@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-01-2011 11:08, Gerd Hoffmann escreveu:
>   Hi,
> 
>> Btw, I took some time to take analyse the input-kbd stuff.
>> As said at the README:
>>
>>     This is a small collection of input layer utilities.  I wrote them
>>     mainly for testing and debugging, but maybe others find them useful
>>     too :-)
>>     ...
>>     Gerd Knorr<kraxel@bytesex.org>  [SUSE Labs]
>>
>> This is an old testing tool written by Gerd Hoffmann probably used for him
>> to test the V4L early Remote Controller implementations.
> 
> Indeed.
> 
>> The last "official" version seems to be this one:
>>     http://dl.bytesex.org/cvs-snapshots/input-20081014-101501.tar.gz
> 
> Just moved the bits to git a few days ago.
> http://bigendian.kraxel.org/cgit/input/
> 
> Code is unchanged since 2008 though.
> 
>> Gerd, if you're still maintaining it, it is a good idea to apply Dmitry's
>> patch:
>>     http://www.spinics.net/lists/linux-input/msg13728.html
> 
> Hmm, doesn't apply cleanly ...

I suspect that Dmitry did the patch against the Debian package, based on a 2007
version of it, as it seems that Debian is using an older version of the package.

Anyway, I've ported his patch to be applied over your -git tree, and tested
on it, with vanilla 2.6.37.

That's the incorrect output result of the old version, with an existing
NEC extended map:

$ sudo /tmp/input/input-kbd 2
/dev/input/event2
   bustype : BUS_I2C
   vendor  : 0x0
   product : 0x0
   version : 0
   name    : "i2c IR (i2c IR (EM2820 Winfast "
   phys    : "i2c-0/0-0030/ir0"
   bits ev : EV_SYN EV_KEY EV_MSC EV_REP

bits: KEY_1
bits: KEY_2
bits: KEY_3
bits: KEY_4
...

And that's the output after applying the patch:

$ sudo ./input-kbd 2
/dev/input/event2
   bustype : BUS_I2C
   vendor  : 0x0
   product : 0x0
   version : 0
   name    : "i2c IR (i2c IR (EM2820 Winfast "
   phys    : "i2c-0/0-0030/ir0"
   bits ev : EV_SYN EV_KEY EV_MSC EV_REP

map: 31 keys, size: 31/64
0x866b00 = 393  # KEY_VIDEO
0x866b01 =   2  # KEY_1
0x866b02 =  11  # KEY_0
0x866b03 = 386  # KEY_TUNER

-

[PATCH] input-kbd - switch to using EVIOCGKEYCODE2 when available

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[mchehab@redhat.com: Ported it to the -git version]

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/input-kbd.c b/input-kbd.c
index c432d0d..aaf23b9 100644
--- a/input-kbd.c
+++ b/input-kbd.c
@@ -9,9 +9,22 @@
 
 #include "input.h"
 
+struct input_keymap_entry_v2 {
+#define KEYMAP_BY_INDEX	(1 << 0)
+	uint8_t  flags;
+	uint8_t  len;
+	uint16_t index;
+	uint32_t keycode;
+	uint8_t  scancode[32];
+};
+
+#ifndef EVIOCGKEYCODE_V2
+#define EVIOCGKEYCODE_V2 _IOR('E', 0x04, struct input_keymap_entry_v2)
+#endif
+
 struct kbd_entry {
-	int scancode;
-	int keycode;
+	unsigned int scancode;
+	unsigned int keycode;
 };
 
 struct kbd_map {
@@ -23,7 +36,7 @@ struct kbd_map {
 
 /* ------------------------------------------------------------------ */
 
-static struct kbd_map* kbd_map_read(int fd)
+static struct kbd_map* kbd_map_read(int fd, unsigned int version)
 {
 	struct kbd_entry entry;
 	struct kbd_map *map;
@@ -32,17 +45,35 @@ static struct kbd_map* kbd_map_read(int fd)
 	map = malloc(sizeof(*map));
 	memset(map,0,sizeof(*map));
 	for (map->size = 0; map->size < 65536; map->size++) {
-		entry.scancode = map->size;
-		entry.keycode  = KEY_RESERVED;
-		rc = ioctl(fd, EVIOCGKEYCODE, &entry);
-		if (rc < 0) {
-			map->size--;
-			break;
+		if (version < 0x10001) {
+			entry.scancode = map->size;
+			entry.keycode  = KEY_RESERVED;
+			rc = ioctl(fd, EVIOCGKEYCODE, &entry);
+			if (rc < 0) {
+				map->size--;
+				break;
+			}
+		} else {
+			struct input_keymap_entry_v2 ke = {
+				.index = map->size,
+				.flags = KEYMAP_BY_INDEX,
+				.len = sizeof(uint32_t),
+				.keycode = KEY_RESERVED,
+			};
+
+			rc = ioctl(fd, EVIOCGKEYCODE_V2, &ke);
+			if (rc < 0)
+				break;
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
@@ -156,37 +187,25 @@ static void kbd_print_bits(int fd)
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
 
-	fd = device_open(nr,1);
-	if (-1 == fd)
-		return -1;
-
-	map = kbd_map_read(fd);
+	map = kbd_map_read(fd, protocol_version);
 	if (NULL == map) {
 		fprintf(stderr,"device has no map\n");
 		close(fd);
@@ -203,14 +222,12 @@ static int set_kbd(int nr, char *mapfile)
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
 
@@ -224,8 +241,10 @@ static int usage(char *prog, int error)
 
 int main(int argc, char *argv[])
 {
-	int c,devnr;
+	int c, devnr, fd;
 	char *mapfile = NULL;
+	unsigned int protocol_version;
+	int rc = EXIT_FAILURE;
 
 	for (;;) {
 		if (-1 == (c = getopt(argc, argv, "hf:")))
@@ -245,12 +264,29 @@ int main(int argc, char *argv[])
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
diff --git a/input.c b/input.c
index d57a31e..a9bd5e8 100644
--- a/input.c
+++ b/input.c
@@ -101,8 +101,8 @@ int device_open(int nr, int verbose)
 		close(fd);
 		return -1;
 	}
-	if (EV_VERSION != version) {
-		fprintf(stderr, "protocol version mismatch (expected %d, got %d)\n",
+	if (EV_VERSION > version) {
+		fprintf(stderr, "protocol version mismatch (expected >= %d, got %d)\n",
 			EV_VERSION, version);
 		close(fd);
 		return -1;
