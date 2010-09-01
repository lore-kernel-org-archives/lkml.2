Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0IACY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:24:58 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:59909 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752618Ab0IACY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:24:57 -0400
Subject: Re: [PATCH 5/7 v3] HID: magicmouse: remove timestamp logic
From: Michael Poole <mdpoole@troilus.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        Tejun Heo <tj@kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1283306184-28833-6-git-send-email-chase.douglas@canonical.com>
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>
	 <1283306184-28833-6-git-send-email-chase.douglas@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 22:24:53 -0400
Message-ID: <1283307893.16204.5.camel@graviton>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 21:56 -0400, Chase Douglas wrote:
> From: Chase Douglas <chase.douglas@ubuntu.com>
> 
> The timestamps from the device are currently stored in the private data
> structure. These aren't used, so remove them. I've left a comment
> detailing the protocol for future reference.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>

Acked-by: Michael Poole <mdpoole@troilus.org>

> ---
>  drivers/hid/hid-magicmouse.c |   18 +++++++-----------
>  1 files changed, 7 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
> index 0fbca59..9fc272f 100644
> --- a/drivers/hid/hid-magicmouse.c
> +++ b/drivers/hid/hid-magicmouse.c
> @@ -71,11 +71,6 @@ MODULE_PARM_DESC(report_undeciphered, "Report undeciphered multi-touch state fie
>   * struct magicmouse_sc - Tracks Magic Mouse-specific data.
>   * @input: Input device through which we report events.
>   * @quirks: Currently unused.
> - * @last_timestamp: Timestamp from most recent (18-bit) touch report
> - *     (units of milliseconds over short windows, but seems to
> - *     increase faster when there are no touches).
> - * @delta_time: 18-bit difference between the two most recent touch
> - *     reports from the mouse.
>   * @ntouches: Number of touches in most recent touch report.
>   * @scroll_accel: Number of consecutive scroll motions.
>   * @scroll_jiffies: Time of last scroll motion.
> @@ -86,8 +81,6 @@ struct magicmouse_sc {
>  	struct input_dev *input;
>  	unsigned long quirks;
>  
> -	int last_timestamp;
> -	int delta_time;
>  	int ntouches;
>  	int scroll_accel;
>  	unsigned long scroll_jiffies;
> @@ -248,7 +241,7 @@ static int magicmouse_raw_event(struct hid_device *hdev,
>  {
>  	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
>  	struct input_dev *input = msc->input;
> -	int x, y, ts, ii, clicks, npoints;
> +	int x, y, ii, clicks, npoints;
>  
>  	switch (data[0]) {
>  	case 0x10:
> @@ -262,9 +255,6 @@ static int magicmouse_raw_event(struct hid_device *hdev,
>  		/* Expect six bytes of prefix, and N*8 bytes of touch data. */
>  		if (size < 6 || ((size - 6) % 8) != 0)
>  			return 0;
> -		ts = data[3] >> 6 | data[4] << 2 | data[5] << 10;
> -		msc->delta_time = (ts - msc->last_timestamp) & 0x3ffff;
> -		msc->last_timestamp = ts;
>  		npoints = (size - 6) / 8;
>  		msc->ntouches = 0;
>  		for (ii = 0; ii < npoints; ii++)
> @@ -280,6 +270,12 @@ static int magicmouse_raw_event(struct hid_device *hdev,
>  		x = (int)(((data[3] & 0x0c) << 28) | (data[1] << 22)) >> 22;
>  		y = (int)(((data[3] & 0x30) << 26) | (data[2] << 22)) >> 22;
>  		clicks = data[3];
> +
> +		/* The following bits provide a device specific timestamp. They
> +		 * are unused here.
> +		 *
> +		 * ts = data[3] >> 6 | data[4] << 2 | data[5] << 10;
> +		 */
>  		break;
>  	case 0x20: /* Theoretically battery status (0-100), but I have
>  		    * never seen it -- maybe it is only upon request.


