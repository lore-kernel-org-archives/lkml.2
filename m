Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2JKEop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:44:45 -0400
Received: from us-mx3.synaptics.com ([12.239.217.85]:62092 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2JKEon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:44:43 -0400
X-PGP-Universal: processed;
	by securemail.synaptics.com on Wed, 10 Oct 2012 21:11:46 -0700
From: Christopher Heiny <Cheiny@synaptics.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>
Subject: RE: [RFC PATCH 06/06] input/rmi4: F11 - 2D touch interface
Thread-Topic: [RFC PATCH 06/06] input/rmi4: F11 - 2D touch interface
Thread-Index: AQHNo3jH7X0/bj3lFU6s4YKgIGAOo5exOOqAgAJWk6Q=
Date: Thu, 11 Oct 2012 04:46:39 +0000
Message-ID: <BFABBC009FBA1C43B207B15FD485ABD922C22C9D@USW-MAIL1.synaptics-inc.local>
References: <1349496603-20775-1-git-send-email-cheiny@synaptics.com>
	<1349496603-20775-7-git-send-email-cheiny@synaptics.com>,<CACRpkdbjgnH=FCyKfQEYo+fNOj0aDM7z+CX6z3SKpRRUGyx3tQ@mail.gmail.com>
In-Reply-To: <CACRpkdbjgnH=FCyKfQEYo+fNOj0aDM7z+CX6z3SKpRRUGyx3tQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.10.35]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> On Sat, Oct 6, 2012 at 6:10 AM, Christopher Heiny <cheiny@synaptics.com>
> wrote:
> 
> So looking closer at this one since we will use it. Maybe it's in such a
> good shape now that I should be able to actually test it with the hardware?

Well, it's been possible to test at least since the patch submitted last December.  The code might have been ugly, but it was working.

> 
> (...)
> 
> > diff --git a/drivers/input/rmi4/rmi_f11.c b/drivers/input/rmi4/rmi_f11.c

[snip previously mentioned stuff]

> 
> > +#define F11_CTRL_SENSOR_MAX_X_POS_OFFSET       6
> > +#define F11_CTRL_SENSOR_MAX_Y_POS_OFFSET       8
> > +
> > +#define F11_CEIL(x, y) (((x) + ((y)-1)) / (y))
> 
> Use existing kernel macros in <linux/kernel.h>
> 
> In this case:
> #define F11_CEIL(x, y) DIV_ROUND_UP(x, y)
> 
> Or just use DIV_ROUND_UP() directly in the code, your choice.

Use it directly is simpler.

> 
> > +#define MAX_NAME_LENGTH 256
> 
> Really? Are you sure there is not a null terminator or length byte
> included so it's actually 255?

We were assuming 255 + terminator.  Perhaps a better name such as NAME_BUFFER_SIZE would be clearer?


