Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab2LDLpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 06:45:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24417 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2LDLps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 06:45:48 -0500
Date: Tue, 4 Dec 2012 14:45:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, zach.pfeffer@linaro.org, Dave.Butcher@arm.com
Subject: Re: [PATCH 2/2] Staging: android: ashmem: Add support for 32bit
 ashmem calls in a 64bit kernel
Message-ID: <20121204114511.GI6568@mwanda>
References: <1354617854-25296-1-git-send-email-serban.constantinescu@arm.com>
 <1354617854-25296-3-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354617854-25296-3-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't understand this, and I'm going to embarrass myself by
displaying my ignorance for all to see.  Why is this code so
different from all the other 32 bit compat code that we have in the
kernel?

On Tue, Dec 04, 2012 at 10:44:14AM +0000, Serban Constantinescu wrote:
> -static int set_name(struct ashmem_area *asma, void __user *name)
> +static int set_name(struct ashmem_area *asma, userptr32_t name)

The user passes in a value which is a 32 pointer.  ashmem_ioctl()
accepts it as "unsigned long arg".  We pass it to set_name() which
truncates away the high zeros so now its a u32 (userptr32_t).  We
then cast it to (unsigned long) and then we cast it to a void
pointer.

What's the point?  Why not just take"unsigned long arg" and cast it
to a pointer directly?

>  	if (unlikely(copy_from_user(asma->name + ASHMEM_NAME_PREFIX_LEN,
> -				    name, ASHMEM_NAME_LEN)))
> +				    (void *)(unsigned long)name, ASHMEM_NAME_LEN)))
>  		ret = -EFAULT;

This will introduce a Sparse complaint.  It should be:
				(void __user *)(unsigned long)name.

But actually we shouldn't need to do this casting.  Any casting
which we need to do should be done in one place instead of pushed
out to every function.

> +	switch (_IOC_NR(cmd)) {
> +	case _IOC_NR(ASHMEM_SET_NAME):
> +		if (_IOC_SIZE(cmd) != sizeof(char[ASHMEM_NAME_LEN]))
> +			pr_err("ashmem: ASHMEM_SET_NAME transaction size differs\n");

Don't merge debug code into the kernel.  It just means people can
spam /var/log/messages.

regards,
dan carpenter

