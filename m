Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2H0Wue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:50:34 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54977 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2H0Wuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 18:50:32 -0400
MIME-Version: 1.0
In-Reply-To: <1345241877-16200-10-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
	<1345241877-16200-10-git-send-email-cheiny@synaptics.com>
Date: Mon, 27 Aug 2012 15:50:30 -0700
Message-ID: <CACRpkdZQqmeCc9bk86N2kE7383r_xSYkXSJ0MZfYjXZP5kYg4Q@mail.gmail.com>
Subject: Re: [RFC PATCH 9/17] input: RMI4 F11 multitouch sensing
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Henrik Rydberg <rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should definately be reviewed by Henrik Rydberg so include him on
the next iteration.

On Fri, Aug 17, 2012 at 3:17 PM, Christopher Heiny <cheiny@synaptics.com> wrote:

Verbose description of what the patch does please.

(...)
> +++ b/drivers/input/rmi4/rmi_f11.c
(...)
> +#ifdef CONFIG_RMI4_F11_TYPEB
> +#include <linux/mt.h>
> +#endif

It doesn't *HURT* if you include one file to many so
just skip the #ifdef.

> +#include <linux/rmi.h>
> +#include "rmi_driver.h"
> +
> +#ifdef CONFIG_RMI4_DEBUG

Same here, just leave all headers in, skip the #ifdef

> +#include <linux/debugfs.h>
> +#include <linux/fs.h>
> +/*#include <asm/uaccess.h> */

Delete that line

> +#include <linux/uaccess.h>
> +#endif
> +
> +#define RESUME_REZERO (1 && defined(CONFIG_PM))
> +#if RESUME_REZERO
> +#include <linux/delay.h>
> +#define DEFAULT_REZERO_WAIT_MS 40
> +#endif

Dito.

> +#define GET_FINGER_STATE(f_states, i) \
> +       ((f_states[i / 4] >> (2 * (i % 4))) & FINGER_STATE_MASK)

Convert to a static inline function.

> +#define INBOX(x, y, box) (x >= box.x && x < (box.x + box.width) \
> +                       && y >= box.y && y < (box.y + box.height))

Dito.

> +/* Adding debugfs for flip, clip, offset and swap */
> +#ifdef CONFIG_RMI4_DEBUG
> +
> +static int setup_debugfs(struct rmi_device *rmi_dev);
> +static void teardown_debugfs(struct rmi_device *rmi_dev);
> +#endif
> +/* End adding debugfs */

Better to depend on CONFIG_DEBUG_FS

(...)
> +#if RESUME_REZERO

This RESUME_REZERO business scares me off. First it should
be a Kconfig thing, and why is it optional? Also put in a comment
explaining what it's all about.

> +static struct device_attribute attrs[] = {
> +       __ATTR(relreport, RMI_RW_ATTR, f11_relreport_show, f11_relreport_store),
> +       __ATTR(maxPos, RMI_RO_ATTR, f11_maxPos_show, rmi_store_error),
> +#if RESUME_REZERO
> +       __ATTR(rezeroOnResume, RMI_RW_ATTR, f11_rezeroOnResume_show,
> +               f11_rezeroOnResume_store),
> +       __ATTR(rezeroWait, RMI_RW_ATTR, f11_rezeroWait_show,
> +               f11_rezeroWait_store),
> +#endif
> +       __ATTR(rezero, RMI_WO_ATTR, rmi_show_error, f11_rezero_store)
> +};