> 
> (...)
> 
> > +static int sensor_debug_open(struct inode *inodep, struct file *filp)
> > +{
> > +       struct sensor_debugfs_data *data;
> > +       struct f11_2d_sensor *sensor = inodep->i_private;
> > +       struct rmi_function_container *fc = sensor->fc;
> > +
> > +       data = devm_kzalloc(&fc->dev, sizeof(struct sensor_debugfs_data),
> > +               GFP_KERNEL);
> 
> Again I may have lead you astray. Check if this leaks memory, in that
> case use kzalloc()/kfree(). Sorry

No problem - will correct it.

> 
> (...)
> 
> > +static int f11_debug_open(struct inode *inodep, struct file *filp)
> > +{
> > +       struct f11_debugfs_data *data;
> > +       struct rmi_function_container *fc = inodep->i_private;
> > +
> > +       data = devm_kzalloc(&fc->dev, sizeof(struct f11_debugfs_data),
> > +               GFP_KERNEL);
> 
> Dito.
> 
> (...)
> 
> > +static void rmi_f11_abs_pos_report(struct f11_data *f11,
> > +                                  struct f11_2d_sensor *sensor,
> > +                                  u8 finger_state, u8 n_finger)
> 
> (...)
> 
> > +               if (axis_align->flip_y)
> > +                       y = max(sensor->max_y - y, 0);
> > +
> > +               /*
> > +               ** here checking if X offset or y offset are specified is
> > +               **  redundant.  We just add the offsets or, clip the
> > values
> > +               **
> > +               ** note: offsets need to be done before clipping occurs,
> > +               ** or we could get funny values that are outside
> > +               ** clipping boundaries.
> > +               */
> 
> This is a weird commenting style, what's wrong with a single star?
> (No big deal but it stands out...)

It's probably just someone's editor settings.  We can tidy it up.

> 
> (...)
> 
> > +static int f11_allocate_control_regs(struct rmi_device *rmi_dev,
> > +                               struct f11_2d_device_query *device_query,
> > +                               struct f11_2d_sensor_query *sensor_query,
> > +                               struct f11_2d_ctrl *ctrl,
> > +                               u16 ctrl_base_addr) {
> > +
> > +       struct rmi_driver_data *driver_data =
> > dev_get_drvdata(&rmi_dev->dev); +       struct rmi_function_container *fc
> > = driver_data->f01_container; +
> > +       ctrl->ctrl0_9 = devm_kzalloc(&fc->dev, sizeof(union
> > f11_2d_ctrl0_9), +                                      GFP_KERNEL);
> 
> If this is called from .probe() only, this is correct.
> 
> So the rule is: use devm_* for anything that is allocated at .probe()
> and released on .remove(). Any other dynamic buffers etc need to
> use common kzalloc()/kfree().

OK - we'll review to make sure that rule is followed, and change as required.

[snip a bunch of the same]

> 
> > +
> > +       return f11_read_control_regs(rmi_dev, ctrl, ctrl_base_addr);
> 
> Hey why are you ending with a call to that function?
> The function name gets misleading.
> 
> Instead call both functions in succession at the call site on
> .probe().

OK.


> 
> (...)
> 
> > +static int f11_device_init(struct rmi_function_container *fc)
> > +{
> > +       int rc;
> > +
> > +       rc = rmi_f11_initialize(fc);
> > +       if (rc < 0)
> > +               goto err_free_data;
> > +
> > +       rc = rmi_f11_register_devices(fc);
> > +       if (rc < 0)
> > +               goto err_free_data;
> > +
> > +       rc = rmi_f11_create_sysfs(fc);
> > +       if (rc < 0)
> > +               goto err_free_data;
> > +
> > +       return 0;
> > +
> > +err_free_data:
> > +       rmi_f11_free_memory(fc);
> > +
> > +       return rc;
> > +}
> > +
> > +static void rmi_f11_free_memory(struct rmi_function_container *fc)
> > +{
> > +       struct f11_data *f11 = fc->data;
> > +       int i;
> > +
> > +       if (f11) {
> > +               for (i = 0; i < f11->dev_query.nbr_of_sensors + 1; i++)
> > +                       kfree(f11->sensors[i].button_map);
> > +       }
> 
> This is wrong. The button_map was allocated with devm_kzalloc()
> so it will get automatically freed. Just skip this step.

We'll correct that.

> 
> (...)
> 
> > +static int rmi_f11_initialize(struct rmi_function_container *fc)
> > +{
> 
> (...)
> 
> > +               rc = f11_allocate_control_regs(rmi_dev,
> > +                               &f11->dev_query, &sensor->sens_query,
> > +                               &f11->dev_controls, control_base_addr);
> > +               if (rc < 0) {
> > +                       dev_err(&fc->dev,
> > +                               "Failed to initialize F11 control
> > params.\n");
> "failed to allocate F11 control params"
> 
> > +                       return rc;
> > +               }
> 
> So after this call the read regs explicitly instead as described above.

OK

> 
> (...)
> 
> > +static void register_virtual_buttons(struct rmi_function_container *fc,
> > +                                    struct f11_2d_sensor *sensor) {
> > +       int j;
> > +
> > +       if (!sensor->sens_query.has_gestures)
> > +               return;
> > +       if (!sensor->virtual_buttons.buttons) {
> > +               dev_warn(&fc->dev, "No virtual button platform data for 2D
> > sensor %d.\n", +                        sensor->sensor_index);
> > +               return;
> > +       }
> > +       /* call devm_kcalloc when it will be defined in kernel */
> > +       sensor->button_map = devm_kzalloc(&fc->dev,
> > +                       sensor->virtual_buttons.buttons,
> > +                       GFP_KERNEL);
> > +       if (!sensor->button_map) {
> > +               dev_err(&fc->dev, "Failed to allocate the virtual button
> > map.\n"); +               return;
> > +       }
> 
> So as noted above, since it's using devm_kzalloc(), don't free() it.

OK.

> 
> (...)
> 
> > +                       sensor->mouse_input = input_dev_mouse;
> > +                       input_dev_mouse->name = "rmi_mouse";
> > +                       input_dev_mouse->phys = "rmi_f11/input0";
> > +
> > +                       input_dev_mouse->id.vendor  = 0x18d1;
> > +                       input_dev_mouse->id.product = 0x0210;
> > +                       input_dev_mouse->id.version = 0x0100;
> 
> As noted in previous review, 0x18d1 is Google's vendor ID. Please use
> a Synaptics Vendor ID, Product ID and version!
> 
> Hint: synaptics Vendor ID is 0x06cb.

That's kind of embarrassing.  We'll fix it.