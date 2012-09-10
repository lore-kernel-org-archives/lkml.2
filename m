Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622Ab2IJMPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:15:44 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1246 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab2IJMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:15:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH] media: v4l2-ctrl: add a helper fucntion to modify the menu
Date: Mon, 10 Sep 2012 14:13:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc3-tschai; KDE/4.8.4; x86_64; ; )
Cc: LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        linux-kernel@vger.kernel.org, Manjunath Hadli <manjunath.hadli@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-doc@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Landley <rob@landley.net>
References: <1347278256-4560-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1347278256-4560-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209101413.12955.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon September 10 2012 13:57:36 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Rob Landley <rob@landley.net>
> ---
>  Documentation/video4linux/v4l2-controls.txt |   26 +++++++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-ctrls.c        |   28 +++++++++++++++++++++++++++
>  include/media/v4l2-ctrls.h                  |   14 +++++++++++++
>  3 files changed, 68 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
> index 43da22b..54a9539 100644
> --- a/Documentation/video4linux/v4l2-controls.txt
> +++ b/Documentation/video4linux/v4l2-controls.txt
> @@ -196,6 +196,32 @@ the error code at the end. Saves a lot of repetitive error checking.
>  It is recommended to add controls in ascending control ID order: it will be
>  a bit faster that way.
>  
> +2.1) Changing the menu of a standard control:
> +There are suitations when the control is standard but the menu items may be
> +device specific, in such cases the framework provides the helper to do that.

The "Menu Controls" section in this file would be a better place to add this.

> +
> +struct v4l2_ctrl * v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl,
> +	const char * const *qmenu, s32 min, s32 max,
> +	u32 menu_skip_mask, s32 def);
> +
> +This helper, function is used to modify the menu, min, max, mask and
> +the default value to set.
> +Example for usage:
> +	static const char * const test_pattern[] = {
> +		"Disabled",
> +		"Vertical Bars",
> +		"Vertical Bars",
> +		"Solid Black",
> +		"Solid White",
> +		NULL
> +	};
> +	struct v4l2_ctrl *test_pattern_ctrl =
> +		v4l2_ctrl_new_std_menu(&foo->ctrl_handler, &foo_ctrl_ops,
> +			V4L2_CID_TEST_PATTERN, V4L2_TEST_PATTERN_DISABLED, 0,
> +			V4L2_TEST_PATTERN_DISABLED);
> +
> +	v4l2_ctrl_modify_menu(test_pattern_ctrl, test_pattern, 0, 5, 0x3, 0);
> +
>  3) Optionally force initial control setup:
>  
>  	v4l2_ctrl_handler_setup(&foo->ctrl_handler);
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index d731422..ac0fb28 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -2666,3 +2666,31 @@ unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait)
>  	return 0;
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_poll);
> +
> +/* Helper function for standard menu controls to modify the menu */
> +struct v4l2_ctrl *v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl,
> +					 const char * const *qmenu, s32 min,

The minimum is always 0 for menu controls, so this argument should be
removed. It's not part of v4l2_ctrl_new_std_menu either.

There is no need to return the pointer here, so just set the return to void.

> +					 s32 max, u32 menu_skip_mask, s32 def)
> +{
> +	if (ctrl->type != V4L2_CTRL_TYPE_MENU)
> +		return NULL;
> +
> +	if (qmenu == NULL)
> +		return NULL;

Change this to:

	if (WARN_ON(ctrl->type != V4L2_CTRL_TYPE_MENU || qmenu == NULL))
		return;

> +
> +	/* Determine if it is standard menu control */
> +	if (!v4l2_ctrl_get_menu(ctrl->id))
> +		return NULL;

This test can be removed. Why should we prohibit calling this function for
non-standard controls?

> +
> +	if ((def > max) || (max < min))
> +		return NULL;

Also replace with if (WARN_ON(def < 0 || def > max)).

All these errors are driver errors and so should just report it in the kernel
log and then bail out.

> +
> +	ctrl->qmenu = qmenu;
> +	ctrl->minimum = min;

No need to set minimum. It's already 0.

> +	ctrl->maximum = max;
> +	ctrl->menu_skip_mask = menu_skip_mask;
> +	ctrl->cur.val = ctrl->val = ctrl->default_value = def;
> +
> +	return ctrl;
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_modify_menu);
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 776605f..5b0ea04 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -488,6 +488,20 @@ static inline void v4l2_ctrl_unlock(struct v4l2_ctrl *ctrl)
>  	mutex_unlock(ctrl->handler->lock);
>  }
>  
> +/**
> + * v4l2_ctrl_modify_menu() - Modify the menu. This function is used when the
> + * control is standard but the menu is specific to device.
> + * @ctrl:		The control to change the menu.
> + * @qmenu:		The menu to which control will point to.
> + * @min:		Minimum value of the control.
> + * @max:		Maximum valur of the control.
> + * @menu_skip_mask:	The control's skip mask for menu controls.
> + * @def:		The default value for control.
> + */
> +struct v4l2_ctrl *v4l2_ctrl_modify_menu(struct v4l2_ctrl *ctrl,
> +					 const char * const *qmenu, s32 min,
> +					 s32 max, u32 menu_skip_mask, s32 def);
> +
>  /** v4l2_ctrl_g_ctrl() - Helper function to get the control's value from within a driver.
>    * @ctrl:	The control.
>    *
> 

Regards,

	Hans
