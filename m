Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1FBEwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 00:52:18 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61685 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1FBEwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 00:52:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SnpkAotJWRGU7beEH5im9m74cTlzAEqr7KH9hjsHV9faUq20avuJ2brRFLEWbMLu3k
         6ApdOZJNQ5B/s45y5s9wq5I38xI0ho70mcfHiUyGwLTYXCTU9s1Rs6TnzZWauOFys4PF
         lyYHqOsfcVtyyaVhnvA5S89wvLEf1baPsH+M4=
MIME-Version: 1.0
In-Reply-To: <1291740643-sup-2494@think>
References: <20101118130630.GJ6178@parisc-linux.org>
	<20101118134804.GN5618@dhcp231-156.rdu.redhat.com>
	<20101118141957.GK6178@parisc-linux.org>
	<20101118142918.GA18510@infradead.org>
	<1290100750.3041.72.camel@mulgrave.site>
	<4CE59C9E.6050902@teksavvy.com>
	<1290177488-sup-6540@think>
	<4CE68F80.7000607@teksavvy.com>
	<20101119145748.GB27919@infradead.org>
	<4CE695FF.20601@teksavvy.com>
	<20101207092749.GA26100@infradead.org>
	<1291740643-sup-2494@think>
Date: Thu, 2 Jun 2011 13:52:12 +0900
X-Google-Sender-Auth: aCHf_JH3_nsQM188xdD6LF8p5iQ
Message-ID: <BANLkTimkn7ZVAUJw6NfWVMECfe+C+82i+g@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
From: Kyungmin Park <kmpark@infradead.org>
To: Chris Mason <chris.mason@oracle.com>, Lukas Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Lord <kernel@teksavvy.com>,
        James Bottomley <james.bottomley@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, Josef Bacik <josef@redhat.com>,
        tytso <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        sandeen <sandeen@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 1:52 AM, Chris Mason <chris.mason@oracle.com> wrote:
> Excerpts from Christoph Hellwig's message of 2010-12-07 04:27:49 -0500:
>> On Fri, Nov 19, 2010 at 10:21:35AM -0500, Mark Lord wrote:
>> > >I really hate to rely on this third party hearsay (from all sides), and
>> > >have implement TRIM support in qemu now.  I'll soon install win7 and
>> > >will check out the TRIM patters myself.
>> >
>> > Excellent!
>>
>> I did a Windows 7 installation under qemu today, and the result is:
>
> Great, thanks for testing this.
>
>>
>>  - it TRIMs the whole device early during the installation
>>  - after that I see a constant stream of small trims during the
>>    installation.  It's using lots of non-contiguous ranges in a single
>>    TRIM command, with sizes down to 8 sectors (4k) for a single range.
>>  - after installation there's is some background-trimming going on
>>    even when doing no user interaction with the VM at all.

Hi Lukas,

Now FITRIM is based on user interaction. So how about to implement the
AUTO batched discard at kernel level?
Idea is same as windows, make a single thread and iterate the
superblocks and call the trim.

here's pseudo codes.

1. generate the trim thread.
2. iterate the superblocks by iterate_supers() at fs/super.c
3. check the queue which support the discard feature or not.
blk_queue_discard(q)
4. wait on events
5. call the sb->trim (need to re-introduce it)

The difficult things are how to define the events and how to trigger
the trim thread.
e.g., notified from block layer, called from filesystem and so on.

How do you think?

Thank you,
Kyungmin Park

>>  - removing files leads to an instant stream of TRIMs, again vectored
>>    and of all sizes down to 4k.  Note that the TRIMs are a lot more
>>    instant than even with btrfs and -o discard, which delays most
>>    TRIMs until doing a sync.
>
> Btrfs will do some small trims right when the block is freed, especially
> in fsync heavy workloads but this is a suboptimal thing I want to fix.
>
> The code tries to gather a whole transaction worth of trims and do them
> after the commit is done.
>
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
