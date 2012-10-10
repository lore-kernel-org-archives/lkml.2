Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab2JJSTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:19:09 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:34529 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab2JJSTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:19:05 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiaOAAK7dVBV5h1yPGdsb2JhbABEhSlphDqzZgR6GQEBAQEfGQ0ngiABAQQBGgEIBAsBIyMFCwgDDgwCJgICFCUKGogRCqRqkwAUgQ2KJhMchF8yYAOVa4VyjS6BYQ
X-IronPort-AV: E=Sophos;i="4.80,566,1344204000"; 
   d="scan'208";a="130157684"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 10 Oct 2012 20:21:30 +0200
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chen <alexandra.chen@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 06/06] input/rmi4: F11 - 2D touch interface
Message-ID: <20121010182130.GA436@polaris.bitmath.org>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
 <1349496603-20775-7-git-send-email-cheiny@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349496603-20775-7-git-send-email-cheiny@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

> rmi_f11.c is a driver for 2D touch sensors.  It has been updated to support
> the MT-B specification, partition control attributes between debugfs and sysfs,
> and to use the standard bus model for loading/unloading.

Please find comments inline.

Generally, if you want this merged as an input device sometime in the
future, you need to reduce the size and complexity of the whole
patchset. Given that you only need to feed the input subsystem with
raw data, you can make do without most of the sysfs nodes, debug
output, and internal gesture state.

The 2D sensor data, currently living in debugfs, might eventually find
a home in the input subsystem, based on the growing interest from
several directions. However, if you are just looking for a way to
transport the rmi data to userland, please consider implementing this
under a different subsystem.

> diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c
> new file mode 100644
> index 0000000..bba818b
> --- /dev/null
> +++ b/drivers/input/rmi4/rmi_f11.c
> @@ -0,0 +1,2727 @@
> +/*
> + * Copyright (c) 2011,2012 Synaptics Incorporated
> + * Copyright (c) 2011 Unixphere
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#define FUNCTION_DATA f11_data
> +#define FNUM 11
> +
> +#include <linux/kernel.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <linux/input.h>
> +#include <linux/input/mt.h>
> +#include <linux/kconfig.h>
> +#include <linux/rmi.h>
> +#include <linux/slab.h>
> +#include "rmi_driver.h"
> +
> +#ifdef CONFIG_RMI4_DEBUG
> +#include <linux/debugfs.h>
> +#include <linux/fs.h>
> +#include <linux/uaccess.h>
> +#endif
> +
> +#define F11_MAX_NUM_OF_SENSORS		8
> +#define F11_MAX_NUM_OF_FINGERS		10
> +#define F11_MAX_NUM_OF_TOUCH_SHAPES	16
> +
> +#define F11_REL_POS_MIN		-128
> +#define F11_REL_POS_MAX		127
> +
> +#define FINGER_STATE_MASK	0x03
> +#define GET_FINGER_STATE(f_states, i) \
> +	((f_states[i / 4] >> (2 * (i % 4))) & FINGER_STATE_MASK)

These could be open-coded or put in a function instead.

> +
> +#define F11_CTRL_SENSOR_MAX_X_POS_OFFSET	6
> +#define F11_CTRL_SENSOR_MAX_Y_POS_OFFSET	8
> +
> +#define F11_CEIL(x, y) (((x) + ((y)-1)) / (y))
> +#define INBOX(x, y, box) (x >= box.x && x < (box.x + box.width) \
> +			&& y >= box.y && y < (box.y + box.height))
> +
> +#define DEFAULT_XY_MAX 9999
> +#define DEFAULT_MAX_ABS_MT_PRESSURE 255
> +#define DEFAULT_MAX_ABS_MT_TOUCH 15
> +#define DEFAULT_MAX_ABS_MT_ORIENTATION 1
> +#define DEFAULT_MIN_ABS_MT_TRACKING_ID 1
> +#define DEFAULT_MAX_ABS_MT_TRACKING_ID 10
> +#define MAX_NAME_LENGTH 256
> +
> +static ssize_t f11_relreport_show(struct device *dev,
> +					struct device_attribute *attr,
> +					char *buf);
> +
> +static ssize_t f11_relreport_store(struct device *dev,
> +					 struct device_attribute *attr,
> +					 const char *buf, size_t count);
> +
> +static ssize_t f11_maxPos_show(struct device *dev,
> +				     struct device_attribute *attr, char *buf);
> +
> +static ssize_t f11_rezero_store(struct device *dev,
> +					 struct device_attribute *attr,
> +					 const char *buf, size_t count);
> +
> +static void rmi_f11_free_memory(struct rmi_function_container *fc);
> +
> +static int rmi_f11_initialize(struct rmi_function_container *fc);
> +
> +static int rmi_f11_create_sysfs(struct rmi_function_container *fc);
> +
> +static int rmi_f11_config(struct rmi_function_container *fc);
> +
> +static int rmi_f11_register_devices(struct rmi_function_container *fc);
> +
> +static void rmi_f11_free_devices(struct rmi_function_container *fc);
> +
> +static void f11_set_abs_params(struct rmi_function_container *fc, int index);

Please try to get rid of these.

> +
> +static struct device_attribute attrs[] = {
> +	__ATTR(relreport, RMI_RW_ATTR, f11_relreport_show, f11_relreport_store),
> +	__ATTR(maxPos, RMI_RO_ATTR, f11_maxPos_show, rmi_store_error),
> +	__ATTR(rezero, RMI_WO_ATTR, rmi_show_error, f11_rezero_store)
> +};
> +
> +/**
> + * @rezero - writing 1 to this will cause the sensor to calibrate to the
> + * current capacitive state.
> + */
> +union f11_2d_commands {
> +	struct {
> +		bool rezero:1;
> +		u8 reserved:7;
> +	} __attribute__((__packed__));
> +	u8 reg;
> +};

