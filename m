Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1HSLnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:43:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48789 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1HSLnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:43:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "David S. Miller" <davem@davemloft.net>, containers@lists.osdl.org
References: <4E4CDF44.5080109@redhat.com> <m17h69sr03.fsf@fess.ebiederm.org>
	<4E4E395B.7070106@redhat.com>
Date: Fri, 19 Aug 2011 04:43:39 -0700
In-Reply-To: <4E4E395B.7070106@redhat.com> (Milan Broz's message of "Fri, 19
	Aug 2011 12:22:19 +0200")
Message-ID: <m1liup4oes.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/VoB2XNYXpfiuGM4UtuQljpsWtgTClBGQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Milan Broz <mbroz@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [dm-devel] clone() with CLONE_NEWNET breaks kobject_uevent_env()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milan Broz <mbroz@redhat.com> writes:

> On 08/19/2011 11:13 AM, Eric W. Biederman wrote:
>> Milan Broz <mbroz@redhat.com> writes:
>> 
>> I think the proper fix is to remove the error return from
>> kobject_uevent_env and kobject_uevent, and make it harder to get calling
>> of this function wrong.  Possibly in conjunction with that tag all of
>> the memory allocations of kobject_uevent_env with GFP_NOFAIL or
>> something so the memory allocator knows that this path is totally
>> not able to deal with failure.
>> 
>> Is kobject_uevent_env anything except an asynchronous best effort
>> notification to user-space that a device has come or gone?
>
> Unfortunately it is for device-mapper. libdevmapper
> depends on information that uevent was sent because udev rules uses
> semaphore to inform that some action was taken.
> So if dm-ioctl returns flag that uevent was not sent, it fallback
> to different error path (otherwise it waits for completion forever).
> (TBH I am more and more convinced this was not quite clever concept.)

If I understand your description and the code right the guarantee that
you need is that kobject_uevent will return success only if it has
queued a packet in every listening netlink socket.

We already ignore ENOBUFS so the guarantee you appear to need in
libdevmapper does not appear to be present in kobject_uevent.

Does the libdevmapper code work despite getting a spurious failure?

If libdevmapper does not work despite a spurious failure I don't see how
we could possibly fix kobject_uevent when there is more than one netlink
listener.

Eric
