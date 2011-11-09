Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1KIWh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 17:37:28 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44247 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab1KIWh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 17:37:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: dilip.daya@hp.com
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, <netdev@vger.kernel.org>,
        adobrian@gmail.com
References: <1320858706.2531.45.camel@pro6455b.example.com>
Date: Wed, 09 Nov 2011 14:38:16 -0800
In-Reply-To: <1320858706.2531.45.camel@pro6455b.example.com> (Dilip Daya's
	message of "Wed, 09 Nov 2011 12:11:46 -0500")
Message-ID: <m1d3d0oraf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19mVsNwCb3Wb6FnPyUAqVDdwNjxAlQkngI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;dilip.daya@hp.com
X-Spam-Relay-Country: **
Subject: Re: ip_local_deliver_finish: proto 108 (IPComp) isn't netns-ready
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dilip Daya <dilip.daya@hp.com> writes:

> Hi All,
>
> LTP-network tests produced:
>
> 	"ip_local_deliver_finish: proto 108 (IPComp) isn't netns-ready"
>
> Question:
> Is the above a bug or feature (IPComp, mode: transport) not netns
> enabled?

I would call it a missing feature.

> Environment:
>
> * v3.1-stable kernel.
>
> * Configured two network-namespaces via "ip netns add ...".
>   on a single system: netns0 (assigned as server) and
>   netns1 (assigned as client).
>   - assigned multiple physical NICs to netns0 and netns1.
>
> * Entered netns1 (ip netns exec netns1 bash) to execute
>   ltp-network suite of tests between netns1 and netns0.
>
> * The following LTP tests produced messages:
>
>   "kernel: ip_local_deliver_finish: proto 108 isn't netns-ready"
>
>    - /usr/lib/ltp/testcases/bin/icmp4-multi-diffip06
>    - /usr/lib/ltp/testcases/bin/tcp4-multi-diffip13
>    - /usr/lib/ltp/testcases/bin/udp4-multi-diffip06
>    - /usr/lib/ltp/testcases/bin/udp4-multi-diffnic06
>    - /usr/lib/ltp/testcases/bin/udp4-multi-diffport06
>
> * I also noticed missing ".netns_ok = 1" in:
>   - http://lxr.linux.no/linux+v3.1/net/ipv4/ipcomp.c#L150

The .netns_ok flag indicates that someone has audited the code and made
certain it all works with network namespaces.

Skimming the code I don't see anything that jumps out as me as
wrong.  And it looks like Alexy did the work in Jan of 2010.

   commit a92df2545402c1a08e7a158f4477a52dea0eeeed
   Author: Alexey Dobriyan <adobriyan@gmail.com>
   Date:   Mon Jan 25 10:38:34 2010 +0000
   
       netns xfrm: ipcomp support
       
       Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
       Signed-off-by: David S. Miller <davem@davemloft.net>

However it is clear that no one has actually tested ipcomp with
network namespaces.

If you have a clue what is going on with ip compression my
recommendation would be to add .netns_ok = 1.  Verify that the
everything works and send the patch.  You probably want to
verify and test ipv6 as well.  It really looks like the code
is fine and it just needs to be enabled.

Eric
