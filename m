Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1FVIil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 04:38:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57466 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab1FVIih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 04:38:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6384"; a="99096595"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH/RESEND 3/3] usb unitests framework: libusb patches
Date: Wed, 22 Jun 2011 11:34:10 +0300
Message-Id: <1308731651-7397-4-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1308731651-7397-1-git-send-email-tlinder@codeaurora.org>
References: <1308731651-7397-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch includes patches that should be applied to the latest libusb
tree. They have not been released to the libusb tree formally just yet.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 .../0001-Add-support-to-USB3-descriptors.patch     |  420 ++++++++++++++++++++
 ...2-Add-support-for-libusb_get_device_speed.patch |  172 ++++++++
 .../libusb_patches/0003-Add-UAS-defines.patch      |   56 +++
 3 files changed, 648 insertions(+), 0 deletions(-)
 create mode 100644 tools/usb/unittests/libusb_patches/0001-Add-support-to-USB3-descriptors.patch
 create mode 100644 tools/usb/unittests/libusb_patches/0002-Add-support-for-libusb_get_device_speed.patch
 create mode 100644 tools/usb/unittests/libusb_patches/0003-Add-UAS-defines.patch

diff --git a/tools/usb/unittests/libusb_patches/0001-Add-support-to-USB3-descriptors.patch b/tools/usb/unittests/libusb_patches/0001-Add-support-to-USB3-descriptors.patch
new file mode 100644
index 0000000..8c8aaf0
--- /dev/null
+++ b/tools/usb/unittests/libusb_patches/0001-Add-support-to-USB3-descriptors.patch
@@ -0,0 +1,420 @@
+From fcc8bb8ea6a326a2c84e92b29004e8e3896925b7 Mon Sep 17 00:00:00 2001
+From: Maya Erez <merez@codeaurora.org>
+Date: Sun, 13 Mar 2011 22:01:07 +0200
+Subject: [PATCH 1/4] Add support to USB3 descriptors
+
+Add definitions for Endpoint Companion and BOS descriptors.
+Add APIs for parsing the Endpoint Companion and BOS descriptors.
+
+Signed-off-by: Maya Erez <merez@codeaurora.org>
+
+---
+ libusb/descriptor.c |  160 +++++++++++++++++++++++++++++++++++++++++++++++---
+ libusb/libusb.h     |  115 ++++++++++++++++++++++++++++++++++++-
+ 2 files changed, 264 insertions(+), 11 deletions(-)
+
+diff --git a/libusb/descriptor.c b/libusb/descriptor.c
+index 11480e8..0ce6975 100644
+--- a/libusb/descriptor.c
++++ b/libusb/descriptor.c
+@@ -22,6 +22,7 @@
+ #include <stdint.h>
+ #include <stdlib.h>
+ #include <string.h>
++#include <stdio.h>
+ 
+ #include "libusbi.h"
+ 
+@@ -45,6 +46,7 @@ int usbi_parse_descriptor(unsigned char *source, const char *descriptor,
+ 	unsigned char *sp = source, *dp = dest;
+ 	uint16_t w;
+ 	const char *cp;
++	uint32_t d;
+ 
+ 	for (cp = descriptor; *cp; cp++) {
+ 		switch (*cp) {
+@@ -63,6 +65,21 @@ int usbi_parse_descriptor(unsigned char *source, const char *descriptor,
+ 				sp += 2;
+ 				dp += 2;
+ 				break;
++			/* 32-bit word, convert from little endian to CPU */
++			case 'd':
++			/* Align to word boundary */
++				dp += ((unsigned long)dp & 1);
++
++				if (host_endian) {
++					memcpy(dp, sp, 4);
++				} else {
++					d = (sp[3] << 24) | (sp[2] << 16) |
++						(sp[1] << 8) | sp[0];
++					*((uint32_t *)dp) = d;
++				}
++				sp += 4;
++				dp += 4;
++				break;
+ 		}
+ 	}
+ 
+@@ -75,6 +92,39 @@ static void clear_endpoint(struct libusb_endpoint_descriptor *endpoint)
+ 		free((unsigned char *) endpoint->extra);
+ }
+ 
++static int parse_endpoint_comp(struct libusb_context *ctx,
++			       struct libusb_ss_ep_comp_descriptor *ep_comp,
++			       unsigned char *buffer, int size)
++{
++	struct usb_descriptor_header header;
++	int parsed = 0;
++
++	usbi_parse_descriptor(buffer, "bb", &header, 0);
++
++	/* Everything should be fine being passed into here, but we sanity */
++	/*  check JIC */
++	if (header.bLength > size) {
++		usbi_err(ctx, "ran out of descriptors parsing");
++		return LIBUSB_ERROR_NO_MEM;
++	}
++
++	if (header.bDescriptorType != LIBUSB_DT_SS_ENDPOINT_COMP) {
++		usbi_err(ctx, "unexpected descriptor %x (expected %x)",
++			header.bDescriptorType, LIBUSB_DT_SS_ENDPOINT_COMP);
++		return parsed;
++	}
++
++	if (header.bLength >= LIBUSB_DT_SS_EP_COMP_SIZE)
++		usbi_parse_descriptor(buffer, "bbbbw", ep_comp, 0);
++
++	buffer += header.bLength;
++	size -= header.bLength;
++	parsed += header.bLength;
++
++	return parsed;
++}
++
++
+ static int parse_endpoint(struct libusb_context *ctx,
+ 	struct libusb_endpoint_descriptor *endpoint, unsigned char *buffer,
+ 	int size, int host_endian)
+@@ -83,7 +133,7 @@ static int parse_endpoint(struct libusb_context *ctx,
+ 	unsigned char *extra;
+ 	unsigned char *begin;
+ 	int parsed = 0;
+-	int len;
++	int len, retval;
+ 
+ 	usbi_parse_descriptor(buffer, "bb", &header, 0);
+ 
+@@ -109,6 +159,28 @@ static int parse_endpoint(struct libusb_context *ctx,
+ 	size -= header.bLength;
+ 	parsed += header.bLength;
+ 
++	/* check if we have a Comapnion descriptor */
++	usbi_parse_descriptor(buffer, "bb", &header, 0);
++	if (header.bDescriptorType == LIBUSB_DT_SS_ENDPOINT_COMP) {
++		endpoint->ep_comp = (struct libusb_ss_ep_comp_descriptor *)
++			malloc(sizeof(struct libusb_ss_ep_comp_descriptor));
++		if (!endpoint->ep_comp) {
++			usbi_err(ctx, "couldn't allocate memory for ep_comp");
++			return LIBUSB_ERROR_NO_MEM;
++		}
++
++		memset(endpoint->ep_comp, 0,
++		       sizeof(struct libusb_ss_ep_comp_descriptor));
++		retval = parse_endpoint_comp(ctx, endpoint->ep_comp,
++					     buffer, size);
++		if (retval < 0)
++			return retval;
++
++		buffer += retval;
++		parsed += retval;
++		size -= retval;
++	}
++
+ 	/* Skip over the rest of the Class Specific or Vendor Specific */
+ 	/*  descriptors */
+ 	begin = buffer;
+@@ -122,9 +194,10 @@ static int parse_endpoint(struct libusb_context *ctx,
+ 
+ 		/* If we find another "proper" descriptor then we're done  */
+ 		if ((header.bDescriptorType == LIBUSB_DT_ENDPOINT) ||
+-				(header.bDescriptorType == LIBUSB_DT_INTERFACE) ||
+-				(header.bDescriptorType == LIBUSB_DT_CONFIG) ||
+-				(header.bDescriptorType == LIBUSB_DT_DEVICE))
++		    (header.bDescriptorType == LIBUSB_DT_INTERFACE) ||
++		    (header.bDescriptorType == LIBUSB_DT_CONFIG) ||
++		    (header.bDescriptorType == LIBUSB_DT_DEVICE) ||
++		    (header.bDescriptorType == LIBUSB_DT_SS_ENDPOINT_COMP))
+ 			break;
+ 
+ 		usbi_dbg("skipping descriptor %x", header.bDescriptorType);
+@@ -233,9 +306,11 @@ static int parse_interface(libusb_context *ctx,
+ 
+ 			/* If we find another "proper" descriptor then we're done */
+ 			if ((header.bDescriptorType == LIBUSB_DT_INTERFACE) ||
+-					(header.bDescriptorType == LIBUSB_DT_ENDPOINT) ||
+-					(header.bDescriptorType == LIBUSB_DT_CONFIG) ||
+-					(header.bDescriptorType == LIBUSB_DT_DEVICE))
++			    (header.bDescriptorType == LIBUSB_DT_ENDPOINT) ||
++			    (header.bDescriptorType == LIBUSB_DT_CONFIG) ||
++			    (header.bDescriptorType == LIBUSB_DT_DEVICE) ||
++			    (header.bDescriptorType ==
++			     LIBUSB_DT_SS_ENDPOINT_COMP))
+ 				break;
+ 
+ 			buffer += header.bLength;
+@@ -379,9 +454,11 @@ static int parse_configuration(struct libusb_context *ctx,
+ 
+ 			/* If we find another "proper" descriptor then we're done */
+ 			if ((header.bDescriptorType == LIBUSB_DT_ENDPOINT) ||
+-					(header.bDescriptorType == LIBUSB_DT_INTERFACE) ||
+-					(header.bDescriptorType == LIBUSB_DT_CONFIG) ||
+-					(header.bDescriptorType == LIBUSB_DT_DEVICE))
++			    (header.bDescriptorType == LIBUSB_DT_INTERFACE) ||
++			    (header.bDescriptorType == LIBUSB_DT_CONFIG) ||
++			    (header.bDescriptorType == LIBUSB_DT_DEVICE) ||
++			    (header.bDescriptorType ==
++			     LIBUSB_DT_SS_ENDPOINT_COMP))
+ 				break;
+ 
+ 			usbi_dbg("skipping descriptor 0x%x\n", header.bDescriptorType);
+@@ -726,3 +803,66 @@ int API_EXPORTED libusb_get_string_descriptor_ascii(libusb_device_handle *dev,
+ 	return di;
+ }
+ 
++
++/** \ingroup desc
++ * Get the USB bos descriptor for a given device.
++ *
++ * \param dev the device
++ * \param bos output bos descriptor
++ * \returns 0 on success
++ */
++API_EXPORTED int libusb_parse_bos_desc(struct libusb_device *dev,
++					struct libusb_bos_descriptor *bos,
++					unsigned char *buf)
++{
++	int i;
++	int desc_begin = 0;
++
++	usbi_parse_descriptor(buf, "bbwb", bos, 0);
++	desc_begin = LIBUSB_DT_BOS_SIZE;
++
++	/* Get the device capability descriptors */
++	for (i = 0; i < bos->bNumDeviceCaps; ++i) {
++		if (buf[desc_begin+2] == LIBUSB_USB_CAP_TYPE_EXT) {
++			if (!bos->usb_ext_cap) {
++				bos->usb_ext_cap =
++				(struct libusb_usb_ext_cap_descriptor *)
++				malloc(sizeof(struct
++					      libusb_usb_ext_cap_descriptor));
++				usbi_parse_descriptor(buf+desc_begin, "bbbd",
++						      bos->usb_ext_cap, 0);
++			} else
++				usbi_warn(dev->ctx,
++					  "usb_ext_cap was already allocated");
++
++			/* move to the next device capability descriptor */
++			desc_begin += LIBUSB_DT_USB_CAP_TYPE_EXT_SIZE;
++		} else if (buf[desc_begin+2] == LIBUSB_SS_USB_CAP_TYPE) {
++			if (!bos->ss_usb_cap) {
++				bos->ss_usb_cap =
++				(struct libusb_ss_usb_cap_descriptor *)
++				malloc(sizeof(struct
++					      libusb_ss_usb_cap_descriptor));
++
++				usbi_parse_descriptor(buf+desc_begin,
++						      "bbbbwbbw",
++						      bos->ss_usb_cap, 0);
++			} else
++				usbi_warn(dev->ctx,
++					  "ss_usb_cap was already allocated");
++
++			/* move to the next device capability descriptor */
++			desc_begin += LIBUSB_DT_SS_USB_CAP_TYPE_SIZE;
++		} else {
++			usbi_info(dev->ctx,
++				  "wireless/container_id capability "
++				  "descriptor");
++
++			/* move to the next device capability descriptor */
++			desc_begin += buf[desc_begin];
++		}
++	}
++	return 0;
++}
++
++
+diff --git a/libusb/libusb.h b/libusb/libusb.h
+index 8dc3362..9f2243a 100644
+--- a/libusb/libusb.h
++++ b/libusb/libusb.h
+@@ -191,7 +191,16 @@ enum libusb_descriptor_type {
+ 	LIBUSB_DT_PHYSICAL = 0x23,
+ 
+ 	/** Hub descriptor */
+-	LIBUSB_DT_HUB = 0x29
++	LIBUSB_DT_HUB = 0x29,
++
++	/** BOS descriptor */
++	LIBUSB_DT_BOS = 0x0f,
++
++	/** Device Capability descriptor */
++	LIBUSB_DT_DEVICE_CAPABILITY = 0x10,
++
++	/** SuperSpeed Endpoint Companion descriptor */
++	LIBUSB_DT_SS_ENDPOINT_COMP = 0x30
+ };
+ 
+ /* Descriptor sizes per descriptor type */
+@@ -201,6 +210,13 @@ enum libusb_descriptor_type {
+ #define LIBUSB_DT_ENDPOINT_SIZE		7
+ #define LIBUSB_DT_ENDPOINT_AUDIO_SIZE	9	/* Audio extension */
+ #define LIBUSB_DT_HUB_NONVAR_SIZE		7
++#define LIBUSB_DT_SS_EP_COMP_SIZE		6
++#define LIBUSB_DT_BOS_SIZE			5
++#define LIBUSB_DT_USB_CAP_TYPE_EXT_SIZE	7
++#define LIBUSB_DT_SS_USB_CAP_TYPE_SIZE	10
++#define LIBUSB_DT_BOS_MAX_SIZE		((LIBUSB_DT_BOS_SIZE) + \
++					(LIBUSB_DT_USB_CAP_TYPE_EXT_SIZE) + \
++					(LIBUSB_DT_SS_USB_CAP_TYPE_SIZE))
+ 
+ #define LIBUSB_ENDPOINT_ADDRESS_MASK	0x0f    /* in bEndpointAddress */
+ #define LIBUSB_ENDPOINT_DIR_MASK		0x80
+@@ -407,6 +423,33 @@ struct libusb_device_descriptor {
+ 	uint8_t  bNumConfigurations;
+ };
+ 
++/* USB_DT_SS_ENDPOINT_COMP: SuperSpeed Endpoint Companion descriptor */
++struct libusb_ss_ep_comp_descriptor {
++
++	/** Size of this descriptor (in bytes) */
++	u_int8_t  bLength;
++
++	/** Descriptor type. Will have value
++	 * \ref libusb_descriptor_type::LIBUSB_DT_SS_ENDPOINT_COMP in
++	 * this context. */
++	u_int8_t  bDescriptorType;
++
++
++	/** The maximum number of packets the endpoint can send or
++	 *  recieve as part of a burst. */
++	u_int8_t  bMaxBurst;
++
++	/** In bulk EP:	bits 4:0 represents the	maximum	number of
++	 *  streams the	EP supports. In	isochronous EP:	bits 1:0
++	 *  represents the Mult	- a zero based value that determines
++	 *  the	maximum	number of packets within a service interval  */
++	u_int8_t  bmAttributes;
++
++	/** The	total number of bytes this EP will transfer every
++	 *  service interval. valid only for periodic EPs. */
++	u_int16_t wBytesPerInterval;
++};
++
+ /** \ingroup desc
+  * A structure representing the standard USB endpoint descriptor. This
+  * descriptor is documented in section 9.6.3 of the USB 2.0 specification.
+@@ -449,6 +492,9 @@ struct libusb_endpoint_descriptor {
+ 	/** For audio devices only: the address if the synch endpoint */
+ 	uint8_t  bSynchAddress;
+ 
++	/** The	EP companion descriptor */
++	struct libusb_ss_ep_comp_descriptor *ep_comp;
++
+ 	/** Extra descriptors. If libusb encounters unknown endpoint descriptors,
+ 	 * it will store them here, should you wish to parse them. */
+ 	const unsigned char *extra;
+@@ -457,6 +503,7 @@ struct libusb_endpoint_descriptor {
+ 	int extra_length;
+ };
+ 
++
+ /** \ingroup desc
+  * A structure representing the standard USB interface descriptor. This
+  * descriptor is documented in section 9.6.5 of the USB 2.0 specification.
+@@ -565,6 +612,60 @@ struct libusb_config_descriptor {
+ 	int extra_length;
+ };
+ 
++/** \ingroup desc
++ * A structure representing the BOS descriptor. This
++ * descriptor is documented in section 9.6.2 of the USB 3.0
++ * specification. All multiple-byte fields are represented in
++ * host-endian format.
++ */
++struct libusb_bos_descriptor {
++	u_int8_t  bLength;
++	u_int8_t  bDescriptorType;
++	u_int16_t wTotalLength;
++	u_int8_t  bNumDeviceCaps;
++
++	struct libusb_usb_ext_cap_descriptor *usb_ext_cap;
++	struct libusb_ss_usb_cap_descriptor *ss_usb_cap;
++};
++
++
++struct libusb_dev_cap_header {
++	u_int8_t  bLength;
++	u_int8_t  bDescriptorType;
++	u_int8_t  bDevCapabilityType;
++};
++
++
++#define	LIBUSB_USB_CAP_TYPE_EXT		2
++
++struct libusb_usb_ext_cap_descriptor {		/* Link Power Management */
++	u_int8_t  bLength;
++	u_int8_t  bDescriptorType;
++	u_int8_t  bDevCapabilityType;
++	u_int32_t  bmAttributes;
++#define LIBUSB_LPM_SUPPORT		(1 << 1)	/* supports LPM */
++};
++
++
++#define	LIBUSB_SS_USB_CAP_TYPE		3
++
++struct libusb_ss_usb_cap_descriptor {		/* Link Power Management */
++	u_int8_t  bLength;
++	u_int8_t  bDescriptorType;
++	u_int8_t  bDevCapabilityType;
++	u_int8_t  bmAttributes;
++#define LIBUSB_LPM_SUPPORT		(1 << 1)	/* supports LPM */
++	u_int16_t wSpeedSupported;
++#define LIBUSB_LOW_SPEED_OPERATION	(1)	/* Low speed operation */
++#define LIBUSB_FULL_SPEED_OPERATION	(1 << 1)/* Full speed operation */
++#define LIBUSB_HIGH_SPEED_OPERATION	(1 << 2)/* High speed operation */
++#define LIBUSB_5GBPS_OPERATION		(1 << 3)/* Operation at 5Gbps */
++	u_int8_t  bFunctionalitySupport;
++	u_int8_t  bU1devExitLat;
++	u_int16_t bU2DevExitLat;
++};
++
++
+ /** \ingroup asyncio
+  * Setup packet for control transfers. */
+ struct libusb_control_setup {
+@@ -1315,6 +1416,18 @@ void LIBUSB_CALL libusb_set_pollfd_notifiers(libusb_context *ctx,
+ 	libusb_pollfd_added_cb added_cb, libusb_pollfd_removed_cb removed_cb,
+ 	void *user_data);
+ 
++
++/** \ingroup desc
++ * Get the USB bos descriptor for a given device.
++ *
++ * \param dev the device
++ * \param bos output bos descriptor
++ * \returns 0 on success
++ */
++int libusb_parse_bos_desc(struct libusb_device *dev,
++			   struct libusb_bos_descriptor *bos,
++			   unsigned char *buf);
++
+ #ifdef __cplusplus
+ }
+ #endif
+-- 
+1.7.3.3
+
+--
+Sent by an employee of the Qualcomm Innovation Center, Inc.
+The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
\ No newline at end of file
diff --git a/tools/usb/unittests/libusb_patches/0002-Add-support-for-libusb_get_device_speed.patch b/tools/usb/unittests/libusb_patches/0002-Add-support-for-libusb_get_device_speed.patch
new file mode 100644
index 0000000..ca612bb
--- /dev/null
+++ b/tools/usb/unittests/libusb_patches/0002-Add-support-for-libusb_get_device_speed.patch
@@ -0,0 +1,172 @@
+From c5df8c1d47367d214c40bf932244f8b44f1f4caf Mon Sep 17 00:00:00 2001
+From: Tatyana Brokhman <tlinder@codeaurora.org>
+Date: Mon, 14 Mar 2011 16:18:26 +0200
+Subject: [PATCH 2/4] Add support for libusb_get_device_speed()
+
+This patch adds a new libusb function used to determine the connected USB
+device speed.
+
+Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
+
+---
+ libusb/core.c           |   17 ++++++++++++++
+ libusb/libusb.h         |   11 +++++++++
+ libusb/libusbi.h        |    7 ++++++
+ libusb/os/linux_usbfs.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++
+ 4 files changed, 91 insertions(+), 0 deletions(-)
+
+diff --git a/libusb/core.c b/libusb/core.c
+index 64445ab..6d49fb3 100644
+--- a/libusb/core.c
++++ b/libusb/core.c
+@@ -745,6 +745,23 @@ int API_EXPORTED libusb_get_max_packet_size(libusb_device *dev,
+ }
+ 
+ /** \ingroup dev
++ * Convenience function to retrieve the speed of the connected
++ * device
++ *
++ * \param dev a device
++ * \returns the connected device speed
++ * \returns LIBUSB_ERROR_NOT_SUPPORTED if get_device_speed() cb
++ *  	    was not defined for the usbi_backend
++ * \returns LIBUSB_ERROR_OTHER on other failure
++ */
++API_EXPORTED int libusb_get_dev_speed(libusb_device *dev)
++{
++	if (usbi_backend->get_device_speed)
++		return usbi_backend->get_device_speed(dev);
++	return LIBUSB_ERROR_NOT_SUPPORTED;
++}
++
++/** \ingroup dev
+  * Calculate the maximum packet size which a specific endpoint is capable is
+  * sending or receiving in the duration of 1 microframe
+  *
+diff --git a/libusb/libusb.h b/libusb/libusb.h
+index 9f2243a..346f85f 100644
+--- a/libusb/libusb.h
++++ b/libusb/libusb.h
+@@ -89,6 +89,16 @@
+ extern "C" {
+ #endif
+ 
++/* USB 2.0 defines three speeds, here's how Linux identifies them */
++enum libusb_device_speed {
++	LIBUSB_SPEED_UNKNOWN = 0,			/* enumerating */
++	LIBUSB_SPEED_LOW, LIBUSB_SPEED_FULL,		/* usb 1.1 */
++	LIBUSB_SPEED_HIGH,				/* usb 2.0 */
++	LIBUSB_SPEED_VARIABLE,			/* wireless (usb 2.5) */
++	LIBUSB_SPEED_SUPER,			/* usb 3.0 */
++};
++
++
+ /** \def libusb_cpu_to_le16
+  * \ingroup misc
+  * Convert a 16-bit value from host-endian to little-endian format. On
+@@ -965,6 +975,7 @@ int LIBUSB_CALL libusb_get_max_packet_size(libusb_device *dev,
+ 	unsigned char endpoint);
+ int LIBUSB_CALL libusb_get_max_iso_packet_size(libusb_device *dev,
+ 	unsigned char endpoint);
++int LIBUSB_CALL libusb_get_dev_speed(libusb_device *dev);
+ 
+ int LIBUSB_CALL libusb_open(libusb_device *dev, libusb_device_handle **handle);
+ void LIBUSB_CALL libusb_close(libusb_device_handle *dev_handle);
+diff --git a/libusb/libusbi.h b/libusb/libusbi.h
+index 974b108..87cd770 100644
+--- a/libusb/libusbi.h
++++ b/libusb/libusbi.h
+@@ -591,6 +591,13 @@ struct usbi_os_backend {
+ 		uint8_t config_index, unsigned char *buffer, size_t len,
+ 		int *host_endian);
+ 
++
++	/* Get the connected device speed
++	 *
++	 * Return 0 on success or a LIBUSB_ERROR_OTHER code on failure.
++	 */
++	int (*get_device_speed)(struct libusb_device *device);
++
+ 	/* Get the bConfigurationValue for the active configuration for a device.
+ 	 * Optional. This should only be implemented if you can retrieve it from
+ 	 * cache (don't generate I/O).
+diff --git a/libusb/os/linux_usbfs.c b/libusb/os/linux_usbfs.c
+index 867893c..430d773 100644
+--- a/libusb/os/linux_usbfs.c
++++ b/libusb/os/linux_usbfs.c
+@@ -333,6 +333,61 @@ static int sysfs_get_device_descriptor(struct libusb_device *dev,
+ 	return 0;
+ }
+ 
++static int sysfs_get_device_speed(struct libusb_device *dev)
++{
++	int fd;
++	ssize_t r;
++	unsigned char buffer[32];
++	char *tmp;
++
++	fd = __open_sysfs_attr(dev, "speed");
++	if (fd < 0)
++		return fd;
++
++	r = read(fd, &buffer, 32);
++	close(fd);
++	if (r < 0) {
++		usbi_err(DEVICE_CTX(dev), "read failed, ret=%d errno=%d", fd, errno);
++		return LIBUSB_ERROR_OTHER;
++	}
++
++	/*
++	 * The read string from sysfs terminates with a "new line" char
++	 * (A in ascii code) which we want to trim
++	 */
++	tmp = strchr(buffer,  10);
++	*tmp=0;
++
++	/* 
++	 * The spped is dumped in sysfs.c as follows:
++	 * case USB_SPEED_LOW: speed = "1.5";
++	 * case USB_SPEED_UNKNOWN/USB_SPEED_FULL: speed = "12";
++	 * case USB_SPEED_HIGH/USB_SPEED_WIRELESS:	speed = "480";
++	 * case USB_SPEED_SUPER: speed = "5000";
++	 */
++
++	if (!strcmp("1.5",buffer))
++		return LIBUSB_SPEED_LOW;
++
++	if (!strcmp("12",buffer))
++		return LIBUSB_SPEED_FULL;
++
++	if (!strcmp("480",buffer))
++		return LIBUSB_SPEED_HIGH;
++
++	if (!strcmp("5000",buffer))
++		return LIBUSB_SPEED_SUPER;
++
++	return LIBUSB_SPEED_UNKNOWN;
++}
++
++static int op_get_dev_speed(struct libusb_device *dev)
++{
++	if (sysfs_has_descriptors)
++		return sysfs_get_device_speed(dev);
++	return LIBUSB_SPEED_UNKNOWN;
++}
++
+ static int op_get_device_descriptor(struct libusb_device *dev,
+ 	unsigned char *buffer, int *host_endian)
+ {
+@@ -2210,6 +2265,7 @@ const struct usbi_os_backend linux_usbfs_backend = {
+ 	.get_device_descriptor = op_get_device_descriptor,
+ 	.get_active_config_descriptor = op_get_active_config_descriptor,
+ 	.get_config_descriptor = op_get_config_descriptor,
++	.get_device_speed = op_get_dev_speed,
+ 
+ 	.open = op_open,
+ 	.close = op_close,
+-- 
+1.7.3.3
+
+--
+Sent by an employee of the Qualcomm Innovation Center, Inc.
+The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
\ No newline at end of file
diff --git a/tools/usb/unittests/libusb_patches/0003-Add-UAS-defines.patch b/tools/usb/unittests/libusb_patches/0003-Add-UAS-defines.patch
new file mode 100644
index 0000000..a1abfd2
--- /dev/null
+++ b/tools/usb/unittests/libusb_patches/0003-Add-UAS-defines.patch
@@ -0,0 +1,56 @@
+From 45864135c176df8bf03bff05733acd8c8ec0579e Mon Sep 17 00:00:00 2001
+From: Tatyana Brokhman <tlinder@codeaurora.org>
+Date: Tue, 14 Jun 2011 13:25:37 +0300
+Subject: [PATCH 3/4] Add UAS defines
+
+This patch adds necessary definitions as defined by the UAS spec
+
+Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
+
+---
+ libusb/libusb.h |   19 ++++++++++++++++++-
+ 1 files changed, 18 insertions(+), 1 deletions(-)
+
+diff --git a/libusb/libusb.h b/libusb/libusb.h
+index 346f85f..c5e2fbb 100644
+--- a/libusb/libusb.h
++++ b/libusb/libusb.h
+@@ -210,7 +210,12 @@ enum libusb_descriptor_type {
+ 	LIBUSB_DT_DEVICE_CAPABILITY = 0x10,
+ 
+ 	/** SuperSpeed Endpoint Companion descriptor */
+-	LIBUSB_DT_SS_ENDPOINT_COMP = 0x30
++	LIBUSB_DT_SS_ENDPOINT_COMP = 0x30,
++
++	/** UASP descriptors:   */
++	/** Pipe usage descriptor   */
++	LIBUSB_DT_PIPE_USAGE = 0x24
++
+ };
+ 
+ /* Descriptor sizes per descriptor type */
+@@ -675,6 +680,18 @@ struct libusb_ss_usb_cap_descriptor {		/* Link Power Management */
+ 	u_int16_t bU2DevExitLat;
+ };
+ 
++/* LIBUSB_DT_PIPE_USAGE descriptor */
++struct libusb_uasp_pipe_usage_desc {
++    u_int8_t  bLength;
++    u_int8_t  bDescriptorType;
++#define PIPE_ID_UNDEF       0x00
++#define PIPE_ID_CMD         0x01
++#define PIPE_ID_STS         0x02
++#define PIPE_ID_DATA_IN     0x03
++#define PIPE_ID_DATA_OUT    0x04
++    u_int8_t  bPipeID;
++    u_int8_t  reserved;
++};
+ 
+ /** \ingroup asyncio
+  * Setup packet for control transfers. */
+-- 
+1.7.3.3
+
+--
+Sent by an employee of the Qualcomm Innovation Center, Inc.
+The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
\ No newline at end of file
-- 
1.7.0.4

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
