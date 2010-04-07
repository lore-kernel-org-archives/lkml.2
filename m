Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab0DGGbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 02:31:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:50133 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab0DGGbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 02:31:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BBC269A.6040909@s5r6.in-berlin.de>
Date: Wed, 07 Apr 2010 08:30:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: cdev: fix information leak
References: <4BBAD1BC.2070100@ladisch.de> <4BBADAA1.9050508@s5r6.in-berlin.de> <4BBAF7EE.5000804@ladisch.de> <4BBB8851.6000509@s5r6.in-berlin.de> <tkrat.0047dfa7530926c0@s5r6.in-berlin.de> <tkrat.630b7e060062afa9@s5r6.in-berlin.de> <tkrat.30d7a4f8f7a97b2b@s5r6.in-berlin.de>
In-Reply-To: <tkrat.30d7a4f8f7a97b2b@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> --- a/drivers/firewire/core-cdev.c
> +++ b/drivers/firewire/core-cdev.c
> @@ -1346,41 +1346,43 @@ static int (* const ioctl_handlers[])(st
>  static int dispatch_ioctl(struct client *client,
>  			  unsigned int cmd, void __user *arg)
>  {
>  	union ioctl_arg buffer;
>  	int ret;
>  
>  	if (fw_device_is_shutdown(client->device))
>  		return -ENODEV;
>  
>  	if (_IOC_TYPE(cmd) != '#' ||
>  	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers))
>  		return -EINVAL;
>  
> -	if (_IOC_DIR(cmd) & _IOC_WRITE) {
> -		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
> -		    copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
> +	if (_IOC_SIZE(cmd) > sizeof(buffer))
> +		return -EFAULT;

I'll combine this into the preceding -EINVAL return.  Cf. man ioctl.

> +
> +	if (_IOC_DIR(cmd) == _IOC_READ)
> +		memset(&buffer, 0, _IOC_SIZE(cmd));
> +
> +	if (_IOC_DIR(cmd) & _IOC_WRITE)
> +		if (copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
>  			return -EFAULT;
> -	}
>  
>  	ret = ioctl_handlers[_IOC_NR(cmd)](client, &buffer);
>  	if (ret < 0)
>  		return ret;
>  
> -	if (_IOC_DIR(cmd) & _IOC_READ) {
> -		if (_IOC_SIZE(cmd) > sizeof(buffer) ||
> -		    copy_to_user(arg, &buffer, _IOC_SIZE(cmd)))
> +	if (_IOC_DIR(cmd) & _IOC_READ)
> +		if (copy_to_user(arg, &buffer, _IOC_SIZE(cmd)))
>  			return -EFAULT;
> -	}
>  
>  	return ret;
>  }

-- 
Stefan Richter
-=====-==-=- -=-- --===
http://arcgraph.de/sr/