Documentation/ABI/testing/* needs these, plus consider moving some
of these to debugfs.

> +union f11_2d_commands {
> +       struct {
> +               u8 rezero:1;
> +       };
> +       u8 reg;

Now I think I can see what you're trying to do. The .reg
is just there to make sure this thing is padded to 8 bits right?

__attribute__((packed)); ?

> +struct f11_2d_device_query {
> +       union {
> +               struct {
> +                       u8 nbr_of_sensors:3;
> +                       u8 has_query9:1;
> +                       u8 has_query11:1;
> +               };
> +               u8 f11_2d_query0;
> +       };
> +
> +       union {
> +               struct {
> +                       u8 has_z_tuning:1;
> +                       u8 has_pos_interpolation_tuning:1;
> +                       u8 has_w_tuning:1;
> +                       u8 has_pitch_info:1;
> +                       u8 has_default_finger_width:1;
> +                       u8 has_segmentation_aggressiveness:1;
> +                       u8 has_tx_rw_clip:1;
> +                       u8 has_drumming_correction:1;
> +               };
> +               u8 f11_2d_query11;
> +       };
> +};

__attribute__((packed)); ?

> +union f11_2d_query9 {
> +       struct {
> +               u8 has_pen:1;
> +               u8 has_proximity:1;
> +               u8 has_palm_det_sensitivity:1;
> +               u8 has_suppress_on_palm_detect:1;
> +               u8 has_two_pen_thresholds:1;
> +               u8 has_contact_geometry:1;
> +       };
> +       u8 reg;
> +};

__attribute__((packed)); ?

> +struct f11_2d_sensor_query {
> +       union {
> +               struct {
> +                       /* query1 */
> +                       u8 number_of_fingers:3;
> +                       u8 has_rel:1;
> +                       u8 has_abs:1;
> +                       u8 has_gestures:1;
> +                       u8 has_sensitivity_adjust:1;
> +                       u8 configurable:1;
> +                       /* query2 */
> +                       u8 num_of_x_electrodes:7;
> +                       /* query3 */
> +                       u8 num_of_y_electrodes:7;
> +                       /* query4 */
> +                       u8 max_electrodes:7;
> +               };
> +               u8 f11_2d_query1__4[4];
> +       };
> +
> +       union {
> +               struct {
> +                       u8 abs_data_size:3;
> +                       u8 has_anchored_finger:1;
> +                       u8 has_adj_hyst:1;
> +                       u8 has_dribble:1;
> +               };
> +               u8 f11_2d_query5;
> +       };
> +
> +       u8 f11_2d_query6;
> +
> +       union {
> +               struct {
> +                       u8 has_single_tap:1;
> +                       u8 has_tap_n_hold:1;
> +                       u8 has_double_tap:1;
> +                       u8 has_early_tap:1;
> +                       u8 has_flick:1;
> +                       u8 has_press:1;
> +                       u8 has_pinch:1;
> +                       u8 padding:1;
> +
> +                       u8 has_palm_det:1;
> +                       u8 has_rotate:1;
> +                       u8 has_touch_shapes:1;
> +                       u8 has_scroll_zones:1;
> +                       u8 has_individual_scroll_zones:1;
> +                       u8 has_multi_finger_scroll:1;
> +               };
> +               u8 f11_2d_query7__8[2];
> +       };
> +
> +       union f11_2d_query9 query9;
> +
> +       union {
> +               struct {
> +                       u8 nbr_touch_shapes:5;
> +               };
> +               u8 f11_2d_query10;
> +       };
> +};

__attribute__((packed)); ?

> +union f11_2d_ctrl0_9 {
> +       struct {
> +               /* F11_2D_Ctrl0 */
> +               u8 reporting_mode:3;
> +               u8 abs_pos_filt:1;
> +               u8 rel_pos_filt:1;
> +               u8 rel_ballistics:1;
> +               u8 dribble:1;
> +               u8 report_beyond_clip:1;
> +               /* F11_2D_Ctrl1 */
> +               u8 palm_detect_thres:4;
> +               u8 motion_sensitivity:2;
> +               u8 man_track_en:1;
> +               u8 man_tracked_finger:1;
> +               /* F11_2D_Ctrl2 and 3 */
> +               u8 delta_x_threshold:8;
> +               u8 delta_y_threshold:8;
> +               /* F11_2D_Ctrl4 and 5 */
> +               u8 velocity:8;
> +               u8 acceleration:8;
> +               /* F11_2D_Ctrl6 thru 9 */
> +               u16 sensor_max_x_pos:12;
> +               u8 ctrl7_reserved:4;
> +               u16 sensor_max_y_pos:12;
> +               u8 ctrl9_reserved:4;
> +       };
> +       struct {
> +               u8 regs[10];
> +               u16 address;
> +       };
> +};

__attribute__((packed)); ?

> +union f11_2d_ctrl10 {
> +       struct {
> +               u8 single_tap_int_enable:1;
> +               u8 tap_n_hold_int_enable:1;
> +               u8 double_tap_int_enable:1;
> +               u8 early_tap_int_enable:1;
> +               u8 flick_int_enable:1;
> +               u8 press_int_enable:1;
> +               u8 pinch_int_enable:1;
> +       };
> +       u8 reg;
> +};

__attribute__((packed)); ?

