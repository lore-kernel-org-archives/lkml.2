Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1GOOBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 10:01:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:60397 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1GOOBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 10:01:07 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: NeilBrown <neilb@suse.de>, david <david@lang.hm>,
        Nico Schottelius <nico-lkml-20110623@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: Mis-Design of Btrfs?
In-reply-to: <4E204139.5060702@redhat.com>
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown> <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown> <4E1E9372.3030208@redhat.com> <1310696606-sup-710@shiny> <alpine.DEB.2.02.1107142149420.3558@asgard.lang.hm> <20110715163354.74fa2083@notabene.brown> <1310728784-sup-9024@shiny> <4E20395C.1000301@redhat.com> <1310735821-sup-2589@shiny> <4E204139.5060702@redhat.com>
Date: Fri, 15 Jul 2011 10:00:35 -0400
Message-Id: <1310738205-sup-715@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4E20480E.0147:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Ric Wheeler's message of 2011-07-15 09:31:37 -0400:
> On 07/15/2011 02:20 PM, Chris Mason wrote:
> > Excerpts from Ric Wheeler's message of 2011-07-15 08:58:04 -0400:
> >> On 07/15/2011 12:34 PM, Chris Mason wrote:
> > [ triggering IO retries on failed crc or other checks ]
> >
> >>> But, maybe the whole btrfs model is backwards for a generic layer.
> >>> Instead of sending down ios and testing when they come back, we could
> >>> just set a verification function (or stack of them?).
> >>>
> >>> For metadata, btrfs compares the crc and a few other fields of the
> >>> metadata block, so we can easily add a compare function pointer and a
> >>> void * to pass in.
> >>>
> >>> The problem is the crc can take a lot of CPU, so btrfs kicks it off to
> >>> threading pools so saturate all the cpus on the box.  But there's no
> >>> reason we can't make that available lower down.
> >>>
> >>> If we pushed the verification down, the retries could bubble up the
> >>> stack instead of the other way around.
> >>>
> >>> -chris
> >> I do like the idea of having the ability to do the verification and retries down
> >> the stack where you actually have the most context to figure out what is possible...
> >>
> >> Why would you need to bubble back up anything other than an error when all
> >> retries have failed?
> > By bubble up I mean that if you have multiple layers capable of doing
> > retries, the lowest levels would retry first.  Basically by the time we
> > get an -EIO_ALREADY_RETRIED we know there's nothing that lower level can
> > do to help.
> >
> > -chris
> 
> Absolutely sounds like the most sane way to go to me, thanks!
> 

It really seemed like a good idea, but I just realized it doesn't work
well when parts of the stack transform the data.

Picture dm-crypt on top of raid1.  If raid1 is responsible for the
crc retries, there's no way to crc the data because it needs to be
decrypted first.

I think the raided dm-crypt config is much more common (and interesting)
than multiple layers that can retry for other reasons (raid1 on top of
raid10?)

In other words, do we really want to do a lot of design work for
multiple layers where each one maintains multiple copies of the data
blocks?  Are there configs where this really makes sense?

-chris
