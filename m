Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757762Ab2JJDVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 23:21:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55049 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2JJDVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 23:21:23 -0400
Date: Tue, 9 Oct 2012 20:21:20 -0700
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
Subject: Re: [PATCH 2/7] PM / QoS: Introduce request and constraint data
 types for PM QoS flags
Message-ID: <20121010032120.GB21067@MGROSS-X220VM>
Reply-To: markgross@thegnar.org
References: <201209282351.10663.rjw@sisk.pl>
 <1413438.1MkXj8vjQK@vostro.rjw.lan>
 <5257738.DZvocH2moA@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5257738.DZvocH2moA@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 10:05:07AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Introduce struct pm_qos_flags_request and struct pm_qos_flags
> representing PM QoS flags request type and PM QoS flags constraint
> type, respectively.  With these definitions the data structures
> will be arranged so that the list member of a struct pm_qos_flags
> object will contain the head of a list of struct pm_qos_flags_request
> objects representing all of the "flags" requests present for the
> given device.  Then, the effective_flags member of a struct
> pm_qos_flags object will contain the bitwise OR of the flags members
> of all the struct pm_qos_flags_request objects in the list.
> 
> Additionally, introduce helper function pm_qos_update_flags()
> allowing the caller to manage the list of struct pm_qos_flags_request
> pointed to by the list member of struct pm_qos_flags.
> 
> The flags are of type s32 so that the request's "value" field
> is always of the same type regardless of what kind of request it
> is (latency requests already have value fields of type s32).
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Jean Pihet <j-pihet@ti.com>
> ---
>  include/linux/pm_qos.h |   17 +++++++++++--
>  kernel/power/qos.c     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 78 insertions(+), 2 deletions(-)
> 
> Index: linux/include/linux/pm_qos.h
> ===================================================================
> --- linux.orig/include/linux/pm_qos.h
> +++ linux/include/linux/pm_qos.h
> @@ -33,6 +33,11 @@ struct pm_qos_request {
>  	struct delayed_work work; /* for pm_qos_update_request_timeout */
>  };
>  
> +struct pm_qos_flags_request {
> +	struct list_head node;
> +	s32 flags;	/* Do not change to 64 bit */
> +};
> +
>  struct dev_pm_qos_request {
>  	struct plist_node node;
>  	struct device *dev;
> @@ -45,8 +50,8 @@ enum pm_qos_type {
>  };
>  
>  /*
> - * Note: The lockless read path depends on the CPU accessing
> - * target_value atomically.  Atomic access is only guaranteed on all CPU
> + * Note: The lockless read path depends on the CPU accessing target_value
> + * or effective_flags atomically.  Atomic access is only guaranteed on all CPU
>   * types linux supports for 32 bit quantites
>   */
>  struct pm_qos_constraints {
> @@ -57,6 +62,11 @@ struct pm_qos_constraints {
>  	struct blocking_notifier_head *notifiers;
>  };
>  
> +struct pm_qos_flags {
> +	struct list_head list;
> +	s32 effective_flags;	/* Do not change to 64 bit */
> +};
> +
>  struct dev_pm_qos {
>  	struct pm_qos_constraints latency;
>  };
> @@ -75,6 +85,9 @@ static inline int dev_pm_qos_request_act
>  
>  int pm_qos_update_target(struct pm_qos_constraints *c, struct plist_node *node,
>  			 enum pm_qos_req_action action, int value);
> +bool pm_qos_update_flags(struct pm_qos_flags *pqf,
> +			 struct pm_qos_flags_request *req,
> +			 enum pm_qos_req_action action, s32 val);
>  void pm_qos_add_request(struct pm_qos_request *req, int pm_qos_class,
>  			s32 value);
>  void pm_qos_update_request(struct pm_qos_request *req,
> Index: linux/kernel/power/qos.c
> ===================================================================
> --- linux.orig/kernel/power/qos.c
> +++ linux/kernel/power/qos.c
> @@ -213,6 +213,69 @@ int pm_qos_update_target(struct pm_qos_c
>  }
>  
>  /**
> + * pm_qos_flags_remove_req - Remove device PM QoS flags request.
> + * @pqf: Device PM QoS flags set to remove the request from.
> + * @req: Request to remove from the set.
> + */
> +static void pm_qos_flags_remove_req(struct pm_qos_flags *pqf,
> +				    struct pm_qos_flags_request *req)
> +{
> +	s32 val = 0;
> +
> +	list_del(&req->node);
> +	list_for_each_entry(req, &pqf->list, node)
> +		val |= req->flags;
> +
> +	pqf->effective_flags = val;
> +}
> +
> +/**
> + * pm_qos_update_flags - Update a set of PM QoS flags.
> + * @pqf: Set of flags to update.
> + * @req: Request to add to the set, to modify, or to remove from the set.
> + * @action: Action to take on the set.
> + * @val: Value of the request to add or modify.
> + *
> + * Update the given set of PM QoS flags and call notifiers if the aggregate
> + * value has changed.  Returns 1 if the aggregate constraint value has changed,
> + * 0 otherwise.
> + */
> +bool pm_qos_update_flags(struct pm_qos_flags *pqf,
> +			 struct pm_qos_flags_request *req,
> +			 enum pm_qos_req_action action, s32 val)
> +{
> +	unsigned long irqflags;
> +	s32 prev_value, curr_value;
> +
> +	spin_lock_irqsave(&pm_qos_lock, irqflags);
> +
> +	prev_value = list_empty(&pqf->list) ? 0 : pqf->effective_flags;
> +
> +	switch (action) {
> +	case PM_QOS_REMOVE_REQ:
> +		pm_qos_flags_remove_req(pqf, req);
> +		break;
> +	case PM_QOS_UPDATE_REQ:
> +		pm_qos_flags_remove_req(pqf, req);
> +	case PM_QOS_ADD_REQ:
> +		req->flags = val;
> +		INIT_LIST_HEAD(&req->node);
> +		list_add_tail(&req->node, &pqf->list);
> +		pqf->effective_flags |= val;
> +		break;
> +	default:
> +		/* no action */
> +		;
> +	}
> +
> +	curr_value = list_empty(&pqf->list) ? 0 : pqf->effective_flags;
> +
> +	spin_unlock_irqrestore(&pm_qos_lock, irqflags);
> +
> +	return prev_value != curr_value;
> +}
> +
> +/**
>   * pm_qos_request - returns current system wide qos expectation
>   * @pm_qos_class: identification of which qos value is requested
>   *
> 

acked-by: mark gross <markgross@thegnar.org>
--mark

