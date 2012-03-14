Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030373Ab2CNCKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:10:46 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57635 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030183Ab2CNCKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:10:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: NeilBrown <neilb@suse.de>
Cc: qing gu <qing.gu@oracle.com>, neilb@cse.unsw.edu.au,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
References: <4F5D747D.9060508@oracle.com>
	<20120314125720.1bb87546@notabene.brown>
Date: Tue, 13 Mar 2012 19:14:05 -0700
In-Reply-To: <20120314125720.1bb87546@notabene.brown> (NeilBrown's message of
	"Wed, 14 Mar 2012 12:57:20 +1100")
Message-ID: <m14ntsc4k2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+auaU8M4MJ5nXLaReSVpyPUjaQmfwZeH8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  3.0 XMGappySubj_01 Very gappy subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0292]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;NeilBrown <neilb@suse.de>
X-Spam-Relay-Country: **
Subject: Re: [PATCH]: md: Initialize ctl_name field of table raid_root_table/raid_dir_table to avoid dump_trace info in debug kernel
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> On Mon, 12 Mar 2012 11:58:53 +0800 qing gu <qing.gu@oracle.com> wrote:
>
>> This patch is used to dispense trace info when system boots with debug 
>> kernel. I have verified it on RHEL6.2 & SLES11.2. Both work fine.
>> In the failure case, system logs that:
>> 
>>     /Feb 21 19:33:55 nsgbj-216-137 kernel: sysctl_check_dir: failed: /dev  ref: /dev .7
>>     Feb 21 19:33:55 nsgbj-216-137 kernel: sysctl table check failed: /dev  Inconsistent directory names
>>     Feb 21 19:33:55 nsgbj-216-137 kernel: Pid: 1, comm: swapper Not tainted 2.6.32-220.el6.x86_64.debug #1
>>     Feb 21 19:33:55 nsgbj-216-137 kernel: Call Trace:
>>     Feb 21 19:33:55 nsgbj-216-137 kernel: [<ffffffff810a2029>] ? set_fail+0x59/0x60
>>     Feb 21 19:33:55 nsgbj-216-137 kernel: [<ffffffff810a23d4>] ? sysctl_check_table+0x3a4/0x680
>>     ...
>>     /
>> 
>> As you can see, system failed with mismatch
>> /sysctl_check_dir: failed: /dev ref: /dev .7/
>> 
>> Signed-off-by: Neil Gu <qing.gu@oracle.com>
>> 
>> -----------------------------------------------------------
>
> (please put patches inline in your email - it makes them easier to reply to)
>
>
>  scripts/kconfig/Makefile |   16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ce88755..9630ad3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -129,6 +129,7 @@ static ctl_table raid_table[] = {
>  
>  static ctl_table raid_dir_table[] = {
>  	{
> +		.ctl_name	= DEV_RAID,
>  		.procname	= "raid",
>  		.maxlen		= 0,
>  		.mode		= S_IRUGO|S_IXUGO,
> @@ -139,6 +140,7 @@ static ctl_table raid_dir_table[] = {
>  
>  static ctl_table raid_root_table[] = {
>  	{
> +		.ctl_name	= CTL_DEV,
>  		.procname	= "dev",
>  		.maxlen		= 0,
>  		.mode		= 0555,
>
> These lines were removed in November 2009 by Eric Biederman in
> commit 894d2491153a9f8270dbed21175d06fde4eba6c7
>
> So I'm not keen on adding them back without understanding the history.
>
> Eric:  Do we need these after all?

For the main trunk no.  The .ctl_name field no longer exists.

kernel/binary_sysctl.c is used to provide backwards compatibility with
the old binary names.

There might be a point for doing something in -stable or someone's
enterprise kernel if some messed up set of backports were merged.

Eric
