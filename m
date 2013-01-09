Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934050Ab3AIUx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:53:29 -0500
Received: from nm26-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.225]:47999
	"EHLO nm26-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932537Ab3AIUx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:53:26 -0500
X-Yahoo-Newman-Id: 208642.20183.bm@smtp104.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: e3nBPR0VM1kibMfU66MYJRhnKZ_m2bJMX572EoDjA6IobpZ
 m5W8AdSp0I3FKZgQqx1ltZnTKOv.2XWUe805c5iJNKnIPnScrWOAi7HBQhKv
 57RvjN5xWBSO_56DwGYPuyIn3ht8XxmvuPUUEy2xVGbFdiwWU_zqiQIZPMOj
 geLGmSx2JFkP4R.JMJHVJhjcg9KBtSfgai4VY.VmR39gGW9th_8fPvfklN2W
 ckmfyVSSB67lPSb9focfy9.xVnpXi4RnfD.7y3l25B2Rp2ENDEIZdk.BYNmz
 b02VRICd93p5e_11esWgDI_zAXXkyAyvSWHOh8TFxjMulu9GxmZKZJ5iJjIY
 FE3OCv0u9pXTrzXmPcoT2wnGkIsaF1JnVuSBvxNRDrDJVcFXwBcE1uHiRMky
 pIw9_v88GkGoAUP4RMv7DdLS9e.qRVtkGw2rSOlPO4B3C62I2jfKFKFQb21H
 Rc_hX
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <50EDD8D4.60003@schaufler-ca.com>
Date: Wed, 09 Jan 2013 12:53:40 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, dwalsh@redhat.com,
        dmalcolm@redhat.com, sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: Friendlier EPERM - Request for input
References: <1357747463.2593.28.camel@localhost>  <1357760637.2593.55.camel@localhost> <50EDCFC0.3010401@schaufler-ca.com> <1357763560.1342.7.camel@localhost>
In-Reply-To: <1357763560.1342.7.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/9/2013 12:32 PM, Eric Paris wrote:
> On Wed, 2013-01-09 at 12:14 -0800, Casey Schaufler wrote:
>> On 1/9/2013 11:43 AM, Eric Paris wrote:
>>> I know many people are worried about information leaks, so I'll right up
>>> front say lets add the sysctl to disable the interface for those who are
>>> concerned about the metadata information leak.  But for most of us I
>>> want that data right when it happens, where it happens, so It can be
>>> exposed, used, and acted upon by the admin trying to troubleshoot why
>>> the shit just hit the fan.
>> How on earth is your webadmin supposed to match the failure
>> of a system call with the content of /proc/8675309/whydiditfail
>> at the time of the failure? It's not like he's going to go into
>> the apache source and add code to look at what's there.
>>
>> Unfortunately, what you probably need is an interface that gives
>> the program access to the audit records it has generated.
> The first thought was wanting to add it by default to perror/strerror in
> libc, but libc guys didn't think it reasonable since it couldn't be
> save/restored across calls, like errno.  Instead I hope for a libc
> function, something like char *get_extended_error_info(void), which
> outputs a localized string based on the information in the /proc
> interface.
>
> Programs like httpd would need to be changed to use this function when
> logging denials.  Programs like python would use this interface to
> populate additional information in the exception they pass up the stack.
>
> I agree that something access to the audit record is appropriate.  It's
> sorta like what I'm proposing.  But audit is not really useful here.  It
> doesn't collect information about any denial other than LSM.  And the
> number of DAC or capabilities denials on a normally operating box is, I
> expect, quite large.  Thus we can't pump them all into audit just on the
> unlikely chance something cares.  Setting a couple of ints is cheap.
> Audit is really nice for people will well defined security goals and
> information retention and analysis purposes, but it kinda completely
> sucks butt for a normal sysadmin or developer...

Let me try again, I think I didn't quite get the idea across.

I'm suggesting that the string returned by get_extended_error_info()
ought to be the audit record the system call would generate, regardless
of whether the audit system would emit it or not.
If the audit record doesn't have the information you need we should
fix the audit system to provide it. Any bit of the information in
the audit record might be relevant, and your admin or developer might
need to see it.

I'm suggesting using the audit record because there are tools to
examine them and it's a pity to use a different format instead of
fixing the one that's already there.

> -Eric
>
>