Maybe a constant would be more suitable here?

> +
> +/**
> + * @nbr_of_sensors - the number of 2D sensors on the touch device.
> + * @has_query9 - indicates the F11_2D_Query9 register exists.
> + * @has_query11 - indicates the F11_2D_Query11 register exists.
> + * @has_z_tuning - if set, the sensor supports Z tuning and registers
> + * F11_2D_Ctrl29 through F11_2D_Ctrl33 exist.
> + * @has_pos_interpolation_tuning - TBD
> + * @has_w_tuning - the sensor supports Wx and Wy scaling and registers
> + * F11_2D_Ctrl36 through F11_2D_Ctrl39 exist.
> + * @has_pitch_info - the X and Y pitches of the sensor electrodes can be
> + * configured and registers F11_2D_Ctrl40 and F11_2D_Ctrl41 exist.
> + * @has_default_finger_width -  the default finger width settings for the
> + * sensor can be configured and registers F11_2D_Ctrl42 through F11_2D_Ctrl44
> + * exist.
> + * @has_segmentation_aggressiveness - the sensor’s ability to distinguish
> + * multiple objects close together can be configured and register F11_2D_Ctrl45
> + * exists.
> + * @has_tx_rw_clip -  the inactive outside borders of the sensor can be
> + * configured and registers F11_2D_Ctrl46 through F11_2D_Ctrl49 exist.
> + * @has_drumming_correction - the sensor can be configured to distinguish
> + * between a fast flick and a quick drumming movement and registers
> + * F11_2D_Ctrl50 and F11_2D_Ctrl51 exist.
> + */
> +struct f11_2d_device_query {
> +	union {
> +		struct {
> +			u8 nbr_of_sensors:3;
> +			bool has_query9:1;
> +			bool has_query11:1;
> +			u8 reserved:3;
> +		} __attribute__((__packed__));
> +		u8 f11_2d_query0;
> +	};

Why union here? It seems all you need is a packed struct named query0.

> +
> +	union {
> +		struct {
> +			bool has_z_tuning:1;
> +			bool has_pos_interpolation_tuning:1;
> +			bool has_w_tuning:1;
> +			bool has_pitch_info:1;
> +			bool has_default_finger_width:1;
> +			bool has_segmentation_aggressiveness:1;
> +			bool has_tx_rw_clip:1;
> +			bool has_drumming_correction:1;
> +		} __attribute__((__packed__));
> +		u8 f11_2d_query11;
> +	};
> +};

Ditto.

> +
> +/**
> + * @has_pen - detection of a stylus is supported and registers F11_2D_Ctrl20
> + * and F11_2D_Ctrl21 exist.
> + * @has_proximity - detection of fingers near the sensor is supported and
> + * registers F11_2D_Ctrl22 through F11_2D_Ctrl26 exist.
> + * @has_palm_det_sensitivity -  the sensor supports the palm detect sensitivity
> + * feature and register F11_2D_Ctrl27 exists.
> + * @has_two_pen_thresholds - is has_pen is also set, then F11_2D_Ctrl35 exists.
> + * @has_contact_geometry - the sensor supports the use of contact geometry to
> + * map absolute X and Y target positions and registers F11_2D_Data18.* through
> + * F11_2D_Data27 exist.
> + */
> +union f11_2d_query9 {
> +	struct {
> +		bool has_pen:1;
> +		bool has_proximity:1;
> +		bool has_palm_det_sensitivity:1;
> +		bool has_suppress_on_palm_detect:1;
> +		bool has_two_pen_thresholds:1;
> +		bool has_contact_geometry:1;
> +	} __attribute__((__packed__));
> +	u8 reg;
> +};

Ditto.

