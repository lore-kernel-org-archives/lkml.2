Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3AHUBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:01:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55617 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3AHUBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:01:53 -0500
Message-ID: <50EC7B26.4030308@canonical.com>
Date: Tue, 08 Jan 2013 12:01:42 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com> <50EC5BCD.9000908@tycho.nsa.gov>
In-Reply-To: <50EC5BCD.9000908@tycho.nsa.gov>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 09:47 AM, Stephen Smalley wrote:
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
> Have you run any benchmarks, particularly to compare performance overhead in the simple case of a single LSM?
> 
I am very interested in this as well and have been meaning to
do some testing here but haven't had the time yet.

> IIRC, the AppArmor devs indicated that they plan to start using secids, which would mean that it would not be possible to stack AppArmor with Smack or SELinux using this mechanism.  So eventually that would have to be addressed in order for this to even support the AppArmor+Smack or AppArmor+SELinux use cases.
> 
> 
We do intend to use secids, but it is being done so that its
configurable. Configuring it off means you loose apparmor
mediation for the bits that need secids. Solving the secids
issue is of interest but its not required atm.

