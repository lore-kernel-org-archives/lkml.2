Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0JGTie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 15:38:34 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37815 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0JGTic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 15:38:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Robin Holt <holt@sgi.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, James Morris <jmorris@namei.org>,
        "Pekka Savola \(ipv6\)" <pekkas@netcore.fi>,
        Patrick McHardy <kaber@trash.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
References: <1286025469.2582.1806.camel@edumazet-laptop>
	<20101004085913.GR14068@sgi.com>
	<1286183058.18293.26.camel@edumazet-laptop>
	<20101004093439.GG5189@cr0.nay.redhat.com>
	<1286187030.18293.33.camel@edumazet-laptop>
	<20101004103545.GJ5189@cr0.nay.redhat.com>
	<1286188701.18293.57.camel@edumazet-laptop>
	<20101005130117.GK5170@cr0.nay.redhat.com>
	<20101007071859.GD5471@cr0.nay.redhat.com>
	<20101007092538.GE5471@cr0.nay.redhat.com>
	<1286445081.2912.15.camel@edumazet-laptop>
	<m1iq1e3qnn.fsf@fess.ebiederm.org>
	<1286470743.2912.276.camel@edumazet-laptop>
	<20101007121840.ca49e2ac.akpm@linux-foundation.org>
Date: Thu, 07 Oct 2010 12:38:22 -0700
In-Reply-To: <20101007121840.ca49e2ac.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 7 Oct 2010 12:18:40 -0700")
Message-ID: <m1vd5d3ia9.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysctl: fix min/max handling in __do_proc_doulongvec_minmax()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 07 Oct 2010 18:59:03 +0200
> Eric Dumazet <eric.dumazet@gmail.com> wrote:

>> Thats fine by me, thanks Eric.
>> 
>> Andrew, please remove previous patch from your tree and replace it by
>> following one :
>> 
>> [PATCH v2] sysctl: fix min/max handling in __do_proc_doulongvec_minmax()
>> 
>> When proc_doulongvec_minmax() is used with an array of longs,
>> and no min/max check requested (.extra1 or .extra2 being NULL), we
>> dereference a NULL pointer for the second element of the array.
>> 
>> Noticed while doing some changes in network stack for the "16TB problem"
>> 
>> Fix is to not change min & max pointers in
>> __do_proc_doulongvec_minmax(), so that all elements of the vector share
>> an unique min/max limit, like proc_dointvec_minmax().
>> 
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> ---
>>  kernel/sysctl.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
>> index f88552c..8e45451 100644
>> --- a/kernel/sysctl.c
>> +++ b/kernel/sysctl.c
>> @@ -2485,7 +2485,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
>>  		kbuf[left] = 0;
>>  	}
>>  
>> -	for (; left && vleft--; i++, min++, max++, first=0) {
>> +	for (; left && vleft--; i++, first=0) {
>>  		unsigned long val;
>>  
>>  		if (write) {
>
> Did we check to see whether any present callers are passing in pointers
> to arrays of min/max values?

In 2.6.36 there are not any callers that pass in a vector of anything, I
don't know about linux-next.  It looks to me like incrementing min and
max was simply a bug.

> I wonder if there's any documentation for this interface which just
> became wrong.

Or it just became right.  Clearly no one has been expecting min
and max to be vectors.

Eric