> +
> +/**
> + * @number_of_fingers - describes the maximum number of fingers the 2-D sensor
> + * supports.
> + * @has_rel - the sensor supports relative motion reporting.
> + * @has_abs - the sensor supports absolute poition reporting.
> + * @has_gestures - the sensor supports gesture reporting.
> + * @has_sensitivity_adjust - the sensor supports a global sensitivity
> + * adjustment.
> + * @configurable - the sensor supports various configuration options.
> + * @num_of_x_electrodes -  the maximum number of electrodes the 2-D sensor
> + * supports on the X axis.
> + * @num_of_y_electrodes -  the maximum number of electrodes the 2-D sensor
> + * supports on the Y axis.
> + * @max_electrodes - the total number of X and Y electrodes that may be
> + * configured.
> + * @abs_data_size - describes the format of data reported by the absolute
> + * data source.  Only one format (the kind used here) is supported at this
> + * time.
> + * @has_anchored_finger - then the sensor supports the high-precision second
> + * finger tracking provided by the manual tracking and motion sensitivity
> + * options.
> + * @has_adjust_hyst - the difference between the finger release threshold and
> + * the touch threshold.
> + * @has_dribble - the sensor supports the generation of dribble interrupts,
> + * which may be enabled or disabled with the dribble control bit.
> + * @f11_2d_query6 - reserved.
> + * @has_single_tap - a basic single-tap gesture is supported.
> + * @has_tap_n_hold - tap-and-hold gesture is supported.
> + * @has_double_tap - double-tap gesture is supported.
> + * @has_early_tap - early tap is supported and reported as soon as the finger
> + * lifts for any tap event that could be interpreted as either a single tap
> + * or as the first tap of a double-tap or tap-and-hold gesture.
> + * @has_flick - flick detection is supported.
> + * @has_press - press gesture reporting is supported.
> + * @has_pinch - pinch gesture detection is supported.
> + * @has_palm_det - the 2-D sensor notifies the host whenever a large conductive
> + * object such as a palm or a cheek touches the 2-D sensor.
> + * @has_rotate - rotation gesture detection is supported.
> + * @has_touch_shapes - TouchShapes are supported.  A TouchShape is a fixed
> + * rectangular area on the sensor that behaves like a capacitive button.
> + * @has_scroll_zones - scrolling areas near the sensor edges are supported.
> + * @has_individual_scroll_zones - if 1, then 4 scroll zones are supported;
> + * if 0, then only two are supported.
> + * @has_multi_finger_scroll - the multifinger_scrolling bit will be set when
> + * more than one finger is involved in a scrolling action.
> + * @nbr_touch_shapes - the total number of touch shapes supported.
> + */
> +struct f11_2d_sensor_query {
> +	union {
> +		struct {
> +			/* query1 */
> +			u8 number_of_fingers:3;
> +			bool has_rel:1;
> +			bool has_abs:1;
> +			bool has_gestures:1;
> +			bool has_sensitivity_adjust:1;
> +			bool configurable:1;
> +			/* query2 */
> +			u8 num_of_x_electrodes:7;
> +			u8 reserved_1:1;
> +			/* query3 */
> +			u8 num_of_y_electrodes:7;
> +			u8 reserved_2:1;
> +			/* query4 */
> +			u8 max_electrodes:7;
> +			u8 reserved_3:1;
> +		} __attribute__((__packed__));
> +		u8 f11_2d_query1__4[4];
> +	};
> +
> +	union {
> +		struct {
> +			u8 abs_data_size:3;
> +			bool has_anchored_finger:1;
> +			bool has_adj_hyst:1;
> +			bool has_dribble:1;
> +			u8 reserved_4:2;
> +		} __attribute__((__packed__));
> +		u8 f11_2d_query5;
> +	};
> +
> +	u8 f11_2d_query6;
> +
> +	union {
> +		struct {
> +			bool has_single_tap:1;
> +			bool has_tap_n_hold:1;
> +			bool has_double_tap:1;
> +			bool has_early_tap:1;
> +			bool has_flick:1;
> +			bool has_press:1;
> +			bool has_pinch:1;
> +			bool padding:1;
> +
> +			bool has_palm_det:1;
> +			bool has_rotate:1;
> +			bool has_touch_shapes:1;
> +			bool has_scroll_zones:1;
> +			bool has_individual_scroll_zones:1;
> +			bool has_multi_finger_scroll:1;
> +		} __attribute__((__packed__));
> +		u8 f11_2d_query7__8[2];
> +	};
> +
> +	union f11_2d_query9 query9;
> +
> +	union {
> +		struct {
> +			u8 nbr_touch_shapes:5;
> +		} __attribute__((__packed__));
> +		u8 f11_2d_query10;
> +	};
> +};

Ditto. It is nice with some documentation, but in this case, it might
make sense to add it on the same line in the struct. Also, since an MT
device outputs the raw position data and leaves the gestures to
userspace, this whole construct is more complex than it needs to be.

