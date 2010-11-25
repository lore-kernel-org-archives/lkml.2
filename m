Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab0KYElt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 23:41:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62590 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab0KYElr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 23:41:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o/j0PlO1ws5FFvvCxqGBtc6jAwbLxvstbJKOKY7OyWRUqhVBDytPRlQwaL9Z9M2lZB
         WDr4hzqeun4zCVzk437lK+gYlQwCQqVjxLlwcIygKG9L952e0VnPMNlJipFNS7cE2/Uq
         6P+wn2UHTmGf+NSbqYbtbsjaVoF0Yt4uDQv0Q=
MIME-Version: 1.0
In-Reply-To: <4CEDCE60.9050109@teksavvy.com>
References: <20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
 <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org>
 <1290100750.3041.72.camel@mulgrave.site> <alpine.LFD.2.00.1011181826550.15886@dhcp-lab-213.englab.brq.redhat.com>
 <1290168976.2570.45.camel@dolmen> <4CE68155.50705@teksavvy.com>
 <20101119140203.GC10039@thunk.org> <4CE69940.6040908@teksavvy.com>
 <alpine.LFD.2.00.1011191640320.3238@dhcp-lab-213.englab.brq.redhat.com>
 <20101119163013.GJ10039@thunk.org> <4CEDCE60.9050109@teksavvy.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Wed, 24 Nov 2010 23:41:26 -0500
Message-ID: <AANLkTimkGr=mpf6xbjvSFc9hZtf6f+UQ2F-N9aZxBsgb@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
To: Mark Lord <kernel@teksavvy.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Lukas Czerner <lczerner@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 9:48 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-11-19 11:30 AM, Ted Ts'o wrote:
>>
>> On Fri, Nov 19, 2010 at 04:44:33PM +0100, Lukas Czerner wrote:
>>>>
>>>> But, oddly, it _is_ the default for mke2fs -t ext4,
>>>> which really threw me for a loop recently.
>>>>
>>>> I though my system had locked up when suddenly everything
>>>> went dead for a very long time (many minutes) while installing a
>>>> new system.
>>
>> Yeah, the assumption was doing a single big discard (which is all
>> mke2fs is doing) should be fast.  At least on sanely implemented SSD's
>> (i.e., like the Intel X25-M) it should be, since all that should
>> require is a flash write to the global mapping table, declaring all of
>> the blocks as free.
>
> But mke2fs probably is NOT doing a "single big discard", because for SATA
> the
> TRIM command is limited to 64K sectors per range.. and the in-kernel TRIM
> code only ever does single ranges..
>
> So doing a discard over an entire drive-encompassing partition, say.. 100GB,
> will require 3000+ individual TRIM commands.  At (say) 200msecs each, that
> adds up to about ten minutes of execution time.  Or less if the drive is
> faster than that.
>
> Whereas.. grouping them into 64-ranges per trim, could reduce the execution
> time down to perhaps 1/50th of that, or in the range of 10-20 seconds
> instead.
>
> Cheers

Mark,

With recent kernels, this is supposed to work as you describe.  ie. 64
contiguous ranges per trim command.

If you see a significant speed difference between mke2fs and running
wiper.sh on that same filesystem immediately after formatting, then
their is likely a bug worth chasing.

Are you seeing an actual speed difference, or just assuming there is
one?  If mke2fs is slower than wiper.sh, what kernel are you testing
with?

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
