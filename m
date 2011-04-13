Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab1DMVAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:00:45 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:60681 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932296Ab1DMVAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:00:44 -0400
X-AuditID: 12074425-b7c8cae00000429f-e8-4da60f084464
Subject: Re: CONFIG_EXT4_USE_FOR_EXT23:  rootfs shows as ext2 instead of ext4
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <4DA5AEBE.6060705@teksavvy.com>
Date: Wed, 13 Apr 2011 17:00:34 -0400
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <5A35771F-49B6-491E-B012-DBE68907E382@mit.edu>
References: <4DA48AF4.5080803@teksavvy.com> <20110413004938.GE3682@thunk.org> <4DA5AEBE.6060705@teksavvy.com>
To: Mark Lord <kernel@teksavvy.com>
X-Mailer: Apple Mail (2.1084)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42IRYrdT0eXgX+ZrcGWPgMWjNyIWM+fdYbO4
	vGsOmwOzx49PH1k9Pm+SC2CK4rJJSc3JLEst0rdL4Mp4dmw/U8FDvorTN5rZGhgPc3cxcnJI
	CJhITG+bxwxhi0lcuLeerYuRi0NIYB+jxJctU9khnA2MEk/ndjFDOCuYJGbNO8oO0iIs4Cux
	bE8/WDuvgKHE0k3tYHFmAS2JG/9eMoHYbAJKEnc+7WcBsTkFdCR2bGliBLFZBFQldh/YzgZR
	7y3Rf20HlC0vsf3tHKiZVhI3ZswGmyMkkCvxZOZesDkiAsoS+xb+BtrFAXS2rETTsowJjIKz
	kFwxC8kVs5BMXcDIvIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXQi83s0QvNaV0EyM4jF1UdzBO
	OKR0iFGAg1GJh/feqaW+QqyJZcWVuYcYJTmYlER5XfiW+QrxJeWnVGYkFmfEF5XmpBYfYpTg
	YFYS4T1RtcRXiDclsbIqtSgfJiXNwaIkzjtfUt1XSCA9sSQ1OzW1ILUIJivDwaEkwesFMlSw
	KDU9tSItM6cEIc3EwQkynAdo+H6QGt7igsTc4sx0iPwpRl2OG78O7mMUYsnLz0uVEueNBikS
	ACnKKM2DmwNLP68YxYHeEuYNBaniAaYuuEmvgJYwAS0Rv7cUZElJIkJKqoHRJebaHSMuFnYW
	TZlNq/3nytxf02jVrPbXaUU//9kHOuXx2kFZU1V2Heh5n7u5tGrhvxtdz3xUk2e8tflgkp1p
	7ur1L/T5stZpmeeS/bhU3lw+FbTm3cQbglVl8gk9fI3F92O1X/z7/8Jr0+8bXJEp7NeiWzhm
	FlyY573m+1eDvb33hBwmK/cpsRRnJBpqMRcVJwIAe0y9DhoDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 13, 2011, at 10:10 AM, Mark Lord wrote:

> 
> It is dangerous if it really has mounted an ext4 as ext2;
> the on-disk formats are not 100% compatible.
> 
> I don't know what it is doing, so it looks quite dangerous.
> Perhaps it really did mount as ext4 though, in which case not.


As the config option name: CONFIG_EXT4_USE_FOR_EXT23 
might mave suggested to you, what this means is that we are 
using the ext4 file system for ext2/3 file systems.   So yes, we are
using the ext4 file system driver when the ext2 file system is 
requested.   Since the kernel tries mounting the "ext2" file system
first, since we are using the ext4 file system driver, it succeeds,
and since it was mounted when the requested name was "ext2",
that is what is recorded in the mount table.

It's not dangerous at all.   Again, as you can tell if you were to actually
look at your .config carefully, the ext2 file system was not compiled
into your kernel at all.   Ext4 will only try masquerading as ext2 if
CONFIG_EXT2_FS is disabled.  So it couldn't have possibly been 
using ext2 code, if you thought about it for a second.

I can write up a patch which explicitly tests for feature flags that go
beyond ext2 as of a particular version, and if so, refuse the mount
when ext4 is masquerading as ext2, and do the same for ext3.   I
probably will do this to avoid user questions, when I have some 
spare time.

However, please note that this will have no actual effect on how
anything int he kernel will behave --- none ---- except for a one
character change in /proc/mounts: s/2/4/.   (This is because the
kernel will now try ext2, and fail, try ext3 and fail, and then succeed
when the exact same file system driver is used.  Oh, it might also
extend the boot time by a few milliseconds.)

Have I made it clear enough now to assuage your fears?

-- Ted


