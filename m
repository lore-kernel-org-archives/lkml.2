Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2JPIR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:17:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47739 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab2JPIRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:17:54 -0400
Message-ID: <507D182E.9010902@suse.cz>
Date: Tue, 16 Oct 2012 10:17:50 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Jean Delvare <khali@linux-fr.org>,
        JJ Ding <jj_ding@emc.com.tw>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c-hid: introduce HID over i2c specification implementation
References: <1350333533-13366-1-git-send-email-benjamin.tissoires@gmail.com>
In-Reply-To: <1350333533-13366-1-git-send-email-benjamin.tissoires@gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 10:38 PM, Benjamin Tissoires wrote:
> Notes:
> {1}: I don't have all the informations in the beginning of the probe function to
> get the real size I need to allocate. So the behavior is to allocate first a
> buffer by using HID_MIN_BUFFER_SIZE and once I got the information, I can
> reallocate the buffer to the right size (in i2c_hid_start).

And there is a bug in this. See below.

> --- /dev/null
> +++ b/drivers/hid/i2c-hid/i2c-hid.c
...
> +static int i2c_hid_alloc_buffers(struct i2c_hid *ihid)
> +{
> +	/* the worst case is computed from the set_report command with a
> +	 * reportID > 15 and the maximum report length */
> +	int args_len = sizeof(__u8) + /* optional ReportID byte */
> +		       sizeof(__u16) + /* data register */
> +		       sizeof(__u16) + /* size of the report */
> +		       ihid->bufsize; /* report */
> +
> +	ihid->inbuf = kzalloc(ihid->bufsize, GFP_KERNEL);
> +
> +	if (!ihid->inbuf)
> +		return -ENOMEM;
> +
> +	ihid->argsbuf = kzalloc(args_len, GFP_KERNEL);
> +
> +	if (!ihid->argsbuf) {
> +		kfree(ihid->inbuf);
> +		return -ENOMEM;
> +	}
> +
> +	ihid->cmdbuf = kzalloc(sizeof(union command) + args_len, GFP_KERNEL);
> +
> +	if (!ihid->cmdbuf) {
> +		kfree(ihid->inbuf);
> +		kfree(ihid->argsbuf);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;

If this is called from hid_start and some of the latter allocation fails
here, you free the buffers appropriately. However if another start
occurs (e.g. by loading another module for that particular device), it
will crash, as the buffers will remain unallocated because at this point
ihid->bufsize == old_bufsize. You should set ihid->bufsize back to
old_bufsize if i2c_hid_alloc_buffers fails and also set the pointers to
NULL here.

regards,
-- 
js
suse labs