> +
> +/**
> + * @reporting_mode - controls how often finger position data is reported.
> + * @abs_pos_filt - when set, enables various noise and jitter filtering
> + * algorithms for absolute reports.
> + * @rel_pos_filt - when set, enables various noise and jitter filtering
> + * algorithms for relative reports.
> + * @rel_ballistics - enables ballistics processing for the relative finger
> + * motion on the 2-D sensor.
> + * @dribble - enables the dribbling feature.
> + * @report_beyond_clip - when this is set, fingers outside the active area
> + * specified by the x_clip and y_clip registers will be reported, but with
> + * reported finger position clipped to the edge of the active area.
> + * @palm_detect_thresh - the threshold at which a wide finger is considered a
> + * palm. A value of 0 inhibits palm detection.
> + * @motion_sensitivity - specifies the threshold an anchored finger must move
> + * before it is considered no longer anchored.  High values mean more
> + * sensitivity.
> + * @man_track_en - for anchored finger tracking, whether the host (1) or the
> + * device (0) determines which finger is the tracked finger.
> + * @man_tracked_finger - when man_track_en is 1, specifies whether finger 0 or
> + * finger 1 is the tracked finger.
> + * @delta_x_threshold - 2-D position update interrupts are inhibited unless
> + * the finger moves more than a certain threshold distance along the X axis.
> + * @delta_y_threshold - 2-D position update interrupts are inhibited unless
> + * the finger moves more than a certain threshold distance along the Y axis.
> + * @velocity - When rel_ballistics is set, this register defines the
> + * velocity ballistic parameter applied to all relative motion events.
> + * @acceleration - When rel_ballistics is set, this register defines the
> + * acceleration ballistic parameter applied to all relative motion events.
> + * @sensor_max_x_pos - the maximum X coordinate reported by the sensor.
> + * @sensor_max_y_pos - the maximum Y coordinate reported by the sensor.
> + */
> +union f11_2d_ctrl0_9 {
> +	struct {
> +		/* F11_2D_Ctrl0 */
> +		u8 reporting_mode:3;
> +		bool abs_pos_filt:1;
> +		bool rel_pos_filt:1;
> +		bool rel_ballistics:1;
> +		bool dribble:1;
> +		bool report_beyond_clip:1;
> +		/* F11_2D_Ctrl1 */
> +		u8 palm_detect_thres:4;
> +		u8 motion_sensitivity:2;
> +		bool man_track_en:1;
> +		bool man_tracked_finger:1;
> +		/* F11_2D_Ctrl2 and 3 */
> +		u8 delta_x_threshold:8;
> +		u8 delta_y_threshold:8;
> +		/* F11_2D_Ctrl4 and 5 */
> +		u8 velocity:8;
> +		u8 acceleration:8;
> +		/* F11_2D_Ctrl6 thru 9 */
> +		u16 sensor_max_x_pos:12;
> +		u8 ctrl7_reserved:4;
> +		u16 sensor_max_y_pos:12;
> +		u8 ctrl9_reserved:4;
> +	} __attribute__((__packed__));
> +	struct {
> +		u8 regs[10];
> +		u16 address;
> +	} __attribute__((__packed__));
> +};
> +
> +/**
> + * @single_tap_int_enable - enable tap gesture recognition.
> + * @tap_n_hold_int_enable - enable tap-and-hold gesture recognition.
> + * @double_tap_int_enable - enable double-tap gesture recognition.
> + * @early_tap_int_enable - enable early tap notification.
> + * @flick_int_enable - enable flick detection.
> + * @press_int_enable - enable press gesture recognition.
> + * @pinch_int_enable - enable pinch detection.
> + */
> +union f11_2d_ctrl10 {
> +	struct {
> +		bool single_tap_int_enable:1;
> +		bool tap_n_hold_int_enable:1;
> +		bool double_tap_int_enable:1;
> +		bool early_tap_int_enable:1;
> +		bool flick_int_enable:1;
> +		bool press_int_enable:1;
> +		bool pinch_int_enable:1;
> +	} __attribute__((__packed__));
> +	u8 reg;
> +};
> +
> +/**
> + * @palm_detect_int_enable - enable palm detection feature.
> + * @rotate_int_enable - enable rotate gesture detection.
> + * @touch_shape_int_enable - enable the TouchShape feature.
> + * @scroll_zone_int_enable - enable scroll zone reporting.
> + * @multi_finger_scroll_int_enable - enable the multfinger scroll feature.
> + */
> +union f11_2d_ctrl11 {
> +	struct {
> +		bool palm_detect_int_enable:1;
> +		bool rotate_int_enable:1;
> +		bool touch_shape_int_enable:1;
> +		bool scroll_zone_int_enable:1;
> +		bool multi_finger_scroll_int_enable:1;
> +	} __attribute__((__packed__));
> +	u8 reg;
> +};
> +
> +union f11_2d_ctrl12 {
> +	struct {
> +		u8 sensor_map:7;
> +		bool xy_sel:1;
> +	} __attribute__((__packed__));
> +	u8 reg;
> +};
> +
> +/**
> + * @sens_adjustment - allows a host to alter the overall sensitivity of a
> + * 2-D sensor. A positive value in this register will make the sensor more
> + * sensitive than the factory defaults, and a negative value will make it
> + * less sensitive.
> + * @hyst_adjustment - increase the touch/no-touch hysteresis by 2 Z-units for
> + * each one unit increment in this setting.
> + */
> +union f11_2d_ctrl14 {
> +	struct {
> +		s8 sens_adjustment:5;
> +		u8 hyst_adjustment:3;
> +	} __attribute__((__packed__));
> +	u8 reg;
> +};
> +
> +/**
> + * @max_tap_time - the maximum duration of a tap, in 10-millisecond units.
> + */
> +union f11_2d_ctrl15 {
> +	struct {
> +		u8 max_tap_time:8;
> +	} __attribute__((__packed__));
> +	u8 reg;
> +};
> +
> +/**
> + * @min_press_time - The minimum duration required for stationary finger(s) to
> + * generate a press gesture, in 10-millisecond units.
> + */
> +union f11_2d_ctrl16 {
> +	struct {
> +		u8 min_press_time:8;
> +	} __attribute__((__packed__));
> +	u8 reg;
> +};
> +
> +/**
> + * @max_tap_distance - Determines the maximum finger movement allowed during
> + * a tap, in 0.1-millimeter units.
> + */
> +union f11_2d_ctrl17 {
> +	struct {
> +		u8 max_tap_distance:8;
> +	} __attribute__((__packed__));
> +	u8 reg;
> +};
> +
> +/**
> + * @min_flick_distance - the minimum finger movement for a flick gesture,
> + * in 1-millimeter units.
> + * @min_flick_speed - the minimum finger speed for a flick gesture, in
> + * 10-millimeter/second units.
> + */
> +union f11_2d_ctrl18_19 {
> +	struct {
> +		u8 min_flick_distance:8;
> +		u8 min_flick_speed:8;
> +	} __attribute__((__packed__));
> +	u8 reg[2];
> +};
> +
> +/**
> + * @pen_detect_enable - enable reporting of stylus activity.
> + * @pen_jitter_filter_enable - Setting this enables the stylus anti-jitter
> + * filter.
> + * @pen_z_threshold - This is the stylus-detection lower threshold. Smaller
> + * values result in higher sensitivity.
> + */
> +union f11_2d_ctrl20_21 {
> +	struct {
> +		bool pen_detect_enable:1;
> +		bool pen_jitter_filter_enable:1;
> +		u8 ctrl20_reserved:6;
> +		u8 pen_z_threshold:8;
> +	} __attribute__((__packed__));
> +	u8 reg[2];
> +};

