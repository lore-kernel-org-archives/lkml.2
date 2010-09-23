Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab0IWPAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:00:51 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43895 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab0IWPAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:00:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@parallels.com>
Cc: hadi@cyberus.ca, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	<m1bp7oq1u8.fsf@fess.ebiederm.org> <4C9B162E.7040201@parallels.com>
	<1285240797.5036.5.camel@bigi> <4C9B3B06.900@parallels.com>
	<1285242055.5036.9.camel@bigi> <4C9B3F9C.8080506@parallels.com>
	<1285243881.5036.22.camel@bigi> <4C9B495D.70200@parallels.com>
Date: Thu, 23 Sep 2010 08:00:33 -0700
In-Reply-To: <4C9B495D.70200@parallels.com> (Pavel Emelyanov's message of
	"Thu, 23 Sep 2010 16:34:37 +0400")
Message-ID: <m1y6asld2m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Pavel Emelyanov <xemul@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 8/8] net: Implement socketat.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@parallels.com> writes:

> On 09/23/2010 04:11 PM, jamal wrote:
>> On Thu, 2010-09-23 at 15:53 +0400, Pavel Emelyanov wrote:
>> 
>>> Why does it matter? You told, that the usage scenario was to
>>> add routes to container. If I do 2 syscalls instead of 1, is
>>> it THAT worse?
>>>
>> 
>> Anything to do with socket IO that requires namespace awareness
>> applies for usage; it could be tcp/udp/etc socket. If it doesnt
>> make any difference performance wise using one scheme vs other
>> to write/read heavy messages then i dont see an issue and socketat
>> is redundant.
>
> That's what my point is about - unless we know why would we need it
> we don't need it.
>
> Eric, please clarify, what is the need in creating a socket in foreign
> net namespace?

Strictly speaking with setns() you can implement this functionality
with setns().  aka

int socketat(int nsfd, int domain, int type, int protocol)
{
        int sk;

        setns(0, nsfd);
        sk = socket(domain, type, protocol);
        setns(0, default_nsfd);

        return sk;
}

The major difference is that socketat in userspace suffers
from races, with signals etc.

The use case are applications are the handful of networking applications
that find that it makes sense to listen to sockets from multiple network
namespaces at once.  Say a home machine that has a vpn into your office
network and the vpn into the office network runs in a different network
namespace so you don't have to worry about address conflicts between
the two networks, the chance of accidentally bridging between them,
and so you can use different dns resolvers for the different networks.

In that scenario it would be nice if I could run some services on both
networks.  Starting two+ copies of the daemons just so the can have live
in all of the networks is ok, but in the fullness of time I expect that
there will be daemons that want to optimize things and have sockets in
all of the network namespaces you are connected to.

In a multiple network namespace aware application when it goes to open
a socket it will want to specify which network namespace the socket is
in.  If it is a general listener it will probably listening to events
in /proc/mounts waiting for extra namespaces to be mounted under a
standard location say: /var/run/netns/<netnsname>/ns.

Once the application receives the event for a new network namespace
showing up it can will want to create a new socket listening for
connections in the new network namespace.

In that scenario none of those network namespaces are foreign, but one
network namespace will be the default and the rest will be non-default
network namespaces.

To support a multiple network namespace aware daemon I need to implement
sockeat() somewhere.  So I figured I would see if anyone minded a
trivial in kernel race free implementation.  To me it is a wart in the
API and I am busily removing warts in the API.

I don't know of any scenarios with other namespaces where there would be
applications that would be native in multiple namespaces.  So I haven't
haven't done any work in that direction.

Eric
