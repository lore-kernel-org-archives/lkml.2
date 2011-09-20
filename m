Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab1ITDfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 23:35:25 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43112 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab1ITDfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 23:35:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org,
        security@kernel.org, Eric Paris <eparis@redhat.com>,
        Stephen Wilson <wilsons@start.ca>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        kernel-hardening@lists.openwall.com
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
	<20110630075716.GB3377@albatros>
	<BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
	<BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
	<BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
	<CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
	<20110919173905.GA3804@albatros>
	<CA+55aFzedLJfK2h2hY_a73Tn9F8Qu=LyjPhq2gVi5S=CYsCnDA@mail.gmail.com>
Date: Mon, 19 Sep 2011 20:35:10 -0700
In-Reply-To: <CA+55aFzedLJfK2h2hY_a73Tn9F8Qu=LyjPhq2gVi5S=CYsCnDA@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 19 Sep 2011 10:45:20 -0700")
Message-ID: <m1obyfopht.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/+JVSdgwkNhdlTaTTYAqAvAzGRRXIg17M=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: [Security] [PATCH 2/2] taskstats: restrict access to user
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Sep 19, 2011 at 10:39 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>>
>> Shouldn't it simply protect taskstats_user_cmd()?  You may still poll
>> the counters with TASKSTATS_CMD_ATTR_PID/TASKSTATS_CMD_ATTR_TGID.
>
> Yeah, I wondered where I'd really want to hook it in, that was the
> other option.
>
> However, one thing that I'm currently independently asking some
> networking people is whether that patch guarantees anything at all: is
> the netlink command even guaranteed to be run in the same context as
> the person sending it?

I don't know where that conversation is happening but since I have been
involved rather heavily in netlink syncrhonously processing messages I
will answer.

> After all, it comes in as a packet of data.  How synchronous is the
> genetlink thing guaranteed to be in the first place?

Yes.  The netlink skb is guaranteed to be processed synchronously
and in the senders process.  So accessing current is guaranteed
to be valid.

I just confirmed my memory by reading the cod in 3.1-rc1

> IOW, are *any* of those "check current capabilities/euid" approaches
> really guaranteed to be valid? Are they valid today, will they
> necessarily be valid in a year?

They are valid until such time as someone as someone rearchitects
netlink message processing.

Several years ago it was decided that processing netlink messages
syncrhonously so we could access current made for much simpler easier to
understand kernel code, and most if not all of the netlink permissions
checks now depend upon the fact that we process netlink messages
synchronously.

Eric
