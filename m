Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020Ab0J2WRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 18:17:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932438Ab0J2WRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 18:17:13 -0400
Date: Fri, 29 Oct 2010 15:17:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Liu Hong <hong.liu@intel.com>,
        Kalhan Trisal <kalhan.trisal@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: isl29020: fix signedness bug
Message-Id: <20101029151710.de349042.akpm@linux-foundation.org>
In-Reply-To: <1288264443-10627-1-git-send-email-segooon@gmail.com>
References: <1288264443-10627-1-git-send-email-segooon@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Oct 2010 15:14:03 +0400
Vasiliy Kulikov <segooon@gmail.com> wrote:

> i2c_smbus_write_byte_data() may return negative error code.  This is not
> seen to als_sensing_range_store() as the result is stored in unsigned int.
> Made it signed.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  Compile tested.
> 
>  drivers/misc/isl29020.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
> index 34fe835..629d31e 100644
> --- a/drivers/misc/isl29020.c
> +++ b/drivers/misc/isl29020.c
> @@ -87,7 +87,7 @@ static ssize_t als_sensing_range_store(struct device *dev,
>  		struct device_attribute *attr, const  char *buf, size_t count)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> -	unsigned int ret_val;
> +	int ret_val;
>  	unsigned long val;
>  
>  	if (strict_strtoul(buf, 10, &val))

yup.

It also needs this:



drivers/misc/isl29020.c: don't ignore the i2c_smbus_read_byte_data() return value

From: Andrew Morton <akpm@linux-foundation.org>

If i2c_smbus_read_byte_data() fails, this driver will write a mangled
errno value into the hardware.

Cc: Vasiliy Kulikov <segooon@gmail.com>
Cc: Liu Hong <hong.liu@intel.com>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/isl29020.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/misc/isl29020.c~a drivers/misc/isl29020.c
--- a/drivers/misc/isl29020.c~a
+++ a/drivers/misc/isl29020.c
@@ -106,8 +106,10 @@ static ssize_t als_sensing_range_store(s
 		val = 4;
 
 	ret_val = i2c_smbus_read_byte_data(client, 0x00);
+	if (ret_val < 0)
+		return ret_val;
 
-	ret_val &= 0xFC; /*reset the bit before setting them */
+	ret_val &= 0xFC; /* reset the bit before setting them */
 	ret_val |= val - 1;
 	ret_val = i2c_smbus_write_byte_data(client, 0x00, ret_val);
 
_

