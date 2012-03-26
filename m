Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2CZUcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:32:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36523 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab2CZUcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:32:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 2/6] firmware_class: Split _request_firmware() into three functions
Date: Mon, 26 Mar 2012 22:36:58 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203260001.46109.rjw@sisk.pl> <4F70B25E.60505@codeaurora.org>
In-Reply-To: <4F70B25E.60505@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203262236.59126.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 26, 2012, Stephen Boyd wrote:
> On 03/25/12 15:01, Rafael J. Wysocki wrote:
> >  drivers/base/firmware_class.c |   57 +++++++++++++++++++++++++++++-------------
> >  1 file changed, 40 insertions(+), 17 deletions(-)
> >
> > Index: linux/drivers/base/firmware_class.c
> > ===================================================================
> > --- linux.orig/drivers/base/firmware_class.c
> > +++ linux/drivers/base/firmware_class.c
> > @@ -435,7 +435,7 @@ static void firmware_class_timeout(u_lon
> >  }
> >  
> >  static struct firmware_priv *
> > -fw_create_instance(struct firmware *firmware, const char *fw_name,
> > +fw_create_instance(const struct firmware *firmware, const char *fw_name,
> >  		   struct device *device, bool uevent, bool nowait)
> >  {
> >  	struct firmware_priv *fw_priv;
> > @@ -449,7 +449,7 @@ fw_create_instance(struct firmware *firm
> >  		goto err_out;
> >  	}
> >  
> > -	fw_priv->fw = firmware;
> > +	fw_priv->fw = (struct firmware *)firmware;
> >  	fw_priv->nowait = nowait;
> >  	strcpy(fw_priv->fw_id, fw_name);
> >  	init_completion(&fw_priv->completion);
> 
> Can we avoid this cast? If we do some parts of fw_create_instance()
> during the setup phase I think we can avoid it.

Yes, we can, but I'm not sure I'd like to make so many changes at once.

> > @@ -639,8 +655,15 @@ static int request_firmware_work_func(vo
> >  		return 0;
> >  	}
> >  
> > -	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
> > +	ret = _request_firmware_prepare(&fw, fw_work->name, fw_work->device);
> > +	if (ret <= 0)
> > +		return ret;
> 
> This needs to jump to the cont function so that users know loading
> failed or that the firmware was builtin.

You're right, sorry.  That should have been

	if (ret > 0) {
		ret = _request_firmware(fw, fw_work->name, fw_work->device,
			fw_work->uevent, true);
		if (ret)
			_request_firmware_cleanup(&fw);
	}

but actually using a jump makes the next patch look better.

Updated patch is appended.

> > +
> > +	ret = _request_firmware(fw, fw_work->name, fw_work->device,
> >  				fw_work->uevent, true);
> > +	if (ret)
> > +		_request_firmware_cleanup(&fw);
> > +
> >  	fw_work->cont(fw, fw_work->context);
> >  
> >  	module_put(fw_work->module);
> >
> 
> Here's a compile only tested patch on top. The idea is return a fw_priv
> pointer from the setup function and use that to indicate failure (error
> pointer), builtin (NULL) or loadable (non-NULL). Then we can move all
> the uevent/device stuff to the loading phase

Good.  Can you please send that as a patch on top of the whole series?
I'd like to avoid mixing your code with mine.  Also, I'd rather avoid
invalidating tests that have been carried out already with this series by
adding changes in the middle of it.

> ----8<-----
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 5db254d..fbe98a8 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -440,13 +440,11 @@ fw_create_instance(const struct firmware *firmware, const char *fw_name,
>  {
>  	struct firmware_priv *fw_priv;
>  	struct device *f_dev;
> -	int error;
>  
>  	fw_priv = kzalloc(sizeof(*fw_priv) + strlen(fw_name) + 1 , GFP_KERNEL);
>  	if (!fw_priv) {
>  		dev_err(device, "%s: kmalloc failed\n", __func__);
> -		error = -ENOMEM;
> -		goto err_out;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  
>  	fw_priv->fw = (struct firmware *)firmware;
> @@ -463,42 +461,7 @@ fw_create_instance(const struct firmware *firmware, const char *fw_name,
>  	f_dev->parent = device;
>  	f_dev->class = &firmware_class;
>  
> -	dev_set_uevent_suppress(f_dev, true);
> -
> -	/* Need to pin this module until class device is destroyed */
> -	__module_get(THIS_MODULE);
> -
> -	error = device_add(f_dev);
> -	if (error) {
> -		dev_err(device, "%s: device_register failed\n", __func__);
> -		goto err_put_dev;
> -	}
> -
> -	error = device_create_bin_file(f_dev, &firmware_attr_data);
> -	if (error) {
> -		dev_err(device, "%s: sysfs_create_bin_file failed\n", __func__);
> -		goto err_del_dev;
> -	}
> -
> -	error = device_create_file(f_dev, &dev_attr_loading);
> -	if (error) {
> -		dev_err(device, "%s: device_create_file failed\n", __func__);
> -		goto err_del_bin_attr;
> -	}
> -
> -	if (uevent)
> -		dev_set_uevent_suppress(f_dev, false);
> -
>  	return fw_priv;
> -
> -err_del_bin_attr:
> -	device_remove_bin_file(f_dev, &firmware_attr_data);
> -err_del_dev:
> -	device_del(f_dev);
> -err_put_dev:
> -	put_device(f_dev);
> -err_out:
> -	return ERR_PTR(error);
>  }
>  
>  static void fw_destroy_instance(struct firmware_priv *fw_priv)
> @@ -510,27 +473,34 @@ static void fw_destroy_instance(struct firmware_priv *fw_priv)
>  	device_unregister(f_dev);
>  }
>  
> -static int _request_firmware_prepare(const struct firmware **firmware_p,
> -				     const char *name, struct device *device)
> +static struct firmware_priv *
> +_request_firmware_prepare(const struct firmware **firmware_p, const char *name,
> +			  struct device *device, bool uevent, bool nowait)
>  {
>  	struct firmware *firmware;
> +	struct firmware_priv *fw_priv;
>  
>  	if (!firmware_p)
> -		return -EINVAL;
> +		return ERR_PTR(-EINVAL);
>  
>  	*firmware_p = firmware = kzalloc(sizeof(*firmware), GFP_KERNEL);
>  	if (!firmware) {
>  		dev_err(device, "%s: kmalloc(struct firmware) failed\n",
>  			__func__);
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  
>  	if (fw_get_builtin_firmware(firmware, name)) {
>  		dev_dbg(device, "firmware: using built-in firmware %s\n", name);
> -		return 0;
> +		return NULL;
>  	}
>  
> -	return 1;
> +	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
> +	if (IS_ERR(fw_priv)) {
> +		release_firmware(firmware);
> +		*firmware_p = NULL;
> +	}
> +	return fw_priv;
>  }
>  
>  static void _request_firmware_cleanup(const struct firmware **firmware_p)
> @@ -539,29 +509,44 @@ static void _request_firmware_cleanup(const struct firmware **firmware_p)
>  	*firmware_p = NULL;
>  }
>  
> -static int _request_firmware(const struct firmware *firmware,
> -			     const char *name, struct device *device,
> -			     bool uevent, bool nowait)
> +static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent)
>  {
> -	struct firmware_priv *fw_priv;
>  	int retval;
> +	struct device *f_dev = &fw_priv->dev;
>  
>  	retval = usermodehelper_read_trylock();
>  	if (WARN_ON(retval)) {
> -		dev_err(device, "firmware: %s will not be loaded\n", name);
> +		dev_err(f_dev, "firmware: %s will not be loaded\n",
> +				fw_priv->fw_id);
>  		return retval;
>  	}
>  
> -	if (uevent)
> -		dev_dbg(device, "firmware: requesting %s\n", name);
> +	dev_set_uevent_suppress(f_dev, true);
>  
> -	fw_priv = fw_create_instance(firmware, name, device, uevent, nowait);
> -	if (IS_ERR(fw_priv)) {
> -		retval = PTR_ERR(fw_priv);
> -		goto out;
> +	/* Need to pin this module until class device is destroyed */
> +	__module_get(THIS_MODULE);
> +
> +	retval = device_add(f_dev);
> +	if (retval) {
> +		dev_err(f_dev, "%s: device_register failed\n", __func__);
> +		goto err_put_dev;
> +	}
> +
> +	retval = device_create_bin_file(f_dev, &firmware_attr_data);
> +	if (retval) {
> +		dev_err(f_dev, "%s: sysfs_create_bin_file failed\n", __func__);
> +		goto err_del_dev;
> +	}
> +
> +	retval = device_create_file(f_dev, &dev_attr_loading);
> +	if (retval) {
> +		dev_err(f_dev, "%s: device_create_file failed\n", __func__);
> +		goto err_del_bin_attr;
>  	}
>  
>  	if (uevent) {
> +		dev_set_uevent_suppress(f_dev, false);
> +		dev_dbg(f_dev, "firmware: requesting %s\n", fw_priv->fw_id);
>  		if (loading_timeout > 0)
>  			mod_timer(&fw_priv->timeout,
>  				  round_jiffies_up(jiffies +
> @@ -586,6 +571,14 @@ static int _request_firmware(const struct firmware *firmware,
>  out:
>  	usermodehelper_read_unlock();
>  	return retval;
> +
> +err_del_bin_attr:
> +	device_remove_bin_file(f_dev, &firmware_attr_data);
> +err_del_dev:
> +	device_del(f_dev);
> +err_put_dev:
> +	put_device(f_dev);
> +	goto out;
>  }
>  
>  /**
> @@ -607,13 +600,15 @@ int
>  request_firmware(const struct firmware **firmware_p, const char *name,
>                   struct device *device)
>  {
> +	struct firmware_priv *fw_priv;
>  	int ret;
>  
> -	ret = _request_firmware_prepare(firmware_p, name, device);
> -	if (ret <= 0)
> -		return ret;
> +	fw_priv = _request_firmware_prepare(firmware_p, name, device, true,
> +					    false);
> +	if (IS_ERR_OR_NULL(fw_priv))
> +		return PTR_RET(fw_priv);
>  
> -	ret = _request_firmware(*firmware_p, name, device, true, false);
> +	ret = _request_firmware_load(fw_priv, true);
>  	if (ret)
>  		_request_firmware_cleanup(firmware_p);
>  
> @@ -648,6 +643,7 @@ static int request_firmware_work_func(void *arg)
>  {
>  	struct firmware_work *fw_work = arg;
>  	const struct firmware *fw;
> +	struct firmware_priv *fw_priv;
>  	int ret;
>  
>  	if (!arg) {
> @@ -655,15 +651,18 @@ static int request_firmware_work_func(void *arg)
>  		return 0;
>  	}
>  
> -	ret = _request_firmware_prepare(&fw, fw_work->name, fw_work->device);
> -	if (ret <= 0)
> -		return ret;
> +	fw_priv = _request_firmware_prepare(&fw, fw_work->name, fw_work->device,
> +			fw_work->uevent, true);
> +	if (IS_ERR_OR_NULL(fw_priv)) {
> +		ret = PTR_RET(fw_priv);
> +		goto out;
> +	}
>  
> -	ret = _request_firmware(fw, fw_work->name, fw_work->device,
> -				fw_work->uevent, true);
> +	ret = _request_firmware_load(fw_priv, fw_work->uevent);
>  	if (ret)
>  		_request_firmware_cleanup(&fw);
>  
> +out:
>  	fw_work->cont(fw, fw_work->context);
>  
>  	module_put(fw_work->module);

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: firmware_class: Split _request_firmware() into three functions, v2

Split _request_firmware() into three functions,
_request_firmware_prepare() doing preparatory work that need not be
done under umhelper_sem, _request_firmware_cleanup() doing the
post-error cleanup and _request_firmware() carrying out the remaining
operations.

This change is requisite for moving the acquisition of umhelper_sem
from _request_firmware() to the callers, which is going to be done
subsequently.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/firmware_class.c |   58 +++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 17 deletions(-)

Index: linux/drivers/base/firmware_class.c
===================================================================
--- linux.orig/drivers/base/firmware_class.c
+++ linux/drivers/base/firmware_class.c
@@ -435,7 +435,7 @@ static void firmware_class_timeout(u_lon
 }
 
 static struct firmware_priv *
-fw_create_instance(struct firmware *firmware, const char *fw_name,
+fw_create_instance(const struct firmware *firmware, const char *fw_name,
 		   struct device *device, bool uevent, bool nowait)
 {
 	struct firmware_priv *fw_priv;
@@ -449,7 +449,7 @@ fw_create_instance(struct firmware *firm
 		goto err_out;
 	}
 
-	fw_priv->fw = firmware;
+	fw_priv->fw = (struct firmware *)firmware;
 	fw_priv->nowait = nowait;
 	strcpy(fw_priv->fw_id, fw_name);
 	init_completion(&fw_priv->completion);
@@ -510,13 +510,10 @@ static void fw_destroy_instance(struct f
 	device_unregister(f_dev);
 }
 
-static int _request_firmware(const struct firmware **firmware_p,
-			     const char *name, struct device *device,
-			     bool uevent, bool nowait)
+static int _request_firmware_prepare(const struct firmware **firmware_p,
+				     const char *name, struct device *device)
 {
-	struct firmware_priv *fw_priv;
 	struct firmware *firmware;
-	int retval = 0;
 
 	if (!firmware_p)
 		return -EINVAL;
@@ -533,10 +530,26 @@ static int _request_firmware(const struc
 		return 0;
 	}
 
+	return 1;
+}
+
+static void _request_firmware_cleanup(const struct firmware **firmware_p)
+{
+	release_firmware(*firmware_p);
+	*firmware_p = NULL;
+}
+
+static int _request_firmware(const struct firmware *firmware,
+			     const char *name, struct device *device,
+			     bool uevent, bool nowait)
+{
+	struct firmware_priv *fw_priv;
+	int retval;
+
 	retval = usermodehelper_read_trylock();
 	if (WARN_ON(retval)) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
-		goto out_nolock;
+		return retval;
 	}
 
 	if (uevent)
@@ -572,13 +585,6 @@ static int _request_firmware(const struc
 
 out:
 	usermodehelper_read_unlock();
-
-out_nolock:
-	if (retval) {
-		release_firmware(firmware);
-		*firmware_p = NULL;
-	}
-
 	return retval;
 }
 
@@ -601,7 +607,17 @@ int
 request_firmware(const struct firmware **firmware_p, const char *name,
                  struct device *device)
 {
-        return _request_firmware(firmware_p, name, device, true, false);
+	int ret;
+
+	ret = _request_firmware_prepare(firmware_p, name, device);
+	if (ret <= 0)
+		return ret;
+
+	ret = _request_firmware(*firmware_p, name, device, true, false);
+	if (ret)
+		_request_firmware_cleanup(firmware_p);
+
+	return ret;
 }
 
 /**
@@ -639,8 +655,16 @@ static int request_firmware_work_func(vo
 		return 0;
 	}
 
-	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
+	ret = _request_firmware_prepare(&fw, fw_work->name, fw_work->device);
+	if (ret <= 0)
+		goto out;
+
+	ret = _request_firmware(fw, fw_work->name, fw_work->device,
 				fw_work->uevent, true);
+	if (ret)
+		_request_firmware_cleanup(&fw);
+
+ out:
 	fw_work->cont(fw, fw_work->context);
 
 	module_put(fw_work->module);