> +union f11_2d_ctrl11 {
> +       struct {
> +               u8 palm_detect_int_enable:1;
> +               u8 rotate_int_enable:1;
> +               u8 touch_shape_int_enable:1;
> +               u8 scroll_zone_int_enable:1;
> +               u8 multi_finger_scroll_int_enable:1;
> +       };
> +       u8 reg;
> +};

__attribute__((packed)); ?

> +union f11_2d_ctrl12 {
> +       struct {
> +               u8 sensor_map:7;
> +               u8 xy_sel:1;
> +       };
> +       u8 reg;
> +};

__attribute__((packed)); ?

> +union f11_2d_ctrl14 {
> +       struct {
> +               u8 sens_adjustment:5;
> +               u8 hyst_adjustment:3;
> +       };
> +       u8 reg;
> +};

__attribute__((packed)); ?

> +union f11_2d_ctrl15 {
> +       struct {
> +               u8 max_tap_time:8;
> +       };
> +       u8 reg;
> +};

__attribute__((packed)); ?

> +union f11_2d_ctrl16 {
> +       struct {
> +               u8 min_press_time:8;
> +       };
> +       u8 reg;
> +};

__attribute__((packed)); ?

> +union f11_2d_ctrl17 {
> +       struct {
> +               u8 max_tap_distance:8;
> +       };
> +       u8 reg;
> +};

__attribute__((packed)); ?

> +union f11_2d_ctrl18_19 {
> +       struct {
> +               u8 min_flick_distance:8;
> +               u8 min_flick_speed:8;
> +       };
> +       u8 reg[2];
> +};

__attribute__((packed)); ?

> +union f11_2d_ctrl20_21 {
> +       struct {
> +               u8 pen_detect_enable:1;
> +               u8 pen_jitter_filter_enable:1;
> +               u8 ctrl20_reserved:6;
> +               u8 pen_z_threshold:8;
> +       };
> +       u8 reg[2];
> +};

__attribute__((packed)); ?

> +/* These are not accessible through sysfs yet. */
> +union f11_2d_ctrl22_26 {
> +       struct {
> +               /* control 22 */
> +               u8 proximity_detect_int_en:1;
> +               u8 proximity_jitter_filter_en:1;
> +               u8 f11_2d_ctrl6_b3__7:6;
> +
> +               /* control 23 */
> +               u8 proximity_detection_z_threshold;
> +
> +               /* control 24 */
> +               u8 proximity_delta_x_threshold;
> +
> +               /* control 25 */
> +               u8 proximity_delta_y_threshold;
> +
> +               /* control 26 */
> +               u8 proximity_delta_z_threshold;
> +       };
> +       u8 regs[5];
> +};

__attribute__((packed)); ?

> +/* control 27 - haspalmdetectsensitivity or has suppressonpalmdetect */
> +union f11_2d_ctrl27 {
> +       struct {
> +               u8 palm_detecy_sensitivity:4;
> +               u8 suppress_on_palm_detect:1;
> +               u8 f11_2d_ctrl27_b5__7:3;
> +       };
> +       u8 regs[1];
> +};

__attribute__((packed)); ?

> +/* control 28 - has_multifingerscroll */
> +union f11_2d_ctrl28 {
> +       struct {
> +               u8 multi_finger_scroll_mode:2;
> +               u8 edge_motion_en:1;
> +               u8 f11_2d_ctrl28b_3:1;
> +               u8 multi_finger_scroll_momentum:4;
> +       };
> +       u8 regs[1];
> +};

__attribute__((packed)); ?

> +/* control 29 & 30 - hasztuning */
> +union f11_2d_ctrl29_30 {
> +       struct {
> +               u8 z_touch_threshold;
> +               u8 z_touch_hysteresis;
> +       };
> +       struct {
> +               u8 regs[2];
> +               u16 address;
> +       };
> +};

__attribute__((packed)); ?

