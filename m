Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2EFOtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 10:49:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37551 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2EFOtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 10:49:09 -0400
MIME-Version: 1.0
In-Reply-To: <1336230499-1450-1-git-send-email-rydberg@euromail.se>
References: <1336230499-1450-1-git-send-email-rydberg@euromail.se>
Date: Sun, 6 May 2012 16:41:40 +0200
Message-ID: <CAN+gG=HqGmf77P6=7RMFT_Ez7Ysp4ZVJ6skfAoDcZ7JN1JtYnw@mail.gmail.com>
Subject: Re: [RFC] Input: MT - Include win8 support
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        chatty@enac.fr, peter.hutterer@who-t.net, chasedouglas@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sat, May 5, 2012 at 5:08 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> The newly released HID protocol for win8 input devices is capable of
> transmitting the same information found in the Apple HID and Linux MT
> protocols. In addition, it includes an extension useful for touch
> alignment. This patch completes the MT protocol with the
> ABS_MT_APPROACH_X/Y events, and documents how to map win8 devices.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> Hi all,
>
> In response to the win8 HID protocol and Benjamin's work on this, here
> is a first draft of the needed extension to the MT protocol. I am
> cc:ing the usual suspects, as this will affect userland. Comments and
> criticism expected. :-)
>
> Cheers,
> Henrik
>
>  Documentation/input/multi-touch-protocol.txt |   35 +++++++++++++++++++++++++-
>  include/linux/input.h                        |    4 ++-
>  2 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
> index 543101c..504ca6d 100644
> --- a/Documentation/input/multi-touch-protocol.txt
> +++ b/Documentation/input/multi-touch-protocol.txt
> @@ -168,7 +168,9 @@ The TOUCH and WIDTH parameters have a geometrical interpretation; imagine
>  looking through a window at someone gently holding a finger against the
>  glass.  You will see two regions, one inner region consisting of the part
>  of the finger actually touching the glass, and one outer region formed by
> -the perimeter of the finger. The diameter of the inner region is the
> +the perimeter of the finger. The center of the inner region is
> +ABS_MT_POSITION_X/Y. The center of the outer region may be different,
> +denoted by ABS_MT_APPROACH_X/Y. The diameter of the inner region is the
>  ABS_MT_TOUCH_MAJOR, the diameter of the outer region is
>  ABS_MT_WIDTH_MAJOR. Now imagine the person pressing the finger harder
>  against the glass. The inner region will increase, and in general, the
> @@ -252,6 +254,9 @@ can distinguish between the two axis, but not (uniquely) any values in
>  between. In such cases, the range of ABS_MT_ORIENTATION should be [0, 1]
>  [4].
>
> +For devices capable of 360 degree orientation, the reported orientation
> +should be twice the given range.

Like Chase, I don't understand the necessity of that.

> +
>  ABS_MT_POSITION_X
>
>  The surface X coordinate of the center of the touching ellipse.
> @@ -260,6 +265,23 @@ ABS_MT_POSITION_Y
>
>  The surface Y coordinate of the center of the touching ellipse.
>
> +ABS_MT_APPROACH_X

Honestly, I think that ABS_MT_APPROACH_* is really confusing for
end-users (Xorg, Wayland, Qt, ...). I know that the explanation are
given, but looking at the mess we had with the use of the MT events
before it has been documented, I don't think this is the right term to
use. Without the doc, and with a little bit of bad faith, I would say
that approach refers to the T coordinate in Win8 doc (the approximate
position where the user wants to touch), whereas the POSITION_* is
more the center of the ellipse of the touch.... But it's the invert...
;-)

Thanks,
Benjamin

> +
> +The surface X coordinate of the center of the approaching ellipse. Omit if
> +the device cannot distinguish between the intended touching point and the
> +center of the approaching contact.
> +
> +ABS_MT_APPROACH_Y
> +
> +The surface Y coordinate of the center of the approaching ellipse. Omit if
> +the device cannot distinguish between the intended touching point and the
> +center of the approaching contact.
> +
> +The four position values can be used to separate the intended touch point
> +from the center of the approaching object. The difference also yields an
> +approximation of the directed orientation of the approaching ellipse, with
> +ABS_MT_WIDTH_MAJOR pointing towards the touch center.
> +
>  ABS_MT_TOOL_TYPE
>
>  The type of approaching tool. A lot of kernel drivers cannot distinguish
> @@ -305,6 +327,17 @@ The range of ABS_MT_ORIENTATION should be set to [0, 1], to indicate that
>  the device can distinguish between a finger along the Y axis (0) and a
>  finger along the X axis (1).
>
> +For win8 devices with both T and C coordinates, the position mapping is
> +
> +   ABS_MT_POSITION_X := T_X
> +   ABS_MT_POSITION_Y := T_Y
> +   ABS_MT_APPROACH_X := C_X
> +   ABS_MT_APPROACH_X := C_Y
> +
> +For win8 devices with Azimuth or Twist defined, the range max is the value
> +for 90 degrees, and the orientation mapping is
> +
> +   ABS_MT_ORIENTATION := twist < 2 * max ? twist : twist - 4 * max
>
>  Finger Tracking
>  ---------------
> diff --git a/include/linux/input.h b/include/linux/input.h
> index a816714..039234e 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -813,11 +813,13 @@ struct input_keymap_entry {
>  #define ABS_MT_TRACKING_ID     0x39    /* Unique ID of initiated contact */
>  #define ABS_MT_PRESSURE                0x3a    /* Pressure on contact area */
>  #define ABS_MT_DISTANCE                0x3b    /* Contact hover distance */
> +#define ABS_MT_APPROACH_X      0x3c    /* Center X approaching ellipse */
> +#define ABS_MT_APPROACH_Y      0x3d    /* Center Y approaching ellipse */
>
>  #ifdef __KERNEL__
>  /* Implementation details, userspace should not care about these */
>  #define ABS_MT_FIRST           ABS_MT_TOUCH_MAJOR
> -#define ABS_MT_LAST            ABS_MT_DISTANCE
> +#define ABS_MT_LAST            ABS_MT_APPROACH_Y
>  #endif
>
>  #define ABS_MAX                        0x3f
> --
> 1.7.10
>
