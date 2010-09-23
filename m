Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0IWMMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 08:12:47 -0400
Received: from smtp.nokia.com ([192.100.122.230]:51948 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab0IWMMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 08:12:45 -0400
Date: Thu, 23 Sep 2010 14:51:08 +0300
From: Ville Tervo <ville.tervo@nokia.com>
To: ext Alan Ott <alan@signal11.us>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Stephane Chatty <chatty@enac.fr>, Michael Poole <mdpoole@troilus.org>,
        "David S. Miller" <davem@davemloft.net>,
        Bastien Nocera <hadess@hadess.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] Bluetooth: hidp: Add support for hidraw
 HIDIOCGFEATURE  and HIDIOCSFEATURE
Message-ID: <20100923115108.GC2379@null>
References: <1281442367.12579.206.camel@localhost.localdomain>
 <1281990059-3562-3-git-send-email-alan@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281990059-3562-3-git-send-email-alan@signal11.us>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Sep 2010 11:51:33.0823 (UTC) FILETIME=[AB6624F0:01CB5B15]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

One comment.

On Mon, Aug 16, 2010 at 10:20:59PM +0200, ext Alan Ott wrote:
> This patch adds support or getting and setting feature reports for bluetooth
> HID devices from HIDRAW.
> 
> Signed-off-by: Alan Ott <alan@signal11.us>
> ---
>  net/bluetooth/hidp/core.c |  114 +++++++++++++++++++++++++++++++++++++++++++--
>  net/bluetooth/hidp/hidp.h |    8 +++
>  2 files changed, 118 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index bfe641b..0e4880e 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -36,6 +36,7 @@
>  #include <linux/file.h>
>  #include <linux/init.h>
>  #include <linux/wait.h>
> +#include <linux/mutex.h>
>  #include <net/sock.h>
>  
>  #include <linux/input.h>
> @@ -313,6 +314,86 @@ static int hidp_send_report(struct hidp_session *session, struct hid_report *rep
>  	return hidp_queue_report(session, buf, rsize);
>  }
>  
> +static int hidp_get_raw_report(struct hid_device *hid,
> +		unsigned char report_number,
> +		unsigned char *data, size_t count,
> +		unsigned char report_type)
> +{
> +	struct hidp_session *session = hid->driver_data;
> +	struct sk_buff *skb;
> +	size_t len;
> +	int numbered_reports = hid->report_enum[report_type].numbered;
> +
> +	switch (report_type) {
> +	case HID_FEATURE_REPORT:
> +		report_type = HIDP_TRANS_GET_REPORT | HIDP_DATA_RTYPE_FEATURE;
> +		break;
> +	case HID_INPUT_REPORT:
> +		report_type = HIDP_TRANS_GET_REPORT | HIDP_DATA_RTYPE_INPUT;
> +		break;
> +	case HID_OUTPUT_REPORT:
> +		report_type = HIDP_TRANS_GET_REPORT | HIDP_DATA_RTYPE_OUPUT;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	if (mutex_lock_interruptible(&session->report_mutex))
> +		return -ERESTARTSYS;
> +
> +	/* Set up our wait, and send the report request to the device. */
> +	session->waiting_report_type = report_type & HIDP_DATA_RTYPE_MASK;
> +	session->waiting_report_number = numbered_reports ? report_number : -1;
> +	set_bit(HIDP_WAITING_FOR_RETURN, &session->flags);
> +	data[0] = report_number;
> +	if (hidp_send_ctrl_message(hid->driver_data, report_type, data, 1))
> +		goto err_eio;
> +
> +	/* Wait for the return of the report. The returned report
> +	   gets put in session->report_return.  */
> +	while (test_bit(HIDP_WAITING_FOR_RETURN, &session->flags)) {
> +		int res;
> +
> +		res = wait_event_interruptible_timeout(session->report_queue,
> +			!test_bit(HIDP_WAITING_FOR_RETURN, &session->flags),
> +			5*HZ);
> +		if (res == 0) {
> +			/* timeout */
> +			goto err_eio;
> +		}
> +		if (res < 0) {
> +			/* signal */
> +			goto err_restartsys;
> +		}
> +	}
> +
> +	skb = session->report_return;
> +	if (skb) {
> +		len = skb->len < count ? skb->len : count;
> +		memcpy(data, skb->data, len);
> +
> +		kfree_skb(skb);
> +		session->report_return = NULL;
> +	} else {
> +		/* Device returned a HANDSHAKE, indicating  protocol error. */
> +		len = -EIO;
> +	}
> +
> +	clear_bit(HIDP_WAITING_FOR_RETURN, &session->flags);
> +	mutex_unlock(&session->report_mutex);
> +
> +	return len;
> +
> +err_restartsys:
> +	clear_bit(HIDP_WAITING_FOR_RETURN, &session->flags);
> +	mutex_unlock(&session->report_mutex);
> +	return -ERESTARTSYS;
> +err_eio:
> +	clear_bit(HIDP_WAITING_FOR_RETURN, &session->flags);
> +	mutex_unlock(&session->report_mutex);
> +	return -EIO;
> +}

How about a variable called ret and using that to return len or errno? It
would eliminate code dublication.

-- 
Ville