Given that most of the above will not be used in this driver, it can
probably be compressed quite a bit.

> +
> +/**
> + * These are not accessible through sysfs yet.
> + *
> + * @proximity_detect_int_en - enable proximity detection feature.
> + * @proximity_jitter_filter_en - enables an anti-jitter filter on proximity
> + * data.
> + * @proximity_detection_z_threshold - the threshold for finger-proximity
> + * detection.
> + * @proximity_delta_x_threshold - In reduced-reporting modes, this is the
> + * threshold for proximate-finger movement in the direction parallel to the
> + * X-axis.
> + * @proximity_delta_y_threshold - In reduced-reporting modes, this is the
> + * threshold for proximate-finger movement in the direction parallel to the
> + * Y-axis.
> + * * @proximity_delta_Z_threshold - In reduced-reporting modes, this is the
> + * threshold for proximate-finger movement in the direction parallel to the
> + * Z-axis.
> + */
> +union f11_2d_ctrl22_26 {
> +	struct {
> +		/* control 22 */
> +		bool proximity_detect_int_en:1;
> +		bool proximity_jitter_filter_en:1;
> +		u8 f11_2d_ctrl6_b3__7:6;
> +
> +		/* control 23 */
> +		u8 proximity_detection_z_threshold;
> +
> +		/* control 24 */
> +		u8 proximity_delta_x_threshold;
> +
> +		/* control 25 */
> +		u8 proximity_delta_y_threshold;
> +
> +		/* control 26 */
> +		u8 proximity_delta_z_threshold;
> +	} __attribute__((__packed__));
> +	u8 regs[5];
> +};
> +
> +/**
> + * @palm_detecy_sensitivity - When this value is small, smaller objects will
> + * be identified as palms; when this value is large, only larger objects will
> + * be identified as palms. 0 represents the factory default.
> + * @suppress_on_palm_detect - when set, all F11 interrupts except palm_detect
> + * are suppressed while a palm is detected.
> + */
> +union f11_2d_ctrl27 {
> +	struct {
> +		s8 palm_detect_sensitivity:4;
> +		bool suppress_on_palm_detect:1;
> +		u8 f11_2d_ctrl27_b5__7:3;
> +	} __attribute__((__packed__));
> +	u8 regs[1];
> +};
> +
> +/**
> + * @multi_finger_scroll_mode - allows choice of multi-finger scroll mode and
> + * determines whether and how X or Y displacements are reported.
> + * @edge_motion_en - enables the edge_motion feature.
> + * @multi_finger_scroll_momentum - controls the length of time that scrolling
> + * continues after fingers have been lifted.
> + */
> +union f11_2d_ctrl28 {
> +	struct {
> +		u8 multi_finger_scroll_mode:2;
> +		bool edge_motion_en:1;
> +		bool f11_2d_ctrl28b_3:1;
> +		u8 multi_finger_scroll_momentum:4;
> +	} __attribute__((__packed__));
> +	u8 regs[1];
> +};
> +
> +/**
> + * @z_touch_threshold - Specifies the finger-arrival Z threshold. Large values
> + * may cause smaller fingers to be rejected.
> + * @z_touch_hysteresis - Specifies the difference between the finger-arrival
> + * Z threshold and the finger-departure Z threshold.
> + */
> +union f11_2d_ctrl29_30 {
> +	struct {
> +		u8 z_touch_threshold;
> +		u8 z_touch_hysteresis;
> +	} __attribute__((__packed__));
> +	struct {
> +		u8 regs[2];
> +		u16 address;
> +	} __attribute__((__packed__));
> +};
> +
> +
> +struct  f11_2d_ctrl {
> +	union f11_2d_ctrl0_9 *ctrl0_9;
> +	union f11_2d_ctrl10		*ctrl10;
> +	union f11_2d_ctrl11		*ctrl11;
> +	union f11_2d_ctrl12		*ctrl12;
> +	u8				ctrl12_size;
> +	union f11_2d_ctrl14		*ctrl14;
> +	union f11_2d_ctrl15		*ctrl15;
> +	union f11_2d_ctrl16		*ctrl16;
> +	union f11_2d_ctrl17		*ctrl17;
> +	union f11_2d_ctrl18_19		*ctrl18_19;
> +	union f11_2d_ctrl20_21		*ctrl20_21;
> +	union f11_2d_ctrl22_26 *ctrl22_26;
> +	union f11_2d_ctrl27 *ctrl27;
> +	union f11_2d_ctrl28 *ctrl28;
> +	union f11_2d_ctrl29_30 *ctrl29_30;
> +};

