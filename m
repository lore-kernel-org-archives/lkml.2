Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1GNG6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab1GNG6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:58:19 -0400
Message-ID: <4E1E9372.3030208@redhat.com>
Date: Thu, 14 Jul 2011 07:57:54 +0100
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Nico Schottelius <nico-lkml-20110623@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: Mis-Design of Btrfs?
References: <20110623105337.GD3753@ethz.ch>	<20110627164637.377314e2@notabene.brown>	<4E0AF091.9030301@redhat.com>	<20110714155620.6e9ac2cc@notabene.brown>	<4E1E866E.2050405@redhat.com> <20110714163836.35a729c1@notabene.brown>
In-Reply-To: <20110714163836.35a729c1@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 07:38 AM, NeilBrown wrote:
> On Thu, 14 Jul 2011 07:02:22 +0100 Ric Wheeler<rwheeler@redhat.com>  wrote:
>
>>> I'm certainly open to suggestions and collaboration.  Do you have in mind any
>>> particular way to make the interface richer??
>>>
>>> NeilBrown
>> Hi Neil,
>>
>> I know that Chris has a very specific set of use cases for btrfs and think that
>> Alasdair and others have started to look at what is doable.
>>
>> The obvious use case is the following:
>>
>> If a file system uses checksumming or other data corruption detection bits, it
>> can detect that it got bad data on a write. If that data was protected by RAID,
>> it would like to ask the block layer to try to read from another mirror (for
>> raid1) or try to validate/rebuild from parity.
>>
>> Today, I think that a retry will basically just give us back a random chance of
>> getting data from a different mirror or the same one that we got data from on
>> the first go.
>>
>> Chris, Alasdair, was that a good summary of one concern?
>>
>> Thanks!
>>
>> Ric
> I imagine a new field in 'struct bio' which was normally zero but could be
> some small integer.  It is only meaningful for read.
> When 0 it means "get this data way you like".
> When non-zero it means "get this data using method N", where the different
> methods are up to the device.
>
> For a mirrored RAID, method N means read from device N-1.
> For stripe/parity RAID, method 1 means "use other data blocks and parity
> blocks to reconstruct data.
>
> The default for non RAID devices is to return EINVAL for any N>  0.
> A remapping device (dm-linear, dm-stripe etc) would just pass the number
> down.  I'm not sure how RAID1 over RAID5 would handle it... that might need
> some thought.
>
> So if btrfs reads a block and the checksum looks wrong, it reads again with
> a larger N.  It continues incrementing N and retrying until it gets a block
> that it likes or it gets EINVAL.  There should probably be an error code
> (EAGAIN?) which means "I cannot work with that number, but try the next one".
>
> It would be trivial for me to implement this for RAID1 and RAID10, and
> relatively easy for RAID5.
> I'd need to give a bit of thought to RAID6 as there are possibly multiple
> ways to reconstruct from different combinations of parity and data.  I'm not
> sure if there would be much point in doing that though.
>
> It might make sense for a device to be able to report what the maximum
> 'N' supported is... that might make stacked raid easier to manage...
>
> NeilBrown
>

I think that the above makes sense. Not sure what your "0" definition is, but I 
would assume that for non-raided devices (i.e., a single s-ata disk), "0" would 
be an indication that there is nothing more that can be tried. The data you got 
is all you are ever going to get :)

For multiple mirrors, you might want to have a scheme where you would be able to 
cycle through the mirrors. You could retry, cycling through the various mirrors 
until you have tried and returned them all at which point you would get a "no 
more" error back or some such thing.

Thanks!

ric

