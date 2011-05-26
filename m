Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab1EZNRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 09:17:43 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:46241
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757774Ab1EZNRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 09:17:41 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Arjan Mels <arjan.mels@nxp.com>, usbip-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] staging: usbip: userspace tools v1.0.0
Date: Thu, 26 May 2011 06:17:11 -0700
Message-Id: <0c4a195be1692312819f75453c74cda818d9b8e3.1306414175.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306414175.git.mfm@muteddisk.com>
References: <cover.1306414175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new and improved (well somewhat, with a ways to go) userspace utility.

    mfm:pts/8[~/tmp/userspace]
    May26 05:18:31 % ./src/usbip help
    usage: usbip [--debug] [version]
                 [help] <command> <args>

      attach     Attach a remote USB device
      detach     Detach a remote USB device
      list       List exported or local USB devices
      bind       Bind device to usbip-host.ko
      unbind     Unbind device from usbip-host.ko

This first commit of the userspace `usbip' utility uses to same
implementation as the old tools, `usbip' and  `usbip_bind_driver'.
Nothing significant has changed so compatibility with windows has
_not_ been broken. However, the tools remain broken in many ways
due to the old implementation.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/configure.ac       |    4 +-
 drivers/staging/usbip/userspace/src/Makefile.am    |   11 +-
 drivers/staging/usbip/userspace/src/bind-driver.c  |  652 ----------------
 drivers/staging/usbip/userspace/src/usbip.c        |  814 ++++----------------
 drivers/staging/usbip/userspace/src/usbip.h        |   39 +
 drivers/staging/usbip/userspace/src/usbip_attach.c |  228 ++++++
 drivers/staging/usbip/userspace/src/usbip_bind.c   |  261 +++++++
 drivers/staging/usbip/userspace/src/usbip_detach.c |  103 +++
 drivers/staging/usbip/userspace/src/usbip_list.c   |  306 ++++++++
 drivers/staging/usbip/userspace/src/usbip_unbind.c |   95 +++
 drivers/staging/usbip/userspace/src/utils.c        |   60 ++-
 drivers/staging/usbip/userspace/src/utils.h        |    1 +
 12 files changed, 1233 insertions(+), 1341 deletions(-)
 delete mode 100644 drivers/staging/usbip/userspace/src/bind-driver.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip.h
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_attach.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_bind.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_detach.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_list.c
 create mode 100644 drivers/staging/usbip/userspace/src/usbip_unbind.c

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index e3afa15..e7d801b 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -1,8 +1,8 @@
 dnl Process this file with autoconf to produce a configure script.
 
 AC_PREREQ(2.59)
-AC_INIT([usbip], [0.1.8], [usbip-devel@lists.sourceforge.net])
-AC_DEFINE([USBIP_VERSION], [0x000106], [numeric version number])
+AC_INIT([usbip], [1.0.0], [usbip-devel@lists.sourceforge.net])
+AC_DEFINE([USBIP_VERSION], [0x00000100], [binary-coded decimal version number])
 
 CURRENT=0
 REVISION=1
diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/drivers/staging/usbip/userspace/src/Makefile.am
index 05a7aa5..52741c8 100644
--- a/drivers/staging/usbip/userspace/src/Makefile.am
+++ b/drivers/staging/usbip/userspace/src/Makefile.am
@@ -2,9 +2,10 @@ AM_CPPFLAGS := -I$(top_srcdir)/libsrc -DUSBIDS_FILE='"@USBIDS_DIR@/usb.ids"'
 AM_CFLAGS   := @EXTRA_CFLAGS@ @PACKAGE_CFLAGS@
 LDADD       := $(top_srcdir)/libsrc/libusbip.la @PACKAGE_LIBS@
 
-sbin_PROGRAMS := usbip usbipd usbip_bind_driver
+sbin_PROGRAMS := usbip usbipd
 
