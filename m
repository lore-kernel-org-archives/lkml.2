Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1HAHMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 03:12:22 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:45938 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751891Ab1HAHMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 03:12:15 -0400
Message-ID: <4E3652CE.1060000@coly.li>
Date: Mon, 01 Aug 2011 15:16:30 +0800
From: Coly Li <i@coly.li>
Reply-To: i@coly.li
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; zh-CN; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Andreas Dilger <aedilger@gmail.com>, Mingming Cao <cmm@us.ibm.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
References: <20110727082730.GG20655@tux1.beaverton.ibm.com> <EF1F2330-D8C4-427A-ABB9-D1E607D91A3D@gmail.com> <20110728165615.GI20655@tux1.beaverton.ibm.com> <20110728220735.GA27253@noexit.corp.google.com> <0E795C1D-AD1E-4CC4-9426-2B58D98B14DC@dilger.ca> <20110729131937.GB5910@noexit.corp.google.com> <4E33B1EC.9030004@gmail.com> <20110731070832.GA2848@noexit.corp.google.com> <4E35EAC9.6070707@gmail.com> <20110801045710.GB5716@noexit.corp.google.com> <20110801050435.GC5716@noexit.corp.google.com>
In-Reply-To: <20110801050435.GC5716@noexit.corp.google.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1390:box585.bluehost.com:colyli:coly.li} {sentby:smtp auth 114.251.86.0 authed with i@coly.li}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年08月01日 13:04, Joel Becker Wrote:
> On Sun, Jul 31, 2011 at 09:57:11PM -0700, Joel Becker wrote:
>> On Mon, Aug 01, 2011 at 07:52:41AM +0800, Coly Li wrote:
>>> On 2011年07月31日 15:08, Joel Becker Wrote:
>>>> On Sat, Jul 30, 2011 at 03:25:32PM +0800, Coly Li wrote:
>>>>> And in non-journal mode, there is not copy of any meta data block in jbd2, we need to be
>>>>> more careful in check summing, e.g. inode/block bitmap blocks...
>>>>
>>>> 	Sure, but you could use a trigger in journaled mode and then do
>>>> the checksums directly in the __ext4_handle_journal_dirty_*() functions
>>>> in non-journaled mode.  Sure, it would be a little more CPU time, but
>>>> the user picked "checksums + no journal" at mkfs time.
>>>>
>>>
>>> Yes, my idea was similar to you.
>>> One thing not clear to me is, in non-journal mode, how to make the page of bitmap block being stable. Because bits
>>> setting in Ext4 bitmap is non-locking, it might be possible that new bit setting after check sum is calculated.
>>
>> 	Every place that changes the bits will eventually call
>> ext4_journal_dirty(), which recalculates the checksum.  So there's no
>> danger of a set-bit-after-last-checksum.  But you will have to lock
>> around the checksum calculation in non-journaling mode.  JBD2 handles it
>> for journaling mode.
> 
> 	Wait, bitsetting in ext4 can't be non-locking.  Or are they
> crazily stomping on memory?  I sure see an assert_spin_locked() in
> mb_mark_used().
> 

Yes, you are right.
What I worried was inode bitmap, because last time (before uninit_bg was developed), inode bitmap was set by
ext4_set_bit_atomic(). Now I see inode bitmap is set by ext4_claim_inode() which locks the group internally.
And I confirm block bitmap is protected by ext4_{lock,unlock}_group(). So there is no risk for
set-bit-after-last-checksum.

Thanks for the clarification.

-- 
Coly Li
