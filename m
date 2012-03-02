Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab2CBAJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:09:07 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:48785 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab2CBAJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:09:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "David Laight" <David.Laight@ACULAB.COM>
Cc: "Eric Dumazet" <eric.dumazet@gmail.com>,
        "David Miller" <davem@davemloft.net>, <paul.gortmaker@windriver.com>,
        <tim.bird@am.sony.com>, <kuznet@ms2.inr.ac.ru>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E85@saturn3.aculab.com>
Date: Thu, 01 Mar 2012 16:12:12 -0800
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6E85@saturn3.aculab.com>
	(David Laight's message of "Thu, 1 Mar 2012 08:55:01 -0000")
Message-ID: <m1fwdr509v.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/LrIvKcQPpL2B0vT7l+GYRgZ8a1coa+Lo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0059]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"David Laight" <David.Laight@ACULAB.COM>
X-Spam-Relay-Country: 
Subject: Re: RFC: memory leak in udp_table_init
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"David Laight" <David.Laight@ACULAB.COM> writes:

>  
>> > The pid table is a good example of something where a hash
>> > table is unnecessary.
>> > Linux should steal the code I put into NetBSD :-)
>> 
>> On this unrelated topic.  What algorithm did you use on NetBSD for
>> dealing with pids?
>
> Basically I forced the hash chain length to one by allocating
> a pid that hit an empty entry in the table.
>
> So you start off with (say) 64 entries and use the low 6
> bits to index the table. The higher bits are incremented
> each time a 'slot' is reused.
> Free entries are kept in a FIFO list.
> So each entry either contains a pointer to the process,
> or the high bits and the index of the next free slot.
> (and the PGID pointer).
> When there are only (say) 2 free entries, then the table
> size is doubled, the pointers moved to the correct places,
> the free ist fixed up, and the minimum number of free entries
> doubled.
>
> The overall effect:
> - lookup is only ever a mask and index + compare.
> - Allocate is always fast and fixed cost (except when
>   the table size has to be doubled).
> - A pid value will never be reused within (about) 2000
>   allocates (for 16bit pids, much larger for 32bit ones).
> - Allocated pid numbers tend to be random, certainly
>   very difficult to predict.
> - Small memory footprint for small systems.
> For pids we normally avoid issuing large values, but
> will do so to avoid immediate re-use on systems that
> have 1000s of active processes.

That is a very nice technique.  Unfortunately doubling a hash table size
when you need large amounts of contiguous memory is difficult, and worse
does not support user space selectable pid numbers which is needed to
support process migration.  So I don't think we can adapt this case for
the linux pid hash table.

I will keep the technique in mind in case I run into a situation where
it is applicable.

Eric
