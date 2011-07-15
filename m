Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab1GOQvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:51:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab1GOQva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:51:30 -0400
Message-ID: <4E206FF8.9090803@redhat.com>
Date: Fri, 15 Jul 2011 17:51:04 +0100
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: david@lang.hm
CC: Chris Mason <chris.mason@oracle.com>, NeilBrown <neilb@suse.de>,
        Nico Schottelius <nico-lkml-20110623@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: Mis-Design of Btrfs?
References: <20110623105337.GD3753@ethz.ch> <20110627164637.377314e2@notabene.brown> <4E0AF091.9030301@redhat.com> <20110714155620.6e9ac2cc@notabene.brown> <4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown> <4E1E9372.3030208@redhat.com> <1310696606-sup-710@shiny> <alpine.DEB.2.02.1107142149420.3558@asgard.lang.hm> <20110715163354.74fa2083@notabene.brown> <1310728784-sup-9024@shiny> <4E20395C.1000301@redhat.com> <1310735821-sup-2589@shiny> <alpine.DEB.2.02.1107150920180.3745@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.02.1107150920180.3745@asgard.lang.hm>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 05:23 PM, david@lang.hm wrote:
> On Fri, 15 Jul 2011, Chris Mason wrote:
>
>> Excerpts from Ric Wheeler's message of 2011-07-15 08:58:04 -0400:
>>> On 07/15/2011 12:34 PM, Chris Mason wrote:
>>
>> By bubble up I mean that if you have multiple layers capable of doing
>> retries, the lowest levels would retry first.  Basically by the time we
>> get an -EIO_ALREADY_RETRIED we know there's nothing that lower level can
>> do to help.
>
> the problem with doing this is that it can end up stalling the box for 
> significant amounts of time while all the retries happen.
>
> we already see this happening today where a disk read failure is retried 
> multiple times by the disk, multiple times by the raid controller, and then 
> multiple times by Linux, resulting is multi-minute stalls when you hit a disk 
> error in some cases.
>
> having the lower layers do the retries automatically runs the risk of making 
> this even worse.
>
> This needs to be able to be throttled by some layer that can see the entire 
> picture (either by cutting off the retries after a number, after some time, or 
> by spacing out the retries to allow other queries to get in and let the box do 
> useful work in the meantime)
>
> David Lang
>

That should not be an issue - we have a "fast fail" path for IO that should 
avoid retrying just for those reasons (i.e., for multi-path or when recovering a 
flaky drive).

This is not a scheme for unbounded retries. If you have a 3 disk mirror in 
RAID1, you would read the data no more than 2 extra times and almost never more 
than once.  That should be *much* faster than the multiple-second long timeout 
you see when waiting for SCSI timeout to fire, etc.

Ric

