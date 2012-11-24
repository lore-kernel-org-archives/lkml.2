Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2KXMHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 07:07:30 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:46345 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab2KXMH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 07:07:28 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ian Kent <raven@themaw.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, autofs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sukadev@linux.vnet.ibm.com, serge.hallyn@canonical.com
References: <87obipehbt.fsf@tucsk.pomaz.szeredi.hu>
	<1353642304.2309.25.camel@perseus.themaw.net>
	<1353672540.6699.18.camel@perseus.themaw.net>
	<874nkgwfw0.fsf@tucsk.pomaz.szeredi.hu>
	<1353723813.2348.48.camel@perseus.themaw.net>
	<1353724641.2348.56.camel@perseus.themaw.net>
Date: Sat, 24 Nov 2012 04:07:15 -0800
In-Reply-To: <1353724641.2348.56.camel@perseus.themaw.net> (Ian Kent's message
	of "Sat, 24 Nov 2012 10:37:21 +0800")
Message-ID: <878v9rmcgc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19wpJQqtE8hlDEuDdUssFIHAUlj+93v7A0=
X-SA-Exim-Connect-IP: 75.135.205.0
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0141]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ian Kent <raven@themaw.net>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] autofs4: allow autofs to work outside the initial PID namespace
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> On Sat, 2012-11-24 at 10:23 +0800, Ian Kent wrote:
>> On Fri, 2012-11-23 at 15:30 +0100, Miklos Szeredi wrote:
>> > Ian Kent <raven@themaw.net> writes:
>> > 
>> > > On Fri, 2012-11-23 at 11:45 +0800, Ian Kent wrote:
>> > >> On Thu, 2012-11-22 at 17:24 +0100, Miklos Szeredi wrote:
>> > >> > Patches were tested by the customer.
>> > >> > 
>> > >> > Ian, Eric, do these patches look OK?

My apologies for the delay.  I have been swamped with the holidays and
the impending 3.8 merge window.   I will take a good hard look at your
patches shortly.

>> AFAICS autofs mounts mounted with MS_PRIVATE in the initial namespace do
>> propagate to the clone when it's created so I'm assuming subsequent
>> mounts would also. If these mounts are busy in some way they can't be
>> umounted in the clone unless "/" is marked private before attempting the
>> umount.
>
> This may sound stupid but if there something like, say, MS_NOPROPAGATE
> then the problem I see would pretty much just go away. No more need to
> umount existing mounts and container instances would be isolated. But, I
> guess, I'm not considering the possibility of cloned of processes as
> well .... if that makes sense, ;)

Something is very weird is going on.  MS_PRIVATE should be the
MS_NOPROPOGATE you are looking for.  There is also MS_UNBINDABLE.
which is a stronger form of MS_PRIVATE and probably worth play with.

I would love to advertise my user namespace changes (queued for 3.8)
that reduce shared subtrees to slave subtress as the solution to this,
and that does address part of the issue but that does not really seem
like the fix.

I expect what we need to avoid unwanted mount propagation is an idiom
something like:

unshare -n
mount --private /mnt
pivot_root /mnt /
umount /mnt

Something like that is present in the startup of most containers
already.  So figuring out where to sprinkle MS_PRIVATE or MS_UNBINDABLE
so that mounts don't propogate that we want to propogate look like a
good deal.

Eric
