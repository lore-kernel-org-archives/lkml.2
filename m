Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab2CZBlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:41:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48396 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2CZBlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:41:15 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20120324163542.GA23888@envy17>
References: <1330491360-1283-1-git-send-email-myungjoo.ham@samsung.com>
	<1331096778-26186-1-git-send-email-myungjoo.ham@samsung.com>
	<20120324163542.GA23888@envy17>
Date: Mon, 26 Mar 2012 10:41:15 +0900
X-Google-Sender-Auth: bLUgdjSDTrJWWDdJ8C63tpsdWK4
Message-ID: <CAJ0PZbSn_gf5yhO4bbmZ8duv19E8zLrKigx0ttb38TY_BOnLyg@mail.gmail.com>
Subject: Re: [PATCH v3] PM / QoS: add pm_qos_update_request_timeout API
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: markgross@thegnar.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2012 at 1:35 AM, mark gross <markgross@thegnar.org> wrote:
> I apologize for the lat replay and admit that I was probably wrong to
> oppose the idea of time out pm_qos requests.  (last week we bumped into
> a need for them and now I get it.)
>
>
> On Wed, Mar 07, 2012 at 02:06:18PM +0900, MyungJoo Ham wrote:
>> The new API, pm_qos_update_request_timeout() is to provide a timeout
>> with pm_qos_update_request.
>>
>> For example, pm_qos_update_request_timeout(req, 100, 1000), means that
>> QoS request on req with value 100 will be active for 1000 jiffies.
>> After 1000 jiffies, the QoS request thru req is rolled back to the
>> request status when pm_qos_update_request_timeout() was called. If there
>> were another pm_qos_update_request(req, x) during the 1000 jiffies, this
>> new request with value x will override as this is another request on the
>> same req handle. A new request on the same req handle will always
>> override the previous request whether it is the conventional request or
>> it is the new timeout request.
>>
>> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
[]
>> @@ -77,6 +79,8 @@ void pm_qos_add_request(struct pm_qos_request *req, int pm_qos_class,
>>                       s32 value);
>>  void pm_qos_update_request(struct pm_qos_request *req,
>>                          s32 new_value);
>> +void pm_qos_update_request_timeout(struct pm_qos_request *req,
>> +                                s32 new_value, unsigned long timeout_ms);
> is ms the right units?  could we ever need us?
>

Because jiffies are used for scheduling tasks, I thought ms should be
fine and having some devices running fast for some msecs longer won't
hurt. However, do you expect scheduling tasks or jiffies may use usecs
later? I don't mind using usecs instead of msecs here; thus, I'll
update this to use usecs. I'll resend patchset soon.


Thanks.

Cheers!
MyungJoo.

>>  void pm_qos_remove_request(struct pm_qos_request *req);
>>
>>  int pm_qos_request(int pm_qos_class);
>> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
>> index 3e122db..8ac8eca 100644
>> --- a/kernel/power/qos.c
>> +++ b/kernel/power/qos.c
>> @@ -259,6 +259,21 @@ int pm_qos_request_active(struct pm_qos_request *req)
>>  EXPORT_SYMBOL_GPL(pm_qos_request_active);
>>
>>  /**
>> + * pm_qos_work_fn - the timeout handler of pm_qos_update_request_timeout
>> + * @work: work struct for the delayed work (timeout)
>> + *
>> + * This cancels the timeout request by falling back to the default at timeout.
>> + */
>> +static void pm_qos_work_fn(struct work_struct *work)
>> +{
>> +     struct pm_qos_request *req = container_of(to_delayed_work(work),
>> +                                               struct pm_qos_request,
>> +                                               work);
>> +
>> +     pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
>> +}
>> +
>> +/**
>>   * pm_qos_add_request - inserts new qos request into the list
>>   * @req: pointer to a preallocated handle
>>   * @pm_qos_class: identifies which list of qos request to use
>> @@ -282,6 +297,7 @@ void pm_qos_add_request(struct pm_qos_request *req,
>>               return;
>>       }
>>       req->pm_qos_class = pm_qos_class;
>> +     INIT_DELAYED_WORK(&req->work, pm_qos_work_fn);
>>       pm_qos_update_target(pm_qos_array[pm_qos_class]->constraints,
>>                            &req->node, PM_QOS_ADD_REQ, value);
>>  }
>> @@ -308,6 +324,9 @@ void pm_qos_update_request(struct pm_qos_request *req,
>>               return;
>>       }
>>
>> +     if (delayed_work_pending(&req->work))
>> +             cancel_delayed_work_sync(&req->work);
>> +
>>       if (new_value != req->node.prio)
>>               pm_qos_update_target(
>>                       pm_qos_array[req->pm_qos_class]->constraints,
>> @@ -316,6 +335,34 @@ void pm_qos_update_request(struct pm_qos_request *req,
>>  EXPORT_SYMBOL_GPL(pm_qos_update_request);
>>
>>  /**
>> + * pm_qos_update_request_timeout - modifies an existing qos request temporarily.
>> + * @req : handle to list element holding a pm_qos request to use
>> + * @new_value: defines the temporal qos request
>> + * @timeout_ms: the effective duration of this qos request in msecs.
>> + *
>> + * After timeout_ms, this qos request is cancelled automatically.
>> + */
>> +void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
>> +                                unsigned long timeout_ms)
>> +{
>> +     if (!req)
>> +             return;
>> +     if (WARN(!pm_qos_request_active(req),
>> +              "%s called for unknown object.", __func__))
>> +             return;
>> +
>> +     if (delayed_work_pending(&req->work))
>> +             cancel_delayed_work_sync(&req->work);
>> +
>> +     if (new_value != req->node.prio)
>> +             pm_qos_update_target(
>> +                     pm_qos_array[req->pm_qos_class]->constraints,
>> +                     &req->node, PM_QOS_UPDATE_REQ, new_value);
>> +
>> +     schedule_delayed_work(&req->work, msecs_to_jiffies(timeout_ms));
>> +}
>> +
>> +/**
>>   * pm_qos_remove_request - modifies an existing qos request
>>   * @req: handle to request list element
>>   *
>> @@ -334,6 +381,9 @@ void pm_qos_remove_request(struct pm_qos_request *req)
>>               return;
>>       }
>>
>> +     if (delayed_work_pending(&req->work))
>> +             cancel_delayed_work_sync(&req->work);
>> +
>>       pm_qos_update_target(pm_qos_array[req->pm_qos_class]->constraints,
>>                            &req->node, PM_QOS_REMOVE_REQ,
>>                            PM_QOS_DEFAULT_VALUE);
>> --
>> 1.7.4.1
>>
>
> Acked-by: Mark Gross <markgross@thegnar.org>
>



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
