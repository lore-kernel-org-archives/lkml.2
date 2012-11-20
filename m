Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2KTUzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:55:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44005 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2KTUzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:55:03 -0500
Date: Tue, 20 Nov 2012 12:54:59 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, ellyjones@chromium.org,
        Kay Sievers <kay@vrfy.org>, Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH v2] devtmpfs: mount with noexec and nosuid
Message-ID: <20121120205459.GA12859@kroah.com>
References: <20121120204238.GA19554@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120204238.GA19554@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 12:42:38PM -0800, Kees Cook wrote:
> Since devtmpfs is writable, make the default noexec,nosuid as well. This
> protects from the case of a privileged process having an arbitrary file
> write flaw and an argumentless arbitrary execution (i.e. it would lack
> the ability to run "mount -o remount,exec,suid /dev").
> 
> Cc: ellyjones@chromium.org
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Roland Eggner <edvx1@systemanalysen.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> ---
> v2:
> - use CONFIG_DEVTMPFS_SAFE to wrap the logic.

That's better, thanks.

One tiny bikeshead request though:

> --- a/drivers/base/devtmpfs.c
> +++ b/drivers/base/devtmpfs.c
> @@ -340,6 +340,10 @@ static int handle_remove(const char *nodename, struct device *dev)
>  int devtmpfs_mount(const char *mntdir)
>  {
>  	int err;
> +	int mflags = MS_SILENT;
> +#ifdef CONFIG_DEVTMPFS_SAFE
> +	mflags |= MS_NOEXEC | MS_NOSUID;
> +#endif

You duplicate this in two places, which makes the c code harder to read.
How about, at the top of the file, you do:

#ifdef CONFIG_DEVTMPFS_SAFE
#define DEVTMPFS_MFLAGS	MS_SILENT | MS_NOEXEC | MS_NOSUID
#else
#define DEVTMPFS_MFLAGS	MS_SILENT
#endif

And then just use DEVTMPFS_MFLAGS in both places?

That should make the patch smaller, which is always nice :)

thanks,

greg k-h
