Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2EBVyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:54:49 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42668 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab2EBVyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:54:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, jasowang@redhat.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Basil Gor <basil.gor@gmail.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
	<20120502055008.GA29319@redhat.com>
	<20120502.024427.22049954455309204.davem@davemloft.net>
	<20120502081141.GA30549@redhat.com> <87pqammkvs.fsf@xmission.com>
	<20120502213128.GB8266@redhat.com>
Date: Wed, 02 May 2012 14:54:37 -0700
In-Reply-To: <20120502213128.GB8266@redhat.com> (Michael S. Tsirkin's message
	of "Thu, 3 May 2012 00:31:29 +0300")
Message-ID: <87txzyb65e.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+yasPdGsUA2a/BpQKQAa5jQaOLRDB1uY4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Michael S. Tsirkin" <mst@redhat.com>
X-Spam-Relay-Country: **
Subject: Re: [V2 PATCH 0/9] vhost/macvtap zeropcopy fixes
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Wed, May 02, 2012 at 12:40:55PM -0700, Eric W. Biederman wrote:
>> 
>> Side question.  Are you aware that macvtap/vhost net is broken
>> in the presence of  vlan accelleration and that vlan accelleration
>> is not optional if you are using vlan headers?
>> 
>> Eric
>
> I didn't know. Could you explain please?

It is worth looking at the netdev history for some recent patches by
Basil Gor, as he has been hit by this issue and has been trying to come
up with a clean fix.  I was burned by this issue in other parts of the
networking stack and so have been doing some basic review.

The short version is that on any normal path through the networking
stack we implement vlan header accelleration in hardware or emulation
in software.  The result is that the ethernet vlan header is not
on the packet and is instead in the skb->tci field.

When coming on out the pf_packet sockets we don't include the vlan
header in the packet but instead the vlan header is put in aux data.

The result of all of this is that vhost/net.c looses the vlan
header when coming from pf_packet socket.

Furthermore macvtap_recvmsg does not act like pf_packet sockets
when there is a vlan header persent so weirdness ensues.  Especially
when the packet is coming from a path where the vlan header has
been stripped and placed in skb->tci.

Eric

