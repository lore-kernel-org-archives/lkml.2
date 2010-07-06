Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0GFHxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:53:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44216 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094Ab0GFHxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:53:35 -0400
Date: Tue, 6 Jul 2010 17:53:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: linux-next: manual merge of the usb tree with the v4l-dvb tree
Message-Id: <20100706175332.952fec90.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/media/video/uvc/uvcvideo.h include/linux/usb/video.h between
commits c3810b43416155d040a200e7a7301f379c8ae8a0 ("V4L/DVB: uvcvideo:
Support menu controls in the control mapping API") and
da1df555fcbb98a9d2054304ea54545d9ff523cf ("V4L/DVB: uvcvideo: Define
control information bits using macros") from the v4l-dvb tree and commit
bb03b5daa9ab053adcce09e939d4115a873abf39 ("USB: uvc: Move constants and
structures definitions to linux/usb/video.h") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary.  Though
moving the USB patch into the v4l-dvb tree may fix the conflicts as
well ...

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/media/video/uvc/uvcvideo.h
index 47b20e7,65ec0d1..0000000
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@@ -196,24 -179,10 +196,6 @@@ struct uvc_device
  /* TODO: Put the most frequently accessed fields at the beginning of
   * structures to maximize cache efficiency.
   */
- struct uvc_streaming_control {
- 	__u16 bmHint;
- 	__u8  bFormatIndex;
- 	__u8  bFrameIndex;
- 	__u32 dwFrameInterval;
- 	__u16 wKeyFrameRate;
- 	__u16 wPFrameRate;
- 	__u16 wCompQuality;
- 	__u16 wCompWindowSize;
- 	__u16 wDelay;
- 	__u32 dwMaxVideoFrameSize;
- 	__u32 dwMaxPayloadTransferSize;
- 	__u32 dwClockFrequency;
- 	__u8  bmFramingInfo;
- 	__u8  bPreferedVersion;
- 	__u8  bMinVersion;
- 	__u8  bMaxVersion;
- };
 -struct uvc_menu_info {
 -	__u32 value;
 -	__u8 name[32];
 -};
  
  struct uvc_control_info {
  	struct list_head list;
diff --cc include/linux/usb/video.h
index 2d5b7fc,429c91a..0000000
--- a/include/linux/usb/video.h
+++ b/include/linux/usb/video.h
@@@ -160,12 -160,402 +160,409 @@@
  #define UVC_STATUS_TYPE_CONTROL				1
  #define UVC_STATUS_TYPE_STREAMING			2
  
+ /* 2.4.3.3. Payload Header Information */
+ #define UVC_STREAM_EOH					(1 << 7)
+ #define UVC_STREAM_ERR					(1 << 6)
+ #define UVC_STREAM_STI					(1 << 5)
+ #define UVC_STREAM_RES					(1 << 4)
+ #define UVC_STREAM_SCR					(1 << 3)
+ #define UVC_STREAM_PTS					(1 << 2)
+ #define UVC_STREAM_EOF					(1 << 1)
+ #define UVC_STREAM_FID					(1 << 0)
+ 
+ /* ------------------------------------------------------------------------
+  * UVC structures
+  */
+ 
+ /* All UVC descriptors have these 3 fields at the beginning */
+ struct uvc_descriptor_header {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ } __attribute__((packed));
+ 
+ /* 3.7.2. Video Control Interface Header Descriptor */
+ struct uvc_header_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u16 bcdUVC;
+ 	__u16 wTotalLength;
+ 	__u32 dwClockFrequency;
+ 	__u8  bInCollection;
+ 	__u8  baInterfaceNr[];
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_HEADER_SIZE(n)				(12+(n))
+ 
+ #define UVC_HEADER_DESCRIPTOR(n) \
+ 	uvc_header_descriptor_##n
+ 
+ #define DECLARE_UVC_HEADER_DESCRIPTOR(n)		\
+ struct UVC_HEADER_DESCRIPTOR(n) {			\
+ 	__u8  bLength;					\
+ 	__u8  bDescriptorType;				\
+ 	__u8  bDescriptorSubType;			\
+ 	__u16 bcdUVC;					\
+ 	__u16 wTotalLength;				\
+ 	__u32 dwClockFrequency;				\
+ 	__u8  bInCollection;				\
+ 	__u8  baInterfaceNr[n];				\
+ } __attribute__ ((packed))
+ 
+ /* 3.7.2.1. Input Terminal Descriptor */
+ struct uvc_input_terminal_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bTerminalID;
+ 	__u16 wTerminalType;
+ 	__u8  bAssocTerminal;
+ 	__u8  iTerminal;
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_INPUT_TERMINAL_SIZE			8
+ 
+ /* 3.7.2.2. Output Terminal Descriptor */
+ struct uvc_output_terminal_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bTerminalID;
+ 	__u16 wTerminalType;
+ 	__u8  bAssocTerminal;
+ 	__u8  bSourceID;
+ 	__u8  iTerminal;
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_OUTPUT_TERMINAL_SIZE			9
+ 
+ /* 3.7.2.3. Camera Terminal Descriptor */
+ struct uvc_camera_terminal_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bTerminalID;
+ 	__u16 wTerminalType;
+ 	__u8  bAssocTerminal;
+ 	__u8  iTerminal;
+ 	__u16 wObjectiveFocalLengthMin;
+ 	__u16 wObjectiveFocalLengthMax;
+ 	__u16 wOcularFocalLength;
+ 	__u8  bControlSize;
+ 	__u8  bmControls[3];
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_CAMERA_TERMINAL_SIZE(n)			(15+(n))
+ 
+ /* 3.7.2.4. Selector Unit Descriptor */
+ struct uvc_selector_unit_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bUnitID;
+ 	__u8  bNrInPins;
+ 	__u8  baSourceID[0];
+ 	__u8  iSelector;
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_SELECTOR_UNIT_SIZE(n)			(6+(n))
+ 
+ #define UVC_SELECTOR_UNIT_DESCRIPTOR(n)	\
+ 	uvc_selector_unit_descriptor_##n
+ 
+ #define DECLARE_UVC_SELECTOR_UNIT_DESCRIPTOR(n)	\
+ struct UVC_SELECTOR_UNIT_DESCRIPTOR(n) {		\
+ 	__u8  bLength;					\
+ 	__u8  bDescriptorType;				\
+ 	__u8  bDescriptorSubType;			\
+ 	__u8  bUnitID;					\
+ 	__u8  bNrInPins;				\
+ 	__u8  baSourceID[n];				\
+ 	__u8  iSelector;				\
+ } __attribute__ ((packed))
+ 
+ /* 3.7.2.5. Processing Unit Descriptor */
+ struct uvc_processing_unit_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bUnitID;
+ 	__u8  bSourceID;
+ 	__u16 wMaxMultiplier;
+ 	__u8  bControlSize;
+ 	__u8  bmControls[2];
+ 	__u8  iProcessing;
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_PROCESSING_UNIT_SIZE(n)			(9+(n))
+ 
+ /* 3.7.2.6. Extension Unit Descriptor */
+ struct uvc_extension_unit_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bUnitID;
+ 	__u8  guidExtensionCode[16];
+ 	__u8  bNumControls;
+ 	__u8  bNrInPins;
+ 	__u8  baSourceID[0];
+ 	__u8  bControlSize;
+ 	__u8  bmControls[0];
+ 	__u8  iExtension;
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_EXTENSION_UNIT_SIZE(p, n)		(24+(p)+(n))
+ 
+ #define UVC_EXTENSION_UNIT_DESCRIPTOR(p, n) \
+ 	uvc_extension_unit_descriptor_##p_##n
+ 
+ #define DECLARE_UVC_EXTENSION_UNIT_DESCRIPTOR(p, n)	\
+ struct UVC_EXTENSION_UNIT_DESCRIPTOR(p, n) {		\
+ 	__u8  bLength;					\
+ 	__u8  bDescriptorType;				\
+ 	__u8  bDescriptorSubType;			\
+ 	__u8  bUnitID;					\
+ 	__u8  guidExtensionCode[16];			\
+ 	__u8  bNumControls;				\
+ 	__u8  bNrInPins;				\
+ 	__u8  baSourceID[p];				\
+ 	__u8  bControlSize;				\
+ 	__u8  bmControls[n];				\
+ 	__u8  iExtension;				\
+ } __attribute__ ((packed))
+ 
+ /* 3.8.2.2. Video Control Interrupt Endpoint Descriptor */
+ struct uvc_control_endpoint_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u16 wMaxTransferSize;
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_CONTROL_ENDPOINT_SIZE			5
+ 
+ /* 3.9.2.1. Input Header Descriptor */
+ struct uvc_input_header_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bNumFormats;
+ 	__u16 wTotalLength;
+ 	__u8  bEndpointAddress;
+ 	__u8  bmInfo;
+ 	__u8  bTerminalLink;
+ 	__u8  bStillCaptureMethod;
+ 	__u8  bTriggerSupport;
+ 	__u8  bTriggerUsage;
+ 	__u8  bControlSize;
+ 	__u8  bmaControls[];
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_INPUT_HEADER_SIZE(n, p)			(13+(n*p))
+ 
+ #define UVC_INPUT_HEADER_DESCRIPTOR(n, p) \
+ 	uvc_input_header_descriptor_##n_##p
+ 
+ #define DECLARE_UVC_INPUT_HEADER_DESCRIPTOR(n, p)	\
+ struct UVC_INPUT_HEADER_DESCRIPTOR(n, p) {		\
+ 	__u8  bLength;					\
+ 	__u8  bDescriptorType;				\
+ 	__u8  bDescriptorSubType;			\
+ 	__u8  bNumFormats;				\
+ 	__u16 wTotalLength;				\
+ 	__u8  bEndpointAddress;				\
+ 	__u8  bmInfo;					\
+ 	__u8  bTerminalLink;				\
+ 	__u8  bStillCaptureMethod;			\
+ 	__u8  bTriggerSupport;				\
+ 	__u8  bTriggerUsage;				\
+ 	__u8  bControlSize;				\
+ 	__u8  bmaControls[p][n];			\
+ } __attribute__ ((packed))
+ 
+ /* 3.9.2.2. Output Header Descriptor */
+ struct uvc_output_header_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bNumFormats;
+ 	__u16 wTotalLength;
+ 	__u8  bEndpointAddress;
+ 	__u8  bTerminalLink;
+ 	__u8  bControlSize;
+ 	__u8  bmaControls[];
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_OUTPUT_HEADER_SIZE(n, p)			(9+(n*p))
+ 
+ #define UVC_OUTPUT_HEADER_DESCRIPTOR(n, p) \
+ 	uvc_output_header_descriptor_##n_##p
+ 
+ #define DECLARE_UVC_OUTPUT_HEADER_DESCRIPTOR(n, p)	\
+ struct UVC_OUTPUT_HEADER_DESCRIPTOR(n, p) {		\
+ 	__u8  bLength;					\
+ 	__u8  bDescriptorType;				\
+ 	__u8  bDescriptorSubType;			\
+ 	__u8  bNumFormats;				\
+ 	__u16 wTotalLength;				\
+ 	__u8  bEndpointAddress;				\
+ 	__u8  bTerminalLink;				\
+ 	__u8  bControlSize;				\
+ 	__u8  bmaControls[p][n];			\
+ } __attribute__ ((packed))
+ 
+ /* 3.9.2.6. Color matching descriptor */
+ struct uvc_color_matching_descriptor {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bColorPrimaries;
+ 	__u8  bTransferCharacteristics;
+ 	__u8  bMatrixCoefficients;
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_COLOR_MATCHING_SIZE			6
+ 
 +/* 4.1.2. Control Capabilities */
 +#define UVC_CONTROL_CAP_GET				(1 << 0)
 +#define UVC_CONTROL_CAP_SET				(1 << 1)
 +#define UVC_CONTROL_CAP_DISABLED			(1 << 2)
 +#define UVC_CONTROL_CAP_AUTOUPDATE			(1 << 3)
 +#define UVC_CONTROL_CAP_ASYNCHRONOUS			(1 << 4)
 +
+ /* 4.3.1.1. Video Probe and Commit Controls */
+ struct uvc_streaming_control {
+ 	__u16 bmHint;
+ 	__u8  bFormatIndex;
+ 	__u8  bFrameIndex;
+ 	__u32 dwFrameInterval;
+ 	__u16 wKeyFrameRate;
+ 	__u16 wPFrameRate;
+ 	__u16 wCompQuality;
+ 	__u16 wCompWindowSize;
+ 	__u16 wDelay;
+ 	__u32 dwMaxVideoFrameSize;
+ 	__u32 dwMaxPayloadTransferSize;
+ 	__u32 dwClockFrequency;
+ 	__u8  bmFramingInfo;
+ 	__u8  bPreferedVersion;
+ 	__u8  bMinVersion;
+ 	__u8  bMaxVersion;
+ } __attribute__((__packed__));
+ 
+ /* Uncompressed Payload - 3.1.1. Uncompressed Video Format Descriptor */
+ struct uvc_format_uncompressed {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bFormatIndex;
+ 	__u8  bNumFrameDescriptors;
+ 	__u8  guidFormat[16];
+ 	__u8  bBitsPerPixel;
+ 	__u8  bDefaultFrameIndex;
+ 	__u8  bAspectRatioX;
+ 	__u8  bAspectRatioY;
+ 	__u8  bmInterfaceFlags;
+ 	__u8  bCopyProtect;
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_FORMAT_UNCOMPRESSED_SIZE			27
+ 
+ /* Uncompressed Payload - 3.1.2. Uncompressed Video Frame Descriptor */
+ struct uvc_frame_uncompressed {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bFrameIndex;
+ 	__u8  bmCapabilities;
+ 	__u16 wWidth;
+ 	__u16 wHeight;
+ 	__u32 dwMinBitRate;
+ 	__u32 dwMaxBitRate;
+ 	__u32 dwMaxVideoFrameBufferSize;
+ 	__u32 dwDefaultFrameInterval;
+ 	__u8  bFrameIntervalType;
+ 	__u32 dwFrameInterval[];
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_FRAME_UNCOMPRESSED_SIZE(n)		(26+4*(n))
+ 
+ #define UVC_FRAME_UNCOMPRESSED(n) \
+ 	uvc_frame_uncompressed_##n
+ 
+ #define DECLARE_UVC_FRAME_UNCOMPRESSED(n)		\
+ struct UVC_FRAME_UNCOMPRESSED(n) {			\
+ 	__u8  bLength;					\
+ 	__u8  bDescriptorType;				\
+ 	__u8  bDescriptorSubType;			\
+ 	__u8  bFrameIndex;				\
+ 	__u8  bmCapabilities;				\
+ 	__u16 wWidth;					\
+ 	__u16 wHeight;					\
+ 	__u32 dwMinBitRate;				\
+ 	__u32 dwMaxBitRate;				\
+ 	__u32 dwMaxVideoFrameBufferSize;		\
+ 	__u32 dwDefaultFrameInterval;			\
+ 	__u8  bFrameIntervalType;			\
+ 	__u32 dwFrameInterval[n];			\
+ } __attribute__ ((packed))
+ 
+ /* MJPEG Payload - 3.1.1. MJPEG Video Format Descriptor */
+ struct uvc_format_mjpeg {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bFormatIndex;
+ 	__u8  bNumFrameDescriptors;
+ 	__u8  bmFlags;
+ 	__u8  bDefaultFrameIndex;
+ 	__u8  bAspectRatioX;
+ 	__u8  bAspectRatioY;
+ 	__u8  bmInterfaceFlags;
+ 	__u8  bCopyProtect;
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_FORMAT_MJPEG_SIZE			11
+ 
+ /* MJPEG Payload - 3.1.2. MJPEG Video Frame Descriptor */
+ struct uvc_frame_mjpeg {
+ 	__u8  bLength;
+ 	__u8  bDescriptorType;
+ 	__u8  bDescriptorSubType;
+ 	__u8  bFrameIndex;
+ 	__u8  bmCapabilities;
+ 	__u16 wWidth;
+ 	__u16 wHeight;
+ 	__u32 dwMinBitRate;
+ 	__u32 dwMaxBitRate;
+ 	__u32 dwMaxVideoFrameBufferSize;
+ 	__u32 dwDefaultFrameInterval;
+ 	__u8  bFrameIntervalType;
+ 	__u32 dwFrameInterval[];
+ } __attribute__((__packed__));
+ 
+ #define UVC_DT_FRAME_MJPEG_SIZE(n)			(26+4*(n))
+ 
+ #define UVC_FRAME_MJPEG(n) \
+ 	uvc_frame_mjpeg_##n
+ 
+ #define DECLARE_UVC_FRAME_MJPEG(n)			\
+ struct UVC_FRAME_MJPEG(n) {				\
+ 	__u8  bLength;					\
+ 	__u8  bDescriptorType;				\
+ 	__u8  bDescriptorSubType;			\
+ 	__u8  bFrameIndex;				\
+ 	__u8  bmCapabilities;				\
+ 	__u16 wWidth;					\
+ 	__u16 wHeight;					\
+ 	__u32 dwMinBitRate;				\
+ 	__u32 dwMaxBitRate;				\
+ 	__u32 dwMaxVideoFrameBufferSize;		\
+ 	__u32 dwDefaultFrameInterval;			\
+ 	__u8  bFrameIntervalType;			\
+ 	__u32 dwFrameInterval[n];			\
+ } __attribute__ ((packed))
+ 
  #endif /* __LINUX_USB_VIDEO_H */
  
