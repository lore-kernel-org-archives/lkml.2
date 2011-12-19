Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1LSJVG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 04:21:06 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40746 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab1LSJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 04:21:03 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Colin Walters <walters@verbum.org>, LKML <linux-kernel@vger.kernel.org>,
        alan@lxorguk.ukuu.org.uk, morgan@kernel.org, luto@mit.edu,
        kzak@redhat.com, Steve Grubb <sgrubb@redhat.com>
References: <1323280461.10724.13.camel@lenny>
	<20111210052945.GA14931@hallyn.com> <1323708089.29338.39.camel@lenny>
	<20111212231149.GA16408@hallyn.com> <1323982580.31563.15.camel@lenny>
	<m1k45xyreb.fsf@fess.ebiederm.org> <1324224103.21713.26.camel@lenny>
	<m1ehw1mlcf.fsf@fess.ebiederm.org> <20111219040604.GA2205@hallyn.com>
Date: Mon, 19 Dec 2011 01:22:31 -0800
In-Reply-To: <20111219040604.GA2205@hallyn.com> (Serge E. Hallyn's message of
	"Mon, 19 Dec 2011 04:06:04 +0000")
Message-ID: <m1r500j4q0.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/aS01m83OAR2Y/kdJqD65F4CidJUW13xI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0007]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: chroot(2) and bind mounts as non-root
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> If I understand you both right, I think what Eric said here is not relevant
> to what Colin cares about.

As long as Colin only cares about being able to be the root user I
agree.  If Colin needs several uids during his build that is trickier.
But it sounds like Colin just needs to have a chroot build environment and
for that a single user sounds good enough.

Being able to use the other namespaces to get a good isolation from the
host environment is also nice and especially the pid namespace can
guarantee that processes won't escape his build environment.

> The mapping Eric is talking about here is new even to me, but I think it
> is an implementation detail referring to a proposal where each uid in the
> container maps to a real uid on the host.  The only thing about that mapping
> that matters is that none of the host uids conflict with existing host
> uids (or uids mapped for other containers).  Now if you want to do cool
> things like map uid 501 on the host to 1001 in the container as well as
> 502 on the host to 1010 in the container, that will be supported - and I
> think that's what Eric is referring to.
>
> But for the sake of fire-off-a-build, you can ignore that and use random
> uids on the host side of the mapping.

It is one of those worse is better implementation details but we can
discuss that more when I start posting patches in January. 

I am not an immediate fan of writing random uids to disk.  Uids being
persistent can be interesting to deal with if those uids are ever
reused.

Right now my implementation supports just 5 non-overlapping uid mapping
ranges.  Which is enough to cover a lot of uids but still fit within one
cacheline.  And I think to keep stat reasonable fast I want at to fit in
a cacheline at least for now.  Oy.  Hopefully it isn't too hard to find
some benchmarks to prove this out.  I expect the torture case is to
time ls -l in a huge directory with a lot of files, owned by a lot of
different users.

Eric
