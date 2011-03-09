Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab1CIX7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:59:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752584Ab1CIX7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:59:21 -0500
Date: Wed, 9 Mar 2011 15:58:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kalhan Trisal <kalhan.trisal@intel.com>,
        Alan Cox <alan@linux.intel.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] misc: hmc6352: fix wrong return value checking for
 i2c_master_recv
Message-Id: <20110309155841.52847f15.akpm@linux-foundation.org>
In-Reply-To: <1299660116.8255.1.camel@mola>
References: <1299660116.8255.1.camel@mola>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Mar 2011 16:41:56 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> i2c_master_recv() returns negative errno, or else the number of bytes read.
> Thus i2c_master_recv(client, i2c_data, 2) returns 2 instead of 1 in success case.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/misc/hmc6352.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
> index 234bfca..3afc11e 100644
> --- a/drivers/misc/hmc6352.c
> +++ b/drivers/misc/hmc6352.c
> @@ -86,7 +86,7 @@ static ssize_t compass_heading_data_show(struct device *dev,
>  	msleep(10); /* sending 'A' cmd we need to wait for 7-10 millisecs */
>  	ret = i2c_master_recv(client, i2c_data, 2);
>  	mutex_unlock(&compass_mutex);
> -	if (ret != 1) {
> +	if (ret < 0) {
>  		dev_warn(dev, "i2c read data cmd failed\n");
>  		return ret;
>  	}

The problem seems real but the fix won't work:

--- a/drivers/misc/hmc6352.c~drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix
+++ a/drivers/misc/hmc6352.c
@@ -75,7 +75,7 @@ static ssize_t compass_heading_data_show
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned char i2c_data[2];
-	unsigned int ret;
+	int ret;
 
 	mutex_lock(&compass_mutex);
 	ret = compass_command(client, 'A');



I also wonder if this bit is correct:

: static ssize_t compass_heading_data_show(struct device *dev,
: 			struct device_attribute *attr, char *buf)
: {
: 	struct i2c_client *client = to_i2c_client(dev);
: 	unsigned char i2c_data[2];
: 	int ret;
: 
: 	mutex_lock(&compass_mutex);
: 	ret = compass_command(client, 'A');
: 	if (ret != 1) {
: 		mutex_unlock(&compass_mutex);
: 		return ret;
: 	}

If compass_command() returns zero (short write on i2c?!?!?) then did we
do the right thing?