Will any of this data be used at all?

> +
> +/**
> + * @x_msb - top 8 bits of X finger position.
> + * @y_msb - top 8 bits of Y finger position.
> + * @x_lsb - bottom 4 bits of X finger position.
> + * @y_lsb - bottom 4 bits of Y finger position.
> + * @w_y - contact patch width along Y axis.
> + * @w_x - contact patch width along X axis.
> + * @z - finger Z value (proxy for pressure).
> + */
> +struct f11_2d_data_1_5 {
> +	u8 x_msb;
> +	u8 y_msb;
> +	u8 x_lsb:4;
> +	u8 y_lsb:4;
> +	u8 w_y:4;
> +	u8 w_x:4;
> +	u8 z;
> +};
> +
> +/**
> + * @delta_x - relative motion along X axis.
> + * @delta_y - relative motion along Y axis.
> + */
> +struct f11_2d_data_6_7 {
> +	s8 delta_x;
> +	s8 delta_y;
> +};
> +
> +/**
> + * @single_tap - a single tap was recognized.
> + * @tap_and_hold - a tap-and-hold gesture was recognized.
> + * @double_tap - a double tap gesture was recognized.
> + * @early_tap - a tap gesture might be happening.
> + * @flick - a flick gesture was detected.
> + * @press - a press gesture was recognized.
> + * @pinch - a pinch gesture was detected.
> + */
> +struct f11_2d_data_8 {
> +	bool single_tap:1;
> +	bool tap_and_hold:1;
> +	bool double_tap:1;
> +	bool early_tap:1;
> +	bool flick:1;
> +	bool press:1;
> +	bool pinch:1;
> +};
> +
> +/**
> + * @palm_detect - a palm or other large object is in contact with the sensor.
> + * @rotate - a rotate gesture was detected.
> + * @shape - a TouchShape has been activated.
> + * @scrollzone - scrolling data is available.
> + * @finger_count - number of fingers involved in the reported gesture.
> + */
> +struct f11_2d_data_9 {
> +	bool palm_detect:1;
> +	bool rotate:1;
> +	bool shape:1;
> +	bool scrollzone:1;
> +	u8 finger_count:3;
> +};
> +
> +/**
> + * @pinch_motion - when a pinch gesture is detected, this is the change in
> + * distance between the two fingers since this register was last read.
> + */
> +struct f11_2d_data_10 {
> +	s8 pinch_motion;
> +};
> +
> +/**
> + * @x_flick_dist - when a flick gesture is detected,  the distance of flick
> + * gesture in X direction.
> + * @y_flick_dist - when a flick gesture is detected,  the distance of flick
> + * gesture in Y direction.
> + * @flick_time - the total time of the flick gesture, in 10ms units.
> + */
> +struct f11_2d_data_10_12 {
> +	s8 x_flick_dist;
> +	s8 y_flick_dist;
> +	u8 flick_time;
> +};
> +
> +/**
> + * @motion - when a rotate gesture is detected, the accumulated distance
> + * of the rotate motion. Clockwise motion is positive and counterclockwise
> + * motion is negative.
> + * @finger_separation - when a rotate gesture is detected, the distance
> + * between the fingers.
> + */
> +struct f11_2d_data_11_12 {
> +	s8 motion;
> +	u8 finger_separation;
> +};
> +
> +/**
> + * @shape_n - a bitmask of the currently activate TouchShapes (if any).
> + */
> +struct f11_2d_data_13 {
> +	u8 shape_n;
> +};
> +
> +/**
> + * @horizontal - chiral scrolling distance in the X direction.
> + * @vertical - chiral scrolling distance in the Y direction.
> + */
> +struct f11_2d_data_14_15 {
> +	s8 horizontal;
> +	s8 vertical;
> +};
> +
> +/**
> + * @x_low - scroll zone motion along the lower edge of the sensor.
> + * @y_right - scroll zone motion along the right edge of the sensor.
> + * @x_upper - scroll zone motion along the upper edge of the sensor.
> + * @y_left - scroll zone motion along the left edge of the sensor.
> + */
> +struct f11_2d_data_14_17 {
> +	s8 x_low;
> +	s8 y_right;
> +	s8 x_upper;
> +	s8 y_left;
> +};
> +
> +struct f11_2d_data {
> +	u8				*f_state;
> +	const struct f11_2d_data_1_5	*abs_pos;
> +	const struct f11_2d_data_6_7	*rel_pos;
> +	const struct f11_2d_data_8	*gest_1;
> +	const struct f11_2d_data_9	*gest_2;
> +	const struct f11_2d_data_10	*pinch;
> +	const struct f11_2d_data_10_12	*flick;
> +	const struct f11_2d_data_11_12	*rotate;
> +	const struct f11_2d_data_13	*shapes;
> +	const struct f11_2d_data_14_15	*multi_scroll;
> +	const struct f11_2d_data_14_17	*scroll_zones;
> +};
> +
> +struct f11_2d_sensor {
> +	struct rmi_f11_2d_axis_alignment axis_align;
> +	struct f11_2d_sensor_query sens_query;
> +	struct f11_2d_data data;
> +	int prev_x[F11_MAX_NUM_OF_FINGERS];
> +	int prev_y[F11_MAX_NUM_OF_FINGERS];
> +	u16 max_x;
> +	u16 max_y;
> +	u8 nbr_fingers;
> +	u8 finger_tracker[F11_MAX_NUM_OF_FINGERS];
> +	u8 *data_pkt;
> +	int pkt_size;
> +	u8 sensor_index;
> +	u8 *button_map;
> +	struct rmi_f11_virtualbutton_map virtual_buttons;
> +	bool type_a;
> +	char input_name[MAX_NAME_LENGTH];
> +	char input_phys[MAX_NAME_LENGTH];
> +	struct input_dev *input;
> +	struct input_dev *mouse_input;
> +	struct rmi_function_container *fc;
> +
> +#ifdef CONFIG_RMI4_DEBUG
> +	struct dentry *debugfs_flip;
> +	struct dentry *debugfs_clip;
> +	struct dentry *debugfs_delta_threshold;
> +	struct dentry *debugfs_offset;
> +	struct dentry *debugfs_swap;
> +	struct dentry *debugfs_type_a;
> +#endif
> +};