-usbip_SOURCES := usbip.c usbip_network.c usbip_network.h
-usbipd_SOURCES := usbipd.c usbip_network.c usbip_network.h
-usbip_bind_driver_SOURCES := bind-driver.c utils.c utils.h \
-			     usbip_network.h usbip_network.c
+usbip_SOURCES := usbip.c utils.c usbip_network.c \
+		 usbip_attach.c usbip_detach.c usbip_list.c \
+		 usbip_bind.c usbip_unbind.c
+
+usbipd_SOURCES := usbipd.c usbip_network.c
diff --git a/drivers/staging/usbip/userspace/src/bind-driver.c b/drivers/staging/usbip/userspace/src/bind-driver.c
deleted file mode 100644
index 1396ff9..0000000
--- a/drivers/staging/usbip/userspace/src/bind-driver.c
+++ /dev/null
@@ -1,652 +0,0 @@
-/*
- *
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
- */
-
-#define _GNU_SOURCE
-#include <getopt.h>
-#include <glib.h>
-
-#include "usbip.h"
-#include "utils.h"
-
-static const struct option longopts[] = {
-	{"usbip",	required_argument,	NULL, 'u'},
-	{"other",	required_argument,	NULL, 'o'},
-	{"list",	no_argument,		NULL, 'l'},
-	{"list2",	no_argument,		NULL, 'L'},
-	{"help",	no_argument,		NULL, 'h'},
-#if 0
-	{"allusbip",	no_argument,		NULL, 'a'},
-	{"export-to",   required_argument,	NULL, 'e'},
-	{"unexport",    required_argument,	NULL, 'x'},
-	{"busid",	required_argument,	NULL, 'b'},
-#endif
-
-	{NULL,		0,			NULL,  0}
-};
-
-static void show_help(void)
-{
-	printf("Usage: usbip_bind_driver [OPTION]\n");
-	printf("Change driver binding for USB/IP.\n");
-	printf("  --usbip busid        make a device exportable\n");
-	printf("  --other busid        use a device by a local driver\n");
-	printf("  --list               print usb devices and their drivers\n");
-	printf("  --list2              print usb devices and their drivers in parseable mode\n");
-#if 0
-	printf("  --allusbip           make all devices exportable\n");
-	printf("  --export-to host     export the device to 'host'\n");
-	printf("  --unexport host      unexport a device previously exported to 'host'\n");
-	printf("  --busid busid        the busid used for --export-to\n");
-#endif
-}
-
-static int modify_match_busid(char *busid, int add)
-{
-	int fd;
-	int ret;
-	char buff[BUS_ID_SIZE + 4];
-	char sysfs_mntpath[SYSFS_PATH_MAX];
-	char match_busid_path[SYSFS_PATH_MAX];
-
-	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
-	if (ret < 0) {
-		err("sysfs must be mounted");
-		return -1;
-	}
-
-	snprintf(match_busid_path, sizeof(match_busid_path),
-		 "%s/%s/usb/%s/%s/match_busid", sysfs_mntpath, SYSFS_BUS_NAME,
-		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME);
-
-	/* BUS_IS_SIZE includes NULL termination? */
-	if (strnlen(busid, BUS_ID_SIZE) > BUS_ID_SIZE - 1) {
-		g_warning("too long busid");
-		return -1;
-	}
-
-	fd = open(match_busid_path, O_WRONLY);
-	if (fd < 0)
-		return -1;
-
-	if (add)
-		snprintf(buff, BUS_ID_SIZE + 4, "add %s", busid);
-	else
-		snprintf(buff, BUS_ID_SIZE + 4, "del %s", busid);
-
-	g_debug("write \"%s\" to %s", buff, match_busid_path);
-
-	ret = write(fd, buff, sizeof(buff));
-	if (ret < 0) {
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-static const char unbind_path_format[] = "/sys/bus/usb/devices/%s/driver/unbind";
-
-/* buggy driver may cause dead lock */
-static int unbind_interface_busid(char *busid)
-{
-	char unbind_path[PATH_MAX];
-	int fd;
-	int ret;
-
-	snprintf(unbind_path, sizeof(unbind_path), unbind_path_format, busid);
-
-	fd = open(unbind_path, O_WRONLY);
-	if (fd < 0) {
-		g_warning("opening unbind_path failed: %d", fd);
-		return -1;
-	}
-
-	ret = write(fd, busid, strnlen(busid, BUS_ID_SIZE));
-	if (ret < 0) {
-		g_warning("write to unbind_path failed: %d", ret);
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-static int unbind_interface(char *busid, int configvalue, int interface)
-{
-	char inf_busid[BUS_ID_SIZE];
-	g_debug("unbinding interface");
-
-	snprintf(inf_busid, BUS_ID_SIZE, "%s:%d.%d", busid, configvalue, interface);
-
-	return unbind_interface_busid(inf_busid);
-}
-
-
-static const char bind_path_format[] = "/sys/bus/usb/drivers/%s/bind";
-
-static int bind_interface_busid(char *busid, char *driver)
-{
-	char bind_path[PATH_MAX];
-	int fd;
-	int ret;
-
-	snprintf(bind_path, sizeof(bind_path), bind_path_format, driver);
-
-	fd = open(bind_path, O_WRONLY);
-	if (fd < 0)
-		return -1;
-
-	ret = write(fd, busid, strnlen(busid, BUS_ID_SIZE));
-	if (ret < 0) {
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-static int bind_interface(char *busid, int configvalue, int interface, char *driver)
-{
-	char inf_busid[BUS_ID_SIZE];
-
-	snprintf(inf_busid, BUS_ID_SIZE, "%s:%d.%d", busid, configvalue, interface);
-
-	return bind_interface_busid(inf_busid, driver);
-}
-
-static int unbind(char *busid)
-{
-	int configvalue = 0;
-	int ninterface = 0;
-	int devclass = 0;
-	int i;
-	int failed = 0;
-
-	configvalue = read_bConfigurationValue(busid);
-	ninterface  = read_bNumInterfaces(busid);
-	devclass  = read_bDeviceClass(busid);
-
-	if (configvalue < 0 || ninterface < 0 || devclass < 0) {
-		g_warning("read config and ninf value, removed?");
-		return -1;
-	}
-
-	if (devclass == 0x09) {
-		g_message("skip unbinding of hub");
-		return -1;
-	}
-
-	for (i = 0; i < ninterface; i++) {
-		char driver[PATH_MAX];
-		int ret;
-
-		bzero(&driver, sizeof(driver));
-
-		getdriver(busid, configvalue, i, driver, PATH_MAX-1);
-
-		g_debug(" %s:%d.%d	-> %s ", busid, configvalue, i, driver);
-
-		if (!strncmp("none", driver, PATH_MAX))
-			continue; /* unbound interface */
-
-#if 0
-		if (!strncmp("usbip", driver, PATH_MAX))
-			continue; /* already bound to usbip */
-#endif
-
-		/* unbinding */
-		ret = unbind_interface(busid, configvalue, i);
-		if (ret < 0) {
-			g_warning("unbind driver at %s:%d.%d failed",
-					busid, configvalue, i);
-			failed = 1;
-		}
-	}
-
-	if (failed)
-		return -1;
-	else
-		return 0;
-}
-
-/* call at unbound state */
-static int bind_to_usbip(char *busid)
-{
-	int configvalue = 0;
-	int ninterface = 0;
-	int i;
-	int failed = 0;
-
-	configvalue = read_bConfigurationValue(busid);
-	ninterface  = read_bNumInterfaces(busid);
-
-	if (configvalue < 0 || ninterface < 0) {
-		g_warning("read config and ninf value, removed?");
-		return -1;
-	}
-
-	for (i = 0; i < ninterface; i++) {
-		int ret;
-
-		ret = bind_interface(busid, configvalue, i,
-				     USBIP_HOST_DRV_NAME);
-		if (ret < 0) {
-			g_warning("bind usbip at %s:%d.%d, failed",
-					busid, configvalue, i);
-			failed = 1;
-			/* need to contine binding at other interfaces */
-		}
-	}
-
-	if (failed)
-		return -1;
-	else
-		return 0;
-}
-
-
-static int use_device_by_usbip(char *busid)
-{
-	int ret;
-
-	ret = unbind(busid);
-	if (ret < 0) {
-		g_warning("unbind drivers of %s, failed", busid);
-		return -1;
-	}
-
-	ret = modify_match_busid(busid, 1);
-	if (ret < 0) {
-		g_warning("add %s to match_busid, failed", busid);
-		return -1;
-	}
-
-	ret = bind_to_usbip(busid);
-	if (ret < 0) {
-		g_warning("bind usbip to %s, failed", busid);
-		modify_match_busid(busid, 0);
-		return -1;
-	}
-
-	g_message("bind %s to usbip, complete!", busid);
-
-	return 0;
-}
-
-
-
-static int use_device_by_other(char *busid)
-{
-	int ret;
-	int config;
-
-	/* read and write the same config value to kick probing */
-	config = read_bConfigurationValue(busid);
-	if (config < 0) {
-		g_warning("read bConfigurationValue of %s, failed", busid);
-		return -1;
-	}
-
-	ret = modify_match_busid(busid, 0);
-	if (ret < 0) {
-		g_warning("del %s to match_busid, failed", busid);
-		return -1;
-	}
-
-	ret = write_bConfigurationValue(busid, config);
-	if (ret < 0) {
-		g_warning("read bConfigurationValue of %s, failed", busid);
-		return -1;
-	}
-
-	g_message("bind %s to other drivers than usbip, complete!", busid);
-
-	return 0;
-}
-
-
-#include <sys/types.h>
-#include <regex.h>
-
-#include <errno.h>
-#include <string.h>
-#include <stdio.h>
-
-
-
-static int is_usb_device(char *busid)
-{
-	int ret;
-
-	regex_t regex;
-	regmatch_t pmatch[1];
-
-	ret = regcomp(&regex, "^[0-9]+-[0-9]+(\\.[0-9]+)*$", REG_NOSUB|REG_EXTENDED);
-	if (ret < 0)
-		g_error("regcomp: %s\n", strerror(errno));
-
-	ret = regexec(&regex, busid, 0, pmatch, 0);
-	if (ret)
-		return 0;	/* not matched */
-
-	return 1;
-}
-
-
-#include <dirent.h>
-static int show_devices(void)
-{
-	DIR *dir;
-
-	dir = opendir("/sys/bus/usb/devices/");
-	if (!dir)
-		g_error("opendir: %s", strerror(errno));
-
-	printf("List USB devices\n");
-	for (;;) {
-		struct dirent *dirent;
-		char *busid;
-
-		dirent = readdir(dir);
-		if (!dirent)
-			break;
-
-		busid = dirent->d_name;
-
-		if (is_usb_device(busid)) {
-			char name[100] = {'\0'};
-			char driver[100] =  {'\0'};
-			int conf, ninf = 0;
-			int i;
-
-			conf = read_bConfigurationValue(busid);
-			ninf = read_bNumInterfaces(busid);
-
-			getdevicename(busid, name, sizeof(name));
-
-			printf(" - busid %s (%s)\n", busid, name);
-
-			for (i = 0; i < ninf; i++) {
-				getdriver(busid, conf, i, driver, sizeof(driver));
-				printf("         %s:%d.%d -> %s\n", busid, conf, i, driver);
-			}
-			printf("\n");
-		}
-	}
-
-	closedir(dir);
-
-	return 0;
-}
-
-static int show_devices2(void)
-{
-	DIR *dir;
-
-	dir = opendir("/sys/bus/usb/devices/");
-	if (!dir)
-		g_error("opendir: %s", strerror(errno));
-
-	for (;;) {
-		struct dirent *dirent;
-		char *busid;
-
-		dirent = readdir(dir);
-		if (!dirent)
-			break;
-
-		busid = dirent->d_name;
-
-		if (is_usb_device(busid)) {
-			char name[100] = {'\0'};
-			char driver[100] =  {'\0'};
-			int conf, ninf = 0;
-			int i;
-
-			conf = read_bConfigurationValue(busid);
-			ninf = read_bNumInterfaces(busid);
-
-			getdevicename(busid, name, sizeof(name));
-
-			printf("busid=%s#usbid=%s#", busid, name);
-
-			for (i = 0; i < ninf; i++) {
-				getdriver(busid, conf, i, driver, sizeof(driver));
-				printf("%s:%d.%d=%s#", busid, conf, i, driver);
-			}
-			printf("\n");
-		}
-	}
-
-	closedir(dir);
-
-	return 0;
-}
-
-
-#if 0
-static int export_to(char *host, char *busid) {
-
-	int ret;
-
-	if( host == NULL ) {
-		printf( "no host given\n\n");
-		show_help();
-		return -1;
-	}
-	if( busid == NULL ) {
-		/* XXX print device list and ask for busnumber, if none is
-		 * given */
-		printf( "no busid given, use --busid switch\n\n");
-		show_help();
-		return -1;
-	}
-
-
-	ret = use_device_by_usbip(busid);
-	if( ret != 0 ) {
-		printf( "could not bind driver to usbip\n");
-		return -1;
-	}
-
-	printf( "DEBUG: exporting device '%s' to '%s'\n", busid, host );
-	ret = export_busid_to_host(host, busid); /* usbip_export.[ch] */
-	if( ret != 0 ) {
-		printf( "could not export device to host\n" );
-		printf( "   host: %s, device: %s\n", host, busid );
-		use_device_by_other(busid);
-		return -1;
-	}
-
-	return 0;
-}
-
-static int unexport_from(char *host, char *busid) {
-
-	int ret;
-
-	if (!host || !busid)
-		g_error("no host or no busid\n");
-
-	g_message("unexport_from: host: '%s', busid: '%s'", host, busid);
-
-	ret = unexport_busid_from_host(host, busid); /* usbip_export.[ch] */
-	if( ret != 0 ) {
-		err( "could not unexport device from host\n" );
-		err( "   host: %s, device: %s\n", host, busid );
-	}
-
-	ret = use_device_by_other(busid);
-	if (ret < 0)
-		g_error("could not unbind device from usbip\n");
-
-	return 0;
-}
-
-
-static int allusbip(void)
-{
-	DIR *dir;
-
-	dir = opendir("/sys/bus/usb/devices/");
-	if (!dir)
-		g_error("opendir: %s", strerror(errno));
-
-	for (;;) {
-		struct dirent *dirent;
-		char *busid;
-
-		dirent = readdir(dir);
-		if (!dirent)
-			break;
-
-		busid = dirent->d_name;
-
-		if (!is_usb_device(busid))
-			continue;
-
-		{
-			char name[PATH_MAX];
-			int conf, ninf = 0;
-			int i;
-			int be_local = 0;
-
-			conf = read_bConfigurationValue(busid);
-			ninf = read_bNumInterfaces(busid);
-
-			getdevicename(busid, name, sizeof(name));
-
-			for (i = 0; i < ninf; i++) {
-				char driver[PATH_MAX];
-
-				getdriver(busid, conf, i, driver, sizeof(driver));
-#if 0
-				if (strncmp(driver, "usbhid", 6) == 0 || strncmp(driver, "usb-storage", 11) == 0) {
-					be_local = 1;
-					break;
-				}
-#endif
-			}
-
-			if (be_local == 0)
-				use_device_by_usbip(busid);
-		}
-	}
-
-	closedir(dir);
-
-	return 0;
-}
-#endif
-
-int main(int argc, char **argv)
-{
-	char *busid = NULL;
-	char *remote_host __attribute__((unused)) = NULL;
-
-	enum {
-		cmd_unknown = 0,
-		cmd_use_by_usbip,
-		cmd_use_by_other,
-		cmd_list,
-		cmd_list2,
-		cmd_allusbip,
-		cmd_export_to,
-		cmd_unexport,
-		cmd_help,
-	} cmd = cmd_unknown;
-
-	if (geteuid() != 0)
-		g_warning("running non-root?");
-
-	for (;;) {
-		int c;
-		int index = 0;
-
-		c = getopt_long(argc, argv, "u:o:hlLae:x:b:", longopts, &index);
-		if (c == -1)
-			break;
-
-		switch (c) {
-			case 'u':
-				cmd = cmd_use_by_usbip;
-				busid = optarg;
-				break;
-			case 'o' :
-				cmd = cmd_use_by_other;
-				busid = optarg;
-				break;
-			case 'l' :
-				cmd = cmd_list;
-				break;
-			case 'L' :
-				cmd = cmd_list2;
-				break;
-			case 'a' :
-				cmd = cmd_allusbip;
-				break;
-			case 'b':
-				busid = optarg;
-				break;
-			case 'e':
-				cmd = cmd_export_to;
-				remote_host = optarg;
-				break;
-			case 'x':
-				cmd = cmd_unexport;
-				remote_host = optarg;
-				break;
-			case 'h': /* fallthrough */
-			case '?':
-				cmd = cmd_help;
-				break;
-			default:
-				g_error("getopt");
-		}
-
-		//if (cmd)
-		//	break;
-	}
-
-	switch (cmd) {
-		case cmd_use_by_usbip:
-			use_device_by_usbip(busid);
-			break;
-		case cmd_use_by_other:
-			use_device_by_other(busid);
-			break;
-		case cmd_list:
-			show_devices();
-			break;
-		case cmd_list2:
-			show_devices2();
-			break;
-#if 0
-		case cmd_allusbip:
-			allusbip();
-			break;
-		case cmd_export_to:
-			export_to(remote_host, busid);
-			break;
-		case cmd_unexport:
-			unexport_from(remote_host, busid);
-			break;
-#endif
-		case cmd_help: /* fallthrough */
-		case cmd_unknown:
-			show_help();
-			break;
-		default:
-			g_error("NOT REACHED");
-	}
-
-	return 0;
-}
diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
index c73b355..8940cd0 100644
--- a/drivers/staging/usbip/userspace/src/usbip.c
+++ b/drivers/staging/usbip/userspace/src/usbip.c
@@ -1,724 +1,180 @@
 /*
+ * command structure borrowed from udev
+ * (git://git.kernel.org/pub/scm/linux/hotplug/udev.git)
  *
- * Copyright (C) 2005-2007 Takahiro Hirofuchi
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifdef HAVE_CONFIG_H
-#include "../config.h"
-#endif
-
-#include "usbip.h"
-#include "usbip_network.h"
-#include <ctype.h>
-#include <sys/types.h>
-#include <sys/stat.h>
+#include <stdio.h>
 #include <stdlib.h>
-#include <fcntl.h>
-#include <glib.h>
-
-static const char version[] = PACKAGE_STRING;
-
-
-/* /sys/devices/platform/vhci_hcd/usb6/6-1/6-1:1.1  -> 1 */
-static int get_interface_number(char *path)
-{
-	char *c;
-
-	c = strstr(path, vhci_driver->hc_device->bus_id);
-	if (!c)
-		return -1;	/* hc exist? */
-	c++;
-	/* -> usb6/6-1/6-1:1.1 */
-
-	c = strchr(c, '/');
-	if (!c)
-		return -1;	/* hc exist? */
-	c++;
-	/* -> 6-1/6-1:1.1 */
-
-	c = strchr(c, '/');
-	if (!c)
-		return -1;	/* no interface path */
-	c++;
-	/* -> 6-1:1.1 */
-
-	c = strchr(c, ':');
-	if (!c)
-		return -1;	/* no configuration? */
-	c++;
-	/* -> 1.1 */
-
-	c = strchr(c, '.');
-	if (!c)
-		return -1;	/* no interface? */
-	c++;
-	/* -> 1 */
-
-
-	return atoi(c);
-}
-
-
-static struct sysfs_device *open_usb_interface(struct usb_device *udev, int i)
-{
-	struct sysfs_device *suinf;
-	char busid[SYSFS_BUS_ID_SIZE];
-
-	snprintf(busid, SYSFS_BUS_ID_SIZE, "%s:%d.%d",
-			udev->busid, udev->bConfigurationValue, i);
-
-	suinf = sysfs_open_device("usb", busid);
-	if (!suinf)
-		err("sysfs_open_device %s", busid);
-
-	return suinf;
-}
-
-
-#define MAX_BUFF 100
-static int record_connection(char *host, char *port, char *busid, int rhport)
-{
-	int fd;
-	char path[PATH_MAX+1];
-	char buff[MAX_BUFF+1];
-	int ret;
-
-	mkdir(VHCI_STATE_PATH, 0700);
 
-	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
-
-	fd = open(path, O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU);
-	if (fd < 0)
-		return -1;
-
-	snprintf(buff, MAX_BUFF, "%s %s %s\n",
-			host, port, busid);
-
-	ret = write(fd, buff, strlen(buff));
-	if (ret != (ssize_t) strlen(buff)) {
-		close(fd);
-		return -1;
-	}
-
-	close(fd);
-
-	return 0;
-}
-
-static int read_record(int rhport, char *host, char *port, char *busid)
-{
-	FILE *file;
-	char path[PATH_MAX+1];
-
-	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
-
-	file = fopen(path, "r");
-	if (!file) {
-		err("fopen");
-		return -1;
-	}
+#include <getopt.h>
 
-	if (fscanf(file, "%s %s %s\n", host, port, busid) != 3) {
-		err("fscanf");
-		fclose(file);
-		return -1;
-	}
+#include "usbip_common.h"
+#include "usbip.h"
 
-	fclose(file);
+static int usbip_help(int argc, char *argv[]);
+static int usbip_version(int argc, char *argv[]);
 
-	return 0;
-}
+static const char usbip_version_string[] = PACKAGE_STRING;
 
+static const char usbip_usage_string[] =
+	"usbip [--debug] [version]\n"
+	"             [help] <command> <args>\n";
 
-int usbip_vhci_imported_device_dump(struct usbip_imported_device *idev)
+static void usbip_usage(void)
 {
-	char product_name[100];
-	char host[NI_MAXHOST] = "unknown host";
-	char serv[NI_MAXSERV] = "unknown port";
-	char remote_busid[SYSFS_BUS_ID_SIZE];
-	int ret;
-
-	if (idev->status == VDEV_ST_NULL || idev->status == VDEV_ST_NOTASSIGNED) {
-		info("Port %02d: <%s>", idev->port, usbip_status_string(idev->status));
-		return 0;
-	}
-
-	ret = read_record(idev->port, host, serv, remote_busid);
-	if (ret) {
-		err("read_record");
-		return -1;
-	}
-
-	info("Port %02d: <%s> at %s", idev->port,
-			usbip_status_string(idev->status), usbip_speed_string(idev->udev.speed));
-
-	usbip_names_get_product(product_name, sizeof(product_name),
-			idev->udev.idVendor, idev->udev.idProduct);
-
-	info("       %s",  product_name);
-
-	info("%10s -> usbip://%s:%s/%s  (remote devid %08x (bus/dev %03d/%03d))",
-			idev->udev.busid, host, serv, remote_busid,
-			idev->devid,
-			idev->busnum, idev->devnum);
-
-	for (int i=0; i < idev->udev.bNumInterfaces; i++) {
-		/* show interface information */
-		struct sysfs_device *suinf;
-
-		suinf = open_usb_interface(&idev->udev, i);
-		if (!suinf)
-			continue;
-
-		info("       %6s used by %-17s", suinf->bus_id, suinf->driver_name);
-		sysfs_close_device(suinf);
-
-		/* show class device information */
-		struct usbip_class_device *cdev;
-
-		dlist_for_each_data(idev->cdev_list, cdev,
-				    struct usbip_class_device) {
-			int ifnum = get_interface_number(cdev->dev_path);
-			if (ifnum == i) {
-				info("           %s", cdev->class_path);
-			}
-		}
-	}
-
-	return 0;
+	printf("usage: %s", usbip_usage_string);
 }
 
+struct command {
+	const char *name;
+	int (*fn)(int argc, char *argv[]);
+	const char *help;
+	void (*usage)(void);
+};
 
+static const struct command cmds[] = {
+	{
+		.name  = "help",
+		.fn    = usbip_help,
+		.help  = NULL,
+		.usage = NULL
+	},
+	{
+		.name  = "version",
+		.fn    = usbip_version,
+		.help  = NULL,
+		.usage = NULL
+	},
+	{
+		.name  = "attach",
+		.fn    = usbip_attach,
+		.help  = "Attach a remote USB device",
+		.usage = usbip_attach_usage
+	},
+	{
+		.name  = "detach",
+		.fn    = usbip_detach,
+		.help  = "Detach a remote USB device",
+		.usage = usbip_detach_usage
+	},
+	{
+		.name  = "list",
+		.fn    = usbip_list,
+		.help  = "List exported or local USB devices",
+		.usage = usbip_list_usage
+	},
+	{
+		.name  = "bind",
+		.fn    = usbip_bind,
+		.help  = "Bind device to " USBIP_HOST_DRV_NAME ".ko",
+		.usage = usbip_bind_usage
+	},
+	{
+		.name  = "unbind",
+		.fn    = usbip_unbind,
+		.help  = "Unbind device from " USBIP_HOST_DRV_NAME ".ko",
+		.usage = usbip_unbind_usage
+	},
+	{ NULL, NULL, NULL, NULL }
+};
 
-
-static int query_exported_devices(int sockfd)
+static int usbip_help(int argc, char *argv[])
 {
-	int ret;
-	struct op_devlist_reply rep;
-	uint16_t code = OP_REP_DEVLIST;
-
-	bzero(&rep, sizeof(rep));
-
-	ret = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
-	if (ret < 0) {
-		err("send op_common");
-		return -1;
-	}
-
-	ret = usbip_recv_op_common(sockfd, &code);
-	if (ret < 0) {
-		err("recv op_common");
-		return -1;
-	}
-
-	ret = usbip_recv(sockfd, (void *) &rep, sizeof(rep));
-	if (ret < 0) {
-		err("recv op_devlist");
-		return -1;
-	}
-
-	PACK_OP_DEVLIST_REPLY(0, &rep);
-	dbg("exportable %d devices", rep.ndev);
-
-	for (unsigned int i=0; i < rep.ndev; i++) {
-		char product_name[100];
-		char class_name[100];
-		struct usb_device udev;
+	const struct command *cmd;
+	int i;
+	int ret = 0;
 
-		bzero(&udev, sizeof(udev));
-
-		ret = usbip_recv(sockfd, (void *) &udev, sizeof(udev));
-		if (ret < 0) {
-			err("recv usb_device[%d]", i);
-			return -1;
-		}
-		pack_usb_device(0, &udev);
-
-		usbip_names_get_product(product_name, sizeof(product_name),
-				udev.idVendor, udev.idProduct);
-		usbip_names_get_class(class_name, sizeof(class_name), udev.bDeviceClass,
-				udev.bDeviceSubClass, udev.bDeviceProtocol);
-
-		info("%8s: %s", udev.busid, product_name);
-		info("%8s: %s", " ", udev.path);
-		info("%8s: %s", " ", class_name);
-
-		for (int j=0; j < udev.bNumInterfaces; j++) {
-			struct usb_interface uinf;
-
-			ret = usbip_recv(sockfd, (void *) &uinf, sizeof(uinf));
-			if (ret < 0) {
-				err("recv usb_interface[%d]", j);
-				return -1;
+	if (argc > 1 && argv++) {
+		for (i = 0; cmds[i].name != NULL; i++)
+			if (!strcmp(cmds[i].name, argv[0]) && cmds[i].usage) {
+				cmds[i].usage();
+				goto done;
 			}
-
-			pack_usb_interface(0, &uinf);
-			usbip_names_get_class(class_name, sizeof(class_name), uinf.bInterfaceClass,
-					uinf.bInterfaceSubClass, uinf.bInterfaceProtocol);
-
-			info("%8s: %2d - %s", " ", j, class_name);
-		}
-
-		info(" ");
-	}
-
-	return rep.ndev;
-}
-
-static int import_device(int sockfd, struct usb_device *udev)
-{
-	int ret;
-	int port;
-
-	ret = usbip_vhci_driver_open();
-	if (ret < 0) {
-		err("open vhci_driver");
-		return -1;
-	}
-
-	port = usbip_vhci_get_free_port();
-	if (port < 0) {
-		err("no free port");
-		usbip_vhci_driver_close();
-		return -1;
-	}
-
-	ret = usbip_vhci_attach_device(port, sockfd, udev->busnum,
-			udev->devnum, udev->speed);
-	if (ret < 0) {
-		err("import device");
-		usbip_vhci_driver_close();
-		return -1;
-	}
-
-	usbip_vhci_driver_close();
-
-	return port;
-}
-
-
-static int query_import_device(int sockfd, char *busid)
-{
-	int ret;
-	struct op_import_request request;
-	struct op_import_reply   reply;
-	uint16_t code = OP_REP_IMPORT;
-
-	bzero(&request, sizeof(request));
-	bzero(&reply, sizeof(reply));
-
-
-	/* send a request */
-	ret = usbip_send_op_common(sockfd, OP_REQ_IMPORT, 0);
-	if (ret < 0) {
-		err("send op_common");
-		return -1;
-	}
-
-	strncpy(request.busid, busid, SYSFS_BUS_ID_SIZE-1);
-
-	PACK_OP_IMPORT_REQUEST(0, &request);
-
-	ret = usbip_send(sockfd, (void *) &request, sizeof(request));
-	if (ret < 0) {
-		err("send op_import_request");
-		return -1;
+		ret = -1;
 	}
 
-
-	/* recieve a reply */
-	ret = usbip_recv_op_common(sockfd, &code);
-	if (ret < 0) {
-		err("recv op_common");
-		return -1;
-	}
-
-	ret = usbip_recv(sockfd, (void *) &reply, sizeof(reply));
-	if (ret < 0) {
-		err("recv op_import_reply");
-		return -1;
-	}
-
-	PACK_OP_IMPORT_REPLY(0, &reply);
-
-
-	/* check the reply */
-	if (strncmp(reply.udev.busid, busid, SYSFS_BUS_ID_SIZE)) {
-		err("recv different busid %s", reply.udev.busid);
-		return -1;
-	}
-
-
-	/* import a device */
-	return import_device(sockfd, &reply.udev);
-}
-
-static int attach_device(char *host, char *busid)
-{
-	int sockfd;
-	int ret;
-	int rhport;
-
-	sockfd = tcp_connect(host, USBIP_PORT_STRING);
-	if (sockfd < 0) {
-		err("tcp connect");
-		return -1;
-	}
-
-	rhport = query_import_device(sockfd, busid);
-	if (rhport < 0) {
-		err("query");
-		return -1;
-	}
-
-	close(sockfd);
-
-	ret = record_connection(host, USBIP_PORT_STRING,
-			busid, rhport);
-	if (ret < 0) {
-		err("record connection");
-		return -1;
-	}
-
-	return 0;
-}
-
-static int detach_port(char *port)
-{
-	int ret;
-	uint8_t portnum;
-
-	for (unsigned int i=0; i < strlen(port); i++)
-		if (!isdigit(port[i])) {
-			err("invalid port %s", port);
-			return -1;
-		}
-
-	/* check max port */
-
-	portnum = atoi(port);
-
-	ret = usbip_vhci_driver_open();
-	if (ret < 0) {
-		err("open vhci_driver");
-		return -1;
-	}
-
-	ret = usbip_vhci_detach_device(portnum);
-	if (ret < 0)
-		return -1;
-
-	usbip_vhci_driver_close();
-
+	usbip_usage();
+	printf("\n");
+	for (cmd = cmds; cmd->name != NULL; cmd++)
+		if (cmd->help != NULL)
+			printf("  %-10s %s\n", cmd->name, cmd->help);
+	printf("\n");
+done:
 	return ret;
 }
 
-static int show_exported_devices(char *host)
+static int usbip_version(int argc, char *argv[])
 {
-	int ret;
-	int sockfd;
-
-	sockfd = tcp_connect(host, USBIP_PORT_STRING);
-	if (sockfd < 0) {
-		err("- %s failed", host);
-		return -1;
-	}
-
-	info("- %s", host);
-
-	ret = query_exported_devices(sockfd);
-	if (ret < 0) {
-		err("query");
-		return -1;
-	}
+	(void) argc;
+	(void) argv;
 
-	close(sockfd);
+	printf("%s\n", usbip_version_string);
 	return 0;
 }
 
-static int attach_exported_devices(char *host, int sockfd)
+static int run_command(const struct command *cmd, int argc, char *argv[])
 {
-	int ret;
-	struct op_devlist_reply rep;
-	uint16_t code = OP_REP_DEVLIST;
-
-	bzero(&rep, sizeof(rep));
-
-	ret = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
-	if(ret < 0) {
-		err("send op_common");
-		return -1;
-	}
-
-	ret = usbip_recv_op_common(sockfd, &code);
-	if(ret < 0) {
-		err("recv op_common");
-		return -1;
-	}
-
-	ret = usbip_recv(sockfd, (void *) &rep, sizeof(rep));
-	if(ret < 0) {
-		err("recv op_devlist");
-		return -1;
-	}
-
-	PACK_OP_DEVLIST_REPLY(0, &rep);
-	dbg("exportable %d devices", rep.ndev);
-
-	for(unsigned int i=0; i < rep.ndev; i++) {
-		char product_name[100];
-		char class_name[100];
-		struct usb_device udev;
-
-		bzero(&udev, sizeof(udev));
-
-		ret = usbip_recv(sockfd, (void *) &udev, sizeof(udev));
-		if(ret < 0) {
-			err("recv usb_device[%d]", i);
-			return -1;
-		}
-		pack_usb_device(0, &udev);
-
-		usbip_names_get_product(product_name, sizeof(product_name),
-				udev.idVendor, udev.idProduct);
-		usbip_names_get_class(class_name, sizeof(class_name), udev.bDeviceClass,
-				udev.bDeviceSubClass, udev.bDeviceProtocol);
-
-		dbg("Attaching usb port %s from host %s on usbip, with deviceid: %s", udev.busid, host, product_name);
-
-		for (int j=0; j < udev.bNumInterfaces; j++) {
-			struct usb_interface uinf;
-
-			ret = usbip_recv(sockfd, (void *) &uinf, sizeof(uinf));
-			if (ret < 0) {
-				err("recv usb_interface[%d]", j);
-				return -1;
-			}
-
-			pack_usb_interface(0, &uinf);
-			usbip_names_get_class(class_name, sizeof(class_name), uinf.bInterfaceClass,
-					uinf.bInterfaceSubClass, uinf.bInterfaceProtocol);
-
-			dbg("interface %2d - %s", j, class_name);
-		}
-
-		attach_device(host, udev.busid);
-	}
-
-	return rep.ndev;
-}
-
-static int attach_devices_all(char *host)
-{
-	int ret;
-	int sockfd;
-
-	sockfd = tcp_connect(host, USBIP_PORT_STRING);
-	if(sockfd < 0) {
-		err("- %s failed", host);
-		return -1;
-	}
-
-	info("- %s", host);
-
-	ret = attach_exported_devices(host, sockfd);
-	if(ret < 0) {
-		err("query");
-		return -1;
-	}
-
-	close(sockfd);
-	return 0;
-}
-
-
-const char help_message[] = "\
-Usage: usbip [options]				\n\
-	-a, --attach [host] [bus_id]		\n\
-		Attach a remote USB device.	\n\
-						\n\
-	-x, --attachall [host]		\n\
-		Attach all remote USB devices on the specific host.	\n\
-						\n\
-	-d, --detach [ports]			\n\
-		Detach an imported USB device.	\n\
-						\n\
-	-l, --list [hosts]			\n\
-		List exported USB devices.	\n\
-						\n\
-	-p, --port				\n\
-		List virtual USB port status. 	\n\
-						\n\
-	-D, --debug				\n\
-		Print debugging information.	\n\
-						\n\
-	-v, --version				\n\
-		Show version.			\n\
-						\n\
-	-h, --help 				\n\
-		Print this help.		\n";
-
-static void show_help(void)
-{
-	printf("%s", help_message);
-}
-
-static int show_port_status(void)
-{
-	int ret;
-	struct usbip_imported_device *idev;
-
-	ret = usbip_vhci_driver_open();
-	if (ret < 0)
-		return ret;
-
-	for (int i = 0; i < vhci_driver->nports; i++) {
-		idev = &vhci_driver->idev[i];
-
-		if (usbip_vhci_imported_device_dump(idev) < 0)
-			ret = -1;
-	}
-
-	usbip_vhci_driver_close();
-
-	return ret;
+	dbg("running command: `%s'\n", cmd->name);
+	return cmd->fn(argc, argv);
 }
 
-#define _GNU_SOURCE
-#include <getopt.h>
-static const struct option longopts[] = {
-	{"attach",	no_argument,	NULL, 'a'},
-	{"attachall",	no_argument,	NULL, 'x'},
-	{"detach",	no_argument,	NULL, 'd'},
-	{"port",	no_argument,	NULL, 'p'},
-	{"list",	no_argument,	NULL, 'l'},
-	{"version",	no_argument,	NULL, 'v'},
-	{"help",	no_argument,	NULL, 'h'},
-	{"debug",	no_argument,	NULL, 'D'},
-	{"syslog",	no_argument,	NULL, 'S'},
-	{NULL,		0,		NULL,  0}
-};
-
 int main(int argc, char *argv[])
 {
-	int ret;
-
-	enum {
-		cmd_attach = 1,
-		cmd_attachall,
-		cmd_detach,
-		cmd_port,
-		cmd_list,
-		cmd_help,
-		cmd_version
-	} cmd = 0;
-
-	usbip_use_stderr = 1;
-
-	if (geteuid() != 0)
-		g_warning("running non-root?");
-
-	ret = usbip_names_init(USBIDS_FILE);
-	if (ret)
-		notice("failed to open %s", USBIDS_FILE);
+	static const struct option opts[] = {
+		{ "debug", no_argument, NULL, 'd' },
+		{ NULL, 0, NULL, 0 }
+	};
+	char *cmd;
+	int opt;
+	int i, rc = -1;
 
+	opterr = 0;
 	for (;;) {
-		int c;
-		int index = 0;
-
-		c = getopt_long(argc, argv, "adplvhDSx", longopts, &index);
+		opt = getopt_long(argc, argv, "+d", opts, NULL);
 
-		if (c == -1)
+		if (opt == -1)
 			break;
 
-		switch(c) {
-			case 'a':
-				if (!cmd)
-					cmd = cmd_attach;
-				else
-					cmd = cmd_help;
-				break;
-			case 'd':
-				if (!cmd)
-					cmd = cmd_detach;
-				else
-					cmd = cmd_help;
-				break;
-			case 'p':
-				if (!cmd)
-					cmd = cmd_port;
-				else cmd = cmd_help;
-				break;
-			case 'l':
-				if (!cmd)
-					cmd = cmd_list;
-				else
-					cmd = cmd_help;
-				break;
-			case 'v':
-				if (!cmd)
-					cmd = cmd_version;
-				else
-					cmd = cmd_help;
-				break;
-			case 'x':
-				if(!cmd)
-					cmd = cmd_attachall;
-				else
-					cmd = cmd_help;
-				break;
-			case 'h':
-				cmd = cmd_help;
-				break;
-			case 'D':
-				usbip_use_debug = 1;
-				break;
-			case 'S':
-				usbip_use_syslog = 1;
-				break;
-			case '?':
-				break;
-
-			default:
-				err("getopt");
-		}
-	}
-
-	ret = 0;
-	switch(cmd) {
-		case cmd_attach:
-			if (optind == argc - 2)
-				ret = attach_device(argv[optind], argv[optind+1]);
-			else
-				show_help();
-			break;
-		case cmd_detach:
-			while (optind < argc)
-				ret = detach_port(argv[optind++]);
-			break;
-		case cmd_port:
-			ret = show_port_status();
-			break;
-		case cmd_list:
-			while (optind < argc)
-				ret = show_exported_devices(argv[optind++]);
-			break;
-		case cmd_attachall:
-			while(optind < argc)
-				ret = attach_devices_all(argv[optind++]);
-			break;
-		case cmd_version:
-			printf("%s\n", version);
-			break;
-		case cmd_help:
-			show_help();
+		switch (opt) {
+		case 'd':
+			usbip_use_debug = 1;
+			usbip_use_stderr = 1;
 			break;
 		default:
-			show_help();
+			goto err_out;
+		}
 	}
 
+	cmd = argv[optind];
+	if (cmd) {
+		for (i = 0; cmds[i].name != NULL; i++)
+			if (!strcmp(cmds[i].name, cmd)) {
+				argc -= optind;
+				argv += optind;
+				optind = 0;
+				rc = run_command(&cmds[i], argc, argv);
+				goto out;
+			}
+	}
 
-	usbip_names_free();
-
-	exit((ret == 0) ? EXIT_SUCCESS : EXIT_FAILURE);
+err_out:
+	usbip_usage();
+out:
+	return (rc > -1 ? EXIT_SUCCESS : EXIT_FAILURE);
 }
diff --git a/drivers/staging/usbip/userspace/src/usbip.h b/drivers/staging/usbip/userspace/src/usbip.h
new file mode 100644
index 0000000..14d4a47
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbip.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __USBIP_H
+#define __USBIP_H
+
+#ifdef HAVE_CONFIG_H
+#include "../config.h"
+#endif
+
+/* usbip commands */
+int usbip_attach(int argc, char *argv[]);
+int usbip_detach(int argc, char *argv[]);
+int usbip_list(int argc, char *argv[]);
+int usbip_bind(int argc, char *argv[]);
+int usbip_unbind(int argc, char *argv[]);
+
+void usbip_attach_usage(void);
+void usbip_detach_usage(void);
+void usbip_list_usage(void);
+void usbip_bind_usage(void);
+void usbip_unbind_usage(void);
+
+#endif /* __USBIP_H */
diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
new file mode 100644
index 0000000..671d23c
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbip_attach.c
@@ -0,0 +1,228 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <sys/stat.h>
+#include <sysfs/libsysfs.h>
+
+#include <limits.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+
+#include <fcntl.h>
+#include <getopt.h>
+#include <unistd.h>
+
+#include "vhci_driver.h"
+#include "usbip_common.h"
+#include "usbip_network.h"
+#include "usbip.h"
+
+static const char usbip_attach_usage_string[] =
+	"usbip attach <args>\n"
+	"    -h, --host=<host>      The machine with exported USB devices\n"
+	"    -b, --busid=<busid>    Busid of the device on <host>\n";
+
+void usbip_attach_usage(void)
+{
+	printf("usage: %s", usbip_attach_usage_string);
+}
+
+#define MAX_BUFF 100
+static int record_connection(char *host, char *port, char *busid, int rhport)
+{
+	int fd;
+	char path[PATH_MAX+1];
+	char buff[MAX_BUFF+1];
+	int ret;
+
+	mkdir(VHCI_STATE_PATH, 0700);
+
+	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", rhport);
+
+	fd = open(path, O_WRONLY|O_CREAT|O_TRUNC, S_IRWXU);
+	if (fd < 0)
+		return -1;
+
+	snprintf(buff, MAX_BUFF, "%s %s %s\n",
+			host, port, busid);
+
+	ret = write(fd, buff, strlen(buff));
+	if (ret != (ssize_t) strlen(buff)) {
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
+
+static int import_device(int sockfd, struct usb_device *udev)
+{
+	int rc;
+	int port;
+
+	rc = usbip_vhci_driver_open();
+	if (rc < 0) {
+		err("open vhci_driver");
+		return -1;
+	}
+
+	port = usbip_vhci_get_free_port();
+	if (port < 0) {
+		err("no free port");
+		usbip_vhci_driver_close();
+		return -1;
+	}
+
+	rc = usbip_vhci_attach_device(port, sockfd, udev->busnum,
+				      udev->devnum, udev->speed);
+	if (rc < 0) {
+		err("import device");
+		usbip_vhci_driver_close();
+		return -1;
+	}
+
+	usbip_vhci_driver_close();
+
+	return port;
+}
+
+static int query_import_device(int sockfd, char *busid)
+{
+	int rc;
+	struct op_import_request request;
+	struct op_import_reply   reply;
+	uint16_t code = OP_REP_IMPORT;
+
+	memset(&request, 0, sizeof(request));
+	memset(&reply, 0, sizeof(reply));
+
+	/* send a request */
+	rc = usbip_send_op_common(sockfd, OP_REQ_IMPORT, 0);
+	if (rc < 0) {
+		err("send op_common");
+		return -1;
+	}
+
+	strncpy(request.busid, busid, SYSFS_BUS_ID_SIZE-1);
+
+	PACK_OP_IMPORT_REQUEST(0, &request);
+
+	rc = usbip_send(sockfd, (void *) &request, sizeof(request));
+	if (rc < 0) {
+		err("send op_import_request");
+		return -1;
+	}
+
+	/* recieve a reply */
+	rc = usbip_recv_op_common(sockfd, &code);
+	if (rc < 0) {
+		err("recv op_common");
+		return -1;
+	}
+
+	rc = usbip_recv(sockfd, (void *) &reply, sizeof(reply));
+	if (rc < 0) {
+		err("recv op_import_reply");
+		return -1;
+	}
+
+	PACK_OP_IMPORT_REPLY(0, &reply);
+
+	/* check the reply */
+	if (strncmp(reply.udev.busid, busid, SYSFS_BUS_ID_SIZE)) {
+		err("recv different busid %s", reply.udev.busid);
+		return -1;
+	}
+
+	/* import a device */
+	return import_device(sockfd, &reply.udev);
+}
+
+static int attach_device(char *host, char *busid)
+{
+	int sockfd;
+	int rc;
+	int rhport;
+
+	sockfd = usbip_net_tcp_connect(host, USBIP_PORT_STRING);
+	if (sockfd < 0) {
+		err("tcp connect");
+		return -1;
+	}
+
+	rhport = query_import_device(sockfd, busid);
+	if (rhport < 0) {
+		err("query");
+		return -1;
+	}
+
+	close(sockfd);
+
+	rc = record_connection(host, USBIP_PORT_STRING, busid, rhport);
+	if (rc < 0) {
+		err("record connection");
+		return -1;
+	}
+
+	return 0;
+}
+
+int usbip_attach(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "host", required_argument, NULL, 'h' },
+		{ "busid", required_argument, NULL, 'b' },
+		{ NULL, 0, NULL, 0 }
+	};
+	char *host = NULL;
+	char *busid = NULL;
+	int opt;
+	int ret = -1;
+
+	for (;;) {
+		opt = getopt_long(argc, argv, "h:b:", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'h':
+			host = optarg;
+			break;
+		case 'b':
+			busid = optarg;
+			break;
+		default:
+			goto err_out;
+		}
+	}
+
+	if (!host || !busid)
+		goto err_out;
+
+	ret = attach_device(host, busid);
+	goto out;
+
+err_out:
+	usbip_attach_usage();
+out:
+	return ret;
+}
diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/drivers/staging/usbip/userspace/src/usbip_bind.c
new file mode 100644
index 0000000..26cfbad
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbip_bind.c
@@ -0,0 +1,261 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <sysfs/libsysfs.h>
+
+#include <stdio.h>
+#include <string.h>
+
+#include <getopt.h>
+#include <fcntl.h>
+#include <unistd.h>
+
+#include "usbip_common.h"
+#include "utils.h"
+#include "usbip.h"
+
+static const char usbip_bind_usage_string[] =
+	"usbip bind <args>\n"
+	"    -b, --busid=<busid>    Bind " USBIP_HOST_DRV_NAME ".ko to device "
+	"on <busid>\n";
+
+void usbip_bind_usage(void)
+{
+	printf("usage: %s", usbip_bind_usage_string);
+}
+
+static const char unbind_path_format[] = "/sys/bus/usb/devices/%s/driver/unbind";
+
+/* buggy driver may cause dead lock */
+static int unbind_interface_busid(char *busid)
+{
+	char unbind_path[SYSFS_PATH_MAX];
+	int fd;
+	int ret;
+
+	snprintf(unbind_path, sizeof(unbind_path), unbind_path_format, busid);
+
+	fd = open(unbind_path, O_WRONLY);
+	if (fd < 0) {
+		dbg("opening unbind_path failed: %d", fd);
+		return -1;
+	}
+
+	ret = write(fd, busid, strnlen(busid, BUS_ID_SIZE));
+	if (ret < 0) {
+		dbg("write to unbind_path failed: %d", ret);
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
+
+static int unbind_interface(char *busid, int configvalue, int interface)
+{
+	char inf_busid[BUS_ID_SIZE];
+	dbg("unbinding interface");
+
+	snprintf(inf_busid, BUS_ID_SIZE, "%s:%d.%d", busid, configvalue, interface);
+
+	return unbind_interface_busid(inf_busid);
+}
+
+static int unbind(char *busid)
+{
+	int configvalue = 0;
+	int ninterface = 0;
+	int devclass = 0;
+	int i;
+	int failed = 0;
+
+	configvalue = read_bConfigurationValue(busid);
+	ninterface  = read_bNumInterfaces(busid);
+	devclass  = read_bDeviceClass(busid);
+
+	if (configvalue < 0 || ninterface < 0 || devclass < 0) {
+		dbg("read config and ninf value, removed?");
+		return -1;
+	}
+
+	if (devclass == 0x09) {
+		dbg("skip unbinding of hub");
+		return -1;
+	}
+
+	for (i = 0; i < ninterface; i++) {
+		char driver[PATH_MAX];
+		int ret;
+
+		memset(&driver, 0, sizeof(driver));
+
+		getdriver(busid, configvalue, i, driver, PATH_MAX-1);
+
+		dbg(" %s:%d.%d	-> %s ", busid, configvalue, i, driver);
+
+		if (!strncmp("none", driver, PATH_MAX))
+			continue; /* unbound interface */
+
+#if 0
+		if (!strncmp("usbip", driver, PATH_MAX))
+			continue; /* already bound to usbip */
+#endif
+
+		/* unbinding */
+		ret = unbind_interface(busid, configvalue, i);
+		if (ret < 0) {
+			dbg("unbind driver at %s:%d.%d failed",
+			    busid, configvalue, i);
+			failed = 1;
+		}
+	}
+
+	if (failed)
+		return -1;
+	else
+		return 0;
+}
+
+static const char bind_path_format[] = "/sys/bus/usb/drivers/%s/bind";
+
+static int bind_interface_busid(char *busid, char *driver)
+{
+	char bind_path[PATH_MAX];
+	int fd;
+	int ret;
+
+	snprintf(bind_path, sizeof(bind_path), bind_path_format, driver);
+
+	fd = open(bind_path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+
+	ret = write(fd, busid, strnlen(busid, BUS_ID_SIZE));
+	if (ret < 0) {
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
+
+static int bind_interface(char *busid, int configvalue, int interface, char *driver)
+{
+	char inf_busid[BUS_ID_SIZE];
+
+	snprintf(inf_busid, BUS_ID_SIZE, "%s:%d.%d", busid, configvalue, interface);
+
+	return bind_interface_busid(inf_busid, driver);
+}
+
+/* call at unbound state */
+static int bind_to_usbip(char *busid)
+{
+	int configvalue = 0;
+	int ninterface = 0;
+	int i;
+	int failed = 0;
+
+	configvalue = read_bConfigurationValue(busid);
+	ninterface  = read_bNumInterfaces(busid);
+
+	if (configvalue < 0 || ninterface < 0) {
+		dbg("read config and ninf value, removed?");
+		return -1;
+	}
+
+	for (i = 0; i < ninterface; i++) {
+		int ret;
+
+		ret = bind_interface(busid, configvalue, i,
+				     USBIP_HOST_DRV_NAME);
+		if (ret < 0) {
+			dbg("bind usbip at %s:%d.%d, failed",
+			    busid, configvalue, i);
+			failed = 1;
+			/* need to contine binding at other interfaces */
+		}
+	}
+
+	if (failed)
+		return -1;
+	else
+		return 0;
+}
+
+static int use_device_by_usbip(char *busid)
+{
+	int ret;
+
+	ret = unbind(busid);
+	if (ret < 0) {
+		dbg("unbind drivers of %s, failed", busid);
+		return -1;
+	}
+
+	ret = modify_match_busid(busid, 1);
+	if (ret < 0) {
+		dbg("add %s to match_busid, failed", busid);
+		return -1;
+	}
+
+	ret = bind_to_usbip(busid);
+	if (ret < 0) {
+		dbg("bind usbip to %s, failed", busid);
+		modify_match_busid(busid, 0);
+		return -1;
+	}
+
+	dbg("bind %s complete!", busid);
+
+	return 0;
+}
+
+int usbip_bind(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "busid", required_argument, NULL, 'b' },
+		{ NULL, 0, NULL, 0 }
+	};
+	int opt;
+	int ret = -1;
+
+	for (;;) {
+		opt = getopt_long(argc, argv, "b:", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'b':
+			ret = use_device_by_usbip(optarg);
+			goto out;
+		default:
+			goto err_out;
+		}
+	}
+
+err_out:
+	usbip_bind_usage();
+out:
+	return ret;
+}
diff --git a/drivers/staging/usbip/userspace/src/usbip_detach.c b/drivers/staging/usbip/userspace/src/usbip_detach.c
new file mode 100644
index 0000000..89bf3c1
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbip_detach.c
@@ -0,0 +1,103 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <sysfs/libsysfs.h>
+
+#include <ctype.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <getopt.h>
+#include <unistd.h>
+
+#include "vhci_driver.h"
+#include "usbip_common.h"
+#include "usbip_network.h"
+#include "usbip.h"
+
+static const char usbip_detach_usage_string[] =
+	"usbip detach <args>\n"
+	"    -p, --port=<port>    " USBIP_VHCI_DRV_NAME
+	" port the device is on\n";
+
+void usbip_detach_usage(void)
+{
+	printf("usage: %s", usbip_detach_usage_string);
+}
+
+static int detach_port(char *port)
+{
+	int ret;
+	uint8_t portnum;
+
+	for (unsigned int i=0; i < strlen(port); i++)
+		if (!isdigit(port[i])) {
+			err("invalid port %s", port);
+			return -1;
+		}
+
+	/* check max port */
+
+	portnum = atoi(port);
+
+	ret = usbip_vhci_driver_open();
+	if (ret < 0) {
+		err("open vhci_driver");
+		return -1;
+	}
+
+	ret = usbip_vhci_detach_device(portnum);
+	if (ret < 0)
+		return -1;
+
+	usbip_vhci_driver_close();
+
+	return ret;
+}
+
+int usbip_detach(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "port", required_argument, NULL, 'p' },
+		{ NULL, 0, NULL, 0 }
+	};
+	int opt;
+	int ret = -1;
+
+	for (;;) {
+		opt = getopt_long(argc, argv, "p:", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'p':
+			ret = detach_port(optarg);
+			goto out;
+		default:
+			goto err_out;
+		}
+	}
+
+err_out:
+	usbip_detach_usage();
+out:
+	return ret;
+}
diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
new file mode 100644
index 0000000..72236ae
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -0,0 +1,306 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <sys/types.h>
+#include <sysfs/libsysfs.h>
+
+#include <errno.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+
+#include <dirent.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <regex.h>
+#include <unistd.h>
+
+#include "usbip_common.h"
+#include "usbip_network.h"
+#include "utils.h"
+#include "usbip.h"
+
+static const char usbip_list_usage_string[] =
+	"usbip list [-p|--parsable] <args>\n"
+	"    -p, --parsable         Parsable list format\n"
+	"    -r, --remote=<host>    List the exported USB devices on <host>\n"
+	"    -l, --local            List the local USB devices\n";
+
+void usbip_list_usage(void)
+{
+	printf("usage: %s", usbip_list_usage_string);
+}
+
+static int query_exported_devices(int sockfd)
+{
+	int ret;
+	struct op_devlist_reply rep;
+	uint16_t code = OP_REP_DEVLIST;
+
+	memset(&rep, 0, sizeof(rep));
+
+	ret = usbip_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
+	if (ret < 0) {
+		err("send op_common");
+		return -1;
+	}
+
+	ret = usbip_recv_op_common(sockfd, &code);
+	if (ret < 0) {
+		err("recv op_common");
+		return -1;
+	}
+
+	ret = usbip_recv(sockfd, (void *) &rep, sizeof(rep));
+	if (ret < 0) {
+		err("recv op_devlist");
+		return -1;
+	}
+
+	PACK_OP_DEVLIST_REPLY(0, &rep);
+	dbg("exportable %d devices", rep.ndev);
+
+	for (unsigned int i=0; i < rep.ndev; i++) {
+		char product_name[100];
+		char class_name[100];
+		struct usb_device udev;
+
+		memset(&udev, 0, sizeof(udev));
+
+		ret = usbip_recv(sockfd, (void *) &udev, sizeof(udev));
+		if (ret < 0) {
+			err("recv usb_device[%d]", i);
+			return -1;
+		}
+		pack_usb_device(0, &udev);
+
+		usbip_names_get_product(product_name, sizeof(product_name),
+					udev.idVendor, udev.idProduct);
+		usbip_names_get_class(class_name, sizeof(class_name),
+				      udev.bDeviceClass, udev.bDeviceSubClass,
+				      udev.bDeviceProtocol);
+
+		printf("%8s: %s\n", udev.busid, product_name);
+		printf("%8s: %s\n", " ", udev.path);
+		printf("%8s: %s\n", " ", class_name);
+
+		for (int j=0; j < udev.bNumInterfaces; j++) {
+			struct usb_interface uinf;
+
+			ret = usbip_recv(sockfd, (void *) &uinf, sizeof(uinf));
+			if (ret < 0) {
+				err("recv usb_interface[%d]", j);
+				return -1;
+			}
+
+			pack_usb_interface(0, &uinf);
+			usbip_names_get_class(class_name, sizeof(class_name),
+					      uinf.bInterfaceClass,
+					      uinf.bInterfaceSubClass,
+					      uinf.bInterfaceProtocol);
+
+			printf("%8s: %2d - %s\n", " ", j, class_name);
+		}
+
+		printf("\n");
+	}
+
+	return rep.ndev;
+}
+
+static int show_exported_devices(char *host)
+{
+	int ret;
+	int sockfd;
+
+	sockfd = usbip_net_tcp_connect(host, USBIP_PORT_STRING);
+	if (sockfd < 0) {
+		err("unable to connect to %s port %s: %s\n", host,
+		    USBIP_PORT_STRING, gai_strerror(sockfd));
+		return -1;
+	}
+	dbg("connected to %s port %s\n", host, USBIP_PORT_STRING);
+
+	printf("- %s\n", host);
+
+	ret = query_exported_devices(sockfd);
+	if (ret < 0) {
+		err("query");
+		return -1;
+	}
+
+	close(sockfd);
+	return 0;
+}
+
+static int is_usb_device(char *busid)
+{
+	int ret;
+
+	regex_t regex;
+	regmatch_t pmatch[1];
+
+	ret = regcomp(&regex, "^[0-9]+-[0-9]+(\\.[0-9]+)*$", REG_NOSUB|REG_EXTENDED);
+	if (ret < 0)
+		err("regcomp: %s\n", strerror(errno));
+
+	ret = regexec(&regex, busid, 0, pmatch, 0);
+	if (ret)
+		return 0;	/* not matched */
+
+	return 1;
+}
+
+static int show_devices(void)
+{
+	DIR *dir;
+
+	dir = opendir("/sys/bus/usb/devices/");
+	if (!dir)
+		err("opendir: %s", strerror(errno));
+
+	printf("List USB devices\n");
+	for (;;) {
+		struct dirent *dirent;
+		char *busid;
+
+		dirent = readdir(dir);
+		if (!dirent)
+			break;
+
+		busid = dirent->d_name;
+
+		if (is_usb_device(busid)) {
+			char name[100] = {'\0'};
+			char driver[100] =  {'\0'};
+			int conf, ninf = 0;
+			int i;
+
+			conf = read_bConfigurationValue(busid);
+			ninf = read_bNumInterfaces(busid);
+
+			getdevicename(busid, name, sizeof(name));
+
+			printf(" - busid %s (%s)\n", busid, name);
+
+			for (i = 0; i < ninf; i++) {
+				getdriver(busid, conf, i, driver,
+					  sizeof(driver));
+				printf("         %s:%d.%d -> %s\n", busid, conf,
+				       i, driver);
+			}
+			printf("\n");
+		}
+	}
+
+	closedir(dir);
+
+	return 0;
+}
+
+static int show_devices2(void)
+{
+	DIR *dir;
+
+	dir = opendir("/sys/bus/usb/devices/");
+	if (!dir)
+		err("opendir: %s", strerror(errno));
+
+	for (;;) {
+		struct dirent *dirent;
+		char *busid;
+
+		dirent = readdir(dir);
+		if (!dirent)
+			break;
+
+		busid = dirent->d_name;
+
+		if (is_usb_device(busid)) {
+			char name[100] = {'\0'};
+			char driver[100] =  {'\0'};
+			int conf, ninf = 0;
+			int i;
+
+			conf = read_bConfigurationValue(busid);
+			ninf = read_bNumInterfaces(busid);
+
+			getdevicename(busid, name, sizeof(name));
+
+			printf("busid=%s#usbid=%s#", busid, name);
+
+			for (i = 0; i < ninf; i++) {
+				getdriver(busid, conf, i, driver, sizeof(driver));
+				printf("%s:%d.%d=%s#", busid, conf, i, driver);
+			}
+			printf("\n");
+		}
+	}
+
+	closedir(dir);
+
+	return 0;
+}
+
+int usbip_list(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "parsable", no_argument, NULL, 'p' },
+		{ "remote", required_argument, NULL, 'r' },
+		{ "local", no_argument, NULL, 'l' },
+		{ NULL, 0, NULL, 0 }
+	};
+	bool is_parsable = false;
+	int opt;
+	int ret = -1;
+
+	if (usbip_names_init(USBIDS_FILE))
+		err("failed to open %s\n", USBIDS_FILE);
+
+	for (;;) {
+		opt = getopt_long(argc, argv, "pr:l", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'p':
+			is_parsable = true;
+			break;
+		case 'r':
+			ret = show_exported_devices(optarg);
+			goto out;
+		case 'l':
+			if (is_parsable)
+				ret = show_devices2();
+			else
+				ret = show_devices();
+			goto out;
+		default:
+			goto err_out;
+		}
+	}
+
+err_out:
+	usbip_list_usage();
+out:
+	usbip_names_free();
+
+	return ret;
+}
diff --git a/drivers/staging/usbip/userspace/src/usbip_unbind.c b/drivers/staging/usbip/userspace/src/usbip_unbind.c
new file mode 100644
index 0000000..9978d38
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/usbip_unbind.c
@@ -0,0 +1,95 @@
+/*
+ * Copyright (C) 2011 matt mooney <mfm@muteddisk.com>
+ *               2005-2007 Takahiro Hirofuchi
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <stdio.h>
+
+#include <getopt.h>
+#include <unistd.h>
+
+#include "usbip_common.h"
+#include "utils.h"
+#include "usbip.h"
+
+static const char usbip_unbind_usage_string[] =
+	"usbip unbind <args>\n"
+	"    -b, --busid=<busid>    Unbind " USBIP_HOST_DRV_NAME ".ko from "
+	"device on <busid>\n";
+
+void usbip_unbind_usage(void)
+{
+	printf("usage: %s", usbip_unbind_usage_string);
+}
+
+static int use_device_by_other(char *busid)
+{
+	int rc;
+	int config;
+
+	/* read and write the same config value to kick probing */
+	config = read_bConfigurationValue(busid);
+	if (config < 0) {
+		dbg("read bConfigurationValue of %s, failed", busid);
+		return -1;
+	}
+
+	rc = modify_match_busid(busid, 0);
+	if (rc < 0) {
+		dbg("del %s to match_busid, failed", busid);
+		return -1;
+	}
+
+	rc = write_bConfigurationValue(busid, config);
+	if (rc < 0) {
+		dbg("read bConfigurationValue of %s, failed", busid);
+		return -1;
+	}
+
+	info("bind %s to other drivers than usbip, complete!", busid);
+
+	return 0;
+}
+
+int usbip_unbind(int argc, char *argv[])
+{
+	static const struct option opts[] = {
+		{ "busid", required_argument, NULL, 'b' },
+		{ NULL, 0, NULL, 0 }
+	};
+	int opt;
+	int ret = -1;
+
+	for (;;) {
+		opt = getopt_long(argc, argv, "b:", opts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'b':
+			ret = use_device_by_other(optarg);
+			goto out;
+		default:
+			goto err_out;
+		}
+	}
+
+err_out:
+	usbip_unbind_usage();
+out:
+	return ret;
+}
diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
index 8f44108..6f91557 100644
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -3,8 +3,61 @@
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
 
+#include <sysfs/libsysfs.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "usbip_common.h"
 #include "utils.h"
 
+int modify_match_busid(char *busid, int add)
+{
+	int fd;
+	int ret;
+	char buff[BUS_ID_SIZE + 4];
+	char sysfs_mntpath[SYSFS_PATH_MAX];
+	char match_busid_path[SYSFS_PATH_MAX];
+
+	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
+	if (ret < 0) {
+		err("sysfs must be mounted");
+		return -1;
+	}
+
+	snprintf(match_busid_path, sizeof(match_busid_path),
+		 "%s/%s/usb/%s/%s/match_busid", sysfs_mntpath, SYSFS_BUS_NAME,
+		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME);
+
+	/* BUS_IS_SIZE includes NULL termination? */
+	if (strnlen(busid, BUS_ID_SIZE) > BUS_ID_SIZE - 1) {
+		dbg("busid is too long");
+		return -1;
+	}
+
+	fd = open(match_busid_path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+
+	if (add)
+		snprintf(buff, BUS_ID_SIZE + 4, "add %s", busid);
+	else
+		snprintf(buff, BUS_ID_SIZE + 4, "del %s", busid);
+
+	dbg("write \"%s\" to %s", buff, match_busid_path);
+
+	ret = write(fd, buff, sizeof(buff));
+	if (ret < 0) {
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
+
 int read_integer(char *path)
 {
 	char buff[100];
@@ -36,7 +89,7 @@ int read_string(char *path, char *string, size_t len)
 	int ret = 0;
 	char  *p;
 
-	bzero(string, len);
+	memset(string, 0, len);
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
@@ -122,15 +175,16 @@ int getdriver(char *busid, int conf, int infnum, char *driver, size_t len)
 {
 	char path[PATH_MAX];
 	char linkto[PATH_MAX];
+	const char none[] = "none";
 	int ret;
 
 	snprintf(path, PATH_MAX, "/sys/bus/usb/devices/%s:%d.%d/driver", busid, conf, infnum);
 
 	/* readlink does not add NULL */
-	bzero(linkto, sizeof(linkto));
+	memset(linkto, 0, sizeof(linkto));
 	ret = readlink(path, linkto, sizeof(linkto)-1);
 	if (ret < 0) {
-		strncpy(driver, "none", len);
+		strncpy(driver, none, len);
 		return -1;
 	} else {
 		strncpy(driver, basename(linkto), len);
diff --git a/drivers/staging/usbip/userspace/src/utils.h b/drivers/staging/usbip/userspace/src/utils.h
index 6c29ae9..423716d 100644
--- a/drivers/staging/usbip/userspace/src/utils.h
+++ b/drivers/staging/usbip/userspace/src/utils.h
@@ -25,6 +25,7 @@
 /* Be sync to kernel header */
 #define BUS_ID_SIZE 20
 
+int modify_match_busid(char *busid, int add);
 int read_string(char *path, char *, size_t len);
 int read_integer(char *path);
 int getdevicename(char *busid, char *name, size_t len);
-- 
1.7.5.1

