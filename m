Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab2HZNoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 09:44:14 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:42192 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab2HZNn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 09:43:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>
References: <87lih2h6i4.fsf@xmission.com> <877gsmfrkc.fsf@xmission.com>
	<20120826123354.GA23803@ioremap.net>
Date: Sun, 26 Aug 2012 06:43:45 -0700
In-Reply-To: <20120826123354.GA23803@ioremap.net> (Evgeniy Polyakov's message
	of "Sun, 26 Aug 2012 16:33:54 +0400")
Message-ID: <876285ahv2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19yZoMrL/iaUMSXS6GQn/xBO4JNMS2zim8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0254]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Evgeniy Polyakov <zbr@ioremap.net>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 09/15] userns: Convert process event connector to handle kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov <zbr@ioremap.net> writes:

> On Sat, Aug 25, 2012 at 05:02:59PM -0700, Eric W. Biederman (ebiederm@xmission.com) wrote:
>> 
>> - Only allow asking for events from the initial user and pid namespace,
>>   where we generate the events in.
>> 
>> - Convert kuids and kgids into the initial user namespace to report
>>   them via the process event connector.
>
>
> Looks good, if IDs are really supposed to be sent only from root
> namespace.

It is more about where events are recevied rather than where events are
sent from.

With this change events continue to be sent from all processes but can
only be received by processes in the initial user and initial pid
namespace.

To processes in other namespaces the uids and pids that the proc
connector code puts into it's messages are just non-sense, so I
cause the registration of connector clients in other namespaces to fail.

All of that I can do easily without a complete reworking of the current
connector code.  Which is enough for my current goal of building able
to build a kernel with all features enabled and only loosing features
if you are in somethin other than the initial namespaces.


> And you dropped PROC_EVENTS from init/Kconfig, but since it
> was no, it should be ok by default.

The removal of PROC_EVENTS from init/Kconfig was removing of the compile
guard that kept PROC_EVENTS and USER_NS from being selected at the same
time.  The curent user namespace code simply disables code that fails
to build when user namespace support is enabled.

> Feel free to add my acked-by: Evgeniy Polyakov <zbr@ioremap.net>
> Although I thoughs it could be more interesting to generate events
> including namespace id

There isn't a namespace id.  It is perfectly possible to generate events
that can be received by processes in multiple pid and user nameapces
just by calling pid_nr_ns() and from_kuid() with the right parameters.
The challenge is figuring out what namespaces have listening netlink
sockets we should send messages to.

Adding support for recepetion of connector proc events by listeners in
other namespaces looks like it would require near complete rewrite of
the connector code:
- Adding support for connector netlink sockets in other than the initial
  network namespace.
- Tracking which sockets were opened in which pid and which user
  namespaces.
- Filtering messages based on which namespaces the clients are listening
  in.
- Generating the different messages for the different sets of clients.

When someone cares enough I am certain the code will get written.
Having a clear unambigous that configuration does not work is
the first step in getting there.

I presume that whatever listens to connector based proc events listens
for the appropriate ack when registering and the daemon will fail to
start up.

Eric
