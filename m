Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab2BOGoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 01:44:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38550 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab2BOGoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 01:44:17 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <201202142308.14165.rjw@sisk.pl>
References: <1329196614-6218-1-git-send-email-myungjoo.ham@samsung.com>
	<201202142308.14165.rjw@sisk.pl>
Date: Wed, 15 Feb 2012 15:44:16 +0900
X-Google-Sender-Auth: tjGscCaFKfEAcxMchhfcSCN903o
Message-ID: <CAJ0PZbQLK4R0VJDebdkEF2iE0CyFfR9qEDfZ0YJV4Ob1CzPpfw@mail.gmail.com>
Subject: Re: [RFC PATCH] PM / QoS: add pm_qos_update_request_timeout API
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        markgross <markgross@thegnar.org>, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/15 Rafael J. Wysocki <rjw@sisk.pl>:
> Hi,
>
> On Tuesday, February 14, 2012, MyungJoo Ham wrote:
>> The new API, pm_qos_update_request_timeout() is to provide a timeout
>> with pm_qos_update_request.
>
> I need to know what the other people in the CC list think about that.  It would
> definitely help if you described a use case.

Use case (current implementation in local repositories) w/ user inputs
(touch screen)

Run DVFS mechanism (both CPUfreq and Devfreq) or devices faster when a
user starts an input.
(default: polling every 100ms. with user inputs: polling every 10ms)
or (depending on projects)
(default: 200MHz ~ 1.5GHz. with user inputs: 800MHz ~ 1.5GHz)

Run DVFS mechanism faster (shorter polling interval) when the
userspace expects a sudden and temporal utilization changes or
fluctuations soon (but the utilization may and may not rise much, so
DVFS mechanism needs to react faster, not to increase frequency
unconditionally.): a new application is being loaded or a bulky task
is being loaded.


>
>> For example, pm_qos_update_request_timeout(req, 100, 1000), means that
>> QoS request on req with value 100 will be active for 1000 jiffies.
>
> Could that be a different time unit instead of jiffies?

Um.. yes.. I guess usec would fit here.

>
[]
>>
>>  #define PM_QOS_RESERVED 0
>>  #define PM_QOS_CPU_DMA_LATENCY 1
>> @@ -29,6 +30,8 @@
>>  struct pm_qos_request {
>>       struct plist_node node;
>>       int pm_qos_class;
>> +     s32 value; /* the back-up value for pm_qos_update_request_timeout */
>
> Well, what about "saved_value"?

Yes.. it looks better.

>
>>  /**
>> + * pm_qos_timeout - the timeout handler of pm_qos_update_request_timeout
>> + * @work: work struct for the delayed work (timeout)
>> + *
>> + * This cancels the timeout request and rolls the request value back.
>> + */
>> +static void pm_qos_timeout(struct work_struct *work)
>
> I'd call it pm_qos_work_fn(), so that it's clear what it is.

Ok.. I'll modify it.. How about pm_qos_timeout_work_fn()?

>
[]
>>
>> -     if (new_value != req->node.prio)
>> +     if (delayed_work_pending(&req->work))
>> +             cancel_delayed_work_sync(&req->work);
>> +
>
> That may result in setting the target value to an unwanted one temporarily.
> Namely, if pm_qos_timeout() is already running, it will switch back to the
> "original" target value before the new one is set.  The PM QoS users may see
> the "restored" value and use it in their decision making.  Do we care?

If pm_qos_timeout is already running at this point, QoS-value will be
restored and PM-QoS users (handlers) will react based on the restored
value. And then, these PM-QoS users (handlers) will again react to the
new_value below.

Having one additional and unnecessary PM-QoS users/handers' side
reaction is surely an overhead; however, it happens only if
pm_qos_timeout is already running at the point of this function call.
It pm_qos_timeout is awaiting for "timeout", then it will simply be
canceled.

If we do cancel_delayed_work rather than cancel_delayed_work_sync
here, we then may have serialization problem; the value set by
pm_qos_update_request() is overriden by pm_qos_timeout().

The purpose of modification here is to guarantee that the
pm_qos_timeout(), which is roll-back capability of
pm_qos_update_request_timeout(), won't override QoS request values set
by another pm_qos_update_request() calls.

Or, we may need to add mutexes in request-updating functions and let
the functions serialized.

>
>> +     req->value = new_value;
>> +     if (new_value != req->node.prio) {
>>               pm_qos_update_target(
>>                       pm_qos_array[req->pm_qos_class]->constraints,
>>                       &req->node, PM_QOS_UPDATE_REQ, new_value);
>> +     }
>
> Adding brances here doesn't belong to this patch.

Oops.. I'll remove these braces.

>
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
>
> Please use __func__ in messages like this.

Oh.. yes, I'll. In fact, because it is WARN(), the function name
itself won't be necessary.

>
>> +             return;
>> +
>> +     if (new_value != req->node.prio) {
>> +             pm_qos_update_target(
>> +                     pm_qos_array[req->pm_qos_class]->constraints,
>> +                     &req->node, PM_QOS_UPDATE_REQ, new_value);
>> +             if (delayed_work_pending(&req->work))
>> +                     cancel_delayed_work_sync(&req->work);
>
> It seems that if pm_qos_timeout() has been started already, it will overwrite
> the value that we've just set, or am I missing something?

No, you are not.

I should've put cancel_delayed_work_sync before pm_qos_update_target().



>
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
>>
>
> Thanks,
> Rafael

Thank you so much!


Cheers!
MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
