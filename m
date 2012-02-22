Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2BVInk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:43:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50829 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2BVIni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:43:38 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20120219211451.GA26578@envy17>
References: <1329196614-6218-1-git-send-email-myungjoo.ham@samsung.com>
	<20120219211451.GA26578@envy17>
Date: Wed, 22 Feb 2012 17:43:38 +0900
X-Google-Sender-Auth: NXYOhOWBHAdP255mSyAnLx7HE0M
Message-ID: <CAJ0PZbS0qZ=Z8Rnfz4N+7-mnuH+U=U_Kp=c1z4=jwreHTXLA+w@mail.gmail.com>
Subject: Re: [RFC PATCH] PM / QoS: add pm_qos_update_request_timeout API
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: markgross@thegnar.org
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Jean Pihet <j-pihet@ti.com>, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 6:14 AM, mark gross <markgross@thegnar.org> wrote:
> On Tue, Feb 14, 2012 at 02:16:54PM +0900, MyungJoo Ham wrote:
>>
>>  #define PM_QOS_RESERVED 0
>>  #define PM_QOS_CPU_DMA_LATENCY 1
>> @@ -29,6 +30,8 @@
>>  struct pm_qos_request {
>>       struct plist_node node;
>>       int pm_qos_class;
>> +     s32 value; /* the back-up value for pm_qos_update_request_timeout */
> Why can't we just drop back to the qos_class default? or auto remove
> the time out request from the list?

It is to fall back to previously set pm_qos request after a timeout.

If the user did pm_qos_update_request(X) and then
pm_qos_update_request_timeout(Y), then it seems fair to return back to
X after the timeout.

With a single req struct, I intended to allow both non-timeout API and
timeout API at the same time.

>
>> +     struct delayed_work work; /* for pm_qos_update_request_timeout */
>>  };
>>
>>  struct dev_pm_qos_request {
>> @@ -74,6 +77,8 @@ void pm_qos_add_request(struct pm_qos_request *req, int pm_qos_class,
>>                       s32 value);
>>  void pm_qos_update_request(struct pm_qos_request *req,
>>                          s32 new_value);
>> +void pm_qos_update_request_timeout(struct pm_qos_request *req,
>> +                                s32 new_value, unsigned long timeout);
> Don't you need 2 values?  one for the request and one for the time out
> request target?

Ah.... you want pm_qos_update_request_timeout to timeout the recent
QoS request on the same req object.

I intended to allow adding both timeout request and non-time request
on the same req object.


However, it appears that the approach you've imagined is better as the
PM QoS framework has been allowing one request through one req object.

Then, we won't need the backup value described above.

I'll change the semmantics of this API in the next iteration.

>
> I tend to not like time out api's.  They are race conditions waiting to
> happen.
>
> The caller could have its own timer that can simply go off and update the
> requested qos.
>

Yes, we have been doing so and resulted in creating time-out work here
and there all over the places repeatedly. And I hoped this would clear
them off.


> I understand that you need to bump performance up for a short time to get good
> interactivity but I don't know if it should be generalized or if this is
> a good enough of a generalization.
>
> --mark
>

Hm... I thought many mobile devices would need or have been already
using this feature (frequency-up with timeout for input events), but I
guess we'll need more opinions on this.

Thanks so much for the comments.


Cheers!
MyungJoo.

>>  void pm_qos_remove_request(struct pm_qos_request *req);
>>
>>  int pm_qos_request(int pm_qos_class);
>> diff --git a/kernel/power/qos.c b/kernel/power/qos.c
>> index b15e0b7..acfa433 100644
>> --- a/kernel/power/qos.c
>> +++ b/kernel/power/qos.c
>> @@ -259,6 +259,21 @@ int pm_qos_request_active(struct pm_qos_request *req)
>>  EXPORT_SYMBOL_GPL(pm_qos_request_active);
>>
>>  /**
>> + * pm_qos_timeout - the timeout handler of pm_qos_update_request_timeout
>> + * @work: work struct for the delayed work (timeout)
>> + *
>> + * This cancels the timeout request and rolls the request value back.
>> + */
>> +static void pm_qos_timeout(struct work_struct *work)
>> +{
>> +     struct pm_qos_request *req = container_of(to_delayed_work(work),
>> +                                               struct pm_qos_request,
>> +                                               work);
>> +
>> +     pm_qos_update_request(req, req->value);
>> +}
>> +
>> +/**
>>   * pm_qos_add_request - inserts new qos request into the list
>>   * @req: pointer to a preallocated handle
>>   * @pm_qos_class: identifies which list of qos request to use
>> @@ -282,6 +297,8 @@ void pm_qos_add_request(struct pm_qos_request *req,
>>               return;
>>       }
>>       req->pm_qos_class = pm_qos_class;
>> +     req->value = value;
>> +     INIT_DELAYED_WORK(&req->work, pm_qos_timeout);
>>       pm_qos_update_target(pm_qos_array[pm_qos_class]->constraints,
>>                            &req->node, PM_QOS_ADD_REQ, value);
>>  }
>> @@ -308,14 +325,46 @@ void pm_qos_update_request(struct pm_qos_request *req,
>>               return;
>>       }
>>
>> -     if (new_value != req->node.prio)
>> +     if (delayed_work_pending(&req->work))
>> +             cancel_delayed_work_sync(&req->work);
>> +
>> +     req->value = new_value;
>> +     if (new_value != req->node.prio) {
>>               pm_qos_update_target(
>>                       pm_qos_array[req->pm_qos_class]->constraints,
>>                       &req->node, PM_QOS_UPDATE_REQ, new_value);
>> +     }
>>  }
>>  EXPORT_SYMBOL_GPL(pm_qos_update_request);
>>
>>  /**
>> + * pm_qos_update_request_timeout - modifies an existing qos request temporarily.
>> + * @req : handle to list element holding a pm_qos request to use
>> + * @new_value: defines the temporal qos request
>> + * @timeout: the effective duration of this qos request in jiffies
>> + *
>> + * After timeout, this qos request is cancelled automatically.
>> + */
>> +void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
>> +                                unsigned long timeout)
>> +{
>> +     if (!req)
>> +             return;
>> +     if (WARN(!pm_qos_request_active(req),
>> +              "pm_qos_update_request_timeout() called for unknown object."))
>> +             return;
>> +
>> +     if (new_value != req->node.prio) {
>> +             pm_qos_update_target(
>> +                     pm_qos_array[req->pm_qos_class]->constraints,
>> +                     &req->node, PM_QOS_UPDATE_REQ, new_value);
>> +             if (delayed_work_pending(&req->work))
>> +                     cancel_delayed_work_sync(&req->work);
>> +             schedule_delayed_work(&req->work, timeout);
>> +     }
>> +}
>> +
>> +/**
>>   * pm_qos_remove_request - modifies an existing qos request
>>   * @req: handle to request list element
>>   *
>> @@ -334,6 +383,9 @@ void pm_qos_remove_request(struct pm_qos_request *req)
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



-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
