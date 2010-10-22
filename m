Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab0JVUED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 16:04:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007Ab0JVUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 16:04:01 -0400
Date: Fri, 22 Oct 2010 13:03:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Hong Liu <hong.liu@intel.com>
Subject: Re: [PATCH] apds9802als: add runtime PM support
Message-Id: <20101022130324.ce4ec019.akpm@linux-foundation.org>
In-Reply-To: <20101015134713.25557.44608.stgit@localhost.localdomain>
References: <20101015134713.25557.44608.stgit@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 14:47:25 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>     Update the driver for the needed runtime power features. Remove the old
>     user controlled power functions.

How's this look?



put PM code under CONFIG_PM

Cc: Alan Cox <alan@linux.intel.com>
Cc: Hong Liu <hong.liu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/apds9802als.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN drivers/misc/apds9802als.c~drivers-misc-apds9802alsc-add-runtime-pm-support-fix drivers/misc/apds9802als.c
--- a/drivers/misc/apds9802als.c~drivers-misc-apds9802alsc-add-runtime-pm-support-fix
+++ a/drivers/misc/apds9802als.c
@@ -266,6 +266,7 @@ static int apds9802als_remove(struct i2c
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static int apds9802als_suspend(struct i2c_client *client, pm_message_t mesg)
 {
 	als_set_power_state(client, false);
@@ -302,6 +303,14 @@ static const struct dev_pm_ops apds9802a
 	.runtime_resume = apds9802als_runtime_resume,
 };
 
+#define APDS9802ALS_PM_OPS (&apds9802als_pm_ops)
+
+#else	/* CONFIG_PM */
+#define apds9802als_suspend NULL
+#define apds9802als_resume NULL
+#define APDS9802ALS_PM_OPS NULL
+#endif	/* CONFIG_PM */
+
 static struct i2c_device_id apds9802als_id[] = {
 	{ DRIVER_NAME, 0 },
 	{ }
@@ -312,7 +321,7 @@ MODULE_DEVICE_TABLE(i2c, apds9802als_id)
 static struct i2c_driver apds9802als_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
-		.pm = &apds9802als_pm_ops,
+		.pm = APDS9802ALS_PM_OPS,
 	},
 	.probe = apds9802als_probe,
 	.remove = apds9802als_remove,
_


And a question.  This driver puts the .suspend and .resume pointers
into the `struct i2c_driver'.  However drivers/misc/isl29020.c does not
do that.  What's up with that?
