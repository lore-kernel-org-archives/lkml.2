Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2JJDhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:37:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49643 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab2JJDhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:37:18 -0400
Date: Tue, 9 Oct 2012 20:37:16 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Huang Ying <ying.huang@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Jean Pihet <j-pihet@ti.com>, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] PM / QoS: Introduce PM QoS device flags support
Message-ID: <20121010033716.GF21067@MGROSS-X220VM>
Reply-To: markgross@thegnar.org
References: <201209282351.10663.rjw@sisk.pl>
 <1413438.1MkXj8vjQK@vostro.rjw.lan>
 <3073514.BL1dL4hrR5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3073514.BL1dL4hrR5@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 10:07:10AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Modify the device PM QoS core code to support PM QoS flags requests.
> 
> First, add a new field of type struct pm_qos_flags called "flags"
> to struct dev_pm_qos for representing the list of PM QoS flags
> requests for the given device.  Accordingly, add a new "type" field
> to struct dev_pm_qos_request (along with an enum for representing
> request types) and a new member called "flr" to its data union for
> representig flags requests.
> 
> Second, modify dev_pm_qos_add_request(), dev_pm_qos_update_request(),
> the internal routine apply_constraint() used by them and their
> existing callers to cover flags requests as well as latency
> requests.  In particular, dev_pm_qos_add_request() gets a new
> argument called "type" for specifying the type of a request to be
> added.
> 
> Finally, introduce two routines, __dev_pm_qos_flags() and
> dev_pm_qos_flags(), allowing their callers to check which PM QoS
> flags have been requested for the given device (the caller is
> supposed to pass the mask of flags to check as the routine's
> second argument and examine its return value for the result).
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Jean Pihet <j-pihet@ti.com>
> ---
>  Documentation/power/pm_qos_interface.txt |    2 
>  drivers/base/power/qos.c                 |  124 ++++++++++++++++++++++++-------
>  drivers/mtd/nand/sh_flctl.c              |    4 -
>  include/linux/pm_qos.h                   |   26 ++++++
>  4 files changed, 127 insertions(+), 29 deletions(-)
> 
> Index: linux/drivers/base/power/qos.c
> ===================================================================
> --- linux.orig/drivers/base/power/qos.c
> +++ linux/drivers/base/power/qos.c
> @@ -48,6 +48,50 @@ static DEFINE_MUTEX(dev_pm_qos_mtx);
>  static BLOCKING_NOTIFIER_HEAD(dev_pm_notifiers);
>  
>  /**
> + * __dev_pm_qos_flags - Check PM QoS flags for a given device.
> + * @dev: Device to check the PM QoS flags for.
> + * @mask: Flags to check against.
> + *
> + * This routine must be called with dev->power.lock held.
> + */
> +enum pm_qos_flags_status __dev_pm_qos_flags(struct device *dev, s32 mask)
> +{
> +	struct dev_pm_qos *qos = dev->power.qos;
> +	struct pm_qos_flags *pqf;
> +	s32 val;
> +
> +	if (!qos)
> +		return PM_QOS_FLAGS_UNDEFINED;
> +
> +	pqf = &qos->flags;
> +	if (list_empty(&pqf->list))
> +		return PM_QOS_FLAGS_UNDEFINED;
> +
> +	val = pqf->effective_flags & mask;
> +	if (val)
> +		return (val == mask) ? PM_QOS_FLAGS_ALL : PM_QOS_FLAGS_SOME;
> +
> +	return PM_QOS_FLAGS_NONE;
> +}
> +
> +/**
> + * dev_pm_qos_flags - Check PM QoS flags for a given device (locked).
> + * @dev: Device to check the PM QoS flags for.
> + * @mask: Flags to check against.
> + */
> +enum pm_qos_flags_status dev_pm_qos_flags(struct device *dev, s32 mask)
> +{
> +	unsigned long irqflags;
> +	enum pm_qos_flags_status ret;
> +
> +	spin_lock_irqsave(&dev->power.lock, irqflags);
> +	ret = __dev_pm_qos_flags(dev, mask);
> +	spin_unlock_irqrestore(&dev->power.lock, irqflags);
> +
> +	return ret;
> +}
> +
> +/**
>   * __dev_pm_qos_read_value - Get PM QoS constraint for a given device.
>   * @dev: Device to get the PM QoS constraint value for.
>   *
> @@ -74,30 +118,39 @@ s32 dev_pm_qos_read_value(struct device
>  	return ret;
>  }
>  
> -/*
> - * apply_constraint
> - * @req: constraint request to apply
> - * @action: action to perform add/update/remove, of type enum pm_qos_req_action
> - * @value: defines the qos request
> +/**
> + * apply_constraint - Add/modify/remove device PM QoS request.
> + * @req: Constraint request to apply
> + * @action: Action to perform (add/update/remove).
> + * @value: Value to assign to the QoS request.
>   *
>   * Internal function to update the constraints list using the PM QoS core
>   * code and if needed call the per-device and the global notification
>   * callbacks
>   */
>  static int apply_constraint(struct dev_pm_qos_request *req,
> -			    enum pm_qos_req_action action, int value)
> +			    enum pm_qos_req_action action, s32 value)
>  {
> -	int ret, curr_value;
> -
> -	ret = pm_qos_update_target(&req->dev->power.qos->latency,
> -				   &req->data.pnode, action, value);
> +	struct dev_pm_qos *qos = req->dev->power.qos;
> +	int ret;
>  
> -	if (ret) {
> -		/* Call the global callbacks if needed */
> -		curr_value = pm_qos_read_value(&req->dev->power.qos->latency);
> -		blocking_notifier_call_chain(&dev_pm_notifiers,
> -					     (unsigned long)curr_value,
> -					     req);
> +	switch(req->type) {
> +	case DEV_PM_QOS_LATENCY:
> +		ret = pm_qos_update_target(&qos->latency, &req->data.pnode,
> +					   action, value);
> +		if (ret) {
> +			value = pm_qos_read_value(&qos->latency);
> +			blocking_notifier_call_chain(&dev_pm_notifiers,
> +						     (unsigned long)value,
> +						     req);
> +		}
> +		break;
> +	case DEV_PM_QOS_FLAGS:
> +		ret = pm_qos_update_flags(&qos->flags, &req->data.flr,
> +					  action, value);
> +		break;
> +	default:
> +		ret = -EINVAL;
>  	}
>  
>  	return ret;
> @@ -134,6 +187,8 @@ static int dev_pm_qos_constraints_alloca
>  	c->type = PM_QOS_MIN;
>  	c->notifiers = n;
>  
> +	INIT_LIST_HEAD(&qos->flags.list);
> +
>  	spin_lock_irq(&dev->power.lock);
>  	dev->power.qos = qos;
>  	spin_unlock_irq(&dev->power.lock);
> @@ -207,6 +262,7 @@ void dev_pm_qos_constraints_destroy(stru
>   * dev_pm_qos_add_request - inserts new qos request into the list
>   * @dev: target device for the constraint
>   * @req: pointer to a preallocated handle
> + * @type: type of the request
>   * @value: defines the qos request
>   *
>   * This function inserts a new entry in the device constraints list of
> @@ -222,7 +278,7 @@ void dev_pm_qos_constraints_destroy(stru
>   * from the system.
>   */
>  int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
> -			   s32 value)
> +			   enum dev_pm_qos_req_type type, s32 value)
>  {
>  	int ret = 0;
>  
> @@ -253,8 +309,10 @@ int dev_pm_qos_add_request(struct device
>  		}
>  	}
>  
> -	if (!ret)
> +	if (!ret) {
> +		req->type = type;
>  		ret = apply_constraint(req, PM_QOS_ADD_REQ, value);
> +	}
>  
>   out:
>  	mutex_unlock(&dev_pm_qos_mtx);
> @@ -281,6 +339,7 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_add_request
>  int dev_pm_qos_update_request(struct dev_pm_qos_request *req,
>  			      s32 new_value)
>  {
> +	s32 curr_value;
>  	int ret = 0;
>  
>  	if (!req) /*guard against callers passing in null */
> @@ -292,15 +351,27 @@ int dev_pm_qos_update_request(struct dev
>  
>  	mutex_lock(&dev_pm_qos_mtx);
>  
> -	if (req->dev->power.qos) {
> -		if (new_value != req->data.pnode.prio)
> -			ret = apply_constraint(req, PM_QOS_UPDATE_REQ,
> -					       new_value);
> -	} else {
> -		/* Return if the device has been removed */
> +	if (!req->dev->power.qos) {
>  		ret = -ENODEV;
> +		goto out;
>  	}
>  
> +	switch(req->type) {
> +	case DEV_PM_QOS_LATENCY:
> +		curr_value = req->data.pnode.prio;
> +		break;
> +	case DEV_PM_QOS_FLAGS:
> +		curr_value = req->data.flr.flags;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (curr_value != new_value)
> +		ret = apply_constraint(req, PM_QOS_UPDATE_REQ, new_value);
> +
> + out:
>  	mutex_unlock(&dev_pm_qos_mtx);
>  	return ret;
>  }
> @@ -451,7 +522,8 @@ int dev_pm_qos_add_ancestor_request(stru
>  		ancestor = ancestor->parent;
>  
>  	if (ancestor)
> -		error = dev_pm_qos_add_request(ancestor, req, value);
> +		error = dev_pm_qos_add_request(ancestor, req,
> +					       DEV_PM_QOS_LATENCY, value);
>  
>  	if (error)
>  		req->dev = NULL;
> @@ -487,7 +559,7 @@ int dev_pm_qos_expose_latency_limit(stru
>  	if (!req)
>  		return -ENOMEM;
>  
> -	ret = dev_pm_qos_add_request(dev, req, value);
> +	ret = dev_pm_qos_add_request(dev, req, DEV_PM_QOS_LATENCY, value);
>  	if (ret < 0)
>  		return ret;
>  
> Index: linux/include/linux/pm_qos.h
> ===================================================================
> --- linux.orig/include/linux/pm_qos.h
> +++ linux/include/linux/pm_qos.h
> @@ -20,6 +20,13 @@ enum {
>  	PM_QOS_NUM_CLASSES,
>  };
>  
> +enum pm_qos_flags_status {
> +	PM_QOS_FLAGS_UNDEFINED = -1,
> +	PM_QOS_FLAGS_NONE,
> +	PM_QOS_FLAGS_SOME,
> +	PM_QOS_FLAGS_ALL,
> +};
> +
>  #define PM_QOS_DEFAULT_VALUE -1
>  
>  #define PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
> @@ -38,9 +45,16 @@ struct pm_qos_flags_request {
>  	s32 flags;	/* Do not change to 64 bit */
>  };
>  
> +enum dev_pm_qos_req_type {
> +	DEV_PM_QOS_LATENCY = 1,
> +	DEV_PM_QOS_FLAGS,
> +};
> +
>  struct dev_pm_qos_request {
> +	enum dev_pm_qos_req_type type;
>  	union {
>  		struct plist_node pnode;
> +		struct pm_qos_flags_request flr;
>  	} data;
>  	struct device *dev;
>  };
> @@ -71,6 +85,7 @@ struct pm_qos_flags {
>  
>  struct dev_pm_qos {
>  	struct pm_qos_constraints latency;
> +	struct pm_qos_flags flags;
>  };
>  
>  /* Action requested to pm_qos_update_target */
> @@ -105,10 +120,12 @@ int pm_qos_request_active(struct pm_qos_
>  s32 pm_qos_read_value(struct pm_qos_constraints *c);
>  
>  #ifdef CONFIG_PM
> +enum pm_qos_flags_status __dev_pm_qos_flags(struct device *dev, s32 mask);
> +enum pm_qos_flags_status dev_pm_qos_flags(struct device *dev, s32 mask);
>  s32 __dev_pm_qos_read_value(struct device *dev);
>  s32 dev_pm_qos_read_value(struct device *dev);
>  int dev_pm_qos_add_request(struct device *dev, struct dev_pm_qos_request *req,
> -			   s32 value);
> +			   enum dev_pm_qos_req_type type, s32 value);
>  int dev_pm_qos_update_request(struct dev_pm_qos_request *req, s32 new_value);
>  int dev_pm_qos_remove_request(struct dev_pm_qos_request *req);
>  int dev_pm_qos_add_notifier(struct device *dev,
> @@ -122,12 +139,19 @@ void dev_pm_qos_constraints_destroy(stru
>  int dev_pm_qos_add_ancestor_request(struct device *dev,
>  				    struct dev_pm_qos_request *req, s32 value);
>  #else
> +static inline enum pm_qos_flags_status __dev_pm_qos_flags(struct device *dev,
> +							  s32 mask)
> +			{ return PM_QOS_FLAGS_UNDEFINED; }
> +static inline enum pm_qos_flags_status dev_pm_qos_flags(struct device *dev,
> +							s32 mask)
> +			{ return PM_QOS_FLAGS_UNDEFINED; }
>  static inline s32 __dev_pm_qos_read_value(struct device *dev)
>  			{ return 0; }
>  static inline s32 dev_pm_qos_read_value(struct device *dev)
>  			{ return 0; }
>  static inline int dev_pm_qos_add_request(struct device *dev,
>  					 struct dev_pm_qos_request *req,
> +					 enum dev_pm_qos_req_type type,
>  					 s32 value)
>  			{ return 0; }
>  static inline int dev_pm_qos_update_request(struct dev_pm_qos_request *req,
> Index: linux/drivers/mtd/nand/sh_flctl.c
> ===================================================================
> --- linux.orig/drivers/mtd/nand/sh_flctl.c
> +++ linux/drivers/mtd/nand/sh_flctl.c
> @@ -710,7 +710,9 @@ static void flctl_select_chip(struct mtd
>  
>  		if (!flctl->qos_request) {
>  			ret = dev_pm_qos_add_request(&flctl->pdev->dev,
> -							&flctl->pm_qos, 100);
> +							&flctl->pm_qos,
> +							DEV_PM_QOS_LATENCY,
> +							100);
>  			if (ret < 0)
>  				dev_err(&flctl->pdev->dev,
>  					"PM QoS request failed: %d\n", ret);
> Index: linux/Documentation/power/pm_qos_interface.txt
> ===================================================================
> --- linux.orig/Documentation/power/pm_qos_interface.txt
> +++ linux/Documentation/power/pm_qos_interface.txt
> @@ -99,7 +99,7 @@ reading the aggregated value does not re
>  
>  From kernel mode the use of this interface is the following:
>  
> -int dev_pm_qos_add_request(device, handle, value):
> +int dev_pm_qos_add_request(device, handle, type, value):
>  Will insert an element into the list for that identified device with the
>  target value.  Upon change to this list the new target is recomputed and any
>  registered notifiers are called only if the target value is now different.
> 
Reviewed-by: mark gross <markgross@thegnar.org>

