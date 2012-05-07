Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab2EGTrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 15:47:05 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:62402 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab2EGTrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 15:47:04 -0400
Date: Mon, 7 May 2012 12:46:58 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
Message-ID: <20120507194658.GH19417@google.com>
References: <20120504165232.GB24639@google.com>
 <Pine.LNX.4.44L0.1205041459240.1166-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1205041459240.1166-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

On Fri, May 04, 2012 at 03:08:53PM -0400, Alan Stern wrote:
> @@ -588,10 +591,15 @@ static ssize_t usb_dev_authorized_store(
>  	result = sscanf(buf, "%u\n", &val);
>  	if (result != 1)
>  		result = -EINVAL;
> -	else if (val == 0)
> +	else if (val == 0) {
> +		void *cookie;
> +
> +		cookie = device_start_attribute_infanticide(dev, attr, NULL);
>  		result = usb_deauthorize_device(usb_dev);
> -	else
> +		device_end_attribute_infanticide(cookie);
> +	} else {
>  		result = usb_authorize_device(usb_dev);
> +	}

I *think* it looks way too huge as lockdep workaround.  We're adding a
whole separate lookup interface for this.  If looking up afterwards is
difficult, can't we get away with adding a field in struct attribute?

Thanks.

-- 
tejun
