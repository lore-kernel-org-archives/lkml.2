Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2HFXGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 19:06:15 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38389 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab2HFXGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 19:06:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: David Miller <davem@davemloft.net>, jan.ariyasu@gmail.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.ariyasu@hp.com
In-Reply-To: <502039A8.7080807@gmail.com> (Vlad Yasevich's message of "Mon, 06
	Aug 2012 17:39:52 -0400")
References: <87mx27rig7.fsf@xmission.com> <50201928.2030802@gmail.com>
	<874noflrzd.fsf@xmission.com>
	<20120806.134737.1358773847818872075.davem@davemloft.net>
	<502039A8.7080807@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Mon, 06 Aug 2012 16:06:02 -0700
Message-ID: <87txwfipt1.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1865PH3LJrT2h62DJ3A4qKK5zW3ZD4d4ZI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0008]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vlad Yasevich <vyasevich@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 00/13] SCTP: Enable netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vlad Yasevich <vyasevich@gmail.com> writes:

> On 08/06/2012 04:47 PM, David Miller wrote:
>> From: ebiederm@xmission.com (Eric W. Biederman)
>> Date: Mon, 06 Aug 2012 12:50:46 -0700
>>
>>> Vlad Yasevich <vyasevich@gmail.com> writes:
>>>
>>>
>>>> Hi Eric
>>>>
>>>> Associations are looked up by ports, but then verifyed by addresses.
>>>> Also, associations belong to sockets and simply validating the socket
>>>> namespace should be sufficient.
>>>
>>> True.  Your set of patches isn't quite as likely to malfunction as it
>>> looked at first glance.  It requires address reuse which happens accross
>>> namespaces but not too frequently.
>>>
>>> As for validating the socket namespace I agree that is the fix and my
>>> patchset winds up doing it.
>>
>> FWIW I much prefer Eric's patch set, it was so significantly easier to
>> read and validate than Jan's.
>>
>
> Yes, but Eric's patch set is missing a very significant piece which is per-net
> sctp tunables/globals.  I think adding that piece in will introduce some of the
> complexities of Jan's patch.

And Jan's patchset is missing the per net snmp counters, as well
as the per net checks when looking in the hash tables.  Things that look
like fairly fundamental correctness issues.

No offense but I think Jan's patchset has minor but significant
structural flaws and correctness issues that would require the patchset
to be respun, after review even if my patches did not exist.

The poor movement of variables from their global context into the per
net context is one of those problems.

The fact that after Jan's patchset all of the tunables despite being
made per net remain in struct sctp_globals and sit their unused is a
recipe for confusion.

So I think the simplest path forward would be to merge my patches, and
then merge Jan's tunable work after she has had a chance to rebase it.

> Also, I noticed that Eric went the route of placing sctp netns into struct net,
> but Jan used a generic pointer.  Which one should be used? Is there some
> guidance?

Placing things directly in struct net is more efficient.  Using net
generic is more convenient for development as using net generic does not
require a kernel recompile.

For minor things and especially where it does not have an impact on
performance net generic is the way to go.

It looked to me that sctp was fundamental enough and had enough
important data structures on the hot path that placing the variables
in struct net directly seemed sensible.

Eric
