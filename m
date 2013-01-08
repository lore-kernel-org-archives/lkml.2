Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab3AHSRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:17:47 -0500
Received: from nm4-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.138]:33279
	"EHLO nm4-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756942Ab3AHSRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:17:44 -0500
X-Yahoo-Newman-Id: 570061.35230.bm@smtp107.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LdqF0RkVM1mCyJX5XNDHJhpT8XjJu6mU7M9umlWRo_K1F3z
 iw_kNw.bbzF6La4.M4j9v9Tbxr9Os2xotgTZEQq3iYJs8972PzpwBMWk8ub4
 pC6ls2jjiUka_K6triiLw.8eaqWmS7unn0nEnCty0Z4qPH7F0Ekau0V3XWyD
 4QNdiSw4wlqSqkHUzamY45qcbB8KkJCe4ErqVlkWNTQ8Iam5ycU4GS30D3Ei
 oIMzWDR3vZFfJ83DJLbK8BTIwWtsZUdKD4R_AOxq5Ug17XN_4crqPMtd6w2t
 7Bj9iWX9pQIjpNuyGYJugJ1WkQk0SqRrHZfgx_nFkA8NYHqeL.E60zPeYwvQ
 .2KTNFC6ZvD8X4mb5nuciZapE8y53VhQeU_stx8vqtCb0KVcslB1O13ssW43
 TjC5LyB2GOSl9NqiOsxIEVDp6uhTFUJjce8.xLd1K8Pd1dv51yzIVdrUtnUe
 TdnI6
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EC62D6.5050605@schaufler-ca.com>
Date: Tue, 08 Jan 2013 10:17:58 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: James Morris <jmorris@namei.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com> <50EC5BCD.9000908@tycho.nsa.gov>
In-Reply-To: <50EC5BCD.9000908@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/2013 9:47 AM, Stephen Smalley wrote:
> On 01/07/2013 08:54 PM, Casey Schaufler wrote:
>> Subject: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
>>
>> Change the infrastructure for Linux Security Modules (LSM)s
>> from a single vector of hook handlers to a list based method
>> for handling multiple concurrent modules.
>>
>> A level of indirection has been introduced in the handling of
>> security blobs. LSMs no longer access ->security fields directly,
>> instead they use an abstraction provided by lsm_[gs]et field
>> functions.
>>
>> The XFRM hooks are only used by SELinux and it is not clear
>> that they can be shared. The First LSM that registers using
>> those hooks gets to use them. Any subsequent LSM that uses
>> those hooks is denied registration.
>>
>> Secids have not been made shareable. Only one LSM that uses
>> secids (SELinux and Smack) can be used at a time. The first
>> to register wins.
>>
>> The "security=" boot option takes a comma separated list of
>> LSMs, registering them in the order presented. The LSM hooks
>> will be executed in the order registered. Hooks that return
>> errors are not short circuited. All hooks are called even
>> if one of the LSM hooks fails. The result returned will be
>> that of the last LSM hook that failed.
>>
>> Some hooks don't fit that model. setprocattr, getprocattr,
>> and a few others are special cased. All behavior from
>> security/capability.c has been moved into the hook handling.
>> The security/commoncap functions used to get called from
>> the LSM specific code. The handling of the capability
>> functions has been moved out of the LSMs and into the
>> hook handling.
>>
>> The /proc/*/attr interfaces are given to one LSM. This
>> can be done by setting CONFIG_SECURITY_PRESENT. Additional
>> interfaces have been created in /proc/*/attr so that
>> each LSM has its own named interfaces.
>>
>> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
>
> Have you run any benchmarks, particularly to compare performance
> overhead in the simple case of a single LSM?

My benchmark work is in the early stages and frankly my
facilities are poorly suited to getting real numbers. One of
the things that someone in the community could do that would
be very helpful would be do some such comparisons. I am
working on getting numbers that are defensible, but it will
take a bit of time.

>
> IIRC, the AppArmor devs indicated that they plan to start using
> secids, which would mean that it would not be possible to stack
> AppArmor with Smack or SELinux using this mechanism.  So eventually
> that would have to be addressed in order for this to even support the
> AppArmor+Smack or AppArmor+SELinux use cases.
>
That is my understanding as well. Having groveled around in the
realities of LSM hook usage for some time now I have developed ideas
around the problem. Unfortunately, no one change is going to address
all of the use models. Networking, audit and caching all use secids
in their own clever ways. This is another area where I would be
delighted to entertain suggested implementations.


