Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777Ab0GWP36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 11:29:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:60123 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760745Ab0GWP3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 11:29:48 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18dNUkq0UMdTamgUJDvYdCEdMen77+2+cH6fjGPWM
	Qx0taNPFyuKrmN
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: [PATCH 09/11] viafb: remove ioctls which break the framebuffer interface
Date: Fri, 23 Jul 2010 15:39:24 +0000
Message-Id: <1279899566-4359-10-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1279899566-4359-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: remove ioctls which break the framebuffer interface

The ioctls VIAFB_SET_DEVICE, VIAFB_SET_DEVICE_INFO and
VIAFB_SET_SECOND_MODE are removed because they prevent a clean
framebuffer driver because they modify the hardware and/or the
internal structures.
There are no known applications using these ioctls so no breakage is
expected. Additionaly the main functionality was duplicating the
framebuffer interface so there really should not exist any user.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
---
 drivers/video/via/ioctl.h    |    3 -
 drivers/video/via/viafbdev.c |  251 ------------------------------------------
 2 files changed, 0 insertions(+), 254 deletions(-)

diff --git a/drivers/video/via/ioctl.h b/drivers/video/via/ioctl.h
index c430fa2..6010d10 100644
--- a/drivers/video/via/ioctl.h
+++ b/drivers/video/via/ioctl.h
@@ -35,11 +35,9 @@
 #define VIAFB_GET_SAMM_INFO		0x56494107	/* 'VIA\07' */
 #define VIAFB_TURN_ON_OUTPUT_DEVICE     0x56494108	/* 'VIA\08' */
 #define VIAFB_TURN_OFF_OUTPUT_DEVICE    0x56494109	/* 'VIA\09' */
-#define VIAFB_SET_DEVICE		0x5649410A
 #define VIAFB_GET_DEVICE		0x5649410B
 #define VIAFB_GET_DRIVER_VERSION	0x56494112	/* 'VIA\12' */
 #define VIAFB_GET_CHIP_INFO		0x56494113	/* 'VIA\13' */
-#define VIAFB_SET_DEVICE_INFO           0x56494114
 #define VIAFB_GET_DEVICE_INFO           0x56494115
 
 #define VIAFB_GET_DEVICE_SUPPORT	0x56494118
@@ -50,7 +48,6 @@
 #define VIAFB_GET_GAMMA_LUT		0x56494124
 #define VIAFB_SET_GAMMA_LUT		0x56494125
 #define VIAFB_GET_GAMMA_SUPPORT_STATE	0x56494126
-#define VIAFB_SET_SECOND_MODE		0x56494129
 #define VIAFB_SYNC_SURFACE		0x56494130
 #define VIAFB_GET_DRIVER_CAPS		0x56494131
 #define VIAFB_GET_IGA_SCALING_INFO	0x56494132
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index ab39552..1128d51 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -49,11 +49,6 @@ char *viafb_active_dev;
 char *viafb_lcd_port = "";
 char *viafb_dvi_port = "";
 
-static void viafb_set_device(struct device_t active_dev);
-static int apply_device_setting(struct viafb_ioctl_setting setting_info,
-			 struct fb_info *info);
-static void apply_second_mode_setting(struct fb_var_screeninfo
-	*sec_var);
 static void retrieve_device_setting(struct viafb_ioctl_setting
 	*setting_info);
 static int viafb_pan_display(struct fb_var_screeninfo *var,
@@ -478,13 +473,6 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 		if (gpu32 & LCD_Device)
 			viafb_lcd_disable();
 		break;
-	case VIAFB_SET_DEVICE:
-		if (copy_from_user(&u.active_dev, (void *)argp,
-			sizeof(u.active_dev)))
-			return -EFAULT;
-		viafb_set_device(u.active_dev);
-		viafb_set_par(info);
-		break;
 	case VIAFB_GET_DEVICE:
 		u.active_dev.crt = viafb_CRT_ON;
 		u.active_dev.dvi = viafb_DVI_ON;
@@ -527,21 +515,6 @@ static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 
 		break;
 
-	case VIAFB_SET_DEVICE_INFO:
-		if (copy_from_user(&u.viafb_setting,
-			argp, sizeof(u.viafb_setting)))
-			return -EFAULT;
-		if (apply_device_setting(u.viafb_setting, info) < 0)
-			return -EINVAL;
-
-		break;
-
-	case VIAFB_SET_SECOND_MODE:
-		if (copy_from_user(&u.sec_var, argp, sizeof(u.sec_var)))
-			return -EFAULT;
-		apply_second_mode_setting(&u.sec_var);
-		break;
-
 	case VIAFB_GET_DEVICE_INFO:
 
 		retrieve_device_setting(&u.viafb_setting);
@@ -913,112 +886,6 @@ static int viafb_sync(struct fb_info *info)
 	return 0;
 }
 
