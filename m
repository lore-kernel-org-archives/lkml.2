Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab0JHAy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:54:57 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:44170 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab0JHAyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:54:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
        ML netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <201010072140.o97Le69i025659@imap1.linux-foundation.org>
	<4CAE4479.6010606@gmail.com>
	<1286490135.6536.75.camel@edumazet-laptop>
	<20101007152806.119d1522.akpm@linux-foundation.org>
Date: Thu, 07 Oct 2010 17:54:48 -0700
In-Reply-To: <20101007152806.119d1522.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 7 Oct 2010 15:28:06 -0700")
Message-ID: <m1y6a95wrr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: IPv4: sysctl table check failed [was: mmotm 2010-10-07-14-08 uploaded]
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 08 Oct 2010 00:22:15 +0200
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>> Le vendredi 08 octobre 2010 __ 00:06 +0200, Jiri Slaby a __crit :
>> > On 10/07/2010 11:08 PM, akpm@linux-foundation.org wrote:
>> > > The mm-of-the-moment snapshot 2010-10-07-14-08 has been uploaded to
>> > 
>> > Hi, I got bunch of "sysctl table check failed" below. All seem to be
>> > related to ipv4:
>> 
>> I would say, sysctl check is buggy :(
>> 
>> min/max are optional
>> 
>> [PATCH] sysctl: min/max bounds are optional
>> 
>> sysctl check complains when proc_doulongvec_minmax or
>> proc_doulongvec_ms_jiffies_minmax are used by a vector of longs (with
>> more than one element), with no min or max value specified.
>> 
>> This is unexpected, given we had a bug on this min/max handling :)
>> 
>> Reported-by: Jiri Slaby <jirislaby@gmail.com>
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> ---
>>  kernel/sysctl_check.c |    9 ---------
>>  1 file changed, 9 deletions(-)
>> 
>> diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
>> index 04cdcf7..10b90d8 100644
>> --- a/kernel/sysctl_check.c
>> +++ b/kernel/sysctl_check.c
>> @@ -143,15 +143,6 @@ int sysctl_check_table(struct nsproxy *namespaces, struct ctl_table *table)
>>  				if (!table->maxlen)
>>  					set_fail(&fail, table, "No maxlen");
>>  			}
>> -			if ((table->proc_handler == proc_doulongvec_minmax) ||
>> -			    (table->proc_handler == proc_doulongvec_ms_jiffies_minmax)) {
>> -				if (table->maxlen > sizeof (unsigned long)) {
>> -					if (!table->extra1)
>> -						set_fail(&fail, table, "No min");
>> -					if (!table->extra2)
>> -						set_fail(&fail, table, "No max");
>> -				}
>> -			}
>>  #ifdef CONFIG_PROC_SYSCTL
>>  			if (table->procname && !table->proc_handler)
>>  				set_fail(&fail, table, "No proc_handler");
>
> That will probably fix it ;)
>
> net-avoid-limits-overflow.patch is dependent on this patch.  Unless
> Eric B squeaks I'll plan on sending this patch in for 2.6.37.

Oh.  I see. I actually had a sanity check for the case that was failing.
I probably spotted the buggy code and wanted to see if there was
anything that cared.

So sysctl_check was perfectly correct until the bug was removed from
proc_doulongvec_minmax.  Which also means we have been auditing the
kernel for quite a while to make certain that it is safe not to
increment min and max.

Eric

