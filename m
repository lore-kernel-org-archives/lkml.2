Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab0KSBRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:17:03 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47493 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab0KSBRA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:17:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=t1173h/FJtk3vsZPBlA/6lVymFGuxBCvAHM7riMkn0NrmrV+1/ylRNT5Q+yPit2oLY
         zxyR1SZIFK09h6YaxfQMrpBues0vkbUOi/SqhFg+HIgs6+bQbPj9hj5fcuvXJ8NVgpw4
         hhkWEJ3luQgcg2DaRa6urN3sTCj0GFz8enZVQ=
MIME-Version: 1.0
In-Reply-To: <4CE5C616.7070706@teksavvy.com>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
 <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com>
 <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
 <4CE59E57.2090009@teksavvy.com> <yq1r5eiw5os.fsf@sermon.lab.mkp.net> <4CE5C616.7070706@teksavvy.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 18 Nov 2010 17:16:36 -0800
Message-ID: <AANLkTikgEeUL2NVLLdoT3RX0r=v0Pzfp9-==F39DVRgN@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
To: Mark Lord <kernel@teksavvy.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <matthew@wil.cx>, Josef Bacik <josef@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>, tytso@mit.edu,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 4:34 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-11-18 06:52 PM, Martin K. Petersen wrote:
>>>>>>>
>>>>>>> "Mark" == Mark Lord<kernel@teksavvy.com>  writes:
>>
>> Mark>  If FITRIM is still issuing single-range-at-a-time TRIMs, then I'd
>> Mark>  call that a BUG that needs fixing.  Doing TRIM like that causes
>> Mark>  tons of unnecessary ERASE cycles, shortening the SSD lifetime.  It
>> Mark>  really needs to batch them into groups of (up to) 64 ranges at a
>> Mark>  time (64 ranges fits into a single 512-byte parameter block).
>>
>> We don't support coalescing discontiguous requests into one command. But
>> we will issue contiguous TRIM requests as big as the payload can
>> handle. That's just short of two gigs per command given a 512-byte
>> block.
>>
>> I spent quite a bit of time trying to make coalescing work in the
>> spring. It got very big and unwieldy. When we discussed it at the
>> filesystem summit the consensus was that it was too intrusive to the I/O
>> stack, elevators, etc.
>
> Surely if a userspace tool and shell-script can accomplish this,
> totally lacking real filesystem knowledge, then we should be able
> to approximate it in kernel space?
>
> This is FITRIM we're talking about, not the on-the-fly automatic TRIM.
>
> FITRIM could perhaps use a similar approach to what wiper.sh does:
> reserve a large number of free blocks, and issue coalesced TRIM(s) on them.
>
> The difference being, it could walk through the filesystem,
> trimming in sections, rather than trying to reserve/trim the entire
> freespace all in one go.
>
> Over-thinking it???

Martin,

I agree with Mark.  When you say "make coalescing work" it sounds like
major overkill.

FITRIM should be able to lock a group of non-contiguous free ranges,
send them down to the block layer as a single pre-coalesced set, and
the block layer just needs to pass it on in a synchronous way.  Then
when that group of ranges is discarded, FITRIM releases the locks.

Every TRIM causes a cache flush anyway on the SSD, so the synchronous
aspect of the process should not be a problem.  (Maybe SCSI with thin
provisioning would see a performance hit?)

To my small brain, the only really complex part is sending something
like that into MDraid, because that one set of ranges might explode
into thousands of ranges and then have to be coalesced back down to a
more manageable number of ranges.

ie. with a simple raid 0, each range will need to be broken into a
bunch of stride sized ranges, then the contiguous strides on each
spindle coalesced back into larger ranges.

But if MDraid can handle discards now with one range, it should not be
that hard to teach it handle a group of ranges.

Greg


-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
CNN/TruTV Aired Forensic Imaging Demo -
   http://insession.blogs.cnn.com/2010/03/23/how-computer-evidence-gets-retrieved/

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
