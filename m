Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083Ab2JTEAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 00:00:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55797 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2JTEAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 00:00:18 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-66-508221d09523
Message-id: <508221CF.7060400@samsung.com>
Date: Sat, 20 Oct 2012 13:00:15 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: anish kumar <anish198519851985@gmail.com>
Cc: gregkh@linuxfoundation.org, myungjoo.ham@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH] extcon: driver model release call not needed
References: <1350580326-1574-1-git-send-email-anish198519851985@gmail.com>
 <508204FC.4030802@samsung.com>
 <1350700237.3764.156.camel@anish-Inspiron-N5050>
 <50820E5F.2010000@samsung.com> <1350704018.3764.240.camel@anish-Inspiron-N5050>
In-reply-to: <1350704018.3764.240.camel@anish-Inspiron-N5050>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd0Lik0BBm/6xC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGnqvPGAueyVScn/+BuYHxv3AXIyeHhICJxJ6el0wQtpjEhXvr
	2boYuTiEBKYzSty8OZEdwulikljx/QobSBWvgJZE85YNzCA2i4CqxOOtP9hBbDag+P4XN4Bq
	ODhEBSIkfvVzQJQLSvyYfI8FJCwioCuxaWEKSJgZqGLSq8UsILawgKfEnkvHoVZ9YJR482MB
	K0iCU8BW4uTkXUwQDeoSk+YtYoaw5SU2r3nLPIFRYBaSFbOQlM1CUraAkXkVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnAAPpPewbiqweIQowAHoxIPr0RfY4AQa2JZcWXuIUYJDmYlEd6l
	i4BCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZs9UgKEBNITS1KzU1MLUotgskwcnFINjPI3F9un
	RhdyRjxJNyhIbssUORRXz2q8Uf2A9VUOZ3PhK6x1rVOldl67nq4cdddGU2eT8sauhF/ycw6u
	tdhy7t3uPJVVS97dkmnSTetelMMrZ5L78qyeH+OM234Pc1lbbe5eeWlrPWfCn82+HQs3i1+Y
	JyK1R+blX6cuNX4mbn73NxerHlZoKrEUZyQaajEXFScCAOU6pVk8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2012 12:33 PM, anish kumar wrote:
[....]
> How about below?

I agree, but there were some minor issues,

[....]
>  
>  static const char *muex_name = "mutually_exclusive";
> @@ -813,7 +779,32 @@ EXPORT_SYMBOL_GPL(extcon_dev_register);
>   */
>  void extcon_dev_unregister(struct extcon_dev *edev)
>  {
> -       extcon_cleanup(edev, false);
> +       mutex_lock(&extcon_dev_list_lock);
> +       list_del(&edev->entry);
> +       mutex_unlock(&extcon_dev_list_lock);
> +
> +       if (!skip && get_device(edev->dev)) {

'skip' variable isn't anymore used and fix indentation as below code

[...]

-----
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index e717bbc..ec7cc84 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -566,47 +566,9 @@ static int create_extcon_class(void)
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
-                               kfree(edev->d_attrs_muex[index].attr.name);
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
-#if defined(CONFIG_ANDROID)
-               if (switch_class)
-                       class_compat_remove_link(switch_class, edev->dev, NULL);
-#endif
-               device_unregister(edev->dev);
-               put_device(edev->dev);
-       }
-
-       kfree(edev->dev);
-}
-
 static void extcon_dev_release(struct device *dev)
 {
-       struct extcon_dev *edev = (struct extcon_dev *) dev_get_drvdata(dev);
-
-       extcon_cleanup(edev, true);
+       kfree(edev->dev);
 }

 static const char *muex_name = "mutually_exclusive";
@@ -832,7 +794,37 @@ EXPORT_SYMBOL_GPL(extcon_dev_register);
  */
 void extcon_dev_unregister(struct extcon_dev *edev)
 {
-       extcon_cleanup(edev, false);
+       int index;
+
+       mutex_lock(&extcon_dev_list_lock);
+       list_del(&edev->entry);
+       mutex_unlock(&extcon_dev_list_lock);
+
+       if (!get_device(edev->dev))
+               return;
+
+       if (edev->mutually_exclusive && edev->max_supported) {
+               for (index = 0; edev->mutually_exclusive[index];
+                    index++)
+                       kfree(edev->d_attrs_muex[index].attr.name);
+               kfree(edev->d_attrs_muex);
+               kfree(edev->attrs_muex);
+       }
+
+       for (index = 0; index < edev->max_supported; index++)
+               kfree(edev->cables[index].attr_g.name);
+
+       if (edev->max_supported) {
+               kfree(edev->extcon_dev_type.groups);
+               kfree(edev->cables);
+       }
+
+#if defined(CONFIG_ANDROID)
+       if (switch_class)
+               class_compat_remove_link(switch_class, edev->dev, NULL);
+#endif
+       device_unregister(edev->dev);
+       put_device(edev->dev);
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);

Thanks,
Chanwoo Choi