-static void check_available_device_to_enable(int device_id)
-{
-	int device_num = 0;
-
-	/* Initialize: */
-	viafb_CRT_ON = STATE_OFF;
-	viafb_DVI_ON = STATE_OFF;
-	viafb_LCD_ON = STATE_OFF;
-	viafb_LCD2_ON = STATE_OFF;
-	viafb_DeviceStatus = None_Device;
-
-	if ((device_id & CRT_Device) && (device_num < MAX_ACTIVE_DEV_NUM)) {
-		viafb_CRT_ON = STATE_ON;
-		device_num++;
-		viafb_DeviceStatus |= CRT_Device;
-	}
-
-	if ((device_id & DVI_Device) && (device_num < MAX_ACTIVE_DEV_NUM)) {
-		viafb_DVI_ON = STATE_ON;
-		device_num++;
-		viafb_DeviceStatus |= DVI_Device;
-	}
-
-	if ((device_id & LCD_Device) && (device_num < MAX_ACTIVE_DEV_NUM)) {
-		viafb_LCD_ON = STATE_ON;
-		device_num++;
-		viafb_DeviceStatus |= LCD_Device;
-	}
-
-	if ((device_id & LCD2_Device) && (device_num < MAX_ACTIVE_DEV_NUM)) {
-		viafb_LCD2_ON = STATE_ON;
-		device_num++;
-		viafb_DeviceStatus |= LCD2_Device;
-	}
-
-	if (viafb_DeviceStatus == None_Device) {
-		/* Use CRT as default active device: */
-		viafb_CRT_ON = STATE_ON;
-		viafb_DeviceStatus = CRT_Device;
-	}
-	DEBUG_MSG(KERN_INFO "Device Status:%x", viafb_DeviceStatus);
-}
-
-static void viafb_set_device(struct device_t active_dev)
-{
-	/* Check available device to enable: */
-	int device_id = None_Device;
-	if (active_dev.crt)
-		device_id |= CRT_Device;
-	if (active_dev.dvi)
-		device_id |= DVI_Device;
-	if (active_dev.lcd)
-		device_id |= LCD_Device;
-
-	check_available_device_to_enable(device_id);
-
-	/* Check property of LCD: */
-	if (viafb_LCD_ON) {
-		if (active_dev.lcd_dsp_cent) {
-			viaparinfo->lvds_setting_info->display_method =
-				viafb_lcd_dsp_method = LCD_CENTERING;
-		} else {
-			viaparinfo->lvds_setting_info->display_method =
-				viafb_lcd_dsp_method = LCD_EXPANDSION;
-		}
-
-		if (active_dev.lcd_mode == LCD_SPWG) {
-			viaparinfo->lvds_setting_info->lcd_mode =
-				viafb_lcd_mode = LCD_SPWG;
-		} else {
-			viaparinfo->lvds_setting_info->lcd_mode =
-				viafb_lcd_mode = LCD_OPENLDI;
-		}
-
-		if (active_dev.lcd_panel_id <= LCD_PANEL_ID_MAXIMUM) {
-			viafb_lcd_panel_id = active_dev.lcd_panel_id;
-			viafb_init_lcd_size();
-		}
-	}
-
-	/* Check property of mode: */
-	if (!active_dev.xres1)
-		viafb_second_xres = 640;
-	else
-		viafb_second_xres = active_dev.xres1;
-	if (!active_dev.yres1)
-		viafb_second_yres = 480;
-	else
-		viafb_second_yres = active_dev.yres1;
-	if (active_dev.bpp != 0)
-		viafb_bpp = active_dev.bpp;
-	if (active_dev.bpp1 != 0)
-		viafb_bpp1 = active_dev.bpp1;
-	if (active_dev.refresh != 0)
-		viafb_refresh = active_dev.refresh;
-	if (active_dev.refresh1 != 0)
-		viafb_refresh1 = active_dev.refresh1;
-	if ((active_dev.samm == STATE_OFF) || (active_dev.samm == STATE_ON))
-		viafb_SAMM_ON = active_dev.samm;
-	viafb_primary_dev = active_dev.primary_dev;
-
-	via_set_primary_address(0);
-	via_set_secondary_address(viafb_SAMM_ON ? viafb_second_offset : 0);
-	viafb_set_iga_path();
-}
-
 static int get_primary_device(void)
 {
 	int primary_device = 0;
@@ -1060,124 +927,6 @@ static int get_primary_device(void)
 	return primary_device;
 }
 
