Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2JTDds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 23:33:48 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:65534 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2JTDdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 23:33:47 -0400
Subject: Re: [PATCH] [PATCH] extcon: driver model release call not needed
From: anish kumar <anish198519851985@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <50820E5F.2010000@samsung.com>
References: <1350580326-1574-1-git-send-email-anish198519851985@gmail.com>
	 <508204FC.4030802@samsung.com>
	 <1350700237.3764.156.camel@anish-Inspiron-N5050>
	 <50820E5F.2010000@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Oct 2012 12:33:38 +0900
Message-ID: <1350704018.3764.240.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 11:37 +0900, Chanwoo Choi wrote:
> On 10/20/2012 11:30 AM, anish kumar wrote:
> > On Sat, 2012-10-20 at 10:57 +0900, Chanwoo Choi wrote:
> >> On 10/19/2012 02:12 AM, anish kumar wrote:
> >>> From: anish kumar <anish198519851985@gmail.com>
> >>>
> >>> We don't need a release call in this file as we are doing
> >>> everything needed in unregister call and we don't have any
> >>> more pointer to free up.
> >>>
> >>> Signed-off-by: anish kumar <anish198519851985@gmail.com>
> >>> ---
> >>>  drivers/extcon/extcon-class.c |    4 +---
> >>>  1 files changed, 1 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> >>> index 946a318..cf30eb1 100644
> >>> --- a/drivers/extcon/extcon-class.c
> >>> +++ b/drivers/extcon/extcon-class.c
> >>> @@ -585,9 +585,7 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
> >>>  
> >>>  static void extcon_dev_release(struct device *dev)
> >>>  {
> >>> -	struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
> >>> -
> >>> -	extcon_cleanup(edev, true);
> >>> +	/* We don't have any thing to free here */
> >>>  }
> >>>  
> >>>  static const char *muex_name = "mutually_exclusive";
> >>
> >> I can't agree this patch. The extcon_dev_release() function is used
> >> for dev->release. If some case without calling extcon_dev_unregister(),
> >> I think dev->release function is needed to free memory of edev->dev.
> > Is it not being released by extcon_dev_unregister?
> > I think it is released by that and we will do two times free and
> > list_del(&edev->entry) as it is called by extcon_dev_release also.
> 
> I think that this patch should modify it as below patch to remove
> two call of kfree().  How about you?
> 
> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
> index e717bbc..efca0b4 100644
> --- a/drivers/extcon/extcon-class.c
> +++ b/drivers/extcon/extcon-class.c
> @@ -597,9 +597,8 @@ static void extcon_cleanup(struct extcon_dev *edev, bool skip)
>  #endif
>                 device_unregister(edev->dev);
>                 put_device(edev->dev);
> -       }
> -
> -       kfree(edev->dev);
> +       } else {
> +               kfree(edev->dev)
How about below?

diff --git a/drivers/extcon/extcon-class.c
b/drivers/extcon/extcon-class.c
index 946a318..62e4ecb 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -551,43 +551,9 @@ static int create_extcon_class(void)
        return 0;
 }
 
-static void extcon_cleanup(struct extcon_dev *edev, bool skip)
-{
-       mutex_lock(&extcon_dev_list_lock);
-       list_del(&edev->entry);
-       mutex_unlock(&extcon_dev_list_lock);
-
-       if (!skip && get_device(edev->dev)) {
-               int index;
-
-               if (edev->mutually_exclusive && edev->max_supported) {
-                       for (index = 0; edev->mutually_exclusive[index];
-                            index++)
-
kfree(edev->d_attrs_muex[index].attr.name);
-                       kfree(edev->d_attrs_muex);
-                       kfree(edev->attrs_muex);
-               }
-
-               for (index = 0; index < edev->max_supported; index++)
-                       kfree(edev->cables[index].attr_g.name);
-
-               if (edev->max_supported) {
-                       kfree(edev->extcon_dev_type.groups);
-                       kfree(edev->cables);
-               }
-
-               device_unregister(edev->dev);
-               put_device(edev->dev);
-       }
-
-       kfree(edev->dev);
-}
-
 static void extcon_dev_release(struct device *dev)
 {
-       struct extcon_dev *edev = (struct extcon_dev *)
dev_get_drvdata(dev);
-
-       extcon_cleanup(edev, true);
+       kfree(edev->dev);
 }
 
 static const char *muex_name = "mutually_exclusive";
@@ -813,7 +779,32 @@ EXPORT_SYMBOL_GPL(extcon_dev_register);
  */
 void extcon_dev_unregister(struct extcon_dev *edev)
 {
-       extcon_cleanup(edev, false);
+       mutex_lock(&extcon_dev_list_lock);
+       list_del(&edev->entry);
+       mutex_unlock(&extcon_dev_list_lock);
+
+       if (!skip && get_device(edev->dev)) {
+               int index;
+
+               if (edev->mutually_exclusive && edev->max_supported) {
+                       for (index = 0; edev->mutually_exclusive[index];
+                            index++)
+
kfree(edev->d_attrs_muex[index].attr.name);
+                       kfree(edev->d_attrs_muex);
+                       kfree(edev->attrs_muex);
+               }
+
+               for (index = 0; index < edev->max_supported; index++)
+                       kfree(edev->cables[index].attr_g.name);
+
+               if (edev->max_supported) {
+                       kfree(edev->extcon_dev_type.groups);
+                       kfree(edev->cables);
+               }
+
+               device_unregister(edev->dev);
+               put_device(edev->dev);
+       }
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
> 


