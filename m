Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0JGQhy convert rfc822-to-quoted-printable (ORCPT
	<rfc822;w@1wt.eu>); Thu, 7 Oct 2010 12:37:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56492 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0JGQhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 12:37:51 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        James Morris <jmorris@namei.org>,
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
Date: Thu, 07 Oct 2010 09:37:32 -0700
In-Reply-To: <1286445081.2912.15.camel@edumazet-laptop> (Eric Dumazet's
	message of "Thu, 07 Oct 2010 11:51:21 +0200")
Message-ID: <m1iq1e3qnn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Dumazet <eric.dumazet@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] sysctl: fix min/max handling in __do_proc_doulongvec_minmax()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from QUOTED-PRINTABLE to 8bit by mail.home.local id o97GcXxQ031189

Eric Dumazet <eric.dumazet@gmail.com> writes:

> Le jeudi 07 octobre 2010 à 17:25 +0800, Américo Wang a écrit :
>> >>
>> >
>> >Here is the final one.
>> 
>> Oops, that one is not correct. Hopefully this one
>> is correct.
>> 
>> --------------->
>> 
>> Eric D. noticed that we may trigger an OOPS if we leave ->extra{1,2}
>> to NULL when we use proc_doulongvec_minmax().
>> 
>> Actually, we don't need to store min/max values in a vector,
>> because all the elements in the vector should share the same min/max
>> value, like what proc_dointvec_minmax() does.
>> 
>
> If we assert same min/max limits are to be applied to all elements,
> a much simpler fix than yours would be :
>
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index f88552c..8e45451 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2485,7 +2485,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
>  		kbuf[left] = 0;
>  	}
>  
> -	for (; left && vleft--; i++, min++, max++, first=0) {
> +	for (; left && vleft--; i++, first=0) {
>  		unsigned long val;
>  
>  		if (write) {
>
>
> Please dont send huge patches like this to 'fix' a bug,
> especially on slow path.
>
> First we fix the bug, _then_ we can try to make code more 
> efficient or more pretty or shorter.
>
> So the _real_ question is :
>
> Should the min/max limits should be a single pair,
> shared by all elements, or a vector of limits.

The difference between long handling and int handling is a
usability issue.  I don't expect we will be exporting new
vectors via sysctl, so the conversion of a handful of vectors
from int to long is where this is most likely to be used.

I skimmed through all of what I presume are the current users
aka linux-2.6.36-rcX and there don't appear to be any users
of proc_dounlongvec_minmax that use it's vector properties there.

Which doubly tells me that incrementing the min and max pointers
is not what we want to do.

Eric