-static void apply_second_mode_setting(struct fb_var_screeninfo
-	*sec_var)
-{
-	u32 htotal, vtotal, long_refresh;
-
-	htotal = sec_var->xres + sec_var->left_margin +
-		sec_var->right_margin + sec_var->hsync_len;
-	vtotal = sec_var->yres + sec_var->upper_margin +
-		sec_var->lower_margin + sec_var->vsync_len;
-	if ((sec_var->xres_virtual * (sec_var->bits_per_pixel >> 3)) & 0x1F) {
-		/*Is 32 bytes alignment? */
-		/*32 pixel alignment */
-		sec_var->xres_virtual = (sec_var->xres_virtual + 31) & ~31;
-	}
-
-	htotal = sec_var->xres + sec_var->left_margin +
-		sec_var->right_margin + sec_var->hsync_len;
-	vtotal = sec_var->yres + sec_var->upper_margin +
-		sec_var->lower_margin + sec_var->vsync_len;
-	long_refresh = 1000000000UL / sec_var->pixclock * 1000;
-	long_refresh /= (htotal * vtotal);
-
-	viafb_second_xres = sec_var->xres;
-	viafb_second_yres = sec_var->yres;
-	viafb_second_virtual_xres = sec_var->xres_virtual;
-	viafb_second_virtual_yres = sec_var->yres_virtual;
-	viafb_bpp1 = sec_var->bits_per_pixel;
-	viafb_refresh1 = viafb_get_refresh(sec_var->xres, sec_var->yres,
-		long_refresh);
-}
-
-static int apply_device_setting(struct viafb_ioctl_setting setting_info,
-	struct fb_info *info)
-{
-	int need_set_mode = 0;
-	DEBUG_MSG(KERN_INFO "apply_device_setting\n");
-
-	if (setting_info.device_flag) {
-		need_set_mode = 1;
-		check_available_device_to_enable(setting_info.device_status);
-	}
-
-	/* Unlock LCD's operation according to LCD flag
-	   and check if the setting value is valid. */
-	/* If the value is valid, apply the new setting value to the device. */
-	if (viafb_LCD_ON) {
-		if (setting_info.lcd_operation_flag & OP_LCD_CENTERING) {
-			need_set_mode = 1;
-			if (setting_info.lcd_attributes.display_center) {
-				/* Centering */
-				viaparinfo->lvds_setting_info->display_method =
-				    LCD_CENTERING;
-				viafb_lcd_dsp_method = LCD_CENTERING;
-				viaparinfo->lvds_setting_info2->display_method =
-				    viafb_lcd_dsp_method = LCD_CENTERING;
-			} else {
-				/* expandsion */
-				viaparinfo->lvds_setting_info->display_method =
-				    LCD_EXPANDSION;
-				viafb_lcd_dsp_method = LCD_EXPANDSION;
-				viaparinfo->lvds_setting_info2->display_method =
-				    LCD_EXPANDSION;
-				viafb_lcd_dsp_method = LCD_EXPANDSION;
-			}
-		}
-
-		if (setting_info.lcd_operation_flag & OP_LCD_MODE) {
-			need_set_mode = 1;
-			if (setting_info.lcd_attributes.lcd_mode ==
-				LCD_SPWG) {
-				viaparinfo->lvds_setting_info->lcd_mode =
-					viafb_lcd_mode = LCD_SPWG;
-			} else {
-				viaparinfo->lvds_setting_info->lcd_mode =
-					viafb_lcd_mode = LCD_OPENLDI;
-			}
-			viaparinfo->lvds_setting_info2->lcd_mode =
-			    viaparinfo->lvds_setting_info->lcd_mode;
-		}
-
-		if (setting_info.lcd_operation_flag & OP_LCD_PANEL_ID) {
-			need_set_mode = 1;
-			if (setting_info.lcd_attributes.panel_id <=
-			    LCD_PANEL_ID_MAXIMUM) {
-				viafb_lcd_panel_id =
-				    setting_info.lcd_attributes.panel_id;
-				viafb_init_lcd_size();
-			}
-		}
-	}
-
-	if (0 != (setting_info.samm_status & OP_SAMM)) {
-		setting_info.samm_status =
-		    setting_info.samm_status & (~OP_SAMM);
-		if (setting_info.samm_status == 0
-		    || setting_info.samm_status == 1) {
-			viafb_SAMM_ON = setting_info.samm_status;
-
-			if (viafb_SAMM_ON)
-				viafb_primary_dev = setting_info.primary_device;
-
-			via_set_primary_address(0);
-			via_set_secondary_address(viafb_SAMM_ON ?
-				viafb_second_offset : 0);
-			viafb_set_iga_path();
-		}
-		need_set_mode = 1;
-	}
-
-	if (!need_set_mode) {
-		;
-	} else {
-		viafb_set_iga_path();
-		viafb_set_par(info);
-	}
-	return true;
-}
-
 static void retrieve_device_setting(struct viafb_ioctl_setting
 	*setting_info)
 {
-- 
1.6.3.2

