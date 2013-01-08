Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3AHEC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 23:02:27 -0500
Received: from nm1.access.bullet.mail.mud.yahoo.com ([66.94.237.202]:23376
	"EHLO nm1.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068Ab3AHEC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 23:02:26 -0500
X-Yahoo-Newman-Id: 150861.63581.bm@smtp110.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4iuyMbwVM1l_i7pOeSSXhTuoDJGqky7jTzCMWzk2Qh7SOAR
 73krNhq63RWIXoR7yj.I7ImEpJ_tNSRRtB0ndc2B2Zx7AKMJNqdsTQYa19kO
 HcGjyRDJUCTjqaO.QdiKECIBK5TZzvWsdNaWZgV0DH.XAT1kmVrwL7fpwG35
 2VvprKHb0g5uurxy91xiqG4M75TmX79.vADwDuBYf3hI83kBJ.A5gQ3EkpO7
 TC2cqtMeQN8.1dJmOHbcdMtV_vNAMgYuFMux7az6arEH3ujpdqPFIIs4_zFr
 c4o0efpmNWUU6vlshotsBTd8l7i3gHMQAnL_lI0F81RCCYowEgtltJFv1V1w
 899dtRuCL.Rr4_Av9LyzAvkf5ENGpBARz_L7npF38Vv66nd7680fCxp2cADG
 .jmWUEn9xUK1TAfuMtP6J3bFseXCyv3vZGc3_MxwZD2fk1jhxobOfwugNXrC
 8drIFNw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EB9A5E.1080306@schaufler-ca.com>
Date: Mon, 07 Jan 2013 20:02:38 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: James Morris <jmorris@namei.org>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com> <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au>
In-Reply-To: <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/7/2013 7:01 PM, Stephen Rothwell wrote:
> Hi Casey,
>
> On Mon, 07 Jan 2013 17:54:24 -0800 Casey Schaufler <casey@schaufler-ca.com> wrote:
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
> Let me ask Andrew's question:  Why do you want to do this (what is the
> use case)?  What does this gain us?

There has been an amazing amount of development in system security
over the past three years. Almost none of it has been in the kernel.
One important reason that it is not getting done in the kernel is
that the current single LSM restriction requires an all or nothing
approach to security. Either you address all your needs with a single
LSM or you have to go with a user space solution, in which case you
may as well do everything in user space.

Multiple concurrent LSMs allows a system to be developed incrementally
and to combine a variety of approaches that meet new and interesting
needs. It allows for systems that are based on an LSM that does not
meet all of the requirements but that can be supplemented by another
LSM that fills the gaps. It allows an LSM like Smack that implements
label based access controls to remain true to its purpose even in the
face of pressure to add controls based on other mechanisms.

I have had requests for running Smack and AppArmor together Tetsuo has
long had need to put SELinux and TOMOYO on the same box. Yama was
recently special cased for stackability.

We are looking at security from different directions than ever before.
What good is a UID on a cell phone? I hear complaints about Android's
"abuse" of the UID. With the option of independent groups creating
smallish LSMs and integrating them by stacking we have the ability to
make the security systems modern devices require using a architecturally
clean model rather than hijacking existing mechanisms that work a
little bit like what you want to do.

I used to believe in a single, integrated security module that addressed
all the issues. Now that Linux is supporting everything from real time
tire pressure gauges in tricycles to the global no-fly list that just
doesn't seem reasonable. We need better turn around on supplemental 
mechanisms. That means collections of smaller, simpler LSMs instead of
monoliths that only a few select individuals or organizations have any
hope of configuring properly.

The topic has been discussed at the past couple of Linux Security Summits
and the only real issue has been who would grind out the code. All of
the existing LSM maintainers are open to stacking. 

> Also, you should use unique subjects for each of the patches in the
> series.
>
Yes, I noticed I'd mucked that up as they flew into the ether.

