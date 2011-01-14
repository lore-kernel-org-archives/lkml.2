Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1ANQlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:41:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43598 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab1ANQlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:41:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xcPRVBMqSu1Juhzl7VtRLT4JLkpt9oeXBlCLUd1w79MELbw6lFkhc/nb85XpAytE5X
         4TViiVJfwE5ra/BhhbG04j8Oww9bNGUpGgXcS6vQZO9H4y8TvS8xpxZmA/yjCk2o5wyS
         pfbIIR4lCrPgVByjZ/YeEdmWhjgUK0qqWJsRc=
Date: Fri, 14 Jan 2011 17:35:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Karel Zak <kzak@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [dm-devel] linux-next - WARNING: at fs/block_dev.c:824
 bd_link_disk_holder+0x92/0x1ac()
Message-ID: <20110114163520.GD978@htj.dyndns.org>
References: <4D2EE156.1050006@redhat.com>
 <20110113122701.GG16523@nb.net.home>
 <20110113131216.GF30719@htj.dyndns.org>
 <20110113132637.GH16523@nb.net.home>
 <20110113133722.GG30719@htj.dyndns.org>
 <4D2F04FF.1070309@redhat.com>
 <20110113141107.GI30719@htj.dyndns.org>
 <4D2F0B6A.6010201@redhat.com>
 <AANLkTinJ68D6Yc-U-Q=ZfS9mqozj5qtHPtySZHOgjcgP@mail.gmail.com>
 <4D2F110E.3010401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2F110E.3010401@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 13, 2011 at 03:49:50PM +0100, Milan Broz wrote:
> So listing block device tree using ONE interface (sysfs) to check
> and display device tree for ALL subsystems seems to be good idea for
> me.  In this exactly defined case.
> 
> I am not saying that symlinks are perfect, just that generic
> interface here is not superfluous.

I'm not saying finding out the current owner is superflous.  That
actually is useful but what's implemented now doesn't satisfy that in
any generic manner.  It only works for md/dm and is designed in such
way that it can't be used out of that scope.

So, it's only useful for md/dm and for those two cases it tries to
show information which doesn't really belong there using an overly
complex mechanism.

Block device open allows _nesting_ by the claiming device.  It is
never meant to track different nested claimers and it shows in the
implementation and interface.  The holder tracking doesn't fit
anywhere.  It's a completely separate piece of logic which doesn't mix
with anything else in the block layer.

If you consider its only user - dm-table, the whole picture is
somewhat uglier.  dm-table tracks how it uses block devices but only
within a single target, so there are two separate layers of reference
counting going on.  This again is caused by the above stated design
inconsistency.

As block device only considers single claimer which doesn't have to be
another device, the owner naturally should have been something which
only points to single in-kernel entity in a way which doesn't require
link to another sysfs entry.

Karel pointed out that having different methods between md and dm
would be silly; however, that is a problem which should be solved
between dm and md and actually is a quite artificial problem (or
solution).  It only exists because dm and md do very similar things in
many cases.  A block device can be used by many more things which are
way out of the scope which can be represented in the sysfs hierarchy.
It simply is impossible to represent that relationship with symlinks
under block device sysfs hierarchy.

Thank you.

-- 
tejun