> +struct  f11_2d_ctrl {
> +       union f11_2d_ctrl0_9 *ctrl0_9;
> +       union f11_2d_ctrl10             *ctrl10;
> +       union f11_2d_ctrl11             *ctrl11;
> +       union f11_2d_ctrl12             *ctrl12;
> +       u8                              ctrl12_size;
> +       union f11_2d_ctrl14             *ctrl14;
> +       union f11_2d_ctrl15             *ctrl15;
> +       union f11_2d_ctrl16             *ctrl16;
> +       union f11_2d_ctrl17             *ctrl17;
> +       union f11_2d_ctrl18_19          *ctrl18_19;
> +       union f11_2d_ctrl20_21          *ctrl20_21;
> +       union f11_2d_ctrl22_26 *ctrl22_26;
> +       union f11_2d_ctrl27 *ctrl27;
> +       union f11_2d_ctrl28 *ctrl28;
> +       union f11_2d_ctrl29_30 *ctrl29_30;
> +};

__attribute__((packed)); ?

> +struct f11_2d_data_1_5 {
> +       u8 x_msb;
> +       u8 y_msb;
> +       u8 x_lsb:4;
> +       u8 y_lsb:4;
> +       u8 w_y:4;
> +       u8 w_x:4;
> +       u8 z;
> +};

__attribute__((packed)); ?

> +struct f11_2d_data_6_7 {
> +       s8 delta_x;
> +       s8 delta_y;
> +};

__attribute__((packed)); ?

> +struct f11_2d_data_8 {
> +       u8 single_tap:1;
> +       u8 tap_and_hold:1;
> +       u8 double_tap:1;
> +       u8 early_tap:1;
> +       u8 flick:1;
> +       u8 press:1;
> +       u8 pinch:1;
> +};

__attribute__((packed)); ?

> +struct f11_2d_data_9 {
> +       u8 palm_detect:1;
> +       u8 rotate:1;
> +       u8 shape:1;
> +       u8 scrollzone:1;
> +       u8 finger_count:3;
> +};

__attribute__((packed)); ?

(...)
> +/* Adding debugfs for flip, clip, offset and swap */
> +#ifdef CONFIG_RMI4_DEBUG

I think this should be just switched on #CONFIG_DEBUG_FS

(...)
> +static int get_tool_type(struct f11_2d_sensor *sensor, u8 finger_state)
> +{
> +#ifdef CONFIG_RMI4_F11_PEN
> +       if (sensor->sens_query.query9.has_pen && finger_state == F11_PEN)
> +               return MT_TOOL_PEN;
> +#endif
> +       return MT_TOOL_FINGER;
> +}

Consider the case where we build a single kernel used on two devices:
one has a pen input and another one has a finger input.

What do you config in your kernel build?

I'm uncertain about the above code, but I hope you can just
define that you want pen support and have both work just
as well.

(...)
> +#ifdef ABS_MT_PRESSURE

Isn't it CONFIG_ABS_MT_PRESSURE?

> +       input_report_abs(sensor->input, ABS_MT_PRESSURE, z);
> +#endif

Henrik will have to answer but why is this optional?

Can't your driver just select ABS_MT_PRESSURE and just always
report this?

