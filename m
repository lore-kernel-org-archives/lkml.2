Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab0GKOZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 10:25:29 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48607 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0GKOZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 10:25:28 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Containers <containers@lists.osdl.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <20100625192945.GA25532@redhat.com>
	<20100625212618.GA11917@us.ibm.com>
	<20100625212758.GA30474@redhat.com>
	<20100625220713.GA31123@us.ibm.com>
	<m1r5jd5l0v.fsf_-_@fess.ebiederm.org>
	<m1mxu15kv4.fsf_-_@fess.ebiederm.org>
	<20100709121425.GB18586@hawkmoon.kerlabs.com>
	<m1lj9k4xfx.fsf@fess.ebiederm.org>
	<20100709141324.GC18586@hawkmoon.kerlabs.com>
	<m1aaq04ph2.fsf_-_@fess.ebiederm.org>
	<20100711141406.GD18586@hawkmoon.kerlabs.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 11 Jul 2010 07:25:18 -0700
In-Reply-To: <20100711141406.GD18586@hawkmoon.kerlabs.com> (Louis Rilling's message of "Sun\, 11 Jul 2010 16\:14\:07 +0200")
Message-ID: <m1mxtyt7sh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 XMBrknScrpt_02 Possible Broken Spam Script
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 01/24] pidns: Remove races by stopping the caching of proc_mnt
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Louis Rilling <Louis.Rilling@kerlabs.com> writes:

> On 09/07/10  8:58 -0700, Eric W. Biederman wrote:
>> 
>> Having proc reference the pid_namespace and the pid_namespace
>> reference proc is a serious reference counting problem, which has
>> resulted in both leaks and use after free problems.  Mount already
>> knows how to go from a pid_namespace to a mount of proc, so we don't
>> need to cache the proc mount.
>> 
>> To do this I introduce get_proc_mnt and replace pid_ns->proc_mnt users
>> with it. Additionally I remove pid_ns_(prepare|release)_proc as they
>> are now unneeded.
>> 
>> This is slightly less efficient but it is much easier to avoid the
>> races.  If efficiency winds up being a problem we can revisit our data
>> structures.
>
> IIUC, the difference between this solution and the first one I proposed is that
> instead of pinning proc_mnt with mntget() at copy_process()-time, proc_mnt is
> looked for and, if possible, mntget() at release_task()-time.
>
> Could you elaborate on the trade-off, that is accessing proc_mnt at
> copy_process()-time vs looking up proc_mnt at release_task()-time?

A little code simplicity.  But Serge was right there is cost a noticeable
cost.  About 5%-7% more on lat_proc from lmbench.

The real benefit was simplicity.

Eric
