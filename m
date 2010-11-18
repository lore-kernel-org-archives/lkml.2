Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654Ab0KRVo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:44:59 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:31910 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757205Ab0KRVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:44:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBACot5UxLd/sX/2dsb2JhbAAHgz3OSJB2gSKDNnMEhFqLEA
X-IronPort-AV: E=Sophos;i="4.59,218,1288584000"; 
   d="scan'208";a="82908397"
Message-ID: <4CE59E57.2090009@teksavvy.com>
Date: Thu, 18 Nov 2010 16:44:55 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: James Bottomley <James.Bottomley@suse.de>, Jeff Moyer <jmoyer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
        Josef Bacik <josef@redhat.com>, Lukas Czerner <lczerner@redhat.com>,
        tytso@mit.edu, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate super_operation
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com> <20101118130630.GJ6178@parisc-linux.org> <20101118134804.GN5618@dhcp231-156.rdu.redhat.com> <20101118141957.GK6178@parisc-linux.org> <20101118142918.GA18510@infradead.org> <1290100750.3041.72.camel@mulgrave.site> <x494obe4kd5.fsf@segfault.boston.devel.redhat.com> <1290102098.3041.77.camel@mulgrave.site> <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
In-Reply-To: <AANLkTim=SkqBehcCvEME7YVHk3S0dLdmBS8ooRF+-BuW@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-18 03:04 PM, Greg Freemyer wrote:
>
> 2) FITRIM doesn't leverage the fact the a TRIM command can handle
> multiple ranges per TRIM command payload.  I haven't seen any FITRIM
> vs. wiper.sh benchmarks, so I don't know what impact that has in
> practice.  Mark Lord thought that this lacking feature would cause
> FITRIM to take minutes or hours with some hardware.  Especially early
> generation SSDs.

If FITRIM is still issuing single-range-at-a-time TRIMs,
then I'd call that a BUG that needs fixing.  Doing TRIM like that
causes tons of unnecessary ERASE cycles, shortening the SSD lifetime.
It really needs to batch them into groups of (up to) 64 ranges at a time
(64 ranges fits into a single 512-byte parameter block).

> 3) wiper.sh does leverage the multiple ranges per TRIM command, but it
> really needs a new block layer interface that would allow it to push
> discard commands into the kernel via the block layer, not just down at
> the physical drive layer.  The interface should accept multiple ranges
> per invocation and trigger TRIM commands to the SSD that have have a
> multi-range discard payload.

I think FITRIM should be doing that, and it should work for more than just ext4.

Cheers!
