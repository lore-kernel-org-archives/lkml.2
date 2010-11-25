Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0KYSIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 13:08:51 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:4520 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0KYSIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 13:08:50 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=H95gfW32JB/XYJSBuOTvJ8IIviFcsPdfxXHbM7LS6jM= c=1 sm=1
 a=dPnxFd8_iYEA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=VwQbUJbxAAAA:8 a=wc6DhzEo1zFAyykfiEEA:9
 a=jGJZYycv87Mi4yxxqvsA:7 a=L84e0MIl-bp4eU1GyLX1YU70JQYA:4 a=CjuIK1q_8ugA:10
 a=x8gzFH9gYPwA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH] fcntl: Add the F_READAHEAD command
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20101125095437.GA3409@ping.uio.no>
Date: Thu, 25 Nov 2010 11:08:45 -0700
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DEAF94DC-08D0-42D2-A6E9-62B1B9C39D40@dilger.ca>
References: <20101125095437.GA3409@ping.uio.no>
To: Morten Hustveit <mortehu@ping.uio.no>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-25, at 02:54, Morten Hustveit wrote:
> +static int f_readahead(struct file *filp, unsigned long arg)
> +{
> +	if (arg) {
> +		filp->f_ra.ra_pages = (arg + PAGE_SIZE - 1) >> PAGE_SHIFT;

Functionality itself is fine, but it would be clearer if you used a better variable name than "arg" here.  Something like "readahead_bytes" or similar would make it immediately clear what the parameter is.

> +		spin_lock(&filp->f_lock);
> +		filp->f_mode &= ~FMODE_RANDOM;
> +		spin_unlock(&filp->f_lock);
> +	} else {
> +		spin_lock(&filp->f_lock);
> +		filp->f_mode |= FMODE_RANDOM;
> +		spin_unlock(&filp->f_lock);
> +	}
> +
> +	return 0;
> +}
> +
> static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
> 		struct file *filp)
> {
> @@ -420,6 +445,9 @@ static long do_fcntl(int fd, unsigned int cmd, unsigned long arg,
> 	case F_GETPIPE_SZ:
> 		err = pipe_fcntl(filp, cmd, arg);
> 		break;
> +	case F_READAHEAD:
> +		err = f_readahead(filp, arg);
> +		break;
> 	default:
> 		break;
> 	}
> diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
> index afc00af..69d8e4d 100644
> --- a/include/linux/fcntl.h
> +++ b/include/linux/fcntl.h
> @@ -28,6 +28,11 @@
> #define F_GETPIPE_SZ	(F_LINUX_SPECIFIC_BASE + 8)
> 
> /*
> + * Set read-ahead buffer size
> + */
> +#define F_READAHEAD	(F_LINUX_SPECIFIC_BASE + 9)
> +
> +/*
> * Types of directory notifications that may be requested.
> */
> #define DN_ACCESS	0x00000001	/* File accessed */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





