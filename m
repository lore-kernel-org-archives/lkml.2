Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933786Ab0GOQgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:36:53 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39616 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933695Ab0GOQgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:36:51 -0400
Message-ID: <4C3F391E.5060408@canonical.com>
Date: Thu, 15 Jul 2010 09:36:46 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 02/13] AppArmor: basic auditing infrastructure.
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>	<1279154621-25868-3-git-send-email-john.johansen@canonical.com> <AANLkTimGhmUiCMMWaDs5aV4Hg86QvQJs3ZFUSqAdlKAt@mail.gmail.com>
In-Reply-To: <AANLkTimGhmUiCMMWaDs5aV4Hg86QvQJs3ZFUSqAdlKAt@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 08:18 AM, Eric Paris wrote:
> On Wed, Jul 14, 2010 at 8:43 PM, John Johansen
> <john.johansen@canonical.com> wrote:
>> Update lsm_audit for AppArmor specific data, and add the core routines for
>> AppArmor uses for auditing.
>>
>> Signed-off-by: John Johansen <john.johansen@canonical.com>
> 
>> + * Currently AppArmor auditing is fed straight into the audit framework.
>> + *
>> + * TODO:
>> + * convert to LSM audit
> 
> 
oops, I missed that one, it should have been removed.

>> +       if (sa->aad.profile) {
>> +               struct aa_profile *profile = sa->aad.profile;
>> +               pid_t pid;
>> +               rcu_read_lock();
>> +               pid = tsk->real_parent->pid;
>> +               rcu_read_unlock();
>> +               audit_log_format(ab, " parent=%d", pid);
>> +               audit_log_format(ab, " profile=");
>> +               if (profile->ns != root_ns) {
>> +                       audit_log_format(ab, ":");
>> +                       audit_log_untrustedstring(ab, profile->ns->base.hname);
>> +                       audit_log_format(ab, "://");
>> +               }
>> +               audit_log_untrustedstring(ab, profile->base.hname);
>> +       }
> 
> what does this message look like?  I don't think it fits the nice
> key=value rules of the audit system....   Are you sure this is what
> you want?
>
it looks like
profile=:ns_name://profile_name

which could be fed straight back in as a valid profile name.  Profile names can
be expressed relative to the namespace, or absolute with the profile namespace name
prepended.  In this case relative namespace reporting is used only for the root_ns
because that is what was traditionally done.

So it is a single value following the rules.

The alternative of outputting the profile namespace name as a separate is also valid,
and I am actually indifferent as to which way it is reported.


>> +#define COMMON_AUDIT_DATA_INIT_NONE(_d) \
>> +       do { \
>> +               memset((_d), 0, sizeof(struct common_audit_data)); \
>> +               (_d)->type = LSM_AUDIT_DATA_NONE; \
>> +       } while (0)
>> +
>> +#endif /* __AA_AUDIT_H */
> 
> Why are you redefining this?  You should just use
> COMMON_AUDIT_DATA_INIT(sa, NONE);

oops, I actually have that patch, and missed applying to the branch, this was
originally added when COMMON_AUDIT_DATA_INIT(sa, NONE) didn't work.  

thanks Eric
