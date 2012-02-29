Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030395Ab2B2S2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:28:31 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57373 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030328Ab2B2S2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:28:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "David Laight" <David.Laight@ACULAB.COM>
Cc: "Eric Dumazet" <eric.dumazet@gmail.com>,
        "David Miller" <davem@davemloft.net>, <paul.gortmaker@windriver.com>,
        <tim.bird@am.sony.com>, <kuznet@ms2.inr.ac.ru>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6E7D@saturn3.aculab.com>
	(David Laight's message of "Mon, 27 Feb 2012 11:33:07 -0000")
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E7D@saturn3.aculab.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Wed, 29 Feb 2012 10:28:13 -0800
Message-ID: <877gz5ze82.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19Wa4GTkInddQ2WEPwN8eOkpY9TXo+xwXw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3881]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      []
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: ; 
X-Spam-Combo: ;"David Laight" <David.Laight@ACULAB.COM>
X-Spam-Relay-Country: **
Subject: Re: RFC: memory leak in udp_table_init
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David Laight" <David.Laight@ACULAB.COM> writes:

>> It was to match the comment we have few lines above :
>> 
>> /*
>>  * The pid hash table is scaled according to the amount of memory in
> the
>>  * machine.  From a minimum of 16 slots up to 4096 slots at one
> gigabyte or
>>  * more.
>>  */

The comment was actually correct until someone converted the code to use
alloc_large_system_hash.

> These large hash tables are, IMHO, an indication that the
> algorithm used is, perhaps, suboptimal.
>
> Not least of the problems is actually finding a suitable
> (and fast) hash function that will work with the actual
> real-life data.
>
> The pid table is a good example of something where a hash
> table is unnecessary.
> Linux should steal the code I put into NetBSD :-)

On this unrelated topic.  What algorithm did you use on NetBSD for
dealing with pids?

A hash chain length of 1 for common sizes is a pretty attractive
algorithm, as it minimizes the number of cache line misses.  Ages ago
when I modeled the linux situation that is what I was seeing.

The normal case for the linux pid hash table is that it has 4096
entries taking 16k or 32k of memory and the typical process load
has about 200 or so processes.    Making it very easy in the common
case to have a single entry hash chain.

All of the other algorithms I know have a tree structure and thus
more cache misses (as you traverse the tree) and ultimately worse
real world performance.

Eric
