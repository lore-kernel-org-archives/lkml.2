Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854Ab0HRXYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:24:21 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:54260 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424Ab0HRXYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:24:17 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net 49A88A9DD1
Message-Id: <E1OlrzM-0001lZ-0z@be1.7eggert.dyndns.org>
From: Bodo Eggert <7eggert@web.de>
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
To: Miklos Szeredi <miklos@szeredi.hu>, miklos@szeredi.hu, jack@suse.cz,
        agruen@suse.de, viro@zeniv.linux.org.uk, jblunck@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        linux-ext4@vger.kernel.org, Valerie Aurora <vaurora@redhat.com>
Reply-To: 7eggert@gmx.de
Date: Thu, 19 Aug 2010 01:24:07 +0200
References: <eVJmW-3Lf-15@gated-at.bofh.it> <eVJmW-3Lf-19@gated-at.bofh.it> <fdNs6-5F1-7@gated-at.bofh.it> <fdVfY-pv-23@gated-at.bofh.it> <fe6Ep-cD-13@gated-at.bofh.it> <fiCPo-73x-17@gated-at.bofh.it> <fiMc1-6ip-7@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, 17 Aug 2010, Valerie Aurora wrote:

>> >  - hard links to make sure a separate inode is not necessary for each
>> >    whiteout/fallthrough entry
>> 
>> The problem with hard links is that you run into hard link limits.  I
>> don't think we can do hard links for whiteouts and fallthrus.  Each
>> whiteout or fallthru will cost an inode if we implement them as
>> extended attributes.  This cost has to be balanced against the cost of
>> implementing them as dentries, which is mainly code complexity in
>> individual file systems.

Not knowing the details, I'd suggest to implement a generic function to
create an attributed inode and let the fs override it to create an
unlinked-file-dentry instead.

Benefit: All fs supporting extended attributes will be able to support
whiteout. If the fs has other means of supporting whiteout, they may fake
the attribute.

Possible problems:
- Having two ways of reporting a whiteout? Or can it be reported using a
  (static) fake inode?
- How do you un-whiteout while (not) having an overlaying fs?

> get_unlinked_inode() is a great idea.  But I feel that individual
> inodes for each fallthrough is excessive.  It'll make the first
> readdir() really really expensive and wastes a lot of disk and memory
> for no good reason.
> 
> Not sure how to fix the hard link limits problem though...

Do a hardlink if you can create a hard link, otherwise use a fresh inode
and use that for the next hardlink(s).