Up to this point in the file, very little is essential to the input deivce.

> +
> +struct f11_data {
> +	struct f11_2d_device_query dev_query;
> +	struct f11_2d_ctrl dev_controls;
> +	struct mutex dev_controls_mutex;
> +	u16 rezero_wait_ms;
> +	struct f11_2d_sensor sensors[F11_MAX_NUM_OF_SENSORS];
> +
> +#ifdef CONFIG_RMI4_DEBUG
> +	struct dentry *debugfs_rezero_wait;
> +#endif
> +};
> +
> +enum finger_state_values {
> +	F11_NO_FINGER	= 0x00,
> +	F11_PRESENT	= 0x01,
> +	F11_INACCURATE	= 0x02,
> +	F11_RESERVED	= 0x03
> +};
> +
> +/* ctrl sysfs files */
> +show_store_union_struct_prototype(abs_pos_filt)
> +show_store_union_struct_prototype(z_touch_threshold)
> +show_store_union_struct_prototype(z_touch_hysteresis)
> +
> +#ifdef CONFIG_RMI4_DEBUG
> +
> +struct sensor_debugfs_data {
> +	bool done;
> +	struct f11_2d_sensor *sensor;
> +};

And this is really needed?

[...]

> +static void rmi_f11_abs_pos_report(struct f11_data *f11,
> +				   struct f11_2d_sensor *sensor,
> +				   u8 finger_state, u8 n_finger)
> +{
> +	struct f11_2d_data *data = &sensor->data;
> +	struct rmi_f11_2d_axis_alignment *axis_align = &sensor->axis_align;
> +	u8 prev_state = sensor->finger_tracker[n_finger];

No need to keep track of the old state.

> +	int x, y, z;
> +	int w_x, w_y, w_max, w_min, orient;
> +	int temp;
> +
> +	if (prev_state && !finger_state) {
> +		/* this is a release */
> +		x = y = z = w_max = w_min = orient = 0;

This data is not sent during a release.

> +	} else if (!prev_state && !finger_state) {
> +		/* nothing to report */
> +		return;
> +	} else {
> +		x = ((data->abs_pos[n_finger].x_msb << 4) |
> +			data->abs_pos[n_finger].x_lsb);
> +		y = ((data->abs_pos[n_finger].y_msb << 4) |
> +			data->abs_pos[n_finger].y_lsb);
> +		z = data->abs_pos[n_finger].z;
> +		w_x = data->abs_pos[n_finger].w_x;
> +		w_y = data->abs_pos[n_finger].w_y;
> +		w_max = max(w_x, w_y);
> +		w_min = min(w_x, w_y);
> +
> +		if (axis_align->swap_axes) {
> +			temp = x;
> +			x = y;
> +			y = temp;
> +			temp = w_x;
> +			w_x = w_y;
> +			w_y = temp;
> +		}
> +
> +		orient = w_x > w_y ? 1 : 0;
> +
> +		if (axis_align->flip_x)
> +			x = max(sensor->max_x - x, 0);
> +
> +		if (axis_align->flip_y)
> +			y = max(sensor->max_y - y, 0);
> +
> +		/*
> +		** here checking if X offset or y offset are specified is
> +		**  redundant.  We just add the offsets or, clip the values
> +		**
> +		** note: offsets need to be done before clipping occurs,
> +		** or we could get funny values that are outside
> +		** clipping boundaries.
> +		*/
> +		x += axis_align->offset_X;
> +		y += axis_align->offset_Y;
> +		x =  max(axis_align->clip_X_low, x);
> +		y =  max(axis_align->clip_Y_low, y);
> +		if (axis_align->clip_X_high)
> +			x = min(axis_align->clip_X_high, x);
> +		if (axis_align->clip_Y_high)
> +			y =  min(axis_align->clip_Y_high, y);

Why is the clipping configurable?

> +
> +	}
> +
> +	/* Some UIs ignore W of zero, so we fudge it to 1 for pens. */
> +	if (IS_ENABLED(CONFIG_RMI4_F11_PEN) &&
> +			get_tool_type(sensor, finger_state) == MT_TOOL_PEN) {
> +		w_max = max(1, w_max);
> +		w_min = max(1, w_min);
> +	}

Is this not true for all tool types?

> +
> +	if (sensor->type_a) {
> +		input_report_abs(sensor->input, ABS_MT_TRACKING_ID, n_finger);
> +		input_report_abs(sensor->input, ABS_MT_TOOL_TYPE,
> +					get_tool_type(sensor, finger_state));
> +	} else {
> +		input_mt_slot(sensor->input, n_finger);
> +		input_mt_report_slot_state(sensor->input,
> +			get_tool_type(sensor, finger_state), finger_state);
> +	}

The driver should only report MT-B, please.

> +	input_report_abs(sensor->input, ABS_MT_PRESSURE, z);
> +	input_report_abs(sensor->input, ABS_MT_TOUCH_MAJOR, w_max);
> +	input_report_abs(sensor->input, ABS_MT_TOUCH_MINOR, w_min);
> +	input_report_abs(sensor->input, ABS_MT_ORIENTATION, orient);
> +	input_report_abs(sensor->input, ABS_MT_POSITION_X, x);
> +	input_report_abs(sensor->input, ABS_MT_POSITION_Y, y);

Only if finger_state is true.

> +	dev_dbg(&sensor->fc->dev,
> +		"finger[%d]:%d - x:%d y:%d z:%d w_max:%d w_min:%d\n",
> +		n_finger, finger_state, x, y, z, w_max, w_min);
> +	/* MT sync between fingers */
> +	if (sensor->type_a)
> +		input_mt_sync(sensor->input);
> +
> +	sensor->finger_tracker[n_finger] = finger_state;
> +}
> +
> +#ifdef CONFIG_RMI4_VIRTUAL_BUTTON
> +static int rmi_f11_virtual_button_handler(struct f11_2d_sensor *sensor)
> +{
> +	int i;
> +	int x;
> +	int y;
> +	struct rmi_button_map *virtualbutton_map;
> +
> +	if (sensor->sens_query.has_gestures &&
> +				sensor->data.gest_1->single_tap) {
> +		virtualbutton_map = &sensor->virtualbutton_map;
> +		x = ((sensor->data.abs_pos[0].x_msb << 4) |
> +			sensor->data.abs_pos[0].x_lsb);
> +		y = ((sensor->data.abs_pos[0].y_msb << 4) |
> +			sensor->data.abs_pos[0].y_lsb);
> +		for (i = 0; i < virtualbutton_map->buttons; i++) {
> +			if (INBOX(x, y, virtualbutton_map->map[i])) {
> +				input_report_key(sensor->input,
> +					virtualbutton_map->map[i].code, 1);
> +				input_report_key(sensor->input,
> +					virtualbutton_map->map[i].code, 0);
> +				input_sync(sensor->input);
> +				return 0;
> +			}
> +		}
> +	}
> +	return 0;
> +}
> +#else
> +#define rmi_f11_virtual_button_handler(sensor)
> +#endif

