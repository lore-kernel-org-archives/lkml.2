Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab0KPAZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 19:25:52 -0500
Received: from adelie.canonical.com ([91.189.90.139]:58556 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0KPAZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 19:25:50 -0500
Message-ID: <4CE1CF88.2090702@canonical.com>
Date: Mon, 15 Nov 2010 16:25:44 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: wzt wzt <wzt.wzt@gmail.com>
CC: linux-kernel@vger.kernel.org, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] APPARMOR: code cleanup on context.h
References: <20101113023435.GB2713@localhost.localdomain> <AANLkTikrdQw1h=efa7EtnXCbQ5APT0PtWdaCUA83T5pN@mail.gmail.com>
In-Reply-To: <AANLkTikrdQw1h=efa7EtnXCbQ5APT0PtWdaCUA83T5pN@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 03:29 PM, wzt wzt wrote:
> hi, john, any comments?
> 
Hi, yes sorry I am just trying to dig my self out from under a 4 day weekend :)

ACK, I am going to add it to the apparmor tree tonight once I finish cleaning the
tree up and push, and it will be included in the next pull request to security.

thanks
john

> On Sat, Nov 13, 2010 at 10:34 AM,  <wzt.wzt@gmail.com> wrote:
>> Use current api to replace old codes.
>>
>> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
>>
>> ---
>>  security/apparmor/include/context.h |   34 +++++++++++++++-------------------
>>  1 files changed, 15 insertions(+), 19 deletions(-)
>>
>> diff --git a/security/apparmor/include/context.h b/security/apparmor/include/context.h
>> index a9cbee4..c9112f3 100644
>> --- a/security/apparmor/include/context.h
>> +++ b/security/apparmor/include/context.h
>> @@ -82,23 +82,6 @@ int aa_set_current_hat(struct aa_profile *profile, u64 token);
>>  int aa_restore_previous_profile(u64 cookie);
>>
>>  /**
>> - * __aa_task_is_confined - determine if @task has any confinement
>> - * @task: task to check confinement of  (NOT NULL)
>> - *
>> - * If @task != current needs to be called in RCU safe critical section
>> - */
>> -static inline bool __aa_task_is_confined(struct task_struct *task)
>> -{
>> -       struct aa_task_cxt *cxt = __task_cred(task)->security;
>> -
>> -       BUG_ON(!cxt || !cxt->profile);
>> -       if (unconfined(aa_newest_version(cxt->profile)))
>> -               return 0;
>> -
>> -       return 1;
>> -}
>> -
>> -/**
>>  * aa_cred_profile - obtain cred's profiles
>>  * @cred: cred to obtain profiles from  (NOT NULL)
>>  *
>> @@ -138,9 +121,8 @@ static inline struct aa_profile *aa_current_profile(void)
>>  {
>>        const struct aa_task_cxt *cxt = current_cred()->security;
>>        struct aa_profile *profile;
>> -       BUG_ON(!cxt || !cxt->profile);
>>
>> -       profile = aa_newest_version(cxt->profile);
>> +       profile = __aa_current_profile();
>>        /*
>>         * Whether or not replacement succeeds, use newest profile so
>>         * there is no need to update it after replacement.
>> @@ -151,4 +133,18 @@ static inline struct aa_profile *aa_current_profile(void)
>>        return profile;
>>  }
>>
>> +/**
>> + * __aa_task_is_confined - determine if @task has any confinement
>> + * @task: task to check confinement of  (NOT NULL)
>> + *
>> + * If @task != current needs to be called in RCU safe critical section
>> + */
>> +static inline bool __aa_task_is_confined(struct task_struct *task)
>> +{
>> +       if (unconfined(aa_cred_profile(__task_cred(task))))
>> +               return 0;
>> +
>> +       return 1;
>> +}
>> +
>>  #endif /* __AA_CONTEXT_H */
>> --
>> 1.6.5.3
>>
>>