> +static int f11_allocate_control_regs(struct rmi_device *rmi_dev,
> +                               struct f11_2d_device_query *device_query,
> +                               struct f11_2d_sensor_query *sensor_query,
> +                               struct f11_2d_ctrl *ctrl,
> +                               u16 ctrl_base_addr) {
> +
> +       int error = 0;
> +       ctrl->ctrl0_9 = kzalloc(sizeof(union f11_2d_ctrl0_9),
> +                                      GFP_KERNEL);
> +       if (!ctrl->ctrl0_9) {
> +               error = -ENOMEM;
> +               goto error_exit;
> +       }
> +       if (sensor_query->f11_2d_query7__8[0]) {
> +               ctrl->ctrl10 = kzalloc(sizeof(union f11_2d_ctrl10),
> +                                      GFP_KERNEL);
> +               if (!ctrl->ctrl10) {
> +                       error = -ENOMEM;
> +                       goto error_exit;
> +               }
> +       }
> +
> +       if (sensor_query->f11_2d_query7__8[1]) {
> +               ctrl->ctrl11 = kzalloc(sizeof(union f11_2d_ctrl11),
> +                                      GFP_KERNEL);
> +               if (!ctrl->ctrl11) {
> +                       error = -ENOMEM;
> +                       goto error_exit;
> +               }
> +       }
> +
> +       if (device_query->has_query9 && sensor_query->query9.has_pen) {
> +               ctrl->ctrl20_21 = kzalloc(sizeof(union f11_2d_ctrl20_21),
> +                                         GFP_KERNEL);
> +               if (!ctrl->ctrl20_21) {
> +                       error = -ENOMEM;
> +                       goto error_exit;
> +               }
> +       }
> +
> +       if (device_query->has_query9 && sensor_query->query9.has_proximity) {
> +               ctrl->ctrl22_26 = kzalloc(sizeof(union f11_2d_ctrl22_26),
> +                                         GFP_KERNEL);
> +               if (!ctrl->ctrl22_26) {
> +                       error = -ENOMEM;
> +                       goto error_exit;
> +               }
> +       }
> +
> +       if (device_query->has_query9 &&
> +               (sensor_query->query9.has_palm_det_sensitivity ||
> +               sensor_query->query9.has_suppress_on_palm_detect)) {
> +               ctrl->ctrl27 = kzalloc(sizeof(union f11_2d_ctrl27),
> +                                         GFP_KERNEL);
> +               if (!ctrl->ctrl27) {
> +                       error = -ENOMEM;
> +                       goto error_exit;
> +               }
> +       }
> +
> +       if (sensor_query->has_multi_finger_scroll) {
> +               ctrl->ctrl28 = kzalloc(sizeof(union f11_2d_ctrl28),
> +                                         GFP_KERNEL);
> +               if (!ctrl->ctrl28) {
> +                       error = -ENOMEM;
> +                       goto error_exit;
> +               }
> +       }
> +
> +       if (device_query->has_query11 && device_query->has_z_tuning) {
> +               ctrl->ctrl29_30 = kzalloc(sizeof(union f11_2d_ctrl29_30),
> +                                         GFP_KERNEL);
> +               if (!ctrl->ctrl29_30) {
> +                       error = -ENOMEM;
> +                       goto error_exit;
> +               }
> +       }
> +
> +       return f11_read_control_regs(rmi_dev, ctrl, ctrl_base_addr);
> +
> +error_exit:
> +       f11_free_control_regs(ctrl);
> +       return error;
> +}

Can't you use devm_kzalloc() for all of these and move them to the call
site?

(...)
> +static int rmi_f11_get_query_parameters(struct rmi_device *rmi_dev,
> +                       struct f11_2d_sensor_query *query, u16 query_base_addr)
> +{
> +       if (query->has_abs) {
(...)
> +       if (query->has_rel) {
(...)
> +       if (query->has_gestures) {
(...)
> +       if (query->has_touch_shapes) {
(...)

This runtime construct is really nice.

> +static void rmi_f11_free_memory(struct rmi_function_container *fc)
> +{
> +       struct f11_data *f11 = fc->data;
> +       int i;
> +
> +       if (f11) {
> +               f11_free_control_regs(&f11->dev_controls);
> +               for (i = 0; i < f11->dev_query.nbr_of_sensors + 1; i++)
> +                       kfree(f11->sensors[i].virtualbutton_map.map);
> +               kfree(f11);
> +               fc->data = NULL;
> +       }
> +}

So with devm* allocators you can cut down on this.

(...)
> +                       /* set bits for each button... */
> +                       for (j = 0; j < vm_pdata->buttons; j++) {
> +                               memcpy(&vm_sensor->map[j], &vm_pdata->map[j],
> +                                       sizeof(struct virtualbutton_map));
> +                               set_bit(vm_sensor->map[j].code,
> +                                       f11->sensors[i].input->keybit);

Hm here you are using the nice bitops set_bit whereas other code isn't...

> +                       f11->sensors[i].mouse_input = input_dev_mouse;
> +                       input_dev_mouse->name = "rmi_mouse";
> +                       input_dev_mouse->phys = "rmi_f11/input0";
> +
> +                       input_dev_mouse->id.vendor  = 0x18d1;

Describe magic numbers.

18d1 is particularly strange since in usb.ids this is Google Inc.

I think you would want to use 0x06cb (Synaptics)

I always was under the impression that USB, PCI (etc) IDs were
in the same number registry since they are often the same.

> +                       input_dev_mouse->id.product = 0x0210;

Usually some company-assigned person managed these numbers for e.g.
USB and PCI. Please check with her/him what to use here if possible.

(---)
> +#if    RESUME_REZERO

#ifdef?

> +#if defined(CONFIG_HAS_EARLYSUSPEND) && \
> +                       !defined(CONFIG_RMI4_SPECIAL_EARLYSUSPEND)
> +       .late_resume = rmi_f11_resume

Funny Android stuff... not supported.

Yours,
Linus Walleij