No virtual buttons, please, this can easily be mapped in userspace.

> +static void rmi_f11_finger_handler(struct f11_data *f11,
> +				   struct f11_2d_sensor *sensor)
> +{
> +	const u8 *f_state = sensor->data.f_state;
> +	u8 finger_state;
> +	u8 finger_pressed_count;
> +	u8 i;
> +
> +	for (i = 0, finger_pressed_count = 0; i < sensor->nbr_fingers; i++) {
> +		/* Possible of having 4 fingers per f_statet register */
> +		finger_state = GET_FINGER_STATE(f_state, i);
> +
> +		if (finger_state == F11_RESERVED) {
> +			pr_err("%s: Invalid finger state[%d]:0x%02x.", __func__,
> +					i, finger_state);
> +			continue;
> +		} else if ((finger_state == F11_PRESENT) ||
> +				(finger_state == F11_INACCURATE)) {
> +			finger_pressed_count++;
> +		}
> +
> +		if (sensor->data.abs_pos)
> +			rmi_f11_abs_pos_report(f11, sensor, finger_state, i);
> +
> +		if (sensor->data.rel_pos)
> +			rmi_f11_rel_pos_report(sensor, i);
> +	}
> +	input_report_key(sensor->input, BTN_TOUCH, finger_pressed_count);

Please use input_mt_sync_frame() here instead.

> +	input_sync(sensor->input);
> +}

Stopping here.

Thanks,
Henrik
